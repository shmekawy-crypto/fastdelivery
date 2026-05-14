<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Favorites.aspx.cs" Inherits="Ar_Favorites" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <asp:Literal ID="litPageTitle" runat="server" Text="<%$ Resources: texts, nav_favorites %>"></asp:Literal>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section id="userDashboard">
    <div class="userProfileField">
        <span class="route">
            <a href="default.aspx"><asp:Literal ID="litHome" runat="server" Text="<%$ Resources: texts, Home %>"></asp:Literal></a>
            <i class="fa-solid fa-angles-left"></i>
            <asp:Literal ID="litAccount" runat="server" Text="<%$ Resources: texts, nav_favorites %>"></asp:Literal>
        </span>

        <div class="profile-head">
            <asp:Literal ID="litProfileHead" runat="server" Text="<%$ Resources: texts, nav_favorites %>"></asp:Literal>
            <i id="dropDownBtn" class="fa-solid fa-angles-down"></i>
        </div>

        <article class="profileContainer">
            <ul class="profileSettings">
                <li><a href="profile.aspx"><asp:Literal ID="litAccountInfo" runat="server" Text="<%$ Resources: texts, AccountInfo %>"></asp:Literal></a></li>
                <li class="active"><a href="Favorites.aspx"><asp:Literal ID="litFav" runat="server" Text="<%$ Resources: texts, nav_favorites %>"></asp:Literal></a></li>
                <li><a href="Addresses.aspx"><asp:Literal ID="litAddresses" runat="server" Text="<%$ Resources: texts, Addresses %>"></asp:Literal></a></li>
                <li><a href="POrders.aspx"><asp:Literal ID="litOrders" runat="server" Text="<%$ Resources: texts, Orders %>"></asp:Literal></a></li>
            </ul>

            <div class="Uform">
                <div class="dataField" id="favoritesContainer">
                    <h3 style="text-align:center; padding: 20px;">Loading favorites...</h3>
                </div>
            </div>
        </article>
    </div>
</section>
<script>
function generateStars(rating) {
    let starsHtml = '';
    const r = parseInt(rating) || 0;
    for (let i = 1; i <= 5; i++) {
        if (i <= r) {
            starsHtml += `<i class="fa-solid fa-star" style="color:#FFD700; font-size: 0.8rem;"></i>`;
        } else {
            starsHtml += `<i class="fa-regular fa-star" style="color:#FFD700; font-size: 0.8rem;"></i>`;
        }
    }
    return starsHtml;
}

function loadFavorites() {
    const favorites = JSON.parse(localStorage.getItem('favoriteShops') || '[]');
    const container = document.getElementById('favoritesContainer');
    const isEn = document.documentElement.lang === 'en';

    if (favorites.length === 0) {
        const emptyMsg = isEn ? 'No favorite shops found.' : '\u0644\u0645 \u064A\u062A\u0645 \u0627\u0644\u0639\u062B\u0648\u0631 \u0639\u0644\u0649 \u0645\u062D\u0644\u0627\u062A \u0645\u0641\u0636\u0644\u0629.';
        container.innerHTML = `<h3 style="text-align:center; padding: 20px;">${emptyMsg}</h3>`;
        return;
    }

    container.innerHTML = '<div class="allAvailableShops" style="width:100%;"></div>';
    const list = container.querySelector('.allAvailableShops');

    favorites.forEach(shop => {
        // Sanitize data: remove any characters outside common ASCII and Arabic ranges
        const sanitize = (str) => {
            if (typeof str !== 'string') return str || '';
            return str.replace(/[^\u0000-\u007F\u0600-\u06FF\s\d.,:-]/g, '').trim();
        };

        const formatPrice = (price) => {
            const p = parseFloat(price);
            return isNaN(p) ? (price || '0.00') : p.toFixed(2);
        };

        const name = sanitize((isEn && shop.nameEn) ? shop.nameEn : shop.name) || (isEn ? 'Unnamed Shop' : '\u0645\u062D\u0644 \u0628\u062F\u0648\u0646 \u0627\u0633\u0645');
        const desc = sanitize((isEn && shop.descEn) ? shop.descEn : shop.desc) || '';
        const statusClass = shop.isOpened == "1" ? "status-badge open" : "status-badge closed";

        // Unicode escapes for Arabic:
        // Open: \u0645\u0641\u062A\u0648\u062D
        // Closed: \u0645\u063A\u0644\u0642
        const statusText = shop.isOpened == "1" ? (isEn ? "Open" : "\u0645\u0641\u062A\u0648\u062D") : (isEn ? "Closed" : "\u0645\u063A\u0644\u0642");

        // Fix image path if needed
        let imgSrc = shop.img || 'images/placeholderImage.webp';
        if (imgSrc.startsWith('~/ar/')) imgSrc = imgSrc.replace('~/ar/', '');
        else if (imgSrc.startsWith('~/')) imgSrc = imgSrc.replace('~/', '');

        const card = `
            <div class="availableShop" style="width:100%; cursor:pointer;" onclick="window.location.href='${shop.url}'">
                <div class="shop-img-wrapper" style="position: relative; width: 120px; height: 120px; flex-shrink: 0;">
                    <img src="${imgSrc}" onerror="this.src='images/placeholderImage.webp'" style="width:100%; height:100%; border-radius:0.5rem; object-fit:cover;" />
                    <div class="favorite-heart is-favorite"
                         onclick="toggleFavorite(event, this)"
                         data-id="${shop.id}">
                        <i class="fa-solid fa-heart"></i>
                    </div>
                </div>
                <div class="availableShopDesc" style="flex:1;">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <h3 class="availableShopName">${name}</h3>
                        <span class="${statusClass}">${statusText}</span>
                    </div>
                    <div class="shopRating" style="margin-block: 10px;">
                        ${generateStars(shop.rate)}
                    </div>
                    <p class="shopFoods">${desc}</p>
                    <div class="shopDelivery">
                        <span class="deliveryTime">${isEn ? 'Receive in' : '\u064A\u0635\u0644 \u062E\u0644\u0627\u0644'} <span class="timer">${sanitize(shop.deliveryTime) || '--'}</span> ${isEn ? 'minutes' : '\u062F\u0642\u064A\u0642\u0629'}</span>
                        <span class="deliveryPayment">${isEn ? 'Delivery' : '\u0627\u0644\u062A\u0648\u0633\u064A\u0644'}: <span class="deliveryPaymentAmount">${formatPrice(sanitize(shop.deliveryCost))}</span> ${isEn ? 'EGP' : '\u062C.\u0645'}</span>
                    </div>
                </div>
            </div>
        `;
        list.insertAdjacentHTML('beforeend', card);
    });
}

function toggleFavorite(event, element) {
    event.preventDefault();
    event.stopPropagation();

    const shopId = element.getAttribute('data-id');
    let favorites = JSON.parse(localStorage.getItem('favoriteShops') || '[]');
    const index = favorites.findIndex(f => f.id === shopId);

    if (index !== -1) {
        // Remove from favorites
        favorites.splice(index, 1);
        localStorage.setItem('favoriteShops', JSON.stringify(favorites));
        // Refresh the list
        loadFavorites();
    }
}

document.addEventListener('DOMContentLoaded', loadFavorites);
</script>

<style>

.allAvailableShops {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 20px;
}
.availableShop {
    display: flex;
    /* flex-wrap: wrap; */
    gap: 1rem !important;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    padding-bottom: 1rem;
    transition: background 0.3s;
}
.availableShop:hover {
    background: #f9f9f9;
}
.availableShopName {
    font-size: 1.2rem;
    font-weight: bold;
    color: var(--fd-blue);
    margin: 0;
}
.shopFoods {
    font-size: 0.9rem;
    color: #666;
    margin: 5px 0;
}
.shopDelivery {
    display: flex;
    gap: 1rem;
    font-size: 0.85rem;
    color: #444;
}
.status-badge {
    padding: 4px 12px;
    border-radius: 2rem;
    font-size: 0.75rem;
    font-weight: 700;
    display: inline-block;
}
.status-badge.open {
    background: #e8f5e9;
    color: #2e7d32;
    border: 1px solid #c8e6c9;
}
.status-badge.closed {
    background: #ffebee;
    color: #c62828;
    border: 1px solid #ffcdd2;
}
@media (max-width:480px){
    .availableShop{
        flex-direction: column;
        gap: 0.3rem !important;
    }
    .shop-img-wrapper{
        margin: auto;
    }
}
</style>
</asp:Content>
