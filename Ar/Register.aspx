<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Ar_Register" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <title><asp:Literal ID="litPageTitle" runat="server" Text="<%$ Resources:Texts, PageTitle %>"></asp:Literal></title>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script src="https://accounts.google.com/gsi/client" async defer></script>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
    function showSwal(title, message, icon) {
        Swal.fire({
            title: title,
            text: message,
            icon: icon, // ممكن يكون 'success', 'error', 'warning', 'info'
            confirmButtonText: 'تسجيل',
            confirmButtonColor: '#3085d6',
            timer: 3000 // يختفي لوحده بعد 3 ثواني
        });
    }
</script>
    <script>
        // Google callback
        function handleCredentialResponse(response) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "GoogleCallback.aspx", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if(xhr.readyState === 4 && xhr.status === 200) {
                    window.parent.location.href = "Default.aspx";
                }
            };
            xhr.send("credential=" + encodeURIComponent(response.credential));
        }

        // Facebook login
        function facebookLogin() {
            FB.login(function(response) {
                if (response.authResponse) {
                    FB.api('/me', { fields: 'name,email' }, function(profile) {
                        var xhr = new XMLHttpRequest();
                        xhr.open("POST", "SaveSocialUser.aspx", true);
                        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                        xhr.onreadystatechange = function() {
                            if(xhr.readyState === 4 && xhr.status === 200) {
                                window.parent.location.href = "Default.aspx";
                            }
                        };
                        xhr.send("name=" + encodeURIComponent(profile.name) +
                                 "&email=" + encodeURIComponent(profile.email) +
                                 "&provider=Facebook&providerId=" + encodeURIComponent(profile.id));
                    });
                } else {
                    // استخدام تعبير السيرفر لجلب الرسالة داخل الجافاسكريبت
                    alert('<%= Resources.Texts.PermissionDenied %>');
                }
            }, { scope: 'email,public_profile' });
        }

        window.fbAsyncInit = function() {
            FB.init({
                appId: '1367713325083365',
                cookie      : true,
                xfbml       : true,
                version     : 'v20.0'
            });
        };

        (function(d, s, id){
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) {return;}
            js = d.createElement(s); js.id = id;
            js.src = "https://connect.facebook.net/en_US/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
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

    <section class="login_form">
      <div class="modal-body">
        <div class="">
          <p class="login-heading" id="login-heading">
              <asp:Literal ID="litSignUpHeading" runat="server" Text="<%$ Resources:Texts, SignUpHeading %>"></asp:Literal>
          </p>
          <div class="social-buttons">
                        <div id="g_id_onload"
             data-client_id="1062707057467-5uhhuk84e3alb7idqedhuaib9slosstg.apps.googleusercontent.com"
             data-callback="handleCredentialResponse"
             data-auto_prompt="false">
        </div>
        <div class="g_id_signin" style="margin-bottom:15px"
             data-type="standard"
             data-shape="pill"
             data-theme="outline"
             data-text="sign_in_with"
             data-size="large"
             data-logo_alignment="left"
            >
        </div>
             <button class="facebook" type="button" onclick="facebookLogin()" aria-label="<asp:Literal runat='server' Text='<%$ Resources:Texts, FacebookLogin %>' />">
                 <i class="fab fa-facebook-f"></i>
                 <span><asp:Literal ID="litFbBtn" runat="server" Text="<%$ Resources:Texts, FacebookLogin %>"></asp:Literal></span>
             </button>
         </div>
          <div class="line"><span><asp:Literal ID="litOr" runat="server" Text="<%$ Resources:Texts, OrText %>"></asp:Literal></span></div>
            <div class="login-form-row">
              <i class="fa-solid fa-user"></i>
                 <asp:TextBox ID="txtFname"  runat="server" Placeholder="<%$ Resources:Texts, FirstNamePlaceholder %>"></asp:TextBox>
            </div>
                      
                 <asp:RequiredFieldValidator 
                ID="reqFirstName" 
                runat="server" 
                ControlToValidate="txtFname"
                ErrorMessage="<%$ Resources:Texts, FirstNameRequired %>"
                ForeColor="Red"
                      CssClass="validator-error"
                Display="Dynamic" ></asp:RequiredFieldValidator> 
            <div class="login-form-row">
              <i class="fa-solid fa-users"></i>
              <asp:TextBox ID="txtLname"  runat="server" Placeholder="<%$ Resources:Texts, LastNamePlaceholder %>"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator 
                ID="reqLastName" 
                runat="server" 
                ControlToValidate="txtLname"
                ErrorMessage="<%$ Resources:Texts, LastNameRequired %>"
                ForeColor="Red"
                      CssClass="validator-error"
                Display="Dynamic"></asp:RequiredFieldValidator>
            <div class="login-form-row">
              <i class="fa fa-envelope"></i>
          <asp:TextBox ID="txtEmail" runat="server" Placeholder="<%$ Resources:Texts, EmailPlaceholder %>" TextMode="Email"></asp:TextBox>
            </div>
                      <asp:RequiredFieldValidator 
                ID="reqEmail" 
                runat="server" 
                    CssClass="validator-error"
                ControlToValidate="txtEmail"
                ErrorMessage="<%$ Resources:Texts, EmailRequired %>"
                ForeColor="Red"
                Display="Dynamic"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator 
                ID="regexEmail" 
                runat="server"
                CssClass="validator-error"
                ControlToValidate="txtEmail"
                ErrorMessage="<%$ Resources:Texts, EmailInvalid %>"
                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                ForeColor="Red"
                Display="Dynamic" ></asp:RegularExpressionValidator>
            <div class="login-form-row">
              <i class="fa fa-lock"></i>
              <div class="password-input-wrapper">
                 <asp:TextBox ID="txtPassword"  runat="server" Placeholder="<%$ Resources:Texts, PasswordPlaceholder %>" TextMode="Password"></asp:TextBox>
                                <span class="showPassword" id="toggle-password">
                                    <asp:Literal ID="litShowPass" runat="server" Text="<%$ Resources:Texts, ShowPassword %>"></asp:Literal>
                                </span>
              </div>
            </div>
            <asp:RequiredFieldValidator 
                ID="reqPassword" 
                runat="server" 
                ControlToValidate="txtPassword"
                ErrorMessage="<%$ Resources:Texts, PasswordRequired %>"
                        CssClass="validator-error"
                ForeColor="Red"
                Display="Dynamic" ></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator
                ID="regexPassword"
                runat="server"
                ControlToValidate="txtPassword"
                CssClass="validator-error"
                ErrorMessage="<%$ Resources:Texts, PasswordLengthError %>"
                ValidationExpression="^.{6,}$"
                ForeColor="Red"
                Display="Dynamic" />
            <div>
              <asp:Literal ID="litTerms1" runat="server" Text="<%$ Resources:Texts, TermsText %>"></asp:Literal>
              <a href="#" style="color: var(--fd-blue)"><asp:Literal ID="litPrivacy" runat="server" Text="<%$ Resources:Texts, PrivacyPolicy %>"></asp:Literal></a> 
              <asp:Literal ID="litAnd" runat="server" Text="<%$ Resources:Texts, AndText %>"></asp:Literal>
              <a href="#" style="color: var(--fd-red)"><asp:Literal ID="litTermsLink" runat="server" Text="<%$ Resources:Texts, TermsOfUse %>"></asp:Literal></a>
            </div>
            <div class="form-options"></div>
              <asp:Button ID="btnRegister" runat="server" class="login-button" Text="<%$ Resources:Texts, RegisterButton %>" OnClick="btnRegister_Click" />
            
            <div class="register-text">
              <span data-testid="text-no-account"><asp:Literal ID="litHaveAccount" runat="server" Text="<%$ Resources:Texts, HaveAccount %>"></asp:Literal></span>
              <a
                class="link-register"
                data-testid="link-register"
                id="loginPage-modal-btn" onclick="showModal2(); return false;"
                ><asp:Literal ID="litLoginLink" runat="server" Text="<%$ Resources:Texts, LoginLink %>"></asp:Literal>
              </a>
            </div>

<script>
  function showModal2() {
    document.getElementById('popupFrame').src = 'login.aspx';
    var modal = new bootstrap.Modal(document.getElementById('pageModal'));
    modal.show();
  }
  document.addEventListener('DOMContentLoaded', function() {
      document.querySelectorAll('.showPassword').forEach(function(toggle) {
          toggle.style.cursor = 'pointer';
          toggle.addEventListener('click', function() {
              var wrapper = toggle.closest('.password-input-wrapper');
              if (!wrapper) return;
              var input = wrapper.querySelector('input[type="password"], input[type="text"]');
              if (!input) return;
              if (input.type === 'password') {
                  input.type = 'text';
                  toggle.textContent = 'إخفاء';
              } else {
                  input.type = 'password';
                  toggle.textContent = 'إظهار';
              }
          });
      });
  });
</script>
        </div>
      </div>
    </section>
</asp:Content>