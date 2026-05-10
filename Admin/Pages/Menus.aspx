<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Menus.aspx.cs" Inherits="Admin_Pages_Menus" Title="القوائم" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" runat="server">
    القوائم
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
         <script type="text/javascript">

            Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(evt, args) {
                $('#<%=cbCategory.ClientID %>').select2();
              

            });
</script>
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
                        <div class="page-title">إدارة القوائم</div>
                    </div>
                    <ol class="breadcrumb page-breadcrumb pull-left">
                        <li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i></li>
                        <li class="active">القوائم</li>
                    </ol>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="card card-box">
                        <div class="card-head">
                            <header>بيانات القوائم</header>
                            <div class="tools">
                                <a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
                                <a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
                                <a class="t-close btn-color fa fa-times" href="javascript:;"></a>
                            </div>
                        </div>

                        <div class="card-body" id="bar-parent">
                            <div class="form-body">

                                <!-- نموذج إضافة / تعديل قائمة -->
                                
                                <div class="form-group row">
										
                                                   	<label class="control-label col-sm-2">التصنيف
													<span class="required" aria-required="true"> * </span>
												</label>
											<div class="col-md-8">
		<asp:DropDownList ID="cbCategory" class="form-control input-height"  AppendDataBoundItems="true" runat="server">
                                                      
                                                        </asp:DropDownList>
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="التصنيف مطلوب" ControlToValidate="cbCategory" InitialValue="0" ValidationGroup="menu" SetFocusOnError="true" Display="Dynamic"  class="help-block"></asp:RequiredFieldValidator>
											</div>
                							
			
                								</div>
                                
                                <div class="form-group row">
                                    <label class="control-label col-sm-2">الإسم بالعربية<span class="required">*</span></label>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorName" runat="server" ControlToValidate="txtName"
                                            ErrorMessage="الإسم بالعربية مطلوب" Display="Dynamic" CssClass="help-block" ValidationGroup="menu"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="control-label col-sm-2">الإسم بالإنجليزية<span class="required">*</span></label>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="txtNameEn" runat="server" CssClass="form-control text-left input-height"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorNameEn" runat="server" ControlToValidate="txtNameEn"
                                            ErrorMessage="الإسم بالإنجليزية مطلوب" Display="Dynamic" CssClass="help-block" ValidationGroup="menu"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="control-label col-sm-2">الإسم بالروسية<span class="required">*</span></label>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="txtNameRu" runat="server" CssClass="form-control text-left input-height"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtNameRu"
                                            ErrorMessage="الإسم بالروسية مطلوب" Display="Dynamic" CssClass="help-block" ValidationGroup="menu"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
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
                                <div class="col-lg-12 p-t-5 text-center">
                                    <asp:Button ID="btnSave" CssClass="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="menu" />
                                    <asp:Button ID="btnCancel" CssClass="btn btn-default" runat="server" Text="الغاء" OnClick="btnCancel_Click" />
                                </div>
                                <div class="form-group row">
                                <label class="control-label col-sm-2">الصورة</label>
                                <div class="col-md-8">
                                    <asp:FileUpload ID="fuPhoto" runat="server" CssClass="form-control" />
                                <asp:HiddenField ID="hfPhotoPath" runat="server" />
                                </div>
                            </div>
                                <!-- البحث وعرض القوائم -->
                                <div class="table-scrollable mt-3">
                                    <div class="form-group row">
                                        <div class="col-md-5">
                                            <div class="input-group">
                                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="بحث..."></asp:TextBox>
                                                <asp:Button ID="btnSearch" runat="server" Text="بحث" CssClass="btn btn-default" OnClick="btnSearch_Click" />
                                            </div>
                                        </div>
                                    </div>

                                    <asp:GridView ID="gvMenus" runat="server" AutoGenerateColumns="False" DataKeyNames="ID"
                                        CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle"
                                        AllowPaging="True" PageSize="10" OnPageIndexChanging="gvMenus_PageIndexChanging"
                                        OnRowCommand="gvMenus_RowCommand" AllowSorting="True">
                                        <Columns>
                                            <asp:BoundField DataField="Name" HeaderText="الإسم بالعربية" />
                                            <asp:BoundField DataField="NameEn" HeaderText="الإسم بالإنجليزية" />
                                            <asp:BoundField DataField="NameRu" HeaderText="الإسم بالروسية" />
                                            <asp:BoundField DataField="CategoryName" HeaderText="التصنيف" />
                                            
                                            <asp:BoundField DataField="Description" HeaderText="الوصف بالعربية" />
                                            <asp:BoundField DataField="DescriptionEn" HeaderText="الوصف بالإنجليزية" />
                                             <asp:BoundField DataField="DescriptionRu" HeaderText="الوصف بالروسية" />
                                            <asp:BoundField DataField="CreatedAt" HeaderText="تاريخ الإنشاء" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                            <asp:TemplateField HeaderText="التحكم">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditMenu" CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-xs btn-info">
                                                        <i class="ace-icon fa fa-pencil bigger-120"></i>
                                                    </asp:LinkButton>
                                                    &nbsp;
                                                    <asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteMenu" CommandArgument='<%# Eval("ID") %>'
                                                        OnClientClick="return confirm('هل أنت متأكد من الحذف؟');" CssClass="btn btn-xs btn-danger">
                                                        <i class="ace-icon fa fa-trash-o bigger-120"></i>
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>

                                    <div class="row mt-2">
                                        <label class="control-label col-md-12">العدد المسجل:
                                            <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label>
                                        </label>
                                    </div>
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
