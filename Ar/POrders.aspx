<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="POrders.aspx.cs" Inherits="Ar_POrders" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <asp:Literal runat="server" Text="<%$ Resources:texts, PageOtitle %>" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section id="userDashboard">
        <div class="userProfileField">
            <span class="route">
                <a href="default.aspx"><asp:Literal runat="server" Text="<%$ Resources:texts, Home %>" /></a>
                <i class="fa-solid fa-angles-left"></i>
                <asp:Literal ID="litMyAccount2" runat="server" Text="<%$ Resources:texts, MyAccount %>" />
            </span>
            <div class="profile-head">
                <asp:Literal ID="litMyAccount" runat="server" Text="<%$ Resources:texts, MyAccount %>"></asp:Literal>
                <i id="dropDownBtn" class="fa-solid fa-angles-down"></i>
            </div>
            <article class="profileContainer">
                <ul class="profileSettings">
                    <li><a href="profile.aspx"><asp:Literal ID="litAccountInfo" runat="server" Text="<%$ Resources: texts, AccountInfo %>"></asp:Literal></a></li>
                    <li><a href="Addresses.aspx"><asp:Literal ID="litAddresses" runat="server" Text="<%$ Resources: texts, Addresses %>"></asp:Literal></a></li>
                    <li class="active"><a href="POrders.aspx"><asp:Literal ID="litOrders" runat="server" Text="<%$ Resources: texts, Orders %>"></asp:Literal></a></li>
                </ul>

                <article class="orderHistory">
                    <div id="noPreviousOrders" runat="server" visible="false">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <p><asp:Literal runat="server" Text="<%$ Resources:texts, NoOrders %>" /></p>
                    </div>

                    <div class="orderDates">
                        <h2><asp:Literal runat="server" Text="<%$ Resources:texts, Orecords %>" /></h2>
                        <div class="dateFilters">
                            <span class="active"><asp:Literal runat="server" Text="<%$ Resources:texts, Today %>" /></span>
                            <span><asp:Literal runat="server" Text="<%$ Resources:texts, Yesterday %>" /></span>
                            <span><asp:Literal runat="server" Text="<%$ Resources:texts, Last7 %>" /></span>
                            <span><asp:Literal runat="server" Text="<%$ Resources:texts, LastMonth %>" /></span>
                            <span><asp:Literal runat="server" Text="<%$ Resources:texts, LastYear %>" /></span>
                        </div>

                        <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
    <ItemTemplate>
        <article class="previousOrder" onclick='<%# "window.location.href=\"OrderDetails.aspx?orderId=" + Eval("OrderID") + "\";" %>'>
            <div class="previousOrderMain">
                <div class="shopIcon">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <div class="previousOrderDetails">
                    
                    <%-- تظهر هذه الكلمة فقط إذا كان الطلب من أكثر من مطعم --%>
                    <%# Convert.ToInt32(Eval("PlacesCount")) > 1 ? "<span class='multi-tag'>طلب مشترك</span>" : "" %>

                    <asp:Repeater ID="rptPlaces" runat="server">
                        <ItemTemplate>
                            <div class="place-group">
                                <h3 class="shopName"><%# Eval("PlaceName") %></h3>
                                <p class="orderedItemSummary"><%# Eval("PlaceItems") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <p class="deliveryLocation">
                        <i class="fa-solid fa-location-dot"></i> <%# Eval("AddressName") %>
                    </p>
                </div>
            </div>
            <div class="previousOrderAction">
                <div class="priceAndDate">
                    <h3 class="orderedItemPrice">
                        <%# Decimal.Parse(Eval("TotalPrice").ToString()).ToString("0.##") %> 
                        <asp:Literal runat="server" Text="<%$ Resources: texts, Currency %>"></asp:Literal>
                    </h3>
                    <p class="orderDate">
                        <i class="fa-regular fa-calendar"></i> <%# Convert.ToDateTime(Eval("Odate")).ToString("yyyy/MM/dd") %>
                    </p>
                </div>
                <button type="button" class="viewDetailsBtn">
                    <asp:Literal runat="server" Text="<%$ Resources:texts, OrderDetailsTitle %>" />
                    <i class="fa-solid fa-chevron-left"></i>
                </button>
            </div>
        </article>
    </ItemTemplate>
</asp:Repeater>
                    </div>
                </article>
            </article>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageScripts" Runat="Server">
    <style>
        /* [نفس الستايلات القديمة مع إضافة التعديلات التالية] */
        section#userDashboard { display: flex; justify-content: center; align-items: center; padding-inline: 25px; }
        .userProfileField { padding: 25px; padding-top: 120px; margin-bottom: 25px; max-width: 1024px; width: 100%; margin-inline: auto; box-shadow: var(--shadow); border-radius: 0.5rem; }
        .profile-head { display: flex; align-items: center; justify-content: space-between; font-size: 2rem; font-weight: bold; }
        .profileContainer { display: grid; grid-template-columns: 20% 80%; margin-top: 20px; padding: 25px 0px; border-top: 1px solid rgba(0, 0, 0, 0.2); }
        .profileSettings { list-style-type: none; border-left: 1px solid rgba(0, 0, 0, 0.2); height: fit-content; position: sticky; top: 100px; }
        .profileSettings li { padding: 10px; transition: 0.3s color ease; }
        .profileSettings li.active { border-right: 2px solid var(--fd-blue); }
        .profileSettings li.active a { color: var(--fd-blue); }
        
        .previousOrder { display: flex; justify-content: space-between; align-items: center; padding: 1.25rem; gap: 1.5rem; background-color: #fff; border: 1px solid #eee; border-radius: 1rem; margin-bottom: 1rem; transition: all 0.3s ease; cursor: pointer; }
        .previousOrder:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,0,0,0.06); border-color: var(--fd-blue); }
        .previousOrderMain { display: flex; gap: 1.25rem; align-items: center; flex: 1; }
        .shopIcon { width: 60px; height: 60px; background-color: #f8f9fa; border-radius: 12px; display: flex; justify-content: center; align-items: center; font-size: 1.5rem; color: var(--fd-blue); }
        .shopName { font-size: 1.1rem; font-weight: 700; margin-bottom: 2px; display: flex; align-items: center; gap: 8px; }
        
        /* ستايل التاج الخاص بالطلب المشترك */
        .multi-tag { background: #e8f5e9; color: #2e7d32; font-size: 0.65rem; padding: 2px 8px; border-radius: 4px; font-weight: bold; border: 1px solid #c8e6c9; }
        
        .orderedItemSummary { font-size: 0.85rem; color: #666; max-width: 450px; white-space: normal; line-height: 1.4; }
        .orderedItemPrice { color: var(--fd-blue); font-weight: 800; font-size: 1.2rem; }
        .viewDetailsBtn { background-color: #f0f4ff; color: var(--fd-blue); border: none; padding: 10px 18px; border-radius: 10px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; }
        .place-group {
    border-bottom: 1px dashed #eee;
    padding-bottom: 8px;
    margin-bottom: 8px;
}
.place-group:last-child {
    border-bottom: none;
}
.shopName {
    color: var(--fd-blue);
    font-size: 1rem;
    margin-bottom: 2px;
}
.orderedItemSummary {
    color: #555;
    font-size: 0.85rem;
    padding-right: 10px;
}
.multi-tag {
    background-color: #e8f5e9;
    color: #2e7d32;
    font-size: 0.75rem;
    font-weight: bold;
    padding: 2px 10px;
    border-radius: 4px;
    border: 1px solid #c8e6c9;
    display: inline-block;
    margin-bottom: 8px;
}

.place-group {
    margin-bottom: 10px;
    border-right: 3px solid #eee; /* لإعطاء شكل جمالي بجانب كل مطعم */
    padding-right: 10px;
}

.place-group:last-of-type {
    border-right: none;
    margin-bottom: 5px;
}
        @media (max-width: 768px) {
            .profileContainer { grid-template-columns: 100%; }
            .profileSettings { display: none; }
            .previousOrder { flex-direction: column; align-items: flex-start; }
            .previousOrderAction { width: 100%; justify-content: space-between; border-top: 1px solid #eee; padding-top: 10px; }
            .orderedItemSummary { max-width: 100%; }
        }
    </style>
</asp:Content>