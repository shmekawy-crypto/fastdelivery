<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="MenuItems.aspx.cs" Inherits="Admin_Pages_MenuItems" Title="عناصر القوائم" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
    عناصر القوائم
   
    
     
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <script type="text/javascript">
    
         Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(evt, args) {
             $('#<%=ddlPlace.ClientID %>').select2();
             $('#<%=ddlMenu.ClientID %>').select2();
            });
   </script>
<style>
        /* تنسيق بسيط للتابز لضمان مظهر متناسق */
        .nav-tabs { border-bottom: 2px solid #ddd; margin-bottom: 20px; }
        .nav-tabs > li.active > a { border: none !important; border-bottom: 3px solid #57c7d4 !important; color: #57c7d4 !important; font-weight: bold; }
        .tab-pane { padding-top: 20px; }
        /* تحسين شكل المدخلات داخل الجدول */
.custom-grid .form-control {
    height: 30px !important;
    padding: 2px 8px !important;
    font-size: 13px !important;
    border-radius: 4px !important;
}

.font-bold { font-weight: 600; color: #2c3e50; }

/* تأثير بسيط عند الوقوف على الصف */
.custom-grid tr:hover { background-color: #f1f8fb !important; }

/* تنسيق الـ well الخاص بالإدخال */
.well .control-label {
    font-size: 13px;
    margin-bottom: 5px;
    color: #666;
}
/* تنسيق رأس الجدول (العناوين) */
.custom-grid th {
    font-size: 13px !important; /* تصغير حجم الخط */
    font-weight: 600 !important;
    background-color: #f8f9fa !important;
    color: #555 !important;
    text-align: center !important;
    padding: 8px !important; /* تقليل المساحة الداخلية */
    border-bottom: 2px solid #57c7d4 !important; /* خط رفيع بلون الهوية */
}

/* تنسيق الخلايا (البيانات) */
.custom-grid td {
    font-size: 13px !important;
    vertical-align: middle !important;
    text-align: center !important;
    padding: 5px !important;
}

/* تصغير حقول الإدخال داخل الجدول أكتر */
.custom-grid .form-control {
    height: 28px !important;
    font-size: 12px !important;
    padding: 2px 5px !important;
    text-align: center;
    border: 1px solid #e1e1e1;
}

/* تنسيق الأيقونات داخل الجدول */
.custom-grid .input-group-addon {
    padding: 2px 8px !important;
    font-size: 11px !important;
    background-color: #f1f1f1;
}
/* تنسيق شامل للجريد الخاص بالأوزان */
.custom-grid {
    direction: rtl !important;
    margin-top: 10px;
}

/* ضبط العناوين (Header) */
.custom-grid th {
    background-color: #f4f6f9 !important; /* لون هادئ للخلفية */
    color: #333 !important;
    font-size: 12px !important; /* تصغير الخط */
    font-weight: bold !important;
    text-align: center !important; /* توسيط النص */
    padding: 6px 4px !important; /* تقليل الارتفاع جداً */
    vertical-align: middle !important;
    border-bottom: 2px solid #57c7d4 !important;
}

/* ضبط الخلايا (Data Cells) */
.custom-grid td {
    text-align: center !important; /* توسيط البيانات */
    vertical-align: middle !important;
    padding: 4px !important; /* تقليل المسافات الداخلية */
    font-size: 13px !important;
}

/* تصغير حقول الإدخال والـ Input Groups */
.custom-grid .input-group {
    width: 100% !important;
}

.custom-grid .form-control {
    height: 26px !important; /* تقليل ارتفاع التكست بوكس */
    font-size: 12px !important;
    padding: 2px 5px !important;
    text-align: center !important;
}

.custom-grid .input-group-addon {
    padding: 2px 6px !important;
    font-size: 10px !important;
    min-width: 30px;
}
/* تنسيق احترافي للجريد */
.custom-grid {
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    border: none !important;
    margin-top: 15px;
}

.custom-grid th {
    background-color: #343a40 !important; /* لون غامق فخم للهيدر */
    color: white !important;
    text-align: center !important;
    vertical-align: middle !important;
    padding: 12px !important;
    font-size: 14px;
    border: none !important;
}

.custom-grid td {
    text-align: center !important;
    vertical-align: middle !important;
    padding: 8px !important;
    border-bottom: 1px solid #eee !important;
    font-size: 13px;
}

.custom-grid tr:hover {
    background-color: #f8f9fa !important; /* تأثير عند مرور الماوس */
    transition: 0.3s;
}

/* تنسيق الصورة داخل الجريد */
.grid-img {
    width: 50px;
    height: 50px;
    object-fit: cover;
    border-radius: 5px;
    border: 1px solid #ddd;
    background-color: #fff;
}

/* تنسيق حقل السعر داخل الجريد */
.grid-input {
    width: 70px;
    text-align: center;
    border-radius: 4px;
    border: 1px solid #ced4da;
    padding: 4px;
}
    </style>
<asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="100" DynamicLayout="true">
    <ProgressTemplate>
        <div class="update"></div>
    </ProgressTemplate>
</asp:UpdateProgress>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
          
        <div class="page-bar">
            <div class="page-title-breadcrumb">
                <div class="pull-right">
                    <div class="page-title">تسجيل عناصر القوائم</div>
                </div>
                <ol class="breadcrumb page-breadcrumb pull-left">
                    <li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i></li>
                    <li class="active">تسجيل عناصر القوائم</li>
                </ol>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12 col-sm-12">
                <div class="card card-box">
                    <div class="card-head">
                        <header>بيانات العنصر</header>
                        <div class="tools">
                            <a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
                            <a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
                            <a class="t-close btn-color fa fa-times" href="javascript:;"></a>
                        </div>
                    </div>

                    <div class="card-body" id="bar-parent">
                        
                        <!-- بداية نظام التابز -->
                        <div class="tabbable-line">
                            <ul class="nav nav-tabs">
                                <li class="active"><a href="#tab_1" data-toggle="tab">البيانات الأساسية</a></li>
                                <li><a href="#tab_2" data-toggle="tab">الأوزان / الأحجام</a></li>
                                <li><a href="#tab_3" data-toggle="tab">الإضافات والخيارات</a></li>
                            </ul>
                            
                            <div class="tab-content">
                                <!-- التاب الأولى: البيانات الحالية -->
                                <div class="tab-pane active" id="tab_1">
                                    <div class="form-body">
                                        <!-- المكان / المطعم -->
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">المكان / المطعم<span class="required">*</span></label>
                                            <div class="col-md-8">
                                                <asp:DropDownList ID="ddlPlace" runat="server" CssClass="form-control input-height" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlPlace_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rfvPlace" runat="server" ControlToValidate="ddlPlace" InitialValue="0" ErrorMessage="المكان مطلوبة" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                        </div>

                                        <!-- القائمة -->
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">القائمة<span class="required">*</span></label>
                                            <div class="col-md-8">
                                                <asp:DropDownList ID="ddlMenu" runat="server" CssClass="form-control input-height" AppendDataBoundItems="true"></asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rfvMenu" runat="server" ControlToValidate="ddlMenu" InitialValue="0" ErrorMessage="القائمة مطلوبة" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                        </div>

                                        <!-- اسم العنصر بلغات مختلفة -->
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">اسم العنصر<span class="required">*</span></label>
                                            <div class="col-md-8">
                                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="اسم العنصر مطلوب" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">اسم العنصر بالإنجليزية<span class="required">*</span></label>
                                            <div class="col-md-8">
                                                <asp:TextBox ID="txtNameEn" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtNameEn" ErrorMessage="اسم العنصر بالإنجليزية مطلوب" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">اسم العنصر بالروسية<span class="required">*</span></label>
                                            <div class="col-md-8">
                                                <asp:TextBox ID="txtNameRu" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtNameRu" ErrorMessage="اسم العنصر بالروسية مطلوب" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                        </div>

                                        <!-- الوصف بلغات مختلفة -->
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">الوصف بالعربية</label>
                                            <div class="col-md-8">
                                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">الوصف بالإنجليزية</label>
                                            <div class="col-md-8">
                                                <asp:TextBox ID="txtDescriptionEn" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">الوصف بالروسية</label>
                                            <div class="col-md-8">
                                                <asp:TextBox ID="txtDescriptionRu" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                            </div>
                                        </div>

                                        <!-- السعر والخصم ووقت التحضير -->
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">السعر<span class="required">*</span></label>
                                            <div class="col-md-3">
                                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice" ErrorMessage="السعر مطلوب" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                                <asp:RegularExpressionValidator ID="revPrice" runat="server" ControlToValidate="txtPrice" ValidationExpression="^\d+(\.\d{1,2})?$" ErrorMessage="السعر يجب أن يكون رقم عشري" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                            <label class="control-label col-sm-2">قيمة الخصم</label>
                                            <div class="col-md-3">
                                                <asp:TextBox ID="txtDiscount" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDiscount" ErrorMessage="الخصم مطلوب" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                                <asp:RegularExpressionValidator ID="revDiscount" runat="server" ControlToValidate="txtDiscount" ValidationExpression="^\d+(\.\d{1,2})?$" ErrorMessage="الخصم يجب أن يكون رقم عشري" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">وقت التحضير (بالدقائق)</label>
                                            <div class="col-md-3">
                                                <asp:TextBox ID="txtPrepearMin" runat="server" CssClass="form-control input-height" TextMode="Number"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="revPrepearMin" runat="server" ControlToValidate="txtPrepearMin" ValidationExpression="^\d+$" ErrorMessage="يجب إدخال أرقام فقط" Display="Dynamic" CssClass="text-danger" ValidationGroup="MenuItemGroup" />
                                            </div>
                                        </div>

                                        <!-- الصورة ومتاح -->
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">الصورة</label>
                                            <div class="col-md-8">
                                                <asp:FileUpload ID="fuPhoto" runat="server" CssClass="form-control" />
                                                <asp:HiddenField ID="hfPhotoPath" runat="server" />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="control-label col-sm-2">متاح</label>
                                            <div class="col-md-2">
                                                <label class="switchToggle">
                                                    <asp:CheckBox ID="chkAvailable" runat="server" Checked="true" />
                                                    <span class="slider green round"></span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- التاب الثانية: الأوزان (مكان فارغ للإضافات المستقبلية) -->
                                <!-- التاب الثانية: الأوزان والأحجام -->
<!-- التاب الثانية: الأوزان والأحجام -->
<div class="tab-pane" id="tab_2">
    <div class="form-body">
        <h4 class="form-section" style="color: #57c7d4; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px;">
            <i class="fa fa-arrows-v"></i> إدارة الأحجام والأسعار المخصصة
        </h4>
        
        <!-- منطقة إضافة حجم جديد -->
        <div class="well" style="background-color: #f9f9f9; border: 1px dashed #57c7d4; padding: 20px; border-radius: 8px;">
            <div class="row">
                <div class="col-md-3">
                    <label class="control-label">اختر الحجم</label>
                    <asp:DropDownList ID="ddlSizes" runat="server" CssClass="form-control select2" AppendDataBoundItems="true">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="control-label">السعر (ج.م)</label>
                    <asp:TextBox ID="txtSizePriceAdd" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="control-label">قيمة الخصم</label>
                    <asp:TextBox ID="txtSizeDiscountAdd" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="control-label">&nbsp;</label>
                    <asp:LinkButton ID="btnAddSizeToList" runat="server" CssClass="btn btn-block btn-info" OnClick="btnAddSizeToList_Click" CausesValidation="false">
                        <i class="fa fa-plus"></i> إضافة للجدول
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <!-- جدول عرض الأحجام المضافة -->
        <div class="table-responsive p-t-20">
            <asp:GridView ID="gvSelectedSizes" runat="server" AutoGenerateColumns="False" 
    CssClass="table table-bordered custom-grid" 
    OnRowDeleting="gvSelectedSizes_RowDeleting">
    <Columns>
        
        <asp:BoundField DataField="SizeName" HeaderText="الحجم">
            <HeaderStyle HorizontalAlign="Center" Width="20%" />
            <ItemStyle HorizontalAlign="Center" />
        </asp:BoundField>
        
        <asp:TemplateField HeaderText="السعر">
            <HeaderStyle HorizontalAlign="Center" Width="30%" />
            <ItemTemplate>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-money"></i></span>
                    <asp:TextBox ID="txtGridPrice" runat="server" Text='<%# Eval("Price") %>' CssClass="form-control"></asp:TextBox>
                </div>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Center" />
        </asp:TemplateField>

        <asp:TemplateField HeaderText="الخصم">
            <HeaderStyle HorizontalAlign="Center" Width="30%" />
            <ItemTemplate>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                    <asp:TextBox ID="txtGridDiscount" runat="server" Text='<%# Eval("DiscountValue") %>' CssClass="form-control"></asp:TextBox>
                </div>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Center" />
        </asp:TemplateField>

        <asp:TemplateField HeaderText="إجراء">
            <HeaderStyle HorizontalAlign="Center" Width="20%" />
            <ItemTemplate>
                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn btn-xs btn-outline btn-danger">
                    <i class="fa fa-trash"></i>
                </asp:LinkButton>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Center" />
        </asp:TemplateField>
        <asp:TemplateField Visible="false">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblSizeID" runat="server" Text='<%# Eval("SizeID") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
    </Columns>
</asp:GridView>
        </div>
    </div>
</div>

                                <!-- التاب الثالثة: الإضافات (مكان فارغ للإضافات المستقبلية) -->
                                <div class="tab-pane" id="tab_3">
    <div class="form-body">
        <h4 class="form-section" style="color: #57c7d4;">
            <i class="fa fa-plus-circle"></i> إدارة الإضافات والملحقات
        </h4>

        <div class="well" style="background-color: #fff; border: 1px solid #e1e1e1; padding: 20px;">
            <div class="row">
                <div class="col-md-5">
                    <label class="control-label">اختر الإضافة</label>
                    <div class="input-group">
                        <asp:DropDownList ID="ddlExtras" runat="server" CssClass="form-control select2">
                        </asp:DropDownList>
                        <!-- زر فتح البوب أب لإضافة نوع جديد -->
                        <span class="input-group-btn">
                            <button type="button" class="btn btn-info" data-toggle="modal" data-target="#modalAddNewExtra">
                                <i class="fa fa-plus"></i>
                            </button>
                        </span>
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="control-label">السعر الإضافي</label>
                    <asp:TextBox ID="txtExtraPrice" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="control-label">&nbsp;</label>
                    <asp:LinkButton ID="btnAddExtraToList" runat="server" CssClass="btn btn-block btn-success" OnClick="btnAddExtraToList_Click">
                        <i class="fa fa-check"></i> إضافة للإصناف
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <!-- جدول الإضافات المختارة -->
        <!-- جدول الإضافات المختارة -->
<div class="table-responsive">
    <asp:GridView ID="gvSelectedExtras" runat="server" AutoGenerateColumns="False" 
        CssClass="table table-bordered custom-grid" GridLines="None" DataKeyNames="Extra_id">
        <Columns>
            <%-- 1. الصورة --%>
            <asp:TemplateField HeaderText="الصورة">
                <ItemTemplate>
                    <asp:Image ID="imgExtra" runat="server" CssClass="grid-img"
                        ImageUrl='<%# string.IsNullOrEmpty(Eval("PhotoUrl").ToString()) ? "~/assets/img/no-item.png" : "~/" + Eval("PhotoUrl") %>' Width="100" Height="100" />
                </ItemTemplate>
                <HeaderStyle Width="70px" />
            </asp:TemplateField>

            <%-- 2. اسم الإضافة --%>
            <asp:BoundField DataField="Name" HeaderText="الإضافة" />

            <%-- 3. السعر (قابل للتعديل) --%>
            <asp:TemplateField HeaderText="السعر">
                <ItemTemplate>
                    <div class="input-group input-group-sm" style="width: 100px; margin: 0 auto;">
                        <asp:TextBox ID="txtGridPrice" runat="server" Text='<%# Eval("Price") %>' 
                            CssClass="form-control grid-input"></asp:TextBox>
                        <span class="input-group-text">ج.م</span>
                    </div>
                </ItemTemplate>
                <HeaderStyle Width="120px" />
            </asp:TemplateField>

            <%-- 4. إجراء --%>
            <asp:TemplateField HeaderText="إجراء">
                <ItemTemplate>
                    <asp:LinkButton ID="btnDeleteExtra" runat="server" CommandName="Delete" 
                        CssClass="btn btn-outline-danger btn-sm" OnClientClick="return confirm('حذف الإضافة؟');">
                        <i class="fa fa-trash"></i>
                    </asp:LinkButton>
                </ItemTemplate>
                <HeaderStyle Width="60px" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>
    </div>
</div>
                            </div>
                        </div>

                        <hr />

                        <!-- الأزرار والبحث والجدول (خارج التابز لتكون ظاهرة دائماً) -->
                        <div class="col-lg-12 p-t-5 text-center">
                            <asp:Button ID="btnSave" runat="server" CssClass="btn btn-info m-r-20" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="MenuItemGroup" />
                            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="الغاء" OnClick="btnCancel_Click" CausesValidation="false" />
                        </div>

                        <div class="form-group row p-t-10">
                            <div class="col-md-5">
                                <div class="input-group">
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="بحث" OnClick="btnSearch_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>

                        <div class="table-scrollable">
                            <asp:GridView ID="gvMenuItems" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-striped table-bordered table-hover" AllowPaging="True" PageSize="10"
                                OnPageIndexChanging="gvMenuItems_PageIndexChanging" OnRowCommand="gvMenuItems_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="الصورة">
                                        <ItemTemplate>
                                            <asp:Image ID="imgPhoto" runat="server" Width="50px" Height="50px" ImageUrl='<%# "~/ar/" + Eval("PhotoUrl") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="الاسم" DataField="Name" />
                                    <asp:BoundField HeaderText="الإسم بالإنجليزية" DataField="NameEn" />
                                    <asp:BoundField HeaderText="الإسم بالروسية" DataField="NameRu" />
                                    <asp:BoundField HeaderText="المكان" DataField="PlaceName" />
                                    <asp:BoundField HeaderText="القائمة" DataField="MenuName" />
                                    
                                    <asp:BoundField HeaderText="الخصم" DataField="DiscountValue" DataFormatString="{0:N2}" />
                                    <asp:BoundField HeaderText="وقت التحضير" DataField="PrepearMin" />
                                    <asp:TemplateField HeaderText="متاح؟">
                                        <ItemTemplate><%# (bool)Eval("IsAvailable") ? "نعم" : "لا" %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="التحكم">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditItem" CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-xs btn-info">تعديل</asp:LinkButton>
                                            &nbsp;
                                            <asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteItem" CommandArgument='<%# Eval("ID") %>' OnClientClick="return confirm('هل أنت متأكد من الحذف؟');" CssClass="btn btn-xs btn-danger">حذف</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal: إضافة نوع إضافة جديد لقاموس النظام -->
<div class="modal fade" id="modalAddNewExtra" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!-- رأس المودال -->
            <div class="modal-header bg-info" style="border-bottom: 2px solid #57c7d4;">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="color: white; opacity: 1;">&times;</button>
                <h4 class="modal-title" style="color: white; font-weight: bold;">
                    <i class="fa fa-plus-square"></i> تعريف إضافة جديدة لنظام Fast Delivery
                </h4>
            </div>

            <!-- جسم المودال -->
            <div class="modal-body" style="background-color: #f9f9f9;">
                <div class="row">
                    <!-- الاسم بالعربي -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="control-label">الاسم (عربي) <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtExtraAr" runat="server" CssClass="form-control" placeholder="مثلاً: صوص ثوم"></asp:TextBox>
                        </div>
                    </div>
                    <!-- الاسم بالإنجليزي -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="control-label">Name (English)</label>
                            <asp:TextBox ID="txtExtraEn" runat="server" CssClass="form-control" placeholder="e.g. Garlic Sauce"></asp:TextBox>
                        </div>
                    </div>
                    <!-- الاسم بالروسي -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="control-label">Имя (Русский)</label>
                            <asp:TextBox ID="txtExtraRu" runat="server" CssClass="form-control" placeholder="напр. Чесночный соус"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <hr />

                <div class="row">
                    <!-- السعر الافتراضي -->
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label">السعر الافتراضي (ج.م)</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-money"></i></span>
                                <asp:TextBox ID="txtDefaultPrice" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <!-- رفع الصورة -->
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label">صورة الإضافة</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-image"></i></span>
                                <asp:FileUpload ID="fuExtraImg" runat="server" CssClass="form-control" />
                            </div>
                            <small class="text-muted">يفضل رفع صور بخلفية شفافة (PNG).</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- أزرار التحكم -->
            <div class="modal-footer" style="background-color: #fff; border-top: 1px solid #eee;">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-times"></i> إغلاق
                </button>
                <asp:Button ID="btnSaveNewExtraType" runat="server" Text="حفظ الإضافة في القاموس" 
                    CssClass="btn btn-info" OnClick="btnSaveNewExtraType_Click" />
            </div>
        </div>
    </div>
</div>
        <script>
            function isNumberKey(evt) {
                var charCode = (evt.which) ? evt.which : event.keyCode;
                if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode != 46)
                    return false;
                return true;
            }
        </script>
        <asp:HiddenField ID="hfSelectedTab" runat="server" Value="#tab_1" />
       <script type="text/javascript">
    function activeTab() {
        // 1. جلب التاب المحفوظة (بتنفع بعد الضغط على أزرار الإضافة والحفظ)
        var tabId = document.getElementById('<%= hfSelectedTab.ClientID %>').value;
        
        if (tabId) {
            applyTabState(tabId);
        }

        // 2. عند الضغط اليدوي بالماوس (تغيير اللون لحظياً)
        $('.nav-tabs a').on('click', function (e) {
            var currentTab = $(this).attr('href');
            
            // تحديث قيمة الـ HiddenField
            document.getElementById('<%= hfSelectedTab.ClientID %>').value = currentTab;
            
            // تطبيق اللون الأخضر فوراً وإخفاء القديم
            applyTabState(currentTab);
        });
    }

    // وظيفة مساعدة لتنظيف وحقن كلاس active
           function applyTabState(tabId) {
               // 1. مسح كلاس active من كل الـ li ومن كل الـ a
               $('.nav-tabs li').removeClass('active');
               $('.nav-tabs a').removeClass('active');
               $('.tab-pane').removeClass('active show');

               // 2. تحديد اللينك اللي عليه الدور
               var targetLink = $('.nav-tabs a[href="' + tabId + '"]');

               // 3. تفعيل الـ li الأب (ده اللي بيظهر اللون الأخضر عندك) وتفعيل اللينك نفسه
               targetLink.addClass('active');
               targetLink.parent('li').addClass('active');

               // 4. إظهار محتوى التاب
               $(tabId).addClass('active show');
           }

    // تشغيل عند أول مرة
    $(document).ready(function () {
        activeTab();
    });

    // إعادة التشغيل بعد الـ Postback (عشان أزرار الإضافة في مشروع Fast Delivery)
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
        activeTab();
    });
           
</script>
        <script type="text/javascript">
    // دالة لمراقبة عملية الـ Validation
    function WebForm_OnSubmit() {
        if (typeof (Page_Validators) !== "undefined") {
            for (var i = 0; i < Page_Validators.length; i++) {
                var val = Page_Validators[i];
                // لو الـ Validator اكتشف خطأ وغير صالح
                if (!val.isvalid) {
                    // البحث عن التاب (الـ div) اللي جواه الـ Validator ده
                    var tabPane = $(val).closest('.tab-pane');
                    if (tabPane.length > 0) {
                        var tabId = "#" + tabPane.attr('id');
                        
                        // تحديث الـ HiddenField وقيمة التاب النشطة
                        document.getElementById('<%= hfSelectedTab.ClientID %>').value = tabId;
                        applyTabState(tabId);
                        
                        // نخرج من اللفة عشان يركز على أول خطأ يقابله
                        break; 
                    }
                }
            }
        }
        return Page_IsValid;
    }
</script>
    </ContentTemplate>
    <Triggers>
        <asp:PostBackTrigger ControlID="btnSave" />
        <asp:PostBackTrigger ControlID="btnSaveNewExtraType" />
    </Triggers>
</asp:UpdatePanel>

</asp:Content>