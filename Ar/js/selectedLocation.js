document.addEventListener("DOMContentLoaded", () => {
    let currentSort = "alphabeticOrder";
    let sortDirection = "asc";

    // Store the original static list of shops once
    const shops = [...document.querySelectorAll(".availableShop")];
    const pagination = document.getElementById("shopNavNums");
    const btnNext = document.getElementById("shopNavRight");
    const btnPrev = document.getElementById("shopNavLeft");
    const searchInput = document.getElementById("selectedShopSearcher");
    const noMatchFigure = document.getElementById("noShopsMatched");

    const filterRating = document.getElementById("filterRating");
    const filterFree = document.getElementById("filterFree");
    const filterFast = document.getElementById("deliveryTime");
    const filterBtn = document.getElementById("filterShopsBtn");

    let filteredShops = [...shops];

    // Fix: Ensure perPage is always recalculating correctly
    const getPerPage = () => (window.innerWidth <= 600 ? 1000 : 1000);
    let perPage = getPerPage();
    console.log("Current perPage:", perPage);
    let currentPage = 1;

    // ---------------- Helper Functions ----------------

    function parseDeliveryPrice(text) {
        if (!text) return { isFree: false, price: null };
        const t = text.trim().toLowerCase();
        if (t.includes("مجاني") || t.includes("free")) return { isFree: true, price: 0 };
        const match = t.match(/(\d+[\.,]?\d*)/);
        if (match) {
            const val = parseFloat(match[1].replace(",", "."));
            return { isFree: val === 0, price: val };
        }
        return { isFree: false, price: null };
    }

    function parseDeliveryTime(shop) {
        const timer = shop.querySelector(".timer");
        if (timer) return parseInt(timer.textContent.trim()) || 0;
        return 999;
    }

    function getShopName(shop) {
        return shop.querySelector(".availableShopName")?.textContent.trim().toLowerCase() || "";
    }

    function getMinPay(shop) {
        const text = shop.querySelector(".minPay")?.textContent || "0";
        const num = parseFloat(text.match(/[\d.]+/)?.[0]);
        return isNaN(num) ? 0 : num;
    }

    function getRating(shop) {
        const stars = shop.querySelector(".shopRatingStars")?.textContent || "0";
        return parseFloat(stars) || 0;
    }

    // ---------------- Filtering ----------------

    function applyFilters() {
        // Update perPage on every filter/init call to handle resize
        perPage = getPerPage();
        const query = (searchInput?.value || "").trim().toLowerCase();

        filteredShops = shops.filter(shop => {
            const name = getShopName(shop);

            if (query && !name.includes(query)) return false;
            if (filterRating?.checked && getRating(shop) < 4) return false;

            const feeText = shop.querySelector(".deliveryPaymentAmount")?.textContent;
            const { isFree } = parseDeliveryPrice(feeText);
            if (filterFree?.checked && !isFree) return false;

            const time = parseDeliveryTime(shop);
            if (filterFast?.checked && time > 30) return false;

            return true;
        });

        applySorting();
        currentPage = 1;
        createPagination();
        showPage(1);
    }

    // ---------------- Sorting ----------------

    function setActiveSort(sortId) {
        document.querySelectorAll(".filterCategory").forEach(el => el.classList.remove("active"));

        if (currentSort === sortId) {
            sortDirection = sortDirection === "asc" ? "desc" : "asc";
        } else {
            sortDirection = sortId === "ratingOrder" ? "desc" : "asc";
        }

        currentSort = sortId;
        const targetBtn = document.getElementById(sortId);
        if (targetBtn) targetBtn.classList.add("active");
    }

    function applySorting() {
        filteredShops.sort((a, b) => {
            switch (currentSort) {
                case "alphabeticOrder":
                    return sortDirection === "asc"
                      ? getShopName(a).localeCompare(getShopName(b), "ar")
                      : getShopName(b).localeCompare(getShopName(a), "ar");
                case "minPayOrder":
                    return sortDirection === "asc" ? getMinPay(a) - getMinPay(b) : getMinPay(b) - getMinPay(a);
                case "deliveryTimeOrder":
                    return sortDirection === "asc" ? parseDeliveryTime(a) - parseDeliveryTime(b) : parseDeliveryTime(b) - parseDeliveryTime(a);
                case "deliveryFeeOrder":
                    const feeA = parseDeliveryPrice(a.querySelector(".deliveryPaymentAmount")?.textContent).price ?? 9999;
                    const feeB = parseDeliveryPrice(b.querySelector(".deliveryPaymentAmount")?.textContent).price ?? 9999;
                    const isFreeA = parseDeliveryPrice(a.querySelector(".deliveryPaymentAmount")?.textContent).isFree;
                    const isFreeB = parseDeliveryPrice(b.querySelector(".deliveryPaymentAmount")?.textContent).isFree;

                    if (sortDirection === "asc") {
                        if (isFreeA && !isFreeB) return -1;
                        if (!isFreeA && isFreeB) return 1;
                    }
                    return sortDirection === "asc" ? feeA - feeB : feeB - feeA;
                case "ratingOrder":
                    return sortDirection === "asc" ? getRating(a) - getRating(b) : getRating(b) - getRating(a);
                default:
                    return 0;
            }
        });
    }

    function sortAndShow(sortId) {
        setActiveSort(sortId);
        applySorting();
        currentPage = 1;
        createPagination();
        showPage(currentPage);
    }

    // ---------------- Pagination ----------------

    function showPage(page) {
        perPage = getPerPage(); // Re-check perPage
        const start = (page - 1) * perPage;
        const end = start + perPage;

        const parent = document.querySelector(".allAvailableShops");
        if (!parent) return;

        // Clear the container
        parent.innerHTML = "";

        const pageShops = filteredShops.slice(start, end);

        if (pageShops.length === 0 && filteredShops.length > 0) {
            // Fallback if page becomes out of bounds
            currentPage = 1;
            showPage(1);
            return;
        }

        pageShops.forEach(shop => parent.appendChild(shop));

        const totalPages = Math.ceil(filteredShops.length / perPage) || 1;

        if (btnPrev) btnPrev.style.display = page === 1 ? "none" : "inline-block";
        if (btnNext) btnNext.style.display = (page >= totalPages || filteredShops.length === 0) ? "none" : "inline-block";

        if (noMatchFigure) {
            noMatchFigure.style.display = filteredShops.length ? "none" : "block";
        }
    }

    function createPagination() {
        if (!pagination) return;
        perPage = getPerPage();
        const totalPages = Math.ceil(filteredShops.length / perPage);

        pagination.innerHTML = "";

        if (totalPages <= 1) {
            pagination.style.display = "none";
            return;
        }

        pagination.style.display = "flex";

        for (let i = 1; i <= totalPages; i++) {
            const btn = document.createElement("button");
            btn.textContent = i;
            btn.type = "button";
            btn.classList.add("page-btn");
            if (i === currentPage) btn.classList.add("active");

            btn.onclick = () => {
                currentPage = i;
                // Update active class manually for speed or recreate
                createPagination();
                showPage(currentPage);
                window.scrollTo({ top: 0, behavior: "smooth" });
            };
            pagination.appendChild(btn);
        }
    }

    // ---------------- Event Listeners ----------------

    const orders = ["alphabeticOrder", "minPayOrder", "deliveryTimeOrder", "deliveryFeeOrder", "ratingOrder"];
    orders.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener("click", () => sortAndShow(id));
    });

    searchInput?.addEventListener("input", applyFilters);
    filterBtn?.addEventListener("click", applyFilters);

    window.addEventListener("resize", () => {
        const newPerPage = getPerPage();
        if (newPerPage !== perPage) {
            perPage = newPerPage;
            currentPage = 1;
            createPagination();
            showPage(1);
        }
    });

    if (btnNext) {
        btnNext.onclick = () => {
            if (currentPage < Math.ceil(filteredShops.length / perPage)) {
                currentPage++;
                showPage(currentPage);
                createPagination();
                window.scrollTo({ top: 0, behavior: "smooth" });
            }
        };
    }

    if (btnPrev) {
        btnPrev.onclick = () => {
            if (currentPage > 1) {
                currentPage--;
                showPage(currentPage);
                createPagination();
                window.scrollTo({ top: 0, behavior: "smooth" });
            }
        };
    }

    // Initial Run
    applyFilters();
});
