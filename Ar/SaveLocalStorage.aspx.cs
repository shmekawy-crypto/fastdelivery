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
    public static object SaveLocalStorage(string cart, string action, int id = 0, string deliveryCost = null, string paymentMethod = null, string scheduledTime = null, string contactMethod = null, string orderType = null, string payerPhone = null, string totalCost = null, string orderCoupon = null, string deliveryCoupon = null, string paymentProofBase64 = null)
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

            // التحقق من (المتاح) و (الحد الأدنى للطلب) وحساب إجماليات المطاعم مسبقاً
            Dictionary<int, decimal> placeTotals = new Dictionary<int, decimal>();

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

                // تخزين الإجمالي لاستخدامه لاحقاً في فحص الكوبون
                placeTotals.Add(pId, placeTotal);

                // ثالثاً: مقارنة الإجمالي بالحد الأدنى للمطعم
                if (placeTotal < minOrder)
                {
                    string minOrderMsg = string.Format("عفواً، الحد الأدنى للطلب من مطعم {0} هو {1} ج.م. إجمالي طلبك الحالي هو {2} ج.م.",
                                                        pName, minOrder, placeTotal);
                    return new { success = false, error = minOrderMsg };
                }
            }

            // متغيرات لتخزين النسب المئوية الممررة لدالة الحفظ
            decimal orderDiscountPercent = 0;
            decimal deliveryDiscountPercent = 0;

            // ==========================================
            // 1. التحقق من كوبون المطعم (Order Coupon)
            // ==========================================
            if (!string.IsNullOrEmpty(orderCoupon))
            {
                DataTable dtCoupon = new DataTable();
                string sqlCoupon = @"SELECT TOP 1 PlaceID, ISNULL(MinOrderAmount, 0) AS MinOrderAmount, DiscountType, DiscountPercentage, IsActive, ExpiryDate 
                                 FROM Coupons 
                                 WHERE CouponCode = @CouponCode";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (SqlCommand cmdCoupon = new SqlCommand(sqlCoupon, conn))
                    {
                        cmdCoupon.Parameters.AddWithValue("@CouponCode", orderCoupon.Trim());
                        using (SqlDataReader drCoupon = cmdCoupon.ExecuteReader())
                        {
                            dtCoupon.Load(drCoupon);
                        }
                    }
                }

                if (dtCoupon.Rows.Count == 0)
                {
                    return new { success = false, error = "كود كوبون الخصم غير صحيح أو غير موجود." };
                }

                DataRow couponRow = dtCoupon.Rows[0];
                bool isCouponActive = couponRow["IsActive"] != DBNull.Value && Convert.ToBoolean(couponRow["IsActive"]);
                DateTime expiryDate = Convert.ToDateTime(couponRow["ExpiryDate"]);
                int discountType = Convert.ToInt32(couponRow["DiscountType"]);

                if (!isCouponActive || expiryDate < DateTime.Now)
                {
                    return new { success = false, error = "عفواً، كوبون الخصم منتهي الصلاحية أو غير فعال حالياً." };
                }

                // التحقق من أن الكوبون من نوع مطعم (1)
                if (discountType != 1)
                {
                    return new { success = false, error = "عفواً، هذا الكوبون مخصص لخصم مصاريف التوصيل فقط ولا يمكن تطبيقه ككوبون خصم أصناف." };
                }

                decimal couponMinOrderAmount = Convert.ToDecimal(couponRow["MinOrderAmount"]);

                if (couponRow["PlaceID"] != DBNull.Value)
                {
                    int couponPlaceId = Convert.ToInt32(couponRow["PlaceID"]);

                    if (!placeTotals.ContainsKey(couponPlaceId))
                    {
                        return new { success = false, error = "هذا الكوبون غير مخصص للمطاعم الموجودة في سلة الطلبات الحالية." };
                    }

                    decimal targetedPlaceTotal = placeTotals[couponPlaceId];
                    if (targetedPlaceTotal < couponMinOrderAmount)
                    {
                        return new { success = false, error = string.Format("عفواً، لتطبيق هذا الكوبون يجب أن يكون إجمالي الطلب من المطعم المخصص {0} ج.م. على الأقل. إجمالي طلبك الحالي منه هو {1} ج.م.", couponMinOrderAmount, targetedPlaceTotal) };
                    }
                }
                else
                {
                    if (ids.Count > 1)
                    {
                        return new { success = false, error = "عفواً، لا يمكن تطبيق الكوبونات العامة عند الشراء من أكثر من مطعم في نفس الطلب." };
                    }

                    decimal totalCartCost = 0;
                    foreach (var kvp in placeTotals)
                    {
                        totalCartCost += kvp.Value;
                    }

                    if (totalCartCost < couponMinOrderAmount)
                    {
                        return new { success = false, error = string.Format("عفواً، الحد الأدنى لتفعيل هذا الكوبون هو إجمالي طلب بقيمة {0} ج.م.", couponMinOrderAmount) };
                    }
                }

                orderDiscountPercent = Convert.ToDecimal(couponRow["DiscountPercentage"]);
            }

            // ==========================================
            // 2. التحقق من كوبون التوصيل (Delivery Coupon)
            // ==========================================
            if (!string.IsNullOrEmpty(deliveryCoupon))
            {
                DataTable dtDelCoupon = new DataTable();
                string sqlDelCoupon = @"SELECT TOP 1 ISNULL(MinOrderAmount, 0) AS MinOrderAmount, DiscountType, DiscountPercentage, IsActive, ExpiryDate 
                                    FROM Coupons 
                                    WHERE CouponCode = @CouponCode";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (SqlCommand cmdDelCoupon = new SqlCommand(sqlDelCoupon, conn))
                    {
                        cmdDelCoupon.Parameters.AddWithValue("@CouponCode", deliveryCoupon.Trim());
                        using (SqlDataReader drDelCoupon = cmdDelCoupon.ExecuteReader())
                        {
                            dtDelCoupon.Load(drDelCoupon);
                        }
                    }
                }

                if (dtDelCoupon.Rows.Count == 0)
                {
                    return new { success = false, error = "كود كوبون التوصيل غير صحيح أو غير موجود." };
                }

                DataRow delCouponRow = dtDelCoupon.Rows[0];
                bool isDelCouponActive = delCouponRow["IsActive"] != DBNull.Value && Convert.ToBoolean(delCouponRow["IsActive"]);
                DateTime delExpiryDate = Convert.ToDateTime(delCouponRow["ExpiryDate"]);
                int delDiscountType = Convert.ToInt32(delCouponRow["DiscountType"]);

                if (!isDelCouponActive || delExpiryDate < DateTime.Now)
                {
                    return new { success = false, error = "عفواً، كوبون التوصيل منتهي الصلاحية أو غير فعال حالياً." };
                }

                // التحقق من أن الكوبون من نوع دليفري (0)
                if (delDiscountType != 0)
                {
                    return new { success = false, error = "عفواً، هذا الكوبون مخصص لخصم المطاعم والأصناف وليس لمصاريف التوصيل." };
                }

                // التحقق من شرط الحد الأدنى المالي على مصاريف التوصيل الحالية المرسلة للدالة
                decimal delMinOrderAmount = Convert.ToDecimal(delCouponRow["MinOrderAmount"]);
                decimal currentDeliveryCost = Convert.ToDecimal(deliveryCost);

                if (currentDeliveryCost < delMinOrderAmount)
                {
                    return new { success = false, error = string.Format("عفواً، الحد الأدنى لمصاريف الشحن لتشغيل هذا الكوبون هو {0} ج.م.", delMinOrderAmount) };
                }

                deliveryDiscountPercent = Convert.ToDecimal(delCouponRow["DiscountPercentage"]);
            }
            // ==========================================

            // تمرير القيم والنسب المئوية المستخرجة (أو 0 في حال انعدامها) لـ دالة الحفظ مع الحفاظ على ترتيب البرامترات الأصلي
            SaveOrderAndDetails(dt, Convert.ToDecimal(deliveryCost), paymentMethod, scheduledTime, contactMethod, orderType, payerPhone, orderCoupon, deliveryCoupon, paymentProofBase64, orderDiscountPercent, deliveryDiscountPercent);

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
    public static string SaveBase64AsImage(string base64String)
    {
        // التحقق من أن المتغير ليس فارغاً أو نال تفادياً لانهيار الكود
        if (string.IsNullOrEmpty(base64String))
        {
            return null;
        }

        try
        {
            // 1. تنظيف النص: إذا كان النص قادماً من الجافا سكريبت عبر FileReader فقد يحتوي على الرأس (Data URI)
            // نقوم بفصل الرأس والاحتفاظ بالنص النقي فقط
            if (base64String.Contains(","))
            {
                base64String = base64String.Split(',')[1];
            }

            // 2. معالجة الفراغات: أحياناً أثناء النقل عبر الأجاكس تتحول علامات الـ "+" إلى مسافات فارغة
            // هذا التبديل يضمن عدم حدوث خطأ "Invalid length for a Base-64 char array"
            base64String = base64String.Replace(" ", "+");

            // 3. تحويل نص الـ Base64 النقي إلى مصفوفة بايتات (byte array)
            byte[] imageBytes = Convert.FromBase64String(base64String);

            // 4. توليد اسم فريد للصورة وتحديد مسار الحفظ داخل مجلد الـ uploads بالموقع
            string fileName = Guid.NewGuid().ToString() + ".png";
            string folderPath = HttpContext.Current.Server.MapPath("~/ar/images/receipts/");

            // التأكد من أن المجلد موجود على السيرفر، وإذا لم يكن موجوداً نقوم بإنشائه فوراً
            
            // المسار الكامل للحفظ الفيزيائي على القرص الصلب
            string fullPath =System.IO.Path.Combine(folderPath, fileName);

            // 5. كتابة البايتات وحفظ الملف نهائياً
            System.IO.File.WriteAllBytes(fullPath, imageBytes);

            // إرجاع المسار النسبي لحفظه في قاعدة البيانات (مثل جدول Orders في عمود إثبات الدفع)
            return "ar/images/receipts/" + fileName;
        }
        catch (Exception ex)
        {
            // تسجيل الخطأ أو التعامل معه حسب طبيعة النظام لديك
            string errorLog = ex.Message;
            return null;
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

    public static void SaveOrderAndDetails(DataTable dt, decimal deliveryCost, string paymentMethod, string scheduledTime, string contactMethod, string orderType, string payerPhone,string orderCoupon,string deliveryCoupon,string paymentProofBase64,decimal orderDiscountPercent, decimal deliveryDiscountPercent)
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

        object transferPhotoValue = DBNull.Value;

        if (!string.IsNullOrEmpty(paymentProofBase64))
        {
            // استدعاء الدالة وحفظ الصورة أولاً قبل الدخول في تفاصيل برامترات قاعدة البيانات
            transferPhotoValue = SaveBase64AsImage(paymentProofBase64);
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
                INSERT INTO Orders (Address_id, Odate, DeliveryCost, delivered,paymentMethod,contactMethod,DeliveryMethod,WalletNumber,ODTime,TransferPhoto,CoponDiscountR,CoponDiscountD,CoponDiscountRU,CoponDiscountDU)
                VALUES (@Address_id, GETDATE(), @DeliveryCost, 0,@paymentMethod,@contactMethod,@DeliveryMethod,@WalletNumber,@ODTime,@TransferPhoto,@CoponDiscountR,@CoponDiscountD,@CoponDiscountRU,@CoponDiscountDU);
                SELECT SCOPE_IDENTITY();", con, trans))
                {
                    cmd.Parameters.AddWithValue("@Address_id", dt.Rows[0]["addid"]);
                    cmd.Parameters.AddWithValue("@DeliveryCost", deliveryCost);
                    cmd.Parameters.AddWithValue("@paymentMethod", paymentMethodInt);
                    cmd.Parameters.AddWithValue("@contactMethod", contactMethodInt);
                    cmd.Parameters.AddWithValue("@DeliveryMethod", DeliveryMethodInt);
                    cmd.Parameters.AddWithValue("@WalletNumber", string.IsNullOrEmpty(payerPhone) ? (object)DBNull.Value : payerPhone);
                    cmd.Parameters.AddWithValue("@TransferPhoto", transferPhotoValue);
                    cmd.Parameters.AddWithValue("@CoponDiscountR", orderDiscountPercent);
                    cmd.Parameters.AddWithValue("@CoponDiscountD", deliveryDiscountPercent);
                    cmd.Parameters.AddWithValue("@CoponDiscountRU", string.IsNullOrEmpty(orderCoupon) ? (object)DBNull.Value : orderCoupon);
                    cmd.Parameters.AddWithValue("@CoponDiscountDU", string.IsNullOrEmpty(deliveryCoupon) ? (object)DBNull.Value : deliveryCoupon);
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