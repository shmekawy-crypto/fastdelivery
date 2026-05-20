<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Admin_Pages_Orders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
الطلبات
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
        <div class="update" style="position:fixed;top:0;left:0;width:100%;height:100%;background:#fff url('../Scripts/loader.gif') no-repeat center center;z-index:9999;"></div>
    </ProgressTemplate>
</asp:UpdateProgress>

<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
        <asp:Timer ID="tmrNewOrders" runat="server" Interval="30000" OnTick="tmrNewOrders_Tick"></asp:Timer>
        
        <asp:HiddenField ID="hfLastOrderId" runat="server" Value="0" />
        <script type="text/javascript">
            function alertNewOrder() {
                alert("يوجد طلب جديد! تم تحديث القائمة تلقائياً.");
                // يمكنك استبدال الـ alert بـ Toastr أو صوت تنبيه لو عندك المكتبة
            }
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
	 
 </script>
        
           <div class="page-bar">
						<div class="page-title-breadcrumb">
							<div class=" pull-right">
								<div class="page-title"> الطلبات المسجلة</div>
							</div>
							<ol class="breadcrumb page-breadcrumb pull-left">
								<li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">الطلبات المسجلة</a>&nbsp;<i class="fa fa-angle-left"></i>
								</li>
								
								<li class="active">الطلبات المسجلة</li>
							</ol>
						</div>
					</div>
            <div class="row">

                           <div class="col-md-12 col-sm-12">
             <div class="card card-box mb-3">
              <div class="card-head">
                   <header>بحث</header>
									</div>
                <div class="card-body">
                    <div class="row mb-2">
                        <div class="col-md-3">
                            <label>من تاريخ:</label>
                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control datepicker" placeholder="yyyy-mm-dd"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label>إلى تاريخ:</label>
                            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control datepicker" placeholder="yyyy-mm-dd"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <label>الحالة:</label>
                            <asp:DropDownList ID="ddlDelivered" runat="server" CssClass="form-control">
                                <asp:ListItem Text="الكل" Value="-1"></asp:ListItem>
                                <asp:ListItem Text="تم التسليم" Value="1"></asp:ListItem>
                                <asp:ListItem Text="لم يتم التسليم" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <label>المحافظة:</label>
                            <asp:DropDownList  ID="ddlGov" runat="server" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="ddlGov_SelectedIndexChanged">
                                <asp:ListItem Text="الكل" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <label>المنطقة:</label>
                            <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-control select2">
                                <asp:ListItem Text="الكل" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary mt-2" Text="بحث" OnClick="btnSearch_Click" />
                </div>
            </div>
                               </div>
                </div>
            <div class="row">

                           <div class="col-md-12 col-sm-12">
            <div class="card card-box">
                <div class="card-head">
                <header>قائمة الطلبات</header>
									</div>
                <div class="card-body">
                    <div class="table-responsive">
                        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle"
                            AllowPaging="True" PageSize="10" OnPageIndexChanging="gvOrders_PageIndexChanging" OnRowCommand="gvOrders_RowCommand" OnRowDataBound="gvOrders_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="id" HeaderText="رقم الطلب" />
                                <asp:BoundField DataField="UserName" HeaderText="اسم المستخدم" />
                                <asp:BoundField DataField="Gov" HeaderText="المحافظة" />
                                <asp:BoundField DataField="Area" HeaderText="المنطقة" />
                                <asp:BoundField DataField="total" HeaderText="المجموع" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="DeliveryCost" HeaderText="تكلفة التوصيل" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="net" HeaderText="الصافي" DataFormatString="{0:N2}" />
                                
                                <asp:TemplateField HeaderText="تفاصيل الدفع والطلب">
    <ItemTemplate>
        <div style="font-size: 11px; line-height: 1.5; text-align: right; min-width: 140px;">
            <span class="text-muted">طريقة الاستلام:</span> <%# GetDeliveryMethodName(Eval("DeliveryMethod")) %><br />
            <span class="text-muted">طريقة الدفع:</span> <%# GetPaymentMethodName(Eval("PaymentMethod")) %><br />
            <span class="text-muted">رقم المحفظة:</span> <%# Eval("WalletNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("WalletNumber").ToString()) ? Eval("WalletNumber") : "-" %><br />
            <span class="text-muted">طريقة التواصل:</span> <%# GetContactMethodName(Eval("ContactMethod")) %><br />
            <span class="text-muted">ميعاد الاستلام:</span> <%# Eval("ODTime", "{0:yyyy-MM-dd HH:mm}") %><br />
            <asp:HyperLink ID="lnkPhoto" runat="server" NavigateUrl='<%# Eval("TransferPhoto") %>' Target="_blank" Visible='<%# Eval("TransferPhoto") != DBNull.Value && !string.IsNullOrEmpty(Eval("TransferPhoto").ToString()) %>' CssClass="badge badge-warning mt-1">عرض الإيصال</asp:HyperLink>
        </div>
    </ItemTemplate>
</asp:TemplateField>
                                <asp:TemplateField HeaderText="كوبونات الخصم">
                                    <ItemTemplate>
                                        <div style="font-size: 11px; line-height: 1.5; text-align: right; min-width: 150px;">
                                            <span class="text-muted">كوبون المطعم:</span> <%# Eval("CoponDiscountRU") != DBNull.Value ? Eval("CoponDiscountRU") : "-" %> (<%# Eval("CoponDiscountR") %>% )<br />
                                            <span class="text-muted">كوبون الدليفرى:</span> <%# Eval("CoponDiscountDU") != DBNull.Value ? Eval("CoponDiscountDU") : "-" %> (<%# Eval("CoponDiscountD") %>% )
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="المندوب">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hfOrderID" Value='<%# Eval("id") %>' runat="server" />
                                        <asp:DropDownList ID="ddlDrivers" runat="server" CssClass="form-control" 
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlDrivers_SelectedIndexChanged" 
                                            AppendDataBoundItems="true" style="min-width:120px;">
                                            <asp:ListItem Text="اختر المندوب" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="تم التسليم">
                                    <ItemTemplate>
                                        <%# Convert.ToBoolean(Eval("Delivered")) 
                                                ? "<i class='fa fa-check text-success'></i>" 
                                                : "<i class='fa fa-times text-danger'></i>" %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="مقبول">
                                    <EditItemTemplate>
                                        <asp:CheckBox ID="CheckBox1Accepted" runat="server" Checked='<%# Bind("Accepted") %>'  />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                                   <asp:HiddenField ID="hfAccepted" Value='<%# Bind("id") %>'  runat="server"/>
		                                 <label class="switchToggle">
                                                             <asp:CheckBox ID="CheckBoxAccepted"  runat="server" Checked='<%# Bind("Accepted") %>'   AutoPostBack="true"  OnCheckedChanged="Accepted_CheckedChanged" />
                                                                      <span class="slider green round"></span>
                                                     </label>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="جارى التحضير">
                                    <EditItemTemplate>
                                        <asp:CheckBox ID="CheckBoxPrepared" runat="server" Checked='<%# Bind("Prepared") %>'  />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                                   <asp:HiddenField ID="hfPrepared" Value='<%# Bind("id") %>'  runat="server"/>
		                                 <label class="switchToggle">
                                                             <asp:CheckBox ID="ChPrepared"  runat="server" Checked='<%# Bind("Prepared") %>'   AutoPostBack="true"  OnCheckedChanged="Prepared_CheckedChanged" />
                                                                      <span class="slider green round"></span>
                                                     </label>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="فى الطريق">
                                    <EditItemTemplate>
                                        <asp:CheckBox ID="CheckBox1InWay" runat="server" Checked='<%# Bind("InWay") %>'  />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                                   <asp:HiddenField ID="hfInWay" Value='<%# Bind("id") %>'  runat="server"/>
		                                 <label class="switchToggle">
                                                             <asp:CheckBox ID="ChInWay"  runat="server" Checked='<%# Bind("InWay") %>'   AutoPostBack="true"  OnCheckedChanged="InWay_CheckedChanged" />
                                                                      <span class="slider green round"></span>
                                                     </label>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="تم التسليم">
                                    <EditItemTemplate>
                                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Delivered") %>'  />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                                   <asp:HiddenField ID="hf" Value='<%# Bind("id") %>'  runat="server"/>
		                                 <label class="switchToggle">
                                                             <asp:CheckBox ID="CheckBox2"  runat="server" Checked='<%# Bind("Delivered") %>'   AutoPostBack="true"  OnCheckedChanged="CheckBox1_CheckedChanged" />
                                                                      <span class="slider green round"></span>
                                                     </label>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="تتبع وقت التنفيذ">
                                    <ItemTemplate>
                                        <div style="font-size: 11px; line-height: 1.6; min-width: 150px; text-align: right;">
                                            <span class="text-muted">القبول:</span> <%# Eval("AcceptedTime", "{0:HH:mm}") %><br />
                                            <span class="text-muted">التحضير:</span> <%# Eval("PreparedTime", "{0:HH:mm}") %><br />
                                            <span class="text-muted">خروج:</span> <%# Eval("InWayTime", "{0:HH:mm}") %><br />
                                            <span class="text-muted">التسليم:</span> <%# Eval("DeliveredTime", "{0:HH:mm}") %>
                                          <hr style="margin: 2px 0;" />
                                            <span class="badge badge-primary">
                                                <%# Eval("TotalTime") != DBNull.Value ? "استغرق: " + Eval("TotalTime") + " دقيقة" : "قيد التنفيذ..." %>
                                            </span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Odate" HeaderText="تاريخ الطلب" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:TemplateField HeaderText="إجراءات">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDetails" runat="server" 
                                            CommandName="ShowDetails" 
                                            CommandArgument='<%# Eval("id") %>' 
                                            CssClass="btn btn-sm btn-info">
                                            عرض التفاصيل
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <div class="mt-2">
                            <label>العدد الكلي: <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label></label>
                        </div>
                    </div>
                </div>
            </div>
                               </div>
                </div>
        

        <script>

             Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(evt, args) {
                 $('#<%= ddlGov.ClientID %>').select2({ width: '100%', dir: 'rtl' });
                $('#<%= ddlArea.ClientID %>').select2({ width: '100%', dir: 'rtl' });

                // Datepicker
                $('.datepicker').datepicker({
                    format: "yyyy-mm-dd",
                    autoclose: true,
                    todayHighlight: true,
                    orientation: "bottom right"
                });
            });


           
        </script>
        <div id="MyPopup" class="modal fade" role="dialog" style="height:100%">
    <div class="modal-dialog" style="height:100%">
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
</asp:UpdatePanel>

</asp:Content>