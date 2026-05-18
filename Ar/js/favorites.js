/**
 * Favorites Management System
 * Standardizes shop favorites across the platform.
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

    const icon = element.querySelector('i');

    if (index === -1) {
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
        if (icon) {
            icon.classList.remove('fa-regular');
            icon.classList.add('fa-solid');
        }
        element.classList.add('is-favorite');
        
        // Add animation
        element.style.transform = 'scale(1.2)';
        setTimeout(() => {
            element.style.transform = '';
        }, 200);

    } else {
        // Remove from favorites
        favorites.splice(index, 1);
        if (icon) {
            icon.classList.remove('fa-solid');
            icon.classList.add('fa-regular');
        }
        element.classList.remove('is-favorite');

        // Add animation
        element.style.transform = 'scale(0.8)';
        setTimeout(() => {
            element.style.transform = '';
        }, 200);

        // If we are on the favorites page (Favorites.aspx), remove the card immediately
        if (window.location.pathname.toLowerCase().includes('favorites.aspx')) {
            const card = element.closest('.availableShop');
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

    saveFavorites(favorites);
}

function initFavorites() {
    const favorites = getFavorites();
    const heartIcons = document.querySelectorAll('.favorite-heart');
    
    heartIcons.forEach(heart => {
        const shopId = heart.getAttribute('data-id');
        const icon = heart.querySelector('i');
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
