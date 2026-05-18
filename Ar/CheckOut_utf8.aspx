<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="CheckOut.aspx.cs" Inherits="Ar_CheckOut" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <title><asp:Literal ID="ltPageTitle" runat="server" Text="<%$ Resources:texts, CheckoutTitle %>" ></asp:Literal></title>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="loader" class="loader-overlay">
       <div class="loader-box">
        <div class="spinner"></div>
        <asp:Literal ID="ltLoaderText" runat="server" Text="<%$ Resources:texts, LoaderText %>" />
    </div>
</div>

    <style>
        .loader-overlay {
    display: none ;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.25);
    backdrop-filter: blur(2px);
    z-index: 9999;
    align-items: center;
    justify-content: center;
}

.loader-box {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 25px 35px;
    background: #ffffff;
    border-radius: 14px;
    box-shadow: 0 5px 25px rgba(0,0,0,0.2);
}

.spinner {
    width: 65px;
    height: 65px;
    border: 6px solid #ddd;
    border-top-color: #3498db;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}

.loader-text {
    margin-top: 15px;
    font-size: 18px;
    color: #333;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

    </style>
    <asp:HiddenField ID="hfAddId" runat="server" />
        <section class="checkoutDetails">
        <div class="checkoutContainer">
            <span class="route"> <a href="default.aspx"><asp:Literal ID="ltHome" runat="server" Text="<%$ Resources:texts, Home %>" /></a> <i class="fa-solid fa-angles-left"></i>
                <a href="./openedShopFoods.html"><span id="location"></span></a>
                <i class="fa-solid fa-angles-left"></i>  <asp:Literal ID="ltExecuteOrderRoute" runat="server" Text="<%$ Resources:texts, ExecuteOrder %>" />
        </span>
             <div id="checkoutCart">
            <article class="checkoutBox">
                <div class="checkoutBoxTitle">
                    <h2><asp:Literal ID="ltOrderDetailsTitle" runat="server" Text="<%$ Resources:texts, OrderDetailsTitle %>" /></h2>
                    <a href="shopPage.html"><asp:Literal ID="ltEditOrder" runat="server" Text="<%$ Resources:texts, EditOrder %>" /></a>
                </div>
                <div class="orderInfo">
                    <h3>هارت أتاك</h3>
                    <div class="orderLabels">
                        <span class="orderName"><asp:Literal ID="ltItem" runat="server" Text="<%$ Resources:texts, Item %>" /></span>
                        <span class="specialOrder"><asp:Literal ID="ltSpecialOrder" runat="server" Text="<%$ Resources:texts, SpecialOrder %>" /></span>
                        <span><asp:Literal ID="ltQuantity" runat="server" Text="<%$ Resources:texts, Quantity %>" /></span>
                        <span><asp:Literal ID="ltPrice" runat="server" Text="<%$ Resources:texts, Price %>" /></span>
                        <span><asp:Literal ID="ltTotal" runat="server" Text="<%$ Resources:texts, Total %>" /></span>
                    </div>
                    <div class="orderStats">
                        <span class="orderName">عرض كينج اتاك <span class="specialOrder">حار</span></span>
                        <span class="specialOrder"><asp:Literal ID="ltSpecialOrder2" runat="server" Text="<%$ Resources:texts, SpecialOrder %>" /></span>
                        <span>1</span>
                        <span>200.00 ج.م</span>
                        <span>200.00 ج.م</span>
                    </div>
                </div>
            </article>
        </div>

            <article class="checkoutBox">
            <div class="checkoutBoxTitle">
                <h2><asp:Literal ID="ltDeliveryAddress" runat="server" Text="<%$ Resources:texts, DeliveryAddress %>" /></h2>
                <div class="checkoutLocationBtns">
                    <button id="locbtn" class="submit" type="button">
                        <asp:Literal ID="ltAddEditAddress" runat="server" Text="<%$ Resources:texts, AddEditAddress %>" />
                    </button>
                </div>
            </div>
            <div class="checkoutLocation">
                <span id="emptyCheckoutLocation">
                    <asp:Literal ID="ltChooseDeliveryLocation" runat="server" Text="<%$ Resources:texts, ChooseDeliveryLocation %>" />
                </span>
                <div class="checkoutSelectedLocation">
                    <p class="card-text"><strong><asp:Literal ID="ltAddress" runat="server" Text="<%$ Resources:texts, Address %>" />:</strong><span id="AddName"></span></p>
                    <p class="card-text"><strong><asp:Literal ID="ltMobile" runat="server" Text="<%$ Resources:texts, Mobile %>" />:</strong><span id="mobile"></span></p>
                    <p class="card-text"><strong><asp:Literal ID="ltPhone" runat="server" Text="<%$ Resources:texts, Phone %>" />:</strong><span id="phone"></span></p>
                    <p class="card-text">
                        <strong><asp:Literal ID="ltStreet" runat="server" Text="<%$ Resources:texts, Street %>" />:</strong><span id="StreetName"></span>,
                        <strong><asp:Literal ID="ltBuilding" runat="server" Text="<%$ Resources:texts, Building %>" />:</strong><span id="Build"></span>,
                        <strong><asp:Literal ID="ltFloor" runat="server" Text="<%$ Resources:texts, Floor %>" />:</strong><span id="Floor"></span>,
                        <strong><asp:Literal ID="ltApartment" runat="server" Text="<%$ Resources:texts, Apartment %>" />:</strong><span id="AdepartmentNo"></span>
                    </p>
                    <p class="card-text"><strong><asp:Literal ID="ltGovernorate" runat="server" Text="<%$ Resources:texts, Governorate %>" />:</strong><span id="Gov"></span>,
                       <strong><asp:Literal ID="ltArea" runat="server" Text="<%$ Resources:texts, Area %>" />:</strong><span id="Area"></span></p>
                    <p class="card-text"><strong><asp:Literal ID="ltInstructions" runat="server" Text="<%$ Resources:texts, Instructions %>" />:</strong><span id="Instructions"></span></p>
                    <p class="card-text"><strong><asp:Literal ID="ltAddressType" runat="server" Text="<%$ Resources:texts, AddressType %>" />:</strong><span id="AType"></span></p>
                </div>
            </div>
        </article>
              <article class="checkoutBox" id="payForOrder">
            <div class="checkoutBoxTitle">
                <h2><asp:Literal ID="ltPaymentDetailsTitle" runat="server" Text="<%$ Resources:texts, PaymentDetailsTitle %>" /></h2>
            </div>
            <div class="paymentSection">
                <span id="discountWaring">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <asp:Literal ID="ltPaymentWarning" runat="server" Text="<%$ Resources:texts, PaymentWarning %>" />
                </span>
                <button id="btnSaveStorage" type="button" class="submit">
                    <asp:Literal ID="ltExecuteOrderButton" runat="server" Text="<%$ Resources:texts, ExecuteOrder %>" />
                </button>
            </div>
        </article>

        </div>

    </section>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageScripts" Runat="Server">
    <style>
    .checkoutDetails {
        padding-top: 120px;
        padding-bottom: 50px;
        padding-inline: 1rem;
        display: flex;
        justify-content: center;
        align-items: center;

        .submit {
            margin: 0;
            padding: 0.25rem 1rem;
            max-width: fit-content;
        }
    }

    .checkoutContainer {
        max-width: 1024px;
        width: 100%;
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .checkoutBox {
        border-radius: 0.25rem;
        border: 1px solid rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
    }

    .checkoutBoxTitle {
        display: flex;
        align-items: center;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        column-gap: 1rem;
        row-gap: 0.25rem;
        flex-wrap: wrap;
        justify-content: space-between;
        padding: 0.5rem 1rem;

        a {
            color: var(--fd-blue);
        }
    }

    .orderInfo {
        display: flex;
        flex-direction: column;
        overflow-x:auto;
        gap: 0.5rem;
        padding: 1rem;
    }

    .removeItem{
        width: 30px;
        height: 30px;
        border-radius: 0.25rem !important;
        transition: var(--transition);
        border: 2px solid red;
        grid-column: span 1 !important;
        justify-self: center;
        align-self: center;

        &:hover{
            background-color: transparent;
            color: red;
        }
    }


    .orderLabels,
    .orderStats {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        padding-inline: 0.25rem;
        text-align: center;
        gap: 0.5rem;
        min-width: 400px;

        span {
            display: flex;
            flex-direction: column;
            line-height: 1;
            justify-content: center;
            padding: 0.5rem 0;
        }
    }

    .orderLabels {
        background-color: #f8f9fa;
    }


    .orderStats {
        font-size: 0.9rem;


        .specialOrder {
            color: rgba(0, 0, 0, 0.5);
        }


    }

    .orderName {
        grid-column: span 2 ;
        text-align: start ;
    }

    .checkoutLocation {
        padding: 1rem;
    }

    #emptyCheckoutLocation {
        cursor: pointer;
        color: var(--fd-blue);
        font-weight: bold;
        font-size: 0.9rem;
    }

    .checkoutSelectedLocation {
        line-height: 1;
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
        font-weight: bold;

        p,
        span {
            color: rgba(0, 0, 0, 0.75);
            font-weight: normal;
        }
    }

    .paymentSection {
        padding: 1rem;
        display: flex;
        flex-direction: column;
        gap: 1rem;
        .inputHolder{
            flex-direction: column;
            display: flex;
            background:none ;
        }
        label{
            font-size: 0.9rem;
        }
        input,select{
            border: 1px solid rgba(0, 0, 0, 0.1);
            padding: 0.25rem 1rem;
            border-radius: 0.25rem;
        }
    }

    #discountWaring {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.9rem;
        padding: 0.5rem 1rem;
        background-color: #E5E7FF;

        i {
            font-size: 1.25rem;
            color: var(--fd-blue);
        }
    }


#creditCardDetails{
    padding: 1.5rem 1rem;
    display: flex;
    flex-direction: column;
    gap: 1rem;
}
    .paymentDetails {
        display: grid;
        grid-template-columns: 57.5% 40%;
        gap: 2.5%;
    }

    .credit {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .creditInfo {
        display: flex;
        border-color: var(--fd-blue);

        .checkoutBoxTitle {
            gap: 0.5rem;
            justify-content: start;
            border-color: var(--fd-blue);

            img {
                width: 35px;
                object-fit: contain;
            }

        }
    }

    .secretNumber{
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
        align-items: end;
        img{
            width: 100px;
            object-fit: contain;
        }
    }

    .saveDetails{
        display: flex;
        gap: 0.25rem;
        font-size: 0.9rem;
        align-items: center;
        input{
            scale: 1;
        }
    }
    .termsAndConditions{
        font-size: 0.9rem;
        font-weight: bold;
        span{
            color: var(--fd-blue);
            cursor: pointer;
        }
    }

    #cartHolder {
        display: flex;
        flex-direction: column;
        border-radius: 0.5rem;
        overflow: hidden;
        max-width: 600px;
        width: 100%;
        position: sticky;
        isolation: isolate;
        height: fit-content;
    }


    .shoppingCartTitle {
        background-color: var(--fd-blue);
        color: white;
        padding: 0.5rem;
    }


#checkoutCartItems{
     display: flex;
        flex-direction: column;
        gap: 1.5rem;
        justify-content: center;
        font-size: 1rem;
        background-color: white;
        font-weight: bold;
        line-height: 1.2;
        border: 1px solid rgba(0, 0, 0, 0.1);
        padding: 1rem ;
        border-bottom-left-radius: inherit;
        border-bottom-right-radius: inherit;
        .submit{
            font-weight: bold;
            max-width: 500px;
            margin: auto;
        }
}

.orderedItem{
    display: flex;
    gap: 0.5rem;
    border-top: 1px solid rgba(0, 0, 0, 0.1);
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);

    padding:1rem 0.5rem;
    font-size: 0.75rem;
    align-items: center;
    justify-content: space-between;
    background-color: #f8f9fa;
}




.preDeliveryFeeAmount,.deliveryAmount,.afterDeliveryFeeAmount{
    display: flex;
    gap: 1rem;
    justify-content: space-between;
    align-items: center;
    padding-inline: 0.5rem;
    font-size: 0.9rem;
    p{
        display: flex;
        gap: 2px;
        align-items: center;
    }
}

.totalAmount{
    white-space: nowrap;
}

.checkoutLocationBtns{
    display: flex;
    gap: 0.5rem;
    align-items: center;
    flex-wrap: wrap;
}

.checkoutBox#payForOrder .submit{
    margin: auto;
    width: 100%;
    max-width: 400px;
    justify-content: center;
    text-align: center;
}

#checkoutCart{
    display: flex;
    flex-direction: column;
    gap: 1rem;
}
</style>
     <link href="css/css_web.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>

        document.getElementById('btnSaveStorage').addEventListener('click', function () {

            let data = localStorage.getItem("cartItems");
            let raw = document.getElementById("Deliverycost").textContent;

            // تنظيف الرقم
            raw = raw.replace(/[^\d.]/g, "");
            raw = raw.replace(/\.$/, "");
            let deliveryCost = raw.trim();

            if (!data) {
                Swal.fire({
                    title: "السلة فارغة",
                    icon: "warning"
                });
                return;
            }
            $("#loader").css("display", "flex");
            let saveUrl = '<%= ResolveUrl("~/Ar/SaveLocalStorage.aspx/SaveLocalStorage") %>';
            fetch(saveUrl, {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({
                    cart: data,
                    action: "update",
                    id: 1,
                    deliveryCost: deliveryCost
                })
            })
            .then(res => res.json())
            .then(result => {
                if (result.d.success) {
                    localStorage.removeItem("cartItems");
                    $("#loader").hide();
                    Swal.fire({
                        title: "تم ارسال طلبكم بنجاح فى انتظار التنفيذ",
                        text: result.d.Message || "",
                        icon: "success",
                        confirmButtonText: "متابعة"
                    }).then(sw => {
                        if (sw.isConfirmed) {
                            window.location.href = "POrders.aspx";
                        }
                    });

                } else {
                    $("#loader").hide();
                    Swal.fire({
                        title: "خطأ",
                        text: result.d.error,
                        icon: "error"
                    });
                    console.error("Error:", result.d.error);
                }
            })
            .catch(err => {
                $("#loader").hide();
                console.error(err);
                Swal.fire({
                    title: "خطأ في الاتصال",
                    text: "حدثت مشكلة أثناء تنفيذ العملية",
                    icon: "error"
                });
            });
        });

</script>
    <script>
        document.getElementById('locbtn').addEventListener('click', function () {
    // هنا حط رابط الصفحة اللي عايز تظهرها
    document.getElementById('locationIframe').src = 'AddAddress.aspx';
    var myModal = new bootstrap.Modal(document.getElementById('locationModal'));
    myModal.show();
});
</script>
    <div class="modal fade" id="locationModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">اختر موقعك</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body p-2">
        <iframe id="locationIframe" src="AddAddress.aspx"
                style="width:100%; height:85dvh; min-height: 500px; border:none; -webkit-overflow-scrolling: touch;"></iframe>
      </div>
    </div>
  </div>
</div>

    <script>
var locationModal = document.getElementById('locationModal');

locationModal.addEventListener('hidden.bs.modal', function () {
    // يعيد تحميل الصفحة
    location.reload();
});
</script>

</asp:Content>

