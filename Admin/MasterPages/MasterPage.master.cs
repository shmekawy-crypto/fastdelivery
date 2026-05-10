using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;
using DMS;


public partial class Admin_MasterPages_MasterPage : System.Web.UI.MasterPage
{

    public string GetCurrentPageName()
    {
        string sPath = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
        System.IO.FileInfo oInfo = new System.IO.FileInfo(sPath);
        string sRet = oInfo.Name;
        return sRet;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Centers Center = new Centers();
        Center.LoadAll();
        ltfcompany.Text = ltcompany2.Text = Center.Name;
        if (Session["uid"] != null)
        {
            AUsers user = new AUsers();
            user.LoadByPrimaryKey(Convert.ToInt32(Session["uid"].ToString()));
            lblUname.Text = user.Name;
            UPages page = new UPages();
            page.Where.Name.Operator = WhereParameter.Operand.Equal;
            page.Where.Name.Value = GetCurrentPageName();
            if (page.Query.Load())
            {

                Privilages privilage = new Privilages();
                privilage.Where.Role_id.Operator = WhereParameter.Operand.Equal;
                privilage.Where.Role_id.Value = user.Role_id;
                privilage.Where.Page_id.Operator = WhereParameter.Operand.Equal;
                privilage.Where.Page_id.Value = page.Id;
                if (privilage.Query.Load())
                {
                    if (!privilage.W)
                    {
                        if (privilage.R)
                        {
                            Panel1.Enabled = false;
                        }
                        else
                        {
                            Response.Redirect("~/admin/pages/login.aspx");
                        }

                    }

                }
                else
                {

                    Response.Redirect("~/admin/pages/login.aspx");
                }
            }
        }

    }
}
