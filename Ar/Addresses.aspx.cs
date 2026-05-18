using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

public partial class Ar_Addresses : System.Web.UI.Page
{
    string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadGovernments();
            BindGrid();

        }
    }
    void LoadGovernments()
    {
        HttpCookie langCookie = Request.Cookies["lang"];
        string lang = (langCookie != null && !string.IsNullOrEmpty(langCookie.Value)) ? langCookie.Value : "ar";

        using (SqlConnection con = new SqlConnection(connStr))
        {

            SqlDataAdapter da = new SqlDataAdapter("SELECT id, Name,NameEn,NameRu FROM Gov", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ddlGov.DataSource = dt;
            ddlGov.DataTextField = "Name";
            ddlGov.DataTextField = "Name";
            if (lang == "en") ddlGov.DataTextField = "NameEn";
            if (lang == "ru") ddlGov.DataTextField = "NameRu";
            ddlGov.DataValueField = "id";
            ddlGov.DataBind();
            ddlGov.Items.Insert(0, new ListItem(GetLiteralText("SelectGov"), "0"));
            ddlArea.Items.Insert(0, new ListItem(GetLiteralText("SelectArea"), "0"));
        }
    }

    [System.Web.Services.WebMethod]
    public static List<ListItem> GetAreasByGov(int govID, string lang)
    {
        string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
        List<ListItem> areas = new List<ListItem>();
        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT id, Name,NameEn,NameRu FROM Areas WHERE Gov_id=@Gov_id", con);
            cmd.Parameters.AddWithValue("@Gov_id", govID);
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                string areaName = rdr["Name"].ToString(); // default Arabic
                if (lang == "en")
                {
                    areaName = rdr["NameEn"].ToString();
                }
                else if (lang == "ru")
                {
                    areaName = rdr["NameRu"].ToString();
                }

                areas.Add(new ListItem(areaName, rdr["id"].ToString()));

            }
        }
        return areas;
    }
    protected string GetLiteralText(string key)
    {

        return (string)GetGlobalResourceObject("texts", key);
    }
    //protected void ddlGov_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    int govID = 0;
    //    if (int.TryParse(ddlGov.SelectedValue, out govID))
    //    {
    //        LoadAreas(govID);
    //    }
    //    else
    //    {
    //        ddlArea.Items.Clear();
    //        ddlArea.Items.Insert(0, new ListItem("-- اختر المنطقة --", "0"));
    //    }

    //    ClientScript.RegisterStartupScript(this.GetType(), "openModalz", "document.getElementById('locationSetBtns').style.display = 'flex';document.getElementById('map2').style.display = 'none';document.getElementById('map').style.display='none';document.getElementById('locationFormShower').style.display='block'; ", true);
    //    ClientScript.RegisterStartupScript(this.GetType(), "hideDiv", "document.getElementById('emptyLocations').style.display='none';", true);
    //    ClientScript.RegisterStartupScript(this.GetType(), "hideDiv2", "document.getElementById('fgrdata').style.display='block';", true);

    //    ClientScript.RegisterStartupScript(this.GetType(), "openModal", "var myModal = new bootstrap.Modal(document.getElementById('OmapModal')); myModal.show();", true);
    //}


    void LoadAreas(int govID, DropDownList ddl = null)
    {


        HttpCookie langCookie = Request.Cookies["lang"];
        string lang = (langCookie != null && !string.IsNullOrEmpty(langCookie.Value)) ? langCookie.Value : "ar";

        using (SqlConnection con = new SqlConnection(connStr))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT id, Name,NameEn,NameRu FROM Areas WHERE Gov_id=@Gov_id", con);
            da.SelectCommand.Parameters.AddWithValue("@Gov_id", govID);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ddlArea.DataSource = dt;
            ddlArea.DataTextField = "Name";
            if (lang == "en") ddlArea.DataTextField = "NameEn";
            if (lang == "ru") ddlArea.DataTextField = "NameRu";
            ddlArea.DataValueField = "id";
            ddlArea.DataBind();
            ddlArea.Items.Insert(0, new ListItem(GetLiteralText("SelectArea"), "0"));
        }
    }
    private void DeleteAddress(int id)
    {
        Addresses addr = new Addresses();
        addr.LoadByPrimaryKey(id);
        addr.DeleteAll();
        try
        {
            addr.Save();
            BindGrid();
        }catch(Exception ex)
        {


        }

    }
    private void ShowSweetAlert(string message, string icon)
    {
        string safeMessage = HttpUtility.JavaScriptStringEncode(message);
        string script = string.Format(@"
        <script type='text/javascript'>
            Swal.fire({{
                icon: '{0}',
                title: '{1}',
                showConfirmButton: true
            }});
        </script>", icon, safeMessage);

        ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), script,true);
    }
    protected void rptAddresses_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditAddress")
        {
            // توجه لصفحة التعديل أو افتح مودال
            if (e.CommandName == "EditAddress")
            {
                BindGrid();
                ViewState["id"] = int.Parse(e.CommandArgument.ToString());
                FillEditForm(id);
                // بعد ما نملأ البيانات، نشغل سكريبت يفتح المودال

            }

        }
        else if (e.CommandName == "DeleteAddress")
        {
            DeleteAddress(id);

        }
    }

    private void FillEditForm(int id)
    {
        Addresses addr = new Addresses();
        addr.LoadByPrimaryKey(id);
        mobile.Text = addr.Mobile;
        txtAddress.Text = addr.AddressName;
        if (addr.AType == 0)
        {
            apartmentType.Checked = true;

            floorNumber.Text = addr.FloorNo;
            apartmentNumber.Text = addr.AdepartmentNo;

        }
        if (addr.AType == 1)
        {
            houseType.Checked = true;
            floorNumber.Style.Add("display", "none");
            apartmentNumber.Style.Add("display", "none");
        }
        if (addr.AType == 2)
        {
            officeType.Checked = true;

        }
        street.Text = addr.StreetName;
        Areas area = new Areas();
        area.LoadByPrimaryKey(addr.Area_id);
        ddlGov.SelectedValue = area.s_Gov_id;
        LoadAreas(area.Gov_id);
        ddlArea.SelectedValue = addr.s_Area_id;
        hfSelectedArea.Value= addr.s_Area_id;
        building.Text = addr.Build;
        hiddenCoords.Value = addr.Latitude + "," + addr.Longitude;
        instructions.Text = addr.Instructions;
        ClientScript.RegisterStartupScript(this.GetType(), "openModalz", "document.getElementById('fgrdata').style.display='block';document.getElementById('emptyLocations').style.display='none';document.getElementById('locationSetBtns').style.display = 'flex';document.getElementById('map2').style.display = 'none';document.getElementById('map').style.display='none';document.getElementById('locationFormShower').style.display='block'; ", true);
        ClientScript.RegisterStartupScript(this.GetType(), "openModal", @"
    document.addEventListener('DOMContentLoaded', function() {
        var modalEl = document.getElementById('OmapModal');
        if (modalEl) {
            var myModal = new bootstrap.Modal(modalEl);
            myModal.show();
        }
    });
", true);
        ClientScript.RegisterStartupScript(this.GetType(), "FixLeafletMap",
    "setTimeout(function(){ if(window.map) map.invalidateSize(); }, 200);", true);
        ClientScript.RegisterStartupScript(this.GetType(), "openModaljj",
"openMap("+ addr.Latitude+ ","+ addr.Longitude + ");", true);
    }

    protected void EditAddress_Click(object sender, EventArgs e)
    {
        var btn = (HtmlButton)sender;
        int id = Convert.ToInt32(btn.Attributes["data-id"]);
        Response.Redirect("EditAddress.aspx?id=" + id);
    }

    protected void DeleteAddress_Click(object sender, EventArgs e)
    {
        var btn = (HtmlButton)sender;
        int id = Convert.ToInt32(btn.Attributes["data-id"]);
        DeleteAddress(id);
    }
    protected void setLocationBtn_Click(object sender, EventArgs e)
    {
        Addresses addr = new Addresses();
        if (ViewState["id"] != null)
        {
            addr.LoadByPrimaryKey(Convert.ToInt32(ViewState["id"].ToString()));

        }
        else
        {
            addr.AddNew();
        }
        Users usr = new Users();
        usr.Where.Email.Operator = WhereParameter.Operand.Equal;
        usr.Where.Email.Value = User.Identity.Name;
        if (usr.Query.Load())
        {
            addr.UserID = usr.Id;
        }
        addr.AddressName = txtAddress.Text;
        addr.Mobile = mobile.Text;
        if (!string.IsNullOrEmpty(phone.Text))
        {
            addr.Phone = phone.Text;
        }
        if (apartmentType.Checked)
        {
            addr.AType = 0;
            addr.StreetName = street.Text;
            addr.Build = building.Text;
            addr.FloorNo = floorNumber.Text;
            addr.AdepartmentNo = apartmentNumber.Text;
            addr.Instructions = instructions.Text;
        }
        if (houseType.Checked)
        {
            addr.AType = 1;
            addr.StreetName = street.Text;
            addr.Build = building.Text;
            addr.SetColumnNull(Addresses.ColumnNames.FloorNo);
            addr.SetColumnNull(Addresses.ColumnNames.AdepartmentNo);
            addr.Instructions = instructions.Text;

        }
        if (officeType.Checked)
        {
            addr.AType = 2;
            addr.StreetName = street.Text;
            addr.Build = building.Text;
            addr.FloorNo = floorNumber.Text;
            addr.AdepartmentNo = apartmentNumber.Text;
            addr.Instructions = instructions.Text;
        }

        addr.Latitude = Convert.ToDecimal(hiddenCoords.Value.Split(',')[0]);
        addr.Longitude = Convert.ToDecimal(hiddenCoords.Value.Split(',')[1]);
        addr.Area_id = int.Parse(hfSelectedArea.Value);
        addr.Save();
        BindGrid();
    }

    private void BindGrid()
    {
        Addresses addr = new Addresses();
        Users usr = new Users();
        usr.Where.Email.Operator = WhereParameter.Operand.Equal;
        usr.Where.Email.Value = User.Identity.Name;
        if (usr.Query.Load())
        {
            addr.Where.UserID.Operator = WhereParameter.Operand.Equal;
            addr.Where.UserID.Value = usr.Id;
            if (addr.Query.Load())
            {
                ClientScript.RegisterStartupScript(this.GetType(), "hideDiv", "document.getElementById('emptyLocations').style.display='none';", true);
                ClientScript.RegisterStartupScript(this.GetType(), "hideDiv2", "document.getElementById('fgrdata').style.display='block';", true);
                rptAddresses.DataSource = addr.DefaultView;
                rptAddresses.DataBind();
            }
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "hideDiv", "document.getElementById('emptyLocations').style.display='flex';", true);
            ClientScript.RegisterStartupScript(this.GetType(), "hideDiv2", "document.getElementById('fgrdata').style.display='none';", true);
        }
        ClearData();
    }

    private void ClearData()
    {
        ViewState["id"] = null;
        txtAddress.Text = "";
        mobile.Text = "";
        phone.Text = "";
        street.Text = "";
        floorNumber.Text = "";
        apartmentNumber.Text = "";
        building.Text = "";
        instructions.Text = "";
        apartmentType.Checked = true;
        ddlGov.SelectedValue = "0";
        ddlArea.Items.Clear();
        ddlArea.Items.Insert(0, new ListItem(GetLiteralText("SelectArea"), "0"));
    }
}
