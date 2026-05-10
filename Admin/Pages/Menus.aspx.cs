using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.IO;

public partial class Admin_Pages_Menus : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategories();
            BindMenus();
        }
    }

    // جلب الفئات لقائمة Dropdown
    void BindCategories()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT ID, Name FROM Categories ORDER BY Name", conn);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            cbCategory.DataSource = dr;
            cbCategory.DataTextField = "Name";
            cbCategory.DataValueField = "ID";
            cbCategory.DataBind();
            dr.Close();

            cbCategory.Items.Insert(0, new ListItem("..اختر التصنيف..", "0"));
        }
    }

    // جلب وعرض القوائم في GridView
    void BindMenus(string search = "")
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = @"
                SELECT m.id, m.Name, m.NameEn,m.NameRu, m.Description,m.DescriptionEn,m.DescriptionRu, m.CreatedAt, c.Name AS CategoryName
FROM  dbo.Menus AS m INNER JOIN
               dbo.Categories AS c ON m.Categories_id = c.id";

            if (!string.IsNullOrEmpty(search))
                sql += " WHERE m.Name LIKE @Search OR m.NameEn LIKE @Search";

            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            if (!string.IsNullOrEmpty(search))
                da.SelectCommand.Parameters.AddWithValue("@Search", "%" + search + "%");

            DataTable dt = new DataTable();
            da.Fill(dt);
            gvMenus.DataSource = dt;
            gvMenus.DataBind();
            lblCount.Text = dt.Rows.Count.ToString();
        }
    }

    // زر الحفظ/التعديل
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string photoPath = hfPhotoPath.Value;

        // رفع الصورة إذا تم اختيارها
        if (fuPhoto.HasFile)
        {
            string ext = Path.GetExtension(fuPhoto.FileName).ToLower();
            if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif")
            {
                string fileName = Guid.NewGuid().ToString() + ext;
                string savePath = Server.MapPath("~/ar/images/menu/") + fileName;
                fuPhoto.SaveAs(savePath);
                photoPath = "images/menu/" + fileName;
            }
        }
        string name = txtName.Text.Trim();
        string nameEn = txtNameEn.Text.Trim();
        string nameRu = txtNameRu.Text.Trim();

        string desc = txtDescription.Text.Trim();
        string descEn = txtDescriptionEn.Text.Trim();
        string descRu = txtDescriptionRu.Text.Trim();
        int categoryId = int.Parse(cbCategory.SelectedValue);

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(nameEn) || categoryId == 0) return;

        if (ViewState["EditID"] != null) // تعديل
        {
            int id = (int)ViewState["EditID"];
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "UPDATE Menus SET Name=@Name, NameEn=@NameEn,NameRu=@NameRu, Description=@Desc, DescriptionEn=@DescEn,DescriptionRu=@DescRu, Categories_id=@CategoryID,PhotoUrl=@Photo WHERE ID=@ID", conn);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@NameEn", nameEn);
                cmd.Parameters.AddWithValue("@NameRu", nameRu);
                cmd.Parameters.AddWithValue("@Desc", string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc);
                cmd.Parameters.AddWithValue("@DescEn", string.IsNullOrEmpty(descEn) ? (object)DBNull.Value : descEn);
                cmd.Parameters.AddWithValue("@DescRu", string.IsNullOrEmpty(descRu) ? (object)DBNull.Value : descRu);
                cmd.Parameters.AddWithValue("@Photo", string.IsNullOrEmpty(photoPath) ? (object)DBNull.Value : photoPath);
                cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            btnSave.Text = "حفظ";
            ViewState["EditID"] = null;
        }
        else // إضافة جديد
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Menus (Name, NameEn,NameRu, Description,DescriptionEn ,DescriptionRu , Categories_id, CreatedAt,PhotoUrl) VALUES (@Name, @NameEn,@NameRu, @Desc,@DescEn,@DescRu, @CategoryID, @CreatedAt,@Photo)", conn);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@NameEn", nameEn);
                cmd.Parameters.AddWithValue("@NameRu", nameRu);
                cmd.Parameters.AddWithValue("@Desc", string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc);
                cmd.Parameters.AddWithValue("@DescEn", string.IsNullOrEmpty(descEn) ? (object)DBNull.Value : descEn);
                cmd.Parameters.AddWithValue("@DescRu", string.IsNullOrEmpty(descRu) ? (object)DBNull.Value : descRu);
                cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                cmd.Parameters.AddWithValue("@Photo", string.IsNullOrEmpty(photoPath) ? (object)DBNull.Value : photoPath);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        ClearForm();
        BindMenus(txtSearch.Text.Trim());
    }

    // زر إلغاء
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        btnSave.Text = "حفظ";
        ViewState["EditID"] = null;
    }

    // زر البحث
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindMenus(txtSearch.Text.Trim());
    }

    // تغيير الصفحة في GridView
    protected void gvMenus_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvMenus.PageIndex = e.NewPageIndex;
        BindMenus(txtSearch.Text.Trim());
    }

    // التعامل مع أوامر GridView (حذف / تعديل)
    protected void gvMenus_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "DeleteMenu")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Menus WHERE ID=@ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            BindMenus(txtSearch.Text.Trim());
        }
        else if (e.CommandName == "EditMenu")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Menus WHERE ID=@ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtName.Text = dr["Name"].ToString();
                    txtNameEn.Text = dr["NameEn"].ToString();
                    txtNameRu.Text = dr["NameRu"].ToString();
                    txtDescription.Text = dr["Description"].ToString();
                    txtDescriptionEn.Text = dr["DescriptionEn"].ToString();
                    txtDescriptionRu.Text = dr["DescriptionRu"].ToString();
                    cbCategory.SelectedValue = dr["Categories_id"].ToString();
                    ViewState["EditID"] = id;
                    btnSave.Text = "تعديل";
                }
                dr.Close();
            }
        }
    }

    // مسح الحقول
    void ClearForm()
    {
        txtName.Text = "";
        txtNameEn.Text = "";
        txtNameRu.Text = "";

        txtDescription.Text = "";
        txtDescriptionEn.Text = "";
        txtDescriptionRu.Text = "";

        cbCategory.SelectedValue = "0";
        ViewState["EditID"] = null;
    }
}
