using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class Places_Menu : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["PlaceID"] == null) Response.Redirect("Login.aspx");
        if (!IsPostBack)
        {
            LoadInitialData();
            BindMenuItems(); // تحميل كل الأصناف عند البداية
            InitializeTables();
        }
    }

    private void InitializeTables()
    {
        DataTable dtS = new DataTable();
        dtS.Columns.Add("SizeID"); dtS.Columns.Add("SizeName"); dtS.Columns.Add("Price"); dtS.Columns.Add("DiscountValue");
        ViewState["Sizes"] = dtS;

        DataTable dtE = new DataTable();
        dtE.Columns.Add("ExtraID"); dtE.Columns.Add("ExtraName"); dtE.Columns.Add("Price"); dtE.Columns.Add("PhotoUrl");
        ViewState["Extras"] = dtE;
    }

    private void LoadInitialData()
    {
        int placeId = Convert.ToInt32(Session["PlaceID"]);
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            SqlDataAdapter daM = new SqlDataAdapter("SELECT id, Name FROM Menus WHERE Categories_id = (SELECT Categories_id FROM Places WHERE id = @pid)", conn);
            daM.SelectCommand.Parameters.AddWithValue("@pid", placeId);
            DataTable dtM = new DataTable(); daM.Fill(dtM);
            ddlMenu.DataSource = dtM; ddlMenu.DataTextField = "Name"; ddlMenu.DataValueField = "id"; ddlMenu.DataBind();
            ddlMenu.Items.Insert(0, new ListItem("-- اختر القسم --", "0"));

            SqlDataAdapter daS = new SqlDataAdapter("SELECT id, Name FROM Sizes", conn);
            DataTable dtS = new DataTable(); daS.Fill(dtS);
            ddlSizes.DataSource = dtS; ddlSizes.DataTextField = "Name"; ddlSizes.DataValueField = "id"; ddlSizes.DataBind();
            ddlSizes.Items.Insert(0, new ListItem("-- الحجم --", "0"));

            SqlDataAdapter daE = new SqlDataAdapter("SELECT id, Name FROM Extras ORDER BY id DESC", conn);
            DataTable dtE = new DataTable(); daE.Fill(dtE);
            ddlExtras.DataSource = dtE; ddlExtras.DataTextField = "Name"; ddlExtras.DataValueField = "id"; ddlExtras.DataBind();
            ddlExtras.Items.Insert(0, new ListItem("-- الإضافة --", "0"));
        }
    }

    // *** منطق البحث ***
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindMenuItems(txtSearch.Text.Trim());
    }

    protected void txtSearch_TextChanged(object sender, EventArgs e)
    {
        BindMenuItems(txtSearch.Text.Trim()); // بحث تلقائي عند الكتابة
    }

    private void BindMenuItems(string searchText = "")
    {
        int pid = Convert.ToInt32(Session["PlaceID"]);
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = @"SELECT mi.*, m.Name as MenuName 
                           FROM MenuItems mi 
                           JOIN Menus m ON mi.MenuID = m.id 
                           WHERE mi.PlaceID = @pid";

            // إضافة جملة البحث لو الحقل مش فاضي
            if (!string.IsNullOrEmpty(searchText))
            {
                sql += " AND (mi.Name LIKE @search OR mi.NameEn LIKE @search OR mi.NameRu LIKE @search)";
            }

            sql += " ORDER BY mi.id DESC";

            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            da.SelectCommand.Parameters.AddWithValue("@pid", pid);
            if (!string.IsNullOrEmpty(searchText))
            {
                da.SelectCommand.Parameters.AddWithValue("@search", "%" + searchText + "%");
            }

            DataTable dt = new DataTable();
            da.Fill(dt);
            gvMenuItems.DataSource = dt;
            gvMenuItems.DataBind();
            upGrid.Update();
        }
    }

    private void SyncGridsWithViewState()
    {
          DataTable dtS = (DataTable)ViewState["Sizes"];
        foreach (GridViewRow row in gvSizes.Rows)
        {
            string sid = ((Label)row.FindControl("lblSizeID")).Text;
            string p = ((TextBox)row.FindControl("txtGridSizePrice")).Text;
            string d = ((TextBox)row.FindControl("txtGridSizeDisc")).Text;
            foreach (DataRow dr in dtS.Rows) { if (dr["SizeID"].ToString() == sid) { dr["Price"] = p; dr["DiscountValue"] = d; break; } }
        }
        ViewState["Sizes"] = dtS;

        DataTable dtE = (DataTable)ViewState["Extras"];
        foreach (GridViewRow row in gvExtras.Rows)
        {
            string eid = ((Label)row.FindControl("lblExtraID")).Text;
            string p = ((TextBox)row.FindControl("txtGridExtraPrice")).Text;
            foreach (DataRow dr in dtE.Rows) { if (dr["ExtraID"].ToString() == eid) { dr["Price"] = p; break; } }
        }
        ViewState["Extras"] = dtE;
    }

    protected void btnSaveAll_Click(object sender, EventArgs e)
    {
        SyncGridsWithViewState();
        int placeId = Convert.ToInt32(Session["PlaceID"]);
        string photoPath = string.IsNullOrEmpty(hfExistingPhoto.Value) ? "images/items/default.png" : hfExistingPhoto.Value;

        // معالجة الصورة من الـ HiddenField (Base64) لضمان عدم ضياعها مع الـ AJAX
        if (!string.IsNullOrEmpty(hfImageBase64.Value))
        {
            try
            {
                string b64 = hfImageBase64.Value;
                string header = b64.Substring(0, b64.IndexOf(";"));
                string extension = "." + header.Substring(header.IndexOf("/") + 1);
                string data = b64.Substring(b64.IndexOf(",") + 1);
                byte[] bytes = Convert.FromBase64String(data);
                string fileName = Guid.NewGuid().ToString() + extension;
                string folderPath = Server.MapPath("~/ar/images/items/");
                if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);
                File.WriteAllBytes(folderPath + fileName, bytes);
                photoPath = "images/items/" + fileName;
            }
            catch { }
        }
        else if (fuItemPhoto.HasFile)
        {
            string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuItemPhoto.FileName);
            fuItemPhoto.SaveAs(Server.MapPath("~/ar/images/items/") + fileName);
            photoPath = "images/items/" + fileName;
        }

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlTransaction trans = conn.BeginTransaction();
            try
            {
                int itemId;
                if (ViewState["EditID"] == null)
                {
                    string sql = @"INSERT INTO MenuItems (MenuID, PlaceID, Name, NameEn, NameRu, Description, DescriptionEn, DescriptionRu, PhotoUrl, IsAvailable, CreatedAt, PrepearMin, Price, DiscountValue) 
                                   VALUES (@mid, @pid, @nAr, @nEn, @nRu, @dAr, @dEn, @dRu, @img, 1, GETDATE(), @prep, 0, 0); SELECT SCOPE_IDENTITY();";
                    SqlCommand cmd = new SqlCommand(sql, conn, trans);
                    SetItemParams(cmd, placeId, photoPath);
                    itemId = Convert.ToInt32(cmd.ExecuteScalar());
                }
                else
                {
                    itemId = (int)ViewState["EditID"];
                    string sql = @"UPDATE MenuItems SET MenuID=@mid, Name=@nAr, NameEn=@nEn, NameRu=@nRu, Description=@dAr, DescriptionEn=@dEn, DescriptionRu=@dRu, PhotoUrl=@img, PrepearMin=@prep WHERE id=@eid";
                    SqlCommand cmd = new SqlCommand(sql, conn, trans);
                    cmd.Parameters.AddWithValue("@eid", itemId);
                    SetItemParams(cmd, placeId, photoPath);
                    cmd.ExecuteNonQuery();
                    new SqlCommand("DELETE FROM MenuItems_Sizes WHERE MenuItems_id=" + itemId, conn, trans).ExecuteNonQuery();
                    new SqlCommand("DELETE FROM MenuItems_Extras WHERE MenuItem_id=" + itemId, conn, trans).ExecuteNonQuery();
                }

                DataTable dtSizes = (DataTable)ViewState["Sizes"];
                if (dtSizes.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtSizes.Rows)
                    {
                        SqlCommand cmdS = new SqlCommand("INSERT INTO MenuItems_Sizes (MenuItems_id, Size_id, Price, DiscountValue) VALUES (@iid, @sid, @p, @d)", conn, trans);
                        cmdS.Parameters.AddWithValue("@iid", itemId); cmdS.Parameters.AddWithValue("@sid", dr["SizeID"]);
                        cmdS.Parameters.AddWithValue("@p", dr["Price"]); cmdS.Parameters.AddWithValue("@d", dr["DiscountValue"]); cmdS.ExecuteNonQuery();
                    }
                }
                else
                {
                    SqlCommand cmdDef = new SqlCommand("INSERT INTO MenuItems_Sizes (MenuItems_id, Size_id, Price, DiscountValue) VALUES (@iid, 1, @p, @d)", conn, trans);
                    cmdDef.Parameters.AddWithValue("@iid", itemId); cmdDef.Parameters.AddWithValue("@p", string.IsNullOrEmpty(txtBasicPrice.Text) ? "0" : txtBasicPrice.Text);
                    cmdDef.Parameters.AddWithValue("@d", string.IsNullOrEmpty(txtBasicDiscount.Text) ? "0" : txtBasicDiscount.Text); cmdDef.ExecuteNonQuery();
                }

                DataTable dtExtras = (DataTable)ViewState["Extras"];
                foreach (DataRow dr in dtExtras.Rows)
                {
                    SqlCommand cmdE = new SqlCommand("INSERT INTO MenuItems_Extras (MenuItem_id, Extra_id, Price) VALUES (@iid, @eid, @p)", conn, trans);
                    cmdE.Parameters.AddWithValue("@iid", itemId); cmdE.Parameters.AddWithValue("@eid", dr["ExtraID"]);
                    cmdE.Parameters.AddWithValue("@p", dr["Price"]); cmdE.ExecuteNonQuery();
                }

                trans.Commit();
                ClearForm(); BindMenuItems();
                ScriptManager.RegisterStartupScript(this, GetType(), "v", "alert('تم حفظ الصنف بنجاح');", true);
            }
            catch (Exception ex) { trans.Rollback(); ScriptManager.RegisterStartupScript(this, GetType(), "v", "alert('خطأ: " + ex.Message.Replace("'", "") + "');", true); }
        }
    }

    private void SetItemParams(SqlCommand cmd, int pid, string img)
    {
        cmd.Parameters.AddWithValue("@mid", ddlMenu.SelectedValue); cmd.Parameters.AddWithValue("@pid", pid);
        cmd.Parameters.AddWithValue("@nAr", txtNameAr.Text); cmd.Parameters.AddWithValue("@nEn", txtNameEn.Text); cmd.Parameters.AddWithValue("@nRu", txtNameRu.Text);
        cmd.Parameters.AddWithValue("@dAr", txtDescAr.Text); cmd.Parameters.AddWithValue("@dEn", txtDescEn.Text); cmd.Parameters.AddWithValue("@dRu", txtDescRu.Text);
        cmd.Parameters.AddWithValue("@img", img); cmd.Parameters.AddWithValue("@prep", string.IsNullOrEmpty(txtPrepTime.Text) ? "0" : txtPrepTime.Text);
    }

    protected void gvMenuItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandArgument == null || e.CommandArgument.ToString() == "") return;
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditItem")
        {
            ViewState["EditID"] = id;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM MenuItems WHERE id=" + id, conn);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    ddlMenu.SelectedValue = dr["MenuID"].ToString(); txtNameAr.Text = dr["Name"].ToString(); txtNameEn.Text = dr["NameEn"].ToString(); txtNameRu.Text = dr["NameRu"].ToString();
                    txtPrepTime.Text = dr["PrepearMin"].ToString(); txtDescAr.Text = dr["Description"].ToString(); txtDescEn.Text = dr["DescriptionEn"].ToString(); txtDescRu.Text = dr["DescriptionRu"].ToString();
                    hfExistingPhoto.Value = dr["PhotoUrl"].ToString();
                    hfImageBase64.Value = ""; // تصفير الـ base64 عند التعديل
                }
                dr.Close();
                SqlDataAdapter daS = new SqlDataAdapter("SELECT MIS.Size_id as SizeID, S.Name as SizeName, MIS.Price, MIS.DiscountValue FROM MenuItems_Sizes MIS JOIN Sizes S ON MIS.Size_id = S.id WHERE MIS.MenuItems_id=" + id, conn);
                DataTable dtS = new DataTable(); daS.Fill(dtS); ViewState["Sizes"] = dtS;
                if (dtS.Rows.Count == 1 && dtS.Rows[0]["SizeID"].ToString() == "1")
                {
                    txtBasicPrice.Text = dtS.Rows[0]["Price"].ToString(); txtBasicDiscount.Text = dtS.Rows[0]["DiscountValue"].ToString();
                    dtS.Clear(); ViewState["Sizes"] = dtS; gvSizes.DataSource = null; gvSizes.DataBind();
                }
                else { gvSizes.DataSource = dtS; gvSizes.DataBind(); }

                SqlDataAdapter daE = new SqlDataAdapter("SELECT MIE.Extra_id as ExtraID, E.Name as ExtraName, MIE.Price, E.PhotoUrl FROM MenuItems_Extras MIE JOIN Extras E ON MIE.Extra_id = E.id WHERE MIE.MenuItem_id=" + id, conn);
                DataTable dtE = new DataTable(); daE.Fill(dtE); ViewState["Extras"] = dtE; gvExtras.DataSource = dtE; gvExtras.DataBind();
                btnSaveAll.Text = "تحديث الصنف"; upMenu.Update();
            }
        }
        else if (e.CommandName == "DeleteItem")
        {
            using (SqlConnection conn = new SqlConnection(connStr)) { conn.Open(); new SqlCommand("DELETE FROM MenuItems WHERE id=" + id, conn).ExecuteNonQuery(); }
            BindMenuItems(txtSearch.Text.Trim());
        }
    }

    protected void btnAddSize_Click(object sender, EventArgs e)
    {
        SyncGridsWithViewState(); DataTable dt = (DataTable)ViewState["Sizes"];
        dt.Rows.Add(ddlSizes.SelectedValue, ddlSizes.SelectedItem.Text, txtSizePrice.Text, txtSizeDiscount.Text);
        gvSizes.DataSource = dt; gvSizes.DataBind();
    }

    protected void btnAddExtra_Click(object sender, EventArgs e)
    {
        SyncGridsWithViewState(); DataTable dt = (DataTable)ViewState["Extras"];
        string img = "images/Extras/default.png";
        using (SqlConnection conn = new SqlConnection(connStr)) { conn.Open(); object res = new SqlCommand("SELECT PhotoUrl FROM Extras WHERE id=" + ddlExtras.SelectedValue, conn).ExecuteScalar(); if (res != null) img = res.ToString(); }
        dt.Rows.Add(ddlExtras.SelectedValue, ddlExtras.SelectedItem.Text, txtExtraPrice.Text, img);
        gvExtras.DataSource = dt; gvExtras.DataBind();
    }

    protected void btnSaveExtraType_Click(object sender, EventArgs e)
    {
        string img = "images/Extras/default.png";
        if (fuExtraIcon.HasFile) { string fn = Guid.NewGuid().ToString() + Path.GetExtension(fuExtraIcon.FileName); fuExtraIcon.SaveAs(Server.MapPath("~/ar/images/Extras/") + fn); img = "images/Extras/" + fn; }
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open(); SqlCommand cmd = new SqlCommand("INSERT INTO Extras (Name, NameEn, NameRu, Price, PhotoUrl) VALUES (@n, @e, @r, @p, @img)", conn);
            cmd.Parameters.AddWithValue("@n", txtNewExtraNameAr.Text); cmd.Parameters.AddWithValue("@e", txtNewExtraNameEn.Text); cmd.Parameters.AddWithValue("@r", txtNewExtraNameRu.Text);
            cmd.Parameters.AddWithValue("@p", txtNewExtraDefaultPrice.Text); cmd.Parameters.AddWithValue("@img", img); cmd.ExecuteNonQuery();
        }
        LoadInitialData(); upMenu.Update(); ScriptManager.RegisterStartupScript(this, GetType(), "c", "$('#modalNewExtraType').modal('hide');", true);
    }

    protected void btnCancelEdit_Click(object sender, EventArgs e) { ClearForm(); }
    private void ClearForm()
    {
        txtNameAr.Text = txtNameEn.Text = txtNameRu.Text = txtDescAr.Text = txtDescEn.Text = txtDescRu.Text = txtBasicPrice.Text = txtBasicDiscount.Text = "";
        txtPrepTime.Text = "0"; hfExistingPhoto.Value = ""; hfImageBase64.Value = ""; ViewState["EditID"] = null; btnSaveAll.Text = "حفظ الصنف بالكامل";
        InitializeTables(); gvSizes.DataSource = gvExtras.DataSource = null; gvSizes.DataBind(); gvExtras.DataBind(); upMenu.Update();
    }

    protected void gvSizes_RowDeleting(object sender, GridViewDeleteEventArgs e) { SyncGridsWithViewState(); DataTable dt = (DataTable)ViewState["Sizes"]; dt.Rows.RemoveAt(e.RowIndex); ViewState["Sizes"] = dt; gvSizes.DataSource = dt; gvSizes.DataBind(); }
    protected void gvExtras_RowDeleting(object sender, GridViewDeleteEventArgs e) { SyncGridsWithViewState(); DataTable dt = (DataTable)ViewState["Extras"]; dt.Rows.RemoveAt(e.RowIndex); ViewState["Extras"] = dt; gvExtras.DataSource = dt; gvExtras.DataBind(); }
}