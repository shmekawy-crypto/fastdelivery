using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.Script.Serialization;

public partial class Admin_Pages_DeliveryZones : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadZones();
        }
    }
    private void LoadZones()
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand(@"
SELECT dz.ZoneID, dz.Latitude, dz.Longitude, dz.RadiusKm,dz.DeliveryCost , p.Name AS RestaurantName
FROM  dbo.DeliveryZones AS dz INNER JOIN
               dbo.Places AS p ON dz.PlacesID = p.id
WHERE (p.id = " + Convert.ToInt32(Request.QueryString["id"].ToString()) + ")", con);

            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(reader);
            con.Close();
            GridView1.DataSource = dt;
            GridView1.DataBind();
            // Convert to simple list for JSON serialization
            var zoneList = new List<object>();
            foreach (DataRow row in dt.Rows)
            {
                zoneList.Add(new
                {
                    ZoneID = row["ZoneID"],
                    Latitude = Convert.ToDouble(row["Latitude"]),
                    Longitude = Convert.ToDouble(row["Longitude"]),
                    RadiusKm = Convert.ToDouble(row["RadiusKm"]),
                    RestaurantName = row["RestaurantName"].ToString()
                });
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            string jsonData = js.Serialize(zoneList);

            // Register clean JSON array in client script
            ClientScript.RegisterStartupScript(this.GetType(), "zones",
                "var savedZones = " + jsonData + ";", true);

            // Bind grid
            GridView1.DataSource = dt;
            GridView1.DataBind();

        }
    }


       

        protected void btnAddZone_Click(object sender, EventArgs e)
        {
            if (txtLat.Text == "" || txtLng.Text == "" || txtRadius.Text == "" || txtDCost.Text == "")
            {
                lblMessage.Text = "يرجى إدخال جميع البيانات.";
                return;
            }

        using (SqlConnection con = new SqlConnection(connStr))
        {
            string query = "INSERT INTO DeliveryZones (PlacesID, Latitude, Longitude, RadiusKm,DeliveryCost) VALUES (@r, @lat, @lng, @rad,@DeliveryCost)";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@r", Convert.ToInt32(Request.QueryString["id"].ToString()));
            cmd.Parameters.AddWithValue("@lat", txtLat.Text);
            cmd.Parameters.AddWithValue("@lng", txtLng.Text);
            cmd.Parameters.AddWithValue("@rad", txtRadius.Text);
            cmd.Parameters.AddWithValue("DeliveryCost", Convert.ToDecimal(txtDCost.Text));
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

            lblMessage.Text = "تمت إضافة المنطقة بنجاح.";
            LoadZones();
        }

        protected void GridView1_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;
            LoadZones();
        }

        protected void GridView1_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            LoadZones();
        }

        protected void GridView1_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
            string lat = ((System.Web.UI.WebControls.TextBox)GridView1.Rows[e.RowIndex].Cells[2].Controls[0]).Text;
            string lng = ((System.Web.UI.WebControls.TextBox)GridView1.Rows[e.RowIndex].Cells[3].Controls[0]).Text;
            string radius = ((System.Web.UI.WebControls.TextBox)GridView1.Rows[e.RowIndex].Cells[4].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "UPDATE DeliveryZones SET Latitude=@lat, Longitude=@lng, RadiusKm=@r ,DeliveryCost=@DeliveryCost WHERE ZoneID=@id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@lat", lat);
                cmd.Parameters.AddWithValue("@lng", lng);
                cmd.Parameters.AddWithValue("@r", radius);
                cmd.Parameters.AddWithValue("@id", id);
            cmd.Parameters.AddWithValue("@DeliveryCost", Convert.ToDecimal(txtDCost.Text));

            
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            GridView1.EditIndex = -1;
            LoadZones();
            lblMessage.Text = "تم تحديث البيانات.";
        }

        protected void GridView1_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);


            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "DELETE FROM DeliveryZones WHERE ZoneID=@id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            LoadZones();
            lblMessage.Text = "تم حذف المنطقة.";
        }
    }

