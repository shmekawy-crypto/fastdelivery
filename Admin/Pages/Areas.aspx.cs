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

public partial class Admin_Pages_Areas : System.Web.UI.Page
{
    public string GetCurrentPageName()
    {
        string sPath = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
        System.IO.FileInfo oInfo = new System.IO.FileInfo(sPath);
        string sRet = oInfo.Name;
        return sRet;
    }



    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            
            BindGrid();
            BindGov();
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

    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }

    protected void gvAreas_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditAreas")
        {

            ViewState["id"] = int.Parse(e.CommandArgument.ToString());
            UpdateAreas(int.Parse(e.CommandArgument.ToString()));

        }
        if (e.CommandName == "DeleteAreas")
        {

            Areas Country = new Areas();
            Country.LoadByPrimaryKey(int.Parse(e.CommandArgument.ToString()));
            Country.DeleteAll();
            try
            {
                Country.Save();
                BindGrid();
                ClearData();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حذف", "alert('لقد تمت عملية الحذف بنجاح')", true);

            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حذف", "alert('لا يمكن حذف الدرجة الوظيفية لارتباطها ببيانات أخرى')", true);
            }

        }
    }

    private void UpdateAreas(int p)
    {
        Areas Area = new Areas();
        Area.LoadByPrimaryKey(p);
        txtName.Text = Area.Name;
        txtNameEn.Text = Area.NameEn;
        txtNameRu.Text = Area.NameRu;
        ddlGov.SelectedValue = Area.s_Gov_id;
        btnSave.Text = "تعديل";
        txtName.Focus();
    }

    private void BindGrid()
    {
        vw_Areas Areas = new vw_Areas();
        
        if (txtSearch.Text != string.Empty)
        {
            Areas.Where.Name.Operator = WhereParameter.Operand.Like;
            Areas.Where.Name.Value = "%" + txtSearch.Text + "%";

            Areas.Where.NameEn.Operator = WhereParameter.Operand.Like;
            Areas.Where.NameEn.Value = "%" + txtSearch.Text + "%";
            Areas.Where.NameEn.Conjuction = WhereParameter.Conj.Or;
        }
        if (Areas.Query.Load())
        {
            gvAreas.DataSource = Areas.DefaultView;
            gvAreas.DataBind();
            lblCount.Text = Areas.RowCount.ToString();

        }
        else {
            gvAreas.DataSource = null;
            gvAreas.DataBind();
            lblCount.Text = "0";
        }
       

    }
    protected void gvAreas_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        gvAreas.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        Areas Areas = new Areas();
        
        if (btnSave.Text == "حفظ")
        {
            Areas.AddNew();

        }
        else
        {
            Areas.LoadByPrimaryKey(int.Parse(ViewState["id"].ToString()));
           
        }
        Areas.Name = txtName.Text.Trim();
        Areas.NameEn = txtNameEn.Text.Trim();
        Areas.NameRu = txtNameRu.Text.Trim();
        Areas.Gov_id = Convert.ToInt32(ddlGov.SelectedValue); 
            try
            {
                Areas.Save();
                
                BindGrid();
                ClearData();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);
            }
            catch (Exception ex) {
                if (ex.Message.Contains("IX_Areas"))
                {

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "خطأ", "alert('يوجد دولة مسجلة بهذا الاسم')", true);

            }
            
            
            }
        
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearData();      
    }

    private void ClearData()
    {
        btnSave.Text = "حفظ";
        txtName.Text = string.Empty;
        txtNameEn.Text = string.Empty;
        txtNameRu.Text = string.Empty;
        txtSearch.Text = string.Empty;
        txtName.Focus();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid();

    }

}
