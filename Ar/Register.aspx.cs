using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS;
using System.Web.Security;
using System.Security.Cryptography;
using System.Data.SqlClient;
using System.Text;

public partial class Ar_Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    private string HashPassword(string password)
    {
        using (SHA256 sha = SHA256.Create())
        {
            byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            return BitConverter.ToString(bytes).Replace("-", "").ToLower();
        }
    }
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        Users usr = new Users();
        usr.AddNew();
        usr.Name = txtFname.Text;
        usr.Lname = txtLname.Text;
        usr.Email = txtEmail.Text;
        usr.PasswordHash = HashPassword(txtPassword.Text);
        usr.Provider = "Manual";
        try
        {
            usr.Save();
            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
               1,                        // Ticket version
               usr.Email,                 // Username
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
            FormsAuthentication.SetAuthCookie(usr.Email, true);
            Response.Redirect("Addresses.aspx");
        }
        catch (Exception ex)
        {
            if (ex.Message.Contains("UQ__Users__A9D1053409DE7BCC"))
            {
                // استدعاء الـ SweetAlert في حالة المستخدم موجود
                string script = "showSwal('خطأ!', 'البريد الإلكتروني مسجل  بالفعل.', 'error');";
                ClientScript.RegisterStartupScript(this.GetType(), "Popup", script, true);
            }
            else
            {
                string script = "showSwal('عفواً!', 'حصلت مشكلة فنية، برجاء المحاولة فى وقت لاحق.', 'warning');";
                ClientScript.RegisterStartupScript(this.GetType(), "Popup", script, true);
            }
        }
    }
}