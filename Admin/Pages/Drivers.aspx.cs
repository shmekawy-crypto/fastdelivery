using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public partial class Admin_Pages_Drivers : System.Web.UI.Page
{
    string connString = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDrivers();
        }
    }

    void BindDrivers()
    {
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "SELECT * FROM DeliveryMen WHERE (DriverName LIKE @search OR Phone LIKE @search OR NationalID LIKE @search) ORDER BY DriverID DESC";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@search", "%" + txtSearch.Text.Trim() + "%");

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvDrivers.DataSource = dt;
            gvDrivers.DataBind();
            lblCount.Text = dt.Rows.Count.ToString();

            // ضبط الحالة في القوائم المنسدلة داخل الجريد
            foreach (GridViewRow row in gvDrivers.Rows)
            {
                DropDownList ddl = (DropDownList)row.FindControl("ddlStatus");
                HiddenField hf = (HiddenField)row.FindControl("hfGridStatus");
                if (ddl != null && hf != null)
                {
                    ddl.SelectedValue = hf.Value;
                }
            }
        }
    }

    private string SaveFile(FileUpload fu, string folderName, string existingPath)
    {
        if (fu.HasFile)
        {
            string ext = Path.GetExtension(fu.FileName);
            string fileName = Guid.NewGuid().ToString() + ext;
            string path = "Delivery/Uploads/" + folderName + "/" + fileName;
            string fullPath = Server.MapPath("~/ar/" + path);

            string directory = Path.GetDirectoryName(fullPath);
            if (!Directory.Exists(directory)) Directory.CreateDirectory(directory);

            fu.SaveAs(fullPath);
            return path;
        }
        return existingPath;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string phone = txtPhone.Text.Trim();
        string nid = txtNationalID.Text.Trim();
        int currentId = int.Parse(hfID.Value);

        // التحقق من عدم تكرار الهاتف أو الرقم القومي
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string checkQuery = "SELECT COUNT(*) FROM DeliveryMen WHERE (Phone = @phone OR NationalID = @nid) AND DriverID <> @id";
            SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
            checkCmd.Parameters.AddWithValue("@phone", phone);
            checkCmd.Parameters.AddWithValue("@nid", nid);
            checkCmd.Parameters.AddWithValue("@id", currentId);
            conn.Open();
            int count = (int)checkCmd.ExecuteScalar();
            if (count > 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('خطأ: رقم الهاتف أو الرقم القومي مسجل لمندوب آخر بالفعل!');", true);
                return;
            }
        }

        string profilePath = SaveFile(fuProfilePic, "Drivers", hfProfilePic.Value);
        string idPath = SaveFile(fuNationalIDPhoto, "Drivers", hfNationalIDPhoto.Value);
        string criminalPath = SaveFile(fuCriminalRecord, "Drivers", hfCriminalRecordPhoto.Value);
        string licensePath = SaveFile(fuLicensePhoto, "Drivers", hfLicensePhoto.Value);

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "";
            if (hfID.Value == "0")
            {
                query = @"INSERT INTO DeliveryMen 
                        (DriverName, Phone, EmergencyPhone, Age, NationalID, ResidenceAddress, Username, Password, VehicleType, VehicleNo, PaymentMethod, ProfilePic, NationalIDPhoto, CriminalRecordPhoto, LicensePhoto, Status, CreatedAt, LastUpdate) 
                        VALUES 
                        (@name, @phone, @ephone, @age, @nid, @address, @user, @pass, @vtype, @vno, @payment, @pic, @nidPic, @crPic, @licPic, 0, GETDATE(), GETDATE())";
            }
            else
            {
                query = @"UPDATE DeliveryMen SET 
                        DriverName=@name, Phone=@phone, EmergencyPhone=@ephone, Age=@age, NationalID=@nid, ResidenceAddress=@address, 
                        Username=@user, Password=@pass, VehicleType=@vtype, VehicleNo=@vno, PaymentMethod=@payment, 
                        ProfilePic=@pic, NationalIDPhoto=@nidPic, CriminalRecordPhoto=@crPic, LicensePhoto=@licPic, LastUpdate=GETDATE() 
                        WHERE DriverID=@id";
            }

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@name", txtDriverName.Text.Trim());
            cmd.Parameters.AddWithValue("@phone", phone);
            cmd.Parameters.AddWithValue("@ephone", txtEmergencyPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@age", string.IsNullOrEmpty(txtAge.Text) ? (object)DBNull.Value : int.Parse(txtAge.Text));
            cmd.Parameters.AddWithValue("@nid", nid);
            cmd.Parameters.AddWithValue("@address", txtResidenceAddress.Text.Trim());
            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@pass", txtPassword.Text.Trim());
            cmd.Parameters.AddWithValue("@vtype", ddlVehicleType.SelectedValue);
            cmd.Parameters.AddWithValue("@vno", txtVehicleNo.Text.Trim());
            cmd.Parameters.AddWithValue("@payment", txtPaymentMethod.Text.Trim());
            cmd.Parameters.AddWithValue("@pic", profilePath);
            cmd.Parameters.AddWithValue("@nidPic", idPath);
            cmd.Parameters.AddWithValue("@crPic", criminalPath);
            cmd.Parameters.AddWithValue("@licPic", licensePath);
            cmd.Parameters.AddWithValue("@id", currentId);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            ClearFields();
            BindDrivers();
        }
    }

    protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        GridViewRow row = (GridViewRow)ddl.NamingContainer;
        int driverId = Convert.ToInt32(gvDrivers.DataKeys[row.RowIndex].Value);
        int newStatus = Convert.ToInt32(ddl.SelectedValue);

        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("UPDATE DeliveryMen SET Status=@status, LastUpdate=GETDATE() WHERE DriverID=@id", conn);
            cmd.Parameters.AddWithValue("@status", newStatus);
            cmd.Parameters.AddWithValue("@id", driverId);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
        BindDrivers();
    }

    protected void gvDrivers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandArgument == null || e.CommandArgument.ToString() == "") return;
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditDriver")
        {
            Edit(id);
        }
        else if (e.CommandName == "DeleteDriver")
        {
            Delete(id);
        }
        else if (e.CommandName == "ConfirmDriver")
        {
            ConfirmStatus(id);
        }
    }

    void ConfirmStatus(int id)
    {
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("UPDATE DeliveryMen SET Status=1, LastUpdate=GETDATE() WHERE DriverID=@id", conn);
            cmd.Parameters.AddWithValue("@id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
            BindDrivers();
        }
    }

    void Edit(int id)
    {
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("SELECT * FROM DeliveryMen WHERE DriverID=@id", conn);
            cmd.Parameters.AddWithValue("@id", id);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                hfID.Value = dr["DriverID"].ToString();
                txtDriverName.Text = dr["DriverName"].ToString();
                txtPhone.Text = dr["Phone"].ToString();
                txtEmergencyPhone.Text = dr["EmergencyPhone"].ToString();
                txtAge.Text = dr["Age"].ToString();
                txtNationalID.Text = dr["NationalID"].ToString();
                txtResidenceAddress.Text = dr["ResidenceAddress"].ToString();
                txtUsername.Text = dr["Username"].ToString();
                txtPassword.Text = dr["Password"].ToString();
                ddlVehicleType.SelectedValue = dr["VehicleType"].ToString();
                txtVehicleNo.Text = dr["VehicleNo"].ToString();
                txtPaymentMethod.Text = dr["PaymentMethod"].ToString();

                hfProfilePic.Value = dr["ProfilePic"].ToString();
                hfNationalIDPhoto.Value = dr["NationalIDPhoto"].ToString();
                hfCriminalRecordPhoto.Value = dr["CriminalRecordPhoto"].ToString();
                hfLicensePhoto.Value = dr["LicensePhoto"].ToString();

                btnSave.Text = "تحديث";

                string js = "";
                if (dr["ProfilePic"].ToString() != "") js += "$('#imgProfilePic').attr('src', '../../" + dr["ProfilePic"].ToString() + "').show();";
                if (dr["NationalIDPhoto"].ToString() != "") js += "$('#imgNationalID').attr('src', '../../" + dr["NationalIDPhoto"].ToString() + "').show();";
                if (dr["CriminalRecordPhoto"].ToString() != "") js += "$('#imgCriminal').attr('src', '../../" + dr["CriminalRecordPhoto"].ToString() + "').show();";
                if (dr["LicensePhoto"].ToString() != "") js += "$('#imgLicense').attr('src', '../../" + dr["LicensePhoto"].ToString() + "').show();";

                if (js != "") ScriptManager.RegisterStartupScript(this, GetType(), "ImgPreview", js, true);
            }
        }
    }

    void Delete(int id)
    {
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM DeliveryMen WHERE DriverID=@id", conn);
            cmd.Parameters.AddWithValue("@id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
            BindDrivers();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindDrivers();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearFields();
    }

    void ClearFields()
    {
        hfID.Value = "0";
        txtDriverName.Text = txtPhone.Text = txtVehicleNo.Text = txtEmergencyPhone.Text = "";
        txtAge.Text = txtNationalID.Text = txtResidenceAddress.Text = txtUsername.Text = "";
        txtPassword.Text = txtPaymentMethod.Text = "";
        ddlVehicleType.SelectedIndex = 0;
        hfProfilePic.Value = hfNationalIDPhoto.Value = hfCriminalRecordPhoto.Value = hfLicensePhoto.Value = "";
        hfBase64Profile.Value = hfBase64National.Value = hfBase64Criminal.Value = hfBase64License.Value = "";
        btnSave.Text = "حفظ";
        ScriptManager.RegisterStartupScript(this, GetType(), "ClearImgs", "$('.img-preview').hide().attr('src', '#');", true);
    }

    protected void gvDrivers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvDrivers.PageIndex = e.NewPageIndex;
        BindDrivers();
    }
}