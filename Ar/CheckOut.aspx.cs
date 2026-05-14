using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS;
public partial class Ar_CheckOut : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            if (!string.IsNullOrEmpty(hfAddId.Value))
            {
                Addresses add = new Addresses();
                add.LoadByPrimaryKey(Convert.ToInt32(hfAddId.Value));
                
            }
        }
    }
    [WebMethod]
    public static object ReceiveAddId(int addId, string lang)
    {
        Addresses add = new Addresses();
        add.LoadByPrimaryKey(addId);

        // ترجمة نوع العقار حسب اللغة
        string AType = HttpContext.GetGlobalResourceObject("texts", "Apartment", new System.Globalization.CultureInfo(lang)).ToString();
        if (add.AType == 1) AType = HttpContext.GetGlobalResourceObject("texts", "House", new System.Globalization.CultureInfo(lang)).ToString();
        else if (add.AType == 2) AType = HttpContext.GetGlobalResourceObject("texts", "Office", new System.Globalization.CultureInfo(lang)).ToString();

        // تحميل المنطقة والحكومة
        Areas area = new Areas();
        area.LoadByPrimaryKey(add.Area_id);

        Gov gov = new Gov();
        gov.LoadByPrimaryKey(area.Gov_id);

        // ترجمة اسم المنطقة حسب اللغة
        string areaName = area.s_Name; // افتراضي عربي
        if (lang == "en") areaName = area.s_NameEn;
        else if (lang == "ru") areaName = area.s_NameRu;

        // ترجمة اسم الحكومة لو حابب
        string govName = gov.s_Name; // افتراضي عربي
        if (lang == "en") govName = gov.s_NameEn;
        else if (lang == "ru") govName = gov.s_NameRu;

        return new
        {
            success = true,
            AddName = add.s_AddressName,
            StreetName = add.s_StreetName,
            mobile = add.s_Mobile,
            phone = add.s_Phone,
            Build = add.s_Build,
            Floor = add.s_FloorNo,
            Area = areaName,
            Gov = govName,
            AdepartmentNo = add.s_AdepartmentNo,
            Instructions = add.s_Instructions,
            AType = AType
        };
    }

}