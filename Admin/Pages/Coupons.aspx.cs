using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Pages_Coupons : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillPlaces();
            BindGrid();
        }
    }

    private void FillPlaces()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            DataTable dt = new DataTable();
            new SqlDataAdapter("SELECT id, Name FROM Places ORDER BY Name", conn).Fill(dt);
            // ملء قائمة التوليد
            ddlPlace.DataSource = dt;
            ddlPlace.DataTextField = "Name"; ddlPlace.DataValueField = "id";
            ddlPlace.DataBind();
            // ملء قائمة البحث
            ddlSearchPlace.DataSource = dt;
            ddlSearchPlace.DataTextField = "Name"; ddlSearchPlace.DataValueField = "id";
            ddlSearchPlace.DataBind();
        }
    }

    private void BindGrid()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = @"SELECT c.*, p.Name as PlaceName FROM Coupons c 
                           LEFT JOIN Places p ON c.PlaceID = p.id WHERE 1=1";

            if (!string.IsNullOrEmpty(txtSearchCode.Text))
                sql += " AND c.CouponCode LIKE @code";

            if (ddlSearchPlace.SelectedValue != "-1")
                sql += (ddlSearchPlace.SelectedValue == "0") ? " AND c.PlaceID IS NULL" : " AND c.PlaceID = @pId";

            if (ddlSearchStatus.SelectedValue == "1") sql += " AND c.IsActive = 1 AND c.ExpiryDate >= GETDATE()";
            else if (ddlSearchStatus.SelectedValue == "0") sql += " AND c.IsActive = 0";
            else if (ddlSearchStatus.SelectedValue == "2") sql += " AND c.ExpiryDate < GETDATE()";

            SqlCommand cmd = new SqlCommand(sql + " ORDER BY c.id DESC", conn);
            cmd.Parameters.AddWithValue("@code", "%" + txtSearchCode.Text + "%");
            cmd.Parameters.AddWithValue("@pId", ddlSearchPlace.SelectedValue);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            gvCoupons.DataSource = dt;
            gvCoupons.DataBind();
            lblCount.Text = dt.Rows.Count.ToString();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        int count = int.Parse(txtCount.Text);
        int dType = int.Parse(ddlDiscountType.SelectedValue);

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            for (int i = 0; i < count; i++)
            {
                // أضفنا MaxDiscountAmount في جملة الـ SQL
                SqlCommand cmd = new SqlCommand(@"INSERT INTO Coupons 
                (CouponCode, DiscountType, DiscountPercentage, MaxDiscountAmount, MinOrderAmount, ExpiryDate, IsActive, PlaceID) 
                VALUES (@C, @T, @P, @Max, @Min, @E, 1, @PID)", conn);

                cmd.Parameters.AddWithValue("@C", GenerateCode(8));
                cmd.Parameters.AddWithValue("@T", dType);
                cmd.Parameters.AddWithValue("@P", decimal.Parse(txtPercentage.Text));
                cmd.Parameters.AddWithValue("@Max", decimal.Parse(txtMaxDiscount.Text)); // الحقل الجديد
                cmd.Parameters.AddWithValue("@Min", decimal.Parse(txtMinOrder.Text));    // الحد الأدنى
                cmd.Parameters.AddWithValue("@E", DateTime.Parse(txtExpiryDate.Text));

                // ربط المطعم (اختياري بناءً على النوع)
                if (dType == 1 && ddlPlace.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@PID", ddlPlace.SelectedValue);
                else
                    cmd.Parameters.AddWithValue("@PID", DBNull.Value);

                cmd.ExecuteNonQuery();
            }
        }
        BindGrid();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('تم التوليد بنجاح شاملة الحد الأقصى للخصم والحد الأدنى');", true);
    }

    // دالة تفريغ الحقول (تحديث)
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtPercentage.Text = "";
        txtCount.Text = "1";
        txtMinOrder.Text = "0";
        txtMaxDiscount.Text = "100";
        BindGrid();
    }
    private string GenerateCode(int len)
    {
        string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random rnd = new Random(Guid.NewGuid().GetHashCode());
        char[] res = new char[len];
        for (int i = 0; i < len; i++) res[i] = chars[rnd.Next(chars.Length)];
        return new string(res);
    }

    protected void gvCoupons_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            if (e.CommandName == "ToggleStatus")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                SqlCommand cmd = new SqlCommand("UPDATE Coupons SET IsActive = @S WHERE id = @ID", conn);
                cmd.Parameters.AddWithValue("@S", !Convert.ToBoolean(args[1]));
                cmd.Parameters.AddWithValue("@ID", args[0]);
                cmd.ExecuteNonQuery();
            }
            else if (e.CommandName == "DeleteCoupon")
            {
                new SqlCommand("DELETE FROM Coupons WHERE id=" + e.CommandArgument, conn).ExecuteNonQuery();
            }
        }
        BindGrid();
    }

    protected void btnSearch_Click(object sender, EventArgs e) { BindGrid(); }
    
}