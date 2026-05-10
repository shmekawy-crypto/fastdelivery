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


public partial class Admin_Pages_AddUsers : System.Web.UI.Page
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
        DMS.Roles Role = new DMS.Roles();
        Role.LoadAll();
        ddlRole.DataSource = Role.DefaultView;
        ddlRole.DataValueField = DMS.Roles.ColumnNames.Id;
        ddlRole.DataTextField = DMS.Roles.ColumnNames.NameAr;
        ddlRole.DataBind();
    }

    private void FillcbPages()
    {
        UPages page = new UPages();
        page.LoadAll();
        cbPage.DataSource = page.DefaultView;
        cbPage.DataValueField = UPages.ColumnNames.Name;
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
        AUsers User = new AUsers();
        if (btnSave.Text == "حفظ")
        {
            User.AddNew();

        }
        else
        {
            User.LoadByPrimaryKey(int.Parse(ViewState["id"].ToString()));
        }
        User.Name = txtUname.Text;
        User.Password = txtPassword.Text;
        User.Role_id =Convert.ToInt32(ddlRole.SelectedValue);
        User.Visible = cbActive.Checked;  
        User.DefaultPage = cbPage.SelectedValue;
        User.Save();
        BindGrid();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);
    }

    private void BindGrid()
    {
        AUsers Users = new AUsers();
        if (Users.Query.Load())
        {
            gvUsers.DataSource = Users.DefaultView;
            gvUsers.DataBind();
            lblCount.Text = Users.RowCount.ToString();

        }
        else
        {
            gvUsers.DataSource = null;
            gvUsers.DataBind();
            lblCount.Text = "0";
        }
    }

    protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditUsers")
        {
            ViewState["id"] = int.Parse(e.CommandArgument.ToString());
            UpdatUsers(int.Parse(e.CommandArgument.ToString()));
        }
        if (e.CommandName == "DeleteUsers")
        {
            Users Users = new Users();
            Users.LoadByPrimaryKey(int.Parse(e.CommandArgument.ToString()));
            Users.DeleteAll();
            try
            {
                Users.Save();
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
        AUsers User = new AUsers();
        User.LoadByPrimaryKey(p);
        txtUname.Text = User.Name;
        txtPassword.Text = User.Password;
        cbActive.Checked = User.Visible;
        cbPage.SelectedValue = User.DefaultPage;
        ddlRole.SelectedValue = User.s_Role_id;
        btnSave.Text = "تعديل";
        txtUname.Focus();

    }

    protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        gvUsers.PageIndex = e.NewPageIndex;
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
        gvUsers.Columns[5].Visible = false;
        gvUsers.AllowPaging = false;
        this.BindGrid();
        gvUsers.GridLines = GridLines.Both;
        gvUsers.HeaderStyle.Font.Bold = true;
        gvUsers.RenderControl(htmltextwrtter);
        Response.ContentEncoding = System.Text.Encoding.Unicode;
        Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());
        Response.Write(strwritter.ToString());

        Response.End();
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        btnSave.Text = "حفظ";
        txtUname.Text = String.Empty;
        txtPassword.Text = String.Empty;
        txtUname.Focus();
    }
}