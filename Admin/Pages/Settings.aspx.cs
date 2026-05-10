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
using System.IO;
using DMS;

public partial class Admin_Pages_Settings : System.Web.UI.Page
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
        if (!IsPostBack)
        {
            Centers Center = new Centers();
            Center.LoadByPrimaryKey(1);
            txtName.Text = Center.Name;
            txtFace.Text = Center.Facebook;
            txtYouTube.Text = Center.Youyube;
            txtTwitter.Text = Center.Twitter;
            txtGooglePlus.Text = Center.GooglePlus;
            txtLinkedIn.Text = Center.LinkedIn;
            txtInstgram.Text = Center.Instgram;
            txtPhone.Text = Center.Phone;
            txtMobile.Text = Center.Mobile;
            txtFax.Text = Center.Fax;
            txtEmail.Text = Center.Mail;
            txtMailBox.Text = Center.MailBox;
            txtAddress.Text = Center.Addresse;
            txtmap.Text = Center.Map;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        Centers Center = new Centers();
        Center.LoadByPrimaryKey(1);
        Center.Name = txtName.Text.Trim();
        Center.Facebook = txtFace.Text.Trim();
        Center.Youyube = txtYouTube.Text.Trim();
        Center.Twitter = txtTwitter.Text.Trim();
        Center.GooglePlus = txtGooglePlus.Text.Trim();
        Center.LinkedIn = txtLinkedIn.Text.Trim();
        Center.Instgram = txtInstgram.Text.Trim();
        Center.Phone = txtPhone.Text.Trim();
        Center.Mobile = txtMobile.Text.Trim();
        Center.Fax = txtFax.Text.Trim();
        Center.Mail = txtEmail.Text.Trim();
        Center.MailBox = txtMailBox.Text.Trim();
        Center.Addresse = txtAddress.Text.Trim();
        Center.Map = txtmap.Text;
        Center.Save();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);



    }
}
