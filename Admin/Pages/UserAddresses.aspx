<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserAddresses.aspx.cs" Inherits="Admin_Pages_UserAddresses" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>
<html lang="ar">
<head runat="server">
    <meta charset="utf-8" />
    <title>عناوين المستخدم</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        .map { height: 250px; width: 100%; margin-top: 10px; }
    </style>
</head>
<body dir="rtl">
    <form id="form1" runat="server">
        <div class="container mt-5">
            <h2 class="mb-4 text-center">عناوين المستخدم</h2>
            <asp:Repeater ID="rptAddresses" runat="server">
                <ItemTemplate>
                    <div class="card mb-3 shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("AddressName") %></h5>
                            <p class="card-text"><strong>الموبايل:</strong> <%# Eval("Mobile") %></p>
                            <p class="card-text"><strong>الهاتف:</strong> <%# Eval("phone") %></p>
                            <p class="card-text"><strong>الشارع:</strong> <%# Eval("StreetName") %>, 
                               <strong>المبنى:</strong> <%# Eval("Build") %>, 
                               <strong>الدور:</strong> <%# Eval("FloorNo") %>, 
                               <strong>الشقة:</strong> <%# Eval("adepartmentNo") %></p>
                            <p class="card-text"><strong>المحافظة:</strong> <%# Eval("Gov") %>, 
                               <strong>المنطقة:</strong> <%# Eval("Area") %></p>
                            <p class="card-text"><strong>تعليمات:</strong> <%# Eval("Instructions") %></p>
                            <p class="card-text"><strong>نوع العنوان:</strong> <%# GetATypeText(Eval("AType")) %></p>
                            <div id="map_<%# Eval("ID") %>" class="map"></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>

    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script>
        window.onload = function() {
            var addresses = <%= AddressesJson %>; // بيانات كل العناوين كـ JSON
            addresses.forEach(function(addr) {
                var mapId = 'map_' + addr.ID;
                
                var mapDiv = document.getElementById(mapId);
                
                if (mapDiv) {
                    var map = L.map(mapId).setView([addr.Latitude, addr.Longitude], 15);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19 }).addTo(map);
                    L.marker([addr.Latitude, addr.Longitude]).addTo(map)
                        .bindPopup('<b>' + addr.AddressName + '</b>')
                        .openPopup();
                }
            });
        }
    </script>
</body>
</html>

