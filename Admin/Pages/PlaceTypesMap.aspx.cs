using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Data;

public partial class Admin_Pages_PlaceTypesMap : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
    int placeId;

    protected void Page_Load(object sender, EventArgs e)
    {
        // بنجيب الـ id اللي مبعوت في الـ QueryString
        if (!int.TryParse(Request.QueryString["place_id"], out placeId))
        {
            lblMessage.Text = "رقم المكان غير صحيح!";
            return;
        }

        if (!IsPostBack)
        {
            hfPlaceId.Value = placeId.ToString();
            LoadPlaceInfo();
            LoadAllTypes();
            LoadGrid();
        }
    }

    void LoadPlaceInfo()
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT Name FROM Places WHERE ID = @ID", con);
            cmd.Parameters.AddWithValue("@ID", placeId);
            con.Open();
            object name = cmd.ExecuteScalar();
            if (name != null) lblPlaceName.Text = name.ToString();
        }
    }

    void LoadAllTypes()
    {
        ddlTypes.Items.Clear();
        using (SqlConnection con = new SqlConnection(connStr))
        {
            // جدول الأنواع الأساسي عندك
            SqlCommand cmd = new SqlCommand("SELECT Id, TypeNameAr FROM placetypes WHERE Active = 1 ORDER BY TypeNameAr", con);
            con.Open();
            ddlTypes.DataSource = cmd.ExecuteReader();
            ddlTypes.DataTextField = "TypeNameAr";
            ddlTypes.DataValueField = "Id";
            ddlTypes.DataBind();
            ddlTypes.Items.Insert(0, new ListItem("-- اختر الفئة --", ""));
        }
    }

    void LoadGrid()
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            // Join بين جدول الوسيط وجدول الأنواع عشان نجيب الاسم
            SqlCommand cmd = new SqlCommand(@"
                SELECT m.Id AS MapID, t.TypeNameAr AS TypeName
                FROM Place_Type_Map m
                INNER JOIN placetypes t ON m.TypeID = t.Id
                WHERE m.PlaceID = @PlaceID", con);
            cmd.Parameters.AddWithValue("@PlaceID", placeId);
            con.Open();
            gvMap.DataSource = cmd.ExecuteReader();
            gvMap.DataBind();
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";

        if (string.IsNullOrEmpty(ddlTypes.SelectedValue))
        {
            lblMessage.Text = "من فضلك اختر الفئة.";
            return;
        }

        using (SqlConnection con = new SqlConnection(connStr))
        {
            // تشيك الأول إنها مش موجودة عشان ميتكررش نفس النوع لنفس المكان
            SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Place_Type_Map WHERE PlaceID=@p AND TypeID=@t", con);
            checkCmd.Parameters.AddWithValue("@p", placeId);
            checkCmd.Parameters.AddWithValue("@t", ddlTypes.SelectedValue);
            con.Open();
            int count = (int)checkCmd.ExecuteScalar();

            if (count > 0)
            {
                lblMessage.Text = "هذه الفئة مضافة بالفعل لهذا المكان.";
                return;
            }

            // إضافة الربط
            SqlCommand cmd = new SqlCommand(@"
                INSERT INTO Place_Type_Map (PlaceID, TypeID)
                VALUES (@PlaceID, @TypeID)", con);
            cmd.Parameters.AddWithValue("@PlaceID", placeId);
            cmd.Parameters.AddWithValue("@TypeID", ddlTypes.SelectedValue);
            cmd.ExecuteNonQuery();
        }

        lblMessage.CssClass = "text-success";
        lblMessage.Text = "تمت إضافة الفئة بنجاح!";
        LoadGrid();
    }

    protected void gvMap_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int mapId = Convert.ToInt32(gvMap.DataKeys[e.RowIndex].Value);

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM Place_Type_Map WHERE Id=@Id", con);
            cmd.Parameters.AddWithValue("@Id", mapId);
            con.Open();
            cmd.ExecuteNonQuery();
        }

        lblMessage.CssClass = "text-success";
        lblMessage.Text = "تم حذف الربط بنجاح!";
        LoadGrid();
    }
}