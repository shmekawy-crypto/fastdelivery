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
using System.Security.Cryptography;
using System.IO;
using DMS;


public partial class Admin_Pages_Privillages : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            FillcbPages();
            FillcbRoles();
            BindGrid();
        }

    }

    private void FillcbRoles()
    {
        DMS.Roles role = new DMS.Roles();
       
        if (role.Query.Load()) {
            ddlRoles.DataSource = role.DefaultView;
            ddlRoles.DataTextField = DMS.Roles.ColumnNames.NameAr;
            ddlRoles.DataValueField = DMS.Roles.ColumnNames.Id;
            ddlRoles.DataBind();
        }
        


    }

    private void FillcbPages()
    {
        UPages page = new UPages();
        page.LoadAll();
        cbPage.DataSource = page.DefaultView;
        cbPage.DataValueField = UPages.ColumnNames.Id;
        cbPage.DataTextField = UPages.ColumnNames.Description;
        cbPage.DataBind();
    }

    protected void GridView_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if (gv.ShowHeader == true && gv.Rows.Count > 0)
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        SaveData();
    }
    private void SaveData()
    {
        Privilages Privilage = new Privilages();
        if (btnSave.Text == "حفظ")
        {
            Privilage.AddNew();

        }
        else
        {
            Privilage.LoadByPrimaryKey(int.Parse(ViewState["id"].ToString()));
        }

        Privilage.Role_id = Convert.ToInt32(ddlRoles.SelectedValue);
        Privilage.Page_id = Convert.ToInt32(cbPage.SelectedValue);
        
            Privilage.R = cbR.Checked;
            Privilage.W = cbW.Checked;

        try
        {
            Privilage.Save();
            BindGrid();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);
        }
        catch (Exception ex) {
            if (ex.Message.Contains("IX_Privilages"))
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('الصفحة مضافة بالفعل')", true);

            }
        }
    }

    private void BindGrid()
    {
        vw_Privilages Privilage = new vw_Privilages();
        Privilage.Where.UID.Operator = WhereParameter.Operand.Equal;
        Privilage.Where.UID.Value = Convert.ToInt32(ddlRoles.SelectedValue);
        if (Privilage.Query.Load())
        {
            gvPrivilage.DataSource = Privilage.DefaultView;
            gvPrivilage.DataBind();
            lblCount.Text = Privilage.RowCount.ToString();

        }
        else
        {
            gvPrivilage.DataSource = null;
            gvPrivilage.DataBind();
            lblCount.Text = "0";
        }
    }

    protected void gvPrivilage_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditUsers")
        {
            ViewState["id"] = int.Parse(e.CommandArgument.ToString());
            UpdatUsers(int.Parse(e.CommandArgument.ToString()));
        }
        if (e.CommandName == "DeleteUsers")
        {
            Privilages Privilage = new Privilages();
            Privilage.LoadByPrimaryKey(int.Parse(e.CommandArgument.ToString()));
            Privilage.DeleteAll();
            try
            {
                Privilage.Save();
                BindGrid();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حذف", "alert('لقد تمت عملية الحذف بنجاح')", true);

            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حذف", "alert('لا يمكن حذف هذا المستودع لارتباطه ببيانات أخرى')", true);
            }
        }
    }
    private void UpdatUsers(int p)
    {
        Privilages Privilage = new Privilages();
        Privilage.LoadByPrimaryKey(p);
        cbPage.SelectedValue = Privilage.s_Page_id;
        if (Privilage.R)
        {
            cbR.Checked = true;
            cbW.Checked = false;

        }
        else {
            cbR.Checked = false;
            cbW.Checked = true;

        }
        btnSave.Text = "تعديل";
       

    }

    protected void gvPrivilage_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        gvPrivilage.PageIndex = e.NewPageIndex;
        BindGrid();
    }

    protected void lbpdf_Click(object sender, EventArgs e)
    {
        ExportGridToExcel();
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
    private void ExportGridToExcel()
    {
        Response.Clear();
        Response.Buffer = true;
        Response.ClearContent();
        Response.ClearHeaders();
        Response.Charset = "";
        string FileName = "Users" + DateTime.Now + ".xls";
        StringWriter strwritter = new StringWriter();
        HtmlTextWriter htmltextwrtter = new HtmlTextWriter(strwritter);
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.ContentType = "application/vnd.ms-excel";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + FileName);
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        gvPrivilage.Columns[5].Visible = false;
        gvPrivilage.AllowPaging = false;
        this.BindGrid();
        gvPrivilage.GridLines = GridLines.Both;
        gvPrivilage.HeaderStyle.Font.Bold = true;
        gvPrivilage.RenderControl(htmltextwrtter);
        Response.ContentEncoding = System.Text.Encoding.Unicode;
        Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());
        Response.Write(strwritter.ToString());

        Response.End();
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        btnSave.Text = "حفظ";
       
    }
    protected void ddlUsers_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }
}