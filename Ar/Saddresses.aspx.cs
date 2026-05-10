using DMS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Services;

[System.Web.Script.Services.ScriptService]
public partial class Ar_Saddresses : System.Web.UI.Page
{
    [WebMethod]
    public static List<string> GetAddresses(string prefix)
    {
        List<string> addresses = new List<string>();
        string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            var user = System.Web.HttpContext.Current.User;
           
                Users usr = new Users();
                usr.Where.Email.Operator = WhereParameter.Operand.Equal;
                usr.Where.Email.Value = user.Identity.Name;
                usr.Query.Load();
            
            string query = "SELECT TOP 10 AddressName FROM Addresses WHERE UserID="+ usr.Id+ "";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
             
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    addresses.Add(dr["AddressName"].ToString());
                }
            }
        }

        return addresses;
    }
}
