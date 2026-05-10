using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

public partial class DeliveryZones2 : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
    int placeID;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!int.TryParse(Request.QueryString["PlacesID"], out placeID))
        {
            Response.Write("PlacesID مفقود في الرابط!");
            Response.End();
        }

        if (!IsPostBack)
        {
            LoadGovernments();
            LoadZones();
        }
    }

    void LoadGovernments()
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT id, Name FROM Gov", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ddlGov.DataSource = dt;
            ddlGov.DataTextField = "Name";
            ddlGov.DataValueField = "id";
            ddlGov.DataBind();
            ddlGov.Items.Insert(0, new ListItem("-- اختر المحافظة --", ""));
        }
    }

    void LoadAreas(int govID, DropDownList ddl = null)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT id, Name FROM Areas WHERE Gov_id=@Gov_id", con);
            da.SelectCommand.Parameters.AddWithValue("@Gov_id", govID);
            DataTable dt = new DataTable();
            da.Fill(dt);
            if (ddl != null)
            {
                ddl.DataSource = dt;
                ddl.DataTextField = "Name";
                ddl.DataValueField = "id";
                ddl.DataBind();
            }
            else
            {
                ddlArea.DataSource = dt;
                ddlArea.DataTextField = "Name";
                ddlArea.DataValueField = "id";
                ddlArea.DataBind();
            }
        }
    }

    protected void ddlGov_SelectedIndexChanged(object sender, EventArgs e)
    {
        int govID = 0;
        if (int.TryParse(ddlGov.SelectedValue, out  govID))
            LoadAreas(govID);
        else
            ddlArea.Items.Clear();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(ddlArea.SelectedValue) || string.IsNullOrEmpty(txtCost.Text))
            return;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "INSERT INTO DeliveryZones (PlacesID, Areas_id, DeliveryCost,DeliveredTime) VALUES (@PlacesID, @Areas_id, @DeliveryCost ,@DeliveredTime)";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@PlacesID", placeID);
            cmd.Parameters.AddWithValue("@Areas_id", ddlArea.SelectedValue);
            cmd.Parameters.AddWithValue("@DeliveryCost", txtCost.Text);
            cmd.Parameters.AddWithValue("@DeliveredTime", txtDeliveredTime.Text);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        txtCost.Text = "";
        LoadZones();
    }

    void LoadZones()
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = @"SELECT dz.ZoneID, g.Name AS GovName, a.Name AS AreaName, dz.DeliveryCost,dz.DeliveredTime,dz.Areas_id
                           FROM DeliveryZones dz
                           INNER JOIN Areas a ON dz.Areas_id = a.id
                           INNER JOIN Gov g ON a.Gov_id = g.id
                           WHERE dz.PlacesID=@PlacesID";
            SqlDataAdapter da = new SqlDataAdapter(sql, con);
            da.SelectCommand.Parameters.AddWithValue("@PlacesID", placeID);
            DataTable dt = new DataTable();
            da.Fill(dt);
            gvZones.DataSource = dt;
            gvZones.DataBind();
        }
    }

    protected void gvZones_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvZones.EditIndex = e.NewEditIndex;
        LoadZones();

        DropDownList ddlGovEdit = (DropDownList)gvZones.Rows[e.NewEditIndex].FindControl("ddlEditGov");
        DropDownList ddlAreaEdit = (DropDownList)gvZones.Rows[e.NewEditIndex].FindControl("ddlEditArea");
        

        int currentAreaID = Convert.ToInt32(gvZones.DataKeys[e.NewEditIndex].Values["Areas_id"]);
        int currentGovID;
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT Gov_id FROM Areas WHERE id=@id", con);
            cmd.Parameters.AddWithValue("@id", currentAreaID);
            con.Open();
            currentGovID = Convert.ToInt32(cmd.ExecuteScalar());
        }

        // تحميل المحافظات
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT id, Name FROM Gov", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ddlGovEdit.DataSource = dt;
            ddlGovEdit.DataTextField = "Name";
            ddlGovEdit.DataValueField = "id";
            ddlGovEdit.DataBind();
            ddlGovEdit.SelectedValue = currentGovID.ToString();
        }

        // تحميل المناطق التابعة للمحافظة الحالية
        LoadAreas(currentGovID, ddlAreaEdit);
        ddlAreaEdit.SelectedValue = currentAreaID.ToString();
    }

    protected void ddlEditGov_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddlGov = (DropDownList)sender;
        GridViewRow row = (GridViewRow)ddlGov.NamingContainer;
        DropDownList ddlArea = (DropDownList)row.FindControl("ddlEditArea");

        int govID = int.Parse(ddlGov.SelectedValue);
        LoadAreas(govID, ddlArea);
    }

    protected void gvZones_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int zoneID = Convert.ToInt32(gvZones.DataKeys[e.RowIndex].Value);
        DropDownList ddlAreaEdit = (DropDownList)gvZones.Rows[e.RowIndex].FindControl("ddlEditArea");
        TextBox txtEditCost = (TextBox)gvZones.Rows[e.RowIndex].FindControl("txtEditCost");
        TextBox txtEditTime = (TextBox)gvZones.Rows[e.RowIndex].FindControl("txtEditTime");
        int selectedAreaID = int.Parse(ddlAreaEdit.SelectedValue);
        decimal deliveryCost = decimal.Parse(txtEditCost.Text);
        int deliveryTime = int.Parse(txtEditTime.Text);
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "UPDATE DeliveryZones SET Areas_id=@Areas_id, DeliveryCost=@DeliveryCost , DeliveredTime=@DeliveredTime WHERE ZoneID=@ZoneID";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@Areas_id", selectedAreaID);
            cmd.Parameters.AddWithValue("@DeliveryCost", deliveryCost);
            cmd.Parameters.AddWithValue("@DeliveredTime", deliveryTime);
            cmd.Parameters.AddWithValue("@ZoneID", zoneID);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        gvZones.EditIndex = -1;
        LoadZones();
    }

    protected void gvZones_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvZones.EditIndex = -1;
        LoadZones();
    }

    protected void gvZones_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int zoneID = Convert.ToInt32(gvZones.DataKeys[e.RowIndex].Value);
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "DELETE FROM DeliveryZones WHERE ZoneID=@ZoneID";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@ZoneID", zoneID);
            con.Open();
            cmd.ExecuteNonQuery();
        }
        LoadZones();
    }
}
