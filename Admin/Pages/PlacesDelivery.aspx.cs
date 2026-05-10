using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Admin_Pages_PlacesDelivery : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
    int placeId;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!int.TryParse(Request.QueryString["place_id"], out placeId))
        {
            lblMessage.Text = "رقم المطعم غير موجود أو غير صحيح!";
            return;
        }

        if (!IsPostBack)
        {
            hfPlaceId.Value = placeId.ToString();
            LoadDays();
            LoadGrid();
        }
    }

    void LoadDays()
    {
        ddlDays.Items.Clear();
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT Id, DayName FROM DaysOfWeek ORDER BY Id", con);
            con.Open();
            var dr = cmd.ExecuteReader();
            ddlDays.DataSource = dr;
            ddlDays.DataTextField = "DayName";
            ddlDays.DataValueField = "Id";
            ddlDays.DataBind();
            ddlDays.Items.Insert(0, new ListItem("-- اختر اليوم --", ""));
        }
    }

    void LoadGrid()
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand(@"
                SELECT s.Id, s.DayId, d.DayName AS DayName, s.StartTime, s.EndTime, s.IsActive
                FROM PlacesDeliverySchedule s
                INNER JOIN DaysOfWeek d ON s.DayId = d.Id
                WHERE s.PlacesId = @PlacesId
                ORDER BY d.Id", con);
            cmd.Parameters.AddWithValue("@PlacesId", placeId);
            con.Open();
            gvSchedules.DataSource = cmd.ExecuteReader();
            gvSchedules.DataBind();
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";

        if (string.IsNullOrEmpty(ddlDays.SelectedValue))
        {
            lblMessage.Text = "من فضلك اختر اليوم.";
            return;
        }
        if (string.IsNullOrEmpty(txtStartTime.Text))
        {
            lblMessage.Text = "من فضلك أدخل وقت البداية.";
            return;
        }
        if (string.IsNullOrEmpty(txtEndTime.Text))
        {
            lblMessage.Text = "من فضلك أدخل وقت النهاية.";
            return;
        }

        TimeSpan startTime = TimeSpan.Parse(txtStartTime.Text);
        TimeSpan endTime = TimeSpan.Parse(txtEndTime.Text);

        if (startTime >= endTime)
        {
            lblMessage.Text = "وقت البداية يجب أن يكون أقل من وقت النهاية.";
            return;
        }

        bool isActive = chkIsActiveAdd.Checked;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand(@"
            INSERT INTO PlacesDeliverySchedule (PlacesId, DayId, StartTime, EndTime, IsActive)
            VALUES (@PlacesId, @DayId, @StartTime, @EndTime, @IsActive)", con);
            cmd.Parameters.AddWithValue("@PlacesId", placeId);
            cmd.Parameters.AddWithValue("@DayId", ddlDays.SelectedValue);
            cmd.Parameters.AddWithValue("@StartTime", startTime);
            cmd.Parameters.AddWithValue("@EndTime", endTime);
            cmd.Parameters.AddWithValue("@IsActive", isActive);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        lblMessage.CssClass = "text-success";
        lblMessage.Text = "تمت الإضافة بنجاح!";
        LoadGrid();
    }


    protected void gvSchedules_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvSchedules.EditIndex = e.NewEditIndex;
        LoadGrid();

        DropDownList ddlEditDay = (DropDownList)gvSchedules.Rows[e.NewEditIndex].FindControl("ddlEditDay");
        if (ddlEditDay != null)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT Id, DayName FROM DaysOfWeek ORDER BY Id", con);
                con.Open();
                ddlEditDay.DataSource = cmd.ExecuteReader();
                ddlEditDay.DataTextField = "DayName";
                ddlEditDay.DataValueField = "Id";
                ddlEditDay.DataBind();
            }

            string dayId = gvSchedules.DataKeys[e.NewEditIndex].Values["DayId"].ToString();
            ddlEditDay.SelectedValue = dayId;
        }
    }

    protected void gvSchedules_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvSchedules.EditIndex = -1;
        LoadGrid();
    }

    protected void gvSchedules_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = Convert.ToInt32(gvSchedules.DataKeys[e.RowIndex].Value);

        DropDownList ddlEditDay = (DropDownList)gvSchedules.Rows[e.RowIndex].FindControl("ddlEditDay");
        TextBox txtEditStart = (TextBox)gvSchedules.Rows[e.RowIndex].FindControl("txtEditStart");
        TextBox txtEditEnd = (TextBox)gvSchedules.Rows[e.RowIndex].FindControl("txtEditEnd");
        CheckBox chkActive = (CheckBox)gvSchedules.Rows[e.RowIndex].FindControl("chkActiveEdit");

        if (ddlEditDay == null || txtEditStart == null || txtEditEnd == null || chkActive == null)
        {
            lblMessage.Text = "حدث خطأ أثناء التحديث!";
            return;
        }

        int dayId = int.Parse(ddlEditDay.SelectedValue);
        TimeSpan start = TimeSpan.Parse(txtEditStart.Text);
        TimeSpan end = TimeSpan.Parse(txtEditEnd.Text);
        bool isActive = chkActive.Checked;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand(@"
                UPDATE PlacesDeliverySchedule
                SET DayId=@DayId, StartTime=@StartTime, EndTime=@EndTime, IsActive=@IsActive
                WHERE Id=@Id", con);
            cmd.Parameters.AddWithValue("@DayId", dayId);
            cmd.Parameters.AddWithValue("@StartTime", start);
            cmd.Parameters.AddWithValue("@EndTime", end);
            cmd.Parameters.AddWithValue("@IsActive", isActive);
            cmd.Parameters.AddWithValue("@Id", id);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        lblMessage.CssClass = "text-success";
        lblMessage.Text = "تم التعديل بنجاح!";
        gvSchedules.EditIndex = -1;
        LoadGrid();
    }

    protected void gvSchedules_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = Convert.ToInt32(gvSchedules.DataKeys[e.RowIndex].Value);

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM PlacesDeliverySchedule WHERE Id=@Id", con);
            cmd.Parameters.AddWithValue("@Id", id);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        lblMessage.CssClass = "text-success";
        lblMessage.Text = "تم الحذف بنجاح!";
        LoadGrid();
    }
}
