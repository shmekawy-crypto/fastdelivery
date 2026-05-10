<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddAddress.aspx.cs" Inherits="Ar_AddAddress" EnableEventValidation="false" %>
<!DOCTYPE html>
<html lang="<%= CurrentLang %>" dir="<%= CurrentDir %>">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>    <asp:Literal ID="litTitle" runat="server" Text="<%$ Resources:texts, Title %>"></asp:Literal>
</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/main.css" rel="stylesheet" />
   

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

    <!-- Bootstrap CSS -->
    

    <!-- Leaflet CSS --><link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <style>
        /* هنا تحط كل الستايلات من الصفحة الأصلية */
      
        #userDashboard { display:flex; justify-content:center; padding:25px; }
        .userProfileField { padding:25px; max-width:1024px; width:100%; margin:auto; box-shadow:0 2px 10px rgba(0,0,0,0.2); border-radius:0.5rem; }
        .profile-head { display:flex; justify-content:space-between; font-size:2rem; font-weight:bold; cursor:pointer; }
        .profileContainer { display:grid; grid-template-columns:20% 80%; margin-top:20px; padding:25px 0; border-top:1px solid rgba(0,0,0,0.2); }
        .profileSettings { list-style:none; border-left:1px solid rgba(0,0,0,0.2); padding-left:0; }
        .profileSettings li { padding:10px; }
        .profileSettings li.active { border-right:2px solid #0056b3; color:#0056b3; }
        #map { height:500px; }
        .modal-dialog { max-width:700px; width:95%; }
        .modal-body { padding:0 !important; }
        .addLocationBtn, .editLocationBtn, .deleteLocationBtn, .setLocationBtn, .current-location-btn { cursor:pointer; }
        /* ضف باقي الستايلات كما هي */
    </style>

    <!-- Leaflet JS -->
</head>
<body>
    <form id="form1" runat="server">

        <asp:HiddenField ID="hfSelectedArea" runat="server" />
           <div id="emptyLocations">
                    <i class="fa-solid fa-location-dot"></i>
                    <p><asp:Literal runat="server" Text="<%$ Resources:texts, NoAddress %>" /></p>
                    <button id="userLocationBtn" type="button" data-bs-toggle="modal" 
        data-bs-target="#OmapModal" onclick="resetAddressModal()">
    <asp:Literal runat="server" Text="<%$ Resources:texts, AddNewAddress %>" />
</button>
                </div>
                   
                <figure id="fgrdata">
                <button class="addLocationBtn" type="button" data-bs-toggle="modal" 
        data-bs-target="#OmapModal" onclick="resetAddressModal()">
    <i class="fa-solid fa-circle-plus"></i> 
    <asp:Literal runat="server" Text="<%$ Resources:texts, AddNewAddress %>" />
</button>


                <asp:Repeater ID="rptAddresses" runat="server" OnItemCommand="rptAddresses_ItemCommand" >
                   <ItemTemplate>
                               <div class="user-location">
  <h4><%# Eval("AddressName")%></h4>
  
     <p>
                                    <%# Eval("AType").ToString() == "0" ?
                                        GetLiteralText("Street") + Eval("StreetName") + " | " + GetLiteralText("Building") + Eval("Build") + " | " + GetLiteralText("Floor") + Eval("FloorNo") + " | " + GetLiteralText("Apartment") + Eval("adepartmentNo") :
                                        Eval("AType").ToString() == "1" ?
                                        GetLiteralText("Street") + Eval("StreetName") + " | " + GetLiteralText("House") + Eval("Build") :
                                        GetLiteralText("Street") + Eval("StreetName") + " | " + GetLiteralText("Building") + Eval("Build") + " | " + GetLiteralText("Floor") + Eval("FloorNo") + " | " + GetLiteralText("Office") + Eval("adepartmentNo") 
                                    %>
                                </p>
   <p><asp:Literal runat="server" Text="<%$ Resources:texts, Mobile %>" />: <%# Eval("Mobile") %></p>
                                <p><asp:Literal runat="server" Text="<%$ Resources:texts, LocationType %>" />: <%# Eval("AType").ToString() == "0" ? GetLiteralText("Apartment") : Eval("AType").ToString() == "1" ? GetLiteralText("House") : GetLiteralText("Office") %></p>

  
 <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditAddress" CommandArgument='<%# Eval("ID") %>' CssClass="editLocationBtn">
                                    <i class="fa-solid fa-pen"></i> <asp:Literal runat="server" Text="<%$ Resources:texts, Edit %>" />
                                </asp:LinkButton>

       <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteAddress" CommandArgument='<%# Eval("ID") %>'
                                    OnClientClick="return confirm('<%$ Resources:texts, ConfirmDelete %>');" CssClass="deleteLocationBtn">
                                    <i class="fa-solid fa-trash"></i> <asp:Literal runat="server" Text="<%$ Resources:texts, Delete %>" />
                                </asp:LinkButton>
</div>
                       </ItemTemplate>
                         
                    </asp:Repeater>
                    </figure>
       
<!-- Modal -->
<div class="modal fade" id="OmapModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered d-flex align-items-center justify-content-center">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <asp:Literal ID="lblModalTitle" runat="server" Text='<%$ Resources:texts, AddNewAddress %>' />
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <div id="map"></div>
                <div id="mapLoader" style="display:none; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(255,255,255,0.8); z-index:1000; flex-direction:column; align-items:center; justify-content:center;">
    <div class="spinner-border text-primary" role="status"></div>
    <span class="mt-2 fw-bold">جارٍ تحديد موقعك الحالي على الخريطة...</span>
</div>
                <figure id="locationFormShower">
                    <div id="locationDetails">

                        <!-- معلومات الاتصال -->
                        <div class="dataField">
                            <label for="mobile">
                                <asp:Literal ID="lblContactInfo" runat="server" Text='<%$ Resources:texts, ContactInfo %>' />
                            </label>
                            <div class="locationDataField">
                                <div>
                                    <div class="inputHolder">
                                        <div>
                                            <asp:TextBox ID="mobile" runat="server" placeholder='<%$ Resources:texts, MobilePlaceholder %>'></asp:TextBox>
                                        </div>
                                        <span class="egyptNum">| 20+</span>
                                    </div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                        ControlToValidate="mobile" ErrorMessage='<%$ Resources:texts, Required %>'
                                        CssClass="validator-error" ForeColor="Red" Display="Dynamic" ValidationGroup="saveadd" />
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                        ControlToValidate="mobile" ValidationExpression="^\d+$"
                                        ErrorMessage='<%$ Resources:texts, NumbersOnly %>' ValidationGroup="saveadd"
                                        ForeColor="Red" CssClass="validator-error" Display="Dynamic" />
                                </div>

                                <div>
                                    <asp:TextBox ID="phone" runat="server" Style="width:100%"
                                        placeholder='<%$ Resources:texts, PhoneOptional %>'></asp:TextBox>
                                    <br />
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                                        ControlToValidate="phone" ValidationExpression="^\d+$"
                                        ErrorMessage='<%$ Resources:texts, NumbersOnly %>' ValidationGroup="saveadd"
                                        ForeColor="Red" CssClass="validator-error" Display="Dynamic" />
                                </div>
                            </div>
                        </div>

                        <!-- المحافظة و المنطقة -->
                        <div class="dataField">
                            <div class="locationDataField">
                                <div>
                                    <asp:DropDownList ID="ddlGov" runat="server" CssClass="form-select"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                        ControlToValidate="ddlGov" InitialValue="0"
                                        ErrorMessage='<%$ Resources:texts, GovRequired %>' ValidationGroup="saveadd"
                                        SetFocusOnError="true" Display="Dynamic" CssClass="validator-error" />
                                </div>
                                <div>
                                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                        ControlToValidate="ddlArea" InitialValue="0"
                                        ErrorMessage='<%$ Resources:texts, AreaRequired %>' ValidationGroup="saveadd"
                                        SetFocusOnError="true" Display="Dynamic" CssClass="validator-error" />
                                </div>
                            </div>
                        </div>

                        <!-- عنوان التوصيل -->
                        <div class="dataField">
                            <label for="txtAddress">
                                <asp:Literal ID="lblDeliveryAddress" runat="server" Text='<%$ Resources:texts, DeliveryAddress %>' />
                            </label>
                            <div class="locationDataField">
                                <asp:TextBox ID="txtAddress" runat="server"
                                    placeholder='<%$ Resources:texts, AddressPlaceholder %>'></asp:TextBox>
                                <asp:HiddenField ID="hiddenCoords" runat="server" />
                            </div>
                        </div>

                        <!-- تفاصيل العنوان -->
                        <div class="dataField">
                            <div class="locationDataField">

                                <div class="radio-buttons">
                                    <asp:RadioButton ID="apartmentType" runat="server" GroupName="Options" Checked="true" />
                                    <label class="gender-btn" onclick="selectOption('<%= apartmentType.ClientID %>')">
                                        <i class="fa-solid fa-building"></i>
                                        <asp:Literal ID="lblApartment" runat="server" Text='<%$ Resources:texts, Apartment %>' />
                                    </label>

                                    <asp:RadioButton ID="houseType" runat="server" GroupName="Options" />
                                    <label class="gender-btn" onclick="selectOption('<%= houseType.ClientID %>')">
                                        <i class="fa-solid fa-house"></i>
                                        <asp:Literal ID="lblHouse" runat="server" Text='<%$ Resources:texts, House %>' />
                                    </label>

                                    <asp:RadioButton ID="officeType" runat="server" GroupName="Options" />
                                    <label class="gender-btn" onclick="selectOption('<%= officeType.ClientID %>')">
                                        <i class="fa-solid fa-city"></i>
                                        <asp:Literal ID="lblOffice" runat="server" Text='<%$ Resources:texts, Office %>' />
                                    </label>
                                </div>

                                <asp:TextBox ID="address" runat="server"
                                    placeholder='<%$ Resources:texts, AddressNameOptional %>'></asp:TextBox>

                                <div>
                                    <asp:TextBox ID="street" runat="server"
                                        placeholder='<%$ Resources:texts, StreetName %>' Style="width:100%"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rvstreet" runat="server"
                                        ControlToValidate="street" ErrorMessage='<%$ Resources:texts, Required %>'
                                        ValidationGroup="saveadd" ForeColor="Red" CssClass="validator-error" Display="Dynamic" />
                                </div>

                                <div>
                                    <asp:TextBox ID="building" runat="server"
                                        placeholder='<%$ Resources:texts, BuildingName %>' Style="width:100%"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rvbuilding" runat="server"
                                        ControlToValidate="building" ErrorMessage='<%$ Resources:texts, Required %>'
                                        ValidationGroup="saveadd" ForeColor="Red" CssClass="validator-error" Display="Dynamic" />
                                </div>

                                <div>
                                    <asp:TextBox ID="floorNumber" runat="server"
                                        placeholder='<%$ Resources:texts, FloorNumber %>' Style="width:100%"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rvfloorNumber" runat="server"
                                        ControlToValidate="floorNumber" ErrorMessage='<%$ Resources:texts, Required %>'
                                        ValidationGroup="saveadd" ForeColor="Red" CssClass="validator-error" Display="Dynamic" />
                                </div>

                                <div>
                                    <asp:TextBox ID="apartmentNumber" runat="server"
                                        placeholder='<%$ Resources:texts, ApartmentNumber %>' Style="width:100%"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rvapartmentNumber" runat="server"
                                        ControlToValidate="apartmentNumber" ErrorMessage='<%$ Resources:texts, Required %>'
                                        ValidationGroup="saveadd" ForeColor="Red" CssClass="validator-error" Display="Dynamic" />
                                </div>

                                <asp:TextBox ID="instructions" TextMode="MultiLine" runat="server"
                                    placeholder='<%$ Resources:texts, InstructionsOptional %>'></asp:TextBox>

                            </div>
                        </div>
                    </div>
                </figure>
            </div>

            <div class="modal-footer">
                <div class="mapBtns" id="locationSetBtns" style="display:none">
                    <button id="backToMap" type="button" class="current-location-btn"
                        onclick="document.getElementById('locationSetBtns').style.display='none'; document.getElementById('map2').style.display='flex';document.getElementById('map').style.display='block';document.getElementById('locationFormShower').style.display='none';">
                        <i class="fa-solid fa-location-dot"></i>
                        <asp:Literal ID="lblBackToMap" runat="server" Text='<%$ Resources:texts, BackToMap %>' />
                    </button>
                    <asp:LinkButton ID="setLocationBtn" CssClass="setLocationBtn" ValidationGroup="saveadd" runat="server"
                        OnClick="setLocationBtn_Click">
                        <i class="fa-solid fa-location"></i>
                        <asp:Literal ID="lblSaveAddress" runat="server" Text='<%$ Resources:texts, SaveAddress %>' />
                    </asp:LinkButton>
                </div>

                <div class="mapBtns" id="map2" style="display:flex">
                    <button id="btnGetLocation" type="button" class="btn btn-primary">
                        <asp:Literal ID="lblMyLocation" runat="server" Text='<%$ Resources:texts, MyLocation %>' />
                    </button>
                    <button id="btnSaveLocation" class="btn btn-success" type="button">
                        <asp:Literal ID="lblConfirmLocation" runat="server" Text='<%$ Resources:texts, ConfirmLocation %>' />
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
   <script>
       $('#<%= ddlArea.ClientID %>').change(function() {
           alert("m");
});
   </script>
        
         <script defer>
    // user profile settings
      const profileHead = document.querySelector(".profile-head");
      const dropDownBtn = document.querySelector("#dropDownBtn");
      const dropDownMenu = document.querySelector(".profileSettings");
      if (dropDownBtn) {
        dropDownBtn.addEventListener("click", () => {
          document.querySelector(".profile-head")?.classList.toggle("active");
          dropDownMenu?.classList.toggle("active");
          dropDownBtn.style.pointerEvents = "none";
          setTimeout(() => {
            dropDownBtn.style.pointerEvents = "auto";
          }, 500);
        });
      }
    </script>

    <script>
    let map, marker, currentLatLng;

    function toggleMapLoader(show) {
        const loader = document.getElementById('mapLoader');
        if (loader) { loader.style.display = show ? 'flex' : 'none'; }
    }

    document.addEventListener("DOMContentLoaded", function () {
        const mapModal = document.getElementById('OmapModal');

        mapModal.addEventListener('shown.bs.modal', function () {
            // 1. التأكد من وجود الخريطة
            if (!map) {
                const defaultLatLng = { lat: 31.037205, lng: 30.457321 };
                map = L.map('map').setView([defaultLatLng.lat, defaultLatLng.lng], 15);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19,
                    attribution: '© OpenStreetMap'
                }).addTo(map);

                map.on('click', function (e) {
                    setMarker(e.latlng);
                    reverseGeocode(e.latlng);
                });

                map.on('locationfound', function (e) {
                    setMarker(e.latlng);
                    map.setView(e.latlng, 15);
                    reverseGeocode(e.latlng);
                    toggleMapLoader(false);
                });

                map.on('locationerror', function (e) {
                    toggleMapLoader(false);
                    console.warn("Location access denied.");
                });
            }

            // 2. اللعبة هنا (تعديل ولا إضافة جديدة؟)
            // هنشوف الـ HiddenField فيه إحداثيات ولا فاضي
            const savedCoords = document.getElementById('<%= hiddenCoords.ClientID %>').value;

            if (savedCoords && savedCoords.includes(',')) {
                // حالة التعديل
                const parts = savedCoords.split(',');
                const latlng = { lat: parseFloat(parts[0]), lng: parseFloat(parts[1]) };
                setMarker(latlng);
                map.setView(latlng, 15);
                reverseGeocode(latlng);
            } else {
                // حالة إضافة جديدة - الآن ستعمل لأننا صفرنا القيمة
                toggleMapLoader(true);
                map.locate({ setView: true, maxZoom: 15 });
                // تأكد من إخفاء الفورم وإظهار الخريطة
                document.getElementById('map').style.display = 'block';
                document.getElementById('locationFormShower').style.display = 'none';
            }
            setTimeout(() => { map.invalidateSize(); }, 300);
        });

        // زر موقعي الحالي (لو حب يغير الموقع المحفوظ وهو جوه المودال)
        document.getElementById('btnGetLocation').addEventListener('click', function (event) {
            event.stopPropagation();
            toggleMapLoader(true);
            map.locate({ setView: true, maxZoom: 15 });
        });

        // زر الحفظ
        document.getElementById('btnSaveLocation').addEventListener('click', function () {
            if (currentLatLng) {
                document.getElementById('<%= hiddenCoords.ClientID %>').value = 
                    currentLatLng.lat.toFixed(6) + "," + currentLatLng.lng.toFixed(6);
                
                document.getElementById('map').style.display = 'none';
                document.getElementById('locationFormShower').style.display = 'block';
                document.getElementById('locationSetBtns').style.display = 'flex';
                document.getElementById('map2').style.display = 'none';
            } else {
                alert("يرجى تحديد موقع على الخريطة أولاً");
            }
        });
    });

    function setMarker(latlng) {
        currentLatLng = latlng;
        if (marker) map.removeLayer(marker);
        marker = L.marker([latlng.lat, latlng.lng]).addTo(map)
            .bindPopup("الموقع المحدد")
            .openPopup();
    }
        function resetAddressModal() {
    // 1. تفريغ الإحداثيات المخفية
    document.getElementById('<%= hiddenCoords.ClientID %>').value = "";
    
    // 2. إعادة ضبط النصوص في الفورم (الاختياري)
    document.getElementById('<%= txtAddress.ClientID %>').value = "";
    document.getElementById('<%= street.ClientID %>').value = "";
    document.getElementById('<%= building.ClientID %>').value = "";
    document.getElementById('<%= floorNumber.ClientID %>').value = "";
    document.getElementById('<%= apartmentNumber.ClientID %>').value = "";
    
    // 3. التأكد من ظهور الخريطة وإخفاء الفورم كبداية
    document.getElementById('map').style.display = 'block';
    document.getElementById('locationFormShower').style.display = 'none';
    document.getElementById('locationSetBtns').style.display = 'none';
    document.getElementById('map2').style.display = 'flex';

    // 4. تحديث نص المودال (إذا أردت)
    document.querySelector('.modal-title').innerText = "إضافة عنوان جديد";
}
    function reverseGeocode(latlng, retries = 2) {
        const txtBox = document.getElementById('<%= txtAddress.ClientID %>');
        txtBox.value = 'جارٍ جلب تفاصيل العنوان...';

        const apiKey = 'pk.afdf541d71deba0c2a855813cce14fca'; 
        const url = `https://us1.locationiq.com/v1/reverse?key=${apiKey}&lat=${latlng.lat}&lon=${latlng.lng}&format=json&zoom=17&accept-language=ar`;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                const a = data.address || {};
                const fullAddress = [a.state, a.city || a.town, a.road].filter(Boolean).join(' - ');
                txtBox.value = fullAddress || 'تم تحديد الموقع بنجاح';
                toggleMapLoader(false); 
            })
            .catch(() => {
                if (retries > 0) {
                    setTimeout(() => reverseGeocode(latlng, retries - 1), 800);
                } else {
                    txtBox.value = 'تعذر تحديد العنوان النصي';
                    toggleMapLoader(false);
                }
            });
    }

    // دالة الـ openMap اللي بتناديها من زرار التعديل الخارجي (لو موجود)
    function openMap(lat, lng) {
        // بنخزن القيم في الـ HiddenField عشان السكريبت اللي فوق يلقطها
        document.getElementById('<%= hiddenCoords.ClientID %>').value = lat + "," + lng;
        // نفتح المودال (لو مش مفتوح)
        // $('#OmapModal').modal('show'); 
    }

    // دالة selectOption (زي ما هي)
    function selectOption(radioId) {
        document.getElementById(radioId).checked = true;
        var txtfloor = document.getElementById('<%= floorNumber.ClientID %>');
        var txtapt = document.getElementById('<%= apartmentNumber.ClientID %>');
        var txtbuild = document.getElementById('<%= building.ClientID %>');
        var rvApt = document.getElementById('<%= rvapartmentNumber.ClientID %>');
        var rvFloor = document.getElementById('<%= rvfloorNumber.ClientID %>');

        const isHouse = (radioId === '<%= houseType.ClientID %>');
        txtapt.style.display = isHouse ? 'none' : 'block';
        txtfloor.style.display = isHouse ? 'none' : 'block';
        
        if (radioId === '<%= apartmentType.ClientID %>') txtbuild.placeholder = 'إسم البناية';
        else if (isHouse) txtbuild.placeholder = 'إسم المنزل';
        else txtbuild.placeholder = 'إسم المبنى/الشركة';

        if (typeof ValidatorEnable === "function") {
            ValidatorEnable(rvApt, !isHouse);
            ValidatorEnable(rvFloor, !isHouse);
        }
    }
</script>

    <script>

  function selectOption(radioId) {
    // check the clicked radio
    document.getElementById(radioId).checked = true;

    // get the textbox element
    
      var txtfloorNumber= document.getElementById('<%= floorNumber.ClientID %>');
      var txtapartmentNumber= document.getElementById('<%= apartmentNumber.ClientID %>');
      var txtbuilding= document.getElementById('<%= building.ClientID %>');
     
      var rvapartmentNumber = document.getElementById('<%= rvapartmentNumber.ClientID %>');
      var rvfloorNumber = document.getElementById('<%= rvfloorNumber.ClientID %>');
      // hide or show textbox depending on which radio is clicked
      if (radioId === '<%= apartmentType.ClientID %>') {
          document.getElementById('<%= apartmentType.ClientID %>').click()
      
          txtfloorNumber.style.display = 'block';
          txtapartmentNumber.style.display = 'block';
          txtbuilding.placeholder ='إسم البناية';
          txtapartmentNumber.placeholder = 'رقم الشقة';
          ValidatorEnable(rvapartmentNumber, true);
          ValidatorEnable(rvfloorNumber, true);
          
      }
        if (radioId === '<%= houseType.ClientID %>') {
          document.getElementById('<%= houseType.ClientID %>').click()
            txtapartmentNumber.style.display = 'none';
            txtfloorNumber.style.display = 'none';
            txtbuilding.placeholder ='إسم المنزل';
            ValidatorEnable(rvapartmentNumber, false);
            ValidatorEnable(rvfloorNumber, false);

        }
        if (radioId === '<%= officeType.ClientID %>') {
          document.getElementById('<%= officeType.ClientID %>').click()
          txtfloorNumber.style.display = 'block';
          txtapartmentNumber.style.display = 'block';
          txtapartmentNumber.placeholder = 'المكتب';
          ValidatorEnable(rvapartmentNumber, true);
          ValidatorEnable(rvfloorNumber, true);
         
      }

  }
    </script>
    <style>
        .radio-buttons {
            display: flex;
            gap: 10px;
        }

            .radio-buttons input[type="radio"] {
                display: none;
            }

            .radio-buttons label {
                padding: 10px 68px;
                border: 1px solid #ccc;
                cursor: pointer;
                user-select: none;
                transition: all 0.2s;
                border-top-right-radius: 8px;
                border-bottom-right-radius: 8px;
            }

            .radio-buttons input[type="radio"]:checked + label {
                background-color: var(--fd-blue);
                color: white;
                border-color: var(--fd-blue);
            }

            .radio-buttons label:hover {
                background-color: #e2e6ea;
            }

        .login-button {
            background-color: var(--fd-blue) !important;
            color: var(--fd-white) !important;
            padding: 14px !important;
            border: none !important;
            border-radius: 50px !important;
            font-size: 18px !important;
            font-weight: 700 !important;
            width: 100% !important;
            cursor: pointer !important;
            transition: background-color 0.2s !important;
            margin: 10px 0 5px !important;
        }
    </style>
    <style>
        .validator-error {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #d93025;
            font-size: 13px;
            margin-bottom: 10px;
            animation: fadeIn 0.2s ease-in;
        }

            .validator-error::before {
                content: "⚠️";
                font-size: 14px;
            }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-3px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
    <style>
        /* user profile styles */
        section#userDashboard {
            display: flex;
            justify-content: center;
            align-items: center;
            padding-inline: 25px;
        }

        .userProfileField {
            padding: 25px;
            padding-top: 120px;
            margin-bottom: 25px;
            max-width: 1024px;
            width: 100%;
            margin-inline: auto;
            box-shadow: var(--shadow);
            border-radius: 0.5rem;
        }

        .profile-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 2rem;
            font-weight: bold;
            i;

        {
            cursor: pointer;
            font-size: 1.75rem;
            transition: 0.5s all ease;
            display: none;
            &:hover;

        {
            color: var(--fd-blue);
            rotate: 180deg;
        }

        }
        }

        .profile-head.active {
            i;

        {
            rotate: 180deg;
            color: var(--fd-blue);
        }

        }

        .profileContainer {
            position: relative;
            isolation: isolate;
            display: grid;
            grid-template-columns: 20% 80%;
            margin-top: 20px;
            padding: 25px 0px;
            border-top: 1px solid rgba(0, 0, 0, 0.2);
        }

        .profileSettings {
            list-style-type: none;
            border-left: 1px solid rgba(0, 0, 0, 0.2);
            height: fit-content;
            li;

        {
            padding: 10px;
            transition: 0.3s color ease;
            &:hover;

        {
            a;

        {
            color: var(--fd-blue);
        }

        }

        a {
            transition: inherit;
        }

        }
        }

        .profileSettings li.active {
            a;

        {
            color: var(--fd-blue);
        }

        border-right: 2px solid var(--fd-blue);
        }

        .route {
            display: flex;
            gap: 1rem;
            align-items: baseline;
            color: #777;
            i;

        {
            color: var(--fd-blue);
            scale: 1.125;
        }

        a {
            color: black !important;
        }

        }

        .profileContainer form {
            padding-block: 10px;
            padding-right: 25px;
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
            input;

        {
            border-radius: 0.25rem;
            border: 1px solid rgba(0, 0, 0, 0.25);
            padding: 0.2rem 1rem;
            width: 100%;
            max-width: 300px;
            background-color: transparent;
            font-size: 0.9rem;
        }

        label,
        button {
            white-space: nowrap;
        }

        label {
            min-width: 113px;
        }

        button {
            border-radius: 2rem;
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
            border: 1px solid rgba(0, 0, 0, 0.25);
            background-color: transparent;
            transition: var(--transition);
            font-weight: bold;
            &:hover;

        {
            background-color: var(--fd-blue);
            color: white;
            border-color: transparent;
        }

        }

        .service_subscribe {
            width: fit-content;
            display: flex;
            align-items: center;
            gap: 1rem;
            input [type="checkbox"];

        {
            width: fit-content;
            scale: 1.5;
            accent-color: var(--fd-blue);
        }

        }
        }

        button[type="submit"] {
            background-color: var(--fd-blue) !important;
            color: white;
            font-size: 1rem !important;
            max-width: 250px;
            width: 100%;
            margin: auto;
            border-width: 2px;
            transition: var(--transition);
            border-color: transparent !important;
            &:hover;

        {
            border-color: var(--fd-blue) !important;
            background-color: transparent !important;
            color: var(--fd-blue) !important;
        }

        }

        .editBtns {
            align-items: center;
            flex-wrap: wrap;
            display: flex;
            gap: 1rem;
        }

        .gender-btn {
            padding: 10px 68px;
            border: 1px solid #ccc;
            cursor: pointer;
            user-select: none;
            transition: all 0.2s;
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

            .gender-btn:last-child {
                border-radius: 0;
                border-top-left-radius: 8px;
                border-bottom-left-radius: 8px;
            }

            .gender-btn:hover {
                background-color: #f0f0f0;
            }

        input[type="radio"]:checked + label {
            background-color: var(--fd-blue);
            color: white;
            border-color: var(--fd-blue);
        }

        input[type="radio"] {
            width: 150px;
        }

        .birthday {
            position: relative;
            isolation: isolate;
            width: 100%;
            max-width: 300px;
            svg;

        {
            position: absolute;
            left: 0.5rem;
            top: 0.5rem;
            width: 16px;
        }

        }

        .inputHolder {
            position: relative;
            width: 100%;
            border-radius: 0.25rem;
            max-width: 300px;
            isolation: isolate;
            background-color: #e9ecef;
            overflow: hidden;
            input;

        {
            cursor: not-allowed;
            color: rgb(74, 71, 71);
            &:focus;

        {
            outline: none;
        }

        }
        }

        .labelTag {
            font-size: 1.5rem;
            color: var(--fd-blue);
        }

        .dataField {
            display: flex;
            flex-wrap: wrap;
            align-items: baseline;
            gap: 1rem;
        }

        #emptyLocations {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            gap: 0.5rem;
            font-size: 1.25rem;
            min-height: 300px;
            color: #777;
            i;

        {
            font-size: 3rem;
            position: relative;
        }

        i::after {
            content: "";
            border-radius: 8px;
            rotate: 45deg;
            inset: 0;
            margin: auto;
            width: 8px;
            height: calc(100% + 24px);
            background: linear-gradient(to right, #777 50%, white 50%);
            position: absolute;
        }

        button {
            background-color: var(--fd-blue);
            color: white;
            padding: 0.5rem 1rem;
            outline: 0;
            font-size: 1rem;
            border: 2px solid transparent;
            border-radius: 0.5rem;
            transition: var(--transition);
            &:hover;

        {
            background-color: transparent;
            color: var(--fd-blue);
            border-color: currentColor;
        }

        }
        }

        #locationFormShower {
            width: 100%;
            interpolate-size: allow-keywords;
            top: 60px;
            left: 0;
            flex-direction: column;
            z-index: -1000;            
            transition: var(--transition);
            display:none;
        }

            #locationFormShower.is-visible {
                z-index: 10000;
                display: flex;
                opacity: 1;
                pointer-events: auto;
                visibility: visible;
            }

        #map-shower.hidden {
            z-index: -1000;
            opacity: 0;
            pointer-events: none;
            visibility: hidden;
        }

        .addLocationBtn {
            margin-block: 1rem;
            margin-inline: auto;
            display: flex;
            justify-content: center;
            align-items: baseline;
            gap: 0.5rem;
            font-size: 1.125rem;
            padding: 0.25rem 1.5rem;
            border-radius: 0.5rem;
            border: 2px solid #0056b3;
            transition: var(--transition);
            background-color: #0056b3;
            color: white;
            &:hover;

        {
            background-color: transparent;
            color: #0056b3;
        }

        }

        .user-location {
            padding-right: 20px;
            padding-block: 20px;
        }

            .user-location:nth-child(even) {
                background-color: whitesmoke;
            }

        .editLocationBtn {
            margin-top: 0.5rem;
            padding: 0.25rem 1.5rem;
            border-radius: 0.5rem;
            border: 2px solid var(--fd-blue);
            transition: var(--transition);
            background-color: var(--fd-blue);
            color: white;
            &:hover;

        {
            background-color: transparent;
            color: var(--fd-blue);
        }

        }
        .editLocationBtn, .deleteLocationBtn {
    display: inline-flex !important;
    visibility: visible !important;
    opacity: 1 !important;
    text-decoration: none !important;
}

.editLocationBtn *, .deleteLocationBtn * {
    visibility: visible !important;
    display: inline !important;
}
        .deleteLocationBtn {
            margin-top: 0.5rem;
            padding: 0.25rem 1.5rem;
            border-radius: 0.5rem;
            border: 2px solid var(--fd-red);
            transition: var(--transition);
            background-color: var(--fd-red);
            color: white;
            &:hover;

        {
            background-color: transparent;
            color: var(--fd-red);
        }

        }

        .hidden {
            display: none;
        }
        
        #map {
            height: 500px;
             position: relative;
        }
        .current-location-btn {
    /* position: absolute; */
    bottom: 15px;
    right: 15px;
    background: #007bff;
    color: white;
    border: none;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
    transition: var(--transition);
    z-index: 9999;
}
        .setLocationBtn {
    padding: 8px 15px;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    z-index: 1000;
    border: 2px solid var(--fd-blue);
    width: fit-content;
    transition: var(--transition);
    margin: 0;
        background-color: var(--fd-blue) !important;
    font-size: 1rem !important;
    max-width: 250px;
   
    border-color: transparent !important;
}
        .mapBtns {
    
    display: flex;
    justify-content: space-around;
    align-items: center;
    padding: 1rem;
    border: 1px solid rgba(0, 0, 0, 0.25);
    border-bottom-left-radius: 0.5rem;
    border-bottom-right-radius: 0.5rem;
    width: 100%;
}
    </style> 
    <style>
        /* make the modal wider */
#OmapModal .modal-dialog {
    max-width: 700px; /* wider modal, adjust as needed */
    width: 95%; /* keeps it responsive */
}

/* remove padding and polish edges */
#OmapModal .modal-content {
    padding: 0 !important;
    border-radius: 10px; /* optional */
    overflow: hidden; /* keeps things tidy if content touches edges */
}

/* kill inner padding Bootstrap adds */
#OmapModal .modal-body {
    padding: 0 !important;
}

/* optional – map full width inside body */
#OmapModal #map {
    width: 100%;
    margin: 0;
}

/* clean up header/footer spacing */
#OmapModal .modal-header,
#OmapModal .modal-footer {
    padding: 10px 15px; /* smaller and tighter */
}

    </style>  
    <style>
        /* layout the radio buttons horizontally */
#OmapModal .radio-buttons {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: stretch;
    gap: 10px;
    margin: 10px 0;
}

/* style each label like a column button */
#OmapModal .gender-btn {
    flex: 1; /* each takes equal width */
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 15px;
    border: 1px solid #ccc;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease-in-out;
    text-align: center;
}

/* highlight the selected one */

/* icons */
#OmapModal .gender-btn i {
    font-size: 20px;
    margin-bottom: 5px;
}

    </style> 

    <script src="https://cdn.jsdelivr.net/npm/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $('#ddlArea').change(function() {
    $('#<%= hfSelectedArea.ClientID %>').val($(this).val());
});
        </script>
    <script>
        function getCookie(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
            return null;
        }
    $(document).ready(function() {
        $("#<%= ddlGov.ClientID %>").change(function() {
            var govID = $(this).val();
            var lang = getCookie("lang");
            if (govID != "0") {
                $.ajax({
                    type: "POST",
                    url: "AddAddress.aspx/GetAreasByGov",
                    data: JSON.stringify({ govID: parseInt(govID), lang: lang }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var ddlArea = $("#<%= ddlArea.ClientID %>");
                        ddlArea.empty();
                        ddlArea.append($('<option/>', { value: 0, text: '-- اختر المنطقة --' }));

                        $.each(response.d, function () {
                            ddlArea.append($('<option/>', { value: this.Value, text: this.Text }));
                        });
                    },
                    error: function (err) {
                        console.log(err);
                    }
                });
            } else {
                var ddlArea = $("#<%= ddlArea.ClientID %>");
                ddlArea.empty();
                ddlArea.append($('<option/>', { value: 0, text: '-- اختر المنطقة --' }));
            }
        });
    });
</script>
        </form>
</body>
</html>
