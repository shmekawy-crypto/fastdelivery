<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Setting.aspx.cs" Inherits="Admin_Pages_Setting" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
   إعدادات عامة
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
								<div class="page-title"> إعدادات عامة</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
							
								
								<li class="active">إعدادات عامة</li>
							</ol>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-sm-12">
							<div class="card card-box">
							<div class="card-head">							
									<header>إعدادات عامة</header>
									
									<div class="tools">
															<a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
															<a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
															
														</div>
								</div>
								<div class="card-body" id="bar-parent">
									<form action="#" id="form_sample_1" class="form-horizontal">
										 
										 
										    <div class="form-body">															
										    
                 <div class="form-group row">
                 
                  			
												
                    <label class="control-label col-sm-2">نسبة الخصم
													<span class="required" aria-required="true"> * </span>
												</label>
											<div class="col-md-2">
		                         <asp:TextBox ID="txtPercentage" runat="server"    class="form-control input-height"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="النسبة مطلوب" ControlToValidate="txtPercentage" ValidationGroup="Subject" Display="Dynamic" class="help-block fa fa-warning tooltips"></asp:RequiredFieldValidator>
									          		                  <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtPercentage" class="help-block fa fa-warning tooltips"
                        ValidationGroup="Subject" ValidationExpression="^(?:[1-9]\d*|0)?(?:\.\d+)?$" Display="Dynamic">أرقام موجبة فقط</asp:RegularExpressionValidator>										
				
												</div>														
                 </div>
               	<div class="col-lg-12 p-t-5 text-center">
								                                                <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="Subject"/>
											</div>
               
			</div>
											
									</form>
								</div>
							</div>
						</div>
					</div>		
											
											
						
					</ContentTemplate>
					</asp:UpdatePanel>

</asp:Content>






