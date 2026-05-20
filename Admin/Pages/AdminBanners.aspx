<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="AdminBanners.aspx.cs" Inherits="Admin_Banners" Title="إدارة الإعلانات والعروض" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
إدارة إعلانات العروض المجمعة للمطاعم
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<style>
.update
{
    position: fixed;
    top: 0px;
    left: 0px;
    min-height: 100%;
    min-width: 100%;
    background-image: url("../Scripts/loader.gif");
    background-position:center center;
    background-repeat:no-repeat;
    z-index: 500 !important;
    overflow: hidden;
}

.bs4-aspnet-pager
{
    background-color:White;
    border: none;
    padding:0px;
    border-collapse:collapse;
    line-height:0.5em;
}
   
.bs4-aspnet-pager td
{
    background-color:White;
    border: none;
    border-collapse:collapse;
    line-height:0.5em;
} 

.bs4-aspnet-pager td table
{
    background-color:White;
    border: none;
    border-collapse:collapse;
    line-height:0.5em;
}

.bs4-aspnet-pager table td, .bs4-aspnet-pager table th, .card .bs4-aspnet-pager table td, .card .bs4-aspnet-pager table th, .card .dataTable td, .card .dataTable th {
    padding: 0px 5px;
    vertical-align: middle;
}       

.bs4-aspnet-pager a, .bs4-aspnet-pager span {
    position: relative;
    float: right;
    padding: 6px 12px;
    margin-right: -1px;
    line-height: 1.42857143;
    color: #007bff;
    text-decoration: none;
    background-color: #fff;
    border: 1px solid #ddd;
}

.bs4-aspnet-pager span {
    z-index: 3;
    color: #fff;
    cursor: default;
    background-color: #007bff;
    border-color: #007bff;
}

.bs4-aspnet-pager tr > td:first-child > a, .bs4-aspnet-pager tr > td:first-child > span {
    margin-right: 0;
}

.bs4-aspnet-pager a:hover, .bs4-aspnet-pager span:hover, .bs4-aspnet-pager a:focus, .bs4-aspnet-pager span:focus 
{
    z-index: 2;
    color: #23527c;
    border-color: Red;
}

.bs4-aspnet-pager td {
    padding: 0;
}

/* تنسيقات صندوق المطاعم المختارة الفوري */
.selected-places-container {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 12px;
    padding: 12px;
    border: 1px dashed #cccccc;
    border-radius: 8px;
    background-color: #fafafa;
    min-height: 50px;
}
.place-tag {
    background: #007bff;
    color: #ffffff;
    padding: 6px 14px;
    border-radius: 20px;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    font-size: 0.88rem;
    font-weight: bold;
    box-shadow: 0 2px 5px rgba(0,123,255,0.15);
}
.place-tag .remove-btn {
    cursor: pointer;
    background: rgba(255,255,255,0.25);
    border-radius: 50%;
    width: 16px;
    height: 16px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 0.7rem;
    transition: background 0.2s, color 0.2s;
}
.place-tag .remove-btn:hover {
    background: #dc3545;
    color: #ffffff;
}
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />

<asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="100" DynamicLayout="true" >
    <ProgressTemplate>
        <div class="update"></div>
    </ProgressTemplate>
</asp:UpdateProgress>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>
              
    <div class="page-bar">
        <div class="page-title-breadcrumb">
            <div class="pull-left">
                <div class="page-title">إدارة إعلانات العروض المجمعة</div>
            </div>
            <ol class="breadcrumb page-breadcrumb pull-right">
                <li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">main</a>&nbsp;<i class="fa fa-angle-left"></i></li>
                <li class="active">إعلانات العروض</li>
            </ol>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12 col-sm-12">
            <div class="card card-box">
                <div class="card-head">
                    <header>إضافة وتعديل عروض المطاعم</header>
                    <div class="tools">
                        <a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
                        <a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
                        <a class="t-close btn-color fa fa-times" href="javascript:;"></a>
                    </div>
                </div>
                <div class="card-body" id="bar-parent">
                    <div id="form_sample_1" class="form-horizontal">
                        <div class="form-body">

                            <%-- 1. عنوان الإعلان --%>
                            <div class="form-group row">
                                <label class="control-label col-sm-3">عنوان العرض / الإعلان
                                    <span class="required" aria-required="true"> * </span>
                                </label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtTitle" runat="server" class="form-control input-height" placeholder="مثال: عروض نهاية الأسبوع الحصرية"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ErrorMessage="عنوان الإعلان مطلوب" ControlToValidate="txtTitle" ValidationGroup="BannerGroup" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <%-- 2. مكان الظهور بالموقع --%>
                            <div class="form-group row">
                                <label class="control-label col-sm-3">مكان الظهور بالموقع
                                    <span class="required" aria-required="true"> * </span>
                                </label>
                                <div class="col-md-8">
                                    <asp:DropDownList ID="ddlPagePlace" runat="server" class="form-control input-height">
                                        <asp:ListItem Value="Home">الصفحة الرئيسية للموقع</asp:ListItem>
                                        <asp:ListItem Value="Shops">صفحة تصفح المطاعم</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <%-- 3. رابط توجيه مفرد --%>
                            <div class="form-group row">
                                <label class="control-label col-sm-3">رابط توجيه مفرد (اختياري)
                                    <span class="required" aria-required="false">  </span>
                                </label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtClickUrl" runat="server" class="form-control text-left input-height" placeholder="مثال: shopPage.html?placeId=5"></asp:TextBox>
                                </div>
                            </div>

                            <%-- 4. اختيار وإضافة المطاعم الفورية --%>
                            <div class="form-group row">
                                <label class="control-label col-sm-3">اختر المطاعم المشاركة
                                    <span class="required" aria-required="false">  </span>
                                </label>
                                <div class="col-md-8">
                                    <div class="row">
                                        <div class="col-md-9">
                                            <asp:DropDownList ID="ddlPlaces" runat="server" class="form-control input-height">
                                            </asp:DropDownList>
                                        </div>
                                        <div class="col-md-3">
                                            <button type="button" class="btn btn-success input-height" style="width:100%; font-weight:bold;" onclick="addCurrentSelectedPlace(event); return false;">
                                                <i class="fa fa-plus"></i> إضافة مطعم
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div id="selectedPlacesContainer" class="selected-places-container"></div>
                                    
                                    <asp:HiddenField ID="hfSelectedPlaceIDs" runat="server" ClientIDMode="Static" />
                                </div>
                            </div>

                            <%-- 5. رفع صورة الإعلان --%>
                            <div class="form-group row">
                                <label class="control-label col-md-3">إختر صورة الإعلان
                                    <span class="required" aria-required="true"> * </span>
                                </label>
                                <div class="col-md-4">
                                    <asp:FileUpload ID="fuphoto" runat="server" />
                                    <asp:RequiredFieldValidator ID="rvImage" runat="server" ErrorMessage="ملف الصورة مطلوب" ControlToValidate="fuphoto" ValidationGroup="BannerGroup" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-5">
                                    <asp:Image ID="Image1" runat="server" Width="200" Height="90" style="object-fit: contain; border: 1px solid #eee; border-radius: 4px;" />
                                </div>
                            </div>

                            <%-- 6. نشط أم لا --%>
                            <div class="form-group row">
                                <label class="control-label col-sm-3">نشط
                                    <span class="required" aria-required="true"> * </span>
                                </label>
                                <div class="col-md-8 text-right">
                                    <label class="switchToggle">
                                         <asp:CheckBox ID="cbActive" runat="server" Checked="true" />
                                         <span class="slider green round"></span>
                                    </label>
                                </div>
                            </div>

                            <%-- 7. الترتيب --%>
                            <div class="form-group row">
                                <label class="control-label col-sm-3">الترتيب
                                    <span class="required" aria-required="true"> * </span>
                                </label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtOrder" runat="server" data-mask="9" class="form-control input-height col-2" Text="0"></asp:TextBox>
                                </div>
                            </div>

                            <%-- 8. أزرار الحفظ والإلغاء --%>
                            <div class="col-lg-12 p-t-20 text-center">
                                <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ وتشغيل الإعلان" OnClick="btnSave_Click" ValidationGroup="BannerGroup"/>
                                <asp:Button ID="btnCancel" class="btn btn-default" runat="server" Text="الغاء" OnClick="btnCancel_Click" />
                            </div>

                        </div>

                        <%-- جدول عرض البيانات المسجلة --%>
                        <div class="table-scrollable" style="margin-top: 30px;">
                            <div id="example4_wrapper" class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">
                                
                                <h4 style="font-weight:bold; margin-bottom:15px; color:#333; text-align:right;">قائمة إعلانات العروض المجمعة النشطة</h4>
                                
                                <asp:GridView ID="gvBanners" OnPreRender="GridView_PreRender" runat="server" AutoGenerateColumns="False"  
                                    PagerSettings-Mode="NumericFirstLast" AllowSorting="true" OnRowCommand="gvBanners_RowCommand" GridLines="None"  
                                    CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle" 
                                    AllowPaging="True" OnPageIndexChanging="gvBanners_PageIndexChanging" PageSize="10">
                                    <HeaderStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
                                    <RowStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
                                    <PagerStyle CssClass="bs4-aspnet-pager" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="م">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:BoundField HeaderText="عنوان العرض / الإعلان" DataField="Title" />
                                        <asp:TemplateField HeaderText="مكان الظهور">
                                            <ItemTemplate>
                                                <%# Eval("PagePlace").ToString() == "Home" ? "الصفحة الرئيسية" : "صفحة المطاعم" %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="رابط التوجيه المستهدف" DataField="ClickUrl" />
                                        
                                        <asp:TemplateField HeaderText="الصورة">
                                            <ItemTemplate>
                                                <asp:Image ID="imgGrid" runat="server" ImageUrl='<%# "~/" + Eval("PhotoUrl") %>' width="160" height="70" style="object-fit:cover; border-radius:4px;" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:CheckBoxField HeaderText="الحالة" DataField="IsActive" ItemStyle-Wrap="false" />
                                        <asp:BoundField HeaderText="الترتيب" DataField="SortOrder" ItemStyle-Wrap="false" />
                                        
                                        <asp:TemplateField HeaderText="الإجراءات">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteBanner" class="btn btn-xs btn-danger"
                                                    CommandArgument='<%# Eval("id") %>' OnClientClick="return confirm('هل أنت متأكد من حذف هذا الإعلان نهائياً من المنظومة؟');"> 
                                                    <i class="ace-icon fa fa-trash-o bigger-120"></i>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>

                            </div>
                            
                            <div class="row">
                                <div class="col-sm-6 col-md-6" style="text-align: right; margin-top: 15px;">
                                    <label class="control-label" style="font-weight: bold;">إجمالي عدد الإعلانات المسجلة :</label>
                                    <asp:Label ID="lblCount" runat="server" Text="0" Font-Bold="true" ForeColor="Red"></asp:Label>           
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- حقل الجافا سكريبت المضمون الحسم بداخل الـ Content2 لتفادي مشاكل الماستر بيج --%>
    <script type="text/javascript">
        if (typeof selectedPlaces === 'undefined') {
            var selectedPlaces = [];
        }

        function addCurrentSelectedPlace(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            const dropdown = document.getElementById('<%= ddlPlaces.ClientID %>');
            if (!dropdown) return false;

            const id = dropdown.value;
            const name = dropdown.options[dropdown.selectedIndex].text;

            if (!id || id === "0") {
                alert('يرجى اختيار اسم مطعم من القائمة أولاً قبل الضغط على إضافة');
                return false;
            }

            if (selectedPlaces.some(p => p.id === id)) {
                alert('هذا المطعم مضاف بالفعل بداخل قائمة العرض الحالي');
                return false;
            }

            selectedPlaces.push({ id: parseInt(id), name: name });
            renderPlaceTags();

            dropdown.value = "0";
            return false;
        }

        function removePlaceTag(id) {
            selectedPlaces = selectedPlaces.filter(p => p.id !== id);
            renderPlaceTags();
        }

        function renderPlaceTags() {
            const container = document.getElementById('selectedPlacesContainer');
            const hfIDs = document.getElementById('hfSelectedPlaceIDs');
            if (!container || !hfIDs) return;
            container.innerHTML = '';

            selectedPlaces.forEach(place => {
                const tag = document.createElement('div');
                tag.className = 'place-tag';
                tag.innerHTML = `${place.name} <span class="remove-btn" onclick="removePlaceTag(${place.id})"><i class="fa fa-times"></i></span>`;
                container.appendChild(tag);
            });

            const idsArray = selectedPlaces.map(p => p.id);
            hfIDs.value = idsArray.join(',');
        }

        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                renderPlaceTags();
            });
        }
    </script>
                
</ContentTemplate>
<Triggers> 
    <asp:PostBackTrigger ControlID="btnSave" />
</Triggers>
</asp:UpdatePanel>
</asp:Content>