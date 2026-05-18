// ✅ التعامل مع تغيير حالة الهيدر عند التمرير
function handleScroll() {
    const header = document.querySelector(".header");
    if (window.scrollY > 50) header.classList.add("scrolled");
    else header.classList.remove("scrolled");
}

// ✅ تحديث روابط الأزرار بالعربية
function updateLoginBtnBehavior() {
    // This logic is now handled by showModal() in MasterPage.master
    return;
}

document.addEventListener("DOMContentLoaded", () => {
    handleScroll();
    window.addEventListener("scroll", handleScroll);

    const loginBtn = document.getElementById("login-modal-btn");
    const loginLink = document.getElementById("loginPage-modal-btn");
    const closeModalBtn = document.getElementById("close-modal-btn");
    const modalOverlay = document.getElementById("login-modal-overlay");
    const userDropDown = document.getElementById("userDropDown");

    // ✅ دوال فتح وإغلاق المودال
    window.openModal = function () {
        modalOverlay.classList.add("is-visible");
        document.body.style.overflow = "hidden";
    };

    function closeModal() {
        modalOverlay.classList.remove("is-visible");
        document.body.style.overflow = "";
    }

    if (loginLink) loginLink.addEventListener("click", openModal);
    if (closeModalBtn) closeModalBtn.addEventListener("click", closeModal);

    if (modalOverlay) {
        modalOverlay.addEventListener("click", (e) => {
            if (e.target === modalOverlay) closeModal();
        });
    }

    document.addEventListener("keydown", (e) => {
        if (e.key === "Escape" && modalOverlay?.classList.contains("is-visible"))
          closeModal();
    });

    // ✅ إظهار أو إخفاء كلمة المرور
    document.querySelectorAll(".showPassword").forEach((toggle) => {
        toggle.addEventListener("click", () => {
            const wrapper = toggle.closest(".password-input-wrapper");
            const input = wrapper?.querySelector(".password-input");
            if (!input) return;

            const isPassword = input.type === "password";
            input.type = isPassword ? "text" : "password";
            toggle.textContent = isPassword ? "إخفاء" : "إظهار";
        });
    });

    // ✅ التحقق من صحة بيانات التسجيل
    const form = document.querySelector('form[data-testid="form-login"]');
    if (!form) return;

    const firstNameInput = document.getElementById("firstName-input");
    const lastNameInput = document.getElementById("lastName-input");
    const emailInputLoginPage = document.getElementById("emailLoginPage-input");
    const passwordInputLoginPage = document.getElementById(
      "password-input-field-loginPage"
    );

    const isValidEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

    const setInvalid = (input, message) => {
        input.classList.add("invalid");
        input.setCustomValidity(message);
    };

    const clearInvalid = (input) => {
        input.classList.remove("invalid");
        input.setCustomValidity("");
    };

    const validateInputs = () => {
        let isValid = true;
        let message = "";

        if (!firstNameInput.value.trim()) {
            setInvalid(firstNameInput, "من فضلك أدخل الاسم الأول");
            message = "من فضلك أدخل الاسم الأول";
            isValid = false;
        } else clearInvalid(firstNameInput);

        if (isValid && !lastNameInput.value.trim()) {
            setInvalid(lastNameInput, "من فضلك أدخل اسم العائلة");
            message = "من فضلك أدخل اسم العائلة";
            isValid = false;
        } else clearInvalid(lastNameInput);

        if (isValid && !emailInputLoginPage.value.trim()) {
            setInvalid(emailInputLoginPage, "من فضلك أدخل البريد الإلكتروني");
            message = "من فضلك أدخل البريد الإلكتروني";
            isValid = false;
        } else if (isValid && !isValidEmail(emailInputLoginPage.value.trim())) {
            setInvalid(emailInputLoginPage, "البريد الإلكتروني غير صالح");
            message = "البريد الإلكتروني غير صالح";
            isValid = false;
        } else clearInvalid(emailInputLoginPage);

        if (isValid && !passwordInputLoginPage.value.trim()) {
            setInvalid(passwordInputLoginPage, "من فضلك أدخل كلمة المرور");
            message = "من فضلك أدخل كلمة المرور";
            isValid = false;
        } else if (isValid && passwordInputLoginPage.value.trim().length < 6) {
            setInvalid(
              passwordInputLoginPage,
              "كلمة المرور يجب أن تكون 6 أحرف على الأقل"
            );
            message = "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
            isValid = false;
        } else clearInvalid(passwordInputLoginPage);

        if (!isValid && message) {
            Swal.fire({
                icon: "error",
                title: "⚠️ خطأ في الإدخال",
                text: message,
                confirmButtonText: "حسنًا",
                confirmButtonColor: "#d33",
            });
        }

        return isValid;
    };

    // ✅ عند إرسال النموذج (تسجيل المستخدم)
    form.addEventListener("submit", (e) => {
        e.preventDefault();
        if (!validateInputs()) return;

        const user = {
            firstName: firstNameInput.value.trim(),
            lastName: lastNameInput.value.trim(),
            email: emailInputLoginPage.value.trim(),
            password: passwordInputLoginPage.value.trim(),
        };

        localStorage.setItem("fastDeliveryUser", JSON.stringify(user));

        Swal.fire({
            icon: "success",
            title: "🎉 تم التسجيل بنجاح",
            text: `مرحبًا بك يا ${user.firstName}`,
            confirmButtonText: "استمرار",
            confirmButtonColor: "#3085d6",
        }).then(() => {
            form.reset();
            closeModal();
            updateLoginBtnBehavior();
            window.location.href = "html_web.html";
        });
    });

    document.addEventListener("click", (e) => {
        if (
          userDropDown &&
          userDropDown.classList.contains("showDropDown") &&
          !userDropDown.contains(e.target) &&
          e.target.id !== "login-modal-btn"
        ) {
            userDropDown.classList.remove("showDropDown");
        }
    });

    const logOut = document.getElementById("logOut");
    if (logOut) {
        logOut.addEventListener("click", () => {
            Swal.fire({
                icon: "question",
                title: "هل أنت متأكد من تسجيل الخروج؟",
                showCancelButton: true,
                confirmButtonText: "نعم، خروج",
                cancelButtonText: "إلغاء",
                confirmButtonColor: "#d33",
                cancelButtonColor: "#3085d6",
            }).then((result) => {
                if (result.isConfirmed) {
                    localStorage.removeItem("fastDeliveryUser");
                    userDropDown.classList.remove("showDropDown");
                    Swal.fire({
                        icon: "success",
                        title: "تم تسجيل الخروج بنجاح ✅",
                        confirmButtonText: "حسنًا",
                    }).then(() => {
                        window.location.href = "html_web.html";
                    });
                }
            });
        });
    }

    // ✅ استدعاء عند تحميل الصفحة
    updateLoginBtnBehavior();

    // ✅ Logic for mobile bottom nav "Orders" icon to open cart modal on shop page
    document.addEventListener("click", (e) => {
        const ordersItem = e.target.closest(".mobile-nav-item.nav-cart");
        if (ordersItem) {
            // Check if we are on a page with a cart modal (like PlaceShop.aspx)
            const cartShowerBtn = document.querySelector("#cartShower .submit button, #cartShower .submit");
            if (cartShowerBtn) {
                e.preventDefault();
                cartShowerBtn.click();
            }
        }
    });

    // ✅ تحديد العنصر النشط في القائمة السفلية للجوال
    function setActiveNavItem() {
        const navItems = document.querySelectorAll('.mobile-nav-item');
        const currentPath = window.location.pathname.toLowerCase();

        navItems.forEach(item => {
            const href = item.getAttribute('href');
            if (href) {
                const normalizedHref = href.toLowerCase().replace(/^\.\//, '');
                if (currentPath.endsWith(normalizedHref)) {
                    item.classList.add('active');
                } else {
                    item.classList.remove('active');
                }
            }
        });

        // حالة خاصة للرئيسية
        if (currentPath.endsWith('/') || currentPath.endsWith('default.aspx')) {
            navItems.forEach(item => {
                if (item.getAttribute('href')?.toLowerCase() === 'default.aspx') {
                    item.classList.add('active');
                }
            });
        }
    }
    setActiveNavItem();
});

// ✅ تحديث العناصر التي تحمل خاصية data-text بناءً على ملف الترجمة
function updateUIWithTexts() {
    if (typeof texts === 'undefined') return;

    document.querySelectorAll('[data-text]').forEach(el => {
        const key = el.getAttribute('data-text');
        if (texts[key]) {
            if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                el.placeholder = texts[key];
            } else if (el.classList.contains('whatsapp-float') || el.hasAttribute('title')) {
                el.title = texts[key];
            } else {
                el.innerText = texts[key];
            }
        }
    });

    // تحديث العناوين في مودال تعديل البيانات
    const emailEditorTitle = document.querySelector('.editorContainer[data-form="emailEditor"] h3');
    if (emailEditorTitle && texts.EditEmail) emailEditorTitle.innerText = texts.EditEmail;

    const passwordEditorTitle = document.querySelector('.editorContainer[data-form="passwordEditor"] h3');
    if (passwordEditorTitle && texts.EditPassword) passwordEditorTitle.innerText = texts.EditPassword;

    // Trigger scheduling init to ensure texts are updated (CheckOut page)
    if (typeof initDeliveryTimeScheduling === 'function') {
        initDeliveryTimeScheduling();
    }
}

// user profile settings
const profileHead = document.querySelector(".profile-head");
const dropDownBtn = document.querySelector("#dropDownBtn");
const dropDownMenu = document.querySelector(".profileSettings");
if (dropDownBtn && profileHead && dropDownMenu) {
    dropDownBtn.addEventListener("click", () => {
        profileHead.classList.toggle("active");
        dropDownMenu.classList.toggle("active");
    });
}

// Function to populate profile fields from localStorage
function populateUserProfile() {
    const storedUser = localStorage.getItem("fastDeliveryUser");
    if (!storedUser) return;

    const user = JSON.parse(storedUser);

    // Populate the form fields
    const emailInput = document.getElementById("useremail");
    const firstNameInput = document.getElementById("userFname");
    const lastNameInput = document.getElementById("userLname");
    const genderRadios = document.querySelectorAll('input[name="gender"]');
    const birthdayInput = document.getElementById("date");

    if (emailInput) emailInput.value = user.email || "";
    if (firstNameInput) firstNameInput.value = user.firstName || "";
    if (lastNameInput) lastNameInput.value = user.lastName || "";
    if (genderRadios) genderRadios.forEach((radio) => (radio.checked = false));
    if (birthdayInput) birthdayInput.value = "";
}

// Call it on page load
document.addEventListener("DOMContentLoaded", populateUserProfile);

const profileForm = document.querySelector("#userDashboard form");

if (profileForm) {
    profileForm.addEventListener("submit", (e) => {
        e.preventDefault();

        const email = document.getElementById("useremail")?.value.trim();
        const firstName = document.getElementById("userFname")?.value.trim();
        const lastName = document.getElementById("userLname")?.value.trim();
        const gender =
          document.querySelector('input[name="gender"]:checked')?.value || "";
        const birthday = document.getElementById("date")?.value || "";

        // Get existing user data or create new object
        const storedUser =
          JSON.parse(localStorage.getItem("fastDeliveryUser")) || {};
        storedUser.email = email;
        storedUser.firstName = firstName;
        storedUser.lastName = lastName;
        storedUser.gender = gender;
        storedUser.birthday = birthday;

        // Save back to localStorage
        localStorage.setItem("fastDeliveryUser", JSON.stringify(storedUser));

        Swal.fire({
            icon: "success",
            title: "تم حفظ البيانات بنجاح ✅",
            confirmButtonText: "حسنًا",
            confirmButtonColor: "#3085d6",
        });
    });
}

// ✅ On page load, populate profile with stored values
function populateUserProfile() {
    const storedUser = localStorage.getItem("fastDeliveryUser");
    if (!storedUser) return;

    const user = JSON.parse(storedUser);

    document.getElementById("useremail").value = user.email || "";
    document.getElementById("userFname").value = user.firstName || "";
    document.getElementById("userLname").value = user.lastName || "";
    document.getElementById("date").value = user.birthday || "";

    // Set gender radio if stored
    if (user.gender) {
        const genderRadio = document.querySelector(
          `input[name="gender"][value="${user.gender}"]`
        );
        if (genderRadio) genderRadio.checked = true;
    }
}

document.addEventListener("DOMContentLoaded", populateUserProfile);

const dataEditorPopup = document.getElementById("dataEditorPopup");
const editorContainers = document.querySelectorAll(".editorContainer");
const showEditPopupBtns = document.querySelectorAll(
  "#changeEmail, #changePassword"
);
const closeEditorBtn = document.getElementById("close-editor-btn");
const editorForm = document.getElementById("sendChange");
const removeFormChange = document.getElementById("removeFormChange");

// ✅ Function to show the popup and the correct container
function openEditor(formName) {
    if (!dataEditorPopup) return;
    dataEditorPopup.classList.add("is-visible");
    document.body.style.overflow = "hidden";

    editorContainers.forEach((container) => {
        container.style.display =
          container.dataset.form === formName ? "block" : "none";
    });

    const headerTitle = dataEditorPopup.querySelector(".editor-head h3");
    headerTitle.textContent =
      formName === "emailEditor" ? "تعديل البريد الالكتروني" : "تعديل كلمة المرور";

    // ✅ Reset inputs whenever opening
    if (editorForm) editorForm.reset();
}

// ✅ Event listeners for buttons
showEditPopupBtns.forEach((btn) => {
    btn.addEventListener("click", () => {
        const formName =
          btn.id === "changeEmail" ? "emailEditor" : "passwordEditor";
        openEditor(formName);
    });
});

// ✅ Close popup function (with reset)
function closeEditPopup() {
    if (dataEditorPopup) dataEditorPopup.classList.remove("is-visible");
    document.body.style.overflow = "";
    if (editorForm) editorForm.reset(); // Reset form on close
}

// ✅ Close button
if (closeEditorBtn) closeEditorBtn.addEventListener("click", closeEditPopup);
if (removeFormChange) removeFormChange.addEventListener("click", closeEditPopup);

// ✅ Close if click outside container
const dataEditContainer = document.querySelector(".dataEditContainer");
if (dataEditorPopup) {
    dataEditorPopup.addEventListener("click", (e) => {
        if (dataEditContainer && !dataEditContainer.contains(e.target)) closeEditPopup();
    });
}

// ✅ Handle form submission
if (editorForm) {
    editorForm.addEventListener("submit", (e) => {
        e.preventDefault();

        const storedUser =
          JSON.parse(localStorage.getItem("fastDeliveryUser")) || {};
        const currentPasswordInput = document.getElementById(
          "savedpassword-input"
        )?.value;

        const emailContainer = document.querySelector(
          'figure[data-form="sendChange"]'
        );
        const passwordContainer = document.querySelector(
          'figure[data-form="passwordEditor"]'
        );

        // --- Email update ---
        if (emailContainer.style.display === "block") {
            const newEmail = document.getElementById("newEmail")?.value.trim();
            const confirmEmail = document
              .getElementById("checkNewEmail")
              ?.value.trim();

            if (!currentPasswordInput) {
                Swal.fire({ icon: "error", title: "⚠️ أدخل كلمة المرور الحالية" });
                return;
            }
            if (currentPasswordInput !== storedUser.password) {
                Swal.fire({ icon: "error", title: "⚠️ كلمة المرور الحالية خاطئة" });
                return;
            }
            if (!newEmail || !confirmEmail) {
                Swal.fire({ icon: "error", title: "⚠️ أدخل البريد الجديد وأكدّه" });
                return;
            }
            if (newEmail !== confirmEmail) {
                Swal.fire({ icon: "error", title: "⚠️ البريد الجديد غير متطابق" });
                return;
            }

            storedUser.email = newEmail;
            localStorage.setItem("fastDeliveryUser", JSON.stringify(storedUser));
            document.getElementById("useremail").value = newEmail;

            Swal.fire({ icon: "success", title: "تم تحديث البريد بنجاح ✅" });
            closeEditPopup(); // ✅ closes popup AND resets form
            return;
        }

        // --- Password update ---
        if (passwordContainer.style.display === "block") {
            const newPassword = document
              .getElementById("newPassword-input")
              ?.value.trim();
            const confirmPassword = document
              .getElementById("checkNewPassword-input")
              ?.value.trim();

            if (!currentPasswordInput) {
                Swal.fire({ icon: "error", title: "⚠️ أدخل كلمة المرور الحالية" });
                return;
            }
            if (currentPasswordInput !== storedUser.password) {
                Swal.fire({ icon: "error", title: "⚠️ كلمة المرور الحالية خاطئة" });
                return;
            }
            if (!newPassword || !confirmPassword) {
                Swal.fire({
                    icon: "error",
                    title: "⚠️ أدخل كلمة المرور الجديدة وأكدها",
                });
                return;
            }
            if (newPassword !== confirmPassword) {
                Swal.fire({
                    icon: "error",
                    title: "⚠️ كلمة المرور الجديدة غير متطابقة",
                });
                return;
            }

            storedUser.password = newPassword;
            localStorage.setItem("fastDeliveryUser", JSON.stringify(storedUser));

            Swal.fire({ icon: "success", title: "تم تحديث كلمة المرور بنجاح ✅" });
            closeEditPopup(); // ✅ closes popup AND resets form
            return;
        }
    });
}

// --- Mobile Profile Menu Logic ---
function toggleMobileProfileMenu(event) {
    if (event) event.stopPropagation();
    const menu = document.getElementById('mobileProfileMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

// ✅ Desktop Profile Menu Logic
function toggleProfileMenu(event) {
    if (event) event.stopPropagation();
    const menu = document.getElementById('userDropDown');
    if (menu) {
        menu.classList.toggle('showDropDown');
    }
}

// Close mobile menu on outside click
document.addEventListener('click', function(event) {
    const menu = document.getElementById('mobileProfileMenu');
    if (menu && menu.classList.contains('show')) {
        const trigger = document.getElementById('mobileProfileTrigger');
        if (trigger && !trigger.contains(event.target)) {
            menu.classList.remove('show');
        }
    }
});

function triggerLogout() {
    // Find the ASP.NET LinkButton and click it
    const logoutBtn = document.getElementById('lblogout') || 
                      document.querySelector('a[id*="lblogout"]') ||
                      document.getElementById('ContentPlaceHolder1_lblogout');
    if (logoutBtn) {
        logoutBtn.click();
    } else {
        // Fallback: Clear local storage and redirect if button not found (though it should be there)
        localStorage.removeItem('cartItems');
        window.location.href = 'Default.aspx';
    }
}
