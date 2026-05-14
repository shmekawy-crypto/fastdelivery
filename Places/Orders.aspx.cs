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
            string sql = @"SELECT O.*, U.Name as CustomerName, A.Mobile, A.Build, A.FloorNo, A.adepartmentNo,
                          (A.AddressName + ' - ' + A.StreetName) as FullAddress,
                          ISNULL((SELECT SUM(Amount * Price) FROM Order_Details WHERE Order_id = O.id), 0) as TotalOrderCash
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

        if (e.CommandName == "ShowDetails")
        {
            lblModalOrderID.Text = id.ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"SELECT O.Odate, U.Name, A.Mobile, A.Build, A.FloorNo, A.adepartmentNo, A.StreetName, A.AddressName,
                                                 ISNULL((SELECT SUM(Amount * Price) FROM Order_Details WHERE Order_id = O.id), 0) as GrandTotal
                                                 FROM Orders O JOIN Addresses A ON O.Address_id = A.ID JOIN Users U ON A.UserID = U.Id
                                                 WHERE O.id = @oid", conn);
                cmd.Parameters.AddWithValue("@oid", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblModalOrderTime.Text = Convert.ToDateTime(dr["Odate"]).ToString("yyyy-MM-dd HH:mm");
                    lblCustName.Text = dr["Name"].ToString();
                    lblCustPhone.Text = dr["Mobile"].ToString();
                    lblModalAddress.Text = string.Format("{0}, {1}, عمارة {2}, دور {3}, شقة {4}", dr["AddressName"], dr["StreetName"], dr["Build"], dr["FloorNo"], dr["adepartmentNo"]);
                    lblGrandTotal.Text = Convert.ToDecimal(dr["GrandTotal"]).ToString("N2");
                }
                conn.Close();
            }
            BindOrderItems(id);
            upModal.Update();
            ScriptManager.RegisterStartupScript(this, GetType(), "Pop", "setTimeout(function() { $('#detailsModal').modal('show'); }, 100);", true);
        }
        else if (e.CommandName == "NextStep")
        {
            UpdateStatus(id); BindOrders(); upOrders.Update();
        }
    }

    private void UpdateStatus(int id)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT Accepted, Prepared, InWay, Delivered FROM Orders WHERE id = @id", conn);
            cmd.Parameters.AddWithValue("@id", id);
            SqlDataReader dr = cmd.ExecuteReader();
            string field = "", timeField = "";
            if (dr.Read())
            {
                if (!Convert.ToBoolean(dr["Accepted"])) { field = "Accepted"; timeField = "AcceptedTime"; }
                else if (!Convert.ToBoolean(dr["Prepared"])) { field = "Prepared"; timeField = "PreparedTime"; }
                else if (!Convert.ToBoolean(dr["InWay"])) { field = "InWay"; timeField = "InWayTime"; }
                else if (!Convert.ToBoolean(dr["Delivered"])) { field = "Delivered"; timeField = "DeliveredTime"; }
            }
            dr.Close();
            if (field != "")
            {
                string up = string.Format("UPDATE Orders SET {0} = 1, {1} = GETDATE() WHERE id = @id", field, timeField);
                SqlCommand cmdUp = new SqlCommand(up, conn);
                cmdUp.Parameters.AddWithValue("@id", id); // تم إصلاح الخطأ هنا
                cmdUp.ExecuteNonQuery();
            }
            conn.Close();
        }
    }

    private void BindOrderItems(int id)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            SqlDataAdapter da = new SqlDataAdapter(@"SELECT OD.id as DetailID, MI.Name as ItemName, S.Name as SizeName, OD.Amount, OD.Price 
                                                   FROM Order_Details OD JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
                                                   JOIN MenuItems MI ON MIS.MenuItems_id = MI.id JOIN Sizes S ON MIS.Size_id = S.id
                                                   WHERE OD.Order_id = " + id, conn);
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
                SqlDataAdapter da = new SqlDataAdapter(@"SELECT E.Name as ExtraName, ODE.Amount FROM Order_Details_Extras ODE
                                                       JOIN MenuItems_Extras MIE ON ODE.MenuItems_Extra_id = MIE.id
                                                       JOIN Extras E ON MIE.Extra_id = E.id WHERE ODE.Order_Detail_id = " + detailId, conn);
                DataTable dt = new DataTable(); da.Fill(dt); rpt.DataSource = dt; rpt.DataBind();
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e) { BindOrders(); }

    public string GetNextStepText(object acc, object prep, object way, object del)
    {
        if (Convert.ToBoolean(del)) return "تم التسليم";
        if (!Convert.ToBoolean(acc)) return "قبول الطلب";
        if (!Convert.ToBoolean(prep)) return "تم التحضير";
        if (!Convert.ToBoolean(way)) return "خرج للتوصيل";
        return "تأكيد التسليم";
    }

    public string GetNextStepClass(object acc, object prep, object way, object del)
    {
        if (Convert.ToBoolean(del)) return "btn-default disabled";
        if (!Convert.ToBoolean(acc)) return "btn-primary";
        if (!Convert.ToBoolean(prep)) return "btn-warning";
        return "btn-info";
    }
}