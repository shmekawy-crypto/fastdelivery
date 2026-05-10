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

public partial class Admin_Pages_Gov : System.Web.UI.Page
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
           
        }

    }


 
    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }

    protected void gvGov_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditGov")
        {

            ViewState["id"] = int.Parse(e.CommandArgument.ToString());
            UpdateGov(int.Parse(e.CommandArgument.ToString()));

        }
        if (e.CommandName == "DeleteGov")
        {

            Gov Country = new Gov();
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

    private void UpdateGov(int p)
    {
        Gov Univer = new Gov();
        Univer.LoadByPrimaryKey(p);
        txtName.Text = Univer.Name;
        txtNameEn.Text = Univer.NameEn;
        txtNameRu.Text = Univer.NameRu;
        btnSave.Text = "تعديل";
        txtName.Focus();
    }

    private void BindGrid()
    {
        Gov Gov = new Gov();
        
        if (txtSearch.Text != string.Empty)
        {
            Gov.Where.Name.Operator = WhereParameter.Operand.Like;
            Gov.Where.Name.Value = "%" + txtSearch.Text + "%";

            Gov.Where.NameEn.Operator = WhereParameter.Operand.Like;
            Gov.Where.NameEn.Value = "%" + txtSearch.Text + "%";
            Gov.Where.NameEn.Conjuction = WhereParameter.Conj.Or;
        }
        if (Gov.Query.Load())
        {
            gvGov.DataSource = Gov.DefaultView;
            gvGov.DataBind();
            lblCount.Text = Gov.RowCount.ToString();

        }
        else {
            gvGov.DataSource = null;
            gvGov.DataBind();
            lblCount.Text = "0";
        }
       

    }
    protected void gvGov_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        gvGov.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        Gov Gov = new Gov();
        
        if (btnSave.Text == "حفظ")
        {
            Gov.AddNew();

        }
        else
        {
            Gov.LoadByPrimaryKey(int.Parse(ViewState["id"].ToString()));
           
        }
        Gov.Name = txtName.Text.Trim();
        Gov.NameEn = txtNameEn.Text.Trim();
        Gov.NameRu = txtNameRu.Text.Trim();

        try
        {
                Gov.Save();
                
                BindGrid();
                ClearData();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);
            }
            catch (Exception ex) {
                if (ex.Message.Contains("IX_Gov"))
                {

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "خطأ", "alert('يوجد محافظة مسجلة بهذا الاسم')", true);

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
