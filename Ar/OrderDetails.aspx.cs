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
            // تم إضافة LEFT JOIN مع جدول DeliveryMen لجلب بيانات المندوب
            string sqlMaster = string.Format(@"SELECT o.Odate, o.Accepted, o.Prepared, o.InWay, o.Delivered, 
                                     o.DeliveryCost, a.Mobile, {0} as GovName, {1} as AreaName,
                                     a.StreetName, a.Build,
                                     d.DriverName, d.Phone as DriverPhone 
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

                bool isInWay = dr["InWay"] != DBNull.Value && Convert.ToBoolean(dr["InWay"]);
                bool isDev = dr["Delivered"] != DBNull.Value && Convert.ToBoolean(dr["Delivered"]);

                litStatusHeader.Text = isDev ? GetGlobalResourceObject("texts", "StatusDelivered").ToString() : GetGlobalResourceObject("texts", "StatusProcessing").ToString();

                // إظهار بيانات المندوب إذا كان الطلب في الطريق ولم يتم تسليمه بعد
                if (isInWay && !isDev && dr["DriverName"] != DBNull.Value)
                {
                    phDriverInfo.Visible = true;
                    litDriverName.Text = dr["DriverName"].ToString();
                    litDriverPhone.Text = dr["DriverPhone"].ToString();
                }
                else
                {
                    phDriverInfo.Visible = false;
                }

                BuildFullStepper(
                    dr["Accepted"] != DBNull.Value && Convert.ToBoolean(dr["Accepted"]),
                    dr["Prepared"] != DBNull.Value && Convert.ToBoolean(dr["Prepared"]),
                    isInWay,
                    isDev
                );
            }
            dr.Close();

            string placeNameCol = lang == "en" ? "p.NameEn" : (lang == "ru" ? "p.NameRu" : "p.Name");
            string sqlPlaces = string.Format(@"SELECT DISTINCT p.id, {0} as PlaceName FROM dbo.Places p 
                               INNER JOIN dbo.MenuItems mi ON p.id = mi.PlaceID 
                               INNER JOIN dbo.Order_Details od ON mi.id = od.MenuItems_id 
                               WHERE od.Order_id = @oid", placeNameCol);

            SqlDataAdapter da = new SqlDataAdapter(sqlPlaces, conn);
            da.SelectCommand.Parameters.AddWithValue("@oid", orderId);
            DataTable dtPlaces = new DataTable();
            da.Fill(dtPlaces);

            rptPlaces.DataSource = dtPlaces;
            rptPlaces.DataBind();

            SqlCommand cmdTotal = new SqlCommand("SELECT ISNULL(SUM(Amount * Price), 0) FROM Order_Details WHERE Order_id = @oid", conn);
            cmdTotal.Parameters.AddWithValue("@oid", orderId);
            decimal subTotal = Convert.ToDecimal(cmdTotal.ExecuteScalar());
            litSubTotal.Text = subTotal.ToString("N2");
            litGrandTotal.Text = (subTotal + Convert.ToDecimal(litDeliveryFee.Text)).ToString("N2");
        }
    }

    protected void tmrRefresh_Tick(object sender, EventArgs e)
    {
        if (Request.QueryString["orderId"] != null)
        {
            int orderId;
            if (int.TryParse(Request.QueryString["orderId"], out orderId))
            {
                RefreshOrderStatus(orderId);
            }
        }
    }

    private void RefreshOrderStatus(int orderId)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            // تحديث الاستعلام ليشمل بيانات المندوب في التحديث التلقائي
            string sqlStatus = @"SELECT o.Accepted, o.Prepared, o.InWay, o.Delivered, 
                                 d.DriverName, d.Phone as DriverPhone 
                                 FROM dbo.Orders o
                                 LEFT JOIN dbo.DeliveryMen d ON o.DriverID = d.DriverID 
                                 WHERE o.id = @oid";
            SqlCommand cmd = new SqlCommand(sqlStatus, conn);
            cmd.Parameters.AddWithValue("@oid", orderId);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                bool isInWay = dr["InWay"] != DBNull.Value && Convert.ToBoolean(dr["InWay"]);
                bool isDev = dr["Delivered"] != DBNull.Value && Convert.ToBoolean(dr["Delivered"]);

                litStatusHeader.Text = isDev ? GetGlobalResourceObject("texts", "StatusDelivered").ToString() : GetGlobalResourceObject("texts", "StatusProcessing").ToString();

                // تحديث ظهور بيانات المندوب تلقائياً
                if (isInWay && !isDev && dr["DriverName"] != DBNull.Value)
                {
                    phDriverInfo.Visible = true;
                    litDriverName.Text = dr["DriverName"].ToString();
                    litDriverPhone.Text = dr["DriverPhone"].ToString();
                }
                else
                {
                    phDriverInfo.Visible = false;
                }

                BuildFullStepper(
                    dr["Accepted"] != DBNull.Value && Convert.ToBoolean(dr["Accepted"]),
                    dr["Prepared"] != DBNull.Value && Convert.ToBoolean(dr["Prepared"]),
                    isInWay,
                    isDev
                );
            }
        }
    }

    private void BuildFullStepper(bool acc, bool prep, bool way, bool dev)
    {
        string s1 = "completed", s2 = acc ? "completed" : "active", s3 = prep ? "completed" : (acc ? "active" : "");
        string s4 = way ? "completed" : (prep ? "active" : ""), s5 = dev ? "completed" : (way ? "active" : "");

        litStepperHtml.Text = String.Format(@"
            <div class='step-item {0}'><div class='step-icon'><i class='fas fa-hourglass-start'></i></div><div class='step-label'>{5}</div></div>
            <div class='step-item {1}'><div class='step-icon'><i class='fas fa-thumbs-up'></i></div><div class='step-label'>{6}</div></div>
            <div class='step-item {2}'><div class='step-icon'><i class='fas fa-utensils'></i></div><div class='step-label'>{7}</div></div>
            <div class='step-item {3}'><div class='step-icon'><i class='fas fa-motorcycle'></i></div><div class='step-label'>{8}</div></div>
            <div class='step-item {4}'><div class='step-icon'><i class='fas fa-check-double'></i></div><div class='step-label'>{9}</div></div>",
            s1, s2, s3, s4, s5,
            GetGlobalResourceObject("texts", "StepWait"), GetGlobalResourceObject("texts", "StepAcc"),
            GetGlobalResourceObject("texts", "StepPrep"), GetGlobalResourceObject("texts", "StepWay"),
            GetGlobalResourceObject("texts", "StepDev"));
    }

    protected void rptPlaces_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int placeId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "id"));
            Repeater rptItems = (Repeater)e.Item.FindControl("rptItems");
            string lang = Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName;
            string nameCol = lang == "en" ? "mi.NameEn" : (lang == "ru" ? "mi.NameRu" : "mi.Name");

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sqlItems = string.Format("SELECT {0} as ItemName, mi.PhotoUrl, od.Amount, od.Price FROM dbo.Order_Details od INNER JOIN dbo.MenuItems mi ON od.MenuItems_id = mi.id WHERE od.Order_id = @oid AND mi.PlaceID = @pid", nameCol);
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