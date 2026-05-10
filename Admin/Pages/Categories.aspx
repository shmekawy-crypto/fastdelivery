<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Categories.aspx.cs" Inherits="Categories" Title="التصنيفات" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
Front End Category
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
     	padding:0 0 0 0 px;
     	border-collapse:collapse;
     	line-height:0.5em
     	}
   
     .bs4-aspnet-pager td
     {
     	background-color:White;
     	border: none;
     	border-collapse:collapse;
     	border-collapse:collapse;
     	line-height:0.5em
     	} 
     .bs4-aspnet-pager td table
     {
     	background-color:White;
     	border: none;
     	border-collapse:collapse;
     	border-collapse:collapse;
     	line-height:0.5em
     	}
.bs4-aspnet-pager table td, .bs4-aspnet-pager table th, .card .bs4-aspnet-pager table td, .card .bs4-aspnet-pager table th, .card .dataTable td, .card .dataTable th {
    padding: 0px 5px;
    vertical-align: middle;
}       
   .bs4-aspnet-pager a,
.bs4-aspnet-pager span {
position: relative;
float: right;
padding: 6px 12px;
margin-right: -1px;
line-height: 1.42857143;
color: ##007bff;
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

.bs4-aspnet-pager tr > td:first-child > a,
.bs4-aspnet-pager tr > td:first-child > span {
margin-right: 0;
}

.bs4-aspnet-pager a:hover,
.bs4-aspnet-pager span:hover,
.bs4-aspnet-pager a:focus,
.bs4-aspnet-pager span:focus 
{
z-index: 2;
color: #23527c;
border-color: Red;

}


.bs4-aspnet-pager td {
padding: 0;
}


   </style>
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
							<div class=" pull-left">
								<div class="page-title">التصنيفات</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-right">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">main</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>
								
								<li class="active">التصنيفات</li>
							</ol>
						</div>
					</div>
<div class="row">
						<div class="col-md-12 col-sm-12">
							<div class="card card-box">
								<div class="card-head">
							
									<header>التصنيفات</header>
									
									<div class="tools">
															<a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
															<a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
															<a class="t-close btn-color fa fa-times" href="javascript:;"></a>
														</div>
								</div>
								<div class="card-body" id="bar-parent">
									<form action="#" id="form_sample_1" class="form-horizontal">
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
                <div class="form-group row">
											
												<label class="control-label col-sm-2">,وصف بالعربية
													<span class="required" aria-required="true"> * </span>
												</label>
														<div class="col-md-7">
			 <asp:TextBox ID="txtDescription" runat="server"  TextMode="MultiLine"  class="form-control input-height"></asp:TextBox>
                                                   
                                
												</div>
												</div>
                                            <div class="form-group row">
											
												<label class="control-label col-sm-2">وصف  بالإنجليزية
													<span class="required" aria-required="true"> * </span>
												</label>
														<div class="col-md-7">
			 <asp:TextBox ID="txtDescriptionEn" runat="server"  TextMode="MultiLine"  class="form-control input-height"></asp:TextBox>
                                                   
                                
												</div>
												</div>
                                            <div class="form-group row">
											
												<label class="control-label col-sm-2">وصف  بالروسية
													<span class="required" aria-required="true"> * </span>
												</label>
														<div class="col-md-7">
			 <asp:TextBox ID="txtDescriptionRu" runat="server"  TextMode="MultiLine"  class="form-control input-height"></asp:TextBox>
                                                   
                                
												</div>
												</div>
		
<div class="form-group row">
											
												<label class="control-label col-md-2">إختار صورة (1920x600)
													<span class="required" aria-required="true"> * </span>
												</label>
														<div class="col-md-4">
			
			
                                                            <asp:FileUpload ID="fuphoto" runat="server" />
                                      
                                      <asp:RequiredFieldValidator ID="rvImage" runat="server" ErrorMessage="Required" ControlToValidate="fuphoto"  ValidationGroup="Category" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>

												</div>
												<div class="col-md-6">
                                                    <asp:Image ID="Image1" runat="server" Width="100" Height="100" />
												</div>
												</div>
		
<div class="form-group row">
<label class="control-label col-sm-2">نشط
													<span class="required" aria-required="true"> * </span>
												</label>
												
												
												        <div class="col-md-7 text-right">
												        
												        <label class="switchToggle">
                                                     <asp:CheckBox ID="cbActive" runat="server"   Checked="false" />
                                                <span class="slider green round"></span>
                                            </label>
                                            
												        
       
           </div>
             
             </div>		
<div class="form-group row">
<label class="control-label col-sm-2">الترتيب
													<span class="required" aria-required="true"> * </span>
												</label>
												
												
												        <div class="col-md-7">
												        
											
                                                    <asp:TextBox ID="txtOrder" runat="server"  data-mask="9"  class="form-control input-height col-2"></asp:TextBox>
                                            
												        
       
           </div>
             
             </div>           												
<div class="col-lg-12 p-t-20 text-center">
								                                                <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="Category"/>

								              <asp:Button ID="btnCancel" class="btn btn-default" runat="server" Text="الغاء" OnClick="btnCancel_Click"  />

											</div>											
								</div>			
											
											<div class="table-scrollable">
										
																						<div id="example4_wrapper" class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">

		<asp:GridView ID="gvCategory"  OnPreRender="GridView_PreRender"  runat="server" AutoGenerateColumns="False"  
                                                                                                PagerSettings-Mode="NumericFirstLast" AllowSorting="true"
        onrowcommand="gvCategory_RowCommand"  GridLines="None"  
                           CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle" 
                AllowPaging="True" onpageindexchanging="gvCategory_PageIndexChanging" PageSize="5"   >
                 <HeaderStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <RowStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <PagerStyle CssClass="bs4-aspnet-pager" />
                            <Columns>
                                    <asp:TemplateField HeaderText="م">
                                    <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    </asp:TemplateField>
                                <asp:BoundField HeaderText="الإسم" DataField="Name"  />
                                <asp:BoundField HeaderText="الإسم بالإنجليزية" DataField="NameEn"  />
                                <asp:BoundField HeaderText="الإسم بالروسية" DataField="NameRu"  />
                                 <asp:BoundField HeaderText="الوصف" DataField="DescrAr"  />
                                <asp:BoundField HeaderText="الوصف بالإنجليزية" DataField="DescrEn"  />
                                <asp:BoundField HeaderText="الوصف بالروسية" DataField="DescrRu"  />
                                  <asp:TemplateField HeaderText="الصورة">
                                    <ItemTemplate>
                                        <asp:Image ID="Image2" runat="server" ImageUrl='<%# "~/ar/" + Eval("PhotoPath") %>' width="400" height="200" />
                                    
                                    </ItemTemplate>
                                    </asp:TemplateField>
                                       
                                       <asp:CheckBoxField HeaderText="الحالة" DataField="Active"  ItemStyle-Wrap="false"  />
                          
                                 <asp:BoundField HeaderText="الترتيب" DataField="Corder"  ItemStyle-Wrap="false"  />
                          <asp:TemplateField HeaderText="الإجراءات">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditCategory" 
                        CommandArgument='<%#Eval("ID") %>' class="btn btn-xs btn-info"><i class="ace-icon fa fa-pencil bigger-120"></i></asp:LinkButton>
                                        &nbsp;<asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteCategory"  class="btn btn-xs btn-danger"
                        CommandArgument='<%#Eval("ID") %>' OnClientClick="return confirm('هل أنت متأكد من الحذف?');"> <i class="ace-icon fa fa-trash-o bigger-120"></i></asp:LinkButton>

                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
               
											</div>
								<div class="row">

<div class="col-sm-6 col-md-6">

<label class="control-label">العدد المسجل :</label>
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
<Triggers> 
<asp:PostBackTrigger ControlID="btnSave" />
</Triggers>
</asp:UpdatePanel>
</asp:Content>