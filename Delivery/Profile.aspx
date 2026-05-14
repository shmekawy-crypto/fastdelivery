<%@ Page Title="الملف الشخصي" Language="C#" MasterPageFile="~/Delivery/MasterPage/Site.master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="Delivery_Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        .profile-container { padding: 20px; background-color: #f8fafc; min-height: 100vh; }
        .main-card { background: #fff; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); overflow: hidden; border: none; margin-bottom: 30px; }
        .profile-header { background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%); padding: 40px; text-align: center; color: #fff; }
        .profile-img { width: 150px; height: 150px; border-radius: 50%; border: 5px solid rgba(255,255,255,0.3); object-fit: cover; margin-bottom: 15px; }
        .status-badge { background: rgba(255,255,255,0.2); padding: 5px 20px; border-radius: 50px; font-size: 14px; display: inline-block; }
        
        .info-section { padding: 30px; }
        .section-title { font-size: 18px; font-weight: 700; color: #2c3e50; margin-bottom: 25px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; }
        .data-item { margin-bottom: 25px; }
        .data-label { font-size: 13px; color: #94a3b8; font-weight: 600; text-transform: uppercase; display: block; margin-bottom: 5px; }
        .data-value { font-size: 16px; color: #1e293b; font-weight: 700; display: block; }
        .icon-box { color: #2ecc71; margin-left: 10px; width: 20px; text-align: center; }
        
        .doc-card { background: #f8fafc; border-radius: 12px; padding: 15px; border: 1px solid #e2e8f0; text-align: center; transition: 0.3s; }
        .doc-card:hover { transform: translateY(-5px); border-color: #2ecc71; }
        .doc-img { width: 100%; border-radius: 8px; margin-top: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .edit-form-card { background: #fff; border-radius: 15px; padding: 30px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-container">
        <asp:Label ID="lblMsg" runat="server" CssClass="alert btn-block" Visible="false" style="margin-bottom:20px;"></asp:Label>

        <!-- 1. واجهة العرض الاحترافية للمندوب المؤكد -->
        <asp:Panel ID="pnlViewMode" runat="server" Visible="false">
            <div class="main-card">
                <div class="profile-header">
                    <asp:Image ID="imgViewProfile" runat="server" CssClass="profile-img" />
                    <h2 style="margin: 0; font-weight: 800;"><asp:Label ID="lblViewName" runat="server"></asp:Label></h2>
                    <div class="status-badge"><i class="fa fa-check-circle"></i> حساب موثق ومعتمد</div>
                </div>

                <div class="info-section">
                    <div class="row">
                        <!-- معلومات الاتصال والهوية -->
                        <div class="col-md-6">
                            <h4 class="section-title"><i class="fa fa-user icon-box"></i> المعلومات الشخصية</h4>
                            <div class="row">
                                <div class="col-sm-6 data-item">
                                    <span class="data-label">رقم الموبايل</span>
                                    <asp:Label ID="lblViewPhone" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                                <div class="col-sm-6 data-item">
                                    <span class="data-label">الرقم القومي</span>
                                    <asp:Label ID="lblViewNationalID" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                                <div class="col-sm-6 data-item">
                                    <span class="data-label">السن</span>
                                    <asp:Label ID="lblViewAge" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                                <div class="col-sm-6 data-item">
                                    <span class="data-label">هاتف الطوارئ</span>
                                    <asp:Label ID="lblViewEmergency" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                                <div class="col-md-12 data-item">
                                    <span class="data-label">عنوان الإقامة التفصيلي</span>
                                    <asp:Label ID="lblViewAddress" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <!-- معلومات المركبة والدفع -->
                        <div class="col-md-6">
                            <h4 class="section-title"><i class="fa fa-truck icon-box"></i> بيانات العمل</h4>
                            <div class="row">
                                <div class="col-sm-6 data-item">
                                    <span class="data-label">نوع المركبة</span>
                                    <asp:Label ID="lblViewVehicleType" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                                <div class="col-sm-6 data-item">
                                    <span class="data-label">رقم اللوحة</span>
                                    <asp:Label ID="lblViewVehicleNo" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                                <div class="col-md-12 data-item">
                                    <span class="data-label">وسيلة استلام الأرباح</span>
                                    <asp:Label ID="lblViewPayment" runat="server" CssClass="data-value"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- قسم الوثائق -->
                    <h4 class="section-title"><i class="fa fa-file-image-o icon-box"></i> المستندات الرسمية المعتمدة</h4>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="doc-card">
                                <strong>صورة البطاقة</strong>
                                <asp:Image ID="imgViewNID" runat="server" CssClass="doc-img" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="doc-card">
                                <strong>الفيش والتشبيه</strong>
                                <asp:Image ID="imgViewCrim" runat="server" CssClass="doc-img" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="doc-card">
                                <strong>رخصة القيادة</strong>
                                <asp:Image ID="imgViewLic" runat="server" CssClass="doc-img" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- 2. واجهة التعديل للمندوب قيد الانتظار -->
        <asp:Panel ID="pnlEditMode" runat="server" Visible="false">
            <div class="edit-form-card">
                <h2 class="text-center" style="color: #e67e22; font-weight: 800;">تحديث البيانات قيد المراجعة</h2>
                <p class="text-center text-muted">يمكنك تعديل بياناتك الآن قبل اعتماد الحساب من الإدارة.</p>
                <hr />
                <!-- يتم وضع أدوات التعديل (TextBoxes, FileUploads) هنا كما في التصميم السابق -->
                 <div class="alert alert-info">يرجى ملء كافة الحقول الفارغة لضمان سرعة قبول الطلب.</div>
                 <div class="text-center">
                     <asp:Button ID="btnSave" runat="server" Text="حفظ التعديلات" CssClass="btn btn-warning btn-lg" OnClick="btnSave_Click" />
                 </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>