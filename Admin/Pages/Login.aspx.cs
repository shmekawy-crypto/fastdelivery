using DMS;
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

public partial class Admin_Pages_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["uid"] = null;
            Session["center"] = null;
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        AUsers user = new AUsers();
        user.Where.Name.Operator = WhereParameter.Operand.Equal;
        user.Where.Name.Value = username.Text;
        user.Where.Password.Operator = WhereParameter.Operand.Equal;
        user.Where.Password.Value = pass.Text;
        user.Where.Visible.Operator = WhereParameter.Operand.Equal;
        user.Where.Visible.Value = 1;
        if (user.Query.Load())
        {
            Session["uid"] = user.Id;
            Response.Redirect(user.DefaultPage);

        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "دخول", "alert('كلمة المرور أو إسم المستخدم خطأ')", true);

        }
    }
}