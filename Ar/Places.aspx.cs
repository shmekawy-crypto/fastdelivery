using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.HtmlControls;
using System.Data;

public partial class Ar_Places : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Request.QueryString["addid"] != null)
            {
                int addId;
                // بنحاول نحول القيمة لرقم، ولو نجحت بنتأكد إنها مش صفر
                if (int.TryParse(Request.QueryString["addid"], out addId) && addId != 0)
                {
                    // الكود هنا سليم والـ addId جاهز للاستخدام
                    ViewState["SelectedTypeId"] = "0";
                    BindSubCategories();
                    BindRepeater();
                    BindRepeaterC();

                }
                else
                {
                    // لو القيمة نصية أو صفر
                    Response.Redirect("~/ar/Addresses.aspx");
                }
            }
            else
            {
                // لو الـ addid مش موجود خالص في الـ URL
                Response.Redirect("~/ar/Addresses.aspx");
            }
        }
    }
    // ضيف الدالة دي في كود الـ CS
    public string GetPlaceTypes(object placeId)
    {
        string types = "";
        // استخدم جملة الاتصال بتاعتك اللي معرفها فوق (connStr)
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "SELECT TypeID FROM Place_Type_Map WHERE PlaceID = @pid";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@pid", placeId);
            con.Open();
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    types += dr["TypeID"].ToString() + ",";
                }
            }
        }
        // بنشيل آخر فاصلة لو موجودة
        return types.TrimEnd(',');
    }
    private void BindSubCategories()
    {
        if (Request.QueryString["id"] == null || Request.QueryString["addid"] == null) return;

        int catId = Convert.ToInt32(Request.QueryString["id"]);
        int addId = Convert.ToInt32(Request.QueryString["addid"]); // العنوان المختاره العميل

        using (SqlConnection con = new SqlConnection(connStr))
        {
            con.Open();

            // 1. حساب إجمالي "الكل" بشرط العنوان والقسم
            // لازم نربط بجدول DeliveryZones و Addresses زي الـ Repeater بالظبط
            string sqlTotal = @"
            SELECT COUNT(DISTINCT p.id)
            FROM Places p
            INNER JOIN DeliveryZones dz ON p.id = dz.PlacesID
            INNER JOIN Addresses a ON dz.Areas_id = a.Area_id
            WHERE p.Categories_id = @catId AND p.Active = 1 AND a.ID = @addr";

            SqlCommand cmdTotal = new SqlCommand(sqlTotal, con);
            cmdTotal.Parameters.AddWithValue("@catId", catId);
            cmdTotal.Parameters.AddWithValue("@addr", addId);
            int allCount = (int)cmdTotal.ExecuteScalar();
            ViewState["AllCount"] = allCount;

            // 2. استعلام الفئات مع العد بشرط العنوان والقسم
            string sql = @"
            SELECT pt.id, pt.TypeNameAr, pt.TypeNameEn, pt.TypeNameRu, pt.TypeImage,
                   COUNT(DISTINCT p.id) AS TotalCount
            FROM PlaceTypes pt
            INNER JOIN Place_Type_Map map ON pt.id = map.TypeID
            INNER JOIN Places p ON map.PlaceID = p.id
            INNER JOIN DeliveryZones dz ON p.id = dz.PlacesID
            INNER JOIN Addresses a ON dz.Areas_id = a.Area_id
            WHERE p.Categories_id = @catId
              AND p.Active = 1
              AND pt.Active = 1
              AND a.ID = @addr
            GROUP BY pt.id, pt.TypeNameAr, pt.TypeNameEn, pt.TypeNameRu, pt.TypeImage";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@catId", catId);
            cmd.Parameters.AddWithValue("@addr", addId);

            rptSubCategories.DataSource = cmd.ExecuteReader();
            rptSubCategories.DataBind();
        }
    }
    public string GetActiveClass(string categoryId)
    {
        string currentSelectedId = Request.QueryString["id"] ?? "1";
        return (categoryId == currentSelectedId) ? " active" : "";
    }

    private void BindRepeaterC()
    {
        Categories cat = new Categories();
        cat.Where.Active.Operator = WhereParameter.Operand.Equal;
        cat.Where.Active.Value = true;
        cat.Query.Load();

        CategoryRepeater.DataSource = cat.DefaultView.Table;
        CategoryRepeater.DataBind();
    }

    private void BindRepeater()
    {
        int catId = Convert.ToInt32(Request.QueryString["id"]);
        int addId = Convert.ToInt32(Request.QueryString["addid"]);
        string typeId = ViewState["SelectedTypeId"].ToString();
        Categories cat = new Categories();
        cat.LoadByPrimaryKey(catId);

        var lang = System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName;
        ltname.Text = (lang == "en") ? cat.NameEn : (lang == "ru") ? cat.NameRu : cat.Name;

        Addresses add = new Addresses();
        add.LoadByPrimaryKey(addId);
        Areas ara = new Areas();
        ara.LoadByPrimaryKey(add.Area_id);
        Gov gov = new Gov();
        gov.LoadByPrimaryKey(ara.Gov_id);

        ltlocation.Text = ltlocation2.Text = (lang == "en") ? gov.NameEn + "-" + ara.NameEn : (lang == "ru") ? gov.NameRu + "-" + ara.NameRu : gov.Name + "-" + ara.Name;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            string filterByType = "";
            if (typeId != "0")
            {
                filterByType = " AND p.id IN (SELECT PlaceID FROM Place_Type_Map WHERE TypeID = @typeId) ";
            }
            // الاستعلام المحدث: يجيب كل المطاعم مع حالة الفتح (IsOpened)
            // ويقوم بترتيبها بحيث المفتوح يظهر أولاً
            string sql = @"
                SELECT p.id, p.Name, p.NameEn, p.NameRu, p.Address, p.Description, p.DescriptionEn, p.DescriptionRu,
                       (dz.DeliveredTime) as DeliveredTime, p.MinOrder, p.Rate, p.PhotoPath, dz.DeliveryCost,
                       CASE
                          WHEN s.StartTime IS NOT NULL
                               AND CAST(DATEADD(HOUR, 10, GETDATE()) AS TIME) BETWEEN s.StartTime AND s.EndTime
                          THEN 1 ELSE 0
                       END AS IsOpened
                FROM dbo.Places AS p
                INNER JOIN dbo.DeliveryZones dz ON p.id = dz.PlacesID
                INNER JOIN dbo.Addresses AS a ON dz.Areas_id = a.Area_id
                INNER JOIN dbo.Categories ON p.Categories_id = dbo.Categories.id
                LEFT JOIN dbo.PlacesDeliverySchedule AS s ON p.id = s.PlacesId
                     AND s.IsActive = 1
                     AND s.DayId = (SELECT Id FROM dbo.DaysOfWeek WHERE DayOrder = DATEPART(WEEKDAY, DATEADD(HOUR, 10, GETDATE())))
            WHERE (p.Active = 1) AND (a.ID = @addr) AND (p.Categories_id = @catg) " + filterByType + @"
            ORDER BY IsOpened DESC, p.Name ASC";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@addr", addId);
            cmd.Parameters.AddWithValue("@catg", catId);
            if (typeId != "0") cmd.Parameters.AddWithValue("@typeId", typeId);
            con.Open();
            rptplaces.DataSource = cmd.ExecuteReader();
            rptplaces.DataBind();
        }
    }

    protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            var dataObj = DataBinder.Eval(e.Item.DataItem, "Rate");
            double rating = (dataObj != null && dataObj.ToString() != "") ? Convert.ToDouble(dataObj) : 0;

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

            var shopRating = (HtmlGenericControl)e.Item.FindControl("shopRating");
            if (shopRating != null) 
                shopRating.InnerHtml = starsHtml + " <span class='rating-number'>(" + rating.ToString("0.0") + ")</span>";
        }
    }
}
