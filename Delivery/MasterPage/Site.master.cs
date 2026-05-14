using System;
using System.Data.SqlClient;
using System.Configuration;

public partial class Delivery_MasterPage_Site : System.Web.UI.MasterPage
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["DriverID"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else
        {
            if (!IsPostBack)
            {
                lblDriverName.Text = Session["DriverName"].ToString();
                LoadSidebarImage();
            }
        }
    }

    private void LoadSidebarImage()
    {
        try
        {
            int driverId = Convert.ToInt32(Session["DriverID"]);
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // جلب مسار الصورة الشخصية فقط
                string query = "SELECT ProfilePic FROM DeliveryMen WHERE DriverID = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", driverId);
                con.Open();
                object pic = cmd.ExecuteScalar();

                if (pic != null && pic != DBNull.Value && !string.IsNullOrEmpty(pic.ToString()))
                {
                    imgSidebarProfile.ImageUrl = ResolveUrl(pic.ToString());
                }
            }
        }
        catch
        {
            // في حالة الخطأ سيتم استخدام الصورة الافتراضية المحددة في التصميم
        }
    }
}