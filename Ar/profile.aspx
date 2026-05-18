<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="Ar_profile" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <title><asp:Literal ID="litPageTitle" runat="server" Text="<%$ Resources: texts, AccountInfoPageTitle %>"></asp:Literal></title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section id="userDashboard">
    <div class="userProfileField">
        <span class="route">
            <a href="default.aspx"><asp:Literal ID="litHome" runat="server" Text="<%$ Resources: texts, Home %>"></asp:Literal></a>
            <i class="fa-solid fa-angles-left"></i>
            <asp:Literal ID="litAccount" runat="server" Text="<%$ Resources: texts, MyAccount %>"></asp:Literal>
        </span>

        <div class="profile-head">
            <asp:Literal ID="litProfileHead" runat="server" Text="<%$ Resources: texts, MyAccount %>"></asp:Literal>
            <i id="dropDownBtn" class="fa-solid fa-angles-down"></i>
        </div>

        <article class="profileContainer">
            <ul class="profileSettings">
                <li class="active"><a href="profile.aspx"><asp:Literal ID="litAccountInfo" runat="server" Text="<%$ Resources: texts, AccountInfo %>"></asp:Literal></a></li>
                <li><a href="Favorites.aspx"><asp:Literal ID="litFav" runat="server" Text="<%$ Resources: texts, nav_favorites %>"></asp:Literal></a></li>
                <li><a href="Addresses.aspx"><asp:Literal ID="litAddresses" runat="server" Text="<%$ Resources: texts, Addresses %>"></asp:Literal></a></li>
                <li><a href="POrders.aspx"><asp:Literal ID="litOrders" runat="server" Text="<%$ Resources: texts, Orders %>"></asp:Literal></a></li>
                <li class="logout-item">
                    <asp:LinkButton ID="lblogout_profile" runat="server" OnClick="lblogout_Click" OnClientClick="localStorage.removeItem('cartItems');">
                        <i class="fa-solid fa-right-from-bracket"></i>
                        <asp:Literal ID="litLogoutProfile" runat="server" Text="<%$ Resources:Texts, Logout %>" />
                    </asp:LinkButton>
                </li>
            </ul>

            <div class="Uform">
                <!-- البريد الإلكتروني -->
                <div class="dataField">
                    <label for="useremail">
                        <asp:Literal ID="litEmail" runat="server" Text="<%$ Resources: texts, Email %>"></asp:Literal>
                        <span class="labelTag">*</span>
                    </label>
                    <div class="inputHolder">
                        <asp:TextBox ID="useremail" ReadOnly="true" TextMode="Email" runat="server"></asp:TextBox>
                    </div>
                    <div class="editBtns">
                        <button type="button" id="changeEmail"><asp:Literal ID="litChangeEmail" runat="server" Text="<%$ Resources: texts, ChangeEmail %>"></asp:Literal></button>
                        <button type="button" id="changePassword"><asp:Literal ID="litChangePassword" runat="server" Text="<%$ Resources: texts, ChangePassword %>"></asp:Literal></button>
                    </div>
                </div>

                <!-- الاسم الاول -->
                <div class="dataField">
                    <label for="userFname">
                        <asp:Literal ID="litFirstName" runat="server" Text="<%$ Resources: texts, FirstName %>"></asp:Literal>
                        <span class="labelTag">*</span>
                    </label>
                    <asp:TextBox ID="userFname" runat="server"></asp:TextBox>
                </div>

                <!-- اسم العائلة -->
                <div class="dataField">
                    <label for="userLname">
                        <asp:Literal ID="litLastName" runat="server" Text="<%$ Resources: texts, LastName %>"></asp:Literal>
                        <span class="labelTag">*</span>
                    </label>
                    <asp:TextBox ID="userLname" runat="server"></asp:TextBox>
                </div>

                <!-- الجنس -->
                <div class="dataField">
                    <label for="gender">
                        <asp:Literal ID="litGender" runat="server" Text="<%$ Resources: texts, Gender %>"></asp:Literal>
                        <span class="labelTag">*</span>
                    </label>
                    <div class="radio-buttons">
                        <asp:RadioButton ID="male" runat="server" GroupName="Options" Text='<%$ Resources: texts, Male %>' />
                        <asp:RadioButton ID="female" runat="server" GroupName="Options" Text='<%$ Resources: texts, Female %>' />
                    </div>
                    <br />
                    <span id="msg" style="color:red; display:none;"><asp:Literal ID="litSelectGender" runat="server" Text="<%$ Resources: texts, SelectGender %>"></asp:Literal></span>
                </div>

                <!-- تاريخ الميلاد -->
                <div class="dataField">
                    <label for="date">
                        <asp:Literal ID="litBirthday" runat="server" Text="<%$ Resources: texts, Birthday %>"></asp:Literal>
                        <span class="labelTag">*</span>
                    </label>

                    <div class="birthday">
                        <asp:TextBox ID="date" runat="server" placeholder='<%$ Resources: texts, SelectDate %>'></asp:TextBox>
    <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="calendar-alt" class="svg-inline--fa fa-calendar-alt fa-w-14 f-15" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path fill="currentColor" d="M0 464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V192H0v272zm320-196c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zm0 128c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zM192 268c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zm0 128c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12h-40c-6.6 0-12-5.4-12-12v-40zM64 268c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12H76c-6.6 0-12-5.4-12-12v-40zm0 128c0-6.6 5.4-12 12-12h40c6.6 0 12 5.4 12 12v40c0 6.6-5.4 12-12 12H76c-6.6 0-12-5.4-12-12v-40zM400 64h-48V16c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v48H160V16c0-8.8-7.2-16-16-16h-32c-8.8 0-16 7.2-16 16v48H48C21.5 64 0 85.5 0 112v48h448v-48c0-26.5-21.5-48-48-48z"></path></svg>

                   </div>
                </div>
                 <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
        // Make ASP.NET's ugly radio buttons work with our labels
        document.addEventListener('DOMContentLoaded', function () {
            const radios = document.querySelectorAll('.radio-buttons input[type="radio"]');
            radios.forEach(rb => {
                const label = document.createElement('label');
                label.innerText = rb.nextSibling.textContent.trim();
                rb.nextSibling.remove();
                rb.parentNode.insertBefore(label, rb.nextSibling);
                label.addEventListener('click', () => rb.click());
            });
        });
    </script>

<script>
    flatpickr("#ContentPlaceHolder1_date", {
    dateFormat: "Y-m-d"
  });
</script>
                <center>
                    <asp:Button ID="btnSave" runat="server" Text='<%$ Resources: texts, Update %>' class="login-button" OnClick="btnSave_Click" />
                    <div class="logout-btn-wrapper" style="margin-top: 20px;">
                         <asp:LinkButton ID="btnLogoutMain" runat="server" OnClick="lblogout_Click" class="logout-link" OnClientClick="localStorage.removeItem('cartItems');">
                            <i class="fa-solid fa-right-from-bracket"></i>
                            <asp:Literal ID="litLogoutMain" runat="server" Text="<%$ Resources:Texts, Logout %>" />
                        </asp:LinkButton>
                    </div>
                </center>
            </div>
        </article>

        <!-- Popup Editor -->
        <article id="dataEditorPopup">
            <div class="dataEditContainer">
                <div class="editor-head">
                    <h3><asp:Literal ID="litEditorTitle" runat="server" Text=""></asp:Literal></h3>
                    <button class="close-btn" aria-label="إغلاق" id="close-editor-btn">
                        <i class="fa fa-times"></i>
                    </button>
                </div>

                <div id="emailEditor">
                    <figure class="editorContainer" data-form="emailEditor">
                        <!-- كلمات المرور والبريد الإلكتروني الجديد -->
                        <div class="dataField">
                            <label for="savedpassword"><asp:Literal ID="litCurrentPassword" runat="server" Text="<%$ Resources: texts, CurrentPassword %>"></asp:Literal><span class="labelTag">*</span></label>
                            <asp:TextBox ID="savedpassword" TextMode="Password" runat="server" placeholder='<%$ Resources: texts, PasswordPlaceholder %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="savedpassword" ErrorMessage='<%$ Resources: texts, PasswordRequired %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="mail" ForeColor="Red"></asp:RequiredFieldValidator>
                        </div>
                        <div class="dataField">
                            <label for="newEmail"><asp:Literal ID="litNewEmail" runat="server" Text="<%$ Resources: texts, NewEmail %>"></asp:Literal><span class="labelTag">*</span></label>
                            <asp:TextBox ID="newEmail" runat="server" placeholder='<%$ Resources: texts, NewEmailPlaceholder %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="newEmail" ErrorMessage='<%$ Resources: texts, EmailRequired %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="mail" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="regexEmail" runat="server" ControlToValidate="newEmail" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage='<%$ Resources: texts, EmailInvalid %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="mail" ForeColor="Red"></asp:RegularExpressionValidator>
                        </div>
                        <div class="dataField">
                            <label for="checkNewEmail"><asp:Literal ID="litConfirmEmail" runat="server" Text="<%$ Resources: texts, ConfirmEmail %>"></asp:Literal><span class="labelTag">*</span></label>
                            <asp:TextBox ID="checkNewEmail" runat="server" placeholder='<%$ Resources: texts, ConfirmEmailPlaceholder %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="checkNewEmail" ErrorMessage='<%$ Resources: texts, EmailRequired %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="mail" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="checkNewEmail" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage='<%$ Resources: texts, EmailInvalid %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="mail" ForeColor="Red"></asp:RegularExpressionValidator>
                        </div>
                        <div class="submitEdit">
                            <asp:Button ID="btnSaveEmail" runat="server" Text='<%$ Resources: texts, Update %>' ValidationGroup="mail" OnClick="sendChange_Click" />
                        </div>
                    </figure>

                    <!-- Password Editor -->
                    <figure class="editorContainer" data-form="passwordEditor">
                        <div class="dataField">
                            <label for="savedpassword2"><asp:Literal ID="litCurrentPassword2" runat="server" Text="<%$ Resources: texts, CurrentPassword %>"></asp:Literal><span class="labelTag">*</span></label>
                            <asp:TextBox ID="savedpassword2" TextMode="Password" runat="server" placeholder='<%$ Resources: texts, PasswordPlaceholder %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="savedpassword2" ErrorMessage='<%$ Resources: texts, PasswordRequired %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="pass" ForeColor="Red"></asp:RequiredFieldValidator>
                        </div>
                        <div class="dataField">
                            <label for="newPassword"><asp:Literal ID="litNewPassword" runat="server" Text="<%$ Resources: texts, NewPassword %>"></asp:Literal><span class="labelTag">*</span></label>
                            <asp:TextBox ID="newPassword" TextMode="Password" runat="server" placeholder='<%$ Resources: texts, NewPasswordPlaceholder %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="newPassword" ErrorMessage='<%$ Resources: texts, PasswordRequired %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="pass" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="regexPassword" runat="server" ControlToValidate="newPassword" ValidationExpression="^.{6,}$" ErrorMessage='<%$ Resources: texts, PasswordMin6 %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="pass" ForeColor="Red"></asp:RegularExpressionValidator>
                        </div>
                        <div class="dataField">
                            <label for="checkNewPassword"><asp:Literal ID="litConfirmPassword" runat="server" Text="<%$ Resources: texts, ConfirmPassword %>"></asp:Literal><span class="labelTag">*</span></label>
                            <asp:TextBox ID="checkNewPassword" TextMode="Password" runat="server" placeholder='<%$ Resources: texts, ConfirmPasswordPlaceholder %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="checkNewPassword" ErrorMessage='<%$ Resources: texts, PasswordRequired %>' CssClass="validator-error" Display="Dynamic" ValidationGroup="pass" ForeColor="Red"></asp:RequiredFieldValidator>
                        </div>
                        <div class="submitEdit">
                            <asp:Button ID="btnSavePassword" runat="server" Text='<%$ Resources: texts, Update %>' ValidationGroup="pass" OnClick="SavePassword_Click" />
                        </div>
                    </figure>
                </div>
            </div>
        </article>
    </div>
</section>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageScripts" Runat="Server">
    <script>
    // user profile settings
const profileHead = document.querySelector(".profile-head");
const dropDownBtn = document.querySelector("#dropDownBtn");
const dropDownMenu = document.querySelector(".profileSettings");
if (dropDownBtn) {
  dropDownBtn.addEventListener("click", () => {
    document.querySelector(".profile-head")?.classList.toggle("active");
    dropDownMenu?.classList.toggle("active");
    dropDownBtn.style.pointerEvents = "none";
    setTimeout(() => {
      dropDownBtn.style.pointerEvents = "auto";
    }, 500);
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
      document.querySelector('input[name="ctl00$ContentPlaceHolder1$Options"]:checked')?.value || "";
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

  dataEditorPopup.classList.add("is-visible");
  document.body.style.overflow = "hidden";

  editorContainers.forEach((container) => {
    container.style.display =
      container.dataset.form === formName ? "block" : "none";
  });

  const headerTitle = dataEditorPopup.querySelector(".editor-head h3");
  headerTitle.textContent =
    formName === "emailEditor"
      ? "تعديل البريد الالكتروني"
      : "تعديل كلمة المرور";

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
  dataEditorPopup.classList.remove("is-visible");
  document.body.style.overflow = "";
  if (editorForm) editorForm.reset(); // Reset form on close
}

// ✅ Close button
if (closeEditorBtn) closeEditorBtn.addEventListener("click", closeEditPopup);
if (removeFormChange)
  removeFormChange.addEventListener("click", closeEditPopup);
// ✅ Close if click outside container
const dataEditContainer = document.querySelector(".dataEditContainer");
if (dataEditorPopup) {
  dataEditorPopup.addEventListener("click", (e) => {
    if (!dataEditContainer?.contains(e.target)) closeEditPopup();
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

  </script>
       <script>
        window.addEventListener('DOMContentLoaded', function () {
            const btn = document.getElementById('<%= btnSave.ClientID %>');
            const yes = document.getElementById('<%= male.ClientID %>');
            const no = document.getElementById('<%= female.ClientID %>');
            const msg = document.getElementById('msg');

            btn.addEventListener('click', function (e) {
                if (!yes.checked && !no.checked) {
                    msg.style.display = 'inline';
                    e.preventDefault(); // يمنع الإرسال
                } else {
                    msg.style.display = 'none';
                }
            });
        });
    </script>
     <style>
      section#userDashboard {
  display: flex;
  justify-content: center;
  align-items: center;
  padding-inline: 25px;
}
.userProfileField {
  padding: 25px;
  padding-top: 120px;
  margin-bottom: 25px;
  max-width: 1024px;
  width: 100%;
  margin-inline: auto;
  box-shadow: var(--shadow);
  border-radius: 0.5rem;
}
.profile-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 2rem;
  font-weight: bold;
  i {
    cursor: pointer;
    font-size: 1.75rem;
    transition: 0.5s all ease;
    display: none;
    &:hover {
      color: var(--fd-blue);
      rotate: 180deg;
    }
  }
}

.profile-head.active {
  i {
    rotate: 180deg;
    color: var(--fd-blue);
  }
}

.profileContainer {
  position: relative;
  isolation: isolate;
  display: grid;
  grid-template-columns: 20% 80%;
  margin-top: 20px;
  padding: 25px 0px;
  border-top: 1px solid rgba(0, 0, 0, 0.2);
}

.profileSettings {
  list-style-type: none;
  border-left: 1px solid rgba(0, 0, 0, 0.2);
  height: fit-content;
position: sticky;
    top: 100px;
  li {
    padding: 10px;
    transition: 0.3s color ease;
    &:hover {
      a {
        color: var(--fd-blue);
      }
    }
    a {
      transition: inherit;
    }
  }
}

.profileSettings li.active {
  a {
    color: var(--fd-blue);
  }
  border-right: 2px solid var(--fd-blue);
}

.route {
  display: flex;
  gap: 1rem;
  align-items: baseline;
  color: #777;
  i {
    color: var(--fd-blue);
    scale: 1.125;
  }
  a {
    color: black !important;
  }
}

.profileContainer #editForm {
  padding-block: 10px;
  padding-right: 25px;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  input {
    border-radius: 0.25rem;
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 0.2rem 1rem;
    width: 100%;
    max-width: 300px;
    background-color: transparent;
    font-size: 0.9rem;
  }
  label,
  button {
    white-space: nowrap;
  }
  label {
    min-width: 113px;
  }
  button {
    border-radius: 2rem;
    padding: 0.5rem 1rem;
    font-size: 0.75rem;
    border: 1px solid rgba(0, 0, 0, 0.1);
    background-color: transparent;
    transition: var(--transition);
    font-weight: bold;
    &:hover {
      background-color: var(--fd-blue);
      color: white;
      border-color: transparent;
    }
  }

  .service_subscribe {
    width: fit-content;
    display: flex;
    align-items: center;
    gap: 1rem;
    input[type="checkbox"] {
      width: fit-content;
      scale: 1.5;
      accent-color: var(--fd-blue);
    }
  }
}

input[type="submit"] {
  background-color: var(--fd-blue) !important;
  color: white;
  font-size: 1rem !important;
  max-width: 250px;
  width: 100%;
  margin: auto;
  border-width: 2px;
  transition: var(--transition);
  border-color: transparent !important;

  &:hover {
    border-color: var(--fd-blue) !important;
    background-color: transparent !important;
    color: var(--fd-blue) !important;
  }
}

.editBtns {
  align-items: center;
  flex-wrap: wrap;
  display: flex;
  gap: 1rem;
}

.gender-btn {
  padding: 10px 68px;
  border: 1px solid #ccc;
  cursor: pointer;
  user-select: none;
  transition: all 0.2s;
  border-top-right-radius: 8px;
  border-bottom-right-radius: 8px;
}
.gender-btn:last-child {
  border-radius: 0;
  border-top-left-radius: 8px;
  border-bottom-left-radius: 8px;
}

.gender-btn:hover {
  background-color: #f0f0f0;
}

input[type="radio"]:checked + label {
  background-color: var(--fd-blue);
  color: white;
  border-color: var(--fd-blue);
}

input[type="radio"] {
  width: 150px;
}

        .gender-selection input[type="radio"] {
            display: none;
        }

.birthday {
  position: relative;
  isolation: isolate;
  width: 100%;
  max-width: 300px;
  svg {
    position: absolute;
    left: 0.5rem;
    top: 0.5rem;
    width: 14px;
  }
}

.inputHolder {
  position: relative;
  width: 100%;
  border-radius: 0.25rem;
  max-width: 300px;
  isolation: isolate;
  background-color: #e9ecef;
  overflow: hidden;
  input {
    cursor: not-allowed;
    color: rgb(74, 71, 71);
    &:focus {
      outline: none;
    }
  }
}

.labelTag {
  font-size: 1.5rem;
  color: var(--fd-blue);
}

.dataField {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  gap: 1rem;
}

#dataEditorPopup {
  position: fixed;
  background-color: rgba(0, 0, 0, 0.5);
  min-height: 100vh;
  width: 100%;
  display: flex;
  opacity: 0;
  visibility: hidden;
  pointer-events: none;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  transition: var(--transition);
  padding-inline: 50px;
  padding-block: 25px;
  top:0;
  left:0;
}
#dataEditorPopup.is-visible {
  opacity: 1;
  visibility: visible;
  pointer-events: auto;
}
#dataEditorPopup .dataEditContainer {
  height: 100%;
  width: 100%;
  max-height: 600px;
  max-width: 700px;
  scale: 0.9;
  transition: var(--transition);
  background-color: white;
  border: 1px solid rgba(0, 0, 0, 0.7);
  box-shadow: var(--shadow);
  border-radius: 0.5rem;
  overflow: hidden;
}

#dataEditorPopup.is-visible .dataEditContainer {
  scale: 1;
}
.submitEdit {
  display: flex;
  position: relative;
  isolation: isolate;
  padding-block: 25px;
  justify-content: end;
  align-items: center;
  gap: 0.5rem;
}
.editor-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 10px;
  background-color: rgba(220, 220, 220, 0.6);
  color: var(--fd-blue);
}

.dataEditContainer form {
  padding-inline: 10px;
  padding-top: 25px;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  input {
    width: 100%;
    max-width: 300px;
    border-radius: 0.5rem;
    border: 1px solid rgba(0, 0, 0, 0.5);
    padding: 0.25rem 1rem;
  }
  .password-input-wrapper {
    width: 100%;
    max-width: 300px;
    position: relative;
    isolation: isolate;
  }
  .showPassword {
    position: absolute;
    left: 0;
  }
  label {
    min-width: 178px;
  }
  button {
    outline: 0;
    border-radius: 2rem;
    width: 150px;
    padding-block: 0.35rem !important;
  }
}
#removeFormChange {
  background-color: transparent;
  border: 1px solid rgba(0, 0, 0, 0.5);
  transition: var(--transition);
  border-top: 1px solid rgba(0, 0, 0, 0.5);
  &:hover {
    background-color: var(--fd-blue);
    color: white;
    border-color: transparent;
  }
}
#sendChange {
  margin: 0;
}


.logout-item {
    margin-top: 20px;
    border-top: 1px solid rgba(0,0,0,0.1);
    padding-top: 10px !important;
}
.logout-item a {
    color: #ff4d4d !important;
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 600;
}
.logout-item a:hover {
    color: #d32f2f !important;
    background: #fff5f5;
}
.logout-link {
    color: #ff4d4d;
    text-decoration: none;
    font-weight: bold;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 30px;
    border: 2px solid #ff4d4d;
    border-radius: 50px;
    transition: all 0.3s ease;
}
.logout-link:hover {
    background-color: #ff4d4d;
    color: white !important;
}
    </style>

    <style>
        .radio-buttons {
            display: flex;
            gap: 10px;
        }

        .radio-buttons input[type="radio"] {
            display: none;
        }
        .radio-buttons label {
            padding: 10px 68px;
    border: 1px solid #ccc;
    cursor: pointer;
    user-select: none;
    transition: all 0.2s;
    border-top-right-radius: 8px;
    border-bottom-right-radius: 8px;
        }
        .radio-buttons input[type="radio"]:checked + label {
             background-color: var(--fd-blue);
  color: white;
  border-color: var(--fd-blue);
        }
        .radio-buttons label:hover {
            background-color: #e2e6ea;
        }
        .login-button {
  background-color: var(--fd-blue) !important;
  color: var(--fd-white) !important;
  padding: 14px !important;
  border: none !important;
  border-radius: 50px !important;
  font-size: 18px !important;
  font-weight: 700 !important;
  width: 100% !important;
  cursor: pointer !important;
  transition: background-color 0.2s !important;
  margin: 10px 0 5px !important;
}

@media (max-width: 480px) {

  .radio-buttons{
  flex-wrap: wrap;

}
  .radio-buttons label{
    border-radius: 0.5rem !important;
    width: 100%;
    text-align: center;
  }
}

  </style>

        <style>


    .validator-error {
        display: flex;
        align-items: center;
        gap: 6px;
        color: #d93025;
        font-size: 13px;
        margin-bottom: 10px;
        animation: fadeIn 0.2s ease-in;
    }

    .validator-error::before {
        content: "⚠️";
        font-size: 14px;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-3px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>
</asp:Content>

