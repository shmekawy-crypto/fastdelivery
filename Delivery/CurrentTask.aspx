<%@ Page Title="المهمة الحالية" Language="C#" MasterPageFile="~/Delivery/MasterPage/Site.master" AutoEventWireup="true" CodeFile="CurrentTask.aspx.cs" Inherits="Delivery_CurrentTask" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .order-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); padding: 25px; margin-bottom: 25px; border-right: 6px solid #3498db; }
        .timer-header { background: #2c3e50; color: #f1c40f; padding: 10px; border-radius: 8px; text-align: center; margin-bottom: 15px; font-weight: bold; }
        .info-label { font-weight: bold; color: #7f8c8d; font-size: 13px; }
        .info-value { color: #2c3e50; font-weight: 600; font-size: 15px; }
        .timeline-box { background: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #eee; font-size: 12px; }
        
        /* تنسيق أزرار الفلترة */
        .filter-nav { margin-bottom: 20px; display: flex; gap: 10px; justify-content: center; }
        .filter-btn { padding: 10px 25px; border-radius: 20px; border: 1px solid #3498db; background: #fff; color: #3498db; font-weight: bold; cursor: pointer; text-decoration: none; }
        .filter-btn.active { background: #3498db !important; color: #fff !important; }
        .badge-count { background: #e74c3c; color: #fff; padding: 2px 8px; border-radius: 10px; margin-right: 5px; font-size: 11px; }
        
        /* تنسيق المجموعات والحسابات */
        .restaurant-group-header { background: #f1f8ff; padding: 10px; border-right: 4px solid #2980b9; margin-top: 15px; display: flex; justify-content: space-between; align-items: center; }
        .restaurant-subtotal { background: #fdf2e9; padding: 8px; text-align: left; font-weight: bold; color: #d35400; border-bottom: 2px solid #e67e22; margin-bottom: 15px; font-size: 13px; }
        .grand-total-box { background: #fff5f0; padding: 15px; border-radius: 10px; border: 1px solid #ffccbc; margin-top: 10px; text-align: center; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <h2 class="text-center" style="font-weight:bold; color:#2c3e50;">بيانات المهام</h2>
        <hr />

        <div class="filter-nav">
            <asp:LinkButton ID="btnActive" runat="server" OnClick="Filter_Click" CommandArgument="0" CssClass="filter-btn active">
                <i class="fa fa-refresh"></i> نشطة <asp:Label ID="lblCountActive" runat="server" CssClass="badge-count">0</asp:Label>
            </asp:LinkButton>
            <asp:LinkButton ID="btnDelivered" runat="server" OnClick="Filter_Click" CommandArgument="1" CssClass="filter-btn">
                <i class="fa fa-check-circle"></i> تم تسليمها <asp:Label ID="lblCountDone" runat="server" CssClass="badge-count" style="background:#27ae60;">0</asp:Label>
            </asp:LinkButton>
        </div>

        <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
            <ItemTemplate>
                <div class="order-card">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="timer-header">
                                <i class="fa fa-clock-o"></i> 
                                <span class="countdown" 
                                      data-accepted-time='<%# Eval("AcceptedTime", "{0:yyyy-MM-ddTHH:mm:ss}") %>' 
                                      data-prep-min='<%# Eval("MaxPrepMin") %>'
                                      data-is-prepared='<%# Eval("Prepared").ToString().ToLower() %>'
                                      data-inway='<%# Eval("InWay").ToString().ToLower() %>'
                                      data-zone-time='<%# Eval("ZoneTime") %>'>--:--</span>
                            </div>
                            <div class="timeline-box">
                                <p><i class="fa fa-plus text-primary"></i> <strong>وقت الطلب:</strong> <%# Eval("Odate") %></p>
                                <p><i class="fa fa-check text-success"></i> <strong>وقت القبول:</strong> <%# Eval("AcceptedTime") %></p>
                                <p><i class="fa fa-home text-danger"></i> <strong>وقت التسليم:</strong> <%# Eval("DeliveredTime") != DBNull.Value ? Eval("DeliveredTime") : "---" %></p>
                            </div>
                            <div class="grand-total-box">
                                <span class="info-label">إجمالي المبلغ المطلوب تحصيله:</span><br />
                                <strong style="font-size:22px; color:#e67e22;"><%# Eval("GrandTotal", "{0:N2}") %> ج.م</strong>
                                <div style="font-size:11px; color:#7f8c8d; margin-top:5px;">
                                    (أصناف: <%# Eval("TotalItemsPrice", "{0:N2}") %> + توصيل: <%# Eval("DeliveryCost", "{0:N2}") %>)
                                </div>
                            </div>
                        </div>

                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-sm-7">
                                    <span class="info-label">اسم العميل:</span>
                                    <span class="info-value" style="color:#c0392b;"><%# Eval("CustomerRealName") %></span>
                                </div>
                                <div class="col-sm-5 text-left">
                                    <span class="info-label">الموبايل:</span>
                                    <a href='tel:<%# Eval("Mobile") %>' class="btn btn-xs btn-success" style="font-weight:bold;"><%# Eval("Mobile") %></a>
                                </div>
                            </div>
                            <div class="row" style="margin-top:10px;">
                                <div class="col-sm-12">
                                    <span class="info-label">العنوان التفصيلي:</span>
                                    <span class="info-value"><%# Eval("AreaName") %> (<%# Eval("AddressName") %>) - <%# Eval("StreetName") %></span>
                                    <br /><small class="text-muted">مبنى: <%# Eval("Build") %> / دور: <%# Eval("FloorNo") %> / شقة: <%# Eval("adepartmentNo") %></small>
                                </div>
                            </div>

                            <h5 style="margin-top:20px; font-weight:bold; color:#2c3e50;"><i class="fa fa-shopping-basket"></i> تفاصيل الطلب حسب المطعم:</h5>
                            
                            <asp:Repeater ID="rptPlaces" runat="server" OnItemDataBound="rptPlaces_ItemDataBound">
                                <ItemTemplate>
                                    <div class="restaurant-group-header">
                                        <span><i class="fa fa-building"></i> <strong><%# Eval("Name") %></strong></span>
                                        <small class="text-muted"><%# Eval("Address") %></small>
                                    </div>
                                    
                                    <asp:Repeater ID="rptItems" runat="server">
                                        <HeaderTemplate>
                                            <table class="table table-condensed" style="font-size:13px; margin-bottom:0;">
                                                <thead>
                                                    <tr style="color:#7f8c8d;">
                                                        <th>الصنف</th><th class="text-center">العدد</th><th class="text-center">السعر</th><th class="text-left">الإجمالي</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("ItemName") %></td>
                                                <td class="text-center"><%# Eval("Amount") %></td>
                                                <td class="text-center"><%# Eval("Price", "{0:N2}") %></td>
                                                <td class="text-left"><strong><%# Eval("ItemTotal", "{0:N2}") %></strong></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></tbody></table></FooterTemplate>
                                    </asp:Repeater>
                                    
                                    <div class="restaurant-subtotal">
                                        إجمالي حساب مطعم <%# Eval("Name") %>: <asp:Label ID="lblPlaceTotal" runat="server"></asp:Label> ج.م
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    
                    <div class="row" style="margin-top:20px;" runat="server" visible='<%# Eval("DeliveredTime") == DBNull.Value %>'>
                        <div class="col-md-6">
                            <asp:Button ID="btnInWay" runat="server" Text="تغيير الحالة إلى (في الطريق)" CssClass="btn btn-warning btn-block" 
                                        Visible='<%# !Convert.ToBoolean(Eval("InWay")) %>' OnClick="btnInWay_Click" CommandArgument='<%# Eval("id") %>' />
                        </div>
                        <div class="col-md-6">
                            <asp:Button ID="btnDelivered" runat="server" Text="تأكيد التسليم للعميل" CssClass="btn btn-success btn-block" 
                                        OnClick="btnDelivered_Click" CommandArgument='<%# Eval("id") %>' OnClientClick="return confirm('تأكيد التسليم؟');" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="alert alert-info text-center" style="margin-top:50px;">
            <h3><i class="fa fa-info-circle"></i> لا توجد مهام نشطة حالياً مسندة إليك</h3>
        </asp:Panel>
    </div>

    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script>
        function updateTimers() {
            $('.countdown').each(function () {
                var el = $(this), prep = el.data('is-prepared'), acceptedStr = el.data('accepted-time');
                if(!acceptedStr) return;
                var accepted = new Date(acceptedStr).getTime(), prepMs = parseInt(el.data('prep-min')) * 60000, now = new Date().getTime();
                if (prep === false) {
                    var diff = (accepted + prepMs) - now;
                    if (diff > 0) {
                        var m = Math.floor(diff / 60000), s = Math.floor((diff % 60000) / 1000);
                        el.text("تحضير: " + m + ":" + (s < 10 ? "0" : "") + s);
                    } else { el.text("جاهز للتسليم").css("color", "#2ecc71"); }
                } else { el.text("في الطريق (متوقع: " + el.data('zone-time') + " د)").css("color", "#f1c40f"); }
            });
        }
        setInterval(updateTimers, 1000);
    </script>
</asp:Content>