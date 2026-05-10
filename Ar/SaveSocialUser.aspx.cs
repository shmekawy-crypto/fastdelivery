using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;

public partial class SaveSocialUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string name = Request.Form["name"];
            string email = Request.Form["email"];
            string provider = Request.Form["provider"];
            string providerId = Request.Form["providerId"];

            string connectionString = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                string q = @"IF NOT EXISTS (SELECT 1 FROM Users WHERE Email=@Email)
                             INSERT INTO Users(Name, Email, Provider, ProviderId)
                             VALUES(@Name, @Email, @Provider, @ProviderId)";
                using (SqlCommand cmd = new SqlCommand(q, con))
                {
                    cmd.Parameters.AddWithValue("@Name", string.IsNullOrEmpty(name) ? email : name);
                    cmd.Parameters.AddWithValue("@Email", email ?? "");
                    cmd.Parameters.AddWithValue("@Provider", provider);
                    cmd.Parameters.AddWithValue("@ProviderId", providerId ?? "");
                    cmd.ExecuteNonQuery();
                }
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
        }

            Session["UserName"] = string.IsNullOrEmpty(name) ? email : name;
            Response.Write("OK");
            Response.End();
        }
    }

