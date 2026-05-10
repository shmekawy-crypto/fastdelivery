<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Sizes.aspx.cs" Inherits="Admin_Pages_Sizes" Title="الأحجام" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
    تسجيل الأحجام
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="100" DynamicLayout="true" >
        <ProgressTemplate>
            <div class="update"></div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="page-bar">
                <div class="page-title-breadcrumb">
                    <div class=" pull-right">
                        <div class="page-title"> تسجيل الأحجام</div>
                    </div>
                    <ol class="breadcrumb page-breadcrumb pull-left">
                        <li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i></li>
                        <li class="active">تسجيل الأحجام</li>
                    </ol>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="card card-box">
                        <div class="card-head">
                            <header>بيانات الأحجام</header>
                        </div>
                        <div class="card-body" id="bar-parent">
                            <div class="form-horizontal">
                                <div class="form-body">
                                    <div class="form-group row">
                                        <label class="control-label col-sm-2">الإسم بالعربية <span class="required"> * </span></label>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtName" runat="server" class="form-control input-height"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfv1" runat="server" ErrorMessage="الإسم بالعربية مطلوب" ControlToValidate="txtName" ValidationGroup="SizesGroup" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label class="control-label col-sm-2">الإسم بالإنجليزية <span class="required"> * </span></label>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtNameEn" runat="server" class="form-control text-left input-height"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfv2" runat="server" ErrorMessage="الإسم بالإنجليزية مطلوب" ControlToValidate="txtNameEn" ValidationGroup="SizesGroup" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label class="control-label col-sm-2">الإسم بالروسية <span class="required"> * </span></label>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtNameRu" runat="server" class="form-control text-left input-height"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfv3" runat="server" ErrorMessage="الإسم بالروسية مطلوب" ControlToValidate="txtNameRu" ValidationGroup="SizesGroup" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-12 p-t-5 text-center">
                                        <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="SizesGroup"/>
                                        <asp:Button ID="btnCancel" class="btn btn-default" runat="server" Text="الغاء" OnClick="btnCancel_Click" />
                                    </div>

                                    <div class="table-scrollable">
                                        <div class="form-group row m-t-20">
                                            <div class="col-md-5">
                                                <div class="input-group">
                                                    <asp:TextBox ID="txtSearch" runat="server" class="form-control"></asp:TextBox>
                                                    <asp:Button ID="btnSearch" class="btn btn-default" runat="server" Text="بحث" onclick="btnSearch_Click" />
                                                </div>
                                            </div>
                                        </div>

                                        <asp:GridView ID="gvSizes" OnRowCommand="gvSizes_RowCommand" runat="server" AutoGenerateColumns="False" 
                                            AllowPaging="True" PageSize="10" OnPageIndexChanging="gvSizes_PageIndexChanging"
                                            CssClass="table table-striped table-bordered table-hover">
                                            <Columns>
                                                <asp:BoundField HeaderText="الإسم بالعربية" DataField="Name" />
                                                <asp:BoundField HeaderText="الإسم بالإنجليزية" DataField="NameEn" />
                                                <asp:BoundField HeaderText="الإسم بالروسية" DataField="NameRu" />
                                                <asp:TemplateField HeaderText="التحكم">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditSize" CommandArgument='<%#Eval("id") %>' class="btn btn-xs btn-info"><i class="fa fa-pencil"></i></asp:LinkButton>
                                                        <asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteSize" CommandArgument='<%#Eval("id") %>' class="btn btn-xs btn-danger" OnClientClick="return confirm('هل أنت متأكد من الحذف؟');"><i class="fa fa-trash-o"></i></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <div class="row">
                                            <label class="control-label col-md-12">العدد المسجل : <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label></label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>