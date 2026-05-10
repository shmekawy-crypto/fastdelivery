<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="Pages_ChangePassword" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <link href="../css/Form.css" rel="stylesheet" type="text/css" />
    
<div class="form" dir="rtl" style="font:12px/1.8em tahoma,Arial,Helvetica,sans-serif">
  
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <div class="page-bar">
						<div class="page-title-breadcrumb">
							<div class=" pull-right">
								<div class="page-title"> تغيير كلمة المرور</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>
								
								<li class="active">تغيير كلمة المرور</li>
							</ol>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-sm-12">
							<div class="card card-box">
								<div class="card-head">
							
									<header>تغيير كلمة المرور</header>
									
								</div>
								
								<div class="card-body" id="bar-parent">
							<div class="form-group row">
												<label class="control-label col-sm-2">كلمة المرور القديمة
													<span class="required" aria-required="true"> * </span>
												</label>
																	<div class="col-md-8">
		                         <asp:TextBox ID="txtOldPass" runat="server" TextMode="Password"   class="form-control input-height center"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="كلمة المرور مطلوبة" ControlToValidate="txtOldPass"  Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
												</div>												
											</div>
							<div class="form-group row">
												<label class="control-label col-sm-2">كلمة المرور الجديدة
													<span class="required" aria-required="true"> * </span>
												</label>
																	<div class="col-md-8">
		                         <asp:TextBox ID="txtNewPass" runat="server" TextMode="Password"   class="form-control input-height center"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="كلمة المرور الجديدة مطلوبة" ControlToValidate="txtNewPass"  Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
												</div>												
											</div>
								
								<div class="form-group row">
												<label class="control-label col-sm-2">إعادة كلمة المرور
													<span class="required" aria-required="true"> * </span>
												</label>
																	<div class="col-md-8">
		                         <asp:TextBox ID="txtConfirmNewPass" runat="server" TextMode="Password"   class="form-control input-height center"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="إعادة كلمة المرور مطلوبة" ControlToValidate="txtConfirmNewPass"  Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
											                                             <asp:CompareValidator ID="CompareValidator2" runat="server" 
                                                 ErrorMessage="CompareValidator" ControlToCompare="txtNewPass" 
                                                 ControlToValidate="txtConfirmNewPass" Display="Dynamic" class="help-block">كلمة المرور غير متطابقة</asp:CompareValidator>

    </p>
												</div>												
											</div>
								<div class="col-lg-12 p-t-5 text-center">
								                                                <asp:Button ID="btnChangePassword" class="btn btn-info m-r-20" runat="server" Text="تغيير كلمة المرور" OnClick="btnChangePassword_Click"/>
											</div>
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
</div>
</asp:Content>

