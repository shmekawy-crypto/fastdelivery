<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Ar_Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
 <asp:Literal ID="litPageTitle" runat="server" Text="<%$ Resources:Texts, Default_PageTitle %>" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <div id="loader-wrapper">
    <div class="loader-container">
        <div class="logo-circle">
            <img src="images/logo.png" alt="Fast Delivery" class="preloader-logo">
        </div>
        <div class="loading-dots">
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
</div>
    
      <asp:ScriptManager runat="server" ID="ScriptManager1" EnablePageMethods="true" />
    <style>
        #map { height: 500px; }
        .header {
            background:none !important;
        }
    </style>
    <style>
/* الحاوية الرئيسية - تدرج لوني فخم وعميق */
#loader-wrapper {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    /* تدرج احترافي من الكحلي الغامق جداً للسواد */
    background: radial-gradient(circle at center, #1a1c2c 0%, #0d0e17 100%);
    z-index: 999999999;
    display: none;
    justify-content: center;
    align-items: center;
    transition: opacity 0.8s ease;
}

.loader-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 30px;
}

/* الدائرة المحيطة باللوجو - خلتها بيضاء بس مع "هالة" إضاءة حولها */
.logo-circle {
    width: 160px;
    height: 160px;
    background: #ffffff;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 30px;
    /* ظل أصفر خفيف خلف الدائرة يعطي إيحاء بأن اللوجو مضيء */
    box-shadow: 0 0 50px rgba(255, 193, 7, 0.2);
    animation: calm-pulse 2s ease-in-out infinite;
    position: relative;
}

.logo-circle img {
    width: 100%;
    height: auto;
    object-fit: contain;
}

/* ستايل النقط - خليتها بلون اللوجو الأصفر */
.loading-dots {
    display: flex;
    gap: 10px;
}

.loading-dots span {
    width: 12px;
    height: 12px;
    background-color: #ffc107; /* اللون الأصفر بتاع اللوجو */
    border-radius: 50%;
    display: inline-block;
    box-shadow: 0 0 10px rgba(255, 193, 7, 0.5);
    animation: dot-blink 1.4s infinite both;
}

.loading-dots span:nth-child(2) { animation-delay: 0.2s; }
.loading-dots span:nth-child(3) { animation-delay: 0.4s; }

/* أنيميشن النبض للدائرة */
@keyframes calm-pulse {
    0%, 100% { transform: scale(1); box-shadow: 0 0 50px rgba(255, 193, 7, 0.2); }
    50% { transform: scale(1.05); box-shadow: 0 0 70px rgba(255, 193, 7, 0.3); }
}

/* أنيميشن النقط */
@keyframes dot-blink {
    0%, 80%, 100% { opacity: 0.3; transform: scale(0.8); }
    40% { opacity: 1; transform: scale(1.2); }
}
</style>
    <section class="hero-section" role="region">
        <div class="container">
             <h1>
                <asp:Literal ID="litHeroTitle" runat="server" Text="<%$ Resources:Texts, Hero_Title %>" />
            </h1>
            <p data-key="hero_desc">
               
                <asp:Literal ID="litHeroDesc" runat="server" Text="<%$ Resources:Texts, Hero_Desc %>" />
            
            </p>

            <div class="search-wrapper">
                <div class="search-box">
                    <asp:DropDownList ID="ddlAddress"  name="ddlAddress" runat="server" style="width: 100%;"></asp:DropDownList>
 
                    <asp:HiddenField ID="hiddenCoords" runat="server" />
    
  <button id="location-btn" type="button" class="btn btn-primary" 
        >
    <i class="fa fa-map-marker-alt"></i>
</button>
                    
    <button id="final-search-btn" type="button" aria-label="البحث  في الموقع المحدد">
        <i class="fa fa-search"></i>
    </button>
</div>
                <script>
                    document.getElementById("final-search-btn").addEventListener("click", function () {
                        
                        // 1. هات أول ID من الريبيتر
                            const firstLink = document.querySelector(".card-content");
                        if (!firstLink) return; // علشان بس ما نسمعش صريخ

                        const id = firstLink.getAttribute("data-id");

                        // 2. هات addid من الـ DDL
                        const addid = document.getElementById('<%= ddlAddress.ClientID %>').value;

                        // 3. روح للصفحة المطلوبة
                        window.location.href = `Places.aspx?id=${id}&addid=${addid}`;
                    });

                </script>
   <script>
document.getElementById('location-btn').addEventListener('click', function() {
    // هنا حط رابط الصفحة اللي عايز تظهرها
    document.getElementById('locationIframe').src = 'AddAddress.aspx';
    var myModal = new bootstrap.Modal(document.getElementById('locationModal'));
    myModal.show();
});
</script>

<style>
    .search-box {
        display: flex;
        align-items: center;
        position: relative;
        width: 100%;
        background-color: #fff;
        border-radius: 6px;
        box-shadow: 0 0 4px rgba(0, 0, 0, 0.1);
        padding: 8px 10px;
    }
    .search-box select {
        flex: 1;
        font-size: 19px;
        background: transparent;
        border: none;
        outline: none;
        color: #333;
        padding: 5px;
        appearance: none;
        -webkit-appearance: none;
        -moz-appearance: none;
    }

    .search-box select option:first-child {
        color: #888;
    }

    .search-box button {
        background-color: transparent;
        border: none;
        font-size: 18px;
        cursor: pointer;
        margin-right: 8px;
    }

    .search-box i {
        color: #555;
    }

    .search-box button:hover i {
        color: #000;
    }
</style>

            </div>
        </div>
        <div class="hero-section-fade-out"></div>
    </section>
    
    <section class="categories-section gray-bg" role="region" aria-labelledby="section_1_title">
        <div class="content-container">
            <h2 id="section_1_title" data-key="section_1_title"> <asp:Literal ID="litSection1Title" runat="server" Text="<%$ Resources:Texts, Section1_Title %>" />
</h2>
            <div class="categories-grid">
       

                <asp:Repeater ID="rptCategory" runat="server">
                    <ItemTemplate>
                        <div class="category-card" role="link" tabindex="0">
                    <div class="category-card-bg" style="background-image: url('<%# Eval("PhotoPath") %>');"></div>
                      
                           <a id="placeLink" href='<%# "Places.aspx?id=" + Eval("id") + "&addid=" + ddlAddress.SelectedValue %>' runat="server" class="card-content" data-id='<%# Eval("id") %>'>

                        <h3 style="font-size: 30px;"><%# 
        System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName == "en" 
        ? DataBinder.Eval(Container.DataItem, "NameEn") 
        : System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName == "ru"
          ? DataBinder.Eval(Container.DataItem, "NameRu")
          : DataBinder.Eval(Container.DataItem, "Name")
    %></h3>
                        <p data-key="grocery_summary"><%# 
        System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName == "en" 
        ? DataBinder.Eval(Container.DataItem, "DescrEn") 
        : System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName == "ru"
          ? DataBinder.Eval(Container.DataItem, "DescrRu")
          : DataBinder.Eval(Container.DataItem, "DescrAr")
    %></p>
                    
                               </a>
                </div>

                    </ItemTemplate>
                </asp:Repeater>
                
            </div>
        </div>
    </section>

  <%--  <section class="categories-section" role="region" aria-labelledby="section_2_title">
        <div class="content-container">
            <h2 id="section_2_title">
                <asp:Literal ID="litSection2Title" runat="server" Text="<%$ Resources:Texts, Section2_Title %>" />
            </h2>
            <div class="categories-grid">
                <div class="category-card plain-bg" role="link" tabindex="0">
                    <div class="category-card-bg" style="background-color: #e8e8e8;"></div>
                    <div class="card-content">
                        <div class="card-icon"><i class="fa fa-store"></i></div>
                        <h3>
                            <asp:Literal ID="litPartnerTitle" runat="server" Text="<%$ Resources:Texts, Partner_Title %>" />
                        </h3>
                        <p>
                            <asp:Literal ID="litPartnerDesc" runat="server" Text="<%$ Resources:Texts, Partner_Desc %>" />
                        </p>
                        <a href="#">
                            <asp:Literal ID="litPartnerLink" runat="server" Text="<%$ Resources:Texts, Partner_Link %>" />
                            <i class="fa fa-chevron-left"></i>
                        </a>
                    </div>
                </div>
                <div class="category-card plain-bg" role="link" tabindex="0">
                    <div class="category-card-bg" style="background-image: url('PLACEHOLDER_FOR_DELIVERY_IMAGE.jpg');"></div>
                    <div class="card-content">
                        <div class="card-icon"><i class="fa fa-motorcycle"></i></div>
                        <h3>
                            <asp:Literal ID="litDeliveryTitle" runat="server" Text="<%$ Resources:Texts, Delivery_Title %>" />
                        </h3>
                        <p>
                            <asp:Literal ID="litDeliveryDesc" runat="server" Text="<%$ Resources:Texts, Delivery_Desc %>" />
                        </p>
                        <a href="#">
                            <asp:Literal ID="litDeliveryLink" runat="server" Text="<%$ Resources:Texts, Delivery_Link %>" />
                            <i class="fa fa-chevron-left"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

  <section class="cities-section" role="region" aria-labelledby="cities_title">
        <div class="content-container">
            <div class="section-icon"><i class="fa fa-map-marked-alt"></i></div>
            <h2 id="cities_title">
                <asp:Literal ID="litCitiesTitle" runat="server" Text="<%$ Resources:Texts, Cities_Title %>" />
            </h2>
            <div class="cities-grid">
                <asp:Literal ID="litCities" runat="server" Text="<%$ Resources:Texts, Cities_List %>" />
            </div>
        </div>
    </section>--%>

  <div class="modal fade" id="mapModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
            <h5 class="modal-title">Select Location</h5>
            <button type="button" class="close-btn" data-bs-dismiss="modal"><i class="fa fa-times"></i></button>
          </div>
      <div class="modal-body">
            <div id="map"></div>
          </div>
        <div class="modal-footer">
            <button id="btnGetLocation" type="button" class="btn btn-primary">📍 Get Current Location</button>
            <button id="btnSaveLocation" class="btn btn-success" type="button">💾 Save Location</button>

          </div>
    </div>
  </div>
</div>
            
    <script >
        document.getElementById('<%= ddlAddress.ClientID %>').addEventListener("change", function () {
            const addid = this.value;
            document.querySelectorAll(".card-content").forEach(link => {
                const id = link.getAttribute("data-id");
                link.href = `Places.aspx?id=${id}&addid=${addid}`;
            });
        });
    </script>

<script type="text/javascript">
    function openPopup() {
        window.open('PopupPage.aspx', 'PopupWindow',
        'width=600,height=400,resizable=yes,scrollbars=yes');
    }
</script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageScripts" runat="server">
   <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
     <script>
let map, marker, currentLatLng;

// جلب لغة الصفحة من الـ resources
let lang = '<%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName %>';

document.addEventListener("DOMContentLoaded", function () {
  const mapModal = document.getElementById('mapModal');

  mapModal.addEventListener('shown.bs.modal', function () {
    if (!map) {
      // Tile Layer حسب اللغة
      let tilesUrl;
      if (lang === 'en') {
        tilesUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      } else if (lang === 'ru') {
        tilesUrl = 'https://{s}.tile.openstreetmap.ru/{z}/{x}/{y}.png';
      } else {
        tilesUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'; // عربي/افتراضي
      }

      // Initialize map
      map = L.map('map').setView([30.0444, 31.2357], 15);

      // Load tiles
      L.tileLayer(tilesUrl, { maxZoom: 19, minZoom: 3, attribution: '© OpenStreetMap' }).addTo(map);

      // Click on map to set location
      map.on('click', function(e) {
        setMarker(e.latlng);
        map.setView(e.latlng, 15);
        reverseGeocode(e.latlng);
      });

      // Try to locate user initially
      map.locate({ setView: true, maxZoom: 15 });
      map.on('locationfound', function(e) {
        setMarker(e.latlng);
        map.setView(e.latlng, 15);
        reverseGeocode(e.latlng);
      });
    }

    setTimeout(() => map.invalidateSize(), 300);
  });

  // Get current location
  document.getElementById('btnGetLocation').addEventListener('click', function (event) {
    event.stopPropagation();
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(pos) {
        const latlng = { lat: pos.coords.latitude, lng: pos.coords.longitude };
        setMarker(latlng);
        map.setView(latlng, 15);
        reverseGeocode(latlng);
      }, function() {
        alert("Unable to get current location.");
      });
    } else {
      alert("Geolocation not supported.");
    }
  });

  // Save button
  document.getElementById('btnSaveLocation').addEventListener('click', function () {
    if (currentLatLng) {
      document.getElementById('<%= hiddenCoords.ClientID %>').value =
        `${currentLatLng.lat.toFixed(6)},${currentLatLng.lng.toFixed(6)}`;

      // حفظ في LocalStorage
      localStorage.setItem('UserLocation', `${currentLatLng.lat.toFixed(6)},${currentLatLng.lng.toFixed(6)}`);

      // إرسال للسيرفر Session
      PageMethods.SaveLocation(`${currentLatLng.lat.toFixed(6)},${currentLatLng.lng.toFixed(6)}`, function() {
        console.log("Session updated successfully!");
      });
    }
    const modal = bootstrap.Modal.getInstance(mapModal);
    modal.hide();
  });
});

// Marker helper
function setMarker(latlng) {
  currentLatLng = latlng;
  if (marker) map.removeLayer(marker);
  marker = L.marker(latlng).addTo(map);
}

// Reverse geocode حسب اللغة
function reverseGeocode(latlng) {
  fetch(`https://nominatim.openstreetmap.org/reverse?lat=${latlng.lat}&lon=${latlng.lng}&format=json&accept-language=${lang}`)
    .then(res => res.json())
    .then(data => {
      console.log(data.display_name); // الاسم بالعربي/إنجليزي/روسي حسب Resource
    });
}
</script>

   <!-- Button -->


<!-- Modal -->
<div class="modal fade" id="locationModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><asp:Literal ID="Literal1" runat="server" Text="<%$ Resources:Texts, Select_Location %>" />
</h5>
        <button type="button" class="close-btn" data-bs-dismiss="modal"><i class="fa fa-times"></i></button>
      </div>
      <div class="modal-body p-2">
        <iframe id="locationIframe" src="AddAddress.aspx" 
                style="width:100%; height:85dvh; min-height: 500px; border:none; -webkit-overflow-scrolling: touch;"></iframe>
      </div>
    </div>
  </div>
</div>

    <script>
var locationModal = document.getElementById('locationModal');

locationModal.addEventListener('hidden.bs.modal', function () {
    // يعيد تحميل الصفحة
    location.reload();
});
</script>
    <style>
        /*#locationModal .modal-dialog {
    max-width: 100%;
    width: 100%;
    margin: 0;
}

#locationModal .modal-content {
    width: 100%;
    border-radius: 0;
}

#locationModal .modal-body {
    padding: 0;
}*/
    </style>

    <script>
    (function () {
        const loader = document.getElementById('loader-wrapper');
        if (!loader) return;
        if (!sessionStorage.getItem('isLoaderShown')) {
            loader.style.display = 'flex';
            window.addEventListener('load', function () {
                // زودنا المدة هنا لـ 3000 ملي ثانية (3 ثوانٍ)
                setTimeout(function () {
                    loader.style.opacity = '0';
                    setTimeout(function () {
                        loader.style.display = 'none';
                    }, 1000); // وقت الاختفاء التدريجي
                }, 5000); 
            });

            sessionStorage.setItem('isLoaderShown', 'true');
        } else {
            loader.style.display = 'none';
        }
    })();
</script>
</asp:Content>


