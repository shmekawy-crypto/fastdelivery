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
using DMS;
using System.IO;

public partial class Categories : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            BindGrid();
        }
    }

    protected void gvCategory_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditCategory")
        {
            ViewState["id"] = int.Parse(e.CommandArgument.ToString());
            DMS.Categories Category = new DMS.Categories();
            Category.LoadByPrimaryKey(Convert.ToInt32(e.CommandArgument.ToString()));
            txtName.Text = Category.Name;
            txtNameEn.Text = Category.NameEn;
            txtNameRu.Text = Category.NameRu;
            txtDescription.Text = Category.DescrAr;
            txtDescriptionEn.Text = Category.DescrEn;
            txtDescriptionRu.Text = Category.DescrRu;
            cbActive.Checked = Category.Active;
            txtOrder.Text = Category.s_Corder;
            Image1.ImageUrl ="~/ar/" + Category.PhotoPath;
            rvImage.Enabled = false;
            btnSave.Text = "تعديل";


        }
        if (e.CommandName == "DeleteCategory")
        {
            DMS.Categories Category = new DMS.Categories();
            Category.LoadByPrimaryKey(Convert.ToInt32(e.CommandArgument.ToString()));
            Category.DeleteAll();
            try
            {
                Category.Save();
                BindGrid();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Delete", "alert('Deleted Successfully')", true);

            }
            catch (Exception)
            {

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Delete", "alert('Can not delete Because Data Releated with another')", true);
            }
        }
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
    private void BindGrid()
    {
        DMS.Categories Category = new DMS.Categories();


        if (Category.LoadAll())
        {

            gvCategory.DataSource = Category.DefaultView;
            gvCategory.DataBind();
            lblCount.Text = Category.RowCount.ToString();
        }
        else
        {

            gvCategory.DataSource = null;
            gvCategory.DataBind();
            lblCount.Text = "0";


        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearData();
    }

    private void ClearData()
    {
        btnSave.Text = "حفظ";
        txtDescription.Text = string.Empty;
        txtDescriptionEn.Text = string.Empty;
        txtDescriptionRu.Text = string.Empty;
        txtName.Text = string.Empty;
        txtNameEn.Text = string.Empty;
        txtNameRu.Text = string.Empty;

        cbActive.Checked = true;
        Image1.ImageUrl = "";
        rvImage.Enabled = true;
        txtDescription.Focus();
    }

    protected void gvCategory_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvCategory.PageIndex = e.NewPageIndex;
        BindGrid();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        DMS.Categories Category = new DMS.Categories();
        if (btnSave.Text == "حفظ")
        {
            Category.AddNew();

        }
        else
        {
            Category.LoadByPrimaryKey(int.Parse(ViewState["id"].ToString()));
        }
        Category.Name = txtName.Text;
        Category.NameEn = txtNameEn.Text;
        Category.NameRu = txtNameRu.Text;

        Category.DescrAr = txtDescription.Text;
        Category.DescrEn = txtDescriptionEn.Text;
        Category.DescrRu = txtDescriptionRu.Text;
        Category.Active = cbActive.Checked;
        Category.Corder = Convert.ToInt32(txtOrder.Text);
        if (fuphoto.HasFile)
        {
            string extension = Guid.NewGuid().ToString() + Path.GetExtension(fuphoto.FileName);
            fuphoto.SaveAs(Server.MapPath("~/Ar/images/" +  extension));
            Category.PhotoPath = "images/" + extension;
        }
        Category.Save();
        BindGrid();
        if (btnSave.Text == "حفظ")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Save", "alert('تمت عملية الحفظ بنجاح')", true);

        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Save", "alert('تمت عملية التعديل بنجاح')", true);
        }
        ClearData();
    }
}
