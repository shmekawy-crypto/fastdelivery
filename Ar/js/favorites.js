/**
 * Favorites Management System
 * Standardizes shop favorites across the platform and synchronizes multi-button instances.
 */

const FAV_STORAGE_KEY = 'favoriteShops';

function getFavorites() {
    try {
        const favs = localStorage.getItem(FAV_STORAGE_KEY);
        return favs ? JSON.parse(favs) : [];
    } catch (e) {
        console.error('Error parsing favorites:', e);
        return [];
    }
}

function saveFavorites(favorites) {
    localStorage.setItem(FAV_STORAGE_KEY, JSON.stringify(favorites));
}

function toggleFavorite(event, element) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    const shopId = element.getAttribute('data-id');
    if (!shopId) return;

    let favorites = getFavorites();
    const index = favorites.findIndex(f => String(f.id) === String(shopId));
    const isAdding = index === -1;

    if (isAdding) {
        // Add to favorites
        // Collect as much data as possible for the favorites page
        const shopData = {
            id: shopId,
            name: element.getAttribute('data-name'),
            nameEn: element.getAttribute('data-name-en'),
            img: element.getAttribute('data-img') || element.getAttribute('data-image'), // Support both
            rate: element.getAttribute('data-rate') || element.getAttribute('data-rating') || '0',
            desc: element.getAttribute('data-desc') || '',
            descEn: element.getAttribute('data-desc-en') || '',
            deliveryTime: element.getAttribute('data-delivery-time') || '',
            deliveryCost: element.getAttribute('data-delivery-cost') || '0',
            isOpened: element.getAttribute('data-is-opened') || '0',
            url: element.getAttribute('data-url') || (element.closest('a') ? element.closest('a').href : window.location.href)
        };

        favorites.push(shopData);
    } else {
        // Remove from favorites
        favorites.splice(index, 1);
    }

    // --- CRITICAL FIX: Synchronize all heart buttons sharing this data-id ---
    const targetButtons = document.querySelectorAll(`.favorite-heart[data-id="${shopId}"], .fav-nav-icon[data-id="${shopId}"]`);

    targetButtons.forEach(btn => {
        const icon = btn.querySelector('i');

        // Ensure a smooth CSS transition runtime behavior
        btn.style.transition = 'transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275)';

        if (isAdding) {
            if (icon) {
                icon.classList.remove('fa-regular');
                icon.classList.add('fa-solid');
            }
            btn.classList.add('is-favorite');

            // Scaled pop animation
            btn.style.transform = 'scale(1.2)';
            setTimeout(() => {
                btn.style.transform = '';
            }, 200);
        } else {
            if (icon) {
                icon.classList.remove('fa-solid');
                icon.classList.add('fa-regular');
            }
            btn.classList.remove('is-favorite');

            // Shrink pop animation
            btn.style.transform = 'scale(0.8)';
            setTimeout(() => {
                btn.style.transform = '';
            }, 200);

            // If we are on the favorites page (Favorites.aspx), remove the card immediately
            if (window.location.pathname.toLowerCase().includes('favorites.aspx')) {
                const card = btn.closest('.availableShop');
                if (card) {
                    card.style.opacity = '0';
                    card.style.transform = 'scale(0.9)';
                    setTimeout(() => {
                        card.remove();
                        if (document.querySelectorAll('.availableShop').length === 0) {
                            location.reload(); // Show empty state
                        }
                    }, 300);
                }
            }
        }
    });

    saveFavorites(favorites);
}

function handleNavFavorite(event, btn) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
    if (typeof window.toggleFavorite === 'function') {
        window.toggleFavorite(event, btn);
    } else if (typeof toggleFavorite === 'function') {
        toggleFavorite(event, btn);
    }
}

function initFavorites() {
    const navFavBtn = document.getElementById('favIconNav');
    if (navFavBtn) {
        // Check if we are on the PlaceShop page (by checking path or presence of shopId/shopHeartIcon)
        const isPlaceShop = window.location.pathname.toLowerCase().includes('placeshop.aspx') || !!document.getElementById('shopId');
        if (isPlaceShop) {
            const cardHeart = document.querySelector('[id$="shopHeartIcon"]') || document.getElementById('shopHeartIcon');

            let shopId = '', shopName = '', shopNameEn = '', shopImg = '', shopRate = '0', shopDesc = '', shopDescEn = '', deliveryTime = '', deliveryCost = '', isOpened = '';

            if (cardHeart) {
                shopId = cardHeart.getAttribute('data-id') || '';
                shopName = cardHeart.getAttribute('data-name') || '';
                shopNameEn = cardHeart.getAttribute('data-name-en') || '';
                shopImg = cardHeart.getAttribute('data-img') || '';
                shopRate = cardHeart.getAttribute('data-rate') || '0';
                shopDesc = cardHeart.getAttribute('data-desc') || '';
                shopDescEn = cardHeart.getAttribute('data-desc-en') || '';
                deliveryTime = cardHeart.getAttribute('data-delivery-time') || '';
                deliveryCost = cardHeart.getAttribute('data-delivery-cost') || '';
                isOpened = cardHeart.getAttribute('data-is-opened') || '';
            }

            // Fallback to DOM elements if not found on cardHeart
            if (!shopId) {
                shopId = document.getElementById('shopId')?.innerText.trim() || new URLSearchParams(window.location.search).get('id') || '';
            }
            if (!shopName) {
                shopName = document.getElementById('shopNameContent')?.innerText.trim() || document.querySelector('.availableShopName')?.innerText.trim() || '';
            }
            if (!shopImg) {
                shopImg = document.querySelector('.shop-profile-img')?.src || document.querySelector('.availableShop img')?.src || '';
            }
            if (!shopRate || shopRate === '0') {
                const raw = document.getElementById('rawRating')?.innerText.trim() || document.querySelector('.shopRating .rating-number')?.innerText.trim() || '0';
                shopRate = parseFloat(raw.replace(/[^\d.]/g, '') || '0').toFixed(1);
            }
            if (!shopDesc) {
                shopDesc = document.getElementById('shopFoodsContent')?.innerText.trim() || '';
            }
            if (!deliveryTime) {
                deliveryTime = document.querySelector('.timer')?.innerText.trim() || '';
            }
            if (!deliveryCost) {
                deliveryCost = document.getElementById('deliveryCostValue')?.innerText.trim() || document.getElementById('deliveryFee')?.innerText.trim() || '';
            }
            if (!isOpened) {
                isOpened = document.getElementById('isOpened')?.innerText.trim() || '';
            }

            if (shopId) {
                navFavBtn.setAttribute('data-id', shopId);
                navFavBtn.setAttribute('data-name', shopName);
                navFavBtn.setAttribute('data-name-en', shopNameEn || shopName);
                navFavBtn.setAttribute('data-img', shopImg);
                navFavBtn.setAttribute('data-rate', shopRate);
                navFavBtn.setAttribute('data-desc', shopDesc);
                navFavBtn.setAttribute('data-desc-en', shopDescEn || shopDesc);
                navFavBtn.setAttribute('data-delivery-time', deliveryTime);
                navFavBtn.setAttribute('data-delivery-cost', deliveryCost);
                navFavBtn.setAttribute('data-is-opened', isOpened);
                navFavBtn.setAttribute('data-url', window.location.href);

                // navFavBtn.classList.add('favorite-heart');
            }
        }
    }

    const favorites = getFavorites();
    // Select both the component layout hearts and navbar structural elements
    const heartIcons = document.querySelectorAll('.favorite-heart, .fav-nav-icon');

    heartIcons.forEach(heart => {
        const shopId = heart.getAttribute('data-id');
        const icon = heart.querySelector('i');
        if (!shopId) return;

        if (favorites.some(f => String(f.id) === String(shopId))) {
            heart.classList.add('is-favorite');
            if (icon) {
                icon.classList.remove('fa-regular');
                icon.classList.add('fa-solid');
            }
        } else {
            heart.classList.remove('is-favorite');
            if (icon) {
                icon.classList.remove('fa-solid');
                icon.classList.add('fa-regular');
            }
        }
    });
}

// Global initialization
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFavorites);
} else {
    initFavorites();
}
