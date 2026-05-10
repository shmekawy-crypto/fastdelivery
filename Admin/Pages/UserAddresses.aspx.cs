using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public partial class Admin_Pages_UserAddresses : System.Web.UI.Page
{
    public string AddressesJson = "[]";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string userIdStr = Request.QueryString["UserID"];
            if (!string.IsNullOrEmpty(userIdStr))
            {
                int userId = int.Parse(userIdStr);
                BindAddresses(userId);
            }
        }
    }

    private void BindAddresses(int userId)
    {
        string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string query = @"
                SELECT Addresses.ID, AddressName, Mobile, phone, StreetName, Build, FloorNo, adepartmentNo, Instructions,
                       Gov.Name AS Gov, Areas.Name AS Area, Latitude, Longitude, AType
                FROM Addresses
                INNER JOIN Areas ON Addresses.Area_id = Areas.id
                INNER JOIN Gov ON Areas.gov_id = Gov.id
                WHERE UserID = @UserID";

            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            da.SelectCommand.Parameters.AddWithValue("@UserID", userId);
            DataTable dt = new DataTable();
            da.Fill(dt);

            // Bind to Repeater
            rptAddresses.DataSource = dt;
            rptAddresses.DataBind();

            // جهز بيانات الإحداثيات للـ JS بطريقة متوافقة مع VS 2015
            var list = new List<Dictionary<string, object>>();
            foreach (DataRow row in dt.Rows)
            {
                var dict = new Dictionary<string, object>();
                dict["ID"] = row["ID"];
                dict["Latitude"] = row["Latitude"];
                dict["Longitude"] = row["Longitude"];
                dict["AddressName"] = row["AddressName"];
                list.Add(dict);
            }

            var serializer = new JavaScriptSerializer();
            AddressesJson = serializer.Serialize(list);
        }
    }

    public string GetATypeText(object value)
    {
        if (value == null) return "";
        int type = Convert.ToInt32(value);
        switch (type)
        {
            case 0: return "شقة";
            case 1: return "منزل";
            case 2: return "مكتب";
            default: return "غير معروف";
        }
    }
}
