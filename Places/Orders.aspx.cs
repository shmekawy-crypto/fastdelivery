using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Places_MasterPages_Orders : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["PlaceID"] == null) Response.Redirect("Login.aspx");
        if (!IsPostBack)
        {
            txtDateFrom.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtDateTo.Text = DateTime.Now.ToString("yyyy-MM-dd");
            BindOrders();
        }
    }

    private void BindOrders()
    {
        int pid = Convert.ToInt32(Session["PlaceID"]);
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            // تم تعديل وعاء الحسبة المالية ليشمل الإضافات التابعة للمطعم الحالي بدقة متناهية
            string sql = @"SELECT O.*, U.Name as CustomerName, A.Mobile, A.Build, A.FloorNo, A.adepartmentNo,
                          (A.AddressName + ' - ' + A.StreetName) as FullAddress,
                          ISNULL((SELECT SUM(od2.Amount * od2.Price) FROM Order_Details od2 JOIN MenuItems_Sizes mis2 ON od2.MenuItems_id = mis2.id JOIN MenuItems mi2 ON mis2.MenuItems_id = mi2.id WHERE od2.Order_id = O.id AND mi2.PlaceID = @pid), 0) +
                          ISNULL((SELECT SUM(ode.Amount * ode.Price) FROM Order_Details_Extras ode JOIN Order_Details od3 ON ode.Order_Detail_id = od3.id JOIN MenuItems_Sizes mis3 ON od3.MenuItems_id = mis3.id JOIN MenuItems mi3 ON mis3.MenuItems_id = mi3.id WHERE od3.Order_id = O.id AND mi3.PlaceID = @pid), 0) as TotalOrderCash
                          FROM Orders O JOIN Addresses A ON O.Address_id = A.ID JOIN Users U ON A.UserID = U.Id
                          WHERE EXISTS (SELECT 1 FROM Order_Details OD JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
                                      JOIN MenuItems MI ON MIS.MenuItems_id = MI.id WHERE OD.Order_id = O.id AND MI.PlaceID = @pid)
                          AND CAST(O.Odate as DATE) BETWEEN @from AND @to";

            if (!string.IsNullOrEmpty(txtSearch.Text)) sql += " AND (U.Name LIKE @s OR A.Mobile LIKE @s)";

            switch (ddlStatus.SelectedValue)
            {
                case "Pending": sql += " AND O.Accepted = 0"; break;
                case "Accepted": sql += " AND O.Accepted = 1 AND O.Prepared = 0"; break;
                case "InWay": sql += " AND O.Prepared = 1 AND O.InWay = 1 AND O.Delivered = 0"; break;
                case "Delivered": sql += " AND O.Delivered = 1"; break;
            }
            sql += " ORDER BY O.Odate DESC";

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@pid", pid);
            cmd.Parameters.AddWithValue("@from", txtDateFrom.Text);
            cmd.Parameters.AddWithValue("@to", txtDateTo.Text);
            if (!string.IsNullOrEmpty(txtSearch.Text)) cmd.Parameters.AddWithValue("@s", "%" + txtSearch.Text.Trim() + "%");

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable(); da.Fill(dt);
            gvOrders.DataSource = dt; gvOrders.DataBind();
            lblTotalOrders.Text = dt.Rows.Count.ToString();
        }
    }

    protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (string.IsNullOrEmpty(e.CommandArgument.ToString())) return;
        int id = Convert.ToInt32(e.CommandArgument);
        int pid = Convert.ToInt32(Session["PlaceID"]);

        if (e.CommandName == "ShowDetails")
        {
            lblModalOrderID.Text = id.ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // تم إزالة أعمدة بيانات العميل من الاستعلام والاكتفاء بالتوقيت والمبالغ وأوقات التحضير لحماية الخصوصية
                SqlCommand cmd = new SqlCommand(@"SELECT O.Odate, 
                                                 ISNULL((SELECT SUM(od2.Amount * od2.Price) FROM Order_Details od2 JOIN MenuItems_Sizes mis2 ON od2.MenuItems_id = mis2.id JOIN MenuItems mi2 ON mis2.MenuItems_id = mi2.id WHERE od2.Order_id = O.id AND mi2.PlaceID = @pid), 0) +
                                                 ISNULL((SELECT SUM(ode.Amount * ode.Price) FROM Order_Details_Extras ode JOIN Order_Details od3 ON ode.Order_Detail_id = od3.id JOIN MenuItems_Sizes mis3 ON od3.MenuItems_id = mis3.id JOIN MenuItems mi3 ON mis3.MenuItems_id = mi3.id WHERE od3.Order_id = O.id AND mi3.PlaceID = @pid), 0) as GrandTotal,
                                                 ISNULL((SELECT MAX(mi4.PrepearMin) FROM Order_Details od4 JOIN MenuItems_Sizes mis4 ON od4.MenuItems_id = mis4.id JOIN MenuItems mi4 ON mis4.MenuItems_id = mi4.id WHERE od4.Order_id = O.id AND mi4.PlaceID = @pid), 0) as MaxPrepareTime
                                                 FROM Orders O
                                                 WHERE O.id = @oid", conn);
                cmd.Parameters.AddWithValue("@oid", id);
                cmd.Parameters.AddWithValue("@pid", pid);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblModalOrderTime.Text = Convert.ToDateTime(dr["Odate"]).ToString("yyyy-MM-dd HH:mm");
                    lblGrandTotal.Text = Convert.ToDecimal(dr["GrandTotal"]).ToString("N2");

                    // تمرير أعلى وقت تحضير للواجهة لعرضه برمجياً
                    int maxPrepTime = Convert.ToInt32(dr["MaxPrepareTime"]);
                    lblTotalPrepareTime.Text = maxPrepTime > 0 ? maxPrepTime.ToString() : "---";
                }
                dr.Close();
                conn.Close();
            }
            BindOrderItems(id);
            upModal.Update();
            ScriptManager.RegisterStartupScript(this, GetType(), "Pop", "setTimeout(function() { $('#detailsModal').modal('show'); }, 100);", true);
        }
        else if (e.CommandName == "NextStep")
        {
            // تم إيقاف تغيير الحالة من المطعم بناءً على رغبتك، وتم الإبقاء على الهيكل فارغاً لمنع الأخطاء البرمجية
        }
    }

    private void UpdateStatus(int id)
    {
        // تم إيقاف اتخاذ الإجراء بناءً على طلبك
    }

    private void BindOrderItems(int id)
    {
        int pid = Convert.ToInt32(Session["PlaceID"]);
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            // الكويري المطور لجلب وقت تحضير الصنف مع الحسبة المالية شاملة أسعار الإضافات التابعة له
            SqlDataAdapter da = new SqlDataAdapter(@"SELECT OD.id as DetailID, MI.Name as ItemName, S.Name as SizeName, OD.Amount, OD.Price, MI.PrepearMin,
                                                   (OD.Amount * OD.Price) + ISNULL((SELECT SUM(ode.Amount * ode.Price) FROM Order_Details_Extras ode WHERE ode.Order_Detail_id = OD.id), 0) as LineTotal
                                                   FROM Order_Details OD JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
                                                   JOIN MenuItems MI ON MIS.MenuItems_id = MI.id JOIN Sizes S ON MIS.Size_id = S.id
                                                   WHERE OD.Order_id = @id AND MI.PlaceID = @pid", conn);
            da.SelectCommand.Parameters.AddWithValue("@id", id);
            da.SelectCommand.Parameters.AddWithValue("@pid", pid);
            DataTable dt = new DataTable(); da.Fill(dt); gvOrderItems.DataSource = dt; gvOrderItems.DataBind();
        }
    }

    protected void gvOrderItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            int detailId = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "DetailID"));
            Repeater rpt = (Repeater)e.Row.FindControl("rptExtras");
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(@"SELECT E.Name as ExtraName, ODE.Amount, ODE.Price FROM Order_Details_Extras ODE
                                                       JOIN MenuItems_Extras MIE ON ODE.MenuItems_Extra_id = MIE.id
                                                       JOIN Extras E ON MIE.Extra_id = E.id WHERE ODE.Order_Detail_id = @did", conn);
                da.SelectCommand.Parameters.AddWithValue("@did", detailId);
                DataTable dt = new DataTable(); da.Fill(dt); rpt.DataSource = dt; rpt.DataBind();
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e) { BindOrders(); }

    public string GetNextStepText(object acc, object prep, object way, object del)
    {
        if (Convert.ToBoolean(del)) return "تم التسليم للعميل";
        if (Convert.ToBoolean(way)) return "خرج للتوصيل مع المندوب";
        if (Convert.ToBoolean(prep)) return "تم تحضيره في المطبخ";
        if (Convert.ToBoolean(acc)) return "تم قبوله وبانتظار التحضير";
        return "بانتظار قبول الإدارة";
    }

    public string GetNextStepClass(object acc, object prep, object way, object del)
    {
        if (Convert.ToBoolean(del)) return "badge-success text-white";
        if (Convert.ToBoolean(way)) return "badge-info text-white";
        if (Convert.ToBoolean(prep)) return "badge-warning text-dark";
        if (Convert.ToBoolean(acc)) return "badge-primary text-white";
        return "badge-danger text-white";
    }
}