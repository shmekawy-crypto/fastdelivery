<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html lang="<%= CurrentLang %>" dir="<%= CurrentDir %>">
<head runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
     <link rel="stylesheet" href="css/main.css">
    <title><asp:Literal ID="litPageTitle" runat="server" Text="<%$ Resources:Texts, LoginTitle %>"></asp:Literal></title>
    <script src="https://accounts.google.com/gsi/client" async defer></script>
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
                     // استخدام تعبير السيرفر لجلب الرسالة المترجمة داخل الجافاسكريبت
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
</head>
<body>
    <form id="form2" runat="server" style="text-align:center">
      <div id="login-modal" class="modal is-visible" aria-modal="true"- role="dialog" aria-labelledby="login-heading">
        <div class="modal2-content" style="max-width:none">
            
            <div class="modal-body">
                <div class="">
                    <p class="login-heading" id="login-heading">
                        <asp:Literal ID="litLoginHeading" runat="server" Text="<%$ Resources:Texts, LoginTitle %>"></asp:Literal>
                    </p>
                    <div class="social-buttons">
             <div id="g_id_onload"
        data-client_id="1062707057467-5uhhuk84e3alb7idqedhuaib9slosstg.apps.googleusercontent.com"
        data-callback="handleCredentialResponse"
        data-auto_prompt="false">
    </div>
    <div class="g_id_signin" style="margin-bottom:15px"
        data-type="standard"
        data-shape="rectangular"
        data-theme="outline"
        data-size="large"
        data-logo_alignment="left"
        data-locale='<%= GetCurrentLanguageCode() %>' 
        > 
    </div>
                        <button class="facebook" type="button" onclick="facebookLogin()" aria-label="<asp:Literal runat='server' Text='<%$ Resources:Texts, FacebookLogin %>' />">
                            <i class="fab fa-facebook-f"></i>
                            <span><asp:Literal ID="litFbBtn" runat="server" Text="<%$ Resources:Texts, FacebookLogin %>"></asp:Literal></span>
                        </button>
                    </div>
                    <div class="line"><span><asp:Literal ID="litOr" runat="server" Text="<%$ Resources:Texts, OrText %>"></asp:Literal></span></div>
                    <div  id="form-login">
                        <div class="login-form-row">
                            <i class="fa fa-envelope"></i> 
                            
                         <asp:TextBox ID="txtEmail" runat="server" Placeholder="<%$ Resources:Texts, EmailPlaceholder %>" TextMode="Email"></asp:TextBox>
                        </div>
                        <div class="login-form-row">
                            <i class="fa fa-lock"></i>
                            <div class="password-input-wrapper">
                                <asp:TextBox ID="txtPassword"  CssClass="password-input" runat="server"  Placeholder="<%$ Resources:Texts, PasswordPlaceholder %>" TextMode="Password"></asp:TextBox>
                                <span class="showPassword" id="toggle-password">
                                    <asp:Literal ID="litShow" runat="server" Text="<%$ Resources:Texts, ShowPassword %>"></asp:Literal>
                                </span>
                            </div>
                        </div>
                        <div class="form-options">
                            <div class="forgot-password" data-testid="link-forgot-password">
                                <asp:Literal ID="litForgotPass" runat="server" Text="<%$ Resources:Texts, ForgotPassword %>"></asp:Literal>
                            </div>
                        </div>
                        <asp:Button ID="btnLogin"  class="login-button" runat="server" Text="<%$ Resources:Texts, LoginButton %>" OnClick="btnLogin_Click" />
                        <div class="register-text">
                            <span data-testid="text-no-account"><asp:Literal ID="litNoAccount" runat="server" Text="<%$ Resources:Texts, NoAccount %>"></asp:Literal></span>
                            <a href="#"  class="link-register" onclick="window.parent.location.href='register.aspx'; return false;" data-testid="link-register">
                                <asp:Literal ID="litCreateAccount" runat="server" Text="<%$ Resources:Texts, CreateAccountLink %>"></asp:Literal>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
        <script>
           
</script>
        

    </form>
     <script src="js/main.js" defer></script>
</body>
</html>