using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Places_MasterPages_RestaurantBanners : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // حماية أمنية حسابية: التأكد التام من أن اليوزر مسجل دخول والـ Session الخاص بالـ PlaceID نشط ومعرف
        if (Session["PlaceID"] == null)
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            int currentPlaceID = Convert.ToInt32(Session["PlaceID"]);
            FillMenuSizesList(currentPlaceID);
            BindRestaurantBannersGrid(currentPlaceID);
        }
    }

    private void FillMenuSizesList(int placeId)
    {
        // تم التعديل الحاسم هنا لجلب اسم الصنف mi.Name من جدول الأصناف الرئيسي مع إرفاق السعر والـ SizeID بدقة
        string query = @"
            SELECT mzs.id AS SizeID, mi.Name + ' - السعر: ' + CAST(mzs.Price AS NVARCHAR(20)) + ' ج.م' AS FullItemName
            FROM dbo.MenuItems_Sizes mzs
            INNER JOIN dbo.MenuItems mi ON mzs.MenuItems_id = mi.id
            WHERE mi.PlaceID = @placeId
            ORDER BY mi.Name ASC, mzs.Price ASC";

        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.AddWithValue("@placeId", placeId);
            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                da.Fill(dt);
            }

            ddlMenuSizes.Items.Clear();
            ddlMenuSizes.Items.Add(new ListItem("--- اختر الصنف من قائمة طعامكم واضغط على زر الإضافة لتضمينه في البانر المجمع الحالي ---", "0"));

            foreach (DataRow row in dt.Rows)
            {
                ddlMenuSizes.Items.Add(new ListItem(row["FullItemName"].ToString(), row["SizeID"].ToString()));
            }
        }
    }

    private void BindRestaurantBannersGrid(int placeId)
    {
        // تم التعديل هنا لربط الجداول ببعضها بشكل سليم عبر الـ XML لاستخراج أسماء الأصناف دون خطأ العمود المفقود
        string query = @"
            SELECT 
                rib.id,
                rib.PhotoUrl,
                rib.IsActive,
                rib.SortOrder,
                STUFF((
                    SELECT ' + ' + mi.Name + ' (ج.م ' + CAST(mzs.Price AS NVARCHAR(20)) + ')'
                    FROM dbo.Restaurant_Banner_Sizes rbs
                    INNER JOIN dbo.MenuItems_Sizes mzs ON rbs.MenuItemSizeID = mzs.id
                    INNER JOIN dbo.MenuItems mi ON mzs.MenuItems_id = mi.id
                    WHERE rbs.RestaurantItemBannerID = rib.id
                    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') AS ConnectedItems
            FROM dbo.Restaurant_Item_Banners rib
            WHERE rib.PlaceID = @placeId
            ORDER BY rib.CreatedDate DESC, rib.SortOrder ASC";

        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.AddWithValue("@placeId", placeId);
            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                da.Fill(dt);
            }

            gvBanners.DataSource = dt;
            gvBanners.DataBind();

            lblTotalBanners.Text = dt.Rows.Count.ToString();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Session["PlaceID"] == null) return;
        if (!fuBannerPhoto.HasFile) return;

        try
        {
            string ext = Path.GetExtension(fuBannerPhoto.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "err", "alert('امتداد الصورة غير مدعوم، يرجى اختيار ملف JPG أو PNG أو WEBP فقط');", true);
                return;
            }

            string fileName = Guid.NewGuid().ToString() + ext;
            string folderPath = Server.MapPath("~/uploads/banners/");

            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            fuBannerPhoto.SaveAs(folderPath + fileName);
            string dbPhotoUrl = "uploads/banners/" + fileName;

            int sortOrder = 0;
            int.TryParse(txtSortOrder.Text, out sortOrder);
            bool isActive = chkIsActive.Checked;
            int currentPlaceID = Convert.ToInt32(Session["PlaceID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    // 1. إدخال السجل الرئيسي للبانر بداخل جدول Restaurant_Item_Banners مع استخدام الـ Session الحية
                    string sqlInsertBanner = @"
                        INSERT INTO dbo.Restaurant_Item_Banners (PlaceID, PhotoUrl, IsActive, SortOrder) 
                        VALUES (@PlaceID, @PhotoUrl, @IsActive, @SortOrder);
                        SELECT SCOPE_IDENTITY();";

                    int insertedBannerID = 0;
                    using (SqlCommand cmdBanner = new SqlCommand(sqlInsertBanner, conn, trans))
                    {
                        cmdBanner.Parameters.AddWithValue("@PlaceID", currentPlaceID);
                        cmdBanner.Parameters.AddWithValue("@PhotoUrl", dbPhotoUrl);
                        cmdBanner.Parameters.AddWithValue("@IsActive", isActive);
                        cmdBanner.Parameters.AddWithValue("@SortOrder", sortOrder);

                        insertedBannerID = Convert.ToInt32(cmdBanner.ExecuteScalar());
                    }

                    // 2. فك وتجزئة أرقام الأحجام المضافة بالهيدن فيلد لربطها بالجدول الوسيط المجمع للبانر الحالي
                    string rawSizeIDs = hfSelectedSizeIDs.Value.Trim();
                    if (!string.IsNullOrEmpty(rawSizeIDs))
                    {
                        string[] sizeIDs = rawSizeIDs.Split(',');
                        string sqlInsertRelation = "INSERT INTO dbo.Restaurant_Banner_Sizes (RestaurantItemBannerID, MenuItemSizeID) VALUES (@BannerID, @SizeID)";

                        foreach (string sid in sizeIDs)
                        {
                            if (!string.IsNullOrEmpty(sid))
                            {
                                using (SqlCommand cmdRelation = new SqlCommand(sqlInsertRelation, conn, trans))
                                {
                                    cmdRelation.Parameters.AddWithValue("@BannerID", insertedBannerID);
                                    cmdRelation.Parameters.AddWithValue("@SizeID", Convert.ToInt32(sid));
                                    cmdRelation.ExecuteNonQuery();
                                }
                            }
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

            int activePlaceId = Convert.ToInt32(Session["PlaceID"]);
            ClearFormFields(activePlaceId);
            BindRestaurantBannersGrid(activePlaceId);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "suc", "alert('تم حفظ وتنشيط بانر العروض والأصناف المجمعة لمطعمكم بنجاح');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "err", "alert('حدث خطأ في السيرفر أثناء المعالجة الحسابية: " + ex.Message.Replace("'", "") + "');", true);
        }
    }

    private void ClearFormFields(int placeId)
    {
        txtSortOrder.Text = "0";
        chkIsActive.Checked = true;
        hfSelectedSizeIDs.Value = "";
        FillMenuSizesList(placeId);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "clearTags", "bannerSelectedItems = []; renderBannerItemTags();", true);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        if (Session["PlaceID"] != null)
        {
            ClearFormFields(Convert.ToInt32(Session["PlaceID"]));
        }
    }

    protected void gvBanners_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (Session["PlaceID"] == null) return;

        if (e.CommandName == "DeleteBanner")
        {
            int bannerId = Convert.ToInt32(e.CommandArgument);
            string deleteQuery = "DELETE FROM dbo.Restaurant_Item_Banners WHERE id = @id";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
            {
                cmd.Parameters.AddWithValue("@id", bannerId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            int currentPlaceID = Convert.ToInt32(Session["PlaceID"]);
            BindRestaurantBannersGrid(currentPlaceID);
            upBannersGrid.Update();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "del", "alert('تم حذف البانر وتطهير كافة متعلقات وحجوم الأصناف التابعة له بنجاح');", true);
        }
    }

    protected void GridView_PreRender(object sender, EventArgs e)
    {
        if (gvBanners.Rows.Count > 0)
        {
            gvBanners.UseAccessibleHeader = true;
            gvBanners.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}