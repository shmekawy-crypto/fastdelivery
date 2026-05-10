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
using System.Diagnostics;

using System.IO;

using System.Data.OleDb;
public partial class Admin_Pages_UsersR : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid();
    }

    private void BindGrid()
    {
        vw_Users User = new vw_Users();
        if (!string.IsNullOrEmpty(txtName.Text))
        {
            User.Query.OpenParenthesis();
            User.Where.Name.Operator = WhereParameter.Operand.Like;
            User.Where.Name.Value = "%" + txtName.Text + "%";

            User.Where.Email.Conjuction = WhereParameter.Conj.Or;
            User.Where.Email.Operator = WhereParameter.Operand.Equal;
            User.Where.Email.Value = txtName.Text;
            User.Query.CloseParenthesis();
        }
        if (User.Query.Load())
        {
            lblCount.Text = User.DefaultView.Table.Rows.Count.ToString();
            gvUsers.DataSource = User.DefaultView;
            gvUsers.DataBind();
            
        }
        else
        {

            lblCount.Text = "0";
            gvUsers.DataSource = null;
            gvUsers.DataBind();
        }
    }
    protected void gvUsersNot_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvUsers.PageIndex = e.NewPageIndex;
        BindGrid();
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        BindGrid();
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "#MyPopup", "$('body').removeClass('modal-open');$('.modal-backdrop').remove();$('#MyPopup2').hide();", true);

    }
    public string Helper2(object o)
    {
        TimeSpan timespan = new TimeSpan(((TimeSpan)o).Hours, ((TimeSpan)o).Minutes, ((TimeSpan)o).Seconds);
        DateTime time = DateTime.Today.Add(timespan);
        return time.ToString("tt hh:mm");
    }
    protected void LinkButton1_Click(object sender, EventArgs e)
    {


    }

    protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Addresses")
        {
            ltcontent.Text = "<iframe src='UserAddresses.aspx?UserID=" + e.CommandArgument + "' width='100%' height='100%' style='overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px' height='100%' width='100%'></iframe>";
            string title = "العناوين المسجلة";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup('" + title + "');", true);
            return;
        }
    }
    public override void VerifyRenderingInServerForm(Control control)
    {

    }
}
