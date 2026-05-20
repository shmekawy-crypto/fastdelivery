using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Banners : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillPlacesDropDownList();
            BindBannersGrid();
        }
    }

    private void FillPlacesDropDownList()
    {
        // جلب قائمة المطاعم النشطة لملء القائمة المنسدلة مباشرة
        string query = "SELECT id, Name FROM dbo.Places ORDER BY Name ASC";

        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                da.Fill(dt);
            }

            ddlPlaces.Items.Clear();
            ddlPlaces.Items.Add(new ListItem("--- اختر اسم المطعم لإضافته فوراً للقائمة ---", "0"));

            foreach (DataRow row in dt.Rows)
            {
                ddlPlaces.Items.Add(new ListItem(row["Name"].ToString(), row["id"].ToString()));
            }
        }
    }

    private void BindBannersGrid()
    {
        string query = "SELECT id, Title, PhotoUrl, ClickUrl, PagePlace, IsActive, SortOrder FROM dbo.Banners ORDER BY CreatedDate DESC";

        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                da.Fill(dt);
            }

            gvBanners.DataSource = dt;
            gvBanners.DataBind();

            lblCount.Text = dt.Rows.Count.ToString();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!fuphoto.HasFile)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "err", "alert('يرجى إرفاق ملف صورة الإعلان أولاً');", true);
            return;
        }

        try
        {
            string ext = Path.GetExtension(fuphoto.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "err", "alert('الملف المختار ليس صورة مدعومة. يرجى رفع ملف JPG, PNG أو WEBP');", true);
                return;
            }

            string fileName = Guid.NewGuid().ToString() + ext;
            string folderPath = Server.MapPath("~/uploads/banners/");

            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            fuphoto.SaveAs(folderPath + fileName);
            string dbPhotoUrl = "uploads/banners/" + fileName;

            int sortOrder = 0;
            int.TryParse(txtOrder.Text, out sortOrder);
            bool isActive = cbActive.Checked;
            string title = txtTitle.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    string sqlInsertBanner = @"INSERT INTO dbo.Banners (Title, PhotoUrl, ClickUrl, PagePlace, IsActive, SortOrder) 
                                               VALUES (@Title, @PhotoUrl, @ClickUrl, @PagePlace, @IsActive, @SortOrder);
                                               SELECT SCOPE_IDENTITY();";

                    int insertedBannerID = 0;
                    string customUrl = txtClickUrl.Text.Trim();

                    using (SqlCommand cmdBanner = new SqlCommand(sqlInsertBanner, conn, trans))
                    {
                        cmdBanner.Parameters.AddWithValue("@Title", title);
                        cmdBanner.Parameters.AddWithValue("@PhotoUrl", dbPhotoUrl);
                        cmdBanner.Parameters.AddWithValue("@ClickUrl", string.IsNullOrEmpty(customUrl) ? (object)DBNull.Value : customUrl);
                        cmdBanner.Parameters.AddWithValue("@PagePlace", ddlPagePlace.SelectedValue);
                        cmdBanner.Parameters.AddWithValue("@IsActive", isActive);
                        cmdBanner.Parameters.AddWithValue("@SortOrder", sortOrder);

                        insertedBannerID = Convert.ToInt32(cmdBanner.ExecuteScalar());
                    }

                    // قراءة المطاعم المضافة من الـ HiddenField المرتبط بالجافا سكريبت
                    string rawPlaceIDs = hfSelectedPlaceIDs.Value.Trim();
                    if (!string.IsNullOrEmpty(rawPlaceIDs))
                    {
                        string[] placeIDs = rawPlaceIDs.Split(',');
                        string sqlInsertRelation = "INSERT INTO dbo.Banner_Places (BannerID, PlaceID) VALUES (@BannerID, @PlaceID)";

                        foreach (string pid in placeIDs)
                        {
                            if (!string.IsNullOrEmpty(pid))
                            {
                                using (SqlCommand cmdRelation = new SqlCommand(sqlInsertRelation, conn, trans))
                                {
                                    cmdRelation.Parameters.AddWithValue("@BannerID", insertedBannerID);
                                    cmdRelation.Parameters.AddWithValue("@PlaceID", Convert.ToInt32(pid));
                                    cmdRelation.ExecuteNonQuery();
                                }
                            }
                        }

                        // توجيه تلقائي لصفحة العروض المجمعة بناء على معرف العرض
                        string sqlUpdateUrl = "UPDATE dbo.Banners SET ClickUrl = @GeneratedUrl WHERE id = @BannerID";
                        using (SqlCommand cmdUpdateUrl = new SqlCommand(sqlUpdateUrl, conn, trans))
                        {
                            cmdUpdateUrl.Parameters.AddWithValue("@GeneratedUrl", "PromoPlaces.aspx?bannerId=" + insertedBannerID);
                            cmdUpdateUrl.Parameters.AddWithValue("@BannerID", insertedBannerID);
                            cmdUpdateUrl.ExecuteNonQuery();
                        }
                    }

                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    throw ex;
                }
            }

            ClearFormInputs();
            BindBannersGrid();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "suc", "alert('تم حفظ إعلان العرض وتسكين المطاعم المحددة بنجاح');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "err", "alert('حدث خطأ أثناء معالجة الإعلان: " + ex.Message.Replace("'", "") + "');", true);
        }
    }

    private void ClearFormInputs()
    {
        txtTitle.Text = "";
        txtClickUrl.Text = "";
        txtOrder.Text = "0";
        cbActive.Checked = true;
        hfSelectedPlaceIDs.Value = "";
        ddlPlaces.SelectedIndex = 0;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "clearTags", "selectedPlaces = []; renderPlaceTags();", true);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearFormInputs();
    }

    protected void gvBanners_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvBanners.PageIndex = e.NewPageIndex;
        BindBannersGrid();
    }

    protected void gvBanners_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteBanner")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            string deleteQuery = "DELETE FROM dbo.Banners WHERE id = @ID";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
            {
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            BindBannersGrid();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "del", "alert('تم حذف الإعلان المحدد بنجاح من المنظومة');", true);
        }
    }

    protected void GridView_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if (gv.Rows.Count > 0)
        {
            gv.UseAccessibleHeader = true;
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}