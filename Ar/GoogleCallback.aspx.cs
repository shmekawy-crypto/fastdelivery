using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Data.SqlClient;
using System.Web.Security;
using System.Configuration;

public partial class GoogleCallback : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
    {
        string credential = Request.Form["credential"];
        if (!string.IsNullOrEmpty(credential))
        {
            var payload = ParseJwt(credential);
            string email = payload["email"];
            string given_name = payload["given_name"];
            string family_name = payload["family_name"];
            SaveUser(email, given_name, family_name, "Google", payload["sub"]);

            Session["UserName"] = string.IsNullOrEmpty(given_name) ? email : given_name;
        }

        Response.Write("OK");
        Response.End();
    }

        private void SaveUser(string email, string name,string Lname, string provider, string providerId)
        {
        
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["Conn"].ConnectionString))
            {
                con.Open();
                string q = @"IF NOT EXISTS (SELECT 1 FROM Users WHERE Email=@Email)
                             INSERT INTO Users(Name,Lname, Email, Provider, ProviderId)
                             VALUES(@Name,@Lname, @Email, @Provider, @ProviderId)";
            using (var cmd = new SqlCommand(q, con))
            {
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Lname", Lname);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Provider", provider);
                cmd.Parameters.AddWithValue("@ProviderId", providerId);
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
        }

        private System.Collections.Generic.Dictionary<string, string> ParseJwt(string jwt)
        {
            var parts = jwt.Split('.');
            string payload64 = parts[1];
            switch (payload64.Length % 4)
            {
                case 2: payload64 += "=="; break;
                case 3: payload64 += "="; break;
            }
            var bytes = Convert.FromBase64String(payload64.Replace('-', '+').Replace('_', '/'));
            string json = System.Text.Encoding.UTF8.GetString(bytes);
            return new JavaScriptSerializer().Deserialize<System.Collections.Generic.Dictionary<string, string>>(json);
        }
    }

