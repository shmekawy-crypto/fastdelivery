<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeliveryZones.aspx.cs" Inherits="Admin_Pages_DeliveryZones" %>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>مناطق التوصيل</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" />

    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <style>
        #map {
            height: 350px;
            width: 100%;
            margin-bottom: 15px;
            border-radius: 10px;
            border: 1px solid #ccc;
        }

        @media (max-width: 575px) {
            #map {
                height: 280px;
            }
        }

        .leaflet-control button {
            font-size: 13px;
            white-space: nowrap;
        }

        table.table {
            font-size: 13px;
        }

        .table td, .table th {
            vertical-align: middle;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server" class="container py-3">

        <h4 class="text-center mb-3">إدارة مناطق التوصيل</h4>

        <!-- Map -->
        <div id="map"></div>

      
            <div class="row g-2 mb-3 text-center text-md-start">
            <div class="col-6 col-md-2">
                <asp:Label runat="server" Text="Latitude:" AssociatedControlID="txtLat"></asp:Label>
                <asp:TextBox ID="txtLat" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
            </div>
               
            <div class="col-6 col-md-2">
                <asp:Label runat="server" Text="Longitude:" AssociatedControlID="txtLng"></asp:Label>
                <asp:TextBox ID="txtLng" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
            </div>

            <div class="col-6 col-md-2">
                <asp:Label runat="server" Text="Radius (كم):" AssociatedControlID="txtRadius"></asp:Label>
                <asp:TextBox ID="txtRadius" runat="server" CssClass="form-control" Text="1" ClientIDMode="Static"></asp:TextBox>
            </div>
<div class="col-6 col-md-2">
                <asp:Label runat="server" Text="تكلفة التوصيل:" AssociatedControlID="txtRadius"></asp:Label>
                <asp:TextBox ID="txtDCost" runat="server" CssClass="form-control" Text="1" ClientIDMode="Static"></asp:TextBox>
            </div>
            <div class="col-6 col-md-2 d-flex align-items-end">
                <asp:Button ID="btnAddZone" runat="server" Text="إضافة" CssClass="btn btn-primary w-100"
                    OnClientClick="syncValuesBeforePostback()" OnClick="btnAddZone_Click" />
            </div>       
                 </div>
        <div class="table-responsive">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                CssClass="table table-bordered table-striped text-center"
                DataKeyNames="ZoneID"
                OnRowEditing="GridView1_RowEditing"
                OnRowCancelingEdit="GridView1_RowCancelingEdit"
                OnRowUpdating="GridView1_RowUpdating"
                OnRowDeleting="GridView1_RowDeleting">

                <Columns>
                    <asp:BoundField DataField="ZoneID" HeaderText="ID" ReadOnly="True" Visible="false" />
                    <asp:BoundField DataField="RestaurantName" HeaderText="المطعم" ReadOnly="True" />
                    <asp:BoundField DataField="Latitude" HeaderText="Latitude" />
                    <asp:BoundField DataField="Longitude" HeaderText="Longitude" />
                    <asp:BoundField DataField="RadiusKm" HeaderText="Radius (كم)" />
                    <asp:BoundField DataField="DeliveryCost" HeaderText="تكلفة التوصيل" />
                    <asp:BoundField DataField="DeliveredTime" HeaderText="مدة التوصيل" />
                    <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                </Columns>
            </asp:GridView>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="text-success fw-bold"></asp:Label>

    </form>

<script>
// Define Egypt bounds (southwest + northeast corners)
    // Create map, locked to Egypt
    const egyptBounds = L.latLngBounds(
    [21.5, 24.7],   // Southwest corner
    [31.6, 36.9]    // Northeast corner
);

let map = L.map('map').setView([30.0444, 31.2357], 15); // Automatically focus on Egypt
// Tile layer
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    minZoom: 3,
    attribution: '© OpenStreetMap'
}).addTo(map);
setTimeout(function () {
    map.invalidateSize();
}, 300);
// Marker and circle
let marker = null;
let circle = null;

// Draw radius circle
function drawCircle(lat, lng, radiusKm) {
    const radiusMeters = radiusKm * 1000;
    if (circle) map.removeLayer(circle);
    circle = L.circle([lat, lng], {
        color: '#0d6efd',
        fillColor: '#0d6efd',
        fillOpacity: 0.2,
        radius: radiusMeters
    }).addTo(map);
}

// Click to select point
map.on('click', function (e) {
    if (!egyptBounds.contains(e.latlng))
        return alert("اختر موقعًا داخل مصر فقط");

    const lat = e.latlng.lat.toFixed(6);
    const lng = e.latlng.lng.toFixed(6);
    const radiusKm = +txtRadius.value || 1;

    txtLat.value = lat;
    txtLng.value = lng;

    if (!marker)
        marker = L.marker(e.latlng).addTo(map);
    else
        marker.setLatLng(e.latlng);

    drawCircle(lat, lng, radiusKm);
});
map.locate({ setView: true, maxZoom: 15 });
map.on('locationfound', function (e) {
    setMarker(e.latlng);
    map.setView(e.latlng, 15);
    reverseGeocode(e.latlng);
});
// Update circle when radius changes
txtRadius.addEventListener('input', () => {
    const lat = +txtLat.value;
    const lng = +txtLng.value;
    if (!isNaN(lat) && !isNaN(lng))
        drawCircle(lat, lng, +txtRadius.value || 1);
});

// "My Location" button (no postback)
// "My Location" button with postback
const locateBtn = L.control({ position: 'topright' });
locateBtn.onAdd = function () {
    const b = L.DomUtil.create('button', 'btn btn-primary btn-sm');
    b.type = 'button';
    b.innerHTML = '<i class="bi bi-geo-alt"></i> موقعي الحالي';
    b.style.margin = '8px';
    b.onclick = () => {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(pos => {
                const latlng = [pos.coords.latitude, pos.coords.longitude];
                if (!egyptBounds.contains(latlng))
                    return alert("الموقع الحالي خارج مصر");

                map.setView(latlng, 15);
                txtLat.value = pos.coords.latitude.toFixed(6);
                txtLng.value = pos.coords.longitude.toFixed(6);

                if (!marker)
                    marker = L.marker(latlng).addTo(map);
                else
                    marker.setLatLng(latlng);

                drawCircle(latlng[0], latlng[1], +txtRadius.value || 1);

               
            });
        } else alert("المتصفح لا يدعم تحديد الموقع");
    };
    return b;
};
locateBtn.addTo(map);


// Show saved zones
if (typeof savedZones !== 'undefined' && savedZones.length > 0) {
    savedZones.forEach(z => {
        const marker = L.marker([z.Latitude, z.Longitude])
            .addTo(map)
            .bindPopup(`<b>${z.RestaurantName}</b><br>نصف القطر: ${z.RadiusKm} كم`);
        L.circle([z.Latitude, z.Longitude], {
            color: 'green',
            fillOpacity: 0.2,
            radius: z.RadiusKm * 1000
        }).addTo(map);
    });
}
</script>


</body>
</html>
