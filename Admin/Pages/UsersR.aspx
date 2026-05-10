<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="UsersR.aspx.cs" Inherits="Admin_Pages_UsersR" Title="المستخدمين المسجلين" EnableEventValidation="false" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
    المستخدمين المسجلين
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <link href="../css/Form.css" rel="stylesheet" type="text/css" />
    <link href="../../css/DEMO2.CSS" rel="stylesheet" type="text/css" />
   <style>
        .update
        {
            position: fixed;
            top: 0px;
            left: 0px;
            min-height: 100%;
            min-width: 100%;
            background-image: url("../../Images/loader.gif");
            background-position: center center;
            background-repeat: no-repeat;
            z-index: 500 !important;
            overflow: hidden;
        }
   </style>
   
   
       <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="100" DynamicLayout="true">
        <ProgressTemplate>
            <div class="update">
            </div>
        </ProgressTemplate>
        </asp:UpdateProgress>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    	<script type="text/javascript">
	    var modal_scrollTop = $('.modal-body').scrollTop();
	    var modal_scrollHeight = $('.modal-body').prop('scrollHeight');
	    var modal_innerHeight = $('.modal-body').innerHeight();

	    $('.modal-body').scroll(function () {

	        // Write to console log to debug:
	        console.warn('modal_scrollTop: ' + modal_scrollTop);
	        console.warn('modal_innerHeight: ' + modal_innerHeight);
	        console.warn('modal_scrollHeight: ' + modal_scrollHeight);

	        // Bottom reached:
	        if (modal_scrollTop + modal_innerHeight >= (modal_scrollHeight - 100)) {
	            alert('reached bottom');
	        }
	    });

	    function ShowPopup(title) {
        $("#MyPopup .modal-title").html(title);
        $("#MyPopup").modal("show");       
    }
    $('body').on('shown.bs.modal', '#MyPopup', function () {
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
<script type = "text/javascript">

    function CallPrint(strid) {
        var prtContent = document.getElementById(strid);
        var WinPrint = window.open('', '', 'letf=0,top=0,,,toolbar=0,scrollbars=0,status=0');
        WinPrint.document.write(prtContent.innerHTML);
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();
        prtContent.innerHTML = strOldOne;
    }
    function Check_Click(objRef) {

        //Get the Row based on checkbox

        var row = objRef.parentNode.parentNode;

        if (objRef.checked) {

            //If checked change color to Aqua

            row.style.backgroundColor = "aqua";

        }

        else {

            //If not checked change back to original color

            if (row.rowIndex % 2 == 0) {

                //Alternating Row Color

                row.style.backgroundColor = "#C2D69B";

            }

            else {

                row.style.backgroundColor = "white";

            }

        }



        //Get the reference of GridView

        var GridView = row.parentNode;



        //Get all input elements in Gridview

        var inputList = GridView.getElementsByTagName("input");



        for (var i = 0; i < inputList.length; i++) {

            //The First element is the Header Checkbox

            var headerCheckBox = inputList[0];



            //Based on all or none checkboxes

            //are checked check/uncheck Header Checkbox

            var checked = true;

            if (inputList[i].type == "checkbox" && inputList[i] != headerCheckBox) {

                if (!inputList[i].checked) {

                    checked = false;

                    break;

                }

            }

        }

        headerCheckBox.checked = checked;



    }

</script>
<script type = "text/javascript">

       function checkAll(objRef) {

           var GridView = objRef.parentNode.parentNode.parentNode;

           var inputList = GridView.getElementsByTagName("input");

           for (var i = 0; i < inputList.length; i++) {

               //Get the Cell To find out ColumnIndex

               var row = inputList[i].parentNode.parentNode;

               if (inputList[i].type == "checkbox" && objRef != inputList[i]) {

                   if (objRef.checked) {

                       //If the header checkbox is checked

                       //check all checkboxes

                       //and highlight all rows

                       row.style.backgroundColor = "aqua";

                       inputList[i].checked = true;

                   }

                   else {

                       //If the header checkbox is checked

                       //uncheck all checkboxes

                       //and change rowcolor back to original

                       if (row.rowIndex % 2 == 0) {

                           //Alternating Row Color

                           row.style.backgroundColor = "#C2D69B";

                       }

                       else {

                           row.style.backgroundColor = "white";

                       }

                       inputList[i].checked = false;

                   }

               }

           }

       }

</script>

<div class="page-bar">
						<div class="page-title-breadcrumb">
							<div class=" pull-right">
								<div class="page-title">المستخدمين المسجلين</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">التعريفات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>								
								<li class="active">المستخدمين المسجلين</li>
							</ol>
						</div>
					</div>					
<div class="row">
<div class="col-md-12 col-sm-12">
							<div class="card card-box">
							<div class="card-head">
							
									<header>قائمة المستخدمين المسجلين</header>
									
									<div class="tools">
															<a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
															<a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
														</div>
								</div>
								<div class="card-body" id="bar-parent">
									
								   <div class="form-group row">
                                        <div class="col-md-12 col-sm-12 col-12">
											
										
														<div class="table-scrollable">
									
									
									
																						<div id="example4_wrapper" class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">
																						
																						<div class="form-group row">		
    <div class="col-md-4">
<asp:TextBox ID="txtName" runat="server" class="form-control input-height" PLACEHOLDER="الإسم/الموبايل/البريد الإلكترونى"></asp:TextBox> 
</div>
                                          <div class="col-md-1">          
                                                     <asp:Button ID="btnSearch" runat="server" Text="بحث"
         CssClass="btn btn-default" onclick="btnSearch_Click" 
         />												
        </div>											
									</div>																				
																						<div class="row">
	<div class="col-sm-12">
        <div class="table-scrollable">
										
																						<div id="example4_wrapper" class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">

																						<asp:GridView ID="gvUsers" runat="server" AllowPaging="True" 
    AllowSorting="True" AutoGenerateColumns="False" 
 GridLines="None" PagerSettings-Mode="NumericFirstLast" 
                onpageindexchanging="gvUsersNot_PageIndexChanging" 
        onrowcommand="gvUsers_RowCommand" DataKeyNames="id"
                                     CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle"
        >
            <HeaderStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
    <RowStyle VerticalAlign="Middle" HorizontalAlign="Center" Wrap="true" />
                                                   <PagerSettings Mode="NumericFirstLast" />
    <PagerStyle CssClass="bs4-aspnet-pager" />
    <Columns>
        
   
<%--<asp:TemplateField>
                                  <ItemTemplate>
                                        <asp:LinkButton ID="lbBalance" runat="server" CommandName="Balance" 
                        CommandArgument='<%#Eval("id") %>'>إضافة رصيد</asp:LinkButton>
                                    
                                      
                                    </ItemTemplate>
                                </asp:TemplateField>--%>
   
                                 
        <asp:BoundField DataField="Name" HeaderText="الإسم الأول"/> 
         <asp:BoundField DataField="Lname" HeaderText="الإسم الأخير"/> 
         <asp:BoundField DataField="Ocounts" HeaderText="عدد الطلبات"/> 
         <asp:BoundField DataField="Acounts" HeaderText="عدد العناوين"/> 

        <asp:TemplateField HeaderText="النوع">
    <ItemTemplate>
        <%# Eval("Gender") != DBNull.Value && Eval("Gender") != null 
       ? ((bool)Eval("Gender") ? "أنثى" : "ذكر") 
       : "غير محدد" %>
    </ItemTemplate>
</asp:TemplateField>
        <asp:BoundField DataField="Bdate" HeaderText="تاريخ الميلاد"/>
              
         <asp:TemplateField HeaderText="البريد الإلكترونى">
         <ItemTemplate>
        <a  href='mailto:mailto:<%#Eval("Email") %>'><%#Eval("Email")%></a>
         </ItemTemplate> 
                       </asp:TemplateField>
             <asp:TemplateField>
                                  <ItemTemplate>
                                        <asp:LinkButton ID="lbAddresses" runat="server" CommandName="Addresses" 
                        CommandArgument='<%#Eval("id") %>'>العناوين المسجلة</asp:LinkButton>
                                    
                                      
                                    </ItemTemplate>
                                </asp:TemplateField>
    </Columns>
    
</asp:GridView>
                                                                                            </div>
            </div>
																						</div>
																						</div>
																						<div class="row">
               <label class="control-label col-md-12">العدد المسجل :
                   <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label>
											</div>
																						</div>
																						</div>
																						</div>
																						</div>	
									
							
							</div>
							</div>
							</div>
							</div>
							
							
<div id="MyPopup" class="modal fade" role="dialog" style="height:100%">
    <div class="modal-dialog" style="height:100%">
        <!-- Modal content-->
        <div class="modal-content" style="min-height: 100%;">
            <div class="modal-header" style="background:skyblue">
                <asp:Button Text="X"  runat="server" id="Button3" OnClick="btnClose_Click" class="btn btn-danger" />
               
                <h4 class="modal-title">
                </h4>
            </div>
            <div class="modal-body"  width="100%" height="100%">
                   <asp:Literal ID="ltcontent" runat="server"></asp:Literal>

                
            </div>
            <div class="modal-footer" style="background:skyblue">            
                <asp:Button Text="إغلاق" runat="server" id="Button4" OnClick="btnClose_Click" class="btn btn-danger" />
                   
            </div>
        </div>
    </div>
</div>
    </ContentTemplate>
      	<Triggers> 				
			
			
</Triggers>
    </asp:UpdatePanel>
</asp:Content>

