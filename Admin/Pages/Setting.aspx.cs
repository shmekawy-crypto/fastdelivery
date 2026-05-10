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
public partial class Admin_Pages_Setting : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            Ssetting set = new Ssetting();
            set.Query.Load();

            txtPercentage.Text = set.s_DeliveryP;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        Ssetting set = new Ssetting();
        set.Query.Load();
       
        set.DeliveryP = Convert.ToDouble(txtPercentage.Text);
      
        set.Save();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "حفظ", "alert('لقد تمت عملية الحفظ بنجاح')", true);
    }
    
}
