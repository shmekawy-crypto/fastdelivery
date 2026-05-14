<%@ Page Title="إدارة الطلبات المتكاملة" Language="C#" MasterPageFile="~/Places/MasterPages/Site.master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Places_MasterPages_Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .dashboard-header { background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); margin-bottom: 25px; border-right: 5px solid #2c3e50; }
        .search-card { background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); margin-bottom: 20px; }
        .table-card { background: #fff; border-radius: 12px; padding: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); }
        .status-time { font-size: 11px; display: block; margin-top: 2px; color: #7f8c8d; }
        .time-badge { background: #f1f4f7; padding: 4px 10px; border-radius: 5px; font-weight: bold; color: #2c3e50; display: inline-block; }
        .modal-header { background: #2c3e50; color: white; border-radius: 15px 15px 0 0; }
        .close-btn { color: white; font-size: 24px; background: none; border: none; float: left; }
        .summary-box { background: #f9f9f9; padding: 15px; border-radius: 10px; border: 1px solid #eee; margin-top: 15px; }
        .btn-modern { border-radius: 6px; font-weight: bold; }

        @media print {
            .sidebar-nav, .dashboard-header, .search-card, .btn, .modal-footer, .navbar, .modal-backdrop { display: none !important; }
            #detailsModal { display: block !important; position: relative !important; width: 100% !important; }
            .modal-dialog { width: 100% !important; margin: 0 !important; }
            .table { width: 100% !important; border: 1px solid #000 !important; }
            th, td { border: 1px solid #000 !important; padding: 5px !important; color: black !important; }
        }
    </style>

    <asp:ScriptManager ID="sm1" runat="server"></asp:ScriptManager>

    <div class="container-fluid">
        <div class="dashboard-header">
            <div class="row">
                <div class="col-md-6">
                    <h2 style="margin:0; font-weight:bold; color:#2c3e50;">مراقبة الطلبات المباشرة</h2>
                </div>
                <div class="col-md-6 text-left">
                    إجمالي النتائج: <b><asp:Label ID="lblTotalOrders" runat="server" Text="0" /></b>
                </div>
            </div>
        </div>

        <!-- لوحة البحث المتقدم -->
        <div class="search-card">
            <div class="row">
                <div class="col-md-3">
                    <label>بحث (اسم العميل / تليفون):</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="ادخل الاسم او الرقم..."></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label>حالة الطلب:</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- الكل --" Value="All" />
                        <asp:ListItem Text="بانتظار القبول" Value="Pending" />
                        <asp:ListItem Text="قيد التحضير" Value="Accepted" />
                        <asp:ListItem Text="خرج للتوصيل" Value="InWay" />
                        <asp:ListItem Text="تم التسليم" Value="Delivered" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label>من تاريخ:</label>
                    <asp:TextBox ID="txtDateFrom" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label>إلى تاريخ:</label>
                    <asp:TextBox ID="txtDateTo" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label>&nbsp;</label>
                    <asp:Button ID="btnSearch" runat="server" Text="بحث وفلترة" CssClass="btn btn-primary btn-block btn-modern" OnClick="btnSearch_Click" />
                </div>
            </div>
        </div>

        <div class="table-card">
            <asp:UpdatePanel ID="upOrders" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:GridView ID="gvOrders" runat="server" CssClass="table table-hover" AutoGenerateColumns="false" DataKeyNames="id" OnRowCommand="gvOrders_RowCommand" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="#" />
                            
                            <asp:TemplateField HeaderText="العميل والعنوان">
                                <ItemTemplate>
                                    <div style="font-weight:bold; color:#2c3e50;"><%# Eval("CustomerName") %></div>
                                    <small><i class="glyphicon glyphicon-phone"></i> <%# Eval("Mobile") %></small><br />
                                    <small class="text-muted">
                                        <%# Eval("FullAddress") %> | 
                                        <b>عمارة <%# Eval("Build") %> - دور <%# Eval("FloorNo") %> - شقة <%# Eval("adepartmentNo") %></b>
                                    </small>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="توقيت الطلب والقيمة">
                                <ItemTemplate>
                                    <span class="time-badge"><%# Eval("Odate", "{0:yyyy-MM-dd HH:mm}") %></span><br />
                                    <div style="font-weight:bold; color:#27ae60; margin-top:5px;"><%# Eval("TotalOrderCash", "{0:N2}") %> ج.م</div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="تتبع الحالة">
                                <ItemTemplate>
                                    <span class="status-time">✔️ قبول: <%# Eval("AcceptedTime", "{0:HH:mm}") ?? "--:--" %></span>
                                    <span class="status-time">🍳 تحضير: <%# Eval("PreparedTime", "{0:HH:mm}") ?? "--:--" %></span>
                                    <span class="status-time">🚚 خروج: <%# Eval("InWayTime", "{0:HH:mm}") ?? "--:--" %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="الإجراء">
                                <ItemTemplate>
                                    <asp:Button ID="btnNext" runat="server" CommandName="NextStep" CommandArgument='<%# Eval("id") %>' 
                                        Text='<%# GetNextStepText(Eval("Accepted"), Eval("Prepared"), Eval("InWay"), Eval("Delivered")) %>'
                                        CssClass='<%# "btn btn-sm btn-modern " + GetNextStepClass(Eval("Accepted"), Eval("Prepared"), Eval("InWay"), Eval("Delivered")) %>' 
                                        Enabled='<%# !Convert.ToBoolean(Eval("Delivered")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="التفاصيل">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDetails" runat="server" CommandName="ShowDetails" CommandArgument='<%# Eval("id") %>' CssClass="btn btn-default btn-sm btn-modern">فاتورة</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <!-- مودال الفاتورة -->
    <div class="modal fade" id="detailsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="modal-header">
                            <button type="button" class="close-btn" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">تفاصيل الفاتورة #<asp:Label ID="lblModalOrderID" runat="server" /></h4>
                        </div>
                        <div class="modal-body">
                            <asp:GridView ID="gvOrderItems" runat="server" CssClass="table" AutoGenerateColumns="false" OnRowDataBound="gvOrderItems_RowDataBound" GridLines="None">
                                <Columns>
                                    <asp:TemplateField HeaderText="الصنف">
                                        <ItemTemplate>
                                            <b><%# Eval("ItemName") %></b> (<%# Eval("SizeName") %>)
                                            <asp:Repeater ID="rptExtras" runat="server">
                                                <ItemTemplate><div style="font-size:11px; color:#e67e22; margin-right:15px;">+ <%# Eval("ExtraName") %></div></ItemTemplate>
                                            </asp:Repeater>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Amount" HeaderText="الكمية" />
                                    <asp:BoundField DataField="Price" HeaderText="السعر" DataFormatString="{0:N2}" />
                                    <asp:TemplateField HeaderText="الإجمالي">
                                        <ItemTemplate><%# (Convert.ToDecimal(Eval("Amount")) * Convert.ToDecimal(Eval("Price"))).ToString("N2") %></ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>

                            <div class="summary-box">
                                <div class="row">
                                    <div class="col-md-7">
                                        <p>توقيت الطلب: <b><asp:Label ID="lblModalOrderTime" runat="server" /></b></p>
                                        <p>العميل: <b><asp:Label ID="lblCustName" runat="server" /></b></p>
                                        <p>تليفون: <b><asp:Label ID="lblCustPhone" runat="server" /></b></p>
                                        <p>العنوان: <asp:Label ID="lblModalAddress" runat="server" /></p>
                                    </div>
                                    <div class="col-md-5 text-left">
                                        <h2 style="color:#27ae60; font-weight:bold; margin-top:20px;">الإجمالي: <asp:Label ID="lblGrandTotal" runat="server" /> ج.م</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default btn-modern" data-dismiss="modal">إغلاق</button>
                            <button type="button" class="btn btn-success btn-modern" onclick="window.print()">طباعة</button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>