<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Favorites.aspx.cs" Inherits="Ar_Favorites" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <title><asp:Literal ID="litPageTitle" runat="server" Text="<%$ Resources: texts, nav_favorites %>"></asp:Literal></title>
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
    const r = parseFloat(rating) || 0;
    for (let i = 1; i <= 5; i++) {
        if (i <= r) {
            starsHtml += `<i class="fa-solid fa-star" style="color:#FFD700; font-size: 0.8rem;"></i>`;
        } else if (i - 0.5 <= r) {
            starsHtml += `<i class="fa-solid fa-star-half-stroke" style="color:#FFD700; font-size: 0.8rem;"></i>`;
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

    const filtered = favorites.filter(shop => shop.name || shop.nameEn);

    if (filtered.length === 0) {
        const emptyMsg = isEn ? 'No favorite shops found.' : '\u0644\u0645 \u064A\u062A\u0645 \u0627\u0644\u0639\u062B\u0648\u0631 \u0639\u0644\u0649 \u0645\u062D\u0644\u0627\u062A \u0645\u0641\u0636\u0644\u0629.';
        container.innerHTML = `<h3 style="text-align:center; padding: 20px;">${emptyMsg}</h3>`;
        return;
    }

    container.innerHTML = '<div class="allAvailableShops" style="width:100%;"></div>';
    const list = container.querySelector('.allAvailableShops');

    filtered.forEach(shop => {
        // Sanitize data: remove any characters outside common ASCII and Arabic ranges
        const sanitize = (str) => {
            if (typeof str !== 'string') return str || '';
            return str.replace(/[^\u0000-\u007F\u0600-\u06FF\s\d.,:-]/g, '').trim();
        };

        const formatPrice = (price) => {
            const p = parseFloat(price);
            return isNaN(p) ? (price || '0.00') : p.toFixed(2);
        };

        const name = sanitize((isEn && shop.nameEn) ? shop.nameEn : shop.name);
        const desc = sanitize((isEn && shop.descEn) ? shop.descEn : shop.desc) || '';
        const statusClass = shop.isOpened == "1" ? "status-badge open" : "status-badge closed";

        // Unicode escapes for Arabic:
        // Open: \u0645\u0641\u062A\u0648\u062D (مفتوح)
        // Closed: \u0645\u063A\u0644\u0642 (مغلق)
        const statusText = shop.isOpened == "1" ? (isEn ? "Open" : "\u0645\u0641\u062A\u0648\u062D") : (isEn ? "Closed" : "\u0645\u063A\u0644\u0642");

        // الـ Unicode المحدث هنا ليعني كلمة (خدمة توصيل) بدلاً من التوسيل القديمة
        // خدمة توصيل: \u062E\u062F\u0645\u0629\x20\u062A\u0648\u0635\u064A\u0644
        const deliveryLabel = isEn ? "Delivery" : "\u062E\u062F\u0645\u0629\x20\u062A\u0648\u0635\u064A\u0644";

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
                    <div class="shopRating" style="margin-block: 10px; display: flex; align-items: center; gap: 5px;">
                        ${generateStars(shop.rate)}
                        <span class="rating-number">(${parseFloat(shop.rate || 0).toFixed(1)})</span>
                    </div>
                    <p class="shopFoods">${desc}</p>
                    <div class="shopDelivery">
                        <span class="deliveryTime">${isEn ? 'Receive in' : '\u064A\u0635\u0644\x20\u062E\u0644\u0627\u0644'} <span class="timer">${sanitize(shop.deliveryTime) || '--'}</span> ${isEn ? 'minutes' : '\u062F\u0642\u064A\u0642\u0629'}</span>
                        <span class="deliveryPayment">${deliveryLabel}: <span class="deliveryPaymentAmount">${formatPrice(sanitize(shop.deliveryCost))}</span> ${isEn ? 'EGP' : '\u062C.\u0645'}</span>
                    </div>
                </div>
            </div>
        `;
        list.insertAdjacentHTML('beforeend', card);
    });
}

document.addEventListener('DOMContentLoaded', loadFavorites);
</script>>

<style>

.allAvailableShops {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
    padding: 10px;
}
.availableShop {
    display: flex !important;
    gap: 1rem !important;
    padding: 1.5rem !important;
    background: white !important;
    border-radius: 1.25rem !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    box-shadow: 0px 4px 15px rgba(0,0,0,0.05) !important;
    transition: all 0.3s ease !important;
    text-decoration: none !important;
    color: inherit !important;
}
.availableShop:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important;
    border-color: var(--fd-blue) !important;
}
.availableShopName {
    font-size: 1.4rem;
    font-weight: 800;
    color: #222;
    margin: 0;
}
.shopFoods {
    font-size: 0.95rem;
    color: #666;
    margin: 5px 0;
    line-height: 1.5;
}
.shopDelivery {
    display: flex;
    gap: 1.5rem;
    font-size: 0.85rem;
    color: #444;
    font-weight: 600;
    margin-top: 10px;
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

.favorite-heart {
    position: absolute;
    top: 5px;
    right: 5px;
    background: white;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    color: #ff4d4f;
    cursor: pointer;
}

@media (max-width:480px){
    .availableShop{
        flex-direction: column !important;
        gap: 0.5rem !important;
    }
    .shop-img-wrapper{
        width: 100% !important;
        height: 180px !important;
    }
    .availableShopName {
        font-size: 1.1rem;
    }
}
</style>
</asp:Content>
