<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="Delivery_login" %>
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>تسجيل الدخول | نظام التوصيل</title>
    
    <!-- Bootstrap & Font Awesome -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
        }
        .login-box {
            width: 100%;
            max-width: 400px;
            padding: 15px;
        }
        .card {
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            position: relative;
            overflow: hidden;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0; right: 0;
            width: 5px; height: 100%;
            background: #3498db;
        }
        .logo-circle {
            width: 80px; height: 80px;
            background: #f8f9fa;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: #3498db;
            font-size: 35px;
            border: 1px solid #eee;
        }
        .form-header { text-align: center; margin-bottom: 30px; }
        .form-header h2 { margin: 0; font-weight: bold; color: #333; font-size: 24px; }
        .form-header p { color: #888; margin-top: 5px; }
        
        .form-group { position: relative; margin-bottom: 25px; }
        .form-group i {
            position: absolute;
            right: 15px; top: 40px;
            color: #bdc3c7;
        }
        .form-control {
            height: 45px;
            border-radius: 8px;
            padding-right: 40px; /* لإفساح مجال للأيقونة جهة اليمين */
            border: 1px solid #ddd;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #3498db;
            box-shadow: none;
        }
        .btn-login {
            background: #3498db;
            border: none;
            height: 50px;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            transition: all 0.3s;
            color: white;
        }
        .btn-login:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        .footer-text { text-align: center; margin-top: 20px; color: rgba(255,255,255,0.7); font-size: 13px; }
    </style>
</head>
<body>
    <div class="login-box">
        <div class="card">
            <div class="form-header">
                <div class="logo-circle">
                    <i class="fa fa-truck"></i>
                </div>
                <h2>أهلاً بك مجدداً</h2>
                <p>سجل دخولك لمتابعة الطلبات</p>
            </div>

            <form id="form1" runat="server">
                <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger btn-block" Visible="false" style="font-size:13px; padding:10px; margin-bottom:20px;"></asp:Label>

                <div class="form-group">
                    <label>اسم المستخدم</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="أدخل اليوزر نيم"></asp:TextBox>
                    <i class="fa fa-user"></i>
                </div>

                <div class="form-group">
                    <label>كلمة المرور</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="********"></asp:TextBox>
                    <i class="fa fa-lock"></i>
                </div>

                <div class="checkbox" style="margin-bottom:20px;">
                    <label><input type="checkbox"> تذكرني على هذا الجهاز</label>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="تسجيل الدخول" CssClass="btn btn-login btn-block" OnClick="btnLogin_Click" />
                <div class="text-center" style="margin-top: 15px;">
    <span>ليس لديك حساب؟ </span>
    <a href="Register.aspx" style="color: #3498db; font-weight: bold; text-decoration: none;">انضم إلينا الآن كمنوب توصيل</a>
</div>
            </form>
        </div>
        <div class="footer-text">
            &copy; 2026 جميع الحقوق محفوظة لنظام دليفري
        </div>
    </div>
</body>
</html>