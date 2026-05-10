using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

public partial class Admin_Pages_PlaceTypes : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPlaceTypes();
        }
    }

    void BindPlaceTypes()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = "SELECT * FROM PlaceTypes ORDER BY POrder ASC";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            gvPlaceTypes.DataSource = dt;
            gvPlaceTypes.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string photoPath = hfTypePhotoPath.Value;

        if (fuTypePhoto.HasFile)
        {
            string ext = Path.GetExtension(fuTypePhoto.FileName).ToLower();
            string fileName = Guid.NewGuid().ToString() + ext;
            string savePath = Server.MapPath("~/ar/images/types/") + fileName;

            // تأكد من وجود المجلد أولاً
            string dir = Server.MapPath("~/ar/images/types/");
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

            fuTypePhoto.SaveAs(savePath);
            photoPath = "images/types/" + fileName;
        }

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = "";
            if (ViewState["EditID"] == null)
                sql = "INSERT INTO PlaceTypes (TypeNameAr, TypeNameEn, TypeNameRu, TypeImage, Active, POrder) VALUES (@Ar, @En, @Ru, @Img, @Active, @Order)";
            else
                sql = "UPDATE PlaceTypes SET TypeNameAr=@Ar, TypeNameEn=@En, TypeNameRu=@Ru, TypeImage=@Img, Active=@Active, POrder=@Order WHERE id=@ID";

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Ar", txtNameAr.Text.Trim());
            cmd.Parameters.AddWithValue("@En", txtNameEn.Text.Trim());
            cmd.Parameters.AddWithValue("@Ru", txtNameRu.Text.Trim());
            cmd.Parameters.AddWithValue("@Img", (object)photoPath ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Active", chkActive.Checked);
            cmd.Parameters.AddWithValue("@Order", string.IsNullOrEmpty(txtOrder.Text) ? 0 : int.Parse(txtOrder.Text));

            if (ViewState["EditID"] != null)
                cmd.Parameters.AddWithValue("@ID", ViewState["EditID"]);

            conn.Open();
            cmd.ExecuteNonQuery();
        }

        ClearForm();
        BindPlaceTypes();
    }

    protected void gvPlaceTypes_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditType")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM PlaceTypes WHERE id=@ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtNameAr.Text = dr["TypeNameAr"].ToString();
                    txtNameEn.Text = dr["TypeNameEn"].ToString();
                    txtNameRu.Text = dr["TypeNameRu"].ToString();
                    txtOrder.Text = dr["POrder"].ToString();
                    chkActive.Checked = (bool)dr["Active"];
                    hfTypePhotoPath.Value = dr["TypeImage"].ToString();
                    ViewState["EditID"] = id;
                    btnSave.Text = "تعديل";
                }
            }
        }
        else if (e.CommandName == "DeleteType")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM PlaceTypes WHERE id=@ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            BindPlaceTypes();
        }
    }

    void ClearForm()
    {
        txtNameAr.Text = txtNameEn.Text = txtNameRu.Text = txtOrder.Text = "";
        hfTypePhotoPath.Value = "";
        chkActive.Checked = true;
        btnSave.Text = "حفظ";
        ViewState["EditID"] = null;
    }

    protected void gvPlaceTypes_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvPlaceTypes.PageIndex = e.NewPageIndex;
        BindPlaceTypes();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
    }
}