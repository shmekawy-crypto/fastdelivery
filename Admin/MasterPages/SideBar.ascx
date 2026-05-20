<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SideBar.ascx.cs" Inherits="Admin_Pages_SideBar" %>

<div class="sidebar-container">
				<div class="sidemenu-container navbar-collapse collapse fixed-menu">
					<div id="remove-scroll" class="left-sidemenu">
					<div  class="slimScrollDiv" >
                            
<ul id="sidemenu"  class="sidemenu"   data-auto-scroll="true" data-keep-expanded="false" data-slide-speed="200" style="padding-top: 20px;overflow:auto;width: auto;height: 607px;">
						
							<li class="sidebar-toggler-wrapper hide">
								<div class="sidebar-toggler">
									<span></span>
								</div>
							</li>
							<li class="sidebar-user-panel">
								<div class="user-panel">
								
                                    <div class="sidebar-user">
									<div class="sidebar-user-picture">
									<a href="../../Ar/Default.aspx" target="_blank"><asp:Image ID="logo2" class="img-circle " runat="server" /></a>	
									</div>
									<div class="sidebar-user-details">
										<div class="user-name"> <asp:Literal ID="lblUname" runat="server"></asp:Literal></div>
										<%--<div class="user-role">مشرف النظام</div>--%>
									</div>
								</div>

								</div>
                                
							</li>
    	<li class="nav-item">
								<a href="../pages/UsersR.aspx" id="UsersR" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">المستخدمين</span>
								</a>
							
							</li>


    <li class="nav-item">
								<a href="../pages/Drivers.aspx" id="Drivers" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">مناديب التوصيل</span>
								</a>
							
							</li>
    <li class="nav-item">
								<a href="../pages/Orders.aspx" id="Orders" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">الطلبات المرسلة</span>
								</a>
							
							</li>
							<li class="nav-item">
								<a href="../pages/Categories.aspx" id="Categories" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">التصنيفات </span>
								</a>
							
							</li>
    <li class="nav-item">
								<a href="../pages/gov.aspx" id="gov" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">المحافظات </span>
								</a>
							
							</li>
    <li class="nav-item">
								<a href="../pages/Areas.aspx" id="Areas" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">المناطق</span>
								</a>
							
							</li>
    <li class="nav-item">
								<a href="../pages/PlaceTypes.aspx" id="PlaceTypes" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">فئات الأماكن </span>
								</a>							
							</li>     
     <li class="nav-item">
								<a href="../pages/Coupons.aspx" id="Coupons" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">الكوبونات </span>
								</a>
							
							</li>
     <li class="nav-item">
								<a href="../pages/AdminBanners.aspx" id="AdminBanners" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">الإعلانات </span>
								</a>
							
							</li>
    
     <li class="nav-item">
								<a href="../pages/places.aspx" id="places" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">الأماكن </span>
								</a>
							
							</li>

   
      <li class="nav-item">
								<a href="../pages/sizes.aspx" id="sizes" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">الأحجام </span>
								</a>							
							</li>
      <li class="nav-item">
								<a href="../pages/Menus.aspx" id="Menus" runat="server" visible="false"  class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">إدارة القوائم </span>
								</a>							
							</li>
    <li class="nav-item">
								<a href="../pages/Menuitems.aspx" id="Menuitems" visible="false"  runat="server" class="nav-link nav-toggle" > <i class="material-icons">dashboard</i>
									<span class="title">عناصر القوائم </span>
								</a>
							
							</li>			
    <li class="nav-item">
								<a href="#" id="Users" runat="server" visible="false"  class="nav-link nav-toggle"> <i class="material-icons">
                                lock</i>
									<span class="title">المستخدمين والصلاحيات</span> <span class="arrow"></span>
								</a>
								<ul class="sub-menu">
                                     <li class="nav-item">
								<a href="../pages/Roles.aspx" runat="server" id="Roles" visible="false"   class="nav-link nav-toggle"> <i class="material-icons">add</i>
									<span class="title">رتب المستخدمين</span>
								</a>
							</li>
                                    <li class="nav-item">
								<a href="../pages/Privillages.aspx" runat="server" id="Privillages" visible="false"   class="nav-link nav-toggle"> <i class="material-icons">add</i>
									<span class="title">صلاحيات المستخدمين</span>
								</a>
							</li>
	                             <li class="nav-item">
								<a href="../pages/AddUsers.aspx" runat="server" id="AddUsers"   class="nav-link nav-toggle"> <i class="material-icons">add</i>
									<span class="title">إضافة المستخدمين</span>
								</a>
							</li>																	
										</ul>
							</li>	
							<li class="nav-item">
								<a href="../pages/ChangePassword.aspx" runat="server" id="ChangePassword"  class="nav-link nav-toggle"> <i class="material-icons">
                                lock</i>
									<span class="title">تغيير كلمة المرور</span>
								</a>								
							</li>

                            <li class="nav-item">
								<a href="../pages/Setting.aspx" runat="server" id="Setting" visible="false" class="nav-link nav-toggle"> <i class="material-icons">
                                settings</i>
									<span class="title">إعدادات عامة</span>
								</a>
								
							</li>
                                                                  	<li class="nav-item">
								<a href="../pages/Settings.aspx"  id="Settings" runat="server" visible="false" class="nav-link"> <i class="material-icons">add</i>
									<span class="title">بيانات الموقع</span>
								</a>
							</li>
                            
								<li class="nav-item">
								<a href="../pages/Login.aspx" class="nav-link nav-toggle"> <i class="icon-logout"></i>
									<span class="title">تسجيل الخروج</span>
								</a>
								
							</li>
                            				
						</ul>
                        </div>
					</div>
				</div>
			</div>