using System;
using System.Web.Services;
using System.Web.Script.Services;
using Newtonsoft.Json.Linq;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web;

public partial class Ar_SaveLocalStorage : System.Web.UI.Page
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static object SaveLocalStorage(string cart, string action, int id = 0, string deliveryCost = null)
    {
        try
        {
            JArray items = string.IsNullOrEmpty(cart) ? new JArray() : JArray.Parse(cart);
            DataTable dt = ConvertJArrayToDataTable(items);

            if (dt.Rows.Count == 0)
            {
                return new { success = false, error = "السلة فارغة" };
            }

            // تجميع IDs المطاعم الفريدة من الكارت
            List<int> ids = new List<int>();
            foreach (DataRow row in dt.Rows)
            {
                int shopId;
                if (int.TryParse(row["shopId"].ToString(), out shopId))
                {
                    if (!ids.Contains(shopId)) ids.Add(shopId);
                }
            }

            string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

            // 1. الأماكن المتاحة الآن بناءً على الجدول الزمني
            string sqlAvailable = @"
                SELECT dbo.PlacesDeliverySchedule.PlacesId
                FROM dbo.PlacesDeliverySchedule 
                INNER JOIN dbo.DaysOfWeek ON dbo.PlacesDeliverySchedule.DayId = dbo.DaysOfWeek.Id
                WHERE (dbo.DaysOfWeek.Dayorder = DATEPART(WEEKDAY, DATEADD(HOUR, 10, GETDATE())) 
                AND (dbo.PlacesDeliverySchedule.IsActive = 1) 
                AND (CAST(DATEADD(HOUR, 10, GETDATE()) AS TIME) BETWEEN 
                dbo.PlacesDeliverySchedule.StartTime AND dbo.PlacesDeliverySchedule.EndTime))";

            // 2. جلب الاسم والحد الأدنى للطلب (MinOrder)
            string idsCsv = string.Join(",", ids);
            string sqlNames = string.Format("SELECT Id, Name, ISNULL(MinOrder, 0) as MinOrder FROM Places WHERE Id IN ({0})", idsCsv);

            DataTable dtAvailable = new DataTable();
            DataTable dtNames = new DataTable();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(sqlAvailable, conn))
                using (SqlDataReader dr = cmd.ExecuteReader())
                    dtAvailable.Load(dr);

                using (SqlCommand cmd2 = new SqlCommand(sqlNames, conn))
                using (SqlDataReader dr2 = cmd2.ExecuteReader())
                    dtNames.Load(dr2);
            }

            // تحويل المتاح لـ HashSet للسرعة
            HashSet<int> availableIds = new HashSet<int>();
            foreach (DataRow row in dtAvailable.Rows)
                availableIds.Add(Convert.ToInt32(row["PlacesId"]));

            // التحقق من (المتاح) و (الحد الأدنى للطلب)
            foreach (DataRow placeRow in dtNames.Rows)
            {
                int pId = Convert.ToInt32(placeRow["Id"]);
                string pName = placeRow["Name"].ToString();
                decimal minOrder = Convert.ToDecimal(placeRow["MinOrder"]);

                // أولاً: هل المطعم متاح حالياً؟
                if (!availableIds.Contains(pId))
                {
                    string notAvailableMsg = (string)HttpContext.GetGlobalResourceObject("texts", "RestaurantnAvaliable") + pName;
                    return new { success = false, error = notAvailableMsg };
                }

                // ثانياً: حساب إجمالي الأصناف التابعة لهذا المطعم
                decimal placeTotal = 0;
                foreach (DataRow itemRow in dt.Rows)
                {
                    if (itemRow["shopId"].ToString() == pId.ToString())
                    {
                        decimal price = Convert.ToDecimal(itemRow["price"]);
                        int amount = Convert.ToInt32(itemRow["amount"]);
                        placeTotal += (price * amount);
                    }
                }

                // ثالثاً: مقارنة الإجمالي بالحد الأدنى
                if (placeTotal < minOrder)
                {
                    string minOrderMsg = string.Format("عفواً، الحد الأدنى للطلب من مطعم {0} هو {1} ج.م. إجمالي طلبك الحالي هو {2} ج.م.",
                                                        pName, minOrder, placeTotal);
                    return new { success = false, error = minOrderMsg };
                }
            }

            // إذا مرت كل الفحوصات بسلام، نبدأ عملية الحفظ
            SaveOrderAndDetails(dt, Convert.ToDecimal(deliveryCost));

            return new
            {
                success = true,
                updatedCart = items.ToString()
            };
        }
        catch (Exception ex)
        {
            return new { success = false, error = ex.Message };
        }
    }

    public static DataTable ConvertJArrayToDataTable(JArray items)
    {
        DataTable dt = new DataTable();
        if (items == null || items.Count == 0) return dt;

        JObject first = (JObject)items[0];
        foreach (var prop in first.Properties())
        {
            dt.Columns.Add(prop.Name, typeof(string));
        }

        foreach (JObject obj in items)
        {
            DataRow row = dt.NewRow();
            foreach (var prop in obj.Properties())
            {
                row[prop.Name] = prop.Value != null ? prop.Value.ToString() : "";
            }
            dt.Rows.Add(row);
        }
        return dt;
    }

    public static void SaveOrderAndDetails(DataTable dt, decimal deliveryCost)
    {
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Conn"].ConnectionString))
        {
            con.Open();
            SqlTransaction trans = con.BeginTransaction();
            try
            {
                int newOrderId = 0;
                // إدخال الطلب الرئيسي
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Orders (Address_id, Odate, DeliveryCost, delivered)
                    VALUES (@Address_id, GETDATE(), @DeliveryCost, 0);
                    SELECT SCOPE_IDENTITY();", con, trans))
                {
                    cmd.Parameters.AddWithValue("@Address_id", dt.Rows[0]["addid"]);
                    cmd.Parameters.AddWithValue("@DeliveryCost", deliveryCost);
                    newOrderId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // إدخال تفاصيل الطلب
                foreach (DataRow row in dt.Rows)
                {
                    using (SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Order_Details (Order_id, MenuItems_id, amount, price)
                        VALUES (@Order_id, @MenuItems_id, @amount, @price)", con, trans))
                    {
                        cmd.Parameters.AddWithValue("@Order_id", newOrderId);
                        cmd.Parameters.AddWithValue("@MenuItems_id", row["id"]);
                        cmd.Parameters.AddWithValue("@amount", row["amount"]);
                        cmd.Parameters.AddWithValue("@price", row["price"]);
                        cmd.ExecuteNonQuery();
                    }
                }
                trans.Commit();
            }
            catch (Exception)
            {
                trans.Rollback();
                throw;
            }
        }
    }
}