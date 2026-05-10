using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Admin_Pages_Sizes : System.Web.UI.Page
{
    // الحصول على سلسلة الاتصال من ملف web.config
    string strConn = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        using (SqlConnection conn = new SqlConnection(strConn))
        {
            // بناء جملة الـ SQL مع البحث
            string sql = "SELECT * FROM Sizes";
            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                sql += " WHERE Name LIKE @search OR NameEn LIKE @search OR NameRu LIKE @search";
            }
            sql += " ORDER BY id";

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                cmd.Parameters.AddWithValue("@search", "%" + txtSearch.Text + "%");
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvSizes.DataSource = dt;
            gvSizes.DataBind();
            lblCount.Text = dt.Rows.Count.ToString();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        using (SqlConnection conn = new SqlConnection(strConn))
        {
            string sql = "";
            if (btnSave.Text == "حفظ")
            {
                sql = "INSERT INTO Sizes (Name, NameEn, NameRu) VALUES (@Name, @NameEn, @NameRu)";
            }
            else
            {
                sql = "UPDATE Sizes SET Name=@Name, NameEn=@NameEn, NameRu=@NameRu WHERE id=@id";
            }

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@NameEn", txtNameEn.Text.Trim());
            cmd.Parameters.AddWithValue("@NameRu", txtNameRu.Text.Trim());

            if (btnSave.Text == "تعديل")
            {
                cmd.Parameters.AddWithValue("@id", ViewState["id"].ToString());
            }

            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                BindGrid();
                ClearData();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('تمت العملية بنجاح')", true);
            }
            catch (SqlException ex)
            {
                // معالجة خطأ تكرار الاسم مثلاً
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "error", string.Format("alert('حدث خطأ: {0}');", ex.Message.Replace("'", "\\'")), true);
            }
        }
    }

    protected void gvSizes_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = int.Parse(e.CommandArgument.ToString());

        if (e.CommandName == "EditSize")
        {
            ViewState["id"] = id;
            GetSizeDetails(id);
        }
        else if (e.CommandName == "DeleteSize")
        {
            DeleteSize(id);
        }
    }

    private void GetSizeDetails(int id)
    {
        using (SqlConnection conn = new SqlConnection(strConn))
        {
            string sql = "SELECT * FROM Sizes WHERE id = @id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                txtName.Text = dr["Name"].ToString();
                txtNameEn.Text = dr["NameEn"].ToString();
                txtNameRu.Text = dr["NameRu"].ToString();
                btnSave.Text = "تعديل";
            }
        }
    }

    private void DeleteSize(int id)
    {
        using (SqlConnection conn = new SqlConnection(strConn))
        {
            string sql = "DELETE FROM Sizes WHERE id = @id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                BindGrid();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('تم الحذف بنجاح')", true);
            }
            catch
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "error", "alert('لا يمكن الحذف لارتباطه ببيانات أخرى')", true);
            }
        }
    }

    protected void gvSizes_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvSizes.PageIndex = e.NewPageIndex;
        BindGrid();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearData();
    }

    private void ClearData()
    {
        txtName.Text = txtNameEn.Text = txtNameRu.Text = txtSearch.Text = "";
        btnSave.Text = "حفظ";
        txtName.Focus();
    }
}