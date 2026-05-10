using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using DMS;
public partial class Ar_profile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (User.Identity.IsAuthenticated)
            {
                Users usr = new Users();
                usr.Where.Email.Operator = WhereParameter.Operand.Equal;
                usr.Where.Email.Value = User.Identity.Name;
                if (usr.Query.Load())
                {

                    useremail.Text = usr.Email;
                    userFname.Text = usr.Name;
                    userLname.Text = usr.Lname;
                    if (!usr.IsColumnNull(Users.ColumnNames.Bdate))
                    {
                        date.Text = usr.Bdate.ToString("yyyy-MM-dd");
                    }
                    if (!usr.IsColumnNull(Users.ColumnNames.Gender))
                    {
                        if (usr.Gender)
                        {
                            female.Checked = true;
                        }
                        else
                        {
                            male.Checked = true;
                        }

                    }
                }
            }
            else
            {
                Response.Redirect("Default.aspx");
            }

        }
    }
    protected string GetLiteralText(string key)
    {

        return (string)GetGlobalResourceObject("texts", key);
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        Users usr = new Users();
        usr.Where.Email.Operator = WhereParameter.Operand.Equal;
        usr.Where.Email.Value = User.Identity.Name;
        if (usr.Query.Load())
        {
            usr.Name = userFname.Text;
            usr.Lname = userLname.Text;
            if (male.Checked)
            {
                usr.Gender = false;
            }
            if (female.Checked)
            {
                usr.Gender = true;
            }
            if (!string.IsNullOrEmpty(date.Text))
            {
                usr.Bdate = Convert.ToDateTime(date.Text);

            }
            else
            {
                usr.SetColumnNull(Users.ColumnNames.Bdate);
            }
            usr.Save();
            ShowSweetAlert(GetLiteralText("UpdatedSuccess"), "success");
        }
    }
    private void ShowSweetAlert(string message, string icon)
    {
        string safeMessage = HttpUtility.JavaScriptStringEncode(message);
        string script = string.Format(@"
        <script type='text/javascript'>
            Swal.fire({{
                icon: '{0}',
                title: '{1}',
                showConfirmButton: true
            }});
        </script>", icon, safeMessage);

        ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), script);
    }
    protected void SavePassword_Click(object sender, EventArgs e)
    {
        Users usr = new Users();
        usr.Where.Email.Operator = WhereParameter.Operand.Equal;
        usr.Where.Email.Value = User.Identity.Name;
        if (usr.Query.Load())
        {
            if (usr.PasswordHash == HashPassword(savedpassword2.Text))
            {
                usr.PasswordHash = HashPassword(newPassword.Text);
                usr.Save();
                newEmail.Text = string.Empty;
                checkNewEmail.Text = string.Empty;
                newPassword.Text = string.Empty;
                checkNewPassword.Text = string.Empty;
                ShowSweetAlert(GetLiteralText("UpdatedSuccess"), "success");
            }
            else
            {


                ShowSweetAlert(GetLiteralText("Oldinncorrect"), "error");
            }

        }

    }
    protected void sendChange_Click(object sender, EventArgs e)
    {
        Users usr = new Users();
        usr.Where.Email.Operator = WhereParameter.Operand.Equal;
        usr.Where.Email.Value = User.Identity.Name;
        if (usr.Query.Load())
        {
            if (usr.PasswordHash == HashPassword(savedpassword.Text))
            {
               usr.Email = newEmail.Text;
               
                usr.Save();
                if (!string.IsNullOrEmpty(newEmail.Text))
                {
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
             1,                        // Ticket version
             usr.Email,                 // Username
             DateTime.Now,             // Issue date
             DateTime.Now.AddDays(7),  // Expiration
             true,                     // Persistent (stays after browser close)
             "",                       // User data (optional)
             FormsAuthentication.FormsCookiePath
         );
                    string.IsNullOrEmpty(newEmail.Text);
                    string encrypted = FormsAuthentication.Encrypt(ticket);
                    HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encrypted);
                    authCookie.Expires = ticket.Expiration;
                    Response.Cookies.Add(authCookie);
                    FormsAuthentication.SetAuthCookie(usr.Email, true);
                }
                newEmail.Text = string.Empty;
                checkNewEmail.Text = string.Empty;
                newPassword.Text = string.Empty;
                checkNewPassword.Text = string.Empty;
                ShowSweetAlert(GetLiteralText("UpdatedSuccess"), "success");
            }
            else
            {
                ShowSweetAlert(GetLiteralText("Oldinncorrect"), "error");
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