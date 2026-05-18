using System;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI.WebControls;

public partial class Delivery_Register : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            con.Open();

            // 1. التحقق من عدم تكرار البيانات الفريدة (يوزر، موبايل، رقم قومي)
            string check = "SELECT COUNT(*) FROM DeliveryMen WHERE Username=@un OR Phone=@ph OR NationalIDNo=@nid";
            SqlCommand chkCmd = new SqlCommand(check, con);
            chkCmd.Parameters.AddWithValue("@un", txtUser.Text.Trim());
            chkCmd.Parameters.AddWithValue("@ph", txtPhone.Text.Trim());
            chkCmd.Parameters.AddWithValue("@nid", txtNationalIDNo.Text.Trim());

            if ((int)chkCmd.ExecuteScalar() > 0)
            {
                lblMsg.Text = "اسم المستخدم أو الهاتف أو الرقم القومي مسجل بالفعل!";
                lblMsg.CssClass = "alert alert-danger";
                lblMsg.Visible = true;
                return;
            }

            // 2. إدخال البيانات (تمت إضافة ResidenceAddress هنا)
            string sql = @"INSERT INTO DeliveryMen 
                (DriverName, Phone, NationalID, Username, Password, Age, ResidenceAddress, VehicleType, VehicleNo, Status, CreatedAt) 
                OUTPUT INSERTED.DriverID
                VALUES (@name, @phone, @nid, @un, @pass, @age, @addr, @vt, @vno, 2, GETDATE())";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@nid", txtNationalIDNo.Text.Trim());
            cmd.Parameters.AddWithValue("@un", txtUser.Text.Trim());
            cmd.Parameters.AddWithValue("@pass", txtPass.Text.Trim());
            cmd.Parameters.AddWithValue("@age", string.IsNullOrEmpty(txtAge.Text) ? (object)DBNull.Value : txtAge.Text);
            cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim()); // السطر الذي كان ناقصاً
            cmd.Parameters.AddWithValue("@vt", ddlVehicleType.SelectedValue);
            cmd.Parameters.AddWithValue("@vno", txtVehicleNo.Text.Trim());

            int newID = (int)cmd.ExecuteScalar();

            // 3. رفع الصور 
            string pPic = SaveFile(fuProfile, "PROF", newID);
            string nPic = SaveFile(fuNID, "NID", newID);
            string cPic = SaveFile(fuCrim, "CRIM", newID);
            string lPic = SaveFile(fuLic, "LIC", newID);

            // 4. تحديث مسارات الصور
            string upSql = @"UPDATE DeliveryMen SET 
                ProfilePic=@p, NationalIDPhoto=@n, CriminalRecordPhoto=@c, LicensePhoto=@l 
                WHERE DriverID=@id";
            SqlCommand upCmd = new SqlCommand(upSql, con);
            upCmd.Parameters.AddWithValue("@p", pPic);
            upCmd.Parameters.AddWithValue("@n", nPic);
            upCmd.Parameters.AddWithValue("@c", cPic);
            upCmd.Parameters.AddWithValue("@l", lPic);
            upCmd.Parameters.AddWithValue("@id", newID);
            upCmd.ExecuteNonQuery();

            lblMsg.Text = "تم إرسال طلبك بنجاح! حسابك قيد المراجعة.";
            lblMsg.CssClass = "alert alert-success";
            lblMsg.Visible = true;
            btnRegister.Visible = false;
        }
    }

    private string SaveFile(System.Web.UI.WebControls.FileUpload fu, string prefix, int id)
    {
        if (fu.HasFile)
        {
            string ext = Path.GetExtension(fu.FileName);
            string path = string.Format("Delivery/Uploads/Drivers/{0}_{1}{2}", prefix, id, ext);
            fu.SaveAs(Server.MapPath("~/" + path));
            return path;
        }
        return "";
    }
}