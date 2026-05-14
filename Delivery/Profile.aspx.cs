using System;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public partial class Delivery_Profile : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["DriverID"] == null) { Response.Redirect("Login.aspx"); return; }
        if (!IsPostBack) { LoadDriverData(); }
    }

    private void LoadDriverData()
    {
        int driverId = Convert.ToInt32(Session["DriverID"]);
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string query = "SELECT * FROM DeliveryMen WHERE DriverID = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", driverId);
            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                int status = Convert.ToInt32(dr["Status"]);

                // تفعيل واجهة العرض للمندوب المؤكد (Status = 1)
                if (status == 1)
                {
                    pnlViewMode.Visible = true;
                    pnlEditMode.Visible = false;

                    // تعبئة كافة تفاصيل المندوب
                    lblViewName.Text = dr["DriverName"].ToString();
                    lblViewPhone.Text = dr["Phone"].ToString();
                    lblViewNationalID.Text = dr["NationalID"].ToString();
                    lblViewAge.Text = dr["Age"].ToString();
                    lblViewAddress.Text = dr["ResidenceAddress"].ToString();
                    lblViewEmergency.Text = dr["EmergencyPhone"].ToString();
                    lblViewPayment.Text = dr["PaymentMethod"].ToString();
                    lblViewVehicleType.Text = dr["VehicleType"].ToString();
                    lblViewVehicleNo.Text = dr["VehicleNo"].ToString();

                    // عرض الصور بمساراتها الصحيحة
                    imgViewProfile.ImageUrl = ResolveUrl(dr["ProfilePic"].ToString());
                    imgViewNID.ImageUrl = ResolveUrl(dr["NationalIDPhoto"].ToString());
                    imgViewCrim.ImageUrl = ResolveUrl(dr["CriminalRecordPhoto"].ToString());
                    imgViewLic.ImageUrl = ResolveUrl(dr["LicensePhoto"].ToString());
                }
                else
                {
                    // تفعيل واجهة التعديل للمندوب Pending
                    pnlViewMode.Visible = false;
                    pnlEditMode.Visible = true;
                    // يتم هنا تحميل البيانات داخل الـ TextBoxes للتعديل
                }
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        // كود الحفظ المعدل
    }
}