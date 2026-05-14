using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Delivery_CurrentTask : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["DriverID"] == null) { Response.Redirect("Login.aspx"); return; }
        if (!IsPostBack) { ViewState["Filter"] = 0; BindTasks(); }
    }

    private void BindTasks()
    {
        int driverId = Convert.ToInt32(Session["DriverID"]);
        int status = Convert.ToInt32(ViewState["Filter"]);

        using (SqlConnection con = new SqlConnection(connStr))
        {
            con.Open();
            // تحديث العدادات
            SqlCommand cmdCount = new SqlCommand("SELECT COUNT(*) FROM Orders WHERE DriverID=@did AND Delivered=@st", con);
            cmdCount.Parameters.AddWithValue("@did", driverId);
            cmdCount.Parameters.AddWithValue("@st", 0);
            lblCountActive.Text = cmdCount.ExecuteScalar().ToString();
            cmdCount.Parameters["@st"].Value = 1;
            lblCountDone.Text = cmdCount.ExecuteScalar().ToString();

            // استعلام الأوردرات الرئيسي
            string sql = @"
                SELECT o.id, o.Odate, o.AcceptedTime, o.Prepared, o.InWay, o.DeliveredTime, o.DeliveryCost,
                u.Name as CustomerRealName, a.AddressName, a.Mobile, a.StreetName, a.Build, a.FloorNo, a.adepartmentNo, ar.Name as AreaName,
                (SELECT SUM(od2.Amount * od2.Price) FROM Order_Details od2 WHERE od2.Order_id = o.id) as TotalItemsPrice,
                ((SELECT SUM(od3.Amount * od3.Price) FROM Order_Details od3 WHERE od3.Order_id = o.id) + o.DeliveryCost) as GrandTotal,
                (SELECT MAX(mi.PrepearMin) FROM Order_Details od JOIN MenuItems_Sizes mis ON od.MenuItems_id = mis.id JOIN MenuItems mi ON mis.MenuItems_id = mi.id WHERE od.Order_id = o.id) as MaxPrepMin,
                (SELECT TOP 1 dz.DeliveredTime FROM DeliveryZones dz WHERE dz.Areas_id = a.Area_id AND dz.PlacesID IN (SELECT DISTINCT mi2.PlaceID FROM Order_Details od2 JOIN MenuItems_Sizes mis2 ON od2.MenuItems_id = mis2.id JOIN MenuItems mi2 ON mis2.MenuItems_id = mi2.id WHERE od2.Order_id = o.id)) as ZoneTime
                FROM Orders o 
                JOIN Addresses a ON o.Address_id = a.ID JOIN Areas ar ON a.Area_id = ar.id LEFT JOIN Users u ON a.UserID = u.Id
                WHERE o.DriverID = @did AND o.Delivered = @st";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@did", driverId);
            cmd.Parameters.AddWithValue("@st", status);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptOrders.DataSource = dt;
            rptOrders.DataBind();
            pnlEmpty.Visible = dt.Rows.Count == 0;
        }
    }

    protected void Filter_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        ViewState["Filter"] = btn.CommandArgument;
        btnActive.CssClass = "filter-btn" + (btn.CommandArgument == "0" ? " active" : "");
        btnDelivered.CssClass = "filter-btn" + (btn.CommandArgument == "1" ? " active" : "");
        BindTasks();
    }

    protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int orderId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "id"));
            Repeater rptPlaces = (Repeater)e.Item.FindControl("rptPlaces");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // جلب المطاعم المميزة في هذا الأوردر فقط
                string sql = @"SELECT DISTINCT p.id, p.Name, p.Address FROM Order_Details od 
                               JOIN MenuItems_Sizes mis ON od.MenuItems_id = mis.id 
                               JOIN MenuItems mi ON mis.MenuItems_id = mi.id 
                               JOIN Places p ON mi.PlaceID = p.id WHERE od.Order_id = @oid";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@oid", orderId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptPlaces.DataSource = dt;
                rptPlaces.DataBind();
            }
        }
    }

    protected void rptPlaces_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int placeId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "id"));

            // إصلاح الخطأ: الوصول الصحيح للأب (RepeaterItem الخاص بـ rptOrders)
            RepeaterItem outerItem = (RepeaterItem)e.Item.Parent.Parent;
            int orderId = Convert.ToInt32(DataBinder.Eval(outerItem.DataItem, "id"));

            Repeater rptItems = (Repeater)e.Item.FindControl("rptItems");
            Label lblPlaceTotal = (Label)e.Item.FindControl("lblPlaceTotal");

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // جلب أصناف المطعم المختار داخل الأوردر المختار
                string sql = @"SELECT mi.Name as ItemName, od.Amount, od.Price, (od.Amount * od.Price) as ItemTotal 
                               FROM Order_Details od JOIN MenuItems_Sizes mis ON od.MenuItems_id = mis.id 
                               JOIN MenuItems mi ON mis.MenuItems_id = mi.id 
                               WHERE od.Order_id = @oid AND mi.PlaceID = @pid";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@oid", orderId);
                cmd.Parameters.AddWithValue("@pid", placeId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                decimal subTotal = 0;
                foreach (DataRow row in dt.Rows) subTotal += Convert.ToDecimal(row["ItemTotal"]);
                lblPlaceTotal.Text = subTotal.ToString("N2");

                rptItems.DataSource = dt;
                rptItems.DataBind();
            }
        }
    }

    // دوال التحديث كما هي
    protected void btnInWay_Click(object sender, EventArgs e) { UpdateStatus(((Button)sender).CommandArgument, "UPDATE Orders SET InWay=1, InWayTime=GETDATE() WHERE id=@oid"); }
    protected void btnDelivered_Click(object sender, EventArgs e) { UpdateStatus(((Button)sender).CommandArgument, "UPDATE Orders SET Delivered=1, DeliveredTime=GETDATE(), InWay=0 WHERE id=@oid"); }

    private void UpdateStatus(string oid, string sql)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand(sql, con); cmd.Parameters.AddWithValue("@oid", oid);
            con.Open(); cmd.ExecuteNonQuery();
        }
        BindTasks();
    }
}