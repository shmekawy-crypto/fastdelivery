using DMS;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class Ar_MasterPages_MasterPage : System.Web.UI.MasterPage
{
    public string CurrentLang = "ar"; // كل مرة تعيد تحميل الصفحة تبدأ من عربي
    public string CurrentDir = "rtl";
    public bool isFirstOrder = false;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Users usr = new Users();
            usr.Where.Email.Operator = WhereParameter.Operand.Equal;
            usr.Where.Email.Value = HttpContext.Current.User.Identity.Name;
            usr.Query.Load();
            if (usr.RowCount > 0)
            {
                vw_Users vUsr = new vw_Users();
                vUsr.Where.Id.Operator = WhereParameter.Operand.Equal;
                vUsr.Where.Id.Value = usr.Id;
                vUsr.Query.Load();
                if (vUsr.RowCount > 0)
                {
                    // Direct SQL count query to prevent view caching and latency
                    using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["Conn"].ConnectionString))
                    {
                        conn.Open();
                        using (SqlCommand sqlCmd = new SqlCommand(
                            "SELECT COUNT(*) FROM dbo.Orders O INNER JOIN dbo.Addresses A ON O.Address_id = A.ID WHERE A.UserID = @UserID", conn))
                        {
                            sqlCmd.Parameters.AddWithValue("@UserID", usr.Id);
                            int orderCount = Convert.ToInt32(sqlCmd.ExecuteScalar());
                            if (orderCount == 0)
                            {
                                isFirstOrder = true;
                            }
                        }
                    }
                }
            }
        }
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
