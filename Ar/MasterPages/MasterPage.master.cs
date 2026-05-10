using DMS;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Ar_MasterPages_MasterPage : System.Web.UI.MasterPage
{
    public string CurrentLang = "ar"; // كل مرة تعيد تحميل الصفحة تبدأ من عربي
    public string CurrentDir = "rtl";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Centers center = new Centers();
            center.LoadAll();
            dlSocial.DataSource = center.DefaultView;
            dlSocial.DataBind();
            string pageName = System.IO.Path.GetFileName(Request.Url.AbsolutePath).ToLower();
            if ((pageName == "default.aspx" || string.IsNullOrEmpty(pageName)) && !string.IsNullOrEmpty(center.Mobile))
            {
                // تنظيف الرقم من أي مسافات أو علامات + لضمان عمل الرابط صح
                string cleanNumber = center.Mobile.Replace(" ", "").Replace("+", "");

                // ربط الرقم بالرابط الخاص بالواتساب
                lnkWhatsApp.NavigateUrl = "https://wa.me/" + cleanNumber;
                lnkWhatsApp.Visible = true;
            }
            else
            {
                // لو مفيش رقم في القاعدة أو مش في الصفحة الرئيسية نخفي الأيقونة
                lnkWhatsApp.Visible = false;
            }
        }
        HttpCookie langCookie = Request.Cookies["lang"];
        string lang = (langCookie != null && !string.IsNullOrEmpty(langCookie.Value)) ? langCookie.Value : "ar";

        switch (lang)
        {
            case "en":
                CurrentLang = "en";
                CurrentDir = "ltr";
                ltscript.Text = "<script id='dynamic - texts' src='js/texts_en.js'></script>";
                break;
            case "ru":
                CurrentLang = "ru";
                CurrentDir = "ltr";

                ltscript.Text = "<script id='dynamic - texts' src='js/texts_ru.js'></script>";
                break;
            default:
                CurrentLang = "ar";
                CurrentDir = "rtl";

                ltscript.Text = "<script id='dynamic - texts' src='js/texts_ar.js'></script>";
                break;
        }
    }
  
    protected void lblogout_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Response.Redirect("default.aspx");
    }
}
