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



    const cart = {
        // Expose to window for global access
        initGlobal() { window.cart = this; },

        items: JSON.parse(localStorage.getItem("cartItems")) || [],
        deliveryFee:
            parseFloat(document.querySelector("#deliveryFee")?.textContent.trim()) ||
            parseFloat(document.querySelector("#deliveryCostValue")?.textContent.trim()) ||
            parseFloat(localStorage.getItem("GLOBAL_DELIVERY_FEE")) || 0,
        save() {
            localStorage.setItem("cartItems", JSON.stringify(this.items));
            this.saveSummary();
            this.initGlobal();
            updateCartUI();
            updateCartCounter();
            updateTotalPayAmount();
            const checkoutCart = document.querySelector("#checkoutCart");
            if (checkoutCart) {
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

            const DISCOUNT_RATE = (typeof GLOBAL_AREA_DISCOUNT !== 'undefined') ? parseFloat(GLOBAL_AREA_DISCOUNT) / 100 : 0;

            // 1. تجميع رسوم المتاجر حسب الـ AreaId
            const areaMap = this.items.reduce((acc, item) => {
                // تأكد إن الـ IDs نصوص ونضيف trim عشان نمنع أي مسافات مخفية
                const aId = String(item.shopAreaId || "").trim();
                const sId = String(item.shopId || "").trim();
                const fee = parseFloat(item.deliveryFee) || 0;

                if (aId && sId) {
                    if (!acc[aId]) {
                        acc[aId] = {};
                    }
                    // بنخزن رسوم المتجر الواحد (مرة واحدة) جوه منطقته
                    acc[aId][sId] = fee;
                }
                return acc;
            }, {});

            // لعمل Debug في الكونسول وتشوف الـ Structure اللي اتكون
            console.log("Area Map Structure:", areaMap);

            // 2. الحساب لكل منطقة
            for (const aId in areaMap) {
                const shopsInThisArea = areaMap[aId];
                const feesArray = Object.values(shopsInThisArea);
                const sumFeesInArea = feesArray.reduce((sum, f) => sum + f, 0);

                console.log(`Area: ${aId}, Shops Count: ${feesArray.length}, Total Fees: ${sumFeesInArea}`);

                if (feesArray.length > 1) {
                    // ✅ أكتر من متجر في نفس الـ Area
                    const areaDiscount = sumFeesInArea * DISCOUNT_RATE;
                    totalDiscountAmount += areaDiscount;
                    finalDeliveryToPay += (sumFeesInArea - areaDiscount);
                } else {
                    // ❌ متجر واحد بس في المنطقة
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
        }
    ,

        getSubtotal() {
            return this.items.reduce((sum, item) => {
                const itemPrice = Number(item.price) || 0;
                let totalForItem = itemPrice * item.amount;

                if (item.customization) {
                    // Upsells with independent qty
                    (item.customization.upsells || []).forEach(u => {
                        totalForItem += (Number(u.price) || 0) * (u.qty || 0);
                    });
                }

                return sum + totalForItem;
            }, 0);
        },

        updateAddonQty(itemId, addonId, delta, type, shopId) {
            const item = this.items.find(i => i.id === itemId && i.shopId === shopId);
            if (!item || !item.customization || !item.customization[type]) return;

            const addon = item.customization[type].find(a => a.id === addonId);
            if (addon) {
                addon.qty = (addon.qty || 1) + delta;
                if (addon.qty < 1) {
                    this.removeAddon(itemId, addonId, type, shopId);
                    return;
                }
                this.save();
                if (typeof sync === 'function') this.sync();
            }
        },

        removeAddon(itemId, addonId, type, shopId) {
            const item = this.items.find(i => i.id === itemId && i.shopId === shopId);
            if (!item || !item.customization || !item.customization[type]) return;

            item.customization[type] = item.customization[type].filter(a => a.id !== addonId);
            this.save();
            if (typeof sync === 'function') this.sync();
        },

        updateItemNotes(itemId, newNotes, shopId) {
            const index = this.items.findIndex(i => i.id === itemId && i.shopId === shopId);
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
            const targetShopId = item.shopId || GLOBAL_shop_ID;
            const targetAreaId = item.areaId || GLOBAL_AREA_ID;

            const differentAreaExists = this.items.some(i => i.areaId !== targetAreaId);

            if (differentAreaExists) {
                Swal.fire({
                    title: texts.CannotAddDifferentAreaTitle,
                    text: texts.CannotAddDifferentAreaText,
                    icon: "error",
                    confirmButtonText:texts.Ok,
                });
                return false;
            }

            const existing = this.items.find(i => i.id === item.id && String(i.shopId) === String(targetShopId));
            if (existing) {
                existing.amount += count;
                this.save();
                return true;
            }

            const shopExists = this.items.some(i => String(i.shopId) === String(targetShopId));

            if (!isUpdate && !shopExists && this.items.length > 0) {
                const newItem = {
                    ...item,
                    amount: count,
                    placeId: item.placeId || GLOBAL_PLACE_ID,
                    areaId: targetAreaId,
                    deliveryFee: item.deliveryFee || GLOBAL_DELIVERY_FEE,
                    shopId: targetShopId,
                    shopName: item.shopName || GLOBAL_shopName,
                    shopAreaId: item.shopAreaId || GLOBAL_shopArea_ID,
                    addId: item.addId || GLOBAL_addid_ID,
                    deliveryTime: item.deliveryTime || GLOBAL_DELIVERY_TIME
                };

                Swal.fire({
                    title: texts.AddItemDifferentShopTitle,
                    text: texts.AddItemDifferentShopText,
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: texts.YesAdd,
                    cancelButtonText: texts.Cancel,
                    reverseButtons: true,
                }).then((result) => {
                    if (result.isConfirmed) {
                        cart.items.push(newItem);
                        cart.save();
                        showCartToast(texts.AddedFromDifferentShop);
                    }
                });
                return false;
            }

            this.items.push({
                ...item,
                amount: count,
                placeId: item.placeId || GLOBAL_PLACE_ID,
                areaId: targetAreaId,
                deliveryFee: item.deliveryFee || GLOBAL_DELIVERY_FEE,
                shopId: targetShopId,
                shopName: item.shopName || GLOBAL_shopName,
                shopAreaId: item.shopAreaId || GLOBAL_shopArea_ID,
                addId: item.addId || GLOBAL_addid_ID,
                deliveryTime: item.deliveryTime || getLiveDeliveryTime(),
            });

            this.save();
            return true;
        },

        removeItem(id, shopId) {
            this.items = this.items.filter(i => !(i.id === id && i.shopId === shopId));
            this.save();
        },

        increaseItem(id, shopId) {
            const existing = this.items.find(i => i.id === id && i.shopId === shopId);
            if (existing) {
                existing.amount += 1;
                this.save();
            }
        },

        decreaseItem(id, shopId) {
            const existing = this.items.find(i => i.id === id && i.shopId === shopId);
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

    window.cart = cart;

const cartData = JSON.parse(localStorage.getItem("cartItems")) || [];
const cartSummary = JSON.parse(localStorage.getItem("cartSummary")) || {};
renderCheckoutArticles(cartData, cartSummary);



const placeIdEl = document.querySelector("#placeId");
const areaIdEl = document.querySelector("#areaId");
const shopAreaIdEl = document.querySelector("#shopAreaId");
const shopIdEl = document.querySelector("#shopId"); // you said id="shopId"
const shopNameEl = document.querySelector("#shopName");
const addidEl = document.querySelector("#addid");
// if (shopAreaIdEl) {
//    localStorage.setItem("currentShopAreaId", shopAreaIdEl.textContent.trim());
// }
const areaDiscountEl = document.querySelector("#areaDiscountPercentage");
let GLOBAL_AREA_DISCOUNT = areaDiscountEl
    ? parseFloat(areaDiscountEl.textContent.trim().replace("%", "")) || 0
    : parseFloat(localStorage.getItem("GLOBAL_AREA_DISCOUNT")) || 0;

if (areaDiscountEl) {
    localStorage.setItem("GLOBAL_AREA_DISCOUNT", GLOBAL_AREA_DISCOUNT);
}

// Expose these to window for access in CheckOut.aspx
window.GLOBAL_AREA_DISCOUNT = GLOBAL_AREA_DISCOUNT;

let GLOBAL_PLACE_ID = placeIdEl ? placeIdEl.textContent.trim() : null;
let GLOBAL_AREA_ID = areaIdEl ? areaIdEl.textContent.trim() : null;
let GLOBAL_shop_ID = shopIdEl ? shopIdEl.textContent.trim() : null;
let GLOBAL_addid_ID = addidEl ? addidEl.textContent.trim() : null;
let GLOBAL_shopArea_ID = shopAreaIdEl ? shopAreaIdEl.textContent.trim() : null;

// Expose these to window for access in CheckOut.aspx
window.GLOBAL_AREA_DISCOUNT = GLOBAL_AREA_DISCOUNT;
window.GLOBAL_AREA_ID = GLOBAL_AREA_ID;
window.GLOBAL_shopArea_ID = GLOBAL_shopArea_ID;
window.GLOBAL_shop_ID = GLOBAL_shop_ID;

// Global Delivery Time from Shop Page - Function to get fresh value
function getLiveDeliveryTime() {
    const timerEl = document.querySelector(".timer");
    return timerEl ? parseInt(timerEl.textContent.trim()) || 0 : 0;
}
window.GLOBAL_DELIVERY_TIME = getLiveDeliveryTime();

let GLOBAL_DELIVERY_FEE =
    parseFloat(localStorage.getItem("GLOBAL_DELIVERY_FEE")) || 0;

const deliveryFeeEl = document.querySelector("#deliveryFee");
const deliveryCostValueEl = document.querySelector("#deliveryCostValue");
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
        localStorage.setItem("GLOBAL_DELIVERY_FEE", fee); // ✅ save it

        // Also update existing items for this shop if they have 0 fee
        const shopIdEl = document.querySelector("#shopId");

        if (shopIdEl) {
            const currentShopId = shopIdEl.textContent.trim();
            let updated = false;

            // Use window.cart.items if available, otherwise fallback to cartItems
            const targetItems = (window.cart && window.cart.items) ? window.cart.items : cartItems;

            targetItems.forEach(item => {
                if (String(item.shopId) === currentShopId && (!item.deliveryFee || item.deliveryFee === 0)) {
                    item.deliveryFee = fee;
                    updated = true;
                }
            });
            if (updated) {
                if (window.cart && typeof window.cart.save === 'function') {
                    window.cart.save();
                } else {
                    localStorage.setItem("cartItems", JSON.stringify(targetItems));
                }
            }
        }
    }
}

let GLOBAL_shopName = shopNameEl ? shopNameEl.textContent.trim() : (localStorage.getItem("currentShopName") || "");

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
                shopLabel.innerHTML = `<i class="fa-solid fa-store"></i> ${group.shopName}`;
                wrapper.appendChild(shopLabel);

                // Render each product in shop
                group.items.forEach(item => {
                    const priceNum = Number(item.price) || 0;
                    let addonsTotal = 0;
                    if (item.customization) {
                        (item.customization.quickChoices || []).forEach(qc => addonsTotal += (Number(qc.price) || 0) * (qc.qty || 1));
                        (item.customization.extras || []).forEach(ex => addonsTotal += (Number(ex.price) || 0));
                        (item.customization.upsells || []).forEach(up => addonsTotal += (Number(up.price) || 0) * (up.qty || 0));
                    }
                    // Parent item total (just product * amount)
                    const itemOnlyTotal = priceNum * item.amount;
                    // Group total (item + all addons)
                    const groupTotalPrice = itemOnlyTotal + addonsTotal;

                    const itemGroup = document.createElement("div");
                    itemGroup.classList.add("cart-item-group");
                    itemGroup.setAttribute("data-item-id", item.id);

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
                            ${item.isCustomized ? `<span class="addons-badge ${item.isCustomProduct && (item.hasActualCustomizations === false || (!item.customization?.extras?.length && !item.customization?.upsells?.length && (!item.customization?.size || item.customization?.size?.id === 'size-small'))) ? 'suggestion-badge' : ''}" onclick="event.stopPropagation(); openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')})">${item.isCustomProduct && (item.hasActualCustomizations === false || (!item.customization?.extras?.length && !item.customization?.upsells?.length && (!item.customization?.size || item.customization?.size?.id === 'size-small'))) ? '<i class="fa-solid fa-wand-magic-sparkles"></i> ' + texts.Extras : texts.Extras}</span>` : ''}
                            ${(item.customization?.notes || item.notes) ? `<span class="notes-badge" onclick="event.stopPropagation(); if(typeof openSimpleNotesModal==='function') openSimpleNotesModal(null, '${item.name.replace(/'/g, "\\'")}', ${item.price}, '${(item.desc || '').replace(/'/g, "\\'")}', '${item.id}'); else openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')}, null, null, null, null, true)">${texts.Notes}</span>` : ''}
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
                                div.innerHTML = `
                                    <span>+ ${ex.name}</span>
                                    <div class="cust-right-col">
                                        <span class="cust-price">${(Number(ex.price) || 0).toLocaleString()} ${texts.Currency}</span>
                                        <span class="remove-cust-item" onclick="event.stopPropagation(); cart.removeAddon('${item.id}', '${ex.id}', 'extras', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
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
                                    <button class="decrease" type="button" onclick="event.stopPropagation(); cart.updateAddonQty('${item.id}', '${upsell.id}', -1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                    <span class="itemAmount">${upsell.qty}</span>
                                    <button class="increase" type="button" onclick="event.stopPropagation(); cart.updateAddonQty('${item.id}', '${upsell.id}', 1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                                </div>
                                <div class="orderedItemMain">
                                    <span class="orderedItemName">${upsell.name}</span>
                                </div>
                                <span class="totalItemPrice">${upsellTotal.toLocaleString()} ${texts.Currency}</span>
                                <span class="removeUpsellItem" onclick="event.stopPropagation(); cart.removeAddon('${item.id}', '${upsell.id}', 'upsells', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
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
                    article.querySelector(".increase").onclick = () => cart.increaseItem(item.id, item.shopId);
                    article.querySelector(".decrease").onclick = () => cart.decreaseItem(item.id, item.shopId);
                    article.querySelector(".removeCartItem").onclick = () => cart.removeItem(item.id, item.shopId);

                    // Edit Logic for customized items
                    if (item.isCustomized && typeof openHardcodedModal === 'function') {
                        const editTrigger = article.querySelector(".orderedItemMain");
                        if (editTrigger) {
                            editTrigger.style.cursor = "pointer";
                            editTrigger.onclick = () => openHardcodedModal(item);
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
                if (e.target.closest("button")) return;

                const id = itemEl.getAttribute("id");
                const name = itemEl.querySelector(".foodName")?.textContent.trim();
                const price = itemEl.querySelector(".foodNewPrice")?.textContent.trim();

                if (id && name && price) {
                    // Load clicked IDs from localStorage
                    let clickedIds = JSON.parse(localStorage.getItem("clickedProductIds")) || [];

                    // Only add to clicked IDs if not already present
                    const isNewClick = !clickedIds.includes(id);
                    if (isNewClick) {
                        clickedIds.push(id);
                        localStorage.setItem("clickedProductIds", JSON.stringify(clickedIds));
                    }

                    // Add item to cart
                    cart.addItem({
                        id, // unique product ID
                        name,
                        price: parseFloat(price.replace(/[^\d.]/g, "")),
                        placeId: GLOBAL_PLACE_ID,
                        areaId: GLOBAL_AREA_ID,
                        deliveryFee: GLOBAL_DELIVERY_FEE,
                        shopId: GLOBAL_shop_ID,
                        shopName: GLOBAL_shopName,
                        shopAreaId: GLOBAL_shopArea_ID,
                        addId: GLOBAL_addid_ID

                    });


                    // Show toast ONLY if first time clicked
                    if (isNewClick) {
                        showCartToast(`${texts.AddedToCartPrefix} "${name}" ${texts.AddedToCartSuffix}`);
                    }

                    console.log("Clicked product IDs:", clickedIds);
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

        const isPickup = localStorage.getItem("deliveryMethod") === "pickup";
        const shopDeliveryTime = isPickup ? 0 : (shopGroup.items[0].deliveryTime || 0);

        titleDiv.innerHTML = `
      <div style="display: flex; flex-direction: column; gap: 4px;">
        <h2 style="display: flex; align-items: center; gap: 10px; margin-bottom: 0;">
            <i class="fa-solid fa-store" style="color: var(--orange-500); font-size: 1.4rem;"></i>
            ${shopGroup.shopName}
        </h2>
        <small style="color: #666; font-size: 0.85rem; margin-inline: 1rem;">
            <i class="fa-regular fa-clock"></i> ${texts.DeliveryTimeHint} ${shopDeliveryTime} ${texts.Minutes}
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
                        <div class="cart-item-badges">
                            ${item.isCustomized ? `<span class="addons-badge ${item.isCustomProduct && (item.hasActualCustomizations === false || (!item.customization?.extras?.length && !item.customization?.upsells?.length && (!item.customization?.size || item.customization?.size?.id === 'size-small'))) ? 'suggestion-badge' : ''}" onclick="if(typeof openHardcodedModal==='function') openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')})">${item.isCustomProduct && (item.hasActualCustomizations === false || (!item.customization?.extras?.length && !item.customization?.upsells?.length && (!item.customization?.size || item.customization?.size?.id === 'size-small'))) ? '<i class="fa-solid fa-wand-magic-sparkles"></i> ' + texts.Extras : texts.Extras}</span>` : ''}
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
                                <button class="decrease" type="button" onclick="cart.updateAddonQty('${item.id}', '${qc.id}', -1, 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                <span class="itemAmount">${qc.qty || 1}</span>
                                <button class="increase" type="button" onclick="cart.updateAddonQty('${item.id}', '${qc.id}', 1, 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                            </div>
                            <span class="itemPrice">${qc.price} ${texts.Currency}</span>
                            <span class="itemTotal">${(qc.price * (qc.qty || 1)).toFixed(2)} ${texts.Currency}</span>
                            <span class="removeItem" onclick="cart.removeAddon('${item.id}', '${qc.id}', 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
                        `;
                        itemGroupWrapper.appendChild(exRow);
                    });

                    // Extras (legacy)
                    (item.customization.extras || []).forEach(ex => {
                        const exRow = document.createElement("div");
                        exRow.classList.add("orderStats", "checkout-customization-row");
                        exRow.innerHTML = `
                            <span class="orderName"><small>+ ${ex.name}</small></span>
                            <span></span>
                            <span class="itemPrice">${ex.price} ${texts.Currency}</span>
                            <span class="itemTotal">${(ex.price).toFixed(2)} ${texts.Currency}</span>
                            <span class="removeItem" onclick="cart.removeAddon('${item.id}', '${ex.id}', 'extras', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
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
                                    <button class="decrease" type="button" onclick="cart.updateAddonQty('${item.id}', '${up.id}', -1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                    <span class="itemAmount">${up.qty}</span>
                                    <button class="increase" type="button" onclick="cart.updateAddonQty('${item.id}', '${up.id}', 1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                                </div>
                                <span class="itemPrice">${up.price} ${texts.Currency}</span>
                                <span class="itemTotal">${upTotal} ${texts.Currency}</span>
                                <span class="removeItem" onclick="cart.removeAddon('${item.id}', '${up.id}', 'upsells', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
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
                            <textarea class="notes-textarea" placeholder="${texts.AddNotesPlaceholder}" onblur="cart.updateItemNotes('${item.id}', this.value, '${item.shopId}')">${noteText}</textarea>
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
                row.querySelector(".increase").onclick = () => cart.increaseItem(item.id, item.shopId);
                row.querySelector(".decrease").onclick = () => cart.decreaseItem(item.id, item.shopId);
                row.querySelector(".removeItem").onclick = () => cart.removeItem(item.id, item.shopId);
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
        const isPickup = localStorage.getItem("deliveryMethod") === "pickup";
        if (isPickup) {
            totalDeliveryTimeEl.innerText = `0 ${texts.Minutes}`;
        } else {
            const maxTime = items.reduce((max, item) => Math.max(max, parseInt(item.deliveryTime) || 0), 0);
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
    const isPickup = localStorage.getItem("deliveryMethod") === "pickup";
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
