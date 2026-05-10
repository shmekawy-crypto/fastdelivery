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



    const cart = {
        items: JSON.parse(localStorage.getItem("cartItems")) || [],
        deliveryFee:
    parseFloat(document.querySelector("#deliveryFee")?.textContent.trim()) ||
      parseFloat(localStorage.getItem("GLOBAL_DELIVERY_FEE")) || 0,
        save() {
            localStorage.setItem("cartItems", JSON.stringify(this.items));
            this.saveSummary();
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


        addItem(item, count = 1) {
            const differentAreaExists = this.items.some(i => i.areaId !== GLOBAL_AREA_ID);

            if (differentAreaExists) {
                Swal.fire({
                    title: texts.CannotAddDifferentAreaTitle,
                    text: texts.CannotAddDifferentAreaText,
                    icon: "error",
                    confirmButtonText:texts.Ok,
                });
                return;
            }

            const shopExists = this.items.some(i => i.shopId === GLOBAL_shop_ID);

            if (!shopExists && this.items.length > 0) {
                const newItem = {
                    ...item,
                    amount: count,
                    placeId: GLOBAL_PLACE_ID,
                    areaId: GLOBAL_AREA_ID,
                    deliveryFee: GLOBAL_DELIVERY_FEE,
                    shopId: GLOBAL_shop_ID,
                    shopName: GLOBAL_shopName,
                    shopAreaId: GLOBAL_shopArea_ID,
                    addId: GLOBAL_addid_ID
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
                return;
            }

            const existing = this.items.find(i => i.id === item.id && i.shopId === GLOBAL_shop_ID);
            if (existing) {
                existing.amount += count;
            } else {
                this.items.push({
                    ...item,
                    amount: count,
                    placeId: GLOBAL_PLACE_ID,
                    areaId: GLOBAL_AREA_ID,
                    deliveryFee: GLOBAL_DELIVERY_FEE,
                    shopId: GLOBAL_shop_ID,
                    shopName: GLOBAL_shopName,
                    shopAreaId: GLOBAL_shopArea_ID,
                    addId: GLOBAL_addid_ID,
                });
            }

            this.save();
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

let GLOBAL_PLACE_ID = placeIdEl ? placeIdEl.textContent.trim() : null;
let GLOBAL_AREA_ID = areaIdEl ? areaIdEl.textContent.trim() : null;
let GLOBAL_shop_ID = shopIdEl ? shopIdEl.textContent.trim() : null;
let GLOBAL_addid_ID = addidEl ? addidEl.textContent.trim() : null;
let GLOBAL_shopArea_ID = shopAreaIdEl ? shopAreaIdEl.textContent.trim() : null;

let GLOBAL_DELIVERY_FEE =
    parseFloat(localStorage.getItem("GLOBAL_DELIVERY_FEE")) || 0;

const deliveryFeeEl = document.querySelector("#deliveryFee");
if (deliveryFeeEl) {
    const fee = parseFloat(deliveryFeeEl.textContent.trim());
    if (!isNaN(fee)) {
        GLOBAL_DELIVERY_FEE = fee;
        localStorage.setItem("GLOBAL_DELIVERY_FEE", fee); // ✅ save it
    }
}

let GLOBAL_shopName= shopNameEl.textContent.trim();

function showCartToast(message = texts.AddedToCartDefault, options = {}) {
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
        const inCart = document.querySelector("#inCartItems");
        const empty = document.querySelector("#emptyCart");
        if (!inCart || !empty) return;

        // Save scroll position
        const scrollPos = inCart.scrollTop;

        // Remove old wrapper if exists
        const oldWrapper = inCart.querySelector(".orderedItemsWrapper");
        if (oldWrapper) oldWrapper.remove();

        // Show empty message if cart is empty
        if (cart.items.length === 0) {
            empty.style.display = "flex";
            inCart.style.display = "none";
            cart.saveSummary();
            updateCartCounter();
            updateTotalPayAmount();
            renderCheckoutArticles(cart.items, JSON.parse(localStorage.getItem("cartSummary")) || {});
            return;
        }

        empty.style.display = "none";
        inCart.style.display = "flex";

        // Create wrapper for items
        const wrapper = document.createElement("div");
        wrapper.classList.add("orderedItemsWrapper");

        const preDeliveryEl = inCart.querySelector(".preDeliveryFeeAmount");
        if (preDeliveryEl) {
            inCart.insertBefore(wrapper, preDeliveryEl);
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
                        ${item.isCustomized ? `<span class="addons-badge" onclick="event.stopPropagation(); openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')})">إضافات</span>` : ''}
                        ${(item.customization?.notes || item.notes) ? `<span class="notes-badge" onclick="event.stopPropagation(); if(typeof openSimpleNotesModal==='function') openSimpleNotesModal(null, '${item.name.replace(/'/g, "\\'")}', ${item.price}, '${(item.desc || '').replace(/'/g, "\\'")}', '${item.id}'); else openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')}, null, null, null, null, true)">ملاحظات</span>` : ''}
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
                                <button class="decrease" onclick="event.stopPropagation(); cart.updateAddonQty('${item.id}', '${upsell.id}', -1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                <span class="itemAmount">${upsell.qty}</span>
                                <button class="increase" onclick="event.stopPropagation(); cart.updateAddonQty('${item.id}', '${upsell.id}', 1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
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
                        <span class="group-total-label">${texts.TotalGroupCost || 'إجمالي التكلفة'}:</span>
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

        // Update totals
        cart.saveSummary();
        updateCartCounter();
        updateTotalPayAmount();

        // Update subtotal, delivery,  total in the popup
        const summary = JSON.parse(localStorage.getItem("cartSummary")) || {
            subtotal: 0,
            delivery: cart.deliveryFee,
            total: 0
        };

        const subtotalEl = document.querySelector(".subtotalAmount");
        const deliveryEls = document.querySelectorAll(".deliveryFee");
        const totalEl = document.querySelector(".totalAmount");

        if (subtotalEl) subtotalEl.textContent = Number(summary.subtotal).toLocaleString() + ` ${texts.Currency}`;
        if (deliveryEls.length >= 1) deliveryEls[0].textContent = Number(summary.delivery).toFixed(2) + ` ${texts.Currency}`;
        if (totalEl) totalEl.textContent = Number(summary.total).toLocaleString() + ` ${texts.Currency}`;

        // Restore scroll position at the very end
        inCart.scrollTop = scrollPos;
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
const btn = document.querySelector(buttonSelector);
    if (!btn) return;

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

// Fallback for lazy DOM content
setTimeout(() => {
    updateCartUI();
    updateCartCounter();
    updateTotalPayAmount();
}, 300);

// ✅ Make accessible globally for debugging
// Make accessible globally for debugging

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
                    // تحديث العناصر مباشرة
                    document.getElementById("AddName").innerText = data.AddName;
                    document.getElementById("StreetName").innerText = data.StreetName;
                    document.getElementById("mobile").innerText = data.mobile;
                    document.getElementById("location").innerText = data.Gov+'-'+data.Area;
                    document.getElementById("phone").innerText = data.phone;
                    document.getElementById("Build").innerText = data.Build;
                    document.getElementById("Floor").innerText = data.Floor;

                    document.getElementById("Area").innerText = data.Area;
                    document.getElementById("Gov").innerText = data.Gov;
                    document.getElementById("AdepartmentNo").innerText = data.AdepartmentNo;

                    document.getElementById("Instructions").innerText = data.Instructions;
                    document.getElementById("AType").innerText = data.AType;

                    // تحديث HiddenField لو عايز تحتفظ بالـ addId
                    document.getElementById("ContentPlaceHolder1_hfAddId").value = addId;
                },
                error: function(err) {
                    console.log("AJAX Error:", err);
                }
            });
        }


        sendAddId(addId);
        titleDiv.innerHTML = `
      <h2>${shopGroup.shopName}</h2>
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
                row.classList.add("orderStats", "checkout-main-item-row", "orderedItem");

                row.innerHTML = `
                    <div class="cartItemAmountHandlers">
                      <button class="decrease"><i class="fa-solid fa-minus"></i></button>
                      <span class="itemAmount">${item.amount}</span>
                      <button class="increase"><i class="fa-solid fa-plus"></i></button>
                    </div>
                    <div class="orderedItemMain">
                        <span class="orderedItemName">
                            ${item.name} 
                            ${item.customization?.size ? `<small class="checkout-item-size">(${item.customization.size.name})</small>` : ''}
                            <small class="unit-price">(${item.price.toFixed(2)} ${texts.Currency})</small>
                        </span>
                        <div class="cart-item-badges">
                            ${item.isCustomized ? `<span class="addons-badge" onclick="if(typeof openHardcodedModal==='function') openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')})">إضافات</span>` : ''}
                            ${(item.customization?.notes || item.notes) ? `<span class="notes-badge" onclick="if(typeof openSimpleNotesModal==='function') openSimpleNotesModal(null, '${item.name.replace(/'/g, "\\'")}', ${item.price}, '${(item.desc || '').replace(/'/g, "\\'")}', '${item.id}'); else openHardcodedModal(${JSON.stringify(item).replace(/"/g, '&quot;')}, null, null, null, null, true)">ملاحظات</span>` : ''}
                        </div>
                    </div>
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
                                <button class="decrease" onclick="cart.updateAddonQty('${item.id}', '${qc.id}', -1, 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                <span class="itemAmount">${qc.qty || 1}</span>
                                <button class="increase" onclick="cart.updateAddonQty('${item.id}', '${qc.id}', 1, 'quickChoices', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
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
                                    <button class="decrease" onclick="cart.updateAddonQty('${item.id}', '${up.id}', -1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-minus"></i></button>
                                    <span class="itemAmount">${up.qty}</span>
                                    <button class="increase" onclick="cart.updateAddonQty('${item.id}', '${up.id}', 1, 'upsells', '${item.shopId}')"><i class="fa-solid fa-plus"></i></button>
                                </div>
                                <span class="itemPrice">${up.price} ${texts.Currency}</span>
                                <span class="itemTotal">${upTotal} ${texts.Currency}</span>
                                <span class="removeItem" onclick="cart.removeAddon('${item.id}', '${up.id}', 'upsells', '${item.shopId}')"><i class="fa-solid fa-trash"></i></span>
                            `;
                            itemGroupWrapper.appendChild(upRow);
                        });
                    }


                    // Total Row for Checkout Group
                    const groupTotalDiv = document.createElement("div");
                    groupTotalDiv.classList.add("checkout-group-total");
                    groupTotalDiv.innerHTML = `
                        <span class="group-total-label">${texts.TotalGroupCost || 'إجمالي التكلفة'}:</span>
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
        checkoutCart.appendChild(article);
    });

    // TOTAL AMOUNT article
    const totalArticle = document.createElement("article");
    totalArticle.classList.add("checkoutBox", "totalAmountBox");
    totalArticle.innerHTML = `
    <div class="checkoutBoxTitle">
      <h2>${texts.Total}</h2>
    </div>

    <div class="orderInfo">
      <div class="orderStats">
        <span>${texts.Subtotal}:</span>
        <span>${Number(summary.subtotal || 0).toLocaleString()} ${texts.Currency}</span>
      </div>
      <div class="orderStats">
        <span>${texts.DeliveryFee}:</span>
        <span id="Deliverycost">
    ${(() => {
        let value = Number(summary.delivery || 0);
        return (value % 1 === 0 ? value : value.toFixed(2)) + ` ${texts.Currency}`;
    })()}
</span>
      </div>
      <div class="orderStats" style="font-weight: bold;">
        <span>${texts.FinalTotal}:</span>
        <span>${Number(summary.total || 0).toLocaleString()} ${texts.Currency}</span>
      </div>
    </div>
  `;
    checkoutCart.appendChild(totalArticle);
}
});
