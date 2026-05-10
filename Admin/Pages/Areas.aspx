<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Areas.aspx.cs" Inherits="Admin_Pages_Areas" Title=" المناطق" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
 المناطق
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
								<div class="page-title"> تسجيل المناطق</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>
								
								<li class="active">تسجيل المناطق</li>
							</ol>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-sm-12">
							<div class="card card-box">
								<div class="card-head">
							
									<header>بيانات المناطق</header>
									
									<div class="tools">
															<a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
															<a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
															<a class="t-close btn-color fa fa-times" href="javascript:;"></a>
														</div>
								</div>
								<div class="card-body" id="bar-parent">
									<form action="#" id="form_sample_1" class="form-horizontal">									 
										   
                                        <div class="form-group row">
                                <label class="control-label col-sm-2">المحافظة<span class="required">*</span></label>
                                <div class="col-md-8">
                                    <asp:DropDownList ID="ddlGov" runat="server" CssClass="form-control input-height" AppendDataBoundItems="true" >
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPlace" runat="server" ControlToValidate="ddlGov"
                                        InitialValue="0" ErrorMessage="المحافظة مطلوبة" Display="Dynamic" CssClass="text-danger"
                                        ValidationGroup="Courses" />
                                </div>
                            </div>
                                        
                                         <div class="form-body">										
			<div class="form-group row">
												<label class="control-label col-sm-2">الإسم بالعربية
													<span class="required" aria-required="true"> * </span>
												</label>
																	<div class="col-md-8">
		                         <asp:TextBox ID="txtName" runat="server"   class="form-control input-height"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="الإسم بالعربية مطلوب" ControlToValidate="txtName" ValidationGroup="Courses" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>

												</div>
												
											</div>
			<div class="form-group row">
												<label class="control-label col-sm-2">الإسم بالإنجليزية
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtNameEn" runat="server"   class="form-control text-left input-height"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="الإسم بالإنجليزية مطلوب" ControlToValidate="txtNameEn" ValidationGroup="Courses" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>

												</div>
												
											</div>
                                             <div class="form-group row">
												<label class="control-label col-sm-2">الإسم بالروسية
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-8">
		                         <asp:TextBox ID="txtNameRu" runat="server"   class="form-control text-left input-height"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="الإسم بالروسية مطلوب" ControlToValidate="txtNameRu" ValidationGroup="Courses" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>

												</div>
												
											</div>
									
											<div class="col-lg-12 p-t-5 text-center">
								                                                <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="Courses"/>
								              <asp:Button ID="btnCancel" class="btn btn-default" runat="server" Text="الغاء" OnClick="btnCancel_Click"  />
											</div>											
														<div class="table-scrollable">
									
																						<div id="example4_wrapper" class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">

<div class="form-group row">
					<div class="col-md-5">	
					<div class="input-group">													
					 <asp:TextBox ID="txtSearch" runat="server"    class="form-control"></asp:TextBox>
                                                     
                                                         <asp:Button ID="btnSearch" 
                            class="btn btn-default" runat="server" Text="بحث" onclick="btnSearch_Click" />

													
												</div>
												</div>
						
					</div>
	
	<div class="row">
	<div class="col-sm-12">
											   <asp:GridView ID="gvAreas"  OnRowCommand="gvAreas_RowCommand"   runat="server" AutoGenerateColumns="False"  PagerSettings-Mode="NumericFirstLast" AllowSorting="true"
          GridLines="None"   OnPageIndexChanging="gvAreas_PageIndexChanging"
                           CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle" 
                AllowPaging="True"  PageSize="5"  >
                 <HeaderStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <RowStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <PagerStyle CssClass="bs4-aspnet-pager" />
                            <Columns>
                                <asp:BoundField HeaderText="الإسم بالعربية" DataField="Name" />
                                <asp:BoundField HeaderText="الإسم بالإنجليزية" DataField="NameEn" />
                                <asp:BoundField HeaderText="الإسم بالروسية" DataField="NameRu" />
                                <asp:BoundField HeaderText="المحافظة" DataField="Gov" />
                               
                                
                                <asp:TemplateField HeaderText="التحكم">
                                    <ItemTemplate>

                                        <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditAreas" 
                        CommandArgument='<%#Eval("ID") %>' class="btn btn-xs btn-info"><i class="ace-icon fa fa-pencil bigger-120"></i></asp:LinkButton>
                                        &nbsp;<asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteAreas"  class="btn btn-xs btn-danger"
                        CommandArgument='<%#Eval("ID") %>' OnClientClick="return confirm('هل أنت متأكد من الحذف?');"> <i class="ace-icon fa fa-trash-o bigger-120"></i></asp:LinkButton>

                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
               </div>
               </div>
               <div class="row">
               <label class="control-label col-md-12">العدد المسجل :
                   <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label>
											</div>
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

