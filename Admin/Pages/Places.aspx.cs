using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.IO;
using DMS;
using System.Web.Services;

public partial class Admin_Pages_Places: System.Web.UI.Page
{    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            FillcbCategories();
            FillcbCategories2();
            BindGov();
            BindGrid();
        }

    }
    void BindGov()
    {

        Gov Gover = new Gov();
        if (Gover.LoadAll())
        {
            ddlGov.DataSource = Gover.DefaultView;
            ddlGov.DataTextField = DMS.Categories.ColumnNames.Name;
            ddlGov.DataValueField = DMS.Categories.ColumnNames.Id;
            ddlGov.DataBind();
        }
    }
    private void FillcbCategories2()
    {
        DMS.Categories Catg = new DMS.Categories();
        Catg.Where.Active.Operator = WhereParameter.Operand.Equal;
        Catg.Where.Active.Value = true;
        if (Catg.Query.Load())
        {
            cbCategory2.DataSource = Catg.DefaultView;
            cbCategory2.DataTextField = DMS.Categories.ColumnNames.Name;
            cbCategory2.DataValueField = DMS.Categories.ColumnNames.Id;
            cbCategory2.DataBind();
        }
    }

    
    private void FillcbCategories()
    {
        DMS.Categories Catg = new DMS.Categories();
        Catg.Where.Active.Operator = WhereParameter.Operand.Equal;
        Catg.Where.Active.Value = true;
        if (Catg.Query.Load())
        {
            cbCategory.DataSource = Catg.DefaultView;
            cbCategory.DataTextField = DMS.Categories.ColumnNames.Name;
            cbCategory.DataValueField = DMS.Categories.ColumnNames.Id;
            cbCategory.DataBind();
        }
    }

    protected void cbBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        //FillcbPreRequest();
    }
    protected void cbBranchS_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }
    protected void cbCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }


    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }

    protected void gvPlaces_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ViewDetails")
        {
            //ltcontent.Text = "<iframe src='DeliveryZones.aspx?id=" + e.CommandArgument + "' width='100%' height='100%' style='overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px' height='100%' width='100%'></iframe>";
            ltcontent.Text = "<iframe src='DeliveryZones2.aspx?PlacesID=" + e.CommandArgument + "' width='100%' height='100%' style='overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px' height='100%' width='100%'></iframe>";
            string title = "إدارة مناطق التوصيل";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup2('" + title + "');", true);
            return;
            //Response.Redirect("~/admin/pages/DeliveryZones.aspx");
        }

        if (e.CommandName == "schadual")
        {
            //ltcontent.Text = "<iframe src='DeliveryZones.aspx?id=" + e.CommandArgument + "' width='100%' height='100%' style='overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px' height='100%' width='100%'></iframe>";
            ltcontent.Text = "<iframe src='PlacesDelivery.aspx?place_id=" + e.CommandArgument + "' width='100%' height='100%' style='overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px' height='100%' width='100%'></iframe>";
            string title = "جدول مواعيد التوصيل للمطعم";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup2('" + title + "');", true);
            return;
            //Response.Redirect("~/admin/pages/DeliveryZones.aspx");
        }
        if (e.CommandName == "MapTypes")
        {
            ltcontent.Text = "<iframe src='PlaceTypesMap.aspx?place_id=" + e.CommandArgument + "' width='100%' height='100%' style='overflow:hidden;overflow-x:hidden;overflow-y:hidden;height:100%;width:100%;position:absolute;top:0px;left:0px;right:0px;bottom:0px' height='100%' width='100%'></iframe>";
            string title = "فئات الاماكن";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup2('" + title + "');", true);
            return;
        }
        if (e.CommandName == "EditPlaces")
        {

            ViewState["id"] = int.Parse(e.CommandArgument.ToString());
            UpdatePlaces(int.Parse(e.CommandArgument.ToString()));
        }
        if (e.CommandName == "DeletePlaces")
        {
            Places Place = new Places();
            Place.LoadByPrimaryKey(int.Parse(e.CommandArgument.ToString()));
            Place.DeleteAll();
            try
            {
                Place.Save();
                BindGrid();
                ClearData();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حذف", "alert('لقد تمت عملية الحذف بنجاح')", true);
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حذف", "alert('لا يمكن حذف المكان لارتباطها ببيانات أخرى')", true);
            }

        }
    }
   
    private void UpdatePlaces(int p)
    {
        Session["fs"] = null;
        Session["banner_fs"] = null;
        Places Place = new Places();
        Place.LoadByPrimaryKey(p);
        txtName.Text = Place.Name;
        txtNameEn.Text = Place.NameEn;
        txtNameRu.Text = Place.NameRu;
        txtUserName.Text = Place.UserName;
        txtPass.Text = Place.Pass;
        imgBanner.ImageUrl = "~/ar/" + Place.Banner;
        cbCategory2.SelectedValue = Place.s_Categories_id;
        Areas area = new Areas();
        area.LoadByPrimaryKey(Place.Areas_id);
        ddlGov.SelectedValue = area.s_Gov_id;
        BindAreas();
        ddlArea.SelectedValue = Place.s_Areas_id;
        ddlrate.SelectedValue = Place.s_Rate;
        txtAddress.Text = Place.Address;
        txtDescription.Text = Place.Description;
        txtDescriptionEn.Text = Place.DescriptionEn;
        txtDescriptionRu.Text = Place.DescriptionRu;

        txtDeliveredTime.Text = Place.s_DeliveredTime;
        txtMinOrder.Text = Place.s_MinOrder;
        cbActive.Checked = Place.Active;
        Image2.ImageUrl = "~/ar/" + Place.PhotoPath;
        btnSave.Text = "تعديل";
        string title = "تعديل الأماكن";
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup('" + title + "');", true);
        return;
    }

    private void BindGrid()
    {
        vw_Places Place = new vw_Places();
        
        if (txtSearch.Text != string.Empty)
        {
            Place.Where.Name.Operator = WhereParameter.Operand.Like;
            Place.Where.Name.Value = "%" + txtSearch.Text + "%";
            Place.Where.NameEn.Operator = WhereParameter.Operand.Like;
            Place.Where.NameEn.Value = "%" + txtSearch.Text + "%";
            Place.Where.NameEn.Conjuction = WhereParameter.Conj.Or;           
        }

        if (cbCategory.SelectedIndex != 0)
        {
            Place.Where.Categories_id.Operator = WhereParameter.Operand.Equal;
            Place.Where.Categories_id.Value = cbCategory.SelectedValue;

        }
        
        if (Place.Query.Load())
        {
            gvPlaces.DataSource = Place.DefaultView;
            gvPlaces.DataBind();
            lblCount.Text = Place.RowCount.ToString();
        }
        else
        {
            gvPlaces.DataSource = null;
            gvPlaces.DataBind();
            lblCount.Text = "0";
        }
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkbox = (CheckBox)sender;
        GridViewRow Grow = (GridViewRow)chkbox.NamingContainer;
        string z = ((HiddenField)Grow.FindControl("hf")).Value;
        Places Place = new Places();
        Place.LoadByPrimaryKey(Convert.ToInt32(z));
        Place.Active = chkbox.Checked;
        Place.Save();
    }
    protected void gvPlaces_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        gvPlaces.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void btnClose_Click(object sender, EventArgs e)
    {
        BindGrid();
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "#MyPopup", "$('body').removeClass('modal-open');$('.modal-backdrop').remove();$('#MyPopup2').hide();", true);
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
     
        Places Place = new Places();

        if (btnSave.Text == "حفظ")
        {
            Place.AddNew();
        }
        else
        {
            Place.LoadByPrimaryKey(int.Parse(ViewState["id"].ToString()));
        }
        Place.Name = txtName.Text.Trim();
        Place.NameEn = txtNameEn.Text.Trim();
        Place.NameRu = txtNameRu.Text.Trim();

        Place.Categories_id = Convert.ToInt32(cbCategory2.SelectedValue);
        Place.Address = txtAddress.Text.Trim();
        Place.Description = txtDescription.Text.Trim();
        Place.DescriptionEn = txtDescriptionEn.Text.Trim();
        Place.DescriptionRu = txtDescriptionRu.Text.Trim();
        Place.DeliveredTime = Convert.ToInt32(txtDeliveredTime.Text);
        Place.Rate = Convert.ToInt32(ddlrate.SelectedValue);
        Place.Areas_id = Convert.ToInt32(ddlArea.SelectedValue);
        if (Session["fs"] != null)
        {
            string filePath = "images/Places/" + Guid.NewGuid().ToString() + ".png";
            File.WriteAllBytes(Server.MapPath("~/ar/"+filePath), (byte[])Session["fs"]);
            Place.PhotoPath = filePath;
        }
        if (Session["banner_fs"] != null)
        {
            string bannerPath = "images/Places/Banners/" + Guid.NewGuid().ToString() + ".png";
            File.WriteAllBytes(Server.MapPath("~/ar/" + bannerPath), (byte[])Session["banner_fs"]);
            Place.Banner = bannerPath;
        }
        Place.MinOrder = Convert.ToDecimal(txtMinOrder.Text);

        Place.Active = cbActive.Checked;
        Place.UserName = txtUserName.Text.Trim();
        Place.Pass = txtPass.Text.Trim();
        if (!string.IsNullOrEmpty(txtPOrder.Text))
        {
            Place.POrder = Convert.ToInt32(txtPOrder.Text);
        }
        else
        {
            Place.POrder = 0; // القيمة الافتراضية
        }
        try
        {
            Place.Save();
            BindGrid();
            ClearData();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);
            string title = "إضافة الأماكن";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup('" + title + "');", true);
            return;
        }
        catch (Exception ex)
        {
            if (ex.Message.Contains("IX_Branches"))
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "خطأ", "alert('يوجد مكان مسجل بهذا الاسم')", true);
            }
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearData();      
    }
    private void ClearData()
    {
        Session["fs"] = null;
        btnSave.Text = "حفظ";
        txtName.Text = string.Empty;
        txtNameEn.Text = string.Empty;
        txtNameRu.Text = string.Empty;
        txtPOrder.Text = "0";
        Image2.ImageUrl = "";
        txtAddress.Text = string.Empty;
        txtDescription.Text = string.Empty;
        txtDescriptionEn.Text = string.Empty;
        txtDescriptionRu.Text = string.Empty;
        txtMinOrder.Text = "0";
        txtDeliveredTime.Text ="0";
        txtSearch.Text = string.Empty;
        txtUserName.Text = string.Empty;
        txtPass.Text = string.Empty;
        imgBanner.ImageUrl = "";
        Session["banner_fs"] = null;
        txtName.Focus();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid();
    }
    protected void btnnew_Click(object sender, EventArgs e)
    {
        ClearData();
        string title = "إضافة الأماكن";
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup('" + title + "');", true);
        txtName.Focus();
        return;
    }
    protected void fileInput_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
    {
        Stream fs = fileInput.PostedFile.InputStream;
        BinaryReader br = new BinaryReader(fs);
        Byte[] bytes = br.ReadBytes((Int32)fs.Length);
        Session["fs"] = bytes;
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + Image2.ClientID + "\").src = '" + ResolveClientUrl("data: image / png; base64," + Convert.ToBase64String(bytes)) + "';", true);
        return;
    }
    protected void fileBanner_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
    {
        Stream fs = fileBanner.PostedFile.InputStream;
        BinaryReader br = new BinaryReader(fs);
        Byte[] bytes = br.ReadBytes((Int32)fs.Length);
        Session["banner_fs"] = bytes; // استخدام Session مختلف للبانر
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "bannerPath", "top.$get(\"" + imgBanner.ClientID + "\").src = '" + ResolveClientUrl("data:image/png;base64," + Convert.ToBase64String(bytes)) + "';", true);
        return;
    }


    protected void ddlGov_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAreas();
    }

    private void BindAreas()
    {
        Areas area = new Areas();
        area.Where.Gov_id.Operator = WhereParameter.Operand.Equal;
        area.Where.Gov_id.Value = Convert.ToInt32(ddlGov.SelectedValue);
        if (area.Query.Load())
        {
            ddlArea.DataSource = area.DefaultView;
            ddlArea.DataTextField = Areas.ColumnNames.Name;
            ddlArea.DataValueField = Areas.ColumnNames.Id;
            ddlArea.DataBind();
        }
        string title = "الأماكن";
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Popup", "ShowPopup('" + title + "');", true);
        return;
    }
}
