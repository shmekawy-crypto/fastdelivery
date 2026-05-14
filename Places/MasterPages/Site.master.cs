using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Places_MasterPages_Site : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // حماية اللوحة: التأكد من أن المستخدم قام بتسجيل الدخول
        // إذا كان الـ Session فارغاً، يتم توجيهه لصفحة الدخول فوراً
        if (Session["PlaceID"] == null)
        {
            Response.Redirect("Login.aspx");
        }
    }
    protected void btnLogout_Click(object sender, EventArgs e)
    {
        // 1. مسح جميع البيانات المخزنة في الجلسة (Session)
        Session.Abandon();
        Session.Clear();

        // 2. إزالة الكوكيز الخاصة بالجلسة للتأكد من الخروج التام
        if (Request.Cookies["ASP.NET_SessionId"] != null)
        {
            Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
            Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
        }

        // 3. التوجه لصفحة تسجيل الدخول
        Response.Redirect("Login.aspx");
    }
}