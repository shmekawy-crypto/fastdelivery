<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Places_Login" %>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>تسجيل دخول | نظام التوصيل الذكي</title>
    
    <!-- Bootstrap & Fonts -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <style>
        :root { --primary-color: #2c3e50; --accent-color: #e67e22; }
        body {
            font-family: 'Cairo', sans-serif;
            background: linear-gradient(135deg, #2c3e50 0%, #000000 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .login-card {
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            width: 100%;
            max-width: 400px;
            transition: transform 0.3s ease;
        }
        .login-card:hover { transform: translateY(-5px); }
        .login-header { text-align: center; margin-bottom: 30px; }
        .login-header i { font-size: 50px; color: var(--accent-color); }
        .login-header h2 { font-weight: 700; color: var(--primary-color); margin-top: 10px; }
        
        .form-group { position: relative; margin-bottom: 25px; }
        .form-group i {
            position: absolute;
            right: 15px;
            top: 40px;
            color: #999;
        }
        .form-control {
            height: 50px;
            border-radius: 10px;
            padding-right: 45px; /* مسافة للأيقونة */
            border: 1px solid #ddd;
            font-size: 16px;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: none;
        }
        .btn-login {
            background: var(--accent-color);
            color: #fff;
            border: none;
            height: 50px;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            width: 100%;
            transition: background 0.3s;
            margin-top: 10px;
        }
        .btn-login:hover { background: #d35400; color: #fff; }
        .footer-text { text-align: center; margin-top: 20px; color: #777; font-size: 13px; }
        .error-msg { color: #e74c3c; text-align: center; margin-top: 10px; display: block; font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            <div class="login-header">
                <i class="fa fa-cutlery"></i>
                <h2>لوحة تحكم الأماكن</h2>
                <p>سجل دخولك لإدارة طلباتك وإحصائياتك</p>
            </div>

            <div class="form-group">
                <label>اسم المستخدم</label>
                <i class="fa fa-user"></i>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="أدخل اسم المستخدم"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>كلمة المرور</label>
                <i class="fa fa-lock"></i>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="********"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="تسجيل الدخول" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <asp:Label ID="lblError" runat="server" CssClass="error-msg" Visible="false"></asp:Label>

            <div class="footer-text">
                &copy; 2026 نظام التوصيل الذكي - جميع الحقوق محفوظة
            </div>
        </div>
    </form>
</body>
</html>