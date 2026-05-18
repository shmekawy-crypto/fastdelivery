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
    public static object SaveLocalStorage(string cart, string action, int id = 0, string deliveryCost = null, string paymentMethod = null, string scheduledTime = null, string contactMethod = null, string orderType = null, string payerPhone = null)
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
            SaveOrderAndDetails(dt, Convert.ToDecimal(deliveryCost), paymentMethod, scheduledTime, contactMethod, orderType, payerPhone);

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

    public static void SaveOrderAndDetails(DataTable dt, decimal deliveryCost, string paymentMethod, string scheduledTime, string contactMethod, string orderType, string payerPhone)
    {

        int paymentMethodInt = 0; // القيمة الافتراضية Cash
        switch (paymentMethod.ToLower().Trim())
        {
            case "cash": paymentMethodInt = 1; break;
            case "visa": paymentMethodInt = 2; break;
            case "instapay": paymentMethodInt = 3; break;
            case "wallet": paymentMethodInt = 4; break;
            case "vodafone_cash": paymentMethodInt = 5; break;
            default: paymentMethodInt = 0; break; // لو جه نص غير معروف
        }

        int contactMethodInt = 0; // القيمة الافتراضية Cash
        switch (contactMethod.ToLower().Trim())
        {
            case "phone": contactMethodInt = 1; break;
            case "whatsapp": contactMethodInt = 2; break;
            case "ring_bell": contactMethodInt = 3; break;
            default: contactMethodInt = 0; break; // لو جه نص غير معروف
        }
        int DeliveryMethodInt = 0; // القيمة الافتراضية Cash
        switch (orderType.ToLower().Trim())
        {
            case "delivery": DeliveryMethodInt = 1; break;
            case "pickup": DeliveryMethodInt = 2; break;
            case "in-shop": DeliveryMethodInt = 3; break;
            default: DeliveryMethodInt = 0; break; // لو جه نص غير معروف
        }
        object scheduledDateTime = DBNull.Value; // الافتراضي لو فاضي ينزل NULL
        if (!string.IsNullOrEmpty(scheduledTime) && !string.IsNullOrWhiteSpace(scheduledTime))
        {
            TimeSpan timeValue;
            DateTime parsedDateTime = DateTime.MinValue;
            // محاولة تحليل الوقت سواء كان مبعوت بصيغة 12 ساعة (PM/AM) أو صيغة 24 ساعة
            if (TimeSpan.TryParse(scheduledTime, out timeValue) ||
                DateTime.TryParse(scheduledTime, out parsedDateTime))
            {
                // لو تم تحليله كـ DateTime كامل أو كـ وقت فقط، ندمجه مع تاريخ اليوم
                DateTime finalTime = parsedDateTime != DateTime.MinValue ? parsedDateTime : DateTime.Today.Add(timeValue);

                // التأكد من دمج تاريخ اليوم الحالي مع الوقت المستخرج
                scheduledDateTime = new DateTime(DateTime.Today.Year, DateTime.Today.Month, DateTime.Today.Day, finalTime.Hour, finalTime.Minute, 0);
            }
        }

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Conn"].ConnectionString))
        {
            con.Open();
            SqlTransaction trans = con.BeginTransaction();
            try
            {
                int newOrderId = 0;
                // 1. إدخال الطلب الرئيسي في جدول Orders
                using (SqlCommand cmd = new SqlCommand(@"
                INSERT INTO Orders (Address_id, Odate, DeliveryCost, delivered,paymentMethod,contactMethod,DeliveryMethod,WalletNumber,ODTime)
                VALUES (@Address_id, GETDATE(), @DeliveryCost, 0,@paymentMethod,@contactMethod,@DeliveryMethod,@WalletNumber,@ODTime);
                SELECT SCOPE_IDENTITY();", con, trans))
                {
                    cmd.Parameters.AddWithValue("@Address_id", dt.Rows[0]["addid"]);
                    cmd.Parameters.AddWithValue("@DeliveryCost", deliveryCost);
                    cmd.Parameters.AddWithValue("@paymentMethod", paymentMethodInt);
                    cmd.Parameters.AddWithValue("@contactMethod", contactMethodInt);
                    cmd.Parameters.AddWithValue("@DeliveryMethod", DeliveryMethodInt);
                    cmd.Parameters.AddWithValue("@WalletNumber", payerPhone);
                    cmd.Parameters.AddWithValue("@ODTime", scheduledDateTime);

                    newOrderId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // 2. إدخال تفاصيل الأصناف والإضافات الخاصة بها
                foreach (DataRow row in dt.Rows)
                {
                    int newDetailId = 0;

                    string sizeId = "";
                    string sizeName = "";

                    // قراءة عمود الـ customization كـ JSON
                    string jsonCust = row["customization"] != null ? row["customization"].ToString() : "";
                    JObject custObj = null;

                    if (!string.IsNullOrEmpty(jsonCust) && jsonCust.Trim().StartsWith("{"))
                    {
                        custObj = JObject.Parse(jsonCust);

                        // استخراج بيانات الحجم (Size) بالطريقة المتوافقة مع C# 5
                        if (custObj["size"] != null && custObj["size"].HasValues)
                        {
                            sizeId = custObj["size"]["id"] != null ? custObj["size"]["id"].ToString() : "";
                            sizeName = custObj["size"]["name"] != null ? custObj["size"]["name"].ToString() : "";
                        }
                    }

                    int currentSizeTableId = Convert.ToInt32(row["id"].ToString());
                    int addressId = Convert.ToInt32(dt.Rows[0]["addid"].ToString());
                    int currentShopId = Convert.ToInt32(row["shopId"].ToString()); // قراءة الـ shopId مباشرة من السلة
                    // إدخال الصنف مع ضبط استعلام الـ DeliveryZones ليعمل بربط مباشر وصحيح عن طريق الـ PlaceID للمطعم
                    using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Order_Details (Order_id, MenuItems_id, amount, price, notes, PrepearMin, DeliveredTime)
                    VALUES (
                        @Order_id, 
                        @MenuItems_id, 
                        @amount, 
                        @price, 
                        @notes,
                        (SELECT TOP 1 mi.PrepearMin FROM dbo.MenuItems mi INNER JOIN dbo.MenuItems_Sizes mzs ON mi.id = mzs.MenuItems_id WHERE mzs.id = @SizeTableID),
                     (SELECT TOP 1 dz.DeliveredTime FROM dbo.DeliveryZones dz INNER JOIN dbo.Addresses ad ON dz.Areas_id = ad.Area_id WHERE dz.PlacesID = @PlaceID AND ad.ID = @AddressID)
                    );
                    SELECT SCOPE_IDENTITY();", con, trans))
                    {
                        cmd.Parameters.AddWithValue("@Order_id", newOrderId);
                        cmd.Parameters.AddWithValue("@MenuItems_id", currentSizeTableId);
                        cmd.Parameters.AddWithValue("@amount", row["amount"]);
                        cmd.Parameters.AddWithValue("@price", row["price"]);
                        cmd.Parameters.AddWithValue("@notes", row["notes"]);
                        cmd.Parameters.AddWithValue("@SizeTableID", currentSizeTableId);
                        cmd.Parameters.AddWithValue("@AddressID", addressId);
                        cmd.Parameters.AddWithValue("@PlaceID", currentShopId);
                        newDetailId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    // إذا كان هناك تخصيصات (إضافات)، نقوم بقراءتها وحفظها
                    if (custObj != null)
                    {
                        // أولاً: معالجة قائمة الـ upsells
                        JArray upsells = custObj["upsells"] as JArray;
                        if (upsells != null)
                        {
                            foreach (JObject extraItem in upsells)
                            {
                                using (SqlCommand cmdExtra = new SqlCommand(@"
                                INSERT INTO Order_Details_Extras (Order_Detail_id, MenuItems_Extra_id, price, Amount)
                                VALUES (@Order_Detail_id, @MenuItems_Extra_id, @price, @Amount)", con, trans))
                                {
                                    cmdExtra.Parameters.AddWithValue("@Order_Detail_id", newDetailId);
                                    cmdExtra.Parameters.AddWithValue("@MenuItems_Extra_id", extraItem["id"] != null ? extraItem["id"].ToString() : "");
                                    cmdExtra.Parameters.AddWithValue("@price", extraItem["price"] != null ? Convert.ToDecimal(extraItem["price"]) : 0);
                                    cmdExtra.Parameters.AddWithValue("@Amount", extraItem["qty"] != null ? Convert.ToInt32(extraItem["qty"]) : 1);
                                    cmdExtra.ExecuteNonQuery();
                                }
                            }
                        }

                    }
                }
                trans.Commit();
            }
            catch (Exception ex)
            {
                trans.Rollback();
                throw;
            }
        }
    }
}