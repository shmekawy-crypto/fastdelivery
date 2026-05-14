<%@ Page Title="إدارة المنيو" Language="C#" MasterPageFile="~/Places/MasterPages/Site.master" AutoEventWireup="true" CodeFile="Menu.aspx.cs" Inherits="Places_Menu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .menu-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 25px; margin-bottom: 25px; }
        .nav-tabs { border-bottom: 2px solid #ddd; margin-bottom: 20px; display: flex; flex-wrap: wrap; }
        .nav-tabs > li { float: none !important; }
        .nav-tabs > li.active > a { border: none !important; border-bottom: 4px solid #e67e22 !important; color: #e67e22 !important; font-weight: bold; background: none !important; }
        .tab-pane { padding: 20px 0; }
        .grid-img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }
        .extra-img { width: 40px; height: 40px; border-radius: 5px; object-fit: cover; border: 1px solid #ddd; }
        .section-header { font-weight: bold; color: #2c3e50; border-right: 5px solid #e67e22; padding-right: 15px; margin-bottom: 25px; }
        .well-custom { background: #f9f9f9; border: 1px solid #eee; padding: 15px; border-radius: 10px; margin-bottom: 15px; }
        .search-box { margin-bottom: 20px; }
        /* ستايل التحذيرات */
        .val-error { color: #e74c3c; font-size: 12px; font-weight: bold; margin-top: 5px; display: block; }
    </style>

    <asp:ScriptManager ID="sm1" runat="server"></asp:ScriptManager>

    <div class="container-fluid">
        <asp:UpdatePanel ID="upMenu" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:HiddenField ID="hfActiveTab" runat="server" Value="#basic" />
                <div class="menu-card">
                    <h3 class="section-header">إدارة أصناف المطعم</h3>
                    
                    <!-- إظهار ملخص الأخطاء أعلى الفورم -->
                    <asp:ValidationSummary ID="vsMain" runat="server" CssClass="alert alert-danger" ValidationGroup="vgSave" HeaderText="برجاء استكمال البيانات التالية:" />

                    <ul class="nav nav-tabs" id="menuTabs">
                        <li class="active"><a data-toggle="tab" href="#basic">1. البيانات الأساسية</a></li>
                        <li><a data-toggle="tab" href="#sizes">2. الأحجام والأسعار</a></li>
                        <li><a data-toggle="tab" href="#extras">3. الإضافات الاختيارية</a></li>
                    </ul>

                    <div class="tab-content">
                        <!-- التاب 1: البيانات الأساسية -->
                        <div id="basic" class="tab-pane fade in active">
                            <div class="row">
                                <div class="col-md-4 form-group">
                                    <label>تصنيف المنيو <span class="text-danger">*</span></label>
                                    <asp:DropDownList ID="ddlMenu" runat="server" CssClass="form-control" AppendDataBoundItems="true"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvMenu" runat="server" ControlToValidate="ddlMenu" InitialValue="0" CssClass="val-error" ErrorMessage="يجب اختيار قسم المنيو" ValidationGroup="vgSave" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-4 form-group">
                                    <label>الاسم (عربي) <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtNameAr" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNameAr" runat="server" ControlToValidate="txtNameAr" CssClass="val-error" ErrorMessage="يجب إدخال اسم الصنف بالعربي" ValidationGroup="vgSave" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-4 form-group">
                                    <label>الاسم (En) <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtNameEn" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNameEn" runat="server" ControlToValidate="txtNameEn" CssClass="val-error" ErrorMessage="يجب إدخال اسم الصنف بالإنجليزية" ValidationGroup="vgSave" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-4 form-group">
                                    <label>الاسم (Ru)</label>
                                    <asp:TextBox ID="txtNameRu" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-4 form-group">
                                    <label>وقت التحضير (دقيقة)</label>
                                    <asp:TextBox ID="txtPrepTime" runat="server" CssClass="form-control" TextMode="Number" Text="0"></asp:TextBox>
                                </div>
                                <div class="col-md-4 form-group">
                                    <label>صورة الصنف</label>
                                    <asp:HiddenField ID="hfExistingPhoto" runat="server" />
                                    <asp:FileUpload ID="fuItemPhoto" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <div class="well-custom">
                                <p class="text-primary" style="font-weight:bold;"><i class="glyphicon glyphicon-info-sign"></i> السعر (لحجم واحد فقط):</p>
                                <div class="row">
                                    <div class="col-md-6">
                                        <label>السعر الأساسي</label>
                                        <asp:TextBox ID="txtBasicPrice" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                                    </div>
                                    <div class="col-md-6">
                                        <label>الخصم</label>
                                        <asp:TextBox ID="txtBasicDiscount" runat="server" CssClass="form-control" placeholder="0"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 form-group"><label>وصف (Ar)</label><asp:TextBox ID="txtDescAr" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox></div>
                                <div class="col-md-4 form-group"><label>وصف (En)</label><asp:TextBox ID="txtDescEn" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox></div>
                                <div class="col-md-4 form-group"><label>وصف (Ru)</label><asp:TextBox ID="txtDescRu" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox></div>
                            </div>
                        </div>

                        <!-- التاب 2: الأحجام -->
                        <div id="sizes" class="tab-pane fade">
                            <div class="well-custom row">
                                <div class="col-md-4">
                                    <asp:DropDownList ID="ddlSizes" runat="server" CssClass="form-control"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvSizeDDL" runat="server" ControlToValidate="ddlSizes" InitialValue="0" CssClass="val-error" ErrorMessage="اختر الحجم" ValidationGroup="vgSize" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtSizePrice" runat="server" CssClass="form-control" placeholder="السعر"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvSizePrice" runat="server" ControlToValidate="txtSizePrice" CssClass="val-error" ErrorMessage="مطلوب السعر" ValidationGroup="vgSize" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-3"><asp:TextBox ID="txtSizeDiscount" runat="server" CssClass="form-control" placeholder="خصم" Text="0"></asp:TextBox></div>
                                <div class="col-md-2">
                                    <asp:Button ID="btnAddSize" runat="server" Text="إضافة" CssClass="btn btn-warning btn-block" OnClick="btnAddSize_Click" ValidationGroup="vgSize" />
                                </div>
                            </div>
                            <asp:GridView ID="gvSizes" runat="server" CssClass="table table-bordered" AutoGenerateColumns="false" OnRowDeleting="gvSizes_RowDeleting">
                                <Columns>
                                    <asp:BoundField DataField="SizeName" HeaderText="الحجم" />
                                    <asp:TemplateField HeaderText="السعر">
                                        <ItemTemplate><asp:TextBox ID="txtGridSizePrice" runat="server" Text='<%# Eval("Price") %>' CssClass="form-control input-sm"></asp:TextBox></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="الخصم">
                                        <ItemTemplate><asp:TextBox ID="txtGridSizeDisc" runat="server" Text='<%# Eval("DiscountValue") %>' CssClass="form-control input-sm"></asp:TextBox></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:CommandField ShowDeleteButton="true" DeleteText="حذف" />
                                    <asp:TemplateField Visible="false"><ItemTemplate><asp:Label ID="lblSizeID" runat="server" Text='<%# Eval("SizeID") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>

                        <!-- التاب 3: الإضافات -->
                        <div id="extras" class="tab-pane fade">
                            <div class="well-custom row">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <asp:DropDownList ID="ddlExtras" runat="server" CssClass="form-control"></asp:DropDownList>
                                        <span class="input-group-btn"><button type="button" class="btn btn-info" data-toggle="modal" data-target="#modalNewExtraType"><i class="glyphicon glyphicon-plus"></i></button></span>
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvExtraDDL" runat="server" ControlToValidate="ddlExtras" InitialValue="0" CssClass="val-error" ErrorMessage="اختر الإضافة" ValidationGroup="vgExtra" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-4">
                                    <asp:TextBox ID="txtExtraPrice" runat="server" CssClass="form-control" placeholder="السعر"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvExtraPrice" runat="server" ControlToValidate="txtExtraPrice" CssClass="val-error" ErrorMessage="مطلوب السعر" ValidationGroup="vgExtra" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-md-2">
                                    <asp:Button ID="btnAddExtra" runat="server" Text="ربط" CssClass="btn btn-success btn-block" OnClick="btnAddExtra_Click" ValidationGroup="vgExtra" />
                                </div>
                            </div>
                            <asp:GridView ID="gvExtras" runat="server" CssClass="table table-bordered" AutoGenerateColumns="false" OnRowDeleting="gvExtras_RowDeleting">
                                <Columns>
                                    <asp:TemplateField HeaderText="الصورة">
                                        <ItemTemplate><asp:Image runat="server" ImageUrl='<%# "~/ar/" + Eval("PhotoUrl") %>' CssClass="extra-img" /></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ExtraName" HeaderText="الإضافة" />
                                    <asp:TemplateField HeaderText="السعر">
                                        <ItemTemplate><asp:TextBox ID="txtGridExtraPrice" runat="server" Text='<%# Eval("Price") %>' CssClass="form-control input-sm"></asp:TextBox></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:CommandField ShowDeleteButton="true" DeleteText="حذف" />
                                    <asp:TemplateField Visible="false"><ItemTemplate><asp:Label ID="lblExtraID" runat="server" Text='<%# Eval("ExtraID") %>'></asp:Label></ItemTemplate></asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>

                    <div class="text-center" style="margin-top:20px;">
                        <asp:Button ID="btnSaveAll" runat="server" Text="حفظ الصنف بالكامل" CssClass="btn btn-primary btn-lg" OnClick="btnSaveAll_Click" ValidationGroup="vgSave" style="width:250px; border-radius:30px; font-weight:bold;" />
                        <asp:LinkButton ID="btnCancelEdit" runat="server" Text="إلغاء / جديد" CssClass="btn btn-default btn-lg" OnClick="btnCancelEdit_Click" style="border-radius:30px; margin-right:10px;" />
                    </div>
                </div>
            </ContentTemplate>
            <Triggers><asp:PostBackTrigger ControlID="btnSaveAll" /></Triggers>
        </asp:UpdatePanel>

        <asp:UpdatePanel ID="upGrid" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="menu-card">
                    <div class="row search-box">
                        <div class="col-md-8"><h4 style="font-weight:bold; color:#2c3e50;">الأصناف المسجلة حالياً</h4></div>
                        <div class="col-md-4">
                            <div class="input-group">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="ابحث باسم الصنف..." OnTextChanged="txtSearch_TextChanged" AutoPostBack="true"></asp:TextBox>
                                <span class="input-group-btn">
                                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-info" OnClick="btnSearch_Click">
                                        <i class="glyphicon glyphicon-search"></i>
                                    </asp:LinkButton>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <asp:GridView ID="gvMenuItems" runat="server" CssClass="table table-hover" GridLines="None" AutoGenerateColumns="false" DataKeyNames="id" OnRowCommand="gvMenuItems_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="الصورة">
                                <ItemTemplate><asp:Image runat="server" ImageUrl='<%# "~/ar/" + Eval("PhotoUrl") %>' CssClass="grid-img" /></ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Name" HeaderText="الاسم" />
                            <asp:BoundField DataField="MenuName" HeaderText="القسم" />
                            <asp:TemplateField HeaderText="التحكم">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CommandName="EditItem" CommandArgument='<%# Eval("id") %>' CssClass="btn btn-info btn-xs"><i class="glyphicon glyphicon-pencil"></i> تعديل</asp:LinkButton>
                                    <asp:LinkButton runat="server" CommandName="DeleteItem" CommandArgument='<%# Eval("id") %>' CssClass="btn btn-danger btn-xs" OnClientClick="return confirm('حذف؟')"><i class="glyphicon glyphicon-trash"></i> حذف</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <!-- مودال تعريف إضافة جديدة -->
    <div class="modal fade" id="modalNewExtraType" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content" style="border-radius:15px;">
                <div class="modal-header" style="background:#5bc0de; color:white; border-radius:15px 15px 0 0;">
                    <h4 class="modal-title">تعريف إضافة جديدة للنظام</h4>
                </div>
                <div class="modal-body">
                    <asp:ValidationSummary ID="vsModal" runat="server" CssClass="alert alert-danger" ValidationGroup="vgModal" />
                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label>عربي <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNewExtraNameAr" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalAr" runat="server" ControlToValidate="txtNewExtraNameAr" CssClass="val-error" ErrorMessage="مطلوب اسم الإضافة عربي" ValidationGroup="vgModal" Display="None"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-4 form-group">
                            <label>English <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNewExtraNameEn" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalEn" runat="server" ControlToValidate="txtNewExtraNameEn" CssClass="val-error" ErrorMessage="مطلوب اسم الإضافة إنجليزي" ValidationGroup="vgModal" Display="None"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-4 form-group">
                            <label>Русский</label>
                            <asp:TextBox ID="txtNewExtraNameRu" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-md-12 form-group">
                            <label>السعر الافتراضي</label>
                            <asp:TextBox ID="txtNewExtraDefaultPrice" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
                        </div>
                        <div class="col-md-12 form-group">
                            <label>صورة الإضافة</label>
                            <asp:FileUpload ID="fuExtraIcon" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">إلغاء</button>
                    <asp:Button ID="btnSaveExtraType" runat="server" Text="حفظ في القاموس" CssClass="btn btn-info" OnClick="btnSaveExtraType_Click" ValidationGroup="vgModal" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function rebindTabs() {
            var activeTab = document.getElementById('<%= hfActiveTab.ClientID %>').value;
            if (activeTab) { $('.nav-tabs a[href="' + activeTab + '"]').tab('show'); }
            $('.nav-tabs a').on('shown.bs.tab', function (e) {
                var id = $(e.target).attr('href');
                document.getElementById('<%= hfActiveTab.ClientID %>').value = id;
            });
        }
        $(document).ready(function () { rebindTabs(); });
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () { rebindTabs(); });
    </script>
</asp:Content>