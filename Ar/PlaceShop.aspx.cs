using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using DMS;
using System.Web.Services;

public partial class Ar_PlaceShop : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindMenu();
            Addresses addr = new Addresses();
            addr.LoadByPrimaryKey(Convert.ToInt32(Request.QueryString["addid"].ToString()));
            Areas area = new Areas();
            area.LoadByPrimaryKey(addr.Area_id);
            Gov gov = new Gov();
            gov.LoadByPrimaryKey(area.Gov_id);
            ltareaId.Text = addr.s_Area_id;
            ltaddid.Text = addr.s_ID;
            Ssetting set = new Ssetting();
            set.LoadAll();
            ltPercentage.Text = set.DeliveryP.ToString("G29");

            Places place = new Places();
            place.LoadByPrimaryKey(Convert.ToInt32(Request.QueryString["id"].ToString()));
            ltBanner.Text = "<img src='" + place.Banner + "' onerror=\"this.src='/ar/images/placeholderImage.webp'\">";
            var lang = System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName;

            ltlocation.Text = lang == "en" ? "<a href='Places.aspx?id=" + place.Categories_id + "&addid=" + addr.ID + "'>" + gov.NameEn + "-" + area.NameEn + "</a>" :
                          lang == "ru" ? "<a href='Places.aspx?id=" + place.Categories_id + "&addid=" + addr.ID + "'>" + gov.NameRu + "-" + area.NameRu + "</a>" :
                          "<a href='Places.aspx?id=" + place.Categories_id + "&addid=" + addr.ID + "'>" + gov.Name + "-" + area.Name + "</a>";

            DeliveryZones dzone = new DeliveryZones();
            dzone.Where.PlacesID.Operator = WhereParameter.Operand.Equal;
            dzone.Where.PlacesID.Value = place.Id;
            dzone.Where.Areas_id.Operator = WhereParameter.Operand.Equal;
            dzone.Where.Areas_id.Value = addr.Area_id;
            dzone.Query.Load();

            vw_Users usr = new vw_Users();
            usr.Where.Id.Operator = WhereParameter.Operand.Equal;
            usr.Where.Id.Value = addr.UserID;
            usr.Query.Load();

            ltDeliveryCost.Text = dzone.DeliveryCost.ToString("F2");
            if (usr.Ocounts == 0)
            {
                ltdeliveryFee.Text = "0";
                ltDeliveryCost.Text = "0";
            }
            else
            {
                ltdeliveryFee.Text = dzone.s_DeliveryCost;
            }

            ltshopId.Text = place.s_Id;
            ltshopName.Text = lang == "en" ? place.NameEn : lang == "ru" ? place.NameRu : place.Name;
            ltshopAreaId.Text = place.s_Areas_id;
            ltname.Text = ltname2.Text = ltshopName.Text;
            ltDetails.Text = lang == "en" ? place.DescriptionEn : lang == "ru" ? place.DescriptionRu : place.Description;

            ltmincost.Text = place.MinOrder.ToString("F2") + " " + (string)GetGlobalResourceObject("texts", "currency");
            ltdeliverytime.Text = (dzone.DeliveredTime).ToString();
            imgplace.ImageUrl = place.PhotoPath;
            imgplace.Attributes.Add("onerror", "this.src='/ar/images/placeholderImage.webp'");

            // Rating Stars logic
            double rating = 0;
            try { 
                object rateObj = place.GetColumn("Rate");
                if (rateObj != null && rateObj != DBNull.Value)
                    rating = Convert.ToDouble(rateObj);
            } catch { }

            string starsHtml = "";
            for (int i = 1; i <= 5; i++)
            {
                if (i <= rating)
                    starsHtml += "<i class='fa-solid fa-star' style='color:#FFD700;'></i>";
                else if (i - 0.5 <= rating)
                    starsHtml += "<i class='fa-solid fa-star-half-stroke' style='color:#FFD700;'></i>";
                else
                    starsHtml += "<i class='fa-regular fa-star' style='color:#FFD700;'></i>";
            }
            shopRating.InnerHtml = starsHtml + " <span class='rating-number'>(" + rating.ToString("0.0") + ")</span>";

            // Fetch IsOpened status via SQL since it's a calculated value
            int isOpened = 0;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sqlStatus = @"
                    SELECT CASE
                        WHEN s.StartTime IS NOT NULL
                             AND CAST(DATEADD(HOUR, 10, GETDATE()) AS TIME) BETWEEN s.StartTime AND s.EndTime
                        THEN 1 ELSE 0
                    END AS IsOpened
                    FROM dbo.Places p
                    LEFT JOIN dbo.PlacesDeliverySchedule s ON p.id = s.PlacesId
                         AND s.IsActive = 1
                         AND s.DayId = (SELECT Id FROM dbo.DaysOfWeek WHERE DayOrder = DATEPART(WEEKDAY, DATEADD(HOUR, 10, GETDATE())))
                    WHERE p.id = @pid";
                SqlCommand cmdStatus = new SqlCommand(sqlStatus, con);
                cmdStatus.Parameters.AddWithValue("@pid", place.Id);
                con.Open();
                object result = cmdStatus.ExecuteScalar();
                if (result != null && result != DBNull.Value) isOpened = Convert.ToInt32(result);
            }

            ltIsOpened.Text = isOpened.ToString();
            ltRawRating.Text = rating.ToString("0.0", System.Globalization.CultureInfo.InvariantCulture);
            shopStatusBadge.Attributes["class"] = isOpened == 1 ? "status-badge open" : "status-badge closed";
            shopStatusBadge.InnerText = isOpened == 1 ? (string)GetGlobalResourceObject("texts", "Open") : (string)GetGlobalResourceObject("texts", "Closed");

            // Set Favorite Heart Data Attributes
            shopHeartIcon.Attributes["data-id"] = place.s_Id;
            shopHeartIcon.Attributes["data-name"] = place.Name;
            shopHeartIcon.Attributes["data-name-en"] = place.NameEn;
            shopHeartIcon.Attributes["data-img"] = "/ar/" + place.PhotoPath;
            shopHeartIcon.Attributes["data-desc"] = place.Description;
            shopHeartIcon.Attributes["data-desc-en"] = place.DescriptionEn;
            shopHeartIcon.Attributes["data-rate"] = rating.ToString("0.0", System.Globalization.CultureInfo.InvariantCulture);
            shopHeartIcon.Attributes["data-is-opened"] = isOpened.ToString();
            shopHeartIcon.Attributes["data-url"] = Request.Url.PathAndQuery;
            shopHeartIcon.Attributes["data-delivery-time"] = ltdeliverytime.Text;
            shopHeartIcon.Attributes["data-delivery-cost"] = ltdeliveryFee.Text;
        }
    }

    private void BindMenu()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = "SELECT distinct dbo.Menus.id, dbo.Menus.Name, dbo.Menus.NameEn,dbo.Menus.PhotoUrl,dbo.Menus.NameRu FROM  dbo.Menus INNER JOIN dbo.MenuItems ON dbo.Menus.id = dbo.MenuItems.MenuID INNER JOIN dbo.Places ON dbo.MenuItems.PlaceID = dbo.Places.id WHERE(dbo.MenuItems.PlaceID = " + Convert.ToInt32(Request.QueryString["id"].ToString()) + ") ";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            da.SelectCommand.CommandTimeout = 60; // Increase timeout to handle semaphore issues
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptMenu.DataSource = FoodCategoryRepeater.DataSource = dt;
            rptMenu.DataBind();
            FoodCategoryRepeater.DataBind();
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }
    }
    public string GetActiveClass(string categoryId)
    {
        string currentSelectedId = Request.QueryString["id"] ?? "1";
        if (categoryId == currentSelectedId) return " active";
        return "";
    }
    [WebMethod]
    public static object GetProductDetails(int itemId)
    {
        // استبدل ConnectionString بما يناسب مشروعك
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

        try
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. جلب بيانات الصنف الأساسية
                string itemSql = "SELECT dbo.MenuItems_Sizes.id AS id, dbo.MenuItems.Name, dbo.MenuItems.Description, dbo.MenuItems.PhotoUrl, dbo.MenuItems.Price FROM dbo.MenuItems INNER JOIN dbo.MenuItems_Sizes ON dbo.MenuItems.id = dbo.MenuItems_Sizes.MenuItems_id WHERE(dbo.MenuItems_Sizes.id = @id)";
                SqlCommand itemCmd = new SqlCommand(itemSql, conn);
                itemCmd.Parameters.AddWithValue("@id", itemId);

                SqlDataReader rdr = itemCmd.ExecuteReader();
                if (!rdr.Read()) return new { success = false, message = "Item not found" };

                // تخزين البيانات الأساسية
                var productData = new
                {
                    id = Convert.ToInt32(rdr["id"]),
                    name = rdr["Name"].ToString(),
                    description = rdr["Description"].ToString(),
                    photoUrl = rdr["PhotoUrl"].ToString(),
                    price = Convert.ToDecimal(rdr["Price"])
                };
                rdr.Close();

                // 2. جلب الأحجام المرتبطة بهذا الصنف
                var sizesList = new List<object>();

                // تعديل الاستعلام لجلب ID جدول الربط ومعرف المنتج
                string sizeSql = @"SELECT
                        ms.id AS MenuSize_id,
                        ms.MenuItems_id,
                        s.Name,
                        ms.Price
                   FROM MenuItems_Sizes ms
                   INNER JOIN Sizes s ON ms.Size_id = s.id
                   WHERE ms.MenuItems_id = (select MenuItems_id from MenuItems_Sizes where id=@id)";

                SqlCommand sizeCmd = new SqlCommand(sizeSql, conn);
                sizeCmd.Parameters.AddWithValue("@id", itemId);

                SqlDataReader sRdr = sizeCmd.ExecuteReader();
                while (sRdr.Read())
                {
                    sizesList.Add(new
                    {
                        // المعرف الفريد للحجم المرتبط بهذا المنتج (الذي ستحتاجه في السلة)
                        id = sRdr["MenuSize_id"],
                        // معرف المنتج الأساسي
                        menuItemid = sRdr["MenuItems_id"],
                        name = sRdr["Name"].ToString(),
                        price = Convert.ToDecimal(sRdr["Price"])
                    });
                }
                sRdr.Close();

                // 3. جلب الإضافات المرتبطة بهذا الصنف
                var extrasList = new List<object>();
                string extraSql = @"SELECT me.id, ex.Name, me.Price,ex.PhotoUrl
                                FROM MenuItems_Extras me
                                INNER JOIN Extras ex ON me.Extra_id = ex.id
                                WHERE me.MenuItem_id = (select MenuItems_id from MenuItems_Sizes where id=@id)";
                SqlCommand extraCmd = new SqlCommand(extraSql, conn);
                extraCmd.Parameters.AddWithValue("@id", itemId);
                SqlDataReader eRdr = extraCmd.ExecuteReader();
                while (eRdr.Read())
                {
                    extrasList.Add(new
                    {
                        id = eRdr["id"],
                        name = eRdr["Name"].ToString(),
                        photoUrl = eRdr["PhotoUrl"].ToString(),
                        price = Convert.ToDecimal(eRdr["Price"])
                    });
                }
                eRdr.Close();

                // الرد النهائي بصيغة JSON
                return new
                {
                    success = true,
                    id = productData.id,
                    name = productData.name,
                    description = productData.description,
                    photoUrl = productData.photoUrl,
                    price = productData.price,
                    sizes = sizesList.Count > 1 ? sizesList : new List<object>(),
                    upsellItems = extrasList
                };
            }
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }
    protected void rptCategories_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int categoryId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "id"));
            Repeater rptFoodItems = (Repeater)e.Item.FindControl("rptFoodItems");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
SELECT
    -- الكود المعدل: يجيب معرف الحجم أولاً، وإذا لم يوجد يجيب معرف الصنف الأساسي
    ISNULL((SELECT TOP 1 id FROM MenuItems_Sizes WHERE MenuItems_id = mi.id), mi.id) AS id,
    
    mi.id AS OriginalMenuItemID, -- سبتهولك هنا لو هتحتاجه في أي مكان تاني
    mi.PlaceID, 
    mi.PrepearMin, 
    mi.MenuID, 
    mi.Name, 
    mi.NameEn, 
    mi.NameRu,
    mi.Description, 
    mi.DescriptionEn, 
    mi.DescriptionRu,
    mi.PhotoUrl,
    
    -- OldPrice: لو فيه أحجام، هات سعر أول حجم، لو مفيش هات سعر الصنف الأساسي
    ISNULL((SELECT TOP 1 Price FROM MenuItems_Sizes WHERE MenuItems_id = mi.id), mi.Price) AS OldPrice,

    -- NewPrice: الحسبة بعد الخصم (سواء من جدول الأحجام أو الأساسي)
    ISNULL(
        (SELECT TOP 1 Price - DiscountValue FROM MenuItems_Sizes WHERE MenuItems_id = mi.id),
        mi.Price - mi.DiscountValue
    ) AS NewPrice,

    -- isCustom: لو عدد سجلاته في جدول الأحجام أكبر من 1 يبقى 1 (يعني مخصص)، غير كده 0
    CASE
        WHEN (SELECT COUNT(*) FROM MenuItems_Sizes WHERE MenuItems_id = mi.id) > 1 THEN 1
        ELSE 0
    END AS isCustom,
    
    -- hasAddons: لو له إضافات أو أحجام متعددة
    CASE
        WHEN (SELECT COUNT(*) FROM MenuItems_Sizes WHERE MenuItems_id = mi.id) > 1 THEN 1
        WHEN (SELECT COUNT(*) FROM MenuItems_Extras WHERE MenuItem_id = mi.id) > 0 THEN 1
        ELSE 0
    END AS hasAddons

FROM dbo.Menus m
INNER JOIN dbo.MenuItems mi ON m.id = mi.MenuID
INNER JOIN dbo.Places p ON mi.PlaceID = p.id
WHERE mi.MenuID = @MenuID AND mi.PlaceID = @PlaceID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@MenuID", categoryId);
                cmd.Parameters.AddWithValue("@PlaceID", Convert.ToInt32(Request.QueryString["id"].ToString()));

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                rptFoodItems.DataSource = rdr;
                rptFoodItems.DataBind();
            }
        }
    }

}
