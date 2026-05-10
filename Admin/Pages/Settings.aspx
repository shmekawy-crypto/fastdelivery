<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Admin_Pages_Settings" Title="بيانات المركز" ValidateRequest="false"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
 بيانات الموقع
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
			<asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="100" DynamicLayout="true" >
  <ProgressTemplate>
    <div class="update">
    </div>
  </ProgressTemplate>
  </asp:UpdateProgress>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                        <div class="page-bar">
						<div class="page-title-breadcrumb">
							<div class=" pull-right">
								<div class="page-title">بيانات الموقع</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">إدارة الصفحة الرئيسية</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>
								
								<li class="active">بيانات الموقع</li>
							</ol>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-sm-12">
							<div class="card card-box">
								<div class="card-head">
							
									<header>بيانات الموقع</header>
									
									<div class="tools">
															<a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
															<a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
															<a class="t-close btn-color fa fa-times" href="javascript:;"></a>
														</div>
								</div>
								<div class="card-body" id="bar-parent">
										 
										    <div class="form-body">									
										
			<div class="form-group row">
												<label class="control-label col-sm-2">الإسم بالعربية
													<span class="required" aria-required="true"> * </span>
												</label>
																	<div class="col-md-8">
		                         <asp:TextBox ID="txtName" runat="server"   class="form-control input-height"></asp:TextBox>
												</div>
												
											</div>
                                                
                                                <div class="form-group row">
												<label class="control-label col-sm-2">تليفون
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtPhone" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
									<div class="form-group row">
												<label class="control-label col-sm-2">موبايل
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtMobile" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">فاكس
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtFax" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">البريد الإلكترونى
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtEmail" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">صندوق البريد
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtMailBox" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">العنوان
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtAddress" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">خريطة الوصول
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtmap" runat="server"    class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">رابط فيس بوك
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtFace" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">رابط يوتيوب
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtYouTube" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">رابط تويتر
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtTwitter" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">رابط جوجل بلس
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtGooglePlus" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">رابط لينكيد إن
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtLinkedIn" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
                                                <div class="form-group row">
												<label class="control-label col-sm-2">رابط إنستجرام
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtInstgram" runat="server"   class="form-control text-left input-height"></asp:TextBox>

												</div>
												
											</div>
											<div class="col-lg-12 p-t-5 text-center">
								                                                <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidateRequestMode="Disabled" />

											</div>
											</div>
								
								</div>
							</div>
						</div>
					</div>													
					        </label>
									                            
					</ContentTemplate>
					</asp:UpdatePanel>
                         

</asp:Content>

