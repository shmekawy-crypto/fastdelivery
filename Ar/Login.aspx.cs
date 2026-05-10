using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;

public partial class Login : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    public string CurrentLang = "ru"; // كل مرة تعيد تحميل الصفحة تبدأ من عربي
    public string CurrentDir = "ltr";
    protected string GetCurrentLanguageCode()
    {
        // افترض أنك تخزن اللغة الحالية للمستخدم في متغير الجلسة Session
        HttpCookie langCookie = Request.Cookies["lang"];
        string lang = (langCookie != null && !string.IsNullOrEmpty(langCookie.Value)) ? langCookie.Value : "ar";


        if (string.IsNullOrEmpty(lang))
        {
            return "en"; // القيمة الافتراضية
        }

        // يمكنك استخدام الكود مباشرة
        if (lang.ToLower() == "ar")
        {
            return "ar";
        }
        else if (lang.ToLower() == "ru")
        {
            return "ru";
        }
        else
        {
            return "en";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        HttpCookie langCookie = Request.Cookies["lang"];
        string lang = (langCookie != null && !string.IsNullOrEmpty(langCookie.Value)) ? langCookie.Value : "ar";

        switch (lang)
        {
            case "en":
                CurrentLang = "en";
                CurrentDir = "ltr";
                break;
            case "ru":
                CurrentLang = "ru";
                CurrentDir = "ltr";

                break;
            default:
                CurrentLang = "ar";
                CurrentDir = "rtl";

                break;
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string hash = HashPassword(password);
      
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                string q = "SELECT COUNT(*) FROM Users WHERE Email=@Email AND PasswordHash=@Hash AND Provider='Manual'";
                using (SqlCommand cmd = new SqlCommand(q, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Hash", hash);
                    int found = (int)cmd.ExecuteScalar();
                    if (found > 0)
                    {
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
              1,                        // Ticket version
              email,                 // Username
              DateTime.Now,             // Issue date
              DateTime.Now.AddYears(10),  // Expiration
              true,                     // Persistent (stays after browser close)
              "",                       // User data (optional)
              FormsAuthentication.FormsCookiePath
          );

                    string encrypted = FormsAuthentication.Encrypt(ticket);
                    HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encrypted);
                    authCookie.Expires = ticket.Expiration;
                    Response.Cookies.Add(authCookie);
                    FormsAuthentication.SetAuthCookie(email, true);

                    string url = ResolveUrl("~/ar/default.aspx"); // أو أي رابط تحب
                    string script = @"
        if (window.parent && window.parent !== window) {{
            try {{
                // لو عايز تقفل المودال لو هو بوتستراب
                if (window.parent.$ && window.parent.$('.modal').length) {{
                    window.parent.$('.modal').modal('hide');
                }}
                window.parent.location.href = 'default.aspx';
            }} catch(e) {{
                console && console.log('redirect to parent failed', e);
                window.location.href = 'default.aspx';
            }}
        }} else {{
            window.location.href = '{url}';
        }}";

                    // true يعني يضيف وسوم <script> تلقائياً
                    ClientScript.RegisterStartupScript(this.GetType(), "RedirectParent", script, true);
                }
                }
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
                return BitConverter.ToString(bytes).Replace("-", "").ToLower();
            }
        }
    }

