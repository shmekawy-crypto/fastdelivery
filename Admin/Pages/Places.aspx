<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Places.aspx.cs" Inherits="Admin_Pages_Places" Title="الأماكن" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">الأماكن 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">        

     <script type="text/javascript">

            Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(evt, args) {
                $('#<%= ddlGov.ClientID %>').select2({<a href="Places.aspx">Places.aspx</a>
        width: '100%',
               });
                       $('#<%= ddlArea.ClientID %>').select2({
        width: '100%',
    });               
                $('#datepicker').datetimepicker({
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0,
                    format: "dd-mm-yyyy"
                });
                $('#datepicker1').datetimepicker({
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0,
                    format: "dd-mm-yyyy"
                });
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
<asp:UpdatePanel ID="UpdatePanel1" runat="server"  UpdateMode="Conditional">
                        <ContentTemplate>
        
	<script type="text/javascript">

	    
$(function () {
    $("[id*=ContentPlaceHolder1_gvPlaces]").sortable({
        items: 'tr:not(tr:first-child)',
        cursor: 'pointer',
        axis: 'y',
        dropOnEmpty: false,
        start: function (e, ui) {
            ui.item.addClass("selected");
        },
        stop: function (e, ui) {
            ui.item.removeClass("selected");
        },
        receive: function (e, ui) {
            $(this).find("tbody").append(ui.item);
        }
    });
});

function ShowPopup(title) {
    $("#MyPopup .modal-title").html(title);
    $("#MyPopup").modal("show");
}
$('body').on('shown.bs.modal', '#MyPopup', function () {
    $('input:visible:enabled:first', this).focus();
})
function ShowPopup2(title) {
    $("#MyPopup2 .modal-title").html(title);
    $("#MyPopup2").modal("show");
}
$('body').on('shown.bs.modal', '#MyPopup2', function () {
    $('input:visible:enabled:first', this).focus();
})
        <%--function ShowImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%=ImgPrv.ClientID%>').prop('src', e.target.result)
                       
                };
                reader.readAsDataURL(input.files[0]);
                }
        }--%>
	 
 </script>		
              
                                            <div class="page-bar">
						<div class="page-title-breadcrumb">
							<div class=" pull-right">
								<div class="page-title"> الأماكن
</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">الأماكن</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>
								
								<li class="active"> الأماكن</li>
							</ol>
						</div>
					</div>
                            <div class="row">
                           <div class="col-md-12 col-sm-12">
                               	<div class="card card-box">
                                       <div class="card-head">							
									<header>بحث</header>
									
									<div class="tools">
															<a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
															<a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
															<a class="t-close btn-color fa fa-times" href="javascript:;"></a>
														</div>
								</div>
                                       <div class="card-body" id="bar-parent"> 
                                            <div class="form-body">
                                    		 <div class="col-md-12 col-sm-12 col-12">
                                               <div class="form-group row">
										<label class="control-label col-sm-1">التصنيف
													<span class="required" aria-required="true"> * </span>
												</label>
                                                   <div class="col-md-3">
		<asp:DropDownList ID="cbCategory" class="form-control input-height"  AppendDataBoundItems="true" runat="server" OnSelectedIndexChanged="cbCategory_SelectedIndexChanged" AutoPostBack="true">
                                                        <asp:ListItem Value="0">..إختر التصنيف..</asp:ListItem>
                                                        </asp:DropDownList>
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ErrorMessage="التصنيف مطلوب" ControlToValidate="cbCategory" InitialValue="0" ValidationGroup="Subject" SetFocusOnError="true" Display="Dynamic"  class="help-block"></asp:RequiredFieldValidator>
											</div>

                                                 			
			
                								</div>
                                        
                                                
                                    </div>
                                           </div>
                                   
                                       </div>
                               </div>  
                             </div>   
                       </div>
					<div class="row">
						<div class="col-md-12 col-sm-12">
							<div class="card card-box">
								<div class="card-head">
							
									<header>بيانات  الأماكن</header>
									
									<div class="tools">
															<a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
															<a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
															<a class="t-close btn-color fa fa-times" href="javascript:;"></a>
														</div>
								</div>
								<div class="card-body" id="bar-parent">
										 <div class="col-md-12 col-sm-12 col-12">
								
						<div class="col-md-12 text-left ">
                                    <asp:LinkButton ID="btnNew" class="btn btn-info" runat="server" OnClick="btnnew_Click"
                                        >إضافة<i class="fa fa-plus"></i></asp:LinkButton>
																	
																</div>		
                                    	<form action="#" id="form_sample_1" class="form-horizontal">
								
										 
										    <div class="form-body">
												
										
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
					</div>
	
	<div class="row">
	<div class="col-sm-12">
											   <asp:GridView ID="gvPlaces"  OnRowCommand="gvPlaces_RowCommand"   runat="server" AutoGenerateColumns="False"  PagerSettings-Mode="NumericFirstLast" AllowSorting="True"
          GridLines="None"   OnPageIndexChanging="gvPlaces_PageIndexChanging"
                           CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle" 
                AllowPaging="True"  PageSize="5"  >
                 <HeaderStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <RowStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
                                                   <PagerSettings Mode="NumericFirstLast" />
    <PagerStyle CssClass="bs4-aspnet-pager" />
                            <Columns>
                                 <asp:TemplateField>
                                    <ItemTemplate>
                            <asp:Image class="d-block w-100" ID="Image2" ImageUrl='<%# "~/ar/" + Eval("PhotoPath") %>'  runat="server" CssClass="img-circle" Height="60" Width="60"/>
                                       
                                         </ItemTemplate>
                                     </asp:TemplateField>
                                <asp:TemplateField HeaderText="Id" ItemStyle-Width="30" Visible="false">
        <ItemTemplate>
            <%# Eval("Id") %>
            <input type="hidden" name="LocationId" value='<%# Eval("Id") %>' />
        </ItemTemplate>
    </asp:TemplateField>
                                <asp:BoundField HeaderText="الإسم بالعربية" DataField="Name" />
                                <asp:BoundField HeaderText="الإسم بالإنجليزية" DataField="NameEn" />
                                <asp:BoundField HeaderText="الإسم بالروسية" DataField="NameRu" />
                                <asp:BoundField HeaderText="المحافظة" DataField="Gov" />
                                <asp:BoundField HeaderText="المنطقة" DataField="Area" />
                                 <asp:BoundField HeaderText="العنوان" DataField="Address" />
                                 <asp:BoundField HeaderText="الوصف بالعربية" DataField="Description" />
                                <asp:BoundField HeaderText="الوصف بالإنجليزية" DataField="DescriptionEn" />
                                 <asp:BoundField HeaderText="الوصف بالروسية" DataField="DescriptionRu" />
                                 <asp:BoundField HeaderText="وقت التوصيل" DataField="DeliveredTime" />
                                 <asp:BoundField HeaderText="الحد الأدنى للطلب" DataField="MinOrder" />
                                 <asp:BoundField HeaderText="التصنيف" DataField="Category" />
                                <asp:BoundField HeaderText="التقييم" DataField="Rate" />
                                <asp:BoundField HeaderText="الترتيب" DataField="POrder" SortExpression="POrder" />

                                       <asp:TemplateField HeaderText="نشط">
            <EditItemTemplate>
                <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>'  />
            </EditItemTemplate>
            <ItemTemplate>
                           <asp:HiddenField ID="hf" Value='<%# Bind("id") %>'  runat="server"/>
		        <label class="switchToggle">
                                                     <asp:CheckBox ID="CheckBox2"  runat="server" Checked='<%# Bind("Active") %>'   AutoPostBack="true"  OnCheckedChanged="CheckBox1_CheckedChanged" />
                                                                      <span class="slider green round"></span>
                                            </label>

            </ItemTemplate>
        </asp:TemplateField>
                                <asp:TemplateField HeaderText="التحكم">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDetails" runat="server" CommandName="ViewDetails" 
                        CommandArgument='<%#Eval("ID") %>' class="btn btn-xs btn-success"><i class="fa fa-list-ul"></i></asp:LinkButton>
                                        <asp:LinkButton ID="lbschadual" runat="server" CommandName="schadual" 
                        CommandArgument='<%#Eval("ID") %>' class="btn btn-xs btn-success"><i class="fa fa-calendar"></i></asp:LinkButton>

                                        <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditPlaces" 
                        CommandArgument='<%#Eval("ID") %>' class="btn btn-xs btn-info"><i class="ace-icon fa fa-pencil bigger-120"></i></asp:LinkButton>
                                        &nbsp;<asp:LinkButton ID="lbDelete" runat="server" CommandName="DeletePlaces"  class="btn btn-xs btn-danger"
                        CommandArgument='<%#Eval("ID") %>' OnClientClick="return confirm('هل أنت متأكد من الحذف?');"> <i class="ace-icon fa fa-trash-o bigger-120"></i></asp:LinkButton>
                                        <asp:LinkButton ID="lbMapTypes" runat="server" CommandName="MapTypes" 
    CommandArgument='<%#Eval("ID") %>' class="btn btn-xs btn-warning">
    <i class="fa fa-tags"></i>
</asp:LinkButton>
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
               
											<div id="MyPopup2" class="modal fade" role="dialog" style="height:100%">
    <div class="modal-dialog" style="height:100%">
        <!-- Modal content-->
        <div class="modal-content" style="min-height: 100%;">
            <div class="modal-header">
                <asp:Button Text="X"  runat="server" id="Button2" OnClick="btnClose_Click" class="btn btn-danger" data-dismiss="modal" />
               
                <h4 class="modal-title">
                </h4>
            </div>
            <div class="modal-body">
                   <asp:Literal ID="ltcontent" runat="server"></asp:Literal>

                
            </div>
            <div class="modal-footer">            
                <asp:Button Text="إغلاق" runat="server" id="Button1" OnClick="btnClose_Click" class="btn btn-danger" />
                   
            </div>
        </div>
    </div>
</div>
						<div id="MyPopup" class="modal fade" role="dialog" style="height:auto">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    &times;</button>
                <h4 class="modal-title">
                </h4>
            </div>
            <div class="modal-body">   
                                <div class="form-group col-md-12">
            <div class="row">
                <div class="form-group  col-md-6">	
                                                   	<label class="pull-right">التصنيف
													<span class="required" aria-required="true"> * </span>
												</label>
											
		<asp:DropDownList ID="cbCategory2" class="form-control input-height"  AppendDataBoundItems="true" runat="server">
                                                        <asp:ListItem Value="0">..إختر التصنيف..</asp:ListItem>
                                                        </asp:DropDownList>
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="التصنيف مطلوب" ControlToValidate="cbCategory2" InitialValue="0" ValidationGroup="Courses" SetFocusOnError="true" Display="Dynamic"  class="help-block"></asp:RequiredFieldValidator>
											
                    </div>
                  			
			
                								</div>
                    </div>
                
                <div class="form-group col-md-12">
            <div class="row">
                <div class="form-group  col-md-6">	
                                                   	<label class="pull-right">المحافظة
													<span class="required" aria-required="true"> * </span>
												</label>
											
		<asp:DropDownList ID="ddlGov" class="form-control input-height"  AppendDataBoundItems="true" runat="server" OnSelectedIndexChanged="ddlGov_SelectedIndexChanged" AutoPostBack="true">
                                                        <asp:ListItem Value="0">..إختر المحافظة..</asp:ListItem>
                                                        </asp:DropDownList>
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="المحافظة مطلوب" ControlToValidate="ddlGov" InitialValue="0" ValidationGroup="Courses" SetFocusOnError="true" Display="Dynamic"  class="help-block"></asp:RequiredFieldValidator>
											
                    </div>
                  			<div class="form-group  col-md-6">	
                                                   	<label class="pull-right">المنطقة
													<span class="required" aria-required="true"> * </span>
												</label>
											
		<asp:DropDownList ID="ddlArea" class="form-control input-height"  AppendDataBoundItems="true" runat="server">
                                                        <asp:ListItem Value="0">..إختر المنطقة..</asp:ListItem>
                                                        </asp:DropDownList>
                                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="المنطقة مطلوب" ControlToValidate="ddlArea" InitialValue="0" ValidationGroup="Courses" SetFocusOnError="true" Display="Dynamic"  class="help-block"></asp:RequiredFieldValidator>
											
                    </div>
			
                								</div>
                    </div>        
                <div class="form-group col-md-12">
            <div class="row">
                <label>(120x120) صورة المكان													<span class="required" aria-required="true"> * </span>
												</label>
                  <asp:Image ID="Image2" runat="server" Width="100%" Height="120" class="text-right" />
		              <cc1:AsyncFileUpload ID="fileInput" runat="server" ClientIDMode="AutoID" class="form-control" Width="100%"  OnUploadedComplete="fileInput_UploadedComplete"/>
 

                </div>
                    </div>        
                    
		<div class="form-group col-md-12">
            <div class="row">
				<div class="form-group  col-md-4">						
            	<label class="pull-right">اسم المكان بالعربية
													<span class="required" aria-required="true"> * </span>
												</label>
											
		                         <asp:TextBox ID="txtName" runat="server"  TextMode="MultiLine" Rows="3"   class="form-control"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="الإسم بالعربية مطلوب" ControlToValidate="txtName" ValidationGroup="Courses" Display="Dynamic" class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RequiredFieldValidator>

									</div>
            			
					<div class="col-md-4">
                			<label class="pull-right">اسم المكان بالإنجليزية
													<span class="required" aria-required="true"> * </span>
												</label>
		                         <asp:TextBox ID="txtNameEn" TextMode="MultiLine" runat="server" Rows="3" dir="ltr"    class="form-control"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="الإسم بالإنجليزية مطلوب" ControlToValidate="txtNameEn" ValidationGroup="Courses" Display="Dynamic" class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RequiredFieldValidator>

												          			
                								</div>

                <div class="col-md-4">
                			<label class="pull-right">اسم المكان بالروسية
													<span class="required" aria-required="true"> * </span>
												</label>
		                         <asp:TextBox ID="txtNameRu" TextMode="MultiLine" runat="server" Rows="3" dir="ltr"    class="form-control"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="الإسم بالروسية مطلوب" ControlToValidate="txtNameRu" ValidationGroup="Courses" Display="Dynamic" class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RequiredFieldValidator>

												          			
                								</div>
		</div>
            </div>

                <div class="form-group col-md-12">
            <div class="row">
				<div class="form-group  col-md-4">						
            	<label class="pull-right">الوصف بالعربية
													<span class="required" aria-required="true"> * </span>
												</label>
											
		                         <asp:TextBox ID="txtDescription" runat="server"  TextMode="MultiLine" Rows="3"   class="form-control"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ErrorMessage="الوصف بالعربية مطلوب" ControlToValidate="txtDescription" ValidationGroup="Courses" Display="Dynamic" class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RequiredFieldValidator>

									</div>
            			<div class="form-group  col-md-4">						
            	<label class="pull-right">الوصف بالإنجليزية
													<span class="required" aria-required="true"> * </span>
												</label>
											
		                         <asp:TextBox ID="txtDescriptionEn" runat="server"  TextMode="MultiLine" Rows="3"   class="form-control"></asp:TextBox>
									</div>
                <div class="form-group  col-md-4">						
            	<label class="pull-right">الوصف بالروسية
													<span class="required" aria-required="true"> * </span>
												</label>
											
		                         <asp:TextBox ID="txtDescriptionRu" runat="server"  TextMode="MultiLine" Rows="3"   class="form-control"></asp:TextBox>
									</div>
					
		</div>
            </div>
                
                
                  <div class="form-group col-md-12">
            <div class="row">
                <div class="col-md-12">
                			<label class="pull-right">العنوان
													<span class="required" aria-required="true"> * </span>
												</label>
		                         <asp:TextBox ID="txtAddress" TextMode="MultiLine" runat="server" Rows="3" dir="ltr"    class="form-control"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ErrorMessage="العنوان مطلوب" ControlToValidate="txtNameEn" ValidationGroup="Courses" Display="Dynamic" class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RequiredFieldValidator>

												          			
                								</div>
                </div>
                      </div>
                <div class="col-md-12 form-group">
	 <div class="row">
		 		<div class="col-md-3">
<label class="pull-right"> الحد الأدنى للطلب   </label>	
				                                      <asp:TextBox ID="txtMinOrder"  Text="0" runat="server"  class="form-control"></asp:TextBox>	
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="الحد الأدنى  مطلوب" ControlToValidate="txtMinOrder" ValidationGroup="Courses" Display="Dynamic"  class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RequiredFieldValidator>
                     <asp:RegularExpressionValidator ID="RegularExpressionValidator2" ValidationExpression="^(?!0*\.0+$)\d*(?:\.\d+)?$" runat="server" ControlToValidate="txtMinOrder" ErrorMessage="الحد الأدنى غير صحيح" ValidationGroup="Courses" Display="Dynamic" class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RegularExpressionValidator>

 </div>	
		 		<div class="col-md-3">
<label class="pull-right">  وقت التوصيل   </label>	
				                         <asp:TextBox ID="txtDeliveredTime" runat="server"  class="form-control"></asp:TextBox>
                                                   <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="وقت التوصيل مطلوب" ControlToValidate="txtDeliveredTime" ValidationGroup="Courses" Display="Dynamic" class="help-block fa fa-warning tooltips" SetFocusOnError="true"></asp:RequiredFieldValidator>

 </div>	
         <div class="col-md-1">
    <label class="pull-right">الترتيب</label>	
    <asp:TextBox ID="txtPOrder" Text="0" runat="server" class="form-control"></asp:TextBox>	
    <asp:RegularExpressionValidator ID="revPOrder" runat="server" 
        ControlToValidate="txtPOrder" ErrorMessage="أرقام فقط" 
        ValidationExpression="^\d+$" ValidationGroup="Courses" 
        Display="Dynamic" ForeColor="Red"></asp:RegularExpressionValidator>
</div>
          		<div class="col-md-3">
<label class="pull-right">  التقييم   </label>	
				                    <asp:DropDownList ID="ddlrate" class="form-control input-height"  AppendDataBoundItems="true" runat="server">
                                                        <asp:ListItem Value="0">0</asp:ListItem>
                                        <asp:ListItem Value="1">1</asp:ListItem>
                                        <asp:ListItem Value="2">2</asp:ListItem>
                                        <asp:ListItem Value="3">3</asp:ListItem>
                                        <asp:ListItem Value="4">4</asp:ListItem>
                                        <asp:ListItem Value="5">5</asp:ListItem>
                                                        </asp:DropDownList>
										
 </div>	
         <div class="col-md-2">
	<label>مكان نشط</label>
          
               					        <label class="switchToggle">
                                                     <asp:CheckBox ID="cbActive" runat="server" Checked="true" />
                                                <span class="slider green round"></span>
                                            </label>
          <div>
              
  
</div>

        
        </div>
	 
</div>		
</div>
                
                        <div class="form-group col-md-12">
    <div class="row">
        <div class="col-md-12">
            <label class="pull-right">(800x200) صورة البانر (Banner)</label>
            <asp:Image ID="imgBanner" runat="server" Width="100%" Height="100" class="text-right" />
            <cc1:AsyncFileUpload ID="fileBanner" runat="server" ClientIDMode="AutoID" OnUploadedComplete="fileBanner_UploadedComplete" />
        </div>
    </div>
</div>

<div class="form-group col-md-12">
    <div class="row">
        <div class="col-md-6">
            <label class="pull-right">اسم المستخدم (UserName)</label>
            <asp:TextBox ID="txtUserName" runat="server" class="form-control"></asp:TextBox>
        </div>
        <div class="col-md-6">
            <label class="pull-right">كلمة المرور (Pass)</label>
            <asp:TextBox ID="txtPass" runat="server" class="form-control" TextMode="SingleLine"></asp:TextBox>
        </div>
    </div>
</div>        
                
                

                  
        <div class="col-lg-12 p-t-5 text-center">
								                                                <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="Courses"/>
											</div>                			
            </div>
            <div class="modal-footer">
            
                <asp:Button Text="إغلاق" id="btnClose" runat="server" onclick="btnClose_Click" class="btn btn-danger" />
            </div>
        </div>
    </div>
</div>										
					    </label>
					</ContentTemplate>
    <Triggers>
		</Triggers>		
        	</asp:UpdatePanel>
                         
    
</asp:Content>

