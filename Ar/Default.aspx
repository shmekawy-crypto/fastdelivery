<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Ar_Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <title><asp:Literal ID="litPageTitle" runat="server" Text="<%$ Resources:Texts, Default_PageTitle %>" /></title>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <asp:ScriptManager runat="server" ID="ScriptManager1" EnablePageMethods="true" />
    <style>
        #map { height: 500px; }

        /* --- New Premium Loader --- */
        #loader-wrapper {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at center, #1a1c2c 0%, #0d0e17 100%);
            z-index: 999999;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: opacity 0.6s cubic-bezier(0.4, 0, 0.2, 1), visibility 0.6s;
        }
        .loader-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 2rem;
        }
        .logo-circle {
            width: 140px;
            height: 140px;
            background: #fff;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            position: relative;
            animation: pulse-logo 2s infinite ease-in-out;
        }
        .preloader-logo {
            width: 85px;
            height: auto;
            object-fit: contain;
        }
        .loading-dots {
            display: flex;
            gap: 10px;
        }
        .loading-dots span {
            width: 12px;
            height: 12px;
            background: #ffc107; /* Standard branding color */
            border-radius: 50%;
            animation: bounce-dots 1.4s infinite ease-in-out both;
        }
        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes pulse-logo {
            0%, 100% { transform: scale(1); box-shadow: 0 15px 35px rgba(0,0,0,0.1); }
            50% { transform: scale(1.08); box-shadow: 0 20px 45px rgba(0,0,0,0.15); }
        }
        @keyframes bounce-dots {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
        .loader-hidden {
            opacity: 0;
            visibility: hidden;
        }
        .news-swipr {
            background: #f5f5f5 !important;
        }

        @media (max-width:480px){
                .whatsapp-float {
                    bottom: 150px !important;
                }

        }
    </style>

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
        font-size: 20px;
        background: transparent;
        border: none;
        outline: none;
        color: #333;
        padding: 5px;
        appearance: none;
        -webkit-appearance: none;
        -moz-appearance: none;
    }
    @media(max-width:480px){
      .search-box select {
        font-size: 16px !important;
      }
       .back-to-top {
        bottom: 150px !important;
       }

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
        color: white;
    }

    .search-box button:hover i {
        color: #000;
    }
</style>

            </div>
        </div>
        <div class="hero-section-fade-out"></div>
    </section>

    <section class="news-swipr">
        <div class="swiper newsSwiper">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <img src="https://np.naukimg.com/cphoto/l45XrkFOujKTaHBdN6PUrTtURaQ/6AFPI5l/k2gAkQqVwFKHFwvhK7u32Kmseoy1Xu1tTnRJRtug8Q2lzX6Wp02NFCPzn2tkSW8b4Mm3yavA7NNZXdbZaFECMd/ZnVDpzp" alt="News Image" />
                </div>
                <div class="swiper-slide">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb_FiZTdONoWw2NWQ_hk1FBfFb3NIhiWImUA&s" alt="News Image" />
                </div>
                <div class="swiper-slide">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCL35UgrPqNPxqfmpoEq1ZFvdM7I7bz61B3w&s" alt="News Image" />
                </div>
                <div class="swiper-slide">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTx319C2Cuuz7TXEhCMHcSrpvwcLgqnO2ahzg&s" alt="News Image" />
                </div>
            </div>
        </div>
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
        window.addEventListener('load', function() {
            const loader = document.getElementById('loader-wrapper');
            if (loader) {
                setTimeout(() => {
                    loader.classList.add('loader-hidden');
                }, 1200);
            }
        });
    </script>
</asp:Content>


