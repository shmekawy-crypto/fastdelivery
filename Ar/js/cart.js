// ======= CART SYSTEM =======
let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
const totalItems = cartItems.reduce((sum, item) => sum + (item.amount || 0), 0);
const cartItemsNumber = document.querySelector("#cartItemsNumber");
if (totalItems > 0) {
    cartItemsNumber.textContent = totalItems;
    cartItemsNumber.style.display = "inline"; // or "block", depending on your layout
} else {
    cartItemsNumber.style.display = "none";
}
// ✅ Global Cart System — Runs on All Pages

document.addEventListener("DOMContentLoaded", () => {
    // Ensure texts object exists
    const texts = window.texts || {};

    // Helper to extract and clean timer values dynamically
    const getLiveDeliveryTime = () => {
        const timerEl = document.querySelector(".timer") || document.querySelector("[id*='timer']") || document.querySelector("[class*='timer']");
        const val = timerEl ? parseInt(timerEl.textContent.replace(/[^\d]/g, "")) : 0;
        return isNaN(val) ? 0 : val;
    };

    // Standardized Global values hydration (CamelCase standard + safe trim casts)
    const placeIdEl = document.querySelector("#placeId");
    const areaIdEl = document.querySelector("#areaId");
    const shopAreaIdEl = document.querySelector("#shopAreaId");
    const shopIdEl = document.querySelector("#shopId");
    const addidEl = document.querySelector("#addid") || document.querySelector("#addId");
    const actualShopNameEl = document.getElementById("shopNameContent") || 
                             document.querySelector(".availableShopName span") || 
                             document.querySelector(".availableShopName") || 
                             document.querySelector("#shopName");

    let GLOBAL_placeId = placeIdEl ? String(placeIdEl.textContent).trim() : String(localStorage.getItem("GLOBAL_placeId") || "").trim();
    let GLOBAL_areaId = areaIdEl ? String(areaIdEl.textContent).trim() : String(localStorage.getItem("GLOBAL_areaId") || "").trim();
    let GLOBAL_shopId = shopIdEl ? String(shopIdEl.textContent).trim() : String(localStorage.getItem("GLOBAL_shopId") || "").trim();
    let GLOBAL_shopAreaId = shopAreaIdEl ? String(shopAreaIdEl.textContent).trim() : String(localStorage.getItem("GLOBAL_shopAreaId") || "").trim();
    let GLOBAL_addId = addidEl ? String(addidEl.textContent).trim() : String(localStorage.getItem("GLOBAL_addId") || "").trim();
    let GLOBAL_shopName = actualShopNameEl ? String(actualShopNameEl.textContent).trim() : String(localStorage.getItem("GLOBAL_shopName") || "").trim();

    // Sync variables to localStorage if loaded from DOM
    if (placeIdEl) localStorage.setItem("GLOBAL_placeId", GLOBAL_placeId);
    if (areaIdEl) localStorage.setItem("GLOBAL_areaId", GLOBAL_areaId);
    if (shopIdEl) localStorage.setItem("GLOBAL_shopId", GLOBAL_shopId);
    if (shopAreaIdEl) localStorage.setItem("GLOBAL_shopAreaId", GLOBAL_shopAreaId);
    if (addidEl) localStorage.setItem("GLOBAL_addId", GLOBAL_addId);
    if (actualShopNameEl) localStorage.setItem("GLOBAL_shopName", GLOBAL_shopName);

    // Expose both standardized clean camelCase names and old uppercase/snake_case names to window for 100% backwards compatibility
    window.GLOBAL_placeId = GLOBAL_placeId;
    window.GLOBAL_PLACE_ID = GLOBAL_placeId;
    window.GLOBAL_areaId = GLOBAL_areaId;
    window.GLOBAL_AREA_ID = GLOBAL_areaId;
    window.GLOBAL_shopId = GLOBAL_shopId;
    window.GLOBAL_shop_ID = GLOBAL_shopId;
    window.GLOBAL_shopAreaId = GLOBAL_shopAreaId;
    window.GLOBAL_shopArea_ID = GLOBAL_shopAreaId;
    window.GLOBAL_addId = GLOBAL_addId;
    window.GLOBAL_addid_ID = GLOBAL_addId;
    window.GLOBAL_shopName = GLOBAL_shopName;

    // Area Discount Setup
    const areaDiscountEl = document.querySelector("#areaDiscountPercentage");
    let GLOBAL_AREA_DISCOUNT = areaDiscountEl
        ? parseFloat(areaDiscountEl.textContent.trim().replace("%", "")) || 0
        : parseFloat(localStorage.getItem("GLOBAL_AREA_DISCOUNT")) || 0;

    if (areaDiscountEl) {
        localStorage.setItem("GLOBAL_AREA_DISCOUNT", String(GLOBAL_AREA_DISCOUNT));
    }
    window.GLOBAL_AREA_DISCOUNT = GLOBAL_AREA_DISCOUNT;
    window.GLOBAL_DELIVERY_TIME = getLiveDeliveryTime();

    // Setup Delivery Fee with safe active-shop coupling
    let GLOBAL_DELIVERY_FEE = parseFloat(localStorage.getItem("GLOBAL_DELIVERY_FEE")) || 0;
    const deliveryFeeEl = document.querySelector("#deliveryFee");
    const deliveryCostValueEl = document.querySelector("#deliveryFee");
    if (deliveryFeeEl || deliveryCostValueEl) {
        let feeStr = "";
        if (deliveryFeeEl && deliveryFeeEl.textContent.trim() !== "" && parseFloat(deliveryFeeEl.textContent.trim()) > 0) {
            feeStr = deliveryFeeEl.textContent.trim();
        } else if (deliveryCostValueEl) {
            feeStr = deliveryCostValueEl.textContent.trim();
        }
        const fee = parseFloat(feeStr);
        if (!isNaN(fee)) {
            GLOBAL_DELIVERY_FEE = fee;
            localStorage.setItem("GLOBAL_DELIVERY_FEE", String(fee));
        }
    }
    window.GLOBAL_DELIVERY_FEE = GLOBAL_DELIVERY_FEE;

    const cart = {
        // Expose to window for global access with secure context binding
        initGlobal() {
            Object.keys(this).forEach(key => {
                if (typeof this[key] === 'function') {
                    this[key] = this[key].bind(this);
                }
            });
            window.cart = this;
        },

        items: (() => {
            // Self-healing load: sanitize any corrupted customization data from localStorage
            const raw = JSON.parse(localStorage.getItem("cartItems")) || [];
            const _fix = (src) => {
                if (!src) return [];
                if (Array.isArray(src)) return src;
                // Convert indexed-object {"0":{...}, "1":{...}} back to a proper array
                return Object.values(src).filter(x => x && typeof x === 'object' && x.id);
            };
            raw.forEach(item => {
                if (item.customization) {
                    item.customization.extras = _fix(item.customization.extras);
                    item.customization.upsells = _fix(item.customization.upsells);
                }
            });
            return raw;
        })(),

        get deliveryFee() {
            const activeShopId = String(document.querySelector("#shopId")?.textContent || "").trim();
            const domFee = parseFloat(document.querySelector("#deliveryFee")?.textContent.trim()) ||
                           parseFloat(document.querySelector("#deliveryCostValue")?.textContent.trim());

            if (activeShopId && !isNaN(domFee)) {
                return domFee;
            }
            if (activeShopId) {
                const item = this.items.find(i => String(i.shopId).trim() === activeShopId);
                if (item && item.deliveryFee !== undefined) return parseFloat(item.deliveryFee) || 0;
            }
            return parseFloat(localStorage.getItem("GLOBAL_DELIVERY_FEE")) || 0;
        },

        syncDeliveryFeeWithDOM() {
            const activeShopId = String(document.querySelector("#shopId")?.textContent || "").trim();
            const domFee = parseFloat(document.querySelector("#deliveryFee")?.textContent.trim()) ||
                           parseFloat(document.querySelector("#deliveryCostValue")?.textContent.trim());

            if (activeShopId && !isNaN(domFee)) {
                let updated = false;
                this.items.forEach(item => {
                    if (String(item.shopId).trim() === activeShopId) {
                        if (parseFloat(item.deliveryFee) !== domFee) {
                            item.deliveryFee = domFee;
                            updated = true;
                        }
                    }
                });
                if (updated) {
                    this.save();
                }
                localStorage.setItem("GLOBAL_DELIVERY_FEE", String(domFee));
            }
        },

        save() {
            localStorage.setItem("cartItems", JSON.stringify(this.items));
            this.saveSummary();
            this.initGlobal();
            if (typeof updateCartUI === 'function') {
                updateCartUI();
            }
            if (typeof updateCartCounter === 'function') {
                updateCartCounter();
            }
            if (typeof updateTotalPayAmount === 'function') {
                updateTotalPayAmount();
            }
            const checkoutCart = document.querySelector("#checkoutCart");
            if (checkoutCart && typeof renderCheckoutArticles === 'function') {
                renderCheckoutArticles(this.items, JSON.parse(localStorage.getItem("cartSummary")) || {});
            }
            if (typeof syncProductBadges === 'function') {
                syncProductBadges();
            }
        },

        sync() {
            this.save();
        },

        saveSummary() {
            const rawSubtotal = this.getSubtotal();
            let totalDiscountAmount = 0;
            let finalDeliveryToPay = 0;

            let discountRate = 0;
            if (typeof window.GLOBAL_AREA_DISCOUNT !== 'undefined') {
                discountRate = parseFloat(window.GLOBAL_AREA_DISCOUNT) / 100;
            } else {
                discountRate = parseFloat(localStorage.getItem("GLOBAL_AREA_DISCOUNT")) / 100 || 0;
            }

            // 1. Group delivery fees of distinct shops by their areaId (standardized & trimmed)
            const areaMap = this.items.reduce((acc, item) => {
                const aId = String(item.areaId || item.shopAreaId || GLOBAL_areaId || "").trim();
                const sId = String(item.shopId || "").trim();
                const fee = parseFloat(item.deliveryFee) || 0;

                if (aId && sId) {
                    if (!acc[aId]) {
                        acc[aId] = {};
                    }
                    acc[aId][sId] = fee;
                }
                return acc;
            }, {});

            console.log("Structured Area Map for summary calculation:", areaMap);

            // 2. Compute delivery fees and multi-shop discounts for each distinct area
            for (const aId in areaMap) {
                const shopsInThisArea = areaMap[aId];
                const feesArray = Object.values(shopsInThisArea);
                const sumFeesInArea = feesArray.reduce((sum, f) => sum + f, 0);

                console.log(`Area ID: ${aId}, Shops count in area: ${feesArray.length}, Sum of delivery fees: ${sumFeesInArea}`);

                if (feesArray.length > 1) {
                    // Two or more distinct shops in the same area: apply discount rate to the sum
                    const areaDiscount = sumFeesInArea * discountRate;
                    totalDiscountAmount += areaDiscount;
                    finalDeliveryToPay += (sumFeesInArea - areaDiscount);
                } else {
                    // Only one shop in the area: no discount applied
                    finalDeliveryToPay += sumFeesInArea;
                }
            }

            const summary = {
                subtotal: rawSubtotal.toFixed(2),
                delivery: finalDeliveryToPay.toFixed(2),
                total: (rawSubtotal + finalDeliveryToPay).toFixed(2),
                discount: totalDiscountAmount.toFixed(2),
            };

            localStorage.setItem("cartSummary", JSON.stringify(summary));
        },

        checkoutState: JSON.parse(localStorage.getItem("checkoutState")) || {
            paymentMethod: 'cash',
            deliveryMethod: 'delivery',
            contactMethod: 'ring_bell',
            scheduledTime: '',
            payerPhone: '',
            paymentProofBase64: ''
        },

        saveCheckoutState() {
            localStorage.setItem("checkoutState", JSON.stringify(this.checkoutState));
        },

        getSubtotal() {
            return this.items.reduce((sum, item) => {
                const itemPrice = Number(item.price) || 0;
                let totalForItem = itemPrice * item.amount;

                if (item.customization) {
                    // Extras with qty support
                    (item.customization.extras || []).forEach(e => {
                        totalForItem += (Number(e.price) || 0) * (e.qty || 1);
                    });
                    // Upsells with independent qty
                    (item.customization.upsells || []).forEach(u => {
                        totalForItem += (Number(u.price) || 0) * (u.qty || 1);
                    });
                }

                return sum + totalForItem;
            }, 0);
        },

        updateAddonQty(itemId, addonId, delta, type, shopId) {
            const item = this.items.find(i => String(i.cartItemId || i.id).trim() === String(itemId).trim() && String(i.shopId).trim() === String(shopId).trim());
            if (!item || !item.customization || !item.customization[type]) return;

            const addon = item.customization[type].find(a => String(a.id).trim() === String(addonId).trim());
            if (addon) {
                addon.qty = (Number(addon.qty) || 1) + delta;
                if (addon.qty < 1) {
                    this.removeAddon(itemId, addonId, type, shopId);
                    return;
                }
                this.save();
            }
        },

        removeAddon(itemId, addonId, type, shopId) {
            const item = this.items.find(i => String(i.cartItemId || i.id).trim() === String(itemId).trim() && String(i.shopId).trim() === String(shopId).trim());
            if (!item || !item.customization || !item.customization[type]) return;

            item.customization[type] = item.customization[type].filter(a => String(a.id).trim() !== String(addonId).trim());
            this.save();
        },

        updateItemNotes(itemId, newNotes, shopId) {
            const index = this.items.findIndex(i => String(i.cartItemId || i.id).trim() === String(itemId).trim() && String(i.shopId).trim() === String(shopId).trim());
            if (index !== -1) {
                if (!this.items[index].customization) {
                    this.items[index].customization = {};
                }
                this.items[index].customization.notes = newNotes;
                this.items[index].notes = newNotes;
                this.save();
            }
        },

        addItem(item, count = 1, isUpdate = false) {
            // Standardize values by explicitly casting and trimming
            const targetShopId = String(item.shopId || GLOBAL_shopId || "").trim();
            const targetAreaId = String(item.areaId || GLOBAL_areaId || "").trim();
            const targetPlaceId = String(item.placeId || GLOBAL_placeId || "").trim();
            const targetShopAreaId = String(item.shopAreaId || GLOBAL_shopAreaId || "").trim();
            const targetAddId = String(item.addId || GLOBAL_addId || "").trim();
            const targetShopName = String(item.shopName || GLOBAL_shopName || "").trim();

            // --- Sanitize incoming customization data to prevent indexed-object corruption ---
            if (item.customization) {
                const _sanitize = (src) => {
                    if (!src) return [];
                    const arr = Array.isArray(src) ? src : Object.values(src);
                    return arr.filter(x => x && typeof x === 'object' && x.id).map(x => ({
                        id: String(x.id),
                        name: String(x.name || ''),
                        price: Number(x.price) || 0,
                        qty: Math.max(1, parseInt(x.qty) || 1)
                    }));
                };
                item.customization.extras = _sanitize(item.customization.extras);
                item.customization.upsells = _sanitize(item.customization.upsells);
                if (item.customization.size && typeof item.customization.size === 'object') {
                    item.customization.size = {
                        id: String(item.customization.size.id),
                        name: String(item.customization.size.name || ''),
                        price: Number(item.customization.size.price) || 0
                    };
                }
                item.customization.notes = String(item.customization.notes || '');
            }

            // Explicitly cross-verify the incoming item's area data against existing items in the cart
            const differentAreaExists = this.items.some(i => String(i.areaId || "").trim() !== targetAreaId);

            if (differentAreaExists) {
                Swal.fire({
                    title: texts.CannotAddDifferentAreaTitle || "منطقة مختلفة",
                    text: texts.CannotAddDifferentAreaText || "لا يمكنك إضافة أصناف من منطقة مختلفة إلى سلة المشتريات.",
                    icon: "error",
                    confirmButtonText: texts.Ok || "موافق",
                });
                return false;
            }

            item.cartItemId = item.cartItemId || item.id;

            const shopExists = this.items.some(i => String(i.shopId).trim() === targetShopId);
            const isSameShopEdit = window.currentEditItem && String(window.currentEditItem.shopId).trim() === targetShopId;

            // If different shop but same area
            if (!isUpdate && !isSameShopEdit && !shopExists && this.items.length > 0) {
                const newItem = {
                    ...item,
                    amount: count,
                    placeId: targetPlaceId,
                    areaId: targetAreaId,
                    deliveryFee: parseFloat(item.deliveryFee) || parseFloat(GLOBAL_DELIVERY_FEE) || 0,
                    shopId: targetShopId,
                    shopName: targetShopName,
                    shopAreaId: targetShopAreaId,
                    addId: targetAddId,
                    deliveryTime: getLiveDeliveryTime() || parseInt(item.deliveryTime) || 0,
                };

                // Close product modal if open
                if (typeof Swal !== 'undefined' && Swal.isVisible()) {
                    Swal.close();
                }

                setTimeout(() => {
                    Swal.fire({
                        title: texts.AddItemDifferentShopTitle || "صنف من متجر آخر",
                        text: texts.AddItemDifferentShopText || "هل تريد إضافة هذا الصنف من متجر آخر؟",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: texts.YesAdd || "نعم، أضف",
                        cancelButtonText: texts.Cancel || "إلغاء",
                        reverseButtons: true,
                    }).then((result) => {
                        if (result.isConfirmed) {
                            if (window.currentEditItem) {
                                const oldId = window.currentEditItem.cartItemId || window.currentEditItem.id;
                                cart.items = cart.items.filter(i => !(String(i.cartItemId || i.id).trim() === String(oldId).trim() && String(i.shopId).trim() === String(window.currentEditItem.shopId).trim()));
                            }
                            cart.items.push(newItem);
                            cart.save();
                            showCartToast(texts.AddedFromDifferentShop || "تمت إضافة الصنف من متجر آخر!");
                        }
                    });
                }, 100);

                return false;
            }

            // --- Deep customization fingerprint for merge-vs-separate comparison ---
            const _custFingerprint = (cust) => {
                if (!cust) return '';
                const sizeKey = cust.size ? String(cust.size.id) : '';
                const extrasKey = (cust.extras || []).map(e => String(e.id)).sort().join(',');
                const upsellsKey = (cust.upsells || []).map(u => String(u.id)).sort().join(',');
                return `${sizeKey}|${extrasKey}|${upsellsKey}`;
            };

            const incomingFingerprint = _custFingerprint(item.customization);

            // Find existing item: match by cartItemId + shopId, then verify customization fingerprint
            const existing = this.items.find(i => {
                const idMatch = String(i.cartItemId || i.id).trim() === String(item.cartItemId).trim();
                const shopMatch = String(i.shopId).trim() === targetShopId;
                if (!idMatch || !shopMatch) return false;

                // For updates from modal, always match by cartItemId (size is baked in)
                if (isUpdate) return true;

                // For fresh adds, also compare customization fingerprint
                const existingFingerprint = _custFingerprint(i.customization);
                return existingFingerprint === incomingFingerprint;
            });

            if (existing) {
                if (isUpdate) {
                    existing.amount = count; // Replace quantity on update
                } else {
                    existing.amount += count; // Increment on normal add
                }

                // Fully replace customization with incoming clean data
                if (item.customization) {
                    existing.customization = {
                        size: item.customization.size || null,
                        extras: [...(item.customization.extras || [])],
                        upsells: [...(item.customization.upsells || [])],
                        notes: String(item.customization.notes || '')
                    };
                }
                if (item.notes !== undefined) existing.notes = String(item.notes);

                // Sync flags
                existing.isCustomized = !!item.isCustomized;
                existing.isCustomProduct = !!item.isCustomProduct;

                // Sync price (may have changed due to size selection)
                existing.price = Number(item.price) || existing.price;
                existing.productBasePrice = Number(item.productBasePrice) || existing.productBasePrice;
                existing.name = item.name || existing.name;
                existing.image = item.image || existing.image;
                existing.sizeId = item.sizeId !== undefined ? item.sizeId : existing.sizeId;
                existing.cartItemId = item.cartItemId || existing.cartItemId;

                // Sync/update delivery time and delivery fee dynamically upon updating
                existing.deliveryTime = getLiveDeliveryTime() || parseInt(existing.deliveryTime) || parseInt(item.deliveryTime) || 0;
                existing.deliveryFee = parseFloat(GLOBAL_DELIVERY_FEE) || parseFloat(existing.deliveryFee) || parseFloat(item.deliveryFee) || 0;

                this.save();
                return true;
            }

            this.items.push({
                ...item,
                amount: count,
                placeId: targetPlaceId,
                areaId: targetAreaId,
                deliveryFee: parseFloat(item.deliveryFee) || parseFloat(GLOBAL_DELIVERY_FEE) || 0,
                shopId: targetShopId,
                shopName: targetShopName,
                shopAreaId: targetShopAreaId,
                addId: targetAddId,
                deliveryTime: getLiveDeliveryTime() || parseInt(item.deliveryTime) || 0,
            });

            this.save();
            return true;
        },

        removeItem(id, shopId) {
            this.items = this.items.filter(i => !(String(i.cartItemId || i.id).trim() === String(id).trim() && String(i.shopId).trim() === String(shopId).trim()));
            this.save();
        },

        increaseItem(id, shopId) {
            const existing = this.items.find(i => String(i.cartItemId || i.id).trim() === String(id).trim() && String(i.shopId).trim() === String(shopId).trim());
            if (existing) {
                existing.amount += 1;
                this.save();
            }
        },

        decreaseItem(id, shopId) {
            const existing = this.items.find(i => String(i.cartItemId || i.id).trim() === String(id).trim() && String(i.shopId).trim() === String(shopId).trim());
            if (existing) {
                existing.amount -= 1;
                if (existing.amount < 1) {
                    this.removeItem(id, shopId);
                } else {
                    this.save();
                }
            }
        },

        clear() {
            this.items = [];
            this.save();
        }
    };

    // Initialize global binding and sync
    cart.initGlobal();
    cart.syncDeliveryFeeWithDOM();

    const cartData = JSON.parse(localStorage.getItem("cartItems")) || [];
    const cartSummary = JSON.parse(localStorage.getItem("cartSummary")) || {};
    if (typeof renderCheckoutArticles === 'function') {
        renderCheckoutArticles(cartData, cartSummary);
    }


function showCartToast(message = (window.texts ? window.texts.AddedToCartDefault : "تمت الإضافة"), options = {}) {
    const {
        background = "#ffc119", // toast background
          color = "#fff", // text color
          icon = "success",
        } = options;

    const progressColor = icon === "success" ? "#a5dc86" : "#ffeb3b";

    // Responsive position & scale
    const isMobile = window.innerWidth <= 600;
    const position = isMobile ? "top" : "top-end";
    const width = isMobile ? "90%" : "auto";
    const customPadding = isMobile ? "0.5em" : "";

    Swal.fire({
        toast: true,
        position: position,
        icon: icon,
        title: message,
        showConfirmButton: false,
        timer: 1500,
        timerProgressBar: true,
        background: background,
        color: color,
        width: width,
        padding: customPadding,
        customClass: {
            timerProgressBar: 'custom-toast-progress'
        },
        didOpen: (toast) => {
            toast.addEventListener("mouseenter", Swal.stopTimer);
            toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
    });

    // Inject custom style for this toast instance
    const style = document.createElement("style");
    style.textContent = `
    .swal2-container .custom-toast-progress {
      background: ${progressColor} !important;
    }
  `;
    document.head.appendChild(style);
}




    function getCartItems() {
        return JSON.parse(localStorage.getItem("cartItems")) || [];
    }

    const items = getCartItems();



    /* ========== COUNTER ========== */
    function updateCartCounter() {
        const counter = document.querySelector("#cartItemsNumber");
        if (!counter) return;
        const total = cart.items.reduce((sum, item) => sum + item.amount, 0);
        counter.textContent = total;
        if (total > 0) {
            counter.textContent = total;
            counter.style.display = "inline"; // or "block", depending on your layout
        } else {
            counter.style.display = "none";
        }
    }

    /* ========== TOTAL PAY (for mobile/cart icon bar) ========== */
    function updateTotalPayAmount() {
        const el = document.querySelector("#totalPayAmount");
        if (!el) return;

        const hasItems = cart.items.length > 0;

        if (!hasItems) {
            // Cart empty → show zeros
            el.textContent = `${texts.Total}: EGP 00.00`;
            return;
        }

        // Cart has items → use cart summary
        const summary = JSON.parse(localStorage.getItem("cartSummary")) || {
            total: 0
        };

        el.textContent = `${texts.Total}: EGP ` + Number(summary.total).toFixed(2);
    }


    /* ========== MAIN CART UI (Popup Cart) ========== */
    function updateCartUI() {
        const inCartEls = document.querySelectorAll("#inCartItems");
        const emptyEls = document.querySelectorAll("#emptyCart");

        if (inCartEls.length === 0 || emptyEls.length === 0) return;

        inCartEls.forEach((inCart, index) => {
            const empty = emptyEls[index];
            if (!empty) return;

            // Prepare new wrapper
            const wrapper = document.createElement("div");
            wrapper.classList.add("orderedItemsWrapper");

            // Show empty message if cart is empty
            if (cart.items.length === 0) {
                if (empty) empty.style.setProperty('display', 'flex', 'important');
                if (inCart) inCart.style.setProperty('display', 'none', 'important');

                // Clear any residual items to prevent them from staying alongside empty state
                const oldWrapper = inCart.querySelector(".orderedItemsWrapper");
                if (oldWrapper) oldWrapper.remove();

                // Also handle the footer explicitly if it's a child of inCartItems
                const sideFooter = inCart.querySelector(".side-cart-footer-container");
                if (sideFooter) {
                    sideFooter.style.setProperty('display', 'none', 'important');
                }

                // Update summary even when empty to ensure localStorage is in sync
                cart.saveSummary();

                return;
            }

            if (empty) empty.style.setProperty('display', 'none', 'important');
            if (inCart) inCart.style.setProperty('display', 'flex', 'important');

            // Ensure footer is visible if it was hidden
            const sideFooter = inCart.querySelector(".side-cart-footer-container");
            if (sideFooter) {
                sideFooter.style.setProperty('display', 'block', 'important');
            }

            // Remove old wrapper and insert new one in the correct position
            const oldWrapper = inCart.querySelector(".orderedItemsWrapper");
            const footerEl = inCart.querySelector(".side-cart-footer-container") || inCart.querySelector(".cart-summary-footer") || inCart.querySelector(".preDeliveryFeeAmount");

            // Save scroll position before swapping
            const savedScrollTop = oldWrapper ? oldWrapper.scrollTop : 0;

            if (oldWrapper) {
                oldWrapper.parentNode.replaceChild(wrapper, oldWrapper);
            } else if (footerEl) {
                footerEl.parentNode.insertBefore(wrapper, footerEl);
            } else {
                inCart.appendChild(wrapper);
            }

            // Group items by shopId
            const itemsByShop = {};
            cart.items.forEach(item => {
                if (!itemsByShop[item.shopId]) {
                    itemsByShop[item.shopId] = {
                        shopName: item.shopName || texts.DefaultShopName,
                        items: []
                    };
                }
                itemsByShop[item.shopId].items.push(item);
            });

            // Render each shop group
            Object.keys(itemsByShop).forEach(shopId => {
                const group = itemsByShop[shopId];

                // Shop label
                const shopLabel = document.createElement("div");
                shopLabel.classList.add("cartShopLabel");
                shopLabel.style.display = "flex";
                shopLabel.style.justifyContent = "space-between";
                shopLabel.style.alignItems = "center";

                let deliveryTimeStr = "";
                if (group.items[0]?.deliveryTime) {
                    deliveryTimeStr = `
                        <span class="deliveryTime" style="font-size: 0.85rem; color: var(--text-color, #666); font-weight: normal; display: flex; align-items: center; gap: 4px;">
                            <i class="fa-regular fa-clock"></i>
                            ${texts.DeliveryTimeHint || 'إستلام خلال'}
                            <span class="timer">${group.items[0].deliveryTime}</span>
                            ${texts.Minutes || 'دقيقة'}
                        </span>
                    `;
                }

                shopLabel.innerHTML = `<div style="display: flex; align-items: center; gap: 5px;"><i class="fa-solid fa-store" style="color: var(--orange-500);"></i> ${group.shopName}</div> ${deliveryTimeStr}`;
                wrapper.appendChild(shopLabel);

                // Render each product in shop
                group.items.forEach(item => {
                    const priceNum = Number(item.price) || 0;
                    let addonsTotal = 0;
                    if (item.customization) {
                        (item.customization.quickChoices || []).forEach(qc => addonsTotal += (Number(qc.price) || 0) * (qc.qty || 1));
                        (item.customization.extras || []).forEach(ex => addonsTotal += (Number(ex.price) || 0) * (ex.qty || 1));
                        (item.customization.upsells || []).forEach(up => addonsTotal += (Number(up.price) || 0) * (up.qty || 1));
                    }
                    // Parent item total (just product * amount)
                    const itemOnlyTotal = priceNum * item.amount;
                    // Group total (item + all addons)
                    const groupTotalPrice = itemOnlyTotal + addonsTotal;

                    const itemGroup = document.createElement("div");
                    itemGroup.classList.add("cart-item-group");
                    itemGroup.setAttribute("data-item-id", item.cartItemId || item.id);

                    const article = document.createElement("article");
                    article.classList.add("orderedItem");
                    if (item.isCustomized) article.classList.add("customized-cart-item");

                    article.innerHTML = `
                        <div class="cartItemAmountHandlers">
                          <button class="decrease" type="button"><i class="fa-solid fa-minus"></i></button>
                          <span class="itemAmount">${item.amount}</span>
                          <button class="increase" type="button"><i class="fa-solid fa-plus"></i></button>
                        </div>
                        <div class="orderedItemMain">
                          <span class="orderedItemName">${item.name} ${item.customization?.size ? `<small class="cart-item-size">(${item.customization.size.name})</small>` : ''} <small class="unit-price">(${item.price} ${texts.Currency})</small></span>
                          <div class="cart-item-badges">
                            ${(item.isCustomProduct || (item.customization?.extras?.length > 0) || (item.customization?.upsells?.length > 0) || (item.customization?.quickChoices?.length > 0) || (item.customization?.size && item.customization.size.id && item.customization.size.id !== 'size-small'))
                                ? (() => {
                                    const hasActualAddons = (item.customization?.extras?.length > 0) || (item.customization?.upsells?.length > 0) || (item.customization?.quickChoices?.length > 0) || (item.customization?.size && item.customization.size.id && item.customization.size.id !== 'size-small');
                                    return `<span class="addons-badge ${!hasActualAddons ? 'suggestion-badge' : ''}" onclick="event.stopPropagation(); if(typeof openProductModal==='function') openProductModal('${item.cartItemId || item.id}', ${JSON.stringify(item).replace(/"/g, '&quot;')}); else if(typeof openHardcodedModal==='function') openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')})">${!hasActualAddons ? '<i class="fa-solid fa-wand-magic-sparkles"></i> ' + (texts.Extras || 'الإضافات') : (texts.Extras || 'الإضافات')}</span>`;
                                })()
                                : ''
                            }

                            ${(() => {
                                const hasNotes = !!(item.customization?.notes || item.notes);
                                return `<span class="notes-badge ${!hasNotes ? 'suggestion-badge' : ''}" onclick="event.stopPropagation(); if(typeof openProductModal==='function') openProductModal('${item.cartItemId || item.id}', ${JSON.stringify(item).replace(/"/g, '&quot;')}, true); else openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')}, null, null, null, null, true)">${!hasNotes ? '<i class="fa-solid fa-comment-medical"></i> ' + (texts.Notes || 'ملاحظات') : (texts.Notes || 'ملاحظات')}</span>`;
                            })()}
                          </div>
                        </div>
                        <span class="totalItemPrice">${itemOnlyTotal.toLocaleString()} ${texts.Currency}</span>
                        <span class="removeCartItem"><i class="fa-solid fa-trash"></i></span>
                    `;
                    itemGroup.appendChild(article);

                    // Add Customizations (Extras)
                    if (item.customization) {
                        const custWrapper = document.createElement("div");
                        custWrapper.classList.add("cart-item-customizations");


                        // Extras
                        if (item.customization.extras && item.customization.extras.length > 0) {
                            item.customization.extras.forEach(ex => {
                                const div = document.createElement("div");
                                div.classList.add("customization-row");
                                const exTotal = (Number(ex.price) || 0) * (ex.qty || 1);

                                div.innerHTML = `
                                    <span>+ ${ex.name} ${ex.qty > 1 ? `(x${ex.qty})` : ''}</span>
                                    <div class="cust-right-col">
                                        <div class="cartItemAmountHandlers mini-handlers">
                                            <button class="decrease" type="button" onclick="event.stopPropagation(); cart.updateAddonQty('${item.cartItemId || item.id}', '${ex.id}', -1, 'extras', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                            <span class="itemAmount">${ex.qty || 1}</span>
                                            <button class="increase" type="button" onclick="event.stopPropagation(); cart.updateAddonQty('${item.cartItemId || item.id}', '${ex.id}', 1, 'extras', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                                        </div>
                                        <span class="cust-price">${exTotal.toLocaleString()} ${texts.Currency}</span>
                                        <span class="remove-cust-item" onclick="event.stopPropagation(); cart.removeAddon('${item.cartItemId || item.id}', '${ex.id}', 'extras', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
                                    </div>
                                `;
                                custWrapper.appendChild(div);
                            });
                        }

                        if (custWrapper.children.length > 0) {
                            itemGroup.appendChild(custWrapper);
                        }
                    }

                    // Nested Upsells (Rendered below main item with handlers)
                    if (item.customization && item.customization.upsells && item.customization.upsells.length > 0) {
                        const upsellsWrapper = document.createElement("div");
                        upsellsWrapper.classList.add("cart-nested-upsells");

                        item.customization.upsells.forEach(upsell => {
                            const upsellArticle = document.createElement("article");
                            upsellArticle.classList.add("orderedItem", "upsell-cart-item");
                            const upsellTotal = (Number(upsell.price) || 0) * (upsell.qty || 0);

                            upsellArticle.innerHTML = `
                                <div class="upsell-connector"></div>
                                <div class="cartItemAmountHandlers">
                                    <button class="decrease" type="button" onclick="event.stopPropagation(); cart.updateAddonQty('${item.cartItemId || item.id}', '${upsell.id}', -1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                    <span class="itemAmount">${upsell.qty}</span>
                                    <button class="increase" type="button" onclick="event.stopPropagation(); cart.updateAddonQty('${item.cartItemId || item.id}', '${upsell.id}', 1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                                </div>
                                <div class="orderedItemMain">
                                    <span class="orderedItemName">${upsell.name}</span>
                                </div>
                                <span class="totalItemPrice">${upsellTotal.toLocaleString()} ${texts.Currency}</span>
                                <span class="removeUpsellItem" onclick="event.stopPropagation(); cart.removeAddon('${item.cartItemId || item.id}', '${upsell.id}', 'upsells', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
                            `;
                            upsellsWrapper.appendChild(upsellArticle);
                        });
                        itemGroup.appendChild(upsellsWrapper);
                    }

                    // Group Total Row if has addons
                    if (addonsTotal > 0) {
                        const groupTotalDiv = document.createElement("div");
                        groupTotalDiv.classList.add("cart-group-total");
                        groupTotalDiv.innerHTML = `
                            <span class="group-total-label">${texts.TotalCostLabel}</span>
                            <span class="group-total-amount">${groupTotalPrice.toLocaleString()} ${texts.Currency}</span>
                        `;
                        itemGroup.appendChild(groupTotalDiv);
                    }

                    wrapper.appendChild(itemGroup);

                    // Buttons
                    article.querySelector(".increase").onclick = () => cart.increaseItem(item.cartItemId || item.id, item.shopId);
                    article.querySelector(".decrease").onclick = () => cart.decreaseItem(item.cartItemId || item.id, item.shopId);
                    article.querySelector(".removeCartItem").onclick = () => cart.removeItem(item.cartItemId || item.id, item.shopId);

                    // Edit Logic for customized items
                    if (item.isCustomized && typeof openHardcodedModal === 'function') {
                        const editTrigger = article.querySelector(".orderedItemMain");
                        if (editTrigger) {
                            editTrigger.style.cursor = "pointer";
                            editTrigger.onclick = () => {
                                if (typeof openProductModal === 'function') openProductModal(item.cartItemId || item.id, item);
                                else openHardcodedModal(item);
                            };
                        }
                    }
                });
            });

            // Restore scroll position after items are rendered
            wrapper.scrollTop = savedScrollTop;
        });

        // Update totals globally
        cart.saveSummary();
        updateCartCounter();
        updateTotalPayAmount();

        // Update subtotal, delivery, total in ALL cart UI instances
        const summary = JSON.parse(localStorage.getItem("cartSummary")) || {
            subtotal: 0,
            delivery: cart.deliveryFee,
            total: 0
        };

        const subtotalEls = document.querySelectorAll(".subtotalAmount");
        const deliveryEls = document.querySelectorAll(".deliveryFee");
        const totalEls = document.querySelectorAll(".totalAmount");

        subtotalEls.forEach(el => el.textContent = Number(summary.subtotal).toLocaleString() + ` ${texts.Currency}`);
        deliveryEls.forEach(el => el.textContent = Number(summary.delivery).toFixed(2) + ` ${texts.Currency}`);
        totalEls.forEach(el => el.textContent = Number(summary.total).toLocaleString() + ` ${texts.Currency}`);

        // Handle empty cart summary update
        if (cart.items.length === 0) {
            renderCheckoutArticles(cart.items, JSON.parse(localStorage.getItem("cartSummary")) || {});
        }
    }



    /* ========== ADD TO CART BUTTONS ========== */
    function initAddToCartByCard() {
        const foodItems = document.querySelectorAll(".foodItem");

        foodItems.forEach((itemEl) => {
            itemEl.addEventListener("click", (e) => {

                // Ignore clicks on buttons inside the item
                if (e.target.closest("button") || e.target.closest(".addToCartBtn")) return;

                // If item has openSimpleNotesModal or openHardcodedModal, don't auto-add
                if (itemEl.hasAttribute("onclick") && (itemEl.getAttribute("onclick").includes("openSimpleNotesModal") || itemEl.getAttribute("onclick").includes("openHardcodedModal"))) return;

                const id = itemEl.getAttribute("id");
                const name = itemEl.querySelector(".foodName")?.textContent.trim();
                const price = itemEl.querySelector(".foodNewPrice")?.textContent.trim();

                if (id && name && price) {
                    // Add item to cart
                    const added = cart.addItem({
                        id, // unique product ID
                        name,
                        price: parseFloat(price.replace(/[^\d.]/g, "")),
                        placeId: GLOBAL_PLACE_ID,
                        areaId: GLOBAL_AREA_ID,
                        deliveryFee: GLOBAL_DELIVERY_FEE,
                        shopId: GLOBAL_shop_ID,
                        shopName: GLOBAL_shopName,
                        shopAreaId: GLOBAL_shopArea_ID,
                        addId: GLOBAL_addid_ID,
                        isCustomProduct: itemEl.classList.contains('custom-item') || itemEl.getAttribute('data-has-addons') === '1'
                    });

                    if (added) {
                        // Load clicked IDs from localStorage
                        let clickedIds = JSON.parse(localStorage.getItem("clickedProductIds")) || [];

                        // Only add to clicked IDs if not already present
                        const isNewClick = !clickedIds.includes(id);
                        if (isNewClick) {
                            clickedIds.push(id);
                            localStorage.setItem("clickedProductIds", JSON.stringify(clickedIds));
                            showCartToast(`${texts.AddedToCartPrefix} "${name}" ${texts.AddedToCartSuffix}`);
                        }
                    }

                    console.log("Clicked product IDs:", JSON.parse(localStorage.getItem("clickedProductIds")) || []);
                }
            });
        });
    }


    // ✅ Function to empty the cart
    function attachEmptyCartButton(buttonSelector, options = {}) {
        const btns = document.querySelectorAll(buttonSelector);
        if (btns.length === 0) return;

        btns.forEach(btn => {
            btn.addEventListener("click", () => {
                const doEmpty = () => {
                    cart.items = [];
                    cart.save();
                    if (options.clearClickedIds) {
                        localStorage.setItem("clickedProductIds", JSON.stringify([]));
                    }
                    if (options.toastMessage) {
                        showCartToast(options.toastMessage);
                    }
                };

                if (options.confirm) {
                    Swal.fire({
                        title: options.confirmMessage || texts.ConfirmEmptyCart,
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonText: texts.Ok,
                        cancelButtonText: texts.Cancel,
                        reverseButtons: true
                    }).then((result) => {
                        if (result.isConfirmed) {
                            doEmpty();
                        }
                    });
                } else {
                    doEmpty();
                }
            });
        });
    }

attachEmptyCartButton("#emptyCartBtn", {
    confirm: true,
    confirmMessage: texts.ConfirmEmptyCart,
    toastMessage: texts.CartEmptied,
    clearClickedIds: true,
});


/* ========== CHECKOUT PAGE LOADER ========== */
function loadCheckoutSummary() {
    if (!window.location.pathname.includes("checkout")) return;
    const stored = localStorage.getItem("cartSummary");
    if (!stored) return;
    const {
        subtotal,
        delivery,
        total
    } = JSON.parse(stored);
    const subtotalEl = document.querySelector(".subtotalAmount");
    const deliveryEl = document.querySelectorAll(".deliveryFee")[0];
    const totalEl = document.querySelector(".totalAmount");
    if (subtotalEl) subtotalEl.textContent = subtotal + ` ${texts.Currency}`;
    if (deliveryEl) deliveryEl.textContent = delivery + ` ${texts.Currency}`;
    if (totalEl) totalEl.textContent = total + ` ${texts.Currency}`;
}



/* ========== INITIALIZE EVERYTHING ========== */
// initAddToCartByCard();
updateCartUI();
updateCartCounter();
updateTotalPayAmount();
loadCheckoutSummary();

if (document.querySelector("#checkoutCart")) {
    renderCheckoutArticles(cart.items, JSON.parse(localStorage.getItem("cartSummary")) || {});
}

// Fallback for lazy DOM content
setTimeout(() => {
    updateCartUI();
    updateCartCounter();
    updateTotalPayAmount();
}, 300);

// ✅ Make accessible globally
window.cart = cart;

// --- SMART CART ICON REDIRECT ---
const cartIcon = document.querySelector("#cartIcon");

function updateCartIconLink() {
    if (!cartIcon) return;

    const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];

    if (cartItems.length === 0) {
        // Cart is empty
        const lastShopId = localStorage.getItem("currentShopId");

        if (lastShopId) {
            // Redirect to last visited shop
            cartIcon.setAttribute("href", `./shopPage.html?shopId=${lastShopId}`);
        } else {
            // No history → go to all shops
            cartIcon.setAttribute("href", "./allShops.html");
        }
    } else {
        // Cart has items → go to checkout
        cartIcon.setAttribute("href", "./checkout.html");
    }
}

// Run once on page load
updateCartIconLink();


function renderCheckoutArticles(items, summary) {
    const checkoutCart = document.querySelector("#checkoutCart");
    if (!checkoutCart) return;

    // Prevent page jump by maintaining current height during update
    const currentHeight = checkoutCart.offsetHeight;
    if (currentHeight > 0) {
        checkoutCart.style.minHeight = currentHeight + 'px';
    }

    checkoutCart.innerHTML = "";

    if (items.length === 0) {
        const emptyMsg = document.createElement("p");
        emptyMsg.textContent = texts.CartIsEmpty;
        checkoutCart.appendChild(emptyMsg);
        return;
    }

    // Group items by shop
    const itemsByShop = {};
    items.forEach(item => {
        if (!itemsByShop[item.shopId]) itemsByShop[item.shopId] = { shopName: item.shopName, items: [] };
        itemsByShop[item.shopId].items.push(item);
    });

    Object.keys(itemsByShop).forEach(shopId => {
        const shopGroup = itemsByShop[shopId];

        const article = document.createElement("article");
        article.classList.add("checkoutBox");

        // Shop title + edit link
        const titleDiv = document.createElement("div");
        titleDiv.classList.add("checkoutBoxTitle");

        const addId = shopGroup.items[0].addId || "";

        function sendAddId(addId) {
            $.ajax({
                type: "POST",
                url: "CheckOut.aspx/ReceiveAddId",
                data: JSON.stringify({ addId: addId, lang: getCookie("lang") || "ar" }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",  // مهم جداً
                success: function(res) {
                    var data = res.d;
                    const dash = "---";

                    const setVal = (id, val) => {
                        const el = document.getElementById(id);
                        if (el) el.innerText = (val && val.toString().trim()) ? val : dash;
                    };

                    setVal("AddName", data.AddName);
                    setVal("StreetName", data.StreetName);
                    setVal("mobile", data.mobile);
                    setVal("phone", data.phone);
                    setVal("Build", data.Build);
                    setVal("Floor", data.Floor);
                    setVal("Area", data.Area);
                    setVal("Gov", data.Gov);
                    setVal("AdepartmentNo", data.AdepartmentNo);
                    setVal("Instructions", data.Instructions);
                    setVal("AType", data.AType);

                    // Optional location group update
                    const locEl = document.getElementById("location");
                    if (locEl) locEl.innerText = (data.Gov || dash) + ' - ' + (data.Area || dash);

                    // Update HiddenField
                    const hf = document.getElementById("ContentPlaceHolder1_hfAddId");
                    if (hf) hf.value = addId;
                },
                error: function(err) {
                    console.log("AJAX Error:", err);
                }
            });
        }


        sendAddId(addId);

        const deliveryMethod = localStorage.getItem("deliveryMethod") || "delivery";
        const isPickup = deliveryMethod === "pickup" || deliveryMethod === "in-shop";
        const shopDeliveryTime = isPickup ? 0 : (parseInt(shopGroup.items[0].deliveryTime) || 0);

        titleDiv.innerHTML = `
      <div style="display: flex; flex-direction: column; gap: 4px;">
        <h2 style="display: flex; align-items: center; gap: 10px; margin-bottom: 0;">
            <i class="fa-solid fa-store" style="color: var(--orange-500); font-size: 1.4rem;"></i>
            ${shopGroup.shopName}
        </h2>
        <small style="color: #666; font-size: 0.85rem; margin-inline: 1rem;">
            <i class="fa-regular fa-clock"></i> ${texts.DeliveryTimeHint} <span id="live-timer-val-${shopId}">${shopDeliveryTime}</span> ${texts.Minutes}
        </small>
      </div>
      <a href="PlaceShop.aspx?id=${shopId}&addid=${addId}">${texts.UpdateOrder}</a>
    `;
        article.appendChild(titleDiv);



            // Order info container
            const orderInfo = document.createElement("div");
            orderInfo.classList.add("orderInfo");

            // Labels row
            const labels = document.createElement("div");
            labels.classList.add("orderLabels");
            labels.innerHTML = `
                <span class="orderName">${texts.Item}</span>
                <span>${texts.Quantity}</span>
                <span>${texts.Price}</span>
                <span>${texts.Total}</span>
                <span>${texts.Remove}</span>
            `;
            orderInfo.appendChild(labels);

            // Each item row
            shopGroup.items.forEach(item => {
                const priceNum = Number(item.price) || 0;
                let addonsTotal = 0;
                if (item.customization) {
                    (item.customization.quickChoices || []).forEach(qc => addonsTotal += (Number(qc.price) || 0) * (qc.qty || 1));
                    (item.customization.extras || []).forEach(ex => addonsTotal += (Number(ex.price) || 0));
                    (item.customization.upsells || []).forEach(up => addonsTotal += (Number(up.price) || 0) * (up.qty || 0));
                }
                const itemOnlyTotal = priceNum * item.amount;
                const groupTotalPrice = itemOnlyTotal + addonsTotal;

                const row = document.createElement("div");
                row.classList.add("orderStats", "checkout-main-item-row");

                row.innerHTML = `
                    <div class="orderedItemMain orderName">
                        <span class="orderedItemName">
                            ${item.name}
                            ${item.customization?.size ? `<small class="checkout-item-size">(${item.customization.size.name})</small>` : ''}
                            <small class="unit-price">(${item.price.toFixed(2)} ${texts.Currency})</small>
                        </span>
                        <div class="cart-item-badges" style="margin-top: 5px;">
                            ${(item.isCustomProduct || (item.customization?.extras?.length > 0) || (item.customization?.upsells?.length > 0) || (item.customization?.quickChoices?.length > 0) || (item.customization?.size && item.customization.size.id && item.customization.size.id !== 'size-small'))
                                ? (() => {
                                    const hasActualAddons = (item.customization?.extras?.length > 0) || (item.customization?.upsells?.length > 0) || (item.customization?.quickChoices?.length > 0) || (item.customization?.size && item.customization.size.id && item.customization.size.id !== 'size-small');
                                    return `<span class="addons-badge ${!hasActualAddons ? 'suggestion-badge' : ''}" onclick="event.stopPropagation(); if(typeof openProductModal==='function') openProductModal('${item.cartItemId || item.id}', ${JSON.stringify(item).replace(/"/g, '&quot;')}); else if(typeof openHardcodedModal==='function') openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')})">${!hasActualAddons ? '<i class="fa-solid fa-wand-magic-sparkles"></i> ' + (texts.Extras || 'الإضافات') : (texts.Extras || 'الإضافات')}</span>`;
                                })()
                                : ''
                            }

                            ${(() => {
                                const hasNotes = !!(item.customization?.notes || item.notes);
                                return `<span class="notes-badge ${!hasNotes ? 'suggestion-badge' : ''}" onclick="event.stopPropagation(); if(typeof openProductModal==='function') openProductModal('${item.cartItemId || item.id}', ${JSON.stringify(item).replace(/"/g, '&quot;')}, true); else openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')}, null, null, null, null, true)">${!hasNotes ? '<i class="fa-solid fa-comment-medical"></i> ' + (texts.Notes || 'ملاحظات') : (texts.Notes || 'ملاحظات')}</span>`;
                            })()}
                        </div>
                    </div>
                    <div class="cartItemAmountHandlers">
                      <button class="decrease" type="button"><i class="fa-solid fa-minus"></i></button>
                      <span class="itemAmount">${item.amount}</span>
                      <button class="increase" type="button"><i class="fa-solid fa-plus"></i></button>
                    </div>
                    <span class="itemPrice">${item.price.toFixed(2)} ${texts.Currency}</span>
                    <span class="totalItemPrice">${itemOnlyTotal.toFixed(2)} ${texts.Currency}</span>
                    <span class="removeItem"><i class="fa-solid fa-trash"></i></span>
                `;


                const itemGroupWrapper = document.createElement("div");
                itemGroupWrapper.classList.add("checkout-item-group");
                if (item.customization && (item.customization.quickChoices?.length > 0 || item.customization.extras?.length > 0 || item.customization.upsells?.length > 0)) {
                    itemGroupWrapper.classList.add("has-addons");
                }
                itemGroupWrapper.appendChild(row);

                orderInfo.appendChild(itemGroupWrapper);

                // Add Customizations to Checkout
                if (item.customization) {
                    // Quick Choices with qty
                    (item.customization.quickChoices || []).forEach(qc => {
                        const exRow = document.createElement("div");
                        exRow.classList.add("orderStats", "checkout-customization-row");
                        exRow.innerHTML = `
                            <span class="orderName"><small>+ ${qc.name}</small></span>
                            <div class="cartItemAmountHandlers">
                                <button class="decrease" type="button" onclick="cart.updateAddonQty('${item.cartItemId || item.id}', '${qc.id}', -1, 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                <span class="itemAmount">${qc.qty || 1}</span>
                                <button class="increase" type="button" onclick="cart.updateAddonQty('${item.cartItemId || item.id}', '${qc.id}', 1, 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                            </div>
                            <span class="itemPrice">${qc.price} ${texts.Currency}</span>
                            <span class="itemTotal">${(qc.price * (qc.qty || 1)).toFixed(2)} ${texts.Currency}</span>
                            <span class="removeItem" onclick="cart.removeAddon('${item.cartItemId || item.id}', '${qc.id}', 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
                        `;
                        itemGroupWrapper.appendChild(exRow);
                    });

                    // Extras (with qty support)
                    (item.customization.extras || []).forEach(ex => {
                        const exRow = document.createElement("div");
                        exRow.classList.add("orderStats", "checkout-customization-row");
                        exRow.innerHTML = `
                            <span class="orderName"><small>+ ${ex.name}</small></span>
                            <div class="cartItemAmountHandlers">
                                <button class="decrease" type="button" onclick="cart.updateAddonQty('${item.cartItemId || item.id}', '${ex.id}', -1, 'extras', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                <span class="itemAmount">${ex.qty || 1}</span>
                                <button class="increase" type="button" onclick="cart.updateAddonQty('${item.cartItemId || item.id}', '${ex.id}', 1, 'extras', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                            </div>
                            <span class="itemPrice">${ex.price} ${texts.Currency}</span>
                            <span class="itemTotal">${((ex.price) * (ex.qty || 1)).toFixed(2)} ${texts.Currency}</span>
                            <span class="removeItem" onclick="cart.removeAddon('${item.cartItemId || item.id}', '${ex.id}', 'extras', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
                        `;
                        itemGroupWrapper.appendChild(exRow);
                    });

                    // Nested Upsells (Independent qty)
                    if (item.customization.upsells && item.customization.upsells.length > 0) {
                        item.customization.upsells.forEach(up => {
                            const upRow = document.createElement("div");
                            upRow.classList.add("orderStats", "checkout-upsell-row");
                            const upTotal = (up.price * up.qty).toFixed(2);
                            upRow.innerHTML = `
                                <span class="orderName"><small><i class="fa-solid fa-plus"></i> ${up.name}</small></span>
                                <div class="cartItemAmountHandlers">
                                    <button class="decrease" type="button" onclick="cart.updateAddonQty('${item.cartItemId || item.id}', '${up.id}', -1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                    <span class="itemAmount">${up.qty}</span>
                                    <button class="increase" type="button" onclick="cart.updateAddonQty('${item.cartItemId || item.id}', '${up.id}', 1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                                </div>
                                <span class="itemPrice">${up.price} ${texts.Currency}</span>
                                <span class="itemTotal">${upTotal} ${texts.Currency}</span>
                                <span class="removeItem" onclick="cart.removeAddon('${item.cartItemId || item.id}', '${up.id}', 'upsells', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
                            `;
                            itemGroupWrapper.appendChild(upRow);
                        });
                    }
                }

                // Add Notes if present (Moved below extras)
                const noteText = item.customization?.notes || item.notes;
                if (noteText) {
                    const notesRow = document.createElement("div");
                    notesRow.classList.add("checkout-item-notes");
                    notesRow.innerHTML = `
                        <div class="notes-container">
                            <div class="notes-header">
                                <i class="fa-solid fa-comment-dots"></i>
                                <span class="notes-label">${texts.Notes}</span>
                            </div>
                            <textarea class="notes-textarea" placeholder="${texts.AddNotesPlaceholder}" onblur="cart.updateItemNotes('${item.cartItemId || item.id}', this.value, '${item.shopId}')">${noteText}</textarea>
                        </div>
                    `;
                    itemGroupWrapper.appendChild(notesRow);
                }

                // Total Row for Checkout Group
                if (item.customization && (item.customization.quickChoices?.length > 0 || item.customization.extras?.length > 0 || item.customization.upsells?.length > 0)) {
                    const groupTotalDiv = document.createElement("div");
                    groupTotalDiv.classList.add("checkout-group-total");
                    groupTotalDiv.innerHTML = `
                        <span class="group-total-label">${texts.TotalCostLabel}</span>
                        <span class="group-total-amount">${groupTotalPrice.toFixed(2)} ${texts.Currency}</span>
                    `;
                    itemGroupWrapper.appendChild(groupTotalDiv);
                }

                // Handlers
                row.querySelector(".increase").onclick = () => cart.increaseItem(item.cartItemId || item.id, item.shopId);
                row.querySelector(".decrease").onclick = () => cart.decreaseItem(item.cartItemId || item.id, item.shopId);
                row.querySelector(".removeItem").onclick = () => cart.removeItem(item.cartItemId || item.id, item.shopId);
            });

        article.appendChild(orderInfo);

        // Calculate shop subtotal
        let shopSubtotal = 0;
        shopGroup.items.forEach(item => {
            const priceNum = Number(item.price) || 0;
            let addonsTotal = 0;
            if (item.customization) {
                (item.customization.quickChoices || []).forEach(qc => addonsTotal += (Number(qc.price) || 0) * (qc.qty || 1));
                (item.customization.extras || []).forEach(ex => addonsTotal += (Number(ex.price) || 0));
                (item.customization.upsells || []).forEach(up => addonsTotal += (Number(up.price) || 0) * (up.qty || 0));
            }
            shopSubtotal += (priceNum * item.amount) + addonsTotal;
        });

        const shopDeliveryFee = shopGroup.items[0].deliveryFee || 0;

        const footerDiv = document.createElement("div");
        footerDiv.className = "vendor-group-footer";
        footerDiv.setAttribute('data-vendor', shopId);
        footerDiv.setAttribute('data-delivery-fee', shopDeliveryFee);
        footerDiv.innerHTML = `
            <span>${texts.SubtotalLabel} <strong>${shopSubtotal.toFixed(2)} ${texts.Currency}</strong></span>
            <span class="shop-delivery-fee">${texts.DeliveryLabel} <strong id="shopDelivery-${shopId}">${shopDeliveryFee} ${texts.Currency}</strong></span>
        `;
        article.appendChild(footerDiv);

        checkoutCart.appendChild(article);
    });

    // Update the hardcoded summary values if they exist
    const subtotalEl = document.getElementById("globalSubtotal");
    const finalTotalEl = document.getElementById("globalFinalTotal");
    const deliveryEl = document.getElementById("globalTotalDelivery");

    if (subtotalEl) {
        subtotalEl.innerText = `${Number(summary.subtotal || 0).toLocaleString()} ${texts.Currency || 'ج.م'}`;
    }
    if (deliveryEl) {
        deliveryEl.innerText = `${Number(summary.delivery || 0).toFixed(2)} ${texts.Currency || 'ج.م'}`;
    }
    if (finalTotalEl) {
        finalTotalEl.innerText = `${Number(summary.total || 0).toLocaleString()} ${texts.Currency || 'ج.م'}`;
    }

    // Update Total Delivery Time in summary
    const totalDeliveryTimeEl = document.getElementById("globalTotalDeliveryTime");
    if (totalDeliveryTimeEl) {
        const deliveryMethod = localStorage.getItem("deliveryMethod") || "delivery";
        const isPickup = deliveryMethod === "pickup" || deliveryMethod === "in-shop";
        if (isPickup) {
            totalDeliveryTimeEl.innerText = `0 ${texts.Minutes}`;
        } else {
            const maxTime = items.reduce((max, item) => {
                const t = parseInt(item.deliveryTime);
                return isNaN(t) ? max : Math.max(max, t);
            }, 0);
            totalDeliveryTimeEl.innerText = `${maxTime} ${texts.Minutes}`;
        }
    }

    if(typeof updateGlobalDeliveryCost === 'function') updateGlobalDeliveryCost();

    // Clear min-height after content is loaded
    requestAnimationFrame(() => {
        checkoutCart.style.minHeight = '';
    });

    // Initialize delivery time scheduling
    if (typeof initDeliveryTimeScheduling === 'function') {
        initDeliveryTimeScheduling();
    }

    // Server-side GetShopTimers call has been removed to ensure 100% reliance on persistent browser localStorage delivery times, preventing resets to 0.
    /*
    const shopIds = Object.keys(itemsByShop).map(id => parseInt(id));
    const addIdVal = items[0]?.addId || "";
    if (shopIds.length > 0 && addIdVal) {
        $.ajax({
            type: "POST",
            url: "CheckOut.aspx/GetShopTimers",
            data: JSON.stringify({ shopIds: shopIds, addId: parseInt(addIdVal) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(res) {
                const timers = res.d;
                if (timers) {
                    let cartChanged = false;
                    const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
                    cartItems.forEach(item => {
                        const liveTimer = timers[item.shopId.toString()];
                        if (liveTimer !== undefined && item.deliveryTime !== liveTimer) {
                            item.deliveryTime = liveTimer;
                            cartChanged = true;
                        }
                    });
                    if (cartChanged) {
                        localStorage.setItem("cartItems", JSON.stringify(cartItems));
                        // Update the local "items" array too so that immediate UI calculations are correct
                        items.forEach(item => {
                            const liveTimer = timers[item.shopId.toString()];
                            if (liveTimer !== undefined) {
                                item.deliveryTime = liveTimer;
                            }
                        });

                        // Re-update total delivery time in summary
                        if (totalDeliveryTimeEl) {
                            const deliveryMethod = localStorage.getItem("deliveryMethod") || "delivery";
                            const isPickup = deliveryMethod === "pickup" || deliveryMethod === "in-shop";
                            if (isPickup) {
                                totalDeliveryTimeEl.innerText = `0 ${texts.Minutes}`;
                            } else {
                                const maxTime = items.reduce((max, item) => Math.max(max, parseInt(item.deliveryTime) || 0), 0);
                                totalDeliveryTimeEl.innerText = `${maxTime} ${texts.Minutes}`;
                            }
                        }

                        // Re-initialize scheduled time calculations
                        if (typeof initDeliveryTimeScheduling === 'function') {
                            initDeliveryTimeScheduling();
                        }
                    }

                    // Update UI elements for each shop timer
                    Object.keys(timers).forEach(sId => {
                        const liveTimer = timers[sId];
                        const deliveryMethod = localStorage.getItem("deliveryMethod") || "delivery";
                        const isPickup = deliveryMethod === "pickup" || deliveryMethod === "in-shop";
                        const displayTime = isPickup ? 0 : liveTimer;

                        const timerSpan = document.getElementById(`live-timer-val-${sId}`);
                        if (timerSpan) {
                            timerSpan.innerText = displayTime;
                        }
                    });
                }
            },
            error: function(err) {
                console.log("Error fetching shop timers:", err);
            }
        });
    }
    */
}

function initDeliveryTimeScheduling() {
    const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
    if (cartItems.length === 0) return;

    const scheduledTimeEl = document.getElementById("scheduledTime");
    const deliveryTimeHintEl = document.getElementById("deliveryTimeHint");
    const rescheduleBtn = document.getElementById("rescheduleBtn");
    const resetBtn = document.getElementById("resetScheduledBtn");
    const deliveryTimePicker = document.getElementById("deliveryTimePicker");

    if (!scheduledTimeEl || !rescheduleBtn) return;

    // 1. Calculate Max Delivery Time from all items in cart
    const maxDeliveryTime = cartItems.reduce((max, item) => {
        const time = parseInt(item.deliveryTime) || 0;
        return Math.max(max, time);
    }, 0) || 30; // Default to 30 mins if none found

    // 2. Set Default Time (Current + Max Delivery)
    const now = new Date();
    const deliveryMethod = localStorage.getItem("deliveryMethod") || "delivery";
    const isPickup = deliveryMethod === "pickup" || deliveryMethod === "in-shop";
    const minAllowedDate = isPickup ? now : new Date(now.getTime() + maxDeliveryTime * 60000);

    const formatTime = (date) => {
        return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true });
    };

    const setHintText = (text) => {
        if (deliveryTimeHintEl) {
            deliveryTimeHintEl.innerHTML = `<i class="fa-regular fa-clock"></i> ${text}`;
        }
    };

    const setDefaultTime = () => {
        if (isPickup) {
            scheduledTimeEl.innerText = formatTime(now);
            setHintText(`${texts.PrepTimeHint || "سيتم التحضير خلال"} ${maxDeliveryTime} ${texts.Minutes}`);
        } else {
            scheduledTimeEl.innerText = formatTime(minAllowedDate);
            setHintText(`${texts.DeliveryTimeHint} ${maxDeliveryTime} ${texts.Minutes}`);
        }

        if (window.cart) {
            window.cart.checkoutState.scheduledTime = '';
            window.cart.saveCheckoutState();
        }

        delete scheduledTimeEl.dataset.customSet;
        if (resetBtn) resetBtn.style.display = "none";
    };

    if (!scheduledTimeEl.dataset.customSet) {
        setDefaultTime();
    } else {
        if (resetBtn) resetBtn.style.display = "block";
    }

    // 3. Initialize Flatpickr for "Cool Calendar"
    if (typeof flatpickr !== 'undefined' && deliveryTimePicker) {
        const fp = flatpickr(deliveryTimePicker, {
            enableTime: true,
            noCalendar: true,
            dateFormat: "h:i K",
            time_24hr: false,
            minDate: minAllowedDate,
            locale: getCookie("lang") || "ar",
            position: "above center",
            positionElement: rescheduleBtn,
            allowInput: false,
            disableMobile: "true", // Force custom picker on mobile for better control
            onOpen: function(selectedDates, dateStr, instance) {
                const inputs = instance.calendarContainer.querySelectorAll('.flatpickr-time input');
                inputs.forEach(input => {
                    input.setAttribute('maxlength', '2');
                    input.oninput = function() {
                        if (this.value.length > 2) this.value = this.value.slice(0, 2);
                    };
                });
            },
            onClose: function(selectedDates) {
                if (selectedDates.length > 0) {
                    const selected = selectedDates[0];

                    // Show confirmation
                    Swal.fire({
                        title: texts.ConfirmRescheduleTitle || "\u062A\u0623\u0643\u064A\u062F \u0627\u0644\u062A\u0648\u0642\u064A\u062A",
                        text: (texts.ConfirmRescheduleText || "\u0647\u0644 \u0623\u0646\u062A \u0645\u062A\u0623\u0643\u062F \u0645\u0646 \u062A\u063A\u064A\u064A\u0631 \u0645\u0648\u0639\u062F \u0627\u0644\u0627\u0633\u062A\u0644\u0627\u0645 \u0625\u0644\u0649 {0}\u061F").replace('{0}', formatTime(selected)),
                        icon: "question",
                        showCancelButton: true,
                        confirmButtonText: texts.Confirm || "\u062A\u0623\u0643\u064A\u062F",
                        cancelButtonText: texts.Cancel || "\u0625\u0644\u063A\u0627\u0621",
                        confirmButtonColor: "var(--fd-blue)",
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const timeStr = formatTime(selected);
                            scheduledTimeEl.innerText = timeStr;
                            scheduledTimeEl.dataset.customSet = "true";

                            if (window.cart) {
                                window.cart.checkoutState.scheduledTime = timeStr;
                                window.cart.saveCheckoutState();
                            }

                            setHintText(`${texts.ScheduledAt || "مجدول في"}: ${timeStr}`);
                            if (resetBtn) resetBtn.style.display = "block";
                            if (typeof updateLiveSummary === 'function') updateLiveSummary();
                        }
                    });
                }
            }
        });

        rescheduleBtn.onclick = () => fp.open();
    }

    if (resetBtn) {
        resetBtn.onclick = () => {
            setDefaultTime();
            if (typeof updateLiveSummary === 'function') updateLiveSummary();
        };
    }
}

    window.updateCartUI = updateCartUI;
});
