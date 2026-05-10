using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Globalization;

public partial class Ar_Default : System.Web.UI.Page
{
    [WebMethod(EnableSession = true)]
    public static void SaveLocation(string coords)
    {
        HttpContext.Current.Session["UserLocation"] = coords;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
       
        if (User.Identity.IsAuthenticated)
        {
            Users usr = new Users();
            usr.Where.Email.Operator = WhereParameter.Operand.Equal;
            usr.Where.Email.Value = User.Identity.Name;
            usr.Query.Load();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Conn"].ConnectionString))
            {
                string sql = @"
        SELECT 
            a.ID, 
            a.StreetName + '(' + g.Name + ',' + ar.Name + ' ) ' AS Name,
            a.Build + ' , ' + a.adepartmentNo + ' , ' + a.FloorNo AS Description
        FROM Addresses a
        INNER JOIN Areas ar ON a.Area_id = ar.id
        INNER JOIN Gov g ON ar.gov_id = g.id where a.UserId=@user
        ORDER BY g.Name, ar.Name, a.StreetName";

                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@user", usr.Id);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                ddlAddress.DataSource = dt;
                ddlAddress.DataTextField = "Name";
                ddlAddress.DataValueField = "ID";
                ddlAddress.DataBind();                
            }
        }
        BindRepeaterC();
    }

    private void BindRepeaterC()
    {
        Categories cat = new Categories();
        cat.Where.Active.Operator = WhereParameter.Operand.Equal;
        cat.Where.Active.Value = true;
        cat.Query.Load();
        rptCategory.DataSource = cat.DefaultView.Table;
        rptCategory.DataBind();
    }
}