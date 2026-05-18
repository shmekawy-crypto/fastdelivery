<%@ Page Title="تفاصيل الطلب" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="OrderDetails.aspx.cs" Inherits="Ar_OrderDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    تفاصيل الطلب
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="order-details-wrapper">
        <div class="container" style="max-width: 800px;">
            <asp:UpdatePanel ID="updStatus" runat="server">
                <ContentTemplate>
                    
                    <asp:Timer ID="tmrRefresh" runat="server" Interval="30000" OnTick="tmrRefresh_Tick"></asp:Timer>
            <div class="order-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-1" style="font-weight: 800;">
                            <asp:Literal runat="server" Text="<%$ Resources:texts, OrderNum %>" /> #<asp:Literal ID="litOrderId" runat="server" />
                        </h4>
                        <p class="text-muted small mb-0"><i class="fa fa-calendar-alt me-1"></i> <asp:Literal ID="litOrderDate" runat="server" /></p>
                    </div>
                    <span class="badge bg-orange p-2 px-3"><asp:Literal ID="litStatusHeader" runat="server" /></span>
                </div>
                <hr style="opacity: 0.05;" />
                <div class="row mt-3">
                    <div class="col-md-7">
                        <p class="mb-1"><strong><i class="fa fa-map-marker-alt text-danger me-2"></i><asp:Literal runat="server" Text="<%$ Resources:texts, DeliveryAddress %>" />:</strong></p>
                        <p class="text-muted small ms-4"><asp:Literal ID="litFullAddress" runat="server" /></p>
                    </div>
                    <div class="col-md-5 text-md-end">
                        <p class="mb-0"><strong><i class="fa fa-phone text-primary me-2"></i><asp:Literal runat="server" Text="<%$ Resources:texts, ContactPhone %>" />:</strong> <asp:Literal ID="litCustomerPhone" runat="server" /></p>
                    </div>
                </div>
            </div>

            <div class="order-card">
                <h6 class="fw-bold mb-3" style="border-right: 4px solid #ff9800; padding-right: 10px;">خيارات وتفاصيل الطلب</h6>
                <div class="row g-3 small">
                    <asp:PlaceHolder ID="phDeliveryMethodInfo" runat="server" Visible="false">
                        <div class="col-6 col-md-4">
                            <div class="p-2 border rounded-3 bg-light">
                                <span class="text-muted d-block mb-1"><i class="fa fa-truck me-1 text-orange"></i> طريقة التوصيل</span>
                                <strong class="text-dark"><asp:Literal ID="litDeliveryMethod" runat="server" /></strong>
                            </div>
                        </div>
                    </asp:PlaceHolder>
                    
                    <asp:PlaceHolder ID="phPaymentMethodInfo" runat="server" Visible="false">
                        <div class="col-6 col-md-4">
                            <div class="p-2 border rounded-3 bg-light">
                                <span class="text-muted d-block mb-1"><i class="fa fa-credit-card me-1 text-orange"></i> طريقة الدفع</span>
                                <strong class="text-dark"><asp:Literal ID="litPaymentMethod" runat="server" /></strong>
                            </div>
                        </div>
                    </asp:PlaceHolder>

                    <asp:PlaceHolder ID="phWalletInfo" runat="server" Visible="false">
                        <div class="col-6 col-md-4">
                            <div class="p-2 border rounded-3 bg-light">
                                <span class="text-muted d-block mb-1"><i class="fa fa-wallet me-1 text-orange"></i> رقم المحفظة</span>
                                <strong class="text-dark"><asp:Literal ID="litWalletNumber" runat="server" /></strong>
                            </div>
                        </div>
                    </asp:PlaceHolder>

                    <asp:PlaceHolder ID="phContactMethodInfo" runat="server" Visible="false">
                        <div class="col-6 col-md-4">
                            <div class="p-2 border rounded-3 bg-light">
                                <span class="text-muted d-block mb-1"><i class="fa fa-comments me-1 text-orange"></i> طريقة التواصل</span>
                                <strong class="text-dark"><asp:Literal ID="litContactMethod" runat="server" /></strong>
                            </div>
                        </div>
                    </asp:PlaceHolder>

                    <asp:PlaceHolder ID="phODTimeInfo" runat="server" Visible="false">
                        <div class="col-12 col-md-8">
                            <div class="p-2 border rounded-3 bg-light">
                                <span class="text-muted d-block mb-1"><i class="fa fa-clock me-1 text-orange"></i> وقت التوصيل المطلوب</span>
                                <strong class="text-dark"><asp:Literal ID="litODTime" runat="server" /></strong>
                            </div>
                        </div>
                    </asp:PlaceHolder>
                </div>
            </div>

            <div class="order-card">
                <h6 class="fw-bold mb-4" style="border-right: 4px solid #ff9800; padding-right: 10px;"><asp:Literal runat="server" Text="<%$ Resources:texts, OrderStatusNow %>" /></h6>
                
                <asp:PlaceHolder ID="phPrepCountdown" runat="server" Visible="false">
                    <div class="alert alert-warning text-center mb-4 py-2" style="border-radius: 10px; border: 1px dashed #ff9800; background-color: #fffde6;">
                        <i class="fa fa-stopwatch fa-spin me-2 text-danger"></i>
                        <asp:Literal ID="litCountdownLabel" runat="server" />
                        <span id="countdownTimer" class="fw-bold text-danger" style="font-size: 16px;">--:--</span>
                        <asp:HiddenField ID="hfSecondsLeft" runat="server" ClientIDMode="Static" />
                    </div>
                </asp:PlaceHolder>

                <div class="order-stepper">
                    <asp:Literal ID="litStepperHtml" runat="server" />
                </div>
                <asp:PlaceHolder ID="phDriverInfo" runat="server" Visible="false">
    <div class="order-card" style="border-right: 4px solid #28a745;">
        <h6 class="fw-bold mb-3"><i class="fa fa-motorcycle me-2"></i>بيانات مندوب التوصيل</h6>
        <div class="d-flex align-items-center">
            <div class="driver-icon me-3" style="width: 50px; height: 50px; background: #e8f5e9; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                <i class="fa fa-user-tie text-success" style="font-size: 24px;"></i>
            </div>
            <div>
                <p class="mb-0 fw-bold"><asp:Literal ID="litDriverName" runat="server" /></p>
                <p class="mb-0 text-muted small">
                    <i class="fa fa-phone-alt me-1"></i>
                    <a href='tel:<%= litDriverPhone.Text %>' style="text-decoration:none; color:inherit;">
                        <asp:Literal ID="litDriverPhone" runat="server" />
                    </a>
                </p>
            </div>
            <div class="ms-auto">
                <a href='tel:<%= litDriverPhone.Text %>' class="btn btn-success btn-sm rounded-pill px-3">
                    <i class="fa fa-phone"></i> إتصال
                </a>
            </div>
        </div>
    </div>
</asp:PlaceHolder>
            </div>

            <div class="order-card">
                <h6 class="fw-bold mb-4" style="border-right: 4px solid #ff9800; padding-right: 10px;"><asp:Literal runat="server" Text="<%$ Resources:texts, CartDetails %>" /></h6>
                <asp:Repeater ID="rptPlaces" runat="server" OnItemDataBound="rptPlaces_ItemDataBound">
                    <ItemTemplate>
                        <div class="place-section">
                            <div class="place-name"><i class="fa fa-store fa-store-orange"></i> <%# Eval("PlaceName") %></div>
                            <asp:Repeater ID="rptItems" runat="server">
                                <ItemTemplate>
                                    <div class="item-box <%# Convert.ToInt32(Eval("IsExtra")) == 1 ? "extra-row" : "" %>">
                                        <img src='<%# Eval("PhotoUrl") %>' class="item-img" style='<%# Convert.ToInt32(Eval("IsExtra")) == 1 ? "display:none;" : "" %>' />
                                        
                                        <div class="item-details" style='<%# Convert.ToInt32(Eval("IsExtra")) == 1 ? "margin-right: 20px;" : "" %>'>
                                            <p class="item-title">
                                                <%# Convert.ToInt32(Eval("IsExtra")) == 1 ? "<span style='color: #28a745; font-weight: bold;'>[إضافة] + </span>" : "" %>
                                                <%# Eval("ItemName") %>
                                                
                                                <%# Convert.ToInt32(Eval("IsExtra")) == 0 && Eval("PrepearMin") != DBNull.Value && Convert.ToInt32(Eval("PrepearMin")) > 0 ? 
                                                    "<span class='badge bg-light text-dark ms-2 small fw-normal border'><i class='fa fa-clock text-warning me-1'></i>" + Eval("PrepearMin") + " دقيقة</span>" : "" %>
                                            </p>
                                            <span class="item-meta"><asp:Literal runat="server" Text="<%$ Resources:texts, UnitPrice %>" />: <%# Eval("Price") %> <asp:Literal runat="server" Text="<%$ Resources:texts, Currency %>" /></span>
                                            
                                            <%# Eval("Notes") != DBNull.Value && !string.IsNullOrEmpty(Eval("Notes").ToString()) ? 
                                                "<div class='item-notes mt-1 small text-muted'><i class='fa fa-edit text-warning me-1'></i><span class='fw-bold'>ملاحظات:</span> " + Eval("Notes") + "</div>" : "" %>
                                        </div>
                                        <div class="item-pricing text-start">
                                            <span class="item-qty"><asp:Literal runat="server" Text="<%$ Resources:texts, Quantity %>" />: <%# Eval("Amount") %></span>
                                            <span class="item-price"><%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Amount"))).ToString("N2") %> <asp:Literal runat="server" Text="<%$ Resources:texts, Currency %>" /></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="mt-4 pt-3">
                    <div class="summary-row">
                        <span><asp:Literal runat="server" Text="<%$ Resources:texts, Subtotal %>" /></span>
                        <span class="fw-bold"><asp:Literal ID="litSubTotal" runat="server" /> <asp:Literal runat="server" Text="<%$ Resources:texts, Currency %>" /></span>
                    </div>
                    <asp:PlaceHolder ID="phRestaurantDiscount" runat="server" Visible="false">
                        <div class="summary-row text-success">
                            <span><i class="fa fa-ticket-alt me-1"></i> كوبون خصم المطعم (<asp:Literal ID="litRestPercent" runat="server" />%)</span>
                            <span class="fw-bold">-<asp:Literal ID="litRestDiscountValue" runat="server" /> <asp:Literal runat="server" Text="<%$ Resources:texts, Currency %>" /></span>
                        </div>
                    </asp:PlaceHolder>
                    <div class="summary-row">
                        <span><asp:Literal runat="server" Text="<%$ Resources:texts, DeliveryFees %>" /></span>
                        <span class="fw-bold"><asp:Literal ID="litDeliveryFee" runat="server" /> <asp:Literal runat="server" Text="<%$ Resources:texts, Currency %>" /></span>
                    </div>
                    <asp:PlaceHolder ID="phDeliveryDiscount" runat="server" Visible="false">
                        <div class="summary-row text-success">
                            <span><i class="fa fa-motorcycle me-1"></i> كوبون خصم التوصيل (<asp:Literal ID="litDelivPercent" runat="server" />%)</span>
                            <span class="fw-bold">-<asp:Literal ID="litDelivDiscountValue" runat="server" /> <asp:Literal runat="server" Text="<%$ Resources:texts, Currency %>" /></span>
                        </div>
                    </asp:PlaceHolder>
                    <div class="summary-row total-row">
                        <span><asp:Literal runat="server" Text="<%$ Resources:texts, Total %>" /></span>
                        <span><asp:Literal ID="litGrandTotal" runat="server" /> <asp:Literal runat="server" Text="<%$ Resources:texts, Currency %>" /></span>
                    </div>
                </div>
            </div>
                    </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" Runat="Server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        /* التنسيقات العامة للحاوية */
        .order-details-wrapper { 
            padding-top: 110px !important; /* عشان ما يغطيش عليه الهيدر */
            padding-bottom: 50px;
            background-color: #fcfcfc; 
            min-height: 100vh; 
            
        }

        /* الكروت */
        .order-card { 
            background: #fff; 
            border-radius: 15px; 
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); 
            margin-bottom: 25px; 
            padding: 25px; 
            border: 1px solid #f1f1f1; 
        }

        /* Badge الحالة باللون البرتقالي */
        .bg-orange { background-color: #ff9800 !important; color: #fff !important; font-weight: bold; border-radius: 8px; }

        /* الـ Stepper المطور */
        .order-stepper { 
            display: flex !important; 
            justify-content: space-between; 
            margin: 40px 0 20px; 
            position: relative; 
            padding: 0;
        }
        .order-stepper::before { 
            content: ""; 
            position: absolute; 
            top: 22px; 
            left: 10%; 
            right: 10%; 
            height: 2px; 
            background: #eee; 
            z-index: 1; 
        }
        .step-item { flex: 1; text-align: center; position: relative; z-index: 2; }
        .step-icon { 
            width: 45px; height: 45px; background: #fff; border: 2px solid #eee; 
            border-radius: 50%; display: flex !important; align-items: center; 
            justify-content: center; margin: 0 auto 10px; color: #ccc;
            transition: all 0.3s ease; font-size: 18px;
        }

        /* حالات الـ Stepper (برتقالي) */
        .step-item.completed .step-icon { background: #ff9800 !important; border-color: #ff9800 !important; color: #fff !important; }
        .step-item.active .step-icon { border-color: #ff9800; color: #ff9800; background: #fff; box-shadow: 0 0 10px rgba(255,152,0,0.2); }
        .step-item.completed .step-label { color: #ff9800; font-weight: bold; }
        .step-label { font-size: 11px; color: #888; white-space: nowrap; }

        /* تفاصيل الأصناف */
        .place-section { margin-top: 20px; border-top: 1px solid #f9f9f9; padding-top: 15px; }
        .place-name { font-weight: bold; color: #444; margin-bottom: 15px; display: flex !important; align-items: center; gap: 8px; }
        
        .item-box { 
            display: flex !important; 
            align-items: center; 
            padding: 15px 0; 
            border-bottom: 1px solid #f8f8f8; 
        }
        /* ستايل إضافي لتمييز أسطر الإضافات بالخلفية وإزاحة بسيطة للداخل */
        .item-box.extra-row {
            background-color: #fafafa;
            padding-right: 15px;
            border-right: 3px solid #28a745;
        }
        .item-img { width: 65px; height: 65px; border-radius: 12px; object-fit: cover; margin-left: 15px; border: 1px solid #eee; }
        .item-details { flex-grow: 1;}
        .item-title { font-weight: bold; color: #333; margin-bottom: 4px; font-size: 14px; }
        .item-meta { font-size: 12px; color: #999; }
        
       
        .item-qty { font-size: 12px; color: #666; display: block; }
        .item-price { color: #ff9800; font-weight: 800; font-size: 14px; display: block; margin-top: 4px; }

        /* ملخص الحساب */
        .summary-row { display: flex !important; justify-content: space-between; padding: 8px 0; font-size: 14px; color: #666; }
        .total-row { 
            margin-top: 15px; 
            padding-top: 15px; 
            border-top: 2px dashed #eee; 
            font-weight: 900; 
            font-size: 18px; 
            color: #333; 
        }
        .total-row span:last-child { color: #ff9800; }

        /* أيقونة المتجر */
        .fa-store-orange { color: #ffc107; }

        /* لون مخصص للأيقونات الفرعية الجديدة */
        .text-orange { color: #ff9800 !important; }
        
        /* كلاس لإظهار الوقت تحت عنوان الخطوة في الستيبير */
        .step-time-label { display: block; font-size: 9px; color: #aaa; margin-top: 2px; font-weight: normal; }
        .step-item.completed .step-time-label { color: #f57c00; }
        
        /* تنسيق مخصص لسطر الملاحظات لتظهر بشكل مميز داخل كرت الصنف */
        .item-notes {
            background-color: #fff9e6;
            padding: 4px 10px;
            border-radius: 6px;
            display: inline-block;
            border: 1px solid #ffe699;
        }
    </style>

    <script type="text/javascript">
        var countdownInterval;
        function initCountdown() {
            clearInterval(countdownInterval);
            var hfSeconds = document.getElementById('hfSecondsLeft');
            if (hfSeconds) {
                var secondsLeft = parseInt(hfSeconds.value);
                if (!isNaN(secondsLeft) && secondsLeft > 0) {
                    countdownInterval = setInterval(function () {
                        secondsLeft--;
                        hfSeconds.value = secondsLeft;
                        
                        if (secondsLeft <= 0) {
                            clearInterval(countdownInterval);
                            document.getElementById('countdownTimer').innerHTML = "00:00";
                            __doPostBack('<%= tmrRefresh.UniqueID %>', '');
                        } else {
                            var mins = Math.floor(secondsLeft / 60);
                            var secs = secondsLeft % 60;
                            document.getElementById('countdownTimer').innerHTML = 
                                (mins < 10 ? "0" + mins : mins) + ":" + (secs < 10 ? "0" + secs : secs);
                        }
                    }, 1000);
                }
            }
        }

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            initCountdown();
        });
        
        window.onload = function () {
            initCountdown();
        };
    </script>
</asp:Content>