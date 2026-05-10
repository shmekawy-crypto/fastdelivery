using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using DMS;

public partial class Admin_Pages_SideBar : System.Web.UI.UserControl
{

    protected void Switch_Click(object sender, EventArgs e)
    {
        Users user = new Users();

        //user.Where.Visible.Operator = WhereParameter.Operand.Equal;
        //user.Where.Visible.Value = 1;


        user.Query.Load();
        Session["uid"] = user.Id;
        Response.Redirect(Request.RawUrl);

    }



    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uid"] != null)
            {
                AUsers user = new AUsers();
                user.LoadByPrimaryKey(Convert.ToInt32(Session["uid"].ToString()));
                lblUname.Text = user.Name;
                Centers Center = new Centers();
                Center.LoadAll();
                //ltcompany2.Text = ltcompany3.Text = ltfcompany.Text = Center.Name;
                if (!Center.IsColumnNull(Centers.ColumnNames.Pic))
                {
                    logo2.ImageUrl = Center.Pic;

                }
                Privilages privilage = new Privilages();

                privilage.Query.OpenParenthesis();
                privilage.Where.R.Operator = WhereParameter.Operand.Equal;
                privilage.Where.R.Value = true;

                privilage.Where.W.Conjuction = WhereParameter.Conj.Or;
                privilage.Where.W.Operator = WhereParameter.Operand.Equal;
                privilage.Where.W.Value = true;
                privilage.Query.CloseParenthesis();
                privilage.Where.Role_id.Operator = WhereParameter.Operand.Equal;
                privilage.Where.Role_id.Value = user.Role_id;
                if (privilage.Query.Load())
                {
                    do
                    {
                        UPages page = new UPages();
                        page.LoadByPrimaryKey(privilage.Page_id);
                        ((HtmlAnchor)this.FindControl(page.Name.Replace(".aspx", ""))).Visible = true;
                        if (!page.IsColumnNull(UPages.ColumnNames.Parent))
                        {
                            ((HtmlAnchor)this.FindControl(page.Parent)).Visible = true;
                        }

                    } while (privilage.MoveNext());
                }
            }
            else
            {
               Response.Redirect("~/admin/pages/login.aspx");

            }

        }
    }
}
