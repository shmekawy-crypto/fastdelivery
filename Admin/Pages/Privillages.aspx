<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Privillages.aspx.cs" Inherits="Admin_Pages_Privillages" Title="صلاحيات المستخدمين" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
    صلاحيات المستخدمين
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      
 
      <script type="text/javascript">
    
         Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(evt, args) {
            $('#<%=cbPage.ClientID %>').select2();
            });
   </script>
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
							<div class=" pull-right">
								<div class="page-title"> إضافة المستخدمين</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>
								
								<li class="active"> صلاحيات المستخدمين</li>
							</ol>
						</div>
					</div>
<div class="row">
						<div class="col-md-12 col-sm-12">
							<div class="card card-box">
								<div class="card-head">
							
									<header>بيانات صلاحيات المستخدمين</header>
									
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
												<label class="control-label col-2">الرتبة
													<span class="required" aria-required="true"> * </span>
												</label>
												<div class="col-md-4">
                                                						                        			<asp:DropDownList ID="ddlRoles" class="form-control input-height"  AppendDataBoundItems="true"
                                                            runat="server" AutoPostBack="True" onselectedindexchanged="ddlUsers_SelectedIndexChanged">
                                                        <asp:ListItem Value="0">..إختر..</asp:ListItem>
                                                        </asp:DropDownList>
                                      <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="الرتبة" ControlToValidate="ddlRoles" InitialValue="0" ValidationGroup="Users" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
										
												</div>
												
									
												
											</div>
									
											
											
											<div class="form-group row">
																	
	<label class="control-label col-md-2">الصفحة
													
												</label>
	<div class="col-md-4">													
																                        			<asp:DropDownList ID="cbPage" class="form-control input-height"  AppendDataBoundItems="true"
                                                            runat="server">
                                                        <asp:ListItem Value="0">..إختر..</asp:ListItem>
                                                        </asp:DropDownList>
                                      <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="صفحة الدخول مطلوبة" ControlToValidate="cbPage" InitialValue="0" ValidationGroup="Users" Display="Dynamic" class="help-block"></asp:RequiredFieldValidator>
												
												</div>
									
										</div>
											<div class="form-group row">
											<div class="col-md-4">
											  <label class="control-label col-md-2">
                                                                                        إطلاع فقط
                                                                                        </label>
                                                                                        <label class="control-label col-sm-2 text-right">
														        <label class="switchToggle">
                                                     <asp:CheckBox ID="cbR" runat="server" />
                                                <span class="slider green round"></span>
                                            </label>
                                            </label>
                                            </div>
                                            <div class="col-md-4">
                                            <label class="control-label col-2">تحكم كامل
													<span class="required" aria-required="true"> * </span>
												</label>
												<label class="control-label col-sm-2 text-right">
                                            			        <label class="switchToggle">
                                                     <asp:CheckBox ID="cbW" runat="server" />
                                                <span class="slider green round"></span>
                                            </label>
                                            </label>
                                            </div>
											</div>
												<div class="form-group row">
												
									
									
											</div>
											<div class="col-lg-12 p-t-20 text-center">
								                                                <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="Users"/>
								              <asp:Button ID="btnCancel" class="btn btn-default" runat="server" Text="الغاء" OnClick="btnCancel_Click"  />

											</div>
											
									<div class="table-scrollable">
							<div id="example4_wrapper" class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">
	
	<div class="row">
	<div class="col-sm-12">
											   <asp:GridView ID="gvPrivilage"  OnPreRender="GridView_PreRender"  runat="server" AutoGenerateColumns="False"  PagerSettings-Mode="NumericFirstLast" AllowSorting="true"
        onrowcommand="gvPrivilage_RowCommand"  GridLines="None"  
                           CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle" 
                AllowPaging="True" onpageindexchanging="gvPrivilage_PageIndexChanging" PageSize="5"  >
                 <HeaderStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <RowStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <PagerStyle CssClass="bs4-aspnet-pager" />
                            <Columns>
                                <asp:BoundField HeaderText="الصفحة" DataField="Name" />
                                <asp:CheckBoxField HeaderText="إطلاع فقط" DataField="R" />                                
                                <asp:CheckBoxField HeaderText="تحكم كامل" DataField="W" />   
                                <asp:TemplateField HeaderText="التحكم">
                                    <ItemTemplate>

                                        <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditUsers" 
                        CommandArgument='<%#Eval("ID") %>' class="btn btn-xs btn-info"><i class="ace-icon fa fa-pencil bigger-120"></i></asp:LinkButton>
                                        &nbsp;<asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteUsers"  class="btn btn-xs btn-danger"
                        CommandArgument='<%#Eval("ID") %>' OnClientClick="return confirm('هل أنت متأكد من الحذف?');">					<i class="ace-icon fa fa-trash-o bigger-120"></i></asp:LinkButton>

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

