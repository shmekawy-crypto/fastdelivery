using System;
using System.Data.SqlClient;
using System.Configuration;

 public partial class Delivery_login : System.Web.UI.Page
    {
        // تأكد أن "MyConn" موجود في ملف Web.config
        string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // إذا كان المندوب مسجل دخوله فعلياً، حوله للطلبات فوراً
                if (Session["DriverID"] != null) Response.Redirect("CurrentTask.aspx");
            }
        }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            // 1. أضفنا عمود Status للاستعلام
            string query = "SELECT DriverID, DriverName, Status FROM DeliveryMen WHERE Username = @user AND Password = @pass";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@pass", txtPassword.Text.Trim());

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                // 2. الحصول على حالة الحساب
                int status = Convert.ToInt32(dr["Status"]);

                if (status == 2)
                {
                    // الحالة 1 تعني أن الحساب نشط وتم تأكيده
                    Session["DriverID"] = dr["DriverID"].ToString();
                    Session["DriverName"] = dr["DriverName"].ToString();
                    Response.Redirect("CurrentTask.aspx");
                }
                else if (status == 1)
                {
                    // الحالة 2 تعني أن الحساب قيد المراجعة (Pending)
                    lblError.Text = "حسابك لا يزال قيد المراجعة من قبل الإدارة، يرجى المحاولة لاحقاً.";
                    lblError.Visible = true;
                }
                else
                {
                    // أي حالة أخرى (مثل 0) تعني أن الحساب محظور
                    lblError.Text = "عذراً، هذا الحساب محظور حالياً. يرجى التواصل مع الدعم الفني.";
                    lblError.Visible = true;
                }
            }
            else
            {
                lblError.Text = "خطأ في اسم المستخدم أو كلمة المرور";
                lblError.Visible = true;
            }
        }
    }
}
