using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Ar_OrderDetails : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["orderId"] != null)
            {
                int orderId;
                if (int.TryParse(Request.QueryString["orderId"], out orderId))
                {
                    LoadOrderFullData(orderId);
                }
            }
            else { Response.Redirect("Default.aspx"); }
        }
    }

    private void LoadOrderFullData(int orderId)
    {
        string lang = Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName;
        string govCol = lang == "en" ? "g.NameEn" : (lang == "ru" ? "g.NameRu" : "g.Name");
        string areaCol = lang == "en" ? "ar.NameEn" : (lang == "ru" ? "ar.NameRu" : "ar.Name");

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sqlMaster = string.Format(@"SELECT o.Odate, o.Accepted, o.Prepared, o.InWay, o.Delivered, 
                                     o.AcceptedTime, o.PreparedTime, o.InWayTime, o.DeliveredTime,
                                     o.DeliveryCost, a.Mobile, {0} as GovName, {1} as AreaName,
                                     a.StreetName, a.Build,
                                     d.DriverName, d.Phone as DriverPhone,
                                     o.DeliveryMethod, o.PaymentMethod, o.WalletNumber, o.ODTime, o.ContactMethod,
                                     o.CoponDiscountR, o.CoponDiscountD
                                     FROM dbo.Orders o 
                                     INNER JOIN dbo.Addresses a ON o.Address_id = a.ID 
                                     INNER JOIN dbo.Areas ar ON a.Area_id = ar.id
                                     INNER JOIN dbo.Gov g ON ar.gov_id = g.id
                                     LEFT JOIN dbo.DeliveryMen d ON o.DriverID = d.DriverID
                                     WHERE o.id = @oid", govCol, areaCol);

            SqlCommand cmd = new SqlCommand(sqlMaster, conn);
            cmd.Parameters.AddWithValue("@oid", orderId);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                litOrderId.Text = orderId.ToString();
                litOrderDate.Text = Convert.ToDateTime(dr["Odate"]).ToString("dd/MM/yyyy hh:mm tt");
                litCustomerPhone.Text = dr["Mobile"].ToString();
                decimal deliveryCost = Convert.ToDecimal(dr["DeliveryCost"]);
                litDeliveryFee.Text = deliveryCost.ToString("N2");

                litFullAddress.Text = String.Format("{0} - {1} - {2} {3} - {4} {5}",
                    dr["GovName"], dr["AreaName"], GetGlobalResourceObject("texts", "Street"), dr["StreetName"], GetGlobalResourceObject("texts", "Build"), dr["Build"]);

                bool isAccepted = dr["Accepted"] != DBNull.Value && Convert.ToBoolean(dr["Accepted"]);
                bool isPrepared = dr["Prepared"] != DBNull.Value && Convert.ToBoolean(dr["Prepared"]);
                bool isInWay = dr["InWay"] != DBNull.Value && Convert.ToBoolean(dr["InWay"]);
                bool isDev = dr["Delivered"] != DBNull.Value && Convert.ToBoolean(dr["Delivered"]);

                // قراءة قيم الكوبونات كنسب مئوية من قاعدة البيانات
                decimal coponDiscountR = dr["CoponDiscountR"] != DBNull.Value ? Convert.ToDecimal(dr["CoponDiscountR"]) : 0;
                decimal coponDiscountD = dr["CoponDiscountD"] != DBNull.Value ? Convert.ToDecimal(dr["CoponDiscountD"]) : 0;

                if (dr["DriverName"] != DBNull.Value && !string.IsNullOrEmpty(dr["DriverName"].ToString()))
                {
                    phDriverInfo.Visible = true;
                    litDriverName.Text = dr["DriverName"].ToString();
                    litDriverPhone.Text = dr["DriverPhone"].ToString();
                }
                else { phDriverInfo.Visible = false; }

                if (dr["DeliveryMethod"] != DBNull.Value)
                {
                    int delMethod = Convert.ToInt32(dr["DeliveryMethod"]);
                    phDeliveryMethodInfo.Visible = true;
                    if (delMethod == 1) litDeliveryMethod.Text = lang == "en" ? "Home Delivery" : "توصيل للمنزل";
                    else if (delMethod == 2) litDeliveryMethod.Text = lang == "en" ? "Pickup from Store" : "استلام من المتجر";
                }
                else { phDeliveryMethodInfo.Visible = false; }

                if (dr["PaymentMethod"] != DBNull.Value)
                {
                    int payMethod = Convert.ToInt32(dr["PaymentMethod"]);
                    phPaymentMethodInfo.Visible = true;
                    if (payMethod == 1) litPaymentMethod.Text = lang == "en" ? "Cash on Delivery" : "الدفع عند الاستلام (كاش)";
                    else if (payMethod == 2) litPaymentMethod.Text = lang == "en" ? "Online / Wallet" : "محفظة إلكترونية / أونلاين";

                    if (dr["WalletNumber"] != DBNull.Value && !string.IsNullOrEmpty(dr["WalletNumber"].ToString()))
                    {
                        phWalletInfo.Visible = true;
                        litWalletNumber.Text = dr["WalletNumber"].ToString();
                    }
                    else { phWalletInfo.Visible = false; }
                }
                else { phPaymentMethodInfo.Visible = false; phWalletInfo.Visible = false; }

                if (dr["ODTime"] != DBNull.Value)
                {
                    phODTimeInfo.Visible = true;
                    litODTime.Text = Convert.ToDateTime(dr["ODTime"]).ToString("dd/MM/yyyy hh:mm tt");
                }
                else { phODTimeInfo.Visible = false; }

                if (dr["ContactMethod"] != DBNull.Value)
                {
                    int conMethod = Convert.ToInt32(dr["ContactMethod"]);
                    phContactMethodInfo.Visible = true;
                    if (conMethod == 1) litContactMethod.Text = lang == "en" ? "Phone Call" : "اتصال هاتفي";
                    else if (conMethod == 2) litContactMethod.Text = lang == "en" ? "WhatsApp" : "واتساب";
                }
                else { phContactMethodInfo.Visible = false; }

                dr.Close();

                // أولاً: جلب عدد الأماكن (المطاعم) الفريدة المشاركة في هذا الأوردر لتطبيق الشرط الهام
                SqlCommand cmdCountPlaces = new SqlCommand(@"
                    SELECT COUNT(DISTINCT mi.PlaceID) 
                    FROM dbo.Order_Details od
                    INNER JOIN dbo.MenuItems_Sizes mzs ON od.MenuItems_id = mzs.id
                    INNER JOIN dbo.MenuItems mi ON mzs.MenuItems_id = mi.id
                    WHERE od.Order_id = @oid", conn);
                cmdCountPlaces.Parameters.AddWithValue("@oid", orderId);
                int totalPlacesInOrder = Convert.ToInt32(cmdCountPlaces.ExecuteScalar());

                // جلب توقيت قاعدة البيانات الحالي
                SqlCommand cmdDbTime = new SqlCommand("SELECT AcceptedTime, PreparedTime, InWayTime, GETDATE() AS CurrentDbTime FROM dbo.Orders WHERE id = @oid", conn);
                cmdDbTime.Parameters.AddWithValue("@oid", orderId);
                DataTable dtDbTimes = new DataTable();
                using (SqlDataAdapter daTime = new SqlDataAdapter(cmdDbTime))
                {
                    daTime.Fill(dtDbTimes);
                }

                DateTime currentDbTime = Convert.ToDateTime(dtDbTimes.Rows[0]["CurrentDbTime"]);

                // -------------------------------------------------------------------------------------
                // نظام العداد والتحول التلقائي لا يعمل إلا إذا كانت أصناف الأوردر تابعة لمكان واحد فقط (totalPlacesInOrder == 1)
                // -------------------------------------------------------------------------------------
                if (totalPlacesInOrder == 1)
                {
                    // 1. إدارة عداد التحضير (مقبول ولم يحضر بعد)
                    if (isAccepted && !isPrepared && dtDbTimes.Rows[0]["AcceptedTime"] != DBNull.Value)
                    {
                        SqlCommand cmdMaxPrep = new SqlCommand("SELECT ISNULL(MAX(PrepearMin), 0) FROM dbo.Order_Details WHERE Order_id = @oid", conn);
                        cmdMaxPrep.Parameters.AddWithValue("@oid", orderId);
                        int maxPrepMin = Convert.ToInt32(cmdMaxPrep.ExecuteScalar());

                        if (maxPrepMin > 0)
                        {
                            DateTime acceptedTime = Convert.ToDateTime(dtDbTimes.Rows[0]["AcceptedTime"]);
                            DateTime targetEndTime = acceptedTime.AddMinutes(maxPrepMin);
                            TimeSpan remainingTime = targetEndTime - currentDbTime;

                            if (remainingTime.TotalSeconds > 0)
                            {
                                phPrepCountdown.Visible = true;
                                litCountdownLabel.Text = "الوقت المتبقي لانتهاء تحضير الطلب: ";
                                hfSecondsLeft.Value = ((int)remainingTime.TotalSeconds).ToString();
                            }
                            else
                            {
                                phPrepCountdown.Visible = false;
                                DateTime computedPrepTime = acceptedTime.AddMinutes(maxPrepMin);

                                SqlCommand cmdUpdateToInWay = new SqlCommand(@"UPDATE dbo.Orders 
                                    SET Prepared = 1, PreparedTime = @pTime, 
                                        InWay = 1, InWayTime = @pTime 
                                    WHERE id = @oid", conn);
                                cmdUpdateToInWay.Parameters.AddWithValue("@oid", orderId);
                                cmdUpdateToInWay.Parameters.AddWithValue("@pTime", computedPrepTime);
                                cmdUpdateToInWay.ExecuteNonQuery();

                                isPrepared = true;
                                isInWay = true;
                            }
                        }
                    }

                    // 2. إدارة عداد التوصيل تلقائياً وتبديل العبارة (في الطريق ولم يسلم بعد)
                    if (isAccepted && isPrepared && isInWay && !isDev)
                    {
                        SqlCommand cmdMaxDelivery = new SqlCommand("SELECT ISNULL(MAX(DeliveredTime), 0) FROM dbo.Order_Details WHERE Order_id = @oid", conn);
                        cmdMaxDelivery.Parameters.AddWithValue("@oid", orderId);
                        int maxDeliveryMin = Convert.ToInt32(cmdMaxDelivery.ExecuteScalar());

                        if (maxDeliveryMin > 0 && dtDbTimes.Rows[0]["InWayTime"] != DBNull.Value)
                        {
                            DateTime inWayTime = Convert.ToDateTime(dtDbTimes.Rows[0]["InWayTime"]);
                            DateTime targetDeliveryEndTime = inWayTime.AddMinutes(maxDeliveryMin);
                            TimeSpan remainingDeliveryTime = targetDeliveryEndTime - currentDbTime;

                            if (remainingDeliveryTime.TotalSeconds > 0)
                            {
                                phPrepCountdown.Visible = true;
                                litCountdownLabel.Text = "الوقت المتبقي لانتهاء توصيل الطلب: ";
                                hfSecondsLeft.Value = ((int)remainingDeliveryTime.TotalSeconds).ToString();
                            }
                            else
                            {
                                phPrepCountdown.Visible = false;
                                DateTime computedDeliveredTime = inWayTime.AddMinutes(maxDeliveryMin);

                                SqlCommand cmdUpdateToDelivered = new SqlCommand(@"UPDATE dbo.Orders 
                                SET Delivered = 1, DeliveredTime = @dTime 
                                WHERE id = @oid", conn);
                                cmdUpdateToDelivered.Parameters.AddWithValue("@oid", orderId);
                                cmdUpdateToDelivered.Parameters.AddWithValue("@dTime", computedDeliveredTime);
                                cmdUpdateToDelivered.ExecuteNonQuery();

                                isDev = true;
                            }
                        }
                    }
                }
                else
                {
                    // إذا كان الأوردر مجمع من أكثر من مطعم، يتم إخفاء كرت العداد تماماً ليعتمد على الإدارة اليدوية للحالات
                    phPrepCountdown.Visible = false;
                }

                if (isDev)
                    litStatusHeader.Text = GetGlobalResourceObject("texts", "StatusDelivered").ToString();
                else if (isInWay)
                    litStatusHeader.Text = lang == "en" ? "In Way" : "في الطريق إليك";
                else if (isPrepared)
                    litStatusHeader.Text = lang == "en" ? "Prepared" : "تم التحضير";
                else
                    litStatusHeader.Text = GetGlobalResourceObject("texts", "StatusProcessing").ToString();

                SqlCommand cmdTimes = new SqlCommand("SELECT AcceptedTime, PreparedTime, InWayTime, DeliveredTime FROM dbo.Orders WHERE id = @oid", conn);
                cmdTimes.Parameters.AddWithValue("@oid", orderId);
                DataTable dtTimes = new DataTable();
                using (SqlDataReader drTimes = cmdTimes.ExecuteReader())
                {
                    dtTimes.Load(drTimes);
                }

                object accTime = dtTimes.Rows.Count > 0 ? dtTimes.Rows[0]["AcceptedTime"] : DBNull.Value;
                object prepTime = dtTimes.Rows.Count > 0 ? dtTimes.Rows[0]["PreparedTime"] : DBNull.Value;
                object wayTime = dtTimes.Rows.Count > 0 ? dtTimes.Rows[0]["InWayTime"] : DBNull.Value;
                object devTime = dtTimes.Rows.Count > 0 ? dtTimes.Rows[0]["DeliveredTime"] : DBNull.Value;

                BuildFullStepper(isAccepted, isPrepared, isInWay, isDev, accTime, prepTime, wayTime, devTime);

                string placeNameCol = lang == "en" ? "p.NameEn" : (lang == "ru" ? "p.NameRu" : "p.Name");
                string sqlPlaces = string.Format(@"SELECT DISTINCT p.id, {0} as PlaceName FROM dbo.Places p 
                                   INNER JOIN dbo.MenuItems mi ON p.id = mi.PlaceID 
                                   INNER JOIN dbo.MenuItems_Sizes mzs ON mi.id = mzs.MenuItems_id
                                   INNER JOIN dbo.Order_Details od ON mzs.id = od.MenuItems_id 
                                   WHERE od.Order_id = @oid", placeNameCol);

                SqlDataAdapter da = new SqlDataAdapter(sqlPlaces, conn);
                da.SelectCommand.Parameters.AddWithValue("@oid", orderId);
                DataTable dtPlaces = new DataTable();
                da.Fill(dtPlaces);

                rptPlaces.DataSource = dtPlaces;
                rptPlaces.DataBind();

                // حساب المجموع الفرعي للأصناف والإضافات معاً قبل الخصم
                SqlCommand cmdTotal = new SqlCommand(@"
                    SELECT 
                    (ISNULL((SELECT SUM(Amount * Price) FROM Order_Details WHERE Order_id = @oid), 0) + 
                     ISNULL((SELECT SUM(ode.Amount * ode.Price) FROM Order_Details_Extras ode INNER JOIN Order_Details od ON ode.Order_Detail_id = od.id WHERE od.Order_id = @oid), 0))", conn);

                cmdTotal.Parameters.AddWithValue("@oid", orderId);
                decimal subTotal = Convert.ToDecimal(cmdTotal.ExecuteScalar());
                litSubTotal.Text = subTotal.ToString("N2");

                // حساب القيم المالية الفعلية المستقطعة من الخصم المئوي
                decimal restaurantDiscountValue = 0;
                decimal deliveryDiscountValue = 0;

                if (coponDiscountR > 0)
                {
                    restaurantDiscountValue = subTotal * (coponDiscountR / 100.0m);
                    phRestaurantDiscount.Visible = true;
                    litRestPercent.Text = coponDiscountR.ToString("0.##");
                    litRestDiscountValue.Text = restaurantDiscountValue.ToString("N2");
                }
                else
                {
                    phRestaurantDiscount.Visible = false;
                }

                if (coponDiscountD > 0)
                {
                    deliveryDiscountValue = deliveryCost * (coponDiscountD / 100.0m);
                    phDeliveryDiscount.Visible = true;
                    litDelivPercent.Text = coponDiscountD.ToString("0.##");
                    litDelivDiscountValue.Text = deliveryDiscountValue.ToString("N2");
                }
                else
                {
                    phDeliveryDiscount.Visible = false;
                }

                // الحسبة النهائية الصافية: (المجموع الفرعي - قيمة خصم المطعم) + (تكلفة التوصيل - قيمة خصم التوصيل)
                decimal finalItemsCost = Math.Max(0, subTotal - restaurantDiscountValue);
                decimal finalDeliveryCost = Math.Max(0, deliveryCost - deliveryDiscountValue);
                decimal grandTotal = finalItemsCost + finalDeliveryCost;

                litGrandTotal.Text = grandTotal.ToString("N2");
            }
        }
    }

    protected void tmrRefresh_Tick(object sender, EventArgs e)
    {
        if (Request.QueryString["orderId"] != null)
        {
            int orderId;
            if (int.TryParse(Request.QueryString["orderId"], out orderId))
            {
                LoadOrderFullData(orderId);
            }
        }
    }

    private void RefreshOrderStatus(int orderId)
    {
        LoadOrderFullData(orderId);
    }

    private void BuildFullStepper(bool acc, bool prep, bool way, bool dev, object accTime, object prepTime, object wayTime, object devTime)
    {
        string s1 = "completed", s2 = acc ? "completed" : "active", s3 = prep ? "completed" : (acc ? "active" : "");
        string s4 = way ? "completed" : (prep ? "active" : ""), s5 = dev ? "completed" : (way ? "active" : "");

        string t1 = "", t2 = "", t3 = "", t4 = "", t5 = "";

        t2 = accTime != DBNull.Value ? "<span class='step-time-label'>" + Convert.ToDateTime(accTime).ToString("hh:mm tt") + "</span>" : "";
        t3 = prepTime != DBNull.Value ? "<span class='step-time-label'>" + Convert.ToDateTime(prepTime).ToString("hh:mm tt") + "</span>" : "";
        t4 = wayTime != DBNull.Value ? "<span class='step-time-label'>" + Convert.ToDateTime(wayTime).ToString("hh:mm tt") + "</span>" : "";
        t5 = devTime != DBNull.Value ? "<span class='step-time-label'>" + Convert.ToDateTime(devTime).ToString("hh:mm tt") + "</span>" : "";

        litStepperHtml.Text = String.Format(@"
            <div class='step-item {0}'><div class='step-icon'><i class='fas fa-hourglass-start'></i></div><div class='step-label'>{5}</div></div>
            <div class='step-item {1}'><div class='step-icon'><i class='fas fa-thumbs-up'></i></div><div class='step-label'>{6}{11}</div></div>
            <div class='step-item {2}'><div class='step-icon'><i class='fas fa-utensils'></i></div><div class='step-label'>{7}{12}</div></div>
            <div class='step-item {3}'><div class='step-icon'><i class='fas fa-motorcycle'></i></div><div class='step-label'>{8}{13}</div></div>
            <div class='step-item {4}'><div class='step-icon'><i class='fas fa-check-double'></i></div><div class='step-label'>{9}{14}</div></div>",
            s1, s2, s3, s4, s5,
            GetGlobalResourceObject("texts", "StepWait"), GetGlobalResourceObject("texts", "StepAcc"),
            GetGlobalResourceObject("texts", "StepPrep"), GetGlobalResourceObject("texts", "StepWay"),
            GetGlobalResourceObject("texts", "StepDev"),
            t1, t2, t3, t4, t5);
    }

    protected void rptPlaces_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int placeId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "id"));
            Repeater rptItems = (Repeater)e.Item.FindControl("rptItems");
            string lang = Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName;

            string nameCol = lang == "en" ? "mi.NameEn" : (lang == "ru" ? "mi.NameRu" : "mi.Name");
            string extraCol = lang == "en" ? "ex.NameEn" : (lang == "ru" ? "ex.NameRu" : "ex.Name");

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sqlItems = string.Format(@"
                    SELECT 
                        od.id AS OrderDetailID, od.Notes, od.PrepearMin,
                        {0} as ItemName, 
                        mi.PhotoUrl, 
                        od.Amount, 
                        od.Price,
                        0 AS IsExtra
                    FROM dbo.Order_Details od 
                    INNER JOIN dbo.MenuItems_Sizes mzs ON od.MenuItems_id = mzs.id
                    INNER JOIN dbo.MenuItems mi ON mzs.MenuItems_id = mi.id
                    WHERE od.Order_id = @oid AND mi.PlaceID = @pid

                    UNION ALL

                    SELECT 
                        od.id AS OrderDetailID, od.Notes, 0 AS PrepearMin,
                        {1} as ItemName, 
                        '' AS PhotoUrl, 
                        ode.Amount, 
                        ode.Price,
                        1 AS IsExtra
                    FROM dbo.Order_Details_Extras ode
                    INNER JOIN dbo.Order_Details od ON ode.Order_Detail_id = od.id
                    INNER JOIN dbo.MenuItems_Sizes mzs ON od.MenuItems_id = mzs.id
                    INNER JOIN dbo.MenuItems mi ON mzs.MenuItems_id = mi.id
                    INNER JOIN dbo.MenuItems_Extras me ON ode.MenuItems_Extra_id = me.id
                    INNER JOIN dbo.Extras ex ON me.Extra_id = ex.id
                    WHERE od.Order_id = @oid AND mi.PlaceID = @pid
                    
                    ORDER BY OrderDetailID ASC, IsExtra ASC", nameCol, extraCol);

                SqlDataAdapter da = new SqlDataAdapter(sqlItems, conn);
                da.SelectCommand.Parameters.AddWithValue("@oid", Request.QueryString["orderId"]);
                da.SelectCommand.Parameters.AddWithValue("@pid", placeId);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptItems.DataSource = dt;
                rptItems.DataBind();
            }
        }
    }
}