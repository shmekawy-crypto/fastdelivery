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

public partial class Admin_Pages_Roles : System.Web.UI.Page
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

    protected void gvRoles_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditRoles")
        {

            ViewState["id"] = int.Parse(e.CommandArgument.ToString());
            UpdateRoles(int.Parse(e.CommandArgument.ToString()));

        }
        if (e.CommandName == "DeleteRoles")
        {

            DMS.Roles Role = new DMS.Roles();
            Role.LoadByPrimaryKey(int.Parse(e.CommandArgument.ToString()));
            Role.DeleteAll();
            try
            {
                Role.Save();
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

    private void UpdateRoles(int p)
    {
        DMS.Roles Univer = new DMS.Roles();
        Univer.LoadByPrimaryKey(p);
        txtName.Text = Univer.NameAr;
        txtNameEn.Text = Univer.NameEn;
      
        btnSave.Text = "تعديل";
        txtName.Focus();
    }

    private void BindGrid()
    {
        DMS.Roles Roles = new DMS.Roles();
        
        if (txtSearch.Text != string.Empty)
        {
            Roles.Where.NameAr.Operator = WhereParameter.Operand.Like;
            Roles.Where.NameAr.Value = "%" + txtSearch.Text + "%";

            Roles.Where.NameEn.Operator = WhereParameter.Operand.Like;
            Roles.Where.NameEn.Value = "%" + txtSearch.Text + "%";
            Roles.Where.NameEn.Conjuction = WhereParameter.Conj.Or;
        }
        if (Roles.Query.Load())
        {
            gvRoles.DataSource = Roles.DefaultView;
            gvRoles.DataBind();
            lblCount.Text = Roles.RowCount.ToString();

        }
        else {
            gvRoles.DataSource = null;
            gvRoles.DataBind();
            lblCount.Text = "0";
        }
       

    }
    protected void gvRoles_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        gvRoles.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        DMS.Roles Roles = new DMS.Roles();
        
        if (btnSave.Text == "حفظ")
        {
            Roles.AddNew();

        }
        else
        {
            Roles.LoadByPrimaryKey(int.Parse(ViewState["id"].ToString()));
           
        }
        Roles.NameAr = txtName.Text.Trim();
        Roles.NameEn = txtNameEn.Text.Trim();
           
            try
            {
                Roles.Save();
                
                BindGrid();
                ClearData();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);
            }
            catch (Exception ex) {
                if (ex.Message.Contains("IX_Roles"))
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
        txtSearch.Text = string.Empty;
        txtName.Focus();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid();

    }

}
