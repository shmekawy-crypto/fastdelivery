using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Admin_Pages_Drivers : System.Web.UI.Page
{
    // تأكد من اسم الـ ConnectionString في الـ web.config
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
            string query = "SELECT * FROM DeliveryMen WHERE (DriverName LIKE @search OR Phone LIKE @search) ORDER BY DriverID DESC";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@search", "%" + txtSearch.Text.Trim() + "%");

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvDrivers.DataSource = dt;
            gvDrivers.DataBind();
            lblCount.Text = dt.Rows.Count.ToString();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string query = "";
            if (hfID.Value == "0") // إضافة جديد
            {
                query = "INSERT INTO DeliveryMen (DriverName, Phone, VehicleNo, Status) VALUES (@name, @phone, @vehicle, 1)";
            }
            else // تعديل
            {
                query = "UPDATE DeliveryMen SET DriverName=@name, Phone=@phone, VehicleNo=@vehicle WHERE DriverID=@id";
            }

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@name", txtDriverName.Text.Trim());
            cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@vehicle", txtVehicleNo.Text.Trim());
            cmd.Parameters.AddWithValue("@id", hfID.Value);

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            ClearFields();
            BindDrivers();
            // يمكنك هنا إضافة سكريبت لإظهار رسالة نجاح
        }
    }

    protected void gvDrivers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditDriver")
        {
            Edit(id);
        }
        else if (e.CommandName == "DeleteDriver")
        {
            Delete(id);
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
                txtVehicleNo.Text = dr["VehicleNo"].ToString();
                btnSave.Text = "تحديث";
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
        txtDriverName.Text = txtPhone.Text = txtVehicleNo.Text = "";
        btnSave.Text = "حفظ";
    }

    protected void gvDrivers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvDrivers.PageIndex = e.NewPageIndex;
        BindDrivers();
    }
}