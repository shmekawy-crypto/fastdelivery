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
public partial class Pages_ChangePassword : System.Web.UI.Page
{
    
    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        AUsers user = new AUsers();
        user.LoadByPrimaryKey(Convert.ToInt32(Session["uid"].ToString()));

        if (user.Password == txtOldPass.Text)
        {
            user.Password = txtNewPass.Text;
            user.Save();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "معلومات", "alert('لقد تم تغيير كلمة المرور بنجاح')", true);

        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "خطأ", "alert('كلمة المرور القديمة خطأ')", true);

        }
    }
}
