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
        // تعديل الاستعلام ليشمل رسوم التوصيل
        string query = @"
    SELECT o.id AS OrderID, o.Odate, a.AddressName,
-- هنا جمعنا إجمالي الأصناف من جدول التفاصيل + مصاريف التوصيل من جدول الأوردر
( (SELECT SUM(od2.Amount * od2.Price) FROM dbo.Order_Details od2 WHERE od2.Order_id = o.id) 
  + o.DeliveryCost ) AS TotalPrice,
(SELECT COUNT(DISTINCT mi.PlaceID) FROM dbo.Order_Details od 
 INNER JOIN dbo.MenuItems mi ON od.MenuItems_id = mi.id 
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

            // استعلام يجيب كل مطعم والأصناف بتاعته مفصولة بـ +
            string subQuery = @"
            SELECT p.Name AS PlaceName, 
            STUFF((SELECT ' + ' + 
                   CASE 
                       WHEN @lang = 'en' THEN mi2.NameEn
                       WHEN @lang = 'ru' THEN mi2.NameRu
                       ELSE mi2.Name
                   END
                   FROM dbo.Order_Details od2 
                   INNER JOIN dbo.MenuItems mi2 ON od2.MenuItems_id = mi2.id 
                   WHERE od2.Order_id = @OrderID AND mi2.PlaceID = p.id 
                   FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') AS PlaceItems
            FROM dbo.Places p
            WHERE p.id IN (SELECT DISTINCT mi3.PlaceID 
                           FROM dbo.Order_Details od3 
                           INNER JOIN dbo.MenuItems mi3 ON od3.MenuItems_id = mi3.id 
                           WHERE od3.Order_id = @OrderID)";

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