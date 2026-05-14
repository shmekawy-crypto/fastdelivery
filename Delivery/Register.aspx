<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Delivery_Register" %>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>تسجيل مندوب جديد</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, sans-serif; padding: 40px 0; }
        .card { background: #fff; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); padding: 30px; border-top: 6px solid #e67e22; }
        .section-header { background: #fdf2e9; padding: 10px 15px; border-right: 5px solid #e67e22; margin: 25px 0 15px; font-weight: bold; color: #d35400; }
        .form-control { border-radius: 8px; }
        .val-error { color: #e74c3c; font-size: 11px; font-weight: bold; display: block; margin-top: 4px; }
    </style>
</head>
<body>
    <div class="container" style="max-width: 950px;">
        <div class="card">
            <h2 class="text-center" style="font-weight:bold;">انضم إلينا كمنوب توصيل</h2>
            <hr />
            <form id="form1" runat="server">
                <asp:Label ID="lblMsg" runat="server" CssClass="alert btn-block" Visible="false"></asp:Label>

                <!-- بيانات الحساب -->
                <h4 class="section-header">بيانات الحساب</h4>
                <div class="row">
                    <div class="col-md-4">
                        <label>الاسم بالكامل:</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ErrorMessage="الاسم مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-4">
                        <label>اسم المستخدم (Username):</label>
                        <asp:TextBox ID="txtUser" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUser" ErrorMessage="اليوزرنيم مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-4">
                        <label>كلمة المرور:</label>
                        <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPass" ErrorMessage="الباسورد مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <!-- المعلومات الشخصية -->
                <h4 class="section-header">المعلومات الشخصية</h4>
                <div class="row">
                    <div class="col-md-4">
                        <label>رقم التليفون:</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" ErrorMessage="رقم التليفون مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-4">
                        <label>الرقم القومي (14 رقم):</label>
                        <asp:TextBox ID="txtNationalIDNo" runat="server" CssClass="form-control" MaxLength="14"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNationalIDNo" ErrorMessage="الرقم القومي مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-4">
                        <label>السن:</label>
                        <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAge" ErrorMessage="السن مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="row" style="margin-top:10px;">
                    <div class="col-md-12">
                        <label>عنوان الإقامة بالتفصيل:</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="المحافظة - المدينة - الشارع"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAddress" ErrorMessage="العنوان مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <!-- بيانات المركبة -->
                <h4 class="section-header">بيانات المركبة</h4>
                <div class="row">
                    <div class="col-md-6">
                        <label>نوع المركبة:</label>
                        <asp:DropDownList ID="ddlVehicleType" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">اختر النوع</asp:ListItem>
                            <asp:ListItem>موتوسيكل</asp:ListItem>
                            <asp:ListItem>سيارة</asp:ListItem>
                            <asp:ListItem>عجلة</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlVehicleType" InitialValue="" ErrorMessage="يرجى اختيار نوع المركبة" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-6">
                        <label>رقم اللوحة:</label>
                        <asp:TextBox ID="txtVehicleNo" runat="server" CssClass="form-control" placeholder="أ ب ج 123"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtVehicleNo" ErrorMessage="رقم اللوحة مطلوب" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <!-- رفع الصور -->
                <h4 class="section-header">رفع الصور والوثائق الرسمية</h4>
                <div class="row text-center">
                    <div class="col-md-3">
                        <label>الصورة الشخصية:</label>
                        <asp:FileUpload ID="fuProfile" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="fuProfile" ErrorMessage="ارفع صورتك" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-3">
                        <label>صورة البطاقة:</label>
                        <asp:FileUpload ID="fuNID" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="fuNID" ErrorMessage="ارفع صورة البطاقة" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-3">
                        <label>صورة الفيش:</label>
                        <asp:FileUpload ID="fuCrim" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="fuCrim" ErrorMessage="ارفع صورة الفيش" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-3">
                        <label>صورة الرخصة:</label>
                        <asp:FileUpload ID="fuLic" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="fuLic" ErrorMessage="ارفع صورة الرخصة" CssClass="val-error" ValidationGroup="G1" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div style="margin-top:30px;">
                    <asp:Button ID="btnRegister" runat="server" Text="إرسال طلب الانضمام" CssClass="btn btn-warning btn-block btn-lg" OnClick="btnRegister_Click" ValidationGroup="G1" />
                </div>
            </form>
        </div>
    </div>
</body>
</html>