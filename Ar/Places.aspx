<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true"
  CodeFile="Places.aspx.cs" Inherits="Ar_Places" %>
  <asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <title><asp:Literal ID="ltPageTitle" runat="server" Text="<%$ Resources:texts, Page_Places_Title %>"></asp:Literal></title>
  </asp:Content>
  <asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>


.news-swipr {
    width: 100%;
    background: transparent;
    padding: 40px;
    height: auto;
    overflow: hidden !important;
    max-height: 350px;
}

.news-swipr .newsSwiper {
    width: 100%;
    max-width: 1200px;
    margin: auto;
    overflow: visible !important;
    max-height: 300px;
}

.news-swipr .newsSwiper {
    .swiper-wrapper {
        max-height: 280px;
    }
}


      .shopRating {
        display: flex;
        gap: 0.25rem;
        font-size: 0.9rem;
        align-items: center;

        i {
          color: #FFD700;
        }
      }

      #selectedLocationShops {
        padding-top: 125px;
        padding-inline: 25px;
        padding-bottom: 50px;
        margin: auto;
        max-width: 1200px;
        width: 100%;

        h2 {
          display: flex;
          justify-content: space-between;
          gap: 1rem;
          align-items: start;
          line-height: 1.2;
        }

        #filterIcon {
          display: none;
        }
      }


      .selectedLocationFilters {
        margin-top: 25px;
        gap: 1.5rem;
      }


      .selectedLocationCategories {
        display: flex;
        flex-direction: column;
        gap: 1rem;


        .submit {
          margin: 0;
          max-width: 100%;
        }
      }

      @media (max-width:480px){
        #selectedLocationShops{
          padding-top: 50px !important;
        }
      }
      .inputHolder {
        position: relative;
        width: 100%;
        max-width: 550px;

        .showPassword {
          color: #444 !important;
        }

        input {
          padding: 0.5rem 1rem;
          border-radius: 0.25rem;
          background-color: #f8f9fa;
          border: 1px solid rgba(0, 0, 0, 0.1);
          width: 100%;
        }

        .showPassword {
          position: absolute;
          top: 0;
          height: fit-content;
          font-size: 1.25rem;
          bottom: 0;
          margin: auto;
        }

      }

      .selectedLocationCategories {
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }

      .filters {
        position: sticky;
        top: 30px;
        height: fit-content;
      }

      .border {
        height: 1px;
        background-color: rgba(0, 0, 0, 0.25);
        display: block;
        border-radius: 1rem;
        width: 100%;
        margin-top: 1rem;
        margin-bottom: 0rem;
      }


      .locationShops {
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }




      #selectedFilter {
        background-color: #f8f9fa;
      }

      .filterFor {
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }

      .filterOptions {
        padding-inline: 0.5rem;
        max-height: 180px;
        overflow-y: auto;
        -webkit-overflow-scrolling: touch;
        /* smooth scroll on iOS */
        /* overscroll-behavior: contain; */
        /* prevent scroll chaining */
        touch-action: pan-y;

      }

      .filterOption {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.9rem;
        color: rgba(0, 0, 0, 0.5);

      }

      .mainFilters {
        display: flex;
        column-gap: 1rem;
        align-items: center;
        font-weight: bold;
        white-space: nowrap;
        flex-wrap: wrap;
      }

      .mainFiltersLabels {
        display: flex;
        padding: 0.5rem 1rem;
        white-space: nowrap;
        flex-wrap: nowrap;
        scroll-behavior: auto;
        -webkit-overflow-scrolling: touch;
        column-gap: 1rem;
        overflow: auto;
        cursor: grab;

        &:active {
          cursor: grabbing;
        }

        span {
          user-select: none;
          cursor: pointer;
          font-weight: 500;
          transition: var(--transition);
          border: 1px solid rgba(0, 0, 0, 0.1);
          padding: 0.25rem 1rem;
          text-align: center;
          border-radius: 3rem;

          &:hover {
            background-color: var(--fd-blue);
            color: white;
            border-color: var(--fd-blue);


          }

        }
      }

      .mainFilters .filterCategory.active {
        background-color: var(--fd-blue);
        color: white;
        pointer-events: none;
        border-color: var(--fd-blue);
      }

      .availableShop {
        display: flex;
        gap: 1.5rem;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        padding: 1rem;

        transition: var(--transition);

        img {
          width: 120px;
          height: 120px;
          aspect-ratio: 1;
          object-position: center;
          object-fit: cover;
          border: 1px solid rgba(0, 0, 0, 0.1);
          border-radius: 0.5rem;
        }

        &:hover {
          background-color: #f8f9fa;

          .availableShopName {
            color: var(--fd-blue);
          }
        }
      }

      .allAvailableShops {
        display: flex;
        flex-direction: column;
      }

      .availableShopDesc {
        display: flex;
        flex-direction: column;
      }

      .availableShopName,
      .shopFoods {
        line-height: 1.5;
        margin-bottom: 0.5rem;
        transition: var(--transition);
      }



      .shopRating {
        display: flex;
        gap: 0.25rem;
        font-size: 0.9rem;
        align-items: center;

        i {
          color: #FFD700;
        }
      }

      .trustBadge {
        display: flex;
        align-items: center;
        gap: 2rem;
        font-weight: bold;
        font-size: 0.8rem;
        margin-top: 0.5rem;
      }

      .circleBadge {
        position: relative;
        isolation: isolate;

        &::after {
          content: '';
          width: 5px;
          height: 5px;
          background-color: rgba(0, 0, 0, 0.5);
          border-radius: 100%;
          right: 0;
          transform: translateX(18px);
          top: 0;
          bottom: 0;
          margin: auto;
          display: block;
          aspect-ratio: 1;
          position: absolute;

        }
      }

      .shopDelivery {
        display: flex;
        column-gap: 1rem;
        flex-wrap: wrap;
        font-size: 0.9rem;
        align-items: center;
        white-space: nowrap;
      }

      .shopRatingStars hidden {
        background-color: var(--fd-blue);
        color: white;
        font-weight: bold;
        font-size: 2rem;
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100px;
        height: 100px;
        position: absolute;
        top: 0;
        left: 0;

      }

      .availableShop {
        position: relative;
        isolation: isolate;
      }

      /* تنسيق الغلاف الرئيسي لشريط التصنيفات */
      .categories-bar-wrapper {
        width: 100%;
        /* يمكنك تعيين لون خلفية مختلف */
        background-color: #ffffff;
        padding: 15px 0;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        /* ظل خفيف */
        margin-bottom: 20px;
        /* مسافة عن باقي المحتوى */
      }

      /* تنسيق حاوية التمرير الأفقية */
      .categories-bar-scroller {
        display: flex;
        /* لعرض العناصر بجانب بعضها */
        overflow-x: auto;
        /* تمكين التمرير الأفقي عند الحاجة */
        -webkit-overflow-scrolling: touch;
        /* تحسين التمرير على الهواتف */
        gap: 20px;
        /* مسافة بين العناصر */
        padding: 0 10px;
        /* لإعطاء مساحة عند التمرير */
      }

      /* إخفاء شريط التمرير (Scrollbar) */
      .categories-bar-scroller::-webkit-scrollbar {
        display: none;
      }

      .categories-bar-scroller {
        -ms-overflow-style: none;
        /* IE and Edge */
        scrollbar-width: none;
        /* Firefox */
      }

      /* تنسيق عنصر التصنيف الواحد */
      .category-item {
        display: flex;
        flex-direction: column;
        /* الصورة فوق النص */
        align-items: center;
        text-align: center;
        text-decoration: none;
        color: #333;
        min-width: 65px;
        /* تثبيت العرض لكي لا تنكمش */
        flex-shrink: 0;
        /* منع العناصر من الانكماش */
        transition: transform 0.2s;
      }

      .category-item:hover {
        color: #ffc119;
        /* لون مميز عند المرور */
      }

      /* تنسيق الصورة */
      .category-item img {
        width: 50px;
        /* حجم الأيقونة/الصورة */
        height: 50px;
        border-radius: 50%;
        /* لجعلها دائرية */
        object-fit: cover;
        margin-bottom: 5px;
        border: 2px solid transparent;
      }

      /* حالة النشط */
      .category-item.active img {
        border-color: #ffc119;
      }

      .category-item span {
        font-size: 14px;
        white-space: nowrap;
        /* منع النص من الالتفاف */
      }

      /* تنسيق الصورة في حالة النشط */
      .category-item.active img {
        border-color: #ffc119;
      }

      /* حالة النشط */
      .category-item.active {
        color: #ffc119;
        /* هذا السطر يغير لون الكتابة (النص) */
      }

      /* تنسيق الصورة في حالة النشط (للحفاظ على حدود الصورة) */
      .category-item.active img {
        border-color: #ffc119;
      }

      /* 1. إظهار الشريط الأفقي فقط في الموبايل */
      .food-categories-mobile-bar {
        width: 100%;
        /* جعله يختفي افتراضياً في الشاشات الكبيرة */
        display: none;
        padding: 10px 0;
        background-color: #f7f7f7;
        margin-bottom: 15px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
      }

      /* 2. حاوية التمرير الأفقي */
      .categories-list-scroll {
        display: flex;
        /* لعرض العناصر بجانب بعضها */
        overflow-x: auto;
        /* تمكين التمرير الأفقي */
        -webkit-overflow-scrolling: touch;
        /* تحسين التمرير على iOS */
        gap: 10px;
        /* المسافة بين التصنيفات */
        padding: 0 15px;
        /* مسافة على الجانبين */
      }

      /* إخفاء شريط التمرير (لجمالية أفضل) */
      .categories-list-scroll::-webkit-scrollbar {
        display: none;
      }

      .categories-list-scroll {
        -ms-overflow-style: none;
        /* IE and Edge */
        scrollbar-width: none;
        /* Firefox */
      }

      /* 3. تنسيق عنصر التصنيف (Pill) */
      .category-pill {
        display: flex;
        align-items: center;
        padding: 8px 10px;
        border-radius: 20px;
        /* شكل الحبة (Pill Shape) */
        background-color: #fff;
        color: #333;
        text-decoration: none;
        font-size: 14px;
        white-space: nowrap;
        /* مهم: منع النص من النزول لسطر جديد */
        border: 1px solid #eee;
        transition: background-color 0.2s, color 0.2s, border-color 0.2s;
        flex-shrink: 0;
        /* مهم: منع العناصر من الانكماش */
      }

      .category-pill img {
        width: 20px;
        height: 20px;
        margin-inline-end: 8px;
        /* مسافة بين الصورة والنص */
      }

      /* 4. حالة العنصر النشط */
      .category-pill.active {
        background-color: #ffc119;
        /* اللون المميز */

        border-color: #ffc119;
      }


      /* 5. نقطة التوقف (Media Query) لتفعيل العرض في الموبايل */
      @media (max-width: 768px) {
        .food-categories-mobile-bar {
          display: block;
          /* إظهار الشريط في الشاشات الصغيرة */
        }

        /* إذا كانت قائمة التصنيفات القديمة تختفي، يمكنك إخفاؤها هنا */
        /* .content-inside-restaurant-menu { display: none; } */
      }

            .availableShop {
                display: flex !important;
                gap: 1rem !important;
                padding: 1.5rem !important;
                background: white !important;
                border-radius: 1.25rem !important;
                border: 1px solid rgba(0, 0, 0, 0.1) !important;
                box-shadow: 0px 4px 15px rgba(0,0,0,0.05) !important;
                transition: all 0.3s ease !important;
                text-decoration: none !important;
                color: inherit !important;
                margin-bottom: 1rem !important;
                height: auto !important;
            }

            .shop-main-row {
                display: flex !important;
                justify-content: space-between !important;
                align-items: flex-start !important;
                gap: 2rem !important;
            }

            .shop-info-text {
                flex: 1 !important;
                display: flex !important;
                flex-direction: column !important;
                gap: 0.5rem !important;
            }

            .availableShopName {
                display: flex !important;
                align-items: center !important;
                gap: 10px !important;
                font-size: 1.5rem !important;
                font-weight: 800 !important;
                color: #222 !important;
                margin: 0 !important;
            }

            .status-badge {
                padding: 4px 12px !important;
                border-radius: 2rem !important;
                font-size: 0.75rem !important;
                font-weight: 700 !important;
                display: inline-block !important;
            }
            .status-badge.open {
                background: #e8f5e9 !important;
                color: #2e7d32 !important;
                border: 1px solid #c8e6c9 !important;
            }
            .status-badge.closed {
                background: #ffebee !important;
                color: #c62828 !important;
                border: 1px solid #ffcdd2 !important;
            }

            .shopFoods {
                font-size: 0.95rem !important;
                color: #666 !important;
                line-height: 1.6 !important;
                margin: 0 !important;
            }

            .shop-visual-part {
                display: flex !important;
                flex-direction: column !important;
                align-items: center !important;
                gap: 0.75rem !important;
            }

            .shop-img-wrapper {
                width: 130px !important;
                height: 130px !important;
                position: relative !important;
            }
            .shop-img-wrapper img {
                width: 100% !important;
                height: 100% !important;
                border-radius: 1.25rem !important;
                object-fit: cover !important;
                border: 1px solid rgba(0,0,0,0.05) !important;
            }

            .shop-details-row {
                display: flex !important;
                justify-content: space-between !important;
                align-items: center !important;
                padding-top: 1rem !important;
                border-top: 1px dashed rgba(0,0,0,0.1) !important;
                flex-wrap: wrap !important;
                gap: 1rem !important;
            }

            .shopDelivery {
                display: flex !important;
                gap: 1.5rem !important;
                font-size: 0.85rem !important;
                color: #444 !important;
                font-weight: 600 !important;
            }

            .shop-features {
                display: flex !important;
                gap: 1rem !important;
                align-items: center !important;
            }
            .feature-item {
                display: flex !important;
                align-items: center !important;
                gap: 6px !important;
                font-size: 0.8rem !important;
                color: #555 !important;
                background: #f8f9fa !important;
                padding: 6px 12px !important;
                border-radius: 0.5rem !important;
            }
            .feature-item i {
                color: #007bff !important;
            }
            .feature-item.promo {
                color: #e91e63 !important;
                background: #fdf2f8 !important;
                font-weight: 700 !important;
            }
            .feature-item.promo i {
                color: #e91e63 !important;
            }

        </style>



    <section id="selectedLocationShops">
      <div class="categories-bar-wrapper">
        <div class="container categories-bar-scroller">

          <asp:Repeater ID="CategoryRepeater" runat="server">
            <ItemTemplate>

              <a href='Places.aspx?id=<%# Eval("ID") %>&addid=<%# Request.QueryString["addid"].ToString() %>'
                class="category-item<%# GetActiveClass(Eval(" ID").ToString()) %>">
                <img src='<%# Eval("PhotoPath") %>' onerror="this.src='/ar/images/placeholderImage.webp'" />
                <span>
                  <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en" ?
                    DataBinder.Eval(Container.DataItem, "NameEn" ) :
                    System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru" ?
                    DataBinder.Eval(Container.DataItem, "NameRu" ) : DataBinder.Eval(Container.DataItem, "Name" ) %>
                </span>
              </a>
            </ItemTemplate>
          </asp:Repeater>

        </div>
      </div>
      <span class="route">
        <a href="Default.aspx">
          <asp:Literal ID="ltHome" runat="server" Text="<%$ Resources:texts, Home %>"></asp:Literal>
        </a>
        <i class="fa-solid fa-angles-left"></i>
        <asp:Literal ID="ltlocation" runat="server"></asp:Literal>
      </span>

      <h2>
        <asp:Literal ID="ltDeliveryFrom" runat="server" Text="<%$ Resources:texts, DeliveryFrom %>"></asp:Literal>
        <asp:Literal ID="ltname" runat="server"></asp:Literal>
        <asp:Literal ID="ltNearMe" runat="server" Text="<%$ Resources:texts, NearMe %>"></asp:Literal>
        (<asp:Literal ID="ltlocation2" runat="server"></asp:Literal>)
        <span id="filterIcon"><i class="fa-solid fa-filter"></i></span>
      </h2>
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

      <div class="selectedLocationFilters">
        <figure class="locationShops">
          <div class="inputHolder">
            <label for="selectedShopSearcher" class="showPassword"><i class="fa-solid fa-magnifying-glass"></i></label>
            <input type="text" name="selectedShopSearcher" id="selectedShopSearcher"
              placeholder="<%=Resources.Texts.Search %>">
          </div>
          <article class="mainFilters">
            <span>
              <asp:Literal ID="ltSortBy" runat="server" Text="<%$ Resources:texts, SortBy %>"></asp:Literal>
            </span>

            <div class="mainFiltersLabels">
              <span class="filterCategory active" id="alphabeticOrder">
                <asp:Literal ID="ltSortAlpha" runat="server" Text="<%$ Resources:texts, Sort_Alpha %>"></asp:Literal>
              </span>

              <span class="filterCategory" id="deliveryFeeOrder">
                <asp:Literal ID="ltSortDeliveryFee" runat="server" Text="<%$ Resources:texts, Sort_DeliveryFee %>">
                </asp:Literal>
              </span>

              <span class="filterCategory" id="deliveryTimeOrder">
                <asp:Literal ID="ltSortTime" runat="server" Text="<%$ Resources:texts, Sort_Time %>"></asp:Literal>
              </span>

              <span class="filterCategory" id="minPayOrder">
                <asp:Literal ID="ltSortMinOrder" runat="server" Text="<%$ Resources:texts, Sort_MinOrder %>">
                </asp:Literal>
              </span>

              <span class="filterCategory" id="ratingOrder">
                <asp:Literal ID="ltSortRating" runat="server" Text="<%$ Resources:texts, Sort_Rating %>"></asp:Literal>
              </span>
            </div>

          </article>
            <div class="food-categories-mobile-bar" style="display:block; background-color:#fff;">
    <div class="categories-list-scroll">

  <a href="javascript:void(0);" class="category-pill active" onclick="filterByJS('0', this)">
        <div class="all-icon-circle">
             <img src="images/all-categories.png" alt="الكل" onerror="this.src='/ar/images/placeholderImage.webp'" />

             </div>
        <span>الكل(<%= ViewState["AllCount"] %>)</span>
    </a>

    <asp:Repeater ID="rptSubCategories" runat="server">
        <ItemTemplate>
            <a href="javascript:void(0);" class="category-pill"
               onclick='<%# "filterByJS(\"" + Eval("id") + "\", this)" %>'>
                <img src='<%# Eval("TypeImage") %>' onerror="this.src='/ar/images/placeholderImage.webp'" />
                      <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en" ?
                    DataBinder.Eval(Container.DataItem, "TypeNameEn" ) :
                    System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru" ?
                    DataBinder.Eval(Container.DataItem, "TypeNameRu" ) : DataBinder.Eval(Container.DataItem, "TypeNameAr" ) %>
                     (<%# Eval("TotalCount") %>)
            </a>
        </ItemTemplate>
    </asp:Repeater>
    </div>
</div>
          <div class="allAvailableShops">

            <asp:Repeater ID="rptplaces" runat="server" OnItemDataBound="rpt_ItemDataBound">
              <ItemTemplate>
                <a href='<%# "Placeshop.aspx?id=" + Eval("id") + "&addid=" + Request.QueryString["addid"] %>'
                  class='<%# "availableShop " + (Eval("IsOpened").ToString() == "0" ? "shop-closed" : "") %>'
                 data-types='<%# GetPlaceTypes(Eval("id")) %>'
                     onclick='<%# Eval("IsOpened").ToString() == "0" ? "return showClosedAlert();" : "" %>'>

                  <span class="shopRatingStars" hidden>
                    <%# Eval("Rate")%>
                  </span>
                  <div class="shop-img-wrapper" style="position: relative; width: 120px; height: 120px; flex-shrink: 0;">
                    <img src='<%# "/ar/" + Eval("PhotoPath") %>' onerror="this.src='/ar/images/placeholderImage.webp'" style="width:100%; height:100%; border-radius:0.5rem; object-fit:cover;" />
                    <div class="favorite-heart"
                         onclick="toggleFavorite(event, this)"
                         data-id='<%# Eval("id") %>'
                         data-name='<%# Eval("Name") %>'
                         data-name-en='<%# Eval("NameEn") %>'
                         data-img='<%# "/ar/" + Eval("PhotoPath") %>'
                         data-desc='<%# Eval("Description") %>'
                         data-desc-en='<%# Eval("DescriptionEn") %>'
                         data-delivery-time='<%# Eval("DeliveredTime") %>'
                         data-delivery-cost='<%# Eval("DeliveryCost", "{0:F2}") %>'
                         data-rate='<%# Eval("Rate") %>'
                         data-is-opened='<%# Eval("IsOpened") %>'
                         data-url='<%# Request.Url.PathAndQuery %>'>
                        <i class="fa-regular fa-heart"></i>
                    </div>
                  </div>

                  <div class="availableShopDesc">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                      <h3 class="availableShopName">
                          <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en" ?
                    DataBinder.Eval(Container.DataItem, "NameEn" ) :
                    System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru" ?
                    DataBinder.Eval(Container.DataItem, "NameRu" ) : DataBinder.Eval(Container.DataItem, "Name" ) %>

                      </h3>
                     <span class='<%# Eval("IsOpened").ToString() == "1" ? "status-badge open" : "status-badge closed" %>'>
    <%# Eval("IsOpened").ToString() == "1" ?
        (GetGlobalResourceObject("texts", "Open") ?? "Open") :
        (GetGlobalResourceObject("texts", "Closed") ?? "Closed") %>
</span>
                    </div>

                    <p class="shopFoods">
                      <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en" ?
                    DataBinder.Eval(Container.DataItem, "DescriptionEn" ) :
                    System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru" ?
                    DataBinder.Eval(Container.DataItem, "DescriptionRu" ) : DataBinder.Eval(Container.DataItem, "Description" ) %>

                    </p>
                    <span class="shopRating" id="shopRating" runat="server"></span>

                    <div class="shopDelivery">
                      <span class="deliveryTime">
                        <asp:Literal ID="ltReceiveIn" runat="server" Text="<%$ Resources:texts, ReceiveIn %>">
                        </asp:Literal>
                        <span class="timer">
                          <%# Eval("DeliveredTime") %>
                        </span> <%= Resources.Texts.ReceiveInMinutes %>
                      </span>
                      <span class="deliveryPayment">

                        <%= Resources.Texts.DeliveryService %>: <span class="deliveryPaymentAmount">
                           <%# Eval("DeliveryCost", "{0:F2}" ) %>
                        </span> <%= Resources.Texts.Currency %>
                      </span>
                      <!-- Hidden min order for sorting -->
                      <span class="minPay" style="display:none;">
                        <%# Eval("MinOrder") %>
                      </span>
                    </div>
                  </div>
                </a>
              </ItemTemplate>
            </asp:Repeater>



          </div>
          <!-- Hidden by default -->
          <figure id="noShopsMatched" style="display:none;text-align:center;margin-top:20px;">
            <asp:Literal ID="ltNoResults" runat="server" Text="<%$ Resources:texts, NoResults %>"></asp:Literal>
          </figure>

          <span class="shopNavBtns">
            <button id="shopNavLeft" style="display: none;"><i class="fa-solid fa-arrow-right"></i></button>

            <div id="shopNavNums"></div> <!-- This is your pagination holder -->

            <button id="shopNavRight" style="display: inline-block;"><i class="fa-solid fa-arrow-left"></i></button>
          </span>


        </figure>



      </div>



    </section>




    <!-- Add Select2 -->

  </asp:Content>
  <asp:Content ID="Content2" ContentPlaceHolderID="PageScripts" Runat="Server">
    <script src="js/selectedLocation.js?v=1.1"></script>
    <script>console.log("Places.aspx loaded with dynamic pagination logic");</script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <%--<script>
      $(function () { // shorthand for document ready
      var ddl = $('#<%= ddlAddresses.ClientID %>');
        if (ddl.length > 0) {
        ddl.select2({
        width: '100%',
        templateResult: formatAddress,
        templateSelection: formatAddress
        });
        }
        });

        function formatAddress(state) {
        if (!state.id) return state.text; // placeholder
        var parts = state.text.split('|');
        return $('<div><strong>' + parts[0] + '</strong><br /><small>' + (parts[1] || '') + '</small></div>');
        }
        </script>--%>
      <script>
function filterByJS(typeId, btn) {
    // 1. تلوين الزرار المختار
    $('.category-pill').removeClass('active');
    $(btn).addClass('active');

    // 2. الفلترة
    if (typeId === '0') {
        // لو اختار الكل اظهر كل المحلات
        $('.availableShop').fadeIn();
    } else {
        // اخفي الكل وابدأ اظهر المطابق بس
        $('.availableShop').each(function() {
            var types = $(this).attr('data-types'); // بيجيب حاجة زي "1,4"
            if (types) {
                var typesArray = types.split(',');
                if (typesArray.indexOf(typeId) !== -1) {
                    $(this).fadeIn();
                } else {
                    $(this).fadeOut();
                }
            } else {
                $(this).fadeOut();
            }
        });
    }
}

</script>
        <style>
          .select2-container--default .select2-selection--single {
            white-space: normal;
            /* يسمح بالنص المتعدد الأسطر */
            line-height: 1.2em;
            /* ارتفاع كل سطر */
            padding-top: 0.3rem;
            /* مسافة علوية */
            padding-bottom: 0.3rem;
            /* مسافة سفلية */
            display: block;
            height: 70px !important;
            /* يسمح بالالتفاف */
          }

          /* ارتفاع عناصر القائمة dropdown */
          .select2-container--default .select2-results__option {
            white-space: normal;
            line-height: 1.2em;
            padding-top: 0.3rem;
            padding-bottom: 0.3rem;
          }

          /* ارتفاع قائمة dropdown نفسها */
          .select2-container--default .select2-dropdown {
            max-height: 300px;
            overflow-y: auto;
          }

          /* شكل الحالة (مفتوح/مغلق) */
          .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: bold;
          }

          .status-badge.open {
            background-color: #d4edda;
            color: #28a745;
            /* أخضر */
          }

          .status-badge.closed {
            background-color: #f8d7da;
            color: #dc3545;
            /* أحمر */
          }

          /* تأثير المطعم المغلق (باهت شوية) */
          .shop-closed {
            opacity: 0.7;
            filter: grayscale(0.5);
            cursor: pointer;
          }
                         /* الحاوية الأساسية */
.categories-list-scroll {
    display: flex;
    overflow-x: auto;
    gap: 15px;
    padding: 10px;
    scrollbar-width: none;
}

/* العنصر نفسه - شلنا منه أي خلفيات */
.category-pill {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-decoration: none !important;
    background: none !important; /* إلغاء أي خلفية قديمة */
    border: none !important;     /* إلغاء أي إطارات قديمة */
    min-width: 70px;
}

/* الصورة هي اللي هتبقى الدائرة */
.category-pill img {
    width: 70px;
    height: 70px;
    border-radius: 50%; /* دائرة كاملة */
    object-fit: cover;
    border: 2px solid #eee; /* إطار خفيف جداً */
    padding: 2px;
    transition: all 0.3s ease;
}

/* النص */
.category-pill span {
    font-size: 12px;
    color: #333;
    font-weight: bold;
    margin-top: 5px;
}

/* حالة الـ Active - التعديل هيبقى على الصورة بس */
.category-pill.active img {
    border-color: #ffc119 !important; /* الإطار يصفر */
    border-width: 3px !important;
    transform: scale(1.1); /* تكبير بسيط للصورة */
}

.category-pill.active span {
    color: #ffc119 !important; /* النص يصفر */
}

            .availableShop {
                display: flex !important;
                gap: 1rem !important;
                padding: 1.5rem !important;
                background: white !important;
                border-radius: 1.25rem !important;
                border: 1px solid rgba(0, 0, 0, 0.1) !important;
                box-shadow: 0px 4px 15px rgba(0,0,0,0.05) !important;
                transition: all 0.3s ease !important;
                text-decoration: none !important;
                color: inherit !important;
                margin-bottom: 2rem !important;
                height: auto !important;
            }

            .shop-main-row {
                display: flex !important;
                justify-content: space-between !important;
                align-items: flex-start !important;
                gap: 2rem !important;
            }

            .shop-info-text {
                flex: 1 !important;
                display: flex !important;
                flex-direction: column !important;
                gap: 0.5rem !important;
            }

            .availableShopName {
                display: flex !important;
                align-items: center !important;
                gap: 10px !important;
                font-size: 1.5rem !important;
                font-weight: 800 !important;
                color: #222 !important;
                margin: 0 !important;
            }

            .status-badge {
                padding: 4px 12px !important;
                border-radius: 2rem !important;
                font-size: 0.75rem !important;
                font-weight: 700 !important;
                display: inline-block !important;
            }
            .status-badge.open {
                background: #e8f5e9 !important;
                color: #2e7d32 !important;
                border: 1px solid #c8e6c9 !important;
            }
            .status-badge.closed {
                background: #ffebee !important;
                color: #c62828 !important;
                border: 1px solid #ffcdd2 !important;
            }

            .shopFoods {
                font-size: 0.95rem !important;
                color: #666 !important;
                line-height: 1.6 !important;
                margin: 0 !important;
            }

            .shop-visual-part {
                display: flex !important;
                flex-direction: column !important;
                align-items: center !important;
                gap: 0.75rem !important;
            }

            .shop-img-wrapper {
                width: 130px !important;
                height: 130px !important;
                position: relative !important;
            }
            .shop-img-wrapper img {
                width: 100% !important;
                height: 100% !important;
                border-radius: 1.25rem !important;
                object-fit: cover !important;
                border: 1px solid rgba(0,0,0,0.05) !important;
            }

            .shop-details-row {
                display: flex !important;
                justify-content: space-between !important;
                align-items: center !important;
                padding-top: 1rem !important;
                border-top: 1px dashed rgba(0,0,0,0.1) !important;
                flex-wrap: wrap !important;
                gap: 1rem !important;
            }

            .shopDelivery {
                display: flex !important;
                gap: 1.5rem !important;
                font-size: 0.85rem !important;
                color: #444 !important;
                font-weight: 600 !important;
            }

            .shop-features {
                display: flex !important;
                gap: 1rem !important;
                align-items: center !important;
            }
            .feature-item {
                display: flex !important;
                align-items: center !important;
                gap: 6px !important;
                font-size: 0.8rem !important;
                color: #555 !important;
                background: #f8f9fa !important;
                padding: 6px 12px !important;
                border-radius: 0.5rem !important;
            }
            .feature-item i {
                color: #007bff !important;
            }
            .feature-item.promo {
                color: #e91e63 !important;
                background: #fdf2f8 !important;
                font-weight: 700 !important;
            }
            .feature-item.promo i {
                color: #e91e63 !important;
            }

        </style>
        <script>
          function showClosedAlert() {
            Swal.fire({
              title: 'المطعم مغلق حالياً',
              text: 'نعتذر منك، المطعم لا يستقبل طلبات في الوقت الحالي. يمكنك تصفح مطاعم أخرى مفتوحة.',
              icon: 'info',
              confirmButtonText: 'موافق',
              confirmButtonColor: '#dc3545'
            });
            return false; // يمنع الرابط من الانتقال لصفحة المنتجات
          }
        </script>
        <link href="css/css_web.css" rel="stylesheet" />
  </asp:Content>
