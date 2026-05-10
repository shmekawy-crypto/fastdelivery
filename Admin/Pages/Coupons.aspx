<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Coupons.aspx.cs" Inherits="Admin_Pages_Coupons" Title="إدارة الكوبونات" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" Runat="Server">
    إدارة وتوليد الكوبونات المتقدمة
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            
            <div class="row">
                <div class="col-md-12">
                    <div class="card card-box">
                        <div class="card-head">
                            <header>توليد كوبونات جديدة تلقائياً</header>
                        </div>
                        <div class="card-body">
                            <div class="form-body">
                                
                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">نوع الخصم *</label>
                                    <div class="col-md-3">
                                        <asp:DropDownList ID="ddlDiscountType" runat="server" class="form-control input-height" onchange="togglePlaces(this)">
                                            <asp:ListItem Value="0">خصم على التوصيل (Delivery)</asp:ListItem>
                                            <asp:ListItem Value="1">خصم على المطعم (Restaurant)</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    
                                    <div id="divPlace" style="display:none;" class="col-md-5">
                                        <div class="row">
                                            <label class="col-sm-4 control-label">اختر المطعم *</label>
                                            <div class="col-md-8">
                                                <asp:DropDownList ID="ddlPlace" runat="server" class="form-control input-height" AppendDataBoundItems="true">
                                                    <asp:ListItem Value="0">.. اختر المطعم ..</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">النسبة % *</label>
                                    <div class="col-md-2">
                                        <asp:TextBox ID="txtPercentage" runat="server" class="form-control" TextMode="Number"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvPercent" runat="server" ControlToValidate="txtPercentage" 
                                            ErrorMessage="النسبة مطلوبة" Display="Dynamic" ForeColor="Red" ValidationGroup="vgSave"></asp:RequiredFieldValidator>
                                    </div>
                                    
                                    <label class="col-sm-2 control-label">أقصى مبلغ خصم *</label>
                                    <div class="col-md-2">
                                        <asp:TextBox ID="txtMaxDiscount" runat="server" class="form-control" Text="100" TextMode="Number"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvMax" runat="server" ControlToValidate="txtMaxDiscount" 
                                            ErrorMessage="المبلغ مطلوب" Display="Dynamic" ForeColor="Red" ValidationGroup="vgSave"></asp:RequiredFieldValidator>
                                    </div>

                                    <label class="col-sm-2 control-label">الحد الأدنى للطلب *</label>
                                    <div class="col-md-2">
                                        <asp:TextBox ID="txtMinOrder" runat="server" class="form-control" Text="0" TextMode="Number"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvMin" runat="server" ControlToValidate="txtMinOrder" 
                                            ErrorMessage="الحد الأدنى مطلوب" Display="Dynamic" ForeColor="Red" ValidationGroup="vgSave"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="col-sm-2 control-label">تاريخ الانتهاء *</label>
                                    <div class="col-md-4">
                                        <asp:TextBox ID="txtExpiryDate" runat="server" class="form-control" TextMode="Date"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvDate" runat="server" ControlToValidate="txtExpiryDate" 
                                            ErrorMessage="التاريخ مطلوب" Display="Dynamic" ForeColor="Red" ValidationGroup="vgSave"></asp:RequiredFieldValidator>
                                    </div>
                                    <label class="col-sm-2 control-label">عدد الكوبونات *</label>
                                    <div class="col-md-2">
                                        <asp:TextBox ID="txtCount" runat="server" class="form-control" Text="1" TextMode="Number"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvCount" runat="server" ControlToValidate="txtCount" 
                                            ErrorMessage="العدد مطلوب" Display="Dynamic" ForeColor="Red" ValidationGroup="vgSave"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="text-center p-t-20">
                                    <asp:Button ID="btnGenerate" runat="server" Text="توليد وحفظ الكوبونات" class="btn btn-info" 
                                        OnClick="btnSave_Click" ValidationGroup="vgSave" />
                                    <asp:Button ID="btnCancel" runat="server" Text="إلغاء وتفريغ" class="btn btn-default" OnClick="btnCancel_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card card-box">
                <div class="card-head">
                    <header>البحث والفلترة في الكوبونات المسجلة</header>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label>كود الكوبون</label>
                            <asp:TextBox ID="txtSearchCode" runat="server" class="form-control" placeholder="بحث بالكود..."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label>بالمطعم</label>
                            <asp:DropDownList ID="ddlSearchPlace" runat="server" class="form-control" AppendDataBoundItems="true">
                                <asp:ListItem Value="-1">.. كل المطاعم ..</asp:ListItem>
                                <asp:ListItem Value="0">عام (بدون مطعم)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label>الحالة</label>
                            <asp:DropDownList ID="ddlSearchStatus" runat="server" class="form-control">
                                <asp:ListItem Value="-1">الكل</asp:ListItem>
                                <asp:ListItem Value="1">فعال وشغال</asp:ListItem>
                                <asp:ListItem Value="0">متوقف يدوياً</asp:ListItem>
                                <asp:ListItem Value="2">منتهي الصلاحية</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 p-t-20">
                            <asp:Button ID="btnSearch" runat="server" Text="فلترة النتائج" class="btn btn-primary" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-scrollable">
                <asp:GridView ID="gvCoupons" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-striped table-bordered table-hover" OnRowCommand="gvCoupons_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="CouponCode" HeaderText="كود الكوبون" HeaderStyle-CssClass="text-center" />
                        <asp:TemplateField HeaderText="النوع" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <%# Eval("DiscountType").ToString() == "1" ? "<span class='label label-success'>مطعم</span>" : "<span class='label label-info'>توصيل</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="PlaceName" HeaderText="المطعم" NullDisplayText="" />
                        <asp:BoundField DataField="DiscountPercentage" HeaderText="النسبة %" />
                        <asp:BoundField DataField="MaxDiscountAmount" HeaderText="أقصى خصم" />
                        <asp:BoundField DataField="MinOrderAmount" HeaderText="أقل طلب" />
                        <asp:BoundField DataField="ExpiryDate" HeaderText="ينتهي في" DataFormatString="{0:yyyy-MM-dd}" />
                        
                        <asp:TemplateField HeaderText="الحالة" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnStatus" runat="server" CommandName="ToggleStatus" 
                                    CommandArgument='<%# Eval("id") + "|" + Eval("IsActive") %>'
                                    CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "btn btn-xs btn-success" : "btn btn-xs btn-warning" %>'>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "فعال (إيقاف؟)" : "متوقف (تفعيل؟)" %>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="حذف" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbDel" runat="server" CommandName="DeleteCoupon" 
                                    CommandArgument='<%#Eval("id") %>' OnClientClick="return confirm('هل أنت متأكد من حذف هذا الكوبون؟');" 
                                    class="text-danger"><i class="fa fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="p-10">العدد المسجل في البحث: <asp:Label ID="lblCount" runat="server" font-bold="true" Text="0"></asp:Label></div>

            <script type="text/javascript">
                function togglePlaces(ddl) {
                    var div = document.getElementById("divPlace");
                    // إظهار قائمة المطاعم فقط إذا كان نوع الخصم "مطعم" (القيمة 1)
                    if (div != null) {
                        div.style.display = (ddl.value == "1") ? "block" : "none";
                    }
                }

                // لضمان عمل الدالة بعد الـ UpdatePanel Postback
                Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function () {
                    var ddlType = document.getElementById('<%= ddlDiscountType.ClientID %>');
                    if (ddlType != null) {
                        togglePlaces(ddlType);
                    }
                });
            </script>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>