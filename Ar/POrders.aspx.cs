using DMS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Ar_POrders : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        this.Load += new EventHandler(Page_Load);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Users usr = new Users();
            usr.Where.Email.Operator = WhereParameter.Operand.Equal;
            usr.Where.Email.Value = User.Identity.Name;
            usr.Query.Load();
            BindOrders(usr.Id);
        }
    }

    private void BindOrders(int userId)
    {
        // الاستعلام المعدل لحساب الخصومات كنسب مئوية
        string query = @"
SELECT o.id AS OrderID, o.Odate, a.AddressName,

-- الحسبة الجديدة الشاملة بناءً على النسب المئوية للخصم
(
    -- 1. حساب إجمالي الأصناف مع الإضافات
    (
        ISNULL((SELECT SUM(od2.Amount * od2.Price) FROM dbo.Order_Details od2 WHERE od2.Order_id = o.id), 0) + 
        ISNULL((SELECT SUM(ode.Amount * ode.Price) FROM dbo.Order_Details_Extras ode INNER JOIN dbo.Order_Details od3 ON ode.Order_Detail_id = od3.id WHERE od3.Order_id = o.id), 0)
    ) 
    -- تطبيق نسبة خصم المطعم (إذا كان الخصم مخزن كـ 10 يعني 10%)
    * (1.0 - (ISNULL(o.CoponDiscountR, 0) / 100.0))
    
    + 
    
    -- 2. حساب مصاريف التوصيل بعد تطبيق نسبة خصم الدليفري
    (
        ISNULL(o.DeliveryCost, 0) * (1.0 - (ISNULL(o.CoponDiscountD, 0) / 100.0))
    )
) AS TotalPrice,

(SELECT COUNT(DISTINCT mi.PlaceID) FROM dbo.Order_Details od 
 INNER JOIN dbo.MenuItems_Sizes mis ON od.MenuItems_id = mis.id
 INNER JOIN dbo.MenuItems mi ON mis.MenuItems_id = mi.id
 WHERE od.Order_id = o.id) AS PlacesCount

FROM dbo.Orders o
INNER JOIN dbo.Addresses a ON o.Address_id = a.ID
WHERE a.UserID = @UserID
ORDER BY o.Odate DESC";

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Conn"].ConnectionString))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.AddWithValue("@UserID", userId);
            conn.Open();
            rptOrders.DataSource = cmd.ExecuteReader();
            rptOrders.DataBind();
        }
        noPreviousOrders.Visible = (rptOrders.Items.Count == 0);
    }

    protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int orderId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "OrderID"));
            Repeater rptPlaces = (Repeater)e.Item.FindControl("rptPlaces");

            // استعلام يجيب كل مطعم والأصناف بتاعته مدمج معها إضافاتها بين قوسين (إضافة 1 + إضافة 2)
            string subQuery = @"
            SELECT p.Name AS PlaceName, 
                   STUFF((
                       SELECT ' + ' + 
                       (
                           CASE 
                               WHEN @lang = 'en' THEN mi2.NameEn
                               WHEN @lang = 'ru' THEN mi2.NameRu
                               ELSE mi2.Name
                           END
                       ) + 
                       -- بناء نصوص الإضافات الخاصة بالصنف إن وجدت
                       ISNULL(
                           ' (' + 
                           STUFF((
                               SELECT ' + ' + 
                               CASE 
                                   WHEN @lang = 'en' THEN ex.NameEn
                                   WHEN @lang = 'ru' THEN ex.NameRu
                                   ELSE ex.Name
                               END
                               FROM dbo.Order_Details_Extras ode
                               INNER JOIN dbo.MenuItems_Extras mie ON ode.MenuItems_Extra_id = mie.id
                               INNER JOIN dbo.Extras ex ON mie.Extra_id = ex.id
                               WHERE ode.Order_Detail_id = od2.id
                               FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') 
                           + ')'
                       , '')
                       FROM dbo.Order_Details od2 
                       INNER JOIN dbo.MenuItems_Sizes mis2 ON od2.MenuItems_id = mis2.id
                       INNER JOIN dbo.MenuItems mi2 ON mis2.MenuItems_id = mi2.id 
                       WHERE od2.Order_id = @OrderID AND mi2.PlaceID = p.id 
                       FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') AS PlaceItems
            FROM dbo.Places p
            WHERE p.id IN (
                SELECT DISTINCT mi3.PlaceID 
                FROM dbo.Order_Details od3 
                INNER JOIN dbo.MenuItems_Sizes mis3 ON od3.MenuItems_id = mis3.id
                INNER JOIN dbo.MenuItems mi3 ON mis3.MenuItems_id = mi3.id 
                WHERE od3.Order_id = @OrderID
            )";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Conn"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(subQuery, conn))
            {
                cmd.Parameters.AddWithValue("@OrderID", orderId);
                var lang = System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName;
                cmd.Parameters.AddWithValue("@lang", lang);
                conn.Open();
                rptPlaces.DataSource = cmd.ExecuteReader();
                rptPlaces.DataBind();
            }
        }
    }
}