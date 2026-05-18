using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS;

public partial class Admin_Pages_Orders : System.Web.UI.Page
{
    // تعريف الكونكشن سترينج مرة واحدة لتسهيل الاستخدام
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // قيم افتراضية للتواريخ
            txtFromDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtToDate.Text = DateTime.Today.ToString("yyyy-MM-dd");

            LoadGovs();
            BindOrders();
        }
    }

    #region "وظائف المندوب الجديدة"

    // دالة لجلب قائمة المناديب
    private DataTable GetActiveDrivers()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            // تأكد أن جدول DeliveryMen موجود عندك وبهذه الأعمدة
            string sql = "SELECT DriverID, DriverName FROM DeliveryMen WHERE Status = 2";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
    }

    // حدث ربط البيانات لملء قائمة المناديب داخل الجريد فيو
    protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddl = (DropDownList)e.Row.FindControl("ddlDrivers");
            if (ddl != null)
            {
                ddl.DataSource = GetActiveDrivers();
                ddl.DataTextField = "DriverName";
                ddl.DataValueField = "DriverID";
                ddl.DataBind();

                // تحديد المندوب الحالي للطلب إذا كان موجوداً
                DataRowView drv = (DataRowView)e.Row.DataItem;
                if (drv["DriverID"] != DBNull.Value)
                {
                    string driverID = drv["DriverID"].ToString();
                    if (ddl.Items.FindByValue(driverID) != null)
                    {
                        ddl.SelectedValue = driverID;
                    }
                }
            }
        }
    }

    // حدث تغيير المندوب من القائمة المنسدلة
    protected void ddlDrivers_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        GridViewRow row = (GridViewRow)ddl.NamingContainer;
        string orderId = ((HiddenField)row.FindControl("hfOrderID")).Value;
        string driverId = ddl.SelectedValue;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "UPDATE Orders SET DriverID=@DriverID WHERE ID=@ID";
            SqlCommand cmd = new SqlCommand(sql, con);

            if (driverId == "0")
                cmd.Parameters.AddWithValue("@DriverID", DBNull.Value);
            else
                cmd.Parameters.AddWithValue("@DriverID", driverId);

            cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(orderId));
            con.Open();
            cmd.ExecuteNonQuery();
        }
    }

    #endregion

    #region "أكواد تحويل الثوابت الرقمية إلى نصوص"

    public string GetPaymentMethodName(object methodId)
    {
        if (methodId == DBNull.Value || methodId == null) return "غير محدد";

        switch (methodId.ToString())
        {
            case "1": return "كاش (عند الاستلام)";
            case "2": return "محفظة إلكترونية";
            case "3": return "فيزا / ماستر كارد";
            default: return "أخرى";
        }
    }

    public string GetContactMethodName(object methodId)
    {
        if (methodId == DBNull.Value || methodId == null) return "غير محدد";

        switch (methodId.ToString())
        {
            case "1": return "اتصال هاتفي";
            case "2": return "واتساب";
            case "3": return "عبر التطبيق";
            default: return "أخرى";
        }
    }

    #endregion

    #region "أكوادك الأصلية كما هي"


    protected void Accepted_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkbox = (CheckBox)sender;
        string z = ((HiddenField)((GridViewRow)chkbox.NamingContainer).FindControl("hfAccepted")).Value;
        using (SqlConnection con = new SqlConnection(connStr))
        {
            // إذا تم التفعيل نضع الوقت، إذا ألغي نجعله NULL
            string sql = "UPDATE Orders SET Accepted=@Accepted, AcceptedTime = (CASE WHEN @Accepted = 1 THEN GETDATE() ELSE NULL END) WHERE ID=@ID";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@Accepted", chkbox.Checked);
            cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(z));
            con.Open(); cmd.ExecuteNonQuery();
        }
        BindOrders(); // تحديث الجدول فوراً لرؤية الوقت
    }

    protected void Prepared_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkbox = (CheckBox)sender;
        string z = ((HiddenField)((GridViewRow)chkbox.NamingContainer).FindControl("hfPrepared")).Value;
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "UPDATE Orders SET Prepared=@Prepared, PreparedTime = (CASE WHEN @Prepared = 1 THEN GETDATE() ELSE NULL END) WHERE ID=@ID";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@Prepared", chkbox.Checked);
            cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(z));
            con.Open(); cmd.ExecuteNonQuery();
        }
        BindOrders();
    }

    protected void InWay_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkbox = (CheckBox)sender;
        string z = ((HiddenField)((GridViewRow)chkbox.NamingContainer).FindControl("hfInWay")).Value;
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "UPDATE Orders SET InWay=@InWay, InWayTime = (CASE WHEN @InWay = 1 THEN GETDATE() ELSE NULL END) WHERE ID=@ID";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@InWay", chkbox.Checked);
            cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(z));
            con.Open(); cmd.ExecuteNonQuery();
        }
        BindOrders();
    }

    protected void CheckBox1_CheckedChanged(object sender, EventArgs e) // تم التسليم
    {
        CheckBox chkbox = (CheckBox)sender;
        string z = ((HiddenField)((GridViewRow)chkbox.NamingContainer).FindControl("hf")).Value;
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string sql = "UPDATE Orders SET Delivered=@Delivered, DeliveredTime = (CASE WHEN @Delivered = 1 THEN GETDATE() ELSE NULL END) WHERE ID=@ID";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@Delivered", chkbox.Checked);
            cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(z));
            con.Open(); cmd.ExecuteNonQuery();
        }
        BindOrders();
    }
    private void LoadGovs()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT id, Name FROM Gov", conn);
            SqlDataReader dr = cmd.ExecuteReader();
            ddlGov.DataSource = dr;
            ddlGov.DataTextField = "Name";
            ddlGov.DataValueField = "id";
            ddlGov.DataBind();
            ddlGov.Items.Insert(0, new System.Web.UI.WebControls.ListItem("الكل", "0"));
            dr.Close();
        }
        LoadAreas(0);
    }

    private void LoadAreas(int govId)
    {
        ddlArea.Items.Clear();
        ddlArea.Items.Add(new System.Web.UI.WebControls.ListItem("الكل", "0"));
        if (govId > 0)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT id, Name FROM Areas WHERE gov_id=@govId", conn);
                cmd.Parameters.AddWithValue("@govId", govId);
                SqlDataReader dr = cmd.ExecuteReader();
                ddlArea.DataSource = dr;
                ddlArea.DataTextField = "Name";
                ddlArea.DataValueField = "id";
                ddlArea.DataBind();
                dr.Close();
            }
        }
    }

    protected void ddlGov_SelectedIndexChanged(object sender, EventArgs e)
    {
        int govId = int.Parse(ddlGov.SelectedValue);
        LoadAreas(govId);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindOrders();
    }
    public string GetDeliveryMethodName(object methodId)
    {
        if (methodId == DBNull.Value || methodId == null) return "غير محدد";

        switch (methodId.ToString())
        {
            case "1": return "توصيل للمنزل (Delivery)";
            case "2": return "استلام من المطعم (Takeaway)";
            default: return "أخرى";
        }
    }
    private void BindOrders()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            // الكويري يجمع بيانات الطلب، العميل، العنوان، ويحسب الإجماليات وأوقات التنفيذ مع الحقول المضافة حديثاً
            string query = @"
            SELECT 
                o.id, 
                u.Name + ' ' + u.Lname AS UserName,
                g.Name AS Gov, 
                a.Name AS Area,
                SUM(od.Amount * od.Price) AS total,
                o.DeliveryCost,
                SUM(od.Amount * od.Price) + o.DeliveryCost AS net,
                o.Delivered, 
                o.Accepted, 
                o.Prepared, 
                o.InWay, 
                o.DriverID,
                o.AcceptedTime, 
                o.PreparedTime, 
                o.InWayTime, 
                o.DeliveredTime,
                DATEDIFF(MINUTE, o.AcceptedTime, o.DeliveredTime) AS TotalTime,
                CAST(o.Odate AS DATE) AS Odate,
                o.DeliveryMethod,
                o.PaymentMethod,
                o.TransferPhoto,
                o.WalletNumber,
                ISNULL(o.CoponDiscountR, 0) AS CoponDiscountR,
                ISNULL(o.CoponDiscountD, 0) AS CoponDiscountD,
                o.CoponDiscountRU,
                o.CoponDiscountDU,
                o.ODTime,
                o.ContactMethod
            FROM Orders o
            INNER JOIN Order_Details od ON o.id = od.Order_id
            INNER JOIN Addresses addr ON o.Address_id = addr.ID
            INNER JOIN Users u ON addr.UserID = u.Id
            INNER JOIN Areas a ON addr.Area_id = a.id
            INNER JOIN Gov g ON a.gov_id = g.id
            WHERE 1=1";

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;

            // فلترة التاريخ
            DateTime fromDate, toDate;
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate)) fromDate = DateTime.Today;
            if (!DateTime.TryParse(txtToDate.Text, out toDate)) toDate = DateTime.Today;

            query += " AND CAST(o.Odate AS DATE) >= @FromDate AND CAST(o.Odate AS DATE) <= @ToDate";
            cmd.Parameters.AddWithValue("@FromDate", fromDate);
            cmd.Parameters.AddWithValue("@ToDate", toDate);

            // فلترة حالة التسليم
            if (ddlDelivered.SelectedValue != "-1")
            {
                query += " AND o.Delivered = @Delivered";
                cmd.Parameters.AddWithValue("@Delivered", ddlDelivered.SelectedValue == "1");
            }

            // فلترة المحافظة والمنطقة
            int govId = int.Parse(ddlGov.SelectedValue);
            if (govId > 0) { query += " AND g.id = @GovId"; cmd.Parameters.AddWithValue("@GovId", govId); }

            int areaId = int.Parse(ddlArea.SelectedValue);
            if (areaId > 0) { query += " AND a.id = @AreaId"; cmd.Parameters.AddWithValue("@AreaId", areaId); }

            // تجميع البيانات وترتيبها بالأحدث
            query += @"
            GROUP BY 
                o.id, u.Name, u.Lname, g.Name, a.Name, o.DeliveryCost, 
                o.Delivered, o.Accepted, o.Prepared, o.InWay, o.DriverID, 
                o.AcceptedTime, o.PreparedTime, o.InWayTime, o.DeliveredTime, o.Odate,
                o.PaymentMethod, o.TransferPhoto, o.WalletNumber, o.CoponDiscountR,
                o.CoponDiscountD, o.CoponDiscountRU, o.CoponDiscountDU, o.ODTime, o.ContactMethod,o.DeliveryMethod
            ORDER BY o.id DESC";

            cmd.CommandText = query;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvOrders.DataSource = dt;
            gvOrders.DataBind();

            lblCount.Text = dt.Rows.Count.ToString();

            // تحديث آخر ID للطلبات الجديدة
            if (dt.Rows.Count > 0)
            {
                object maxId = dt.Compute("Max(id)", "");
                hfLastOrderId.Value = maxId.ToString();
            }
        }
    }
    protected void tmrNewOrders_Tick(object sender, EventArgs e)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = "SELECT ISNULL(MAX(id), 0) FROM Orders";
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();
            int latestIdInDb = Convert.ToInt32(cmd.ExecuteScalar());
            int lastDisplayedId = Convert.ToInt32(hfLastOrderId.Value);

            if (latestIdInDb > lastDisplayedId)
            {
                BindOrders();
                ScriptManager.RegisterStartupScript(this, GetType(), "NewOrderAlert", "alertNewOrder();", true);
            }
        }
    }

    protected void gvOrders_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
    {
        gvOrders.PageIndex = e.NewPageIndex;
        BindOrders();
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "#MyPopup", "$('body').removeClass('modal-open');$('.modal-backdrop').remove();$('#MyPopup2').hide();", true);
    }

    protected void gvOrders_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ShowDetails")
        {
            ltcontent.Text = "<iframe src='OrdersDetails.aspx?id=" + e.CommandArgument + "' width='100%' height='100%' style='overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px' height='100%' width='100%'></iframe>";
            string title = "تفاصيل الطلب";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup('" + title + "');", true);
            return;
        }
    }
    #endregion
}