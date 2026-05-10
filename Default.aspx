<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
  <!DOCTYPE html>
  <html lang="ar">

  <head>
    <meta charset="UTF-8">
    <title>تسجيل الدخول بجوجل</title>
    <style>
      .google-btn {
        background: white;
        color: #444;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 16px;
        padding: 10px 20px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .google-btn img {
        width: 20px;
        height: 20px;
      }
    </style>
  </head>

  <body>

    <button class="google-btn" onclick="loginWithGoogle()">
      <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google logo">
      تسجيل الدخول باستخدام Google
    </button>

    <script>
      function loginWithGoogle() {
        window.open("https://accounts.google.com/signin", "_blank", "width=500,height=600");
      }
    </script>

  </body>

  </html>