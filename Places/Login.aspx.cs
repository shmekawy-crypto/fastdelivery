using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

    public partial class Places_Login : System.Web.UI.Page
    {
        // تأكد من تغيير اسم الـ ConnectionString حسب الـ Web.config عندك
        string connString = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // الاستعلام بيشوف اليوزر والباسورد وحالة المطعم (Active)
                string query = "SELECT id, Name FROM Places WHERE UserName = @user AND Pass = @pass AND Active = 1";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@pass", txtPassword.Text.Trim());

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    // "السر كله هنا" .. بنخزن البيانات في الـ Session عشان نستخدمها في كل الصفحات
                    Session["PlaceID"] = dt.Rows[0]["id"];
                    Session["PlaceName"] = dt.Rows[0]["Name"];

                    // نوديه على صفحة الإحصائيات
                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    lblError.Text = "بيانات الدخول غير صحيحة أو الحساب معطل.";
                }
            }
        }
    }
