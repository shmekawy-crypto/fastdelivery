using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

public partial class Admin_Pages_MenuItems : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            BindPlaces();
            BindMenuItems();
            FillSizesDDL();
            FillExtrasDropDownList();
            BindSizesGrid(0); // تحميل جدول الأحجام فارغاً عند أول مرة
        }
    }

    void FillSizesDDL()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = "SELECT id, Name FROM Sizes ORDER BY Name";
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            ddlSizes.DataSource = dr;
            ddlSizes.DataTextField = "Name";
            ddlSizes.DataValueField = "id";
            ddlSizes.DataBind();
            ddlSizes.Items.Insert(0, new ListItem("--- اختر الحجم ---", "0"));
        }
    }

    void BindSizesGrid(int menuItemId)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = @"SELECT MS.Size_id AS SizeID, S.Name AS SizeName, MS.Price, MS.DiscountValue 
                           FROM MenuItems_Sizes MS 
                           INNER JOIN Sizes S ON MS.Size_id = S.id 
                           WHERE MS.MenuItems_id = @itemID";

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@itemID", menuItemId);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ViewState["SelectedSizes"] = dt;
            gvSelectedSizes.DataSource = dt;
            gvSelectedSizes.DataBind();
        }
    }

    protected void btnSaveNewExtraType_Click(object sender, EventArgs e)
    {
        string photoPath = "";
        if (fuExtraImg.HasFile)
        {
            string folderPath = Server.MapPath("~/ar/images/Extras/");
            if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);
            string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuExtraImg.FileName);
            fuExtraImg.SaveAs(folderPath + fileName);
            photoPath = "images/Extras/" + fileName;
        }

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string query = @"INSERT INTO Extras (Name, NameEn, NameRu, Price, PhotoUrl) 
                             VALUES (@Name, @NameEn, @NameRu, @Price, @PhotoUrl)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Name", txtExtraAr.Text.Trim());
                cmd.Parameters.AddWithValue("@NameEn", txtExtraEn.Text.Trim());
                cmd.Parameters.AddWithValue("@NameRu", txtExtraRu.Text.Trim());
                cmd.Parameters.AddWithValue("@Price", decimal.Parse(txtDefaultPrice.Text));
                cmd.Parameters.AddWithValue("@PhotoUrl", photoPath);
                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                if (rowsAffected > 0)
                {
                    FillExtrasDropDownList();
                    ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", @"
                    $('#modalAddNewExtra').modal('hide');
                    $('.modal-backdrop').remove();
                    $('body').removeClass('modal-open');", true);
                }
            }
        }
    }

    private void FillExtrasDropDownList()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string query = "SELECT id, Name FROM Extras ORDER BY Name ASC";
            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ddlExtras.DataSource = dt;
            ddlExtras.DataTextField = "Name";
            ddlExtras.DataValueField = "id";
            ddlExtras.DataBind();
            ddlExtras.Items.Insert(0, new ListItem("--- اختر الإضافة ---", "0"));
        }
    }

    private void CreateExtrasTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Extra_id", typeof(int));
        dt.Columns.Add("Name", typeof(string));
        dt.Columns.Add("Price", typeof(decimal));
        dt.Columns.Add("PhotoUrl", typeof(string)); // إضافة هذا السطر
        ViewState["ExtrasTable"] = dt;
    }
    private string GetPhotoPathFromDB(string extraID)
    {
        string photoPath = "Images/default.png"; // مسار افتراضي في حال لم توجد صورة

        // تأكد من وضع Connection String الخاص بمشروعك هنا
        string connString = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            // افترضنا أن جدول الإضافات اسمه Extras وعمود الصورة اسمه Photo
            string query = "SELECT PhotoUrl FROM Extras WHERE id = @id";

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@id", extraID);

            try
            {
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    photoPath ="ar/"+ result.ToString();
                }
            }
            catch (Exception ex)
            {
                // يمكنك تسجيل الخطأ هنا إذا أردت
            }
        }

        return photoPath;
    }
    protected void btnAddExtraToList_Click(object sender, EventArgs e)
    {
        // 1. التحقق من الاختيار وكتابة السعر
        if (ddlExtras.SelectedValue == "0" || string.IsNullOrEmpty(txtExtraPrice.Text))
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('من فضلك اختر الإضافة واكتب السعر')", true);
            return;
        }

        // 2. جلب الجدول الحالي من الـ ViewState
        DataTable dt = (ViewState["ExtrasTable"] != null) ? (DataTable)ViewState["ExtrasTable"] : new DataTable();

        // إذا كان الجدول جديداً، نقوم بإنشائه
        if (dt.Columns.Count == 0)
        {
            CreateExtrasTable();
            dt = (DataTable)ViewState["ExtrasTable"];
        }

        // 3. الخطوة الأهم: التحقق من عدم التكرار
        string selectedExtraID = ddlExtras.SelectedValue;
        foreach (DataRow row in dt.Rows)
        {
            // نقارن الـ ID المختار بـ Extra_id الموجود في الجدول
            if (row["Extra_id"].ToString() == selectedExtraID)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('هذه الإضافة موجودة بالفعل في القائمة')", true);
                return; // نخرج من الدالة ولا نضيف شيئاً
            }
        }

        // 4. إضافة السطر الجديد إذا لم يكن مكرراً
        DataRow dr = dt.NewRow();
        dr["Extra_id"] = int.Parse(selectedExtraID);
        dr["Name"] = ddlExtras.SelectedItem.Text;
        dr["Price"] = decimal.Parse(txtExtraPrice.Text);
        // تأكد من جلب PhotoUrl إذا كنت تحتاجه للعرض، أو اتركه فارغاً مؤقتاً
        dr["PhotoUrl"] = GetPhotoPathFromDB(selectedExtraID);
        dt.Rows.Add(dr);

        // 5. حفظ وتحديث العرض
        ViewState["ExtrasTable"] = dt;
        gvSelectedExtras.DataSource = dt;
        gvSelectedExtras.DataBind();

        // 6. تفريغ الحقول للاستخدام التالي
        txtExtraPrice.Text = "";
        ddlExtras.SelectedIndex = 0;
    }
    private void LoadExtrasGrid(int menuItemId)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string query = @"SELECT E.Name, ME.Price, ME.Extra_id, ME.id, E.PhotoUrl 
                 FROM MenuItems_Extras ME
                 INNER JOIN Extras E ON ME.Extra_id = E.id
                 WHERE ME.MenuItem_id = @MenuItemId";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@MenuItemId", menuItemId);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            // تحويل البيانات لجدول الإضافات في ViewState لتمكين التعديل/الحذف
            ViewState["ExtrasTable"] = dt;
            gvSelectedExtras.DataSource = dt;
            gvSelectedExtras.DataBind();
        }
    }

    void BindMenus()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand(@"SELECT dbo.Menus.id, dbo.Menus.Name, dbo.Menus.NameEn 
                                              FROM dbo.Menus 
                                              INNER JOIN dbo.Places ON dbo.Menus.Categories_id = dbo.Places.Categories_id 
                                              WHERE dbo.Places.id = @PlaceID ORDER BY name", conn);
            cmd.Parameters.AddWithValue("@PlaceID", ddlPlace.SelectedValue);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            ddlMenu.DataSource = dr;
            ddlMenu.DataTextField = "Name";
            ddlMenu.DataValueField = "ID";
            ddlMenu.DataBind();
            ddlMenu.Items.Insert(0, new ListItem("..اختر القائمة..", "0"));
        }
    }

    void BindPlaces()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT ID, Name FROM Places ORDER BY Name", conn);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            ddlPlace.DataSource = dr;
            ddlPlace.DataTextField = "Name";
            ddlPlace.DataValueField = "ID";
            ddlPlace.DataBind();
            ddlPlace.Items.Insert(0, new ListItem("..اختر المكان..", "0"));
        }
    }

    protected void btnAddSizeToList_Click(object sender, EventArgs e)
    {
        if (ddlSizes.SelectedValue == "0" || string.IsNullOrEmpty(txtSizePriceAdd.Text))
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('من فضلك اختر الحجم واكتب السعر')", true);
            return;
        }

        DataTable dt;
        if (ViewState["SelectedSizes"] == null)
        {
            dt = new DataTable();
            dt.Columns.Add("SizeID");
            dt.Columns.Add("SizeName");
            dt.Columns.Add("Price", typeof(decimal));
            dt.Columns.Add("DiscountValue", typeof(decimal));
        }
        else { dt = GetDataTableFromGrid(); }

        string selectedSizeID = ddlSizes.SelectedValue;
        foreach (DataRow row in dt.Rows)
        {
            if (row["SizeID"].ToString() == selectedSizeID)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('هذا الحجم مضاف مسبقاً لهذا الصنف')", true);
                return;
            }
        }

        DataRow dr = dt.NewRow();
        dr["SizeID"] = selectedSizeID;
        dr["SizeName"] = ddlSizes.SelectedItem.Text;
        dr["Price"] = decimal.Parse(txtSizePriceAdd.Text);
        dr["DiscountValue"] = string.IsNullOrEmpty(txtSizeDiscountAdd.Text) ? 0 : decimal.Parse(txtSizeDiscountAdd.Text);
        dt.Rows.Add(dr);

        ViewState["SelectedSizes"] = dt;
        gvSelectedSizes.DataSource = dt;
        gvSelectedSizes.DataBind();
        txtSizePriceAdd.Text = "";
        txtSizeDiscountAdd.Text = "";
        ddlSizes.SelectedValue = "0";
    }

    protected void gvSelectedSizes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (ViewState["SelectedSizes"] != null)
        {
            DataTable dt = (DataTable)ViewState["SelectedSizes"];
            dt.Rows.RemoveAt(e.RowIndex);
            ViewState["SelectedSizes"] = dt;
            gvSelectedSizes.DataSource = dt;
            gvSelectedSizes.DataBind();
        }
    }

    void BindMenuItems(string search = "")
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = @"
                SELECT mi.ID, mi.Name, mi.NameEn, mi.NameRu, mi.Description, mi.DescriptionEn, mi.DescriptionRu, 
                       mi.DiscountValue, mi.IsAvailable, mi.PhotoUrl, mi.PrepearMin, 
                       m.Name AS MenuName, p.Name AS PlaceName
                FROM MenuItems mi
                INNER JOIN Menus m ON mi.MenuID = m.ID
                INNER JOIN Places p ON mi.PlaceID = p.ID";

            if (!string.IsNullOrEmpty(search))
                sql += " WHERE mi.Name LIKE @Search OR mi.Description LIKE @Search";

            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            if (!string.IsNullOrEmpty(search))
                da.SelectCommand.Parameters.AddWithValue("@Search", "%" + search + "%");

            DataTable dt = new DataTable();
            da.Fill(dt);
            gvMenuItems.DataSource = dt;
            gvMenuItems.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        string photoPath = hfPhotoPath.Value;

        if (fuPhoto.HasFile)
        {
            string ext = Path.GetExtension(fuPhoto.FileName).ToLower();
            if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif")
            {
                string fileName = Guid.NewGuid().ToString() + ext;
                string savePath = Server.MapPath("~/ar/images/items/") + fileName;
                fuPhoto.SaveAs(savePath);
                photoPath = "images/items/" + fileName;
            }
        }

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlTransaction trans = conn.BeginTransaction();
            try
            {
                int currentID = 0;
                string sql = "";
                if (ViewState["EditID"] != null)
                {
                    currentID = (int)ViewState["EditID"];
                    sql = @"UPDATE MenuItems SET MenuID=@MenuID, PlaceID=@PlaceID, Name=@Name, NameEn=@NameEn, NameRu=@NameRu,Price=@Price 
                        Description=@Desc, DescriptionEn=@DescEn, DescriptionRu=@DescRu,
                        DiscountValue=@Discount, PhotoUrl=@Photo, 
                        IsAvailable=@IsAvailable, PrepearMin=@PrepearMin
                        WHERE ID=@ID";
                }
                else
                {
                    sql = @"INSERT INTO MenuItems (MenuID, PlaceID, Name, NameEn, NameRu, Description, DescriptionEn, DescriptionRu,Price, 
                        DiscountValue, PhotoUrl, IsAvailable, CreatedAt, PrepearMin)
                        VALUES (@MenuID, @PlaceID, @Name, @NameEn, @NameRu, @Desc, @DescEn, @DescRu,@Price, 
                        @Discount, @Photo, @IsAvailable, @CreatedAt, @PrepearMin);
                        SELECT SCOPE_IDENTITY();";
                }

                SqlCommand cmd = new SqlCommand(sql, conn, trans);
                cmd.Parameters.AddWithValue("@MenuID", ddlMenu.SelectedValue);
                cmd.Parameters.AddWithValue("@PlaceID", ddlPlace.SelectedValue);
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@NameEn", txtNameEn.Text.Trim());
                cmd.Parameters.AddWithValue("@NameRu", txtNameRu.Text.Trim());
                cmd.Parameters.AddWithValue("@Price", string.IsNullOrEmpty(txtPrice.Text) ? 0 : decimal.Parse(txtPrice.Text));
                cmd.Parameters.AddWithValue("@Desc", string.IsNullOrEmpty(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@DescEn", string.IsNullOrEmpty(txtDescriptionEn.Text) ? (object)DBNull.Value : txtDescriptionEn.Text.Trim());
                cmd.Parameters.AddWithValue("@DescRu", string.IsNullOrEmpty(txtDescriptionRu.Text) ? (object)DBNull.Value : txtDescriptionRu.Text.Trim());
                cmd.Parameters.AddWithValue("@Discount", string.IsNullOrEmpty(txtDiscount.Text) ? 0 : decimal.Parse(txtDiscount.Text));
                cmd.Parameters.AddWithValue("@Photo", string.IsNullOrEmpty(photoPath) ? (object)DBNull.Value : photoPath);
                cmd.Parameters.AddWithValue("@IsAvailable", chkAvailable.Checked);
                cmd.Parameters.AddWithValue("@PrepearMin", string.IsNullOrEmpty(txtPrepearMin.Text) ? 0 : int.Parse(txtPrepearMin.Text));

                if (ViewState["EditID"] != null) { cmd.Parameters.AddWithValue("@ID", currentID); cmd.ExecuteNonQuery(); }
                else { cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now); currentID = Convert.ToInt32(cmd.ExecuteScalar()); }

                // معالجة الأحجام
                SqlCommand cmdDelSizes = new SqlCommand("DELETE FROM MenuItems_Sizes WHERE MenuItems_id = @itemID", conn, trans);
                cmdDelSizes.Parameters.AddWithValue("@itemID", currentID);
                cmdDelSizes.ExecuteNonQuery();
                bool hasSizesAdded = false;
                DataTable dtSizes = GetDataTableFromGrid();
                if (dtSizes != null && dtSizes.Rows.Count > 0)
                {
                    foreach (DataRow row in dtSizes.Rows)
                    {
                        SqlCommand cmdSize = new SqlCommand(@"INSERT INTO MenuItems_Sizes (MenuItems_id, Size_id, Price, DiscountValue) 
                                                              VALUES (@itemID, @sizeID, @price, @disc)", conn, trans);
                        cmdSize.Parameters.AddWithValue("@itemID", currentID);
                        cmdSize.Parameters.AddWithValue("@sizeID", row["SizeID"]);
                        cmdSize.Parameters.AddWithValue("@price", row["Price"]);
                        cmdSize.Parameters.AddWithValue("@disc", row["DiscountValue"]);
                        cmdSize.ExecuteNonQuery();
                    }
                    hasSizesAdded = true;
                }

                if (!hasSizesAdded)
                {
                    int defaultSizeID = 1;
                    decimal defaultPrice = string.IsNullOrEmpty(txtPrice.Text.Trim()) ? 0 : decimal.Parse(txtPrice.Text.Trim());
                    SqlCommand cmdDefault = new SqlCommand(@"INSERT INTO MenuItems_Sizes (MenuItems_id, Size_id, Price) 
                                                         VALUES (@itemID, @sizeID, @price)", conn, trans);
                    cmdDefault.Parameters.AddWithValue("@itemID", currentID);
                    cmdDefault.Parameters.AddWithValue("@sizeID", defaultSizeID);
                    cmdDefault.Parameters.AddWithValue("@price", defaultPrice);
                    cmdDefault.ExecuteNonQuery();
                }

                // معالجة الإضافات
                SqlCommand cmdDelExtras = new SqlCommand("DELETE FROM MenuItems_Extras WHERE MenuItem_id = @itemID", conn, trans);
                cmdDelExtras.Parameters.AddWithValue("@itemID", currentID);
                cmdDelExtras.ExecuteNonQuery();

                if (ViewState["ExtrasTable"] != null)
                {
                    // تحديث الجدول بالقيم المكتوبة في الجريد أولاً
                    DataTable dtExtras = GetExtrasDataTableFromGrid();
                    foreach (DataRow row in dtExtras.Rows)
                    {
                        SqlCommand cmdExtra = new SqlCommand(@"INSERT INTO MenuItems_Extras (MenuItem_id, Extra_id, Price) 
                                                               VALUES (@itemID, @extraID, @price)", conn, trans);
                        cmdExtra.Parameters.AddWithValue("@itemID", currentID);
                        cmdExtra.Parameters.AddWithValue("@extraID", row["Extra_id"]);
                        cmdExtra.Parameters.AddWithValue("@price", row["Price"]);
                        cmdExtra.ExecuteNonQuery();
                    }
                }

                trans.Commit();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('تم حفظ البيانات الصنف بنجاح ')", true);
                ClearForm();
                BindMenuItems(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                trans.Rollback();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "error", "alert('خطأ: " + ex.Message.Replace("'", "") + "')", true);
            }
        }
    }
    private DataTable GetExtrasDataTableFromGrid()
    {
        DataTable dt = (DataTable)ViewState["ExtrasTable"];
        if (dt != null)
        {
            foreach (GridViewRow row in gvSelectedExtras.Rows)
            {
                // بنجيب الـ ID المخفي أو من الـ DataKeys
                int extraId = Convert.ToInt32(gvSelectedExtras.DataKeys[row.RowIndex].Value);

                // بنجيب الـ TextBox اللي فيه السعر
                TextBox txtPrice = (TextBox)row.FindControl("txtGridPrice");

                // بنحدث السطر المقابل في الـ DataTable
                DataRow[] dr = dt.Select("Extra_id = " + extraId);
                if (dr.Length > 0)
                {
                    dr[0]["Price"] = decimal.Parse(txtPrice.Text);
                }
            }
        }
        return dt;
    }
    protected void gvMenuItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandArgument == null || e.CommandArgument.ToString() == "") return;
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "DeleteItem")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM MenuItems WHERE ID=@ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            BindMenuItems(txtSearch.Text.Trim());
        }
        else if (e.CommandName == "EditItem")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM MenuItems WHERE ID=@ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    ddlPlace.SelectedValue = dr["PlaceID"].ToString();
                    BindMenus();
                    ddlMenu.SelectedValue = dr["MenuID"].ToString();
                    txtPrepearMin.Text = dr["PrepearMin"].ToString();
                    txtName.Text = dr["Name"].ToString();
                    txtNameEn.Text = dr["NameEn"].ToString();
                    txtNameRu.Text = dr["NameRu"].ToString();
                    txtDescription.Text = dr["Description"].ToString();
                    txtDescriptionEn.Text = dr["DescriptionEn"].ToString();
                    txtDescriptionRu.Text = dr["DescriptionRu"].ToString();
                    txtDiscount.Text = dr["DiscountValue"].ToString();
                    hfPhotoPath.Value = dr["PhotoUrl"].ToString();
                    chkAvailable.Checked = (bool)dr["IsAvailable"];
                    ViewState["EditID"] = id;
                    btnSave.Text = "تعديل";
                }
                dr.Close();
            }
            BindSizesGrid(id);
            LoadExtrasGrid(id); // تحميل الإضافات عند التعديل
        }
    }

    void ClearForm()
    {
        ddlMenu.SelectedValue = "0";
        ddlPlace.SelectedValue = "0";
        txtPrepearMin.Text = "0";
        txtName.Text = "";
        txtNameEn.Text = "";
        txtNameRu.Text = "";
        txtDescription.Text = "";
        txtDescriptionEn.Text = "";
        txtDescriptionRu.Text = "";
        txtDiscount.Text = "0";
        txtPrice.Text = "0";
        hfPhotoPath.Value = "";
        chkAvailable.Checked = true;
        btnSave.Text = "حفظ";
        ViewState["EditID"] = null;
        ViewState["ExtrasTable"] = null;
        ViewState["SelectedSizes"] = null;
        gvSelectedSizes.DataSource = null; gvSelectedSizes.DataBind();
        gvSelectedExtras.DataSource = null; gvSelectedExtras.DataBind();
    }

    private DataTable GetDataTableFromGrid()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("SizeID");
        dt.Columns.Add("SizeName");
        dt.Columns.Add("Price", typeof(decimal));
        dt.Columns.Add("DiscountValue", typeof(decimal));
        foreach (GridViewRow row in gvSelectedSizes.Rows)
        {
            DataRow dr = dt.NewRow();
            dr["SizeID"] = ((Label)row.FindControl("lblSizeID")).Text;
            dr["SizeName"] = row.Cells[0].Text;
            dr["Price"] = decimal.Parse(((TextBox)row.FindControl("txtGridPrice")).Text);
            dr["DiscountValue"] = decimal.Parse(((TextBox)row.FindControl("txtGridDiscount")).Text);
            dt.Rows.Add(dr);
        }
        return dt;
    }

    protected void ddlPlace_SelectedIndexChanged(object sender, EventArgs e) { BindMenus(); }
    protected void btnCancel_Click(object sender, EventArgs e) { ClearForm(); }
    protected void btnSearch_Click(object sender, EventArgs e) { BindMenuItems(txtSearch.Text.Trim()); }
    protected void gvMenuItems_PageIndexChanging(object sender, GridViewPageEventArgs e) { gvMenuItems.PageIndex = e.NewPageIndex; BindMenuItems(txtSearch.Text.Trim()); }
}