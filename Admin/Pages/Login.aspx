<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Pages_Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta content="width=device-width, initial-scale=1" name="viewport">
	<meta name="description" content="Responsive Admin Template">
	<meta name="author" content="RedstarHospital">
	<title><asp:Literal ID="lblTitle" runat="server"></asp:Literal>تسجيل الدخول</title>
	<!-- google font -->
	<link href="../scripts/css" rel="stylesheet" type="text/css">
	<!-- icons -->
	<link href="../scripts/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="../scripts/material-design-iconic-font.min.css">
	<!-- bootstrap -->
	<link href="../scripts/bootstrap.min.css" rel="stylesheet" type="text/css">
	<!-- style -->
	<link rel="stylesheet" href="../scripts/extra_pages.css">
	<!-- rtl -->
	<link href="../scripts/rtl.css" rel="stylesheet" type="text/css">
	<!-- favicon -->
<link rel="shortcut icon" href="../../ar/images/logo.PNG">
<body>
	<div class="limiter">
		<div class="container-login100 page-background">
			<div class="wrap-login100">
				<form class="login100-form validate-form" id="form1" runat="server">
					<span class="login100-form-logo">
						<asp:Image ID="logo" class="img-circle " runat="server" ImageUrl="~/AR/images/logo.png" />
					</span>
					<span class="login100-form-title p-b-34 p-t-27">
						تسجيل الدخول
					</span>
				
					<div class="wrap-input100 validate-input" data-validate="Enter username">
					
    <asp:TextBox ID="username" class="input100" runat="server" placeholder="إسم المستخدم"></asp:TextBox>
						<span class="focus-input100" data-placeholder=""></span>
					</div>
					<div class="wrap-input100 validate-input" data-validate="Enter password">
						<asp:TextBox ID="pass" class="input100" TextMode="Password" runat="server" placeholder="كلمة المرور"></asp:TextBox>
						<span class="focus-input100" data-placeholder=""></span>
					</div>
					<div class="checkbox contact100-form-checkbox rtl">
						
        <asp:CheckBox ID="ckb1" class="input-checkbox100" runat="server" />
						<label class="label-checkbox100" for="ckb1">
							تذكرنى
						</label>
					</div>
					<div class="container-login100-form-btn">
        <asp:Button ID="btnSubmit" runat="server" Text="دخول"  class="login100-form-btn" 
                            onclick="btnSubmit_Click"/>	
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- start js include path -->
	<script src="../scripts/jquery.min.js.download"></script>
	<!-- bootstrap -->
	<script src="../scripts/bootstrap.min.js.download"></script>
	<script src="../scripts/pages.js.download"></script>
	<!-- end js include path -->


<iframe id="mc-sidebar-container" style="top: 0px; padding: 0px; margin: 0px; z-index: 2147483646; position: fixed; border: none; opacity: 0; left: auto; right: 0px; display: block; max-width: none; transition: width 0s ease 0.4s, height 0s ease 0.4s, opacity 0.4s ease 0s, transform 0.4s ease 0s; transform: translate3d(400px, 0px, 0px); width: 400px; height: 0px;" src="../scripts/saved_resource.html"></iframe><iframe id="mc-topbar-container" style="top: 0px; padding: 0px; margin: 0px; z-index: 2147483646; position: fixed; border: none; opacity: 0; left: 0px; display: block; max-height: none; transition: width 0s ease 0.4s, height 0s ease 0.4s, opacity 0.4s ease 0s, transform 0.4s ease 0s; transform: translate3d(0px, -50px, 0px); height: 50px; width: 0px;" src="../scripts/saved_resource(1).html"></iframe><iframe id="mc-toast-container" style="bottom: 0px; right: 0px; padding: 0px; margin: 0px; z-index: 2147483640; position: fixed; border: none; opacity: 0; display: block; height: 0px; width: 0px;" src="../scripts/saved_resource(2).html"></iframe><iframe id="mc-download-overlay-container" style="bottom: 0px; right: 0px; padding: 0px; margin: 0px; z-index: 2147483640; position: fixed; border: none; opacity: 0; display: block; height: 0px; width: 0px;" src="../scripts/saved_resource(3).html"></iframe></body></html>
