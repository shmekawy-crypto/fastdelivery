<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="PlaceTypes.aspx.cs" Inherits="Admin_Pages_PlaceTypes" Title="أنواع الأماكن" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
    أنواع الأماكن (الفئات)
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

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
                    <div class="page-title">تسجيل أنواع الأماكن</div>
                </div>
                <ol class="breadcrumb page-breadcrumb pull-left">
                    <li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i></li>
                    <li class="active">تسجيل أنواع الأماكن</li>
                </ol>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12 col-sm-12">
                <div class="card card-box">
                    <div class="card-head">
                        <header>بيانات النوع</header>
                    </div>

                    <div class="card-body" id="bar-parent">
                        <div class="form-body">

                            <div class="form-group row">
                                <label class="control-label col-sm-2">الاسم بالعربية<span class="required">*</span></label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtNameAr" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNameAr" runat="server" ControlToValidate="txtNameAr"
                                        ErrorMessage="الاسم بالعربية مطلوب" Display="Dynamic" CssClass="text-danger"
                                        ValidationGroup="TypeGroup" />
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="control-label col-sm-2">الاسم بالإنجليزية<span class="required">*</span></label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtNameEn" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNameEn" runat="server" ControlToValidate="txtNameEn"
                                        ErrorMessage="الاسم بالإنجليزية مطلوب" Display="Dynamic" CssClass="text-danger"
                                        ValidationGroup="TypeGroup" />
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="control-label col-sm-2">الاسم بالروسية<span class="required">*</span></label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtNameRu" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNameRu" runat="server" ControlToValidate="txtNameRu"
                                        ErrorMessage="الاسم بالروسية مطلوب" Display="Dynamic" CssClass="text-danger"
                                        ValidationGroup="TypeGroup" />
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="control-label col-sm-2">ترتيب الظهور</label>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtOrder" runat="server" CssClass="form-control input-height" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="control-label col-sm-2">صورة الفئة</label>
                                <div class="col-md-8">
                                    <asp:FileUpload ID="fuTypePhoto" runat="server" CssClass="form-control" />
                                    <asp:HiddenField ID="hfTypePhotoPath" runat="server" />
                                </div>
                            </div>

                            <div class="form-group row">
                                 <label class="control-label col-sm-2">تفعيل</label>
                                 <div class="col-md-2">
                                    <label class="switchToggle">
                                         <asp:CheckBox ID="chkActive" runat="server" Checked="true" />
                                         <span class="slider green round"></span>
                                    </label>
                                 </div>
                            </div>

                            <div class="col-lg-12 p-t-5 text-center">
                                <asp:Button ID="btnSave" runat="server" CssClass="btn btn-info m-r-20" Text="حفظ"
                                    OnClick="btnSave_Click" ValidationGroup="TypeGroup" />
                                <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="الغاء"
                                    OnClick="btnCancel_Click" CausesValidation="false" />
                            </div>

                            <div class="table-scrollable m-t-20">
                                <asp:GridView ID="gvPlaceTypes" runat="server" AutoGenerateColumns="False" 
                                    CssClass="table table-striped table-bordered table-hover" AllowPaging="True" PageSize="10"
                                    OnPageIndexChanging="gvPlaceTypes_PageIndexChanging" OnRowCommand="gvPlaceTypes_RowCommand">
                                    <Columns>
                                        <asp:TemplateField HeaderText="الصورة">
                                            <ItemTemplate>
                                                <asp:Image ID="imgType" runat="server" Width="50px" Height="50px" 
                                                    ImageUrl='<%# string.IsNullOrEmpty(Eval("TypeImage").ToString()) ? "~/ar/images/no-image.png" : "~/ar/" + Eval("TypeImage") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="الاسم (ع)" DataField="TypeNameAr" />
                                        <asp:BoundField HeaderText="الاسم (E)" DataField="TypeNameEn" />
                                        <asp:BoundField HeaderText="الترتيب" DataField="POrder" />
                                        <asp:TemplateField HeaderText="الحالة">
                                            <ItemTemplate>
                                                <%# (bool)Eval("Active") ? "مفعل" : "معطل" %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="التحكم">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditType" CommandArgument='<%# Eval("id") %>'
                                                    CssClass="btn btn-xs btn-info">تعديل</asp:LinkButton>
                                                <asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteType" CommandArgument='<%# Eval("id") %>'
                                                    OnClientClick="return confirm('هل أنت متأكد من حذف هذه الفئة؟');" CssClass="btn btn-xs btn-danger">حذف</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </ContentTemplate>
     <Triggers>
        <asp:PostBackTrigger ControlID="btnSave" />
    </Triggers>
</asp:UpdatePanel>

</asp:Content>