using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Places_MasterPages_Dashboard : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["PlaceID"] == null) Response.Redirect("Login.aspx");

        if (!IsPostBack)
        {
            int placeId = Convert.ToInt32(Session["PlaceID"]);
            lblPlaceName.Text = Session["PlaceName"] != null ? Session["PlaceName"].ToString() : "المطعم";
            LoadStatistics(placeId);
        }
    }

    private void LoadStatistics(int placeId)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            // 1. الإحصائيات العامة (تعديل: استخدام Odate بدل CreatedAt)
            string sqlSummary = @"SELECT 
                    ISNULL(SUM(OD.Price * OD.Amount), 0) as TotalSales,
                    COUNT(DISTINCT O.id) as TotalOrders,
                    (SELECT COUNT(*) FROM MenuItems WHERE PlaceID = @pid) as MenuCount
                    FROM Order_Details OD 
                    JOIN Orders O ON OD.Order_id = O.id
                    JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
                    JOIN MenuItems MI ON MIS.MenuItems_id = MI.id
                    WHERE MI.PlaceID = @pid AND O.Accepted = 1";

            SqlCommand cmd = new SqlCommand(sqlSummary, conn);
            cmd.Parameters.AddWithValue("@pid", placeId);
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                lblTotalSales.Text = Convert.ToDecimal(dr["TotalSales"]).ToString("N0");
                lblTotalOrders.Text = dr["TotalOrders"].ToString();
                lblMenuCount.Text = dr["MenuCount"].ToString();
            }
            dr.Close();

            // 2. الأصناف الأكثر مبيعاً
            string sqlTopItems = @"SELECT TOP 5 
                    MI.Name as ItemName, 
                    SUM(OD.Amount) as QuantitySold,
                    SUM(OD.Price * OD.Amount) as TotalRevenue
                    FROM Order_Details OD
                    JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
                    JOIN MenuItems MI ON MIS.MenuItems_id = MI.id
                    JOIN Orders O ON OD.Order_id = O.id
                    WHERE MI.PlaceID = @pid AND O.Accepted = 1
                    GROUP BY MI.Name ORDER BY QuantitySold DESC";

            SqlDataAdapter da = new SqlDataAdapter(sqlTopItems, conn);
            da.SelectCommand.Parameters.AddWithValue("@pid", placeId);
            DataTable dtTop = new DataTable();
            da.Fill(dtTop);
            gvItemsStats.DataSource = dtTop;
            gvItemsStats.DataBind();

            var names = dtTop.AsEnumerable().Select(r => "'" + r["ItemName"].ToString() + "'").ToArray();
            var values = dtTop.AsEnumerable().Select(r => r["QuantitySold"].ToString()).ToArray();
            hfTopItemsLabels.Value = "[" + string.Join(",", names) + "]";
            hfTopItemsValues.Value = "[" + string.Join(",", values) + "]";

            // 3. إحصائيات المناطق (التعديل الجوهري: الربط عبر جدول Addresses)
            string sqlRegions = @"
                DECLARE @GrandTotal DECIMAL(18,2);
                SELECT @GrandTotal = SUM(OD.Price * OD.Amount) 
                FROM Order_Details OD JOIN Orders O ON OD.Order_id = O.id
                JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
                JOIN MenuItems MI ON MIS.MenuItems_id = MI.id
                WHERE MI.PlaceID = @pid AND O.Accepted = 1;

                SELECT 
                    ISNULL(A.Name, 'غير محدد') as RegionName,
                    SUM(OD.Price * OD.Amount) as TotalSales,
                    CAST((SUM(OD.Price * OD.Amount) / NULLIF(@GrandTotal, 0)) * 100 AS DECIMAL(10,1)) as Percentage
                FROM Order_Details OD
                JOIN Orders O ON OD.Order_id = O.id
                JOIN Addresses AD ON O.Address_id = AD.ID
                JOIN Areas A ON AD.Area_id = A.id
                JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
                JOIN MenuItems MI ON MIS.MenuItems_id = MI.id
                WHERE MI.PlaceID = @pid AND O.Accepted = 1
                GROUP BY A.Name
                ORDER BY TotalSales DESC";

            SqlDataAdapter daReg = new SqlDataAdapter(sqlRegions, conn);
            daReg.SelectCommand.Parameters.AddWithValue("@pid", placeId);
            DataTable dtReg = new DataTable();
            daReg.Fill(dtReg);
            gvRegionStats.DataSource = dtReg;
            gvRegionStats.DataBind();

            var regNames = dtReg.AsEnumerable().Select(r => "'" + r["RegionName"].ToString() + "'").ToArray();
            var regValues = dtReg.AsEnumerable().Select(r => r["Percentage"].ToString()).ToArray();
            hfRegionLabels.Value = "[" + string.Join(",", regNames) + "]";
            hfRegionValues.Value = "[" + string.Join(",", regValues) + "]";

            // 4. مبيعات الأسبوع (استخدام Odate)
            LoadWeeklySales(placeId, conn);
        }
    }

    private void LoadWeeklySales(int placeId, SqlConnection conn)
    {
        string sqlWeekly = @"
            SELECT 
                DATEPART(dw, O.Odate) as DayNum,
                SUM(OD.Price * OD.Amount) as DailyTotal
            FROM Order_Details OD
            JOIN Orders O ON OD.Order_id = O.id
            JOIN MenuItems_Sizes MIS ON OD.MenuItems_id = MIS.id
            JOIN MenuItems MI ON MIS.MenuItems_id = MI.id
            WHERE MI.PlaceID = @pid AND O.Odate >= DATEADD(day, -7, GETDATE()) AND O.Accepted = 1
            GROUP BY DATEPART(dw, O.Odate)
            ORDER BY DayNum";

        SqlCommand cmd = new SqlCommand(sqlWeekly, conn);
        cmd.Parameters.AddWithValue("@pid", placeId);
        DataTable dtWeek = new DataTable();
        using (SqlDataAdapter da = new SqlDataAdapter(cmd)) { da.Fill(dtWeek); }

        decimal[] weekData = new decimal[7];
        foreach (DataRow row in dtWeek.Rows)
        {
            int dayIndex = Convert.ToInt32(row["DayNum"]) - 1;
            if (dayIndex >= 0 && dayIndex < 7) weekData[dayIndex] = Convert.ToDecimal(row["DailyTotal"]);
        }
        hfSalesData.Value = "[" + string.Join(",", weekData) + "]";
    }
}