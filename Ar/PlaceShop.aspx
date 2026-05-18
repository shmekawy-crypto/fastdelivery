<%@ Page Title="" Language="C#" MasterPageFile="~/Ar/MasterPages/MasterPage.master" AutoEventWireup="true"
    CodeFile="PlaceShop.aspx.cs" Inherits="Ar_PlaceShop" ResponseEncoding="utf-8" ContentType="text/html" %>
    <asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    </asp:Content>

    <asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <asp:ScriptManager runat="server" ID="ScriptManager1" EnablePageMethods="true" />
        <style>
            .news-swipr {
                width: 100%;
                background: transparent;
                padding: 40px;
                height: auto;
                overflow: hidden !important;
                max-height: 350px;
            }

            #searchIconNav,
            #favIconNav {
                display: flex !important;
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

            .swal2-html-container {
                padding: 0 !important;
                overflow-x: hidden;
            }

            #navShareBtn {
                display: flex !important;
            }

            #openedShopFoods {
                padding-top: 125px;
                padding-inline: 25px;
                padding-bottom: 50px;
                position: relative;
                /* isolation: isolate; */
                margin: auto;
                max-width: 1280px !important;
                width: 100%;

                h2 {
                    display: flex;
                    padding-block: 1rem;
                    justify-content: space-between;
                    gap: 1rem;
                    align-items: start;
                    margin: 0;
                    line-height: 1.2;
                }

                #filterIcon {
                    display: none;
                }
            }


            .route {
                display: none !important;
            }

            .availableShop {
                display: flex;
                gap: 1rem;
                padding: 1.5rem;
                margin-bottom: 0.5rem;
                margin-top: 0;
                background: white;
                border-radius: 1.25rem;
                border: 1px solid rgba(0, 0, 0, 0.1);
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                text-decoration: none;
                color: inherit;

                img {
                    width: 130px;
                    height: 130px;
                    aspect-ratio: 1;
                    object-position: center;
                    object-fit: cover;
                    border: 1px solid rgba(0, 0, 0, 0.08);
                    border-radius: 1rem;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                }

                &:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
                    background: #fff;

                    .availableShopName {
                        color: var(--fd-blue);
                    }
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

            .shopPayMethods {
                display: flex;
                gap: 1rem;
                align-items: center;
                /* width: fit-content; */
                margin-top: 0.5rem;

                img {
                    width: 40px;
                    object-fit: contain;
                    height: 30px;
                    border-radius: 0 !important;
                    border: none !important;
                }
            }

            .availableShopDesc {
                display: flex;
                flex-direction: column;
            }

            .availableShopName {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                gap: 0.5rem;
            }

            .availableShopName,
            .shopFoods {
                line-height: 1.25;
                margin-bottom: 0.5rem;
                transition: var(--transition);
            }



            .shopRating {
                display: flex;
                gap: 0.25rem !important;
                font-size: 0.9rem;
                align-items: center;
                justify-content: center;

                i {
                    color: #FFD700;
                    font-size: 0.85rem;
                }

                .rating-number {
                    margin-inline-start: 4px;
                    font-weight: 700;
                    color: #444;
                    font-size: 0.95rem;
                }
            }

            .favorite-heart,
            .share-shop {
                position: absolute;
                top: 10px;
                width: 35px;
                height: 35px;
                background: rgba(255, 255, 255, 0.9);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                z-index: 10;
            }

            .favorite-heart {
                inset-inline-end: 10px;
            }

            .share-shop {
                inset-inline-end: 55px;
                /* Next to heart */
                color: var(--fd-blue);
            }

            .favorite-heart:hover,
            .share-shop:hover {
                transform: scale(1.1);
                background: #fff;
            }

            .favorite-heart i {
                font-size: 1.2rem;
                color: #ccc;
                transition: color 0.3s;
            }

            .favorite-heart.active i {
                color: #ff4d4f;
                font-weight: 900;
            }



            #shopListsOptions {
                display: none !important;
                margin-block: 25px;
                border-bottom: 1px solid rgba(0, 0, 0, 0.1);
                padding-inline: 0.5rem;
                flex-wrap: wrap;
                justify-content: space-evenly;
                gap: 1rem;
                box-sizing: border-box;
                list-style: none;

                li {
                    display: flex;
                    gap: 0.5rem;
                    text-align: center;
                    flex-basis: 25%;
                    position: relative;
                    font-weight: bold;
                    justify-content: center;
                    white-space: nowrap;
                    align-items: center;
                    cursor: pointer;
                    padding-bottom: 0.5rem;
                    transition: var(--transition);
                    font-size: 1.25rem;

                    i {
                        font-size: 1.5rem;
                        color: var(--fd-blue);
                    }

                    &:hover {
                        color: var(--fd-blue);
                    }

                }
            }



            #shopLists li.active {
                color: var(--fd-blue);
                border-color: var(--fd-blue);

                &:after {
                    content: '';
                    background-color: transparent;
                    z-index: -1;
                    border-bottom: 5px solid var(--fd-blue);
                    width: 100%;
                    height: 100%;
                    clip-path: polygon(20% 0%, 80% 0%, 100% 100%, 0% 100%);
                    position: absolute;
                    bottom: 0;
                    left: 0;
                }
            }



            #openedShopFoods {
                .inputHolder {
                    position: relative;
                    width: 100%;
                    isolation: isolate;

                    .showPassword {
                        color: #444 !important;
                    }

                    input {
                        padding: 0.5rem 1rem;
                        border-radius: 0.25rem;
                        border: 1px solid rgba(0, 0, 0, 0.1);
                        width: 100%;
                    }

                    .showPassword {
                        position: absolute;
                        left: 0;
                        top: 0;
                        height: fit-content;
                        font-size: 1.25rem;
                        bottom: 0;
                        margin: auto;
                    }
                }
            }

            #shopGrid {
                display: grid;
                grid-template-columns: 65% 30%;
                /* gap: 1rem; */
            }

            #shopFoodLists {
                display: grid;
                grid-template-columns: 30% 65%;
                gap: 1rem;
            }

            #foodListsNav {
                display: flex;
                flex-direction: column;
                position: sticky;
                max-height: 450px;
                will-change: auto;
                overflow-y: auto;
                -webkit-overflow-scrolling: touch;
                touch-action: pan-y;
                top: 100px;
                line-height: 1.2;
                height: fit-content;
                border-radius: 0.25rem;
                padding: 0.5rem;
                border: 1px solid rgba(0, 0, 0, 0.1);

                .foodNavLinks {
                    display: flex;
                    flex-direction: column;

                    a {
                        padding: 1rem 0.5rem;
                        transition: var(--transition);
                        border-right: 3px solid transparent;

                        &:hover,
                        &.active {
                            background-color: #f8f9fa;
                            color: var(--fd-blue);
                            border-right-color: var(--fd-blue);
                            font-weight: 700;
                        }
                    }
                }
            }


            #foodListsHolder {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }

            .foodListTitle {
                background-color: white;
                padding: 0.5rem;

                i {
                    transition: var(--transition);
                    cursor: pointer;

                    &:hover {
                        rotate: 180deg;

                        color: var(--fd-blue);

                    }
                }


            }

            .foodListTitle.active {
                i {
                    color: var(--fd-blue);
                    rotate: 180deg;
                }
            }

            .foodDrowdown {
                padding: 0 !important;
                display: flex;
                flex-direction: column;
                list-style: none;
                gap: 1.25rem;
                transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
                overflow: visible;
                height: auto;
                opacity: 1;
                padding-bottom: 2rem;
            }

            .foodDrowdown.active {
                /* Preserve active state if JS still toggles it */
                display: flex !important;
            }

            .foodList {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }



            .foodItem {
                display: flex;
                flex-direction: row;
                justify-content: space-between;
                align-items: stretch;
                padding: 1.25rem;
                background: #fff;
                border-radius: 1.25rem;
                border: 1px solid #f2f2f2;
                margin-bottom: 1rem;
                transition: all 0.3s ease;
                gap: 1.5rem;
                cursor: pointer;
                position: relative;
            }

            .foodItem:hover {
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                border-color: var(--fd-blue);
                transform: translateY(-3px);
            }

            .foodDetailsContainer {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                flex: 1;
                text-align: start;
                height: auto;
                padding-block: 0.75rem;
            }

            .foodText {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;

                .foodName {
                    font-size: 1rem !important;
                }
            }

            .foodName {
                font-size: 1.2rem;
                font-weight: 700;
                color: #1a1a1a;
                margin: 0;
                line-height: 1.2;
                transition: color 0.3s ease;
            }

            .foodItem:hover .foodName {
                color: var(--fd-blue);
            }

            .foodContent {
                font-size: 0.95rem;
                color: #777;
                line-height: 1.5;
                margin: 0;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .foodPricing {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                margin-top: auto;
            }

            .foodNewPrice {
                font-size: 1.15rem;
                font-weight: 800;
                color: #1a1a1a;
                white-space: nowrap;
            }

            .foodOldPrice {
                font-size: 0.95rem;
                color: #bbb;
                text-decoration: line-through;
                font-weight: 500;
                white-space: nowrap;
            }

            .foodImage {
                pointer-events: none !important;
                position: relative;
                width: 150px !important;
                height: 100% !important;
                max-width: 150px !important;
                flex-shrink: 0;
                background-color: #f8f8f8;
                padding: 0 !important;
                display: flex;
                justify-content: center;
                align-items: center;
                border-radius: 1.5rem !important;
                overflow: hidden;
                border: none !important;

            }

            .foodImage img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: inherit;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
                aspect-ratio: 1;
                position: relative;
                z-index: 1;
                background-color: #fff;
            }

            .foodItem {
                flex-direction: row-reverse !important;
                column-gap: 1.5rem !important;

                img {
                    border-radius: 1.5rem !important;
                    background-color: var(--fd-blue);
                }
            }

            .addToCart {
                position: absolute;
                bottom: 10px;
                inset-inline-start: 10px;
                display: flex;
                justify-content: center;
                align-items: center;
                height: fit-content !important;
                pointer-events: auto;
                /* Changed from none to auto */
                z-index: 2;
            }

            .addToCartBtn {
                width: 36px !important;
                height: 36px !important;
                background-color: #fff;
                color: #ff6b00;
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
                font-size: 1.4rem;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                cursor: pointer;
                pointer-events: auto;
                /* Enable clicks */
            }

            .qty-control {
                pointer-events: auto;
                /* Enable clicks */
            }

            .foodItem:hover .addToCartBtn {
                transform: scale(1.1);
                background-color: #ff6b00;
                color: #fff;
            }

            @media (max-width: 480px) {
                .foodText {
                    pointer-events: none;
                }

                .shopRating {
                    .rating-number {
                        font-size: 0.8rem;
                    }
                }

                /* .icon-btn{
                    width: 36px !important;
                    height: 36px !important;
                    font-size: 16px !important;
                } */
                .lang-btn {
                    /* font-size: 14px !important; */
                    padding: 10px !important;
                }




                .foodDrowdown {
                    display: grid !important;
                    grid-template-columns: repeat(2, 1fr) !important;
                    gap: 10px !important;
                    padding-inline: 5px !important;
                    height: auto !important;
                    opacity: 1 !important;
                    /* overflow: visible !important; */
                }

                .foodDrowdown {
                    padding-inline: 0px !important;
                }

                #openedShopFoods {
                    padding-inline: 1rem !important;
                    padding-top: 100px !important;
                }

                .foodItem {
                    flex-direction: column-reverse !important;
                    padding: 0px !important;
                    gap: 0.5rem !important;
                    margin-bottom: 0 !important;
                    border-radius: 1rem !important;
                    height: 100% !important;
                    align-items: stretch !important;
                    display: flex !important;
                }

                .foodImage {
                    width: 100% !important;
                    height: auto !important;
                    max-width: 100% !important;
                    aspect-ratio: 1 !important;
                }

                .foodImage img {
                    border-radius: 0.75rem !important;
                    height: 100% !important;
                    width: 100% !important;
                    object-fit: cover !important;
                }

                .foodDetailsContainer {
                    padding: 0.5rem !important;
                    gap: 4px !important;
                    height: auto !important;
                    flex: 1 !important;
                    pointer-events: none;
                }

                .foodText,
                .foodName {
                    flex: 1;
                }

                .foodText {
                    pointer-events: none;

                    .foodName {
                        font-size: 0.8rem !important;
                        display: -webkit-box !important;
                        -webkit-line-clamp: 2 !important;
                        -webkit-box-orient: vertical !important;
                        overflow: hidden !important;
                        line-height: 1.5 !important;
                    }
                }

                .foodContent {
                    font-size: 0.7rem !important;
                    -webkit-line-clamp: 2 !important;
                    display: -webkit-box !important;
                    -webkit-box-orient: vertical !important;
                    overflow: hidden !important;
                    min-height: 2.4em !important;
                    margin: 0 !important;
                    line-height: 1.5 !important;
                }

                .foodPricing {
                    margin-top: 4px !important;
                    gap: 4px !important;
                    justify-content: flex-start !important;
                }

                .foodNewPrice {
                    font-size: 0.9rem !important;
                }

                .foodOldPrice {
                    font-size: 0.75rem !important;
                }

                .addToCart {
                    bottom: 5px !important;
                    inset-inline-start: 5px !important;
                }

                .addToCartBtn {
                    width: 32px !important;
                    height: 32px !important;
                    font-size: 1rem !important;
                }
            }


            #cartHolder {
                display: flex;
                flex-direction: column;
                border-radius: 0.5rem;
                overflow: hidden;
                justify-content: center;
                max-width: 600px;
                width: 100%;
                position: sticky;
                isolation: isolate;
                height: fit-content;
            }

            #closeCartBtn {
                width: fit-content;
                right: initial;
                display: none;
                left: 10px;
            }

            .shoppingCartTitle {
                background-color: var(--fd-blue);
                color: white;

                padding: 0.5rem;
            }


            #emptyCart {
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
                justify-content: center;
                border: 1px solid #fffcfc;
                border-bottom-left-radius: 1.25rem;
                border-bottom-right-radius: 1.25rem;
                align-items: center;
                text-align: center;
                background-color: #fff;
                margin-bottom: 0px !important;
                font-size: 1.1rem;
                padding: 3.5rem 2rem;
                font-weight: 600;
                color: #888;

                i {
                    font-size: 4.5rem;
                    color: #eee;
                    margin-bottom: 0.5rem;
                }
            }


            #cartShower {
                position: fixed;
                bottom: 0;
                color: white;
                left: 0;
                width: 100%;
                display: none;
                gap: 1rem;
                justify-content: space-between;
                align-items: center;
                padding: 0.5rem 1rem;
                z-index: 100;
                background-color: var(--fd-dark);

                .submit {
                    padding-block: 0.25rem;
                    margin: 0;
                }
            }

            #totalPayAmount {
                white-space: nowrap;
                font-size: 1rem;
            }

            #foodImageModal {
                width: 400px;
                height: 400px;
                background-color: white;
                border: 1px solid rgba(0, 0, 0, 0.1);
                box-shadow: var(--shadow);
                position: fixed;
                z-index: 1000;
                padding: 1rem;
                border-radius: 0.5rem;
                pointer-events: none;

                opacity: 0;
                transform: translate(0, 0);
                transition: opacity 0.2s ease, transform 0.2s ease;
            }

            #foodImageModal.show {
                opacity: 1;
                transform: translate(5px, 5px);
                /* small shift for smooth effect */
            }

            #foodImageModal img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: inherit;
            }

            #foodImageModal::after {
                content: '';
                position: absolute;
                width: 30px;
                height: 30px;
                background-color: white;
                border-top: 1px solid rgba(0, 0, 0, 0.1);
                border-right: 1px solid rgba(0, 0, 0, 0.1);
                rotate: 45deg;
                right: -16px;
                top: var(--arrow-top, 50%);
                aspect-ratio: 1;
                z-index: -1;
            }

            /* --- MODERN CLEAN CART DESIGN --- */
            #shoppingCart {
                .orderedItemsWrapper {
                    max-height: 350px;
                }

                /* Container overlay is handled in css_web.css, but we can override if needed */
            }

            #cartHolder {
                background: #fff;
                border-radius: 1.5rem;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
                max-width: 480px;
                width: 95%;
                position: relative;
                border: none;
                display: flex;
                flex-direction: column;
            }

            .shoppingCartTitle {
                font-size: 1.4rem;
                color: #222;
                margin-bottom: 1.5rem;
                text-align: center;
                border-bottom: 1px solid #fffcfc;
                padding-bottom: 1rem;
                font-weight: 800;
            }

            #closeCartBtn {
                position: absolute;
                top: 1.25rem;
                right: 1.25rem;
                font-size: 1.8rem;
                color: #bbb;
                cursor: pointer;
                transition: all 0.2s;
                line-height: 1;
                z-index: 10;
            }

            #closeCartBtn:hover {
                color: #ff4d4f;
                transform: rotate(90deg);
            }

            .orderedItemsWrapper {
                /* max-height: 450px; */
                overflow-y: auto;
                overflow-x: auto;
                margin-bottom: 1.5rem;
                display: flex;
                flex-direction: column;
                gap: 8px;
                -webkit-overflow-scrolling: touch;
            }

            /* Custom Scrollbar */
            .orderedItemsWrapper::-webkit-scrollbar {
                width: 5px;
            }

            .orderedItemsWrapper::-webkit-scrollbar-track {
                background: #f9f9f9;
            }

            .orderedItemsWrapper::-webkit-scrollbar-thumb {
                background: #ddd;
                border-radius: 10px;
            }

            .cartShopLabel {
                background-color: #f8f9fa;
                padding: 10px 14px;
                margin: 1rem 0;
                border-radius: 12px;
                font-weight: 700;
                font-size: 0.9rem;
                color: var(--fd-blue);
                display: flex;
                align-items: center;
                gap: 8px;
                border-left: 4px solid var(--fd-blue);
            }



            .orderedItem:hover {
                background: #fcfcfc;
            }

            .swiper {
                overflow: initial !important;
            }

            .orderedItemName {
                font-weight: 700;
                color: #2c3e50;
                font-size: 0.75rem !important;
                line-height: 1.4;
                text-align: initial !important;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 250px;
            }

            .totalItemPrice {
                font-weight: 800;
                color: var(--fd-blue);
                font-size: 0.8rem !important;
                white-space: nowrap;
                text-align: center;
            }

            .removeCartItem {
                color: #ccc;
                font-size: 1.1rem;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                justify-content: center;
                align-items: center;
                margin-right: 10px;
            }

            .removeCartItem:hover {
                color: #ff4d4f;
                transform: scale(1.15);
            }

            .addons-badge {
                font-size: 0.7rem;
                color: #ffc119;
                background: #fff9e6;
                padding: 1px 6px;
                border-radius: 4px;
                margin-top: 3px;
                display: flex;
                width: fit-content;
            }

            .orderedItemMain {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
                flex-direction: column;
                margin: 0 12px;
            }

            .cartItemAmountHandlers {
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 10px;
                padding: 4px;
                margin: 0;
                min-width: 85px;
                gap: 6px;
            }

            .increase,
            .decrease {
                display: flex;
                justify-content: center;
                align-items: center;
                width: 26px;
                height: 26px;
                border: none;
                background: var(--fd-blue);
                color: #fff;
                cursor: pointer;
                border-radius: 7px;
                transition: all 0.2s;
                font-size: 0.8rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                padding: 0;
            }

            .increase:hover,
            .decrease:hover {
                background: var(--fd-blue);
                color: #fff;
            }

            .itemAmount {
                min-width: 26px;
                text-align: center;
                font-weight: 800;
                font-size: 0.9rem;
                color: #222;
            }

            /* --- Cart Summary --- */
            #inCartItems {
                background: #fafbfc;
                border-radius: 1.25rem;
                margin-bottom: 0px !important;
                padding: 1rem !important;
                padding-top: 0px !important;
                display: flex;
                flex-direction: column;
                gap: 0 !important;
            }

            .preDeliveryFeeAmount,
            .deliveryAmount,
            .afterDeliveryFeeAmount {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 0.95rem;
            }

            .preDeliveryFeeAmount p,
            .deliveryAmount p {
                color: #777;
                font-weight: 500;
                margin: 0;
            }

            .subtotalAmount,
            .deliveryFee {
                font-weight: 700;
                color: #444;
            }

            .afterDeliveryFeeAmount {
                margin-top: 5px;
                padding-top: 12px;
                border-top: 1px dashed #ddd;
            }

            .afterDeliveryFeeAmount p {
                font-size: 1.1rem;
                font-weight: 700;
                color: #222;
                margin: 0;
            }

            .totalAmount {
                font-size: 1.3rem;
                font-weight: 900;
                color: var(--fd-blue);
            }

            /* --- Actions --- */
            .confirmCartActions {
                display: flex;
                gap: 12px;
            }

            .confirmCartActions .submit {
                flex: 1;
                background: var(--fd-blue);
                color: #fff;
                height: 52px;
                border: none;
                border-radius: 14px;
                font-weight: 700;
                font-size: 1.05rem;
                cursor: pointer;
                transition: all 0.3s;
                box-shadow: 0 10px 20px rgba(255, 193, 25, 0.2);
                overflow: hidden;
            }

            .confirmCartActions .submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 24px rgba(255, 193, 25, 0.3);
                opacity: 1;
            }

            #emptyCartBtn {
                width: 40px;
                height: 40px;
                background: #fff;
                border: 1px solid #eee;
                color: #ff4d4f;
                border-radius: 14px;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 0;
                font-size: 1.25rem;
            }

            #emptyCartBtn:hover {
                background: #fff1f0;
                border-color: #ffccc7;
                transform: scale(1.05);
            }

            /* --- Empty State --- */
            #emptyCart {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 40px 20px;
                text-align: center;
            }

            #emptyCart i {
                font-size: 4.5rem;
                color: #eee;
                margin-bottom: 20px;
                filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.02));
            }

            #emptyCart p {
                color: #999;
                font-size: 1.1rem;
                font-weight: 600;
                margin: 0;
            }

            .confirmCartActions a {
                color: inherit;
                text-decoration: none;
                width: 100%;
                display: block;
            }

            /* &#1578;&#1606;&#1587;&#1610;&#1602; &#1588;&#1585;&#1610;&#1591; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1601;&#1575;&#1578; (Food Categories Bar) */
            .food-categories-mobile-bar {
                width: 100%;
                display: block;
                /* &#1604;&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1608;&#1576;&#1575;&#1610;&#1604; */
                padding: 10px 0;
                background-color: #fff;
                /* &#1582;&#1604;&#1601;&#1610;&#1577; &#1576;&#1610;&#1590;&#1575;&#1569; &#1606;&#1592;&#1610;&#1601;&#1577; */
                margin-bottom: 15px;
                box-shadow: none;
                /* &#1573;&#1586;&#1575;&#1604;&#1577; &#1575;&#1604;&#1592;&#1604; */
            }

            /* &#1581;&#1575;&#1608;&#1610;&#1577; &#1575;&#1604;&#1578;&#1605;&#1585;&#1610;&#1585; &#1575;&#1604;&#1571;&#1601;&#1602;&#1610; */
            .categories-list-scroll {
                display: flex;
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                touch-action: pan-x pan-y;
                gap: 20px;
                /* &#1605;&#1587;&#1575;&#1601;&#1577; &#1571;&#1603;&#1576;&#1585; &#1576;&#1610;&#1606; &#1575;&#1604;&#1603;&#1604;&#1605;&#1575;&#1578; */
                padding: 0 15px;
                justify-content: flex-start;
                /* &#1578;&#1585;&#1578;&#1610;&#1576; &#1575;&#1604;&#1593;&#1606;&#1575;&#1589;&#1585; &#1605;&#1606; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577; */
            }

            /* 2. &#1578;&#1606;&#1587;&#1610;&#1602; &#1593;&#1606;&#1589;&#1585; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1601; (&#1575;&#1604;&#1603;&#1604;&#1605;&#1577; &#1601;&#1602;&#1591;) */
            .category-pill {
                /* &#1571;&#1604;&#1594;&#1610;&#1606;&#1575; Flexbox &#1607;&#1606;&#1575; &#1604;&#1571;&#1606;&#1606;&#1575; &#1604;&#1575; &#1606;&#1581;&#1578;&#1575;&#1580; &#1604;&#1578;&#1585;&#1578;&#1610;&#1576; &#1575;&#1604;&#1589;&#1608;&#1585;&#1577; &#1608;&#1575;&#1604;&#1606;&#1589; */
                display: inline-block;
                padding: 5px 0;
                /* &#1605;&#1587;&#1575;&#1601;&#1577; &#1581;&#1608;&#1604; &#1575;&#1604;&#1606;&#1589; (&#1571;&#1593;&#1604;&#1609; &#1608;&#1571;&#1587;&#1601;&#1604;) */
                color: #888;
                /* &#1604;&#1608;&#1606; &#1585;&#1605;&#1575;&#1583;&#1610; &#1582;&#1601;&#1610;&#1601; &#1604;&#1604;&#1606;&#1589; &#1594;&#1610;&#1585; &#1575;&#1604;&#1606;&#1588;&#1591; */
                text-decoration: none;
                font-size: 16px;
                font-weight: 500;
                white-space: nowrap;
                /* &#1605;&#1606;&#1593; &#1575;&#1604;&#1606;&#1589; &#1605;&#1606; &#1575;&#1604;&#1606;&#1586;&#1608;&#1604; &#1604;&#1587;&#1591;&#1585; &#1580;&#1583;&#1610;&#1583; */
                border-radius: 0;
                /* &#1604;&#1575; &#1606;&#1581;&#1578;&#1575;&#1580; &#1604;&#1571;&#1610; &#1586;&#1608;&#1575;&#1610;&#1575; &#1605;&#1587;&#1578;&#1583;&#1610;&#1585;&#1577; */
                border: none;
                /* &#1573;&#1586;&#1575;&#1604;&#1577; &#1571;&#1610; &#1573;&#1591;&#1575;&#1585; &#1571;&#1608; &#1582;&#1604;&#1601;&#1610;&#1577; */
                transition: color 0.2s;
                flex-shrink: 0;
            }

            /* 3. ط·آ¥ط¸â€‍ط·ط›ط·آ§ط·طŒ &#1578;&#1606;&#1587;&#1610;&#1602; &#1575;&#1604;&#1589;&#1608;&#1585; &#1578;&#1605;&#1575;&#1605;&#1575;&#1611; (&#1604;&#1604;&#1578;&#1571;&#1603;&#1583;) */
            .category-pill img {
                display: none;
                /* &#1573;&#1582;&#1601;&#1575;&#1569; &#1575;&#1604;&#1589;&#1608;&#1585;&#1577; &#1578;&#1605;&#1575;&#1605;&#1575;&#1611; */
            }

            /* &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1593;&#1606;&#1589;&#1585; &#1575;&#1604;&#1606;&#1588;&#1591; */
            .category-pill.active {
                color: #ffc119;
                /* &#1604;&#1608;&#1606; &#1575;&#1604;&#1606;&#1589; &#1610;&#1589;&#1576;&#1581; &#1605;&#1605;&#1610;&#1586;&#1575;&#1611; */

                /* أ¢إ“â€¦ &#1575;&#1604;&#1571;&#1607;&#1605;: &#1573;&#1606;&#1588;&#1575;&#1569; &#1575;&#1604;&#1582;&#1591; &#1575;&#1604;&#1587;&#1601;&#1604;&#1610; */
                border-bottom: 3px solid #ffc119;
            }

            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 700;
                margin-inline-start: 12px;
                display: inline-flex;
                align-items: center;
                vertical-align: middle;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .deliveryTime i,
            .deliveryPayment i,
            .minPay i {
                font-size: 10px;
            }


            .status-badge.open {
                background-color: #ecfdf5;
                color: #059669;
                border: 1px solid #10b981;
            }

            .status-badge.closed {
                background-color: #fef2f2;
                color: #dc2626;
                border: 1px solid #ef4444;
            }

            .route {
                color: white;
            }

            #shopBanner {
                width: 100%;
                position: absolute;
                height: 333px;
                top: 0;
                right: 0;
                overflow: hidden;
                left: 0;
                border-bottom-right-radius: 1rem;
                border-bottom-left-radius: 1rem;
                z-index: -1;
                margin: auto;
            }

            #shopBanner img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            @media (max-width: 480px) {
                .logo-container {
                    display: none !important;

                }

            }
        </style>
        <script>
            // Logic consolidated in initSidebarActiveState below
        </script>
        <section id="openedShopFoods">

            <figure id="shopBanner">

                <asp:Literal ID="ltBanner" runat="server"></asp:Literal>

            </figure>

            <article id="foodImageModal">
                <img src="" alt="zoomed image">
            </article>


            <span class="route"> <a href="Default.aspx">
                    <asp:Literal ID="ltHome" runat="server" Text="<%$ Resources:texts, Home %>"></asp:Literal>
                </a> <i class="fa-solid fa-angles-left"></i>
                <asp:Literal ID="ltlocation" runat="server"></asp:Literal><i class="fa-solid fa-angles-left"></i>
                <asp:Literal ID="ltname2" runat="server"></asp:Literal>
            </span>
            <div id="placeId" hidden>0</div>
            <div id="areaId" hidden>
                <asp:Literal ID="ltareaId" runat="server"></asp:Literal>
            </div>
            <div id="userLocationId" hidden>0</div>
            <div id="deliveryFee" hidden>
                <asp:Literal ID="ltdeliveryFee" runat="server"></asp:Literal>
            </div>
            <div id="shopId" hidden>
                <asp:Literal ID="ltshopId" runat="server"></asp:Literal>
            </div>
            <div id="shopName" hidden>
                <asp:Literal ID="ltshopName" runat="server"></asp:Literal>
            </div>
            <div id="addid" hidden>
                <asp:Literal ID="ltaddid" runat="server"></asp:Literal>
            </div>

            <div id="shopAreaId" hidden>
                <asp:Literal ID="ltshopAreaId" runat="server"></asp:Literal>
            </div>
            <div id="areaDiscountPercentage" hidden>
                <asp:Literal ID="ltPercentage" runat="server"></asp:Literal>%
            </div>


            <article class="availableShop">

                <div style="position: relative;">
                    <div class="shop-img-wrapper" style="position: relative; width: 130px; height: 130px;">
                        <asp:Image ID="imgplace" runat="server" CssClass="shop-profile-img"
                            style="width:100%; height:100%; border-radius:1rem; object-fit:cover;" />
                        <div class="favorite-heart" onclick="toggleFavorite(event, this)" id="shopHeartIcon"
                            runat="server">
                            <i class="fa-regular fa-heart"></i>
                        </div>
                    </div>

                    <span class="shopRating" style="text-align:center;padding-top:5px" id="shopRating"
                        runat="server"></span>
                    <div id="isOpened" hidden>
                        <asp:Literal ID="ltIsOpened" runat="server"></asp:Literal>
                    </div>
                    <div id="rawRating" hidden>
                        <asp:Literal ID="ltRawRating" runat="server"></asp:Literal>
                    </div>
                </div>
                <div class="availableShopDesc">
                    <h3 class="availableShopName" style="display: flex; align-items: center;">
                        <span id="shopNameContent">
                            <asp:Literal ID="ltname" runat="server"></asp:Literal>
                        </span>
                        <span id="shopStatusBadge" runat="server"></span>
                    </h3>
                    <p class="shopFoods" id="shopFoodsContent">
                        <asp:Literal ID="ltDetails" runat="server"></asp:Literal>
                    </p>


                    <div class="shopDelivery">
                        <span class="deliveryTime">
                            <i class="fa-regular fa-clock"></i>
                            <asp:Literal ID="ltReceiveIn" runat="server" Text="<%$ Resources:texts, ReceiveIn %>">
                            </asp:Literal>


                            <span class="timer">
                                <asp:Literal ID="ltdeliverytime" runat="server"></asp:Literal>
                            </span>
                            <asp:Literal ID="ltReceiveInMinutes" runat="server"
                                Text="<%$ Resources:texts, ReceiveInMinutes %>"></asp:Literal>

                        </span>
                        <span class="delieveryPayment">
                            <i class="fa-solid fa-truck-fast"></i>
                            <asp:Literal ID="ltDeliveryService" runat="server"
                                Text="<%$ Resources:texts, DeliveryService %>"></asp:Literal>:&nbsp; <span
                                id="deliveryCostValue">
                                <asp:Literal ID="ltDeliveryCost" runat="server"></asp:Literal>
                            </span>
                            <asp:Literal ID="Literal1" runat="server" Text="<%$ Resources:texts, currency %>">
                            </asp:Literal>
                        </span>
                        <span class="minPay">
                            <i class="fa-solid fa-money-bill-wave"></i>
                            <asp:Literal ID="ltMinOrderText" runat="server" Text="<%$ Resources:texts, MinOrder %>">
                            </asp:Literal>:&nbsp;<asp:Literal ID="ltmincost" runat="server"></asp:Literal>
                        </span>
                    </div>

                    <div class="shopPayMethods">
                        <p class="pay-badge tracking">
                            <i class="fa-solid fa-map-location-dot"></i>
                            <asp:Literal ID="ltLiveTracking" runat="server" Text="<%$ Resources:texts, LiveTracking %>">
                            </asp:Literal>
                        </p>

                        <p class="pay-badge safe">
                            <i class="fa-solid fa-shield"></i>
                            <asp:Literal ID="ltSafeDelivery" runat="server" Text="<%$ Resources:texts, SafeDelivery %>">
                            </asp:Literal>
                        </p>

                        <p class="pay-badge free">
                            <i class="fa-solid fa-gift"></i>
                            <asp:Literal ID="ltFirstOrderFree" runat="server"
                                Text="<%$ Resources:texts, FirstOrderFree %>"></asp:Literal>
                        </p>
                    </div>

                </div>
            </article>

            <section class="news-swipr">
                <div class="swiper newsSwiper">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <img src="https://np.naukimg.com/cphoto/l45XrkFOujKTaHBdN6PUrTtURaQ/6AFPI5l/k2gAkQqVwFKHFwvhK7u32Kmseoy1Xu1tTnRJRtug8Q2lzX6Wp02NFCPzn2tkSW8b4Mm3yavA7NNZXdbZaFECMd/ZnVDpzp"
                                alt="News Image" />
                        </div>
                        <div class="swiper-slide">
                            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb_FiZTdONoWw2NWQ_hk1FBfFb3NIhiWImUA&s"
                                alt="News Image" />
                        </div>
                        <div class="swiper-slide">
                            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCL35UgrPqNPxqfmpoEq1ZFvdM7I7bz61B3w&s"
                                alt="News Image" />
                        </div>
                        <div class="swiper-slide">
                            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTx319C2Cuuz7TXEhCMHcSrpvwcLgqnO2ahzg&s"
                                alt="News Image" />
                        </div>
                    </div>
                </div>
            </section>

            <div id="shopLists">
                <ul id="shopListsOptions">
                    <li class="active">
                        <i class="fa-solid fa-utensils"></i>
                        <asp:Literal ID="ltMenu" runat="server" Text="<%$ Resources:texts, Menu %>"></asp:Literal>
                    </li>
                    <li>
                        <i class="fa-solid fa-comments"></i>
                        <asp:Literal ID="ltReviews" runat="server" Text="<%$ Resources:texts, Reviews %>"></asp:Literal>
                    </li>
                    <li>
                        <i class="fa-solid fa-circle-info"></i>
                        <asp:Literal ID="ltShopInfo" runat="server" Text="<%$ Resources:texts, ShopInfo %>">
                        </asp:Literal>
                    </li>
                </ul>


                <div class="food-categories-mobile-bar">
                    <div class="categories-list-scroll">
                        <asp:Repeater ID="FoodCategoryRepeater" runat="server">
                            <ItemTemplate>
                                <%-- &#1610;&#1605;&#1603;&#1606;&#1603;
                                    &#1575;&#1587;&#1578;&#1582;&#1583;&#1575;&#1605;
                                    &#1575;&#1604;&#1605;&#1606;&#1591;&#1602;
                                    &#1575;&#1604;&#1588;&#1585;&#1591;&#1610;
                                    &#1604;&#1578;&#1591;&#1576;&#1610;&#1602; active class &#1607;&#1606;&#1575; --%>

                                    <a href='#section-<%# Eval("id")%>' class="category-pill"
                                        data-category-id="<%# Eval(" ID") %>">

                                        <%-- &#1607;&#1584;&#1607; &#1607;&#1610;
                                            &#1575;&#1604;&#1589;&#1608;&#1585;&#1577;
                                            &#1575;&#1604;&#1605;&#1589;&#1594;&#1585;&#1577;
                                            &#1604;&#1604;&#1578;&#1589;&#1606;&#1610;&#1601; --%>
                                            <img src='<%# Eval("PhotoUrl") %>' alt='<%# Eval("Name") %>'
                                                onerror="this.src='/ar/images/placeholderImage.webp'" />
                                            <span>
                                                <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en"
                                                    ? DataBinder.Eval(Container.DataItem, "NameEn" ) :
                                                    System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru"
                                                    ? DataBinder.Eval(Container.DataItem, "NameRu" ) :
                                                    DataBinder.Eval(Container.DataItem, "Name" ) %>
                                            </span>
                                    </a>
                            </ItemTemplate>
                        </asp:Repeater>

                        <%-- &#1605;&#1579;&#1575;&#1604; &#1579;&#1575;&#1576;&#1578;: --%>
                    </div>
                </div>

                <div class="restaurant-content-wrapper">
                </div>

                <section id="shopGrid">
                    <figure id="shopFoodLists">
                        <article id="foodListsNav">
                            <h3>
                                <asp:Literal ID="ltMenuTitle" runat="server" Text="<%$ Resources:texts, MenuTitle %>">
                                </asp:Literal>
                            </h3>
                            <div class="foodNavLinks">

                                <asp:Repeater ID="rptMenu" runat="server">

                                    <ItemTemplate>
                                        <a href='#section-<%# Eval("id")%>' title='<%#
        System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName == "en"
        ? DataBinder.Eval(Container.DataItem, "NameEn")
        : System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName == "ru"
          ? DataBinder.Eval(Container.DataItem, "NameRu")
          : DataBinder.Eval(Container.DataItem, "Name")
    %>'>
                                            <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en"
                                                ? DataBinder.Eval(Container.DataItem, "NameEn" ) :
                                                System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru"
                                                ? DataBinder.Eval(Container.DataItem, "NameRu" ) :
                                                DataBinder.Eval(Container.DataItem, "Name" ) %>
                                        </a>
                                    </ItemTemplate>
                                </asp:Repeater>



                            </div>
                        </article>

                        <article id="foodListsHolder">
                            <div class="inputHolder">
                                <label for="selectedShopSearcher" class="showPassword"><i
                                        class="fa-solid fa-magnifying-glass"></i></label>
                                <input type="text" name="selectedShopSearcher" id="selectedShopSearcher"
                                    placeholder=<%=Resources.Texts.Search %>>
                            </div>




                            <asp:Repeater ID="rptCategories" runat="server"
                                OnItemDataBound="rptCategories_ItemDataBound">
                                <ItemTemplate>
                                    <div class="foodList" id='section-<%# Eval("id") %>'>
                                        <h2 class="foodListTitle active">
                                            <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en"
                                                ? DataBinder.Eval(Container.DataItem, "NameEn" ) :
                                                System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru"
                                                ? DataBinder.Eval(Container.DataItem, "NameRu" ) :
                                                DataBinder.Eval(Container.DataItem, "Name" ) %>
                                                <span style="display: none;" class="dropDownBtn"><i
                                                        class="fa-solid fa-angles-down"></i></span>
                                        </h2>

                                        <ul class="foodDrowdown">
                                            <asp:Repeater ID="rptFoodItems" runat="server">
                                                <ItemTemplate>
                                                    <li class="foodItem <%# Convert.ToBoolean(Eval(" isCustom"))
                                                        ? "custom-item" : "" %>"
                                                        id='<%# Eval("id") %>'
                                                            data-product-name='<%#
                                                                System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en"
                                                                ? Eval("NameEn") : Eval("Name") %>'
                                                                data-price='<%# Eval("NewPrice") %>'
                                                                    data-has-addons='<%# Eval("hasAddons") %>'
                                                                        data-is-custom='<%# Eval("isCustom") %>'
                                                                            onclick="handleProductClick(this, event)">
                                                                            <div class="product-qty-badge">0</div>
                                                                            <div class="foodDetailsContainer">
                                                                                <div class="foodText">
                                                                                    <h4 class="foodName">
                                                                                        <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en"
                                                                                            ?
                                                                                            DataBinder.Eval(Container.DataItem, "NameEn"
                                                                                            ) :
                                                                                            System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru"
                                                                                            ?
                                                                                            DataBinder.Eval(Container.DataItem, "NameRu"
                                                                                            ) :
                                                                                            DataBinder.Eval(Container.DataItem, "Name"
                                                                                            ) %>
                                                                                    </h4>
                                                                                    <p class="foodContent">
                                                                                        <%# System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="en"
                                                                                            ?
                                                                                            DataBinder.Eval(Container.DataItem, "DescriptionEn"
                                                                                            ) :
                                                                                            System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName=="ru"
                                                                                            ?
                                                                                            DataBinder.Eval(Container.DataItem, "DescriptionRu"
                                                                                            ) :
                                                                                            DataBinder.Eval(Container.DataItem, "Description"
                                                                                            ) %>
                                                                                    </p>
                                                                                    <%# Convert.ToInt32(Eval("PrepearMin")) > 0 ? string.Format("<small style='color: #e67e22; font-weight: bold;'><i class='fa-solid fa-utensils'></i> {0} دقيقة</small>", Eval("PrepearMin")) : "" %>
                                                                                </div>
                                                                                <div class="foodPricing">
                                                                                    <%# (Eval("OldPrice").ToString())
                                                                                        !=(Eval("NewPrice").ToString())
                                                                                        ? "<span class='foodOldPrice'>EGP"
                                                                                        +
                                                                                        Convert.ToDecimal(Eval("OldPrice")).ToString("0.##")
                                                                                        + "</span>" : "" %>
                                                                                        <span class="foodNewPrice">
                                                                                            <%# Convert.ToDecimal(Eval("NewPrice")).ToString("0.##")
                                                                                                %>
                                                                                                <%= Resources.Texts.Currency
                                                                                                    %>
                                                                                        </span>
                                                                                </div>
                                                                            </div>

                                                                            <div class="foodImage">
                                                                                <img src='<%# Eval("PhotoUrl") %>'
                                                                                    alt="food image"
                                                                                    onerror="this.src='/ar/images/placeholderImage.webp';" />
                                                                                <div class="addToCart">
                                                                                    <%# Convert.ToBoolean(Eval("isCustom"))
                                                                                        ? "<span class='addToCartBtn'><i class='fa-solid fa-angle-left'></i></span>"
                                                                                        : @"<span class='addToCartBtn'
                                                                                        onclick='handleAddToCartClick(event, this)'
                                                                                        title='" + Resources.Texts.addtocart + @"'>
                                                                                        <i class='fa fa-plus'></i>
                                                                                        </span>
                                                                                        <div class='qty-control card-qty'
                                                                                            style='display:none;'
                                                                                            onclick='event.stopPropagation()'>
                                                                                            <button
                                                                                                onclick='handleCardQty(event, this, -1)'><i
                                                                                                    class='fa-solid fa-minus'></i></button>
                                                                                            <span
                                                                                                class='qty-val'>1</span>
                                                                                            <button
                                                                                                onclick='handleCardQty(event, this, 1)'><i
                                                                                                    class='fa-solid fa-plus'></i></button>
                                                                                        </div>"
                                                                                        %>
                                                                                </div>
                                                                            </div>
                                                    </li>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </ul>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>


                        </article>
                    </figure>


                    <article id="shoppingCart">
                        <div id="cartHolder">
                            <span id="closeCartBtn" class="close"><i class="fa-solid fa-xmark"></i></span>

                            <h2 class="shoppingCartTitle">
                                <asp:Literal ID="ltShoppingCartTitle" runat="server"
                                    Text="<%$ Resources:texts, ShoppingCartTitle %>"></asp:Literal>
                            </h2>

                            <!-- Empty cart message -->
                            <figure id="emptyCart">
                                <i class="fa-solid fa-cart-shopping"></i>
                                <p>
                                    <asp:Literal ID="ltEmptyCart" runat="server"
                                        Text="<%$ Resources:texts, EmptyCartMessage %>"></asp:Literal>
                                </p>
                            </figure>

                            <!-- Cart items -->
                            <figure id="inCartItems">
                                <div class="preDeliveryFeeAmount">
                                    <p>
                                        <asp:Literal ID="ltSubtotal" runat="server"
                                            Text="<%$ Resources:texts, Subtotal %>"></asp:Literal>
                                    </p>
                                    <span class="subtotalAmount">0.00 <%= Resources.Texts.Currency %></span>
                                </div>

                                <div class="deliveryAmount">
                                    <p>
                                        <asp:Literal ID="ltDeliveryFeeText" runat="server"
                                            Text="<%$ Resources:texts, DeliveryFee %>"></asp:Literal>
                                        <i class="fa-solid fa-circle-info"></i>
                                    </p>
                                    <span class="deliveryFee">0.00 <%= Resources.Texts.Currency %></span>
                                </div>



                                <div class="afterDeliveryFeeAmount">
                                    <p>
                                        <asp:Literal ID="ltTotalAmountText" runat="server"
                                            Text="<%$ Resources:texts, TotalAmount %>"></asp:Literal>
                                    </p>
                                    <span class="totalAmount">0.00 <%= Resources.Texts.Currency %></span>
                                </div>

                                <div class="confirmCartActions">
                                    <button class="submit" type="button">
                                        <a href="checkout.aspx">
                                            <asp:Literal ID="ltCheckout" runat="server"
                                                Text="<%$ Resources:texts, Checkout %>"></asp:Literal>
                                        </a>
                                    </button>
                                    <button type="button" id="emptyCartBtn"
                                        title='<asp:Literal ID="ltEmptyCartTitle" runat="server" Text="<%$ Resources:texts, EmptyCart %>" />'
                                        aria-label='<asp:Literal ID="ltEmptyCartAria" runat="server" Text="<%$ Resources:texts, EmptyCart %>" />'>
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </figure>
                        </div>
                    </article>

                </section>
            </div>
        </section>






        <div id="cartShower">
            <h3 id="totalPayAmount">
            </h3>
            <button type="button" class="submit">
                <asp:Literal ID="ltViewCart" runat="server" Text="<%$ Resources:texts, ViewCart %>"></asp:Literal>
            </button>
        </div>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="PageScripts" Runat="Server">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <link href="css/css_web.css" rel="stylesheet" />

        <style>
            /* &#1581;&#1575;&#1608;&#1610;&#1577; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1601; - &#1580;&#1593;&#1604; &#1575;&#1604;&#1593;&#1606;&#1575;&#1589;&#1585; &#1601;&#1608;&#1602; &#1576;&#1593;&#1590;&#1607;&#1575; */
            .category-pill {
                display: flex;
                flex-direction: column;
                /* &#1604;&#1580;&#1593;&#1604; &#1575;&#1604;&#1589;&#1608;&#1585;&#1577; &#1601;&#1608;&#1602; &#1608;&#1575;&#1604;&#1603;&#1604;&#1605;&#1577; &#1578;&#1581;&#1578; */
                align-items: center;
                gap: 8px;
                /* &#1605;&#1587;&#1575;&#1601;&#1577; &#1576;&#1610;&#1606; &#1575;&#1604;&#1589;&#1608;&#1585;&#1577; &#1608;&#1575;&#1604;&#1606;&#1589; */
                padding: 10px;
                text-decoration: none;
                transition: all 0.3s ease;
                flex-shrink: 0;
                border-bottom: 3px solid transparent;
                /* &#1582;&#1591; &#1588;&#1601;&#1575;&#1601; &#1575;&#1601;&#1578;&#1585;&#1575;&#1590;&#1610;&#1575;&#1611; */
            }

            /* &#1573;&#1592;&#1607;&#1575;&#1585; &#1608;&#1578;&#1606;&#1587;&#1610;&#1602; &#1575;&#1604;&#1589;&#1608;&#1585;&#1577; */
            .category-pill img {
                display: block !important;
                /* ط·آ¥ط¸â€‍ط·ط›ط·آ§ط·طŒ &#1575;&#1604;&#1600; display: none &#1575;&#1604;&#1587;&#1575;&#1576;&#1602; */
                width: 60px;
                /* ط¸ظ¹ط¸â€¦ط¸ئ’ط¸â€ ط¸ئ’ ط·ع¾ط¸ئ’ط·آ¨ط¸ظ¹ط·آ± ط·آ£ط¸ث† ط·ع¾ط·آµط·ط›ط¸ظ¹ط·آ± ط·آ§ط¸â€‍ط·آ­ط·آ¬ط¸â€¦ */
                height: 60px;
                border-radius: 50%;
                /* &#1604;&#1580;&#1593;&#1604; &#1589;&#1608;&#1585;&#1577; &#1575;&#1604;&#1601;&#1574;&#1577; &#1583;&#1575;&#1574;&#1585;&#1610;&#1577; */
                object-fit: cover;
                background-color: #f8f8f8;
                border: 1px solid #eee;
            }

            /* &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1593;&#1606;&#1589;&#1585; &#1575;&#1604;&#1606;&#1588;&#1591; */
            .category-pill.active {
                color: #ffc119;
                border-bottom: 3px solid #ffc119;
            }

            .category-pill.active img {
                border-color: #ffc119;
                transform: scale(1.1);
                /* ط·ع¾ط¸ئ’ط·آ¨ط¸ظ¹ط·آ± ط·آ¨ط·آ³ط¸ظ¹ط·آ· ط¸â€‍ط¸â€‍ط·آµط¸ث†ط·آ±ط·آ© ط·آ§ط¸â€‍ط¸â€ ط·آ´ط·آ·ط·آ© */
            }

            /* Navbar Icons Visibility for this page only */
            .search-nav-icon,
            .fav-nav-icon {
                display: flex !important;
            }

            @media (max-width: 768px) {
                .action-buttons {
                    display: flex;
                    gap: 5px;
                }

                .icon-btn {
                    padding: 5px;
                }
            }

            @media(max-width:480px) {
                .action-buttons {
                    width: calc(100% - 88px);
                    justify-content: end;
                }
            }

            .bottom-sheet-modal {
                border-top-left-radius: 20px !important;
                border-top-right-radius: 20px !important;
                border-bottom-left-radius: 0 !important;
                border-bottom-right-radius: 0 !important;
                margin: 0 !important;
                max-height: 90vh;
                overflow: hidden;
            }

            .compact-modal-container {
                width: 100%;
                padding-bottom: env(safe-area-inset-bottom);
            }

            .compact-modal-header {
                min-height: 50px;
                padding: 15px;
                display: flex;
                justify-content: center;
                position: relative;
                background: white;
                border-top-left-radius: 20px;
                border-top-right-radius: 20px;
            }

            .compact-modal-header .handle {
                width: 40px;
                height: 4px;
                background: #ddd;
                border-radius: 2px;
            }

            .compact-close {
                position: absolute;
                right: 15px;
                top: 10px;
                background: #fffcfc;
                border: none;
                width: 30px;
                height: 30px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
            }

            .title-price-row {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 5px;
            }

            .compact-price {
                font-weight: 700;
                color: var(--fd-blue);
                font-size: 1.1rem;
            }

            /* Upsell Redesign Styles */
            .upsell-section .section-subtitle {
                font-size: 0.85rem;
                color: #666;
                margin-top: -5px;
                margin-bottom: 15px;
            }

            .upsell-card-new {
                background: transparent;
                text-align: left;
                width: 140px !important;
            }

            .upsell-img-wrapper {
                position: relative;
                width: 100%;
                aspect-ratio: 1/1;
                margin-bottom: 8px;
            }

            .upsell-img-wrapper img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 16px;
            }

            .upsell-add-btn {
                position: absolute;
                bottom: 8px;
                right: 8px;
                width: 32px;
                height: 32px;
                background: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                cursor: pointer;
                color: #ff6b00;
                font-size: 14px;
                transition: transform 0.2s;
            }

            .upsell-add-btn:active {
                transform: scale(0.9);
            }

            .upsell-info {
                display: flex;
                flex-direction: column;
                align-items: stretch;
                height: 100%;
                max-height: 45px;
            }

            .upsell-info h5 {
                font-size: 0.9rem;
                margin: 0;
                font-weight: 600;
                color: #333;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                min-height: fit-content;
                text-overflow: ellipsis;
            }

            .upsell-info p {
                font-size: 0.85rem;
                color: #666;
                margin: 2px 0 0;
                font-weight: 500;
                margin-top: auto;
            }

            .related-products-swiper {
                height: auto !important;
                padding-bottom: 10px !important;
            }

            .upsell-card-new {
                height: fit-content !important;
            }

            .upsell-card-new .qty-control {
                position: absolute;
                bottom: 8px;
                right: 8px;
                background: white;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                border-radius: 20px;
                padding: 2px 5px;
                display: none;
                align-items: center;
                gap: 5px;
                z-index: 10;
            }

            .upsell-card-new .qty-control button {
                width: 26px;
                height: 26px;
                font-size: 10px;
            }

            .upsell-card-new .upsell-badge {
                position: absolute;
                top: 8px;
                right: 8px;
                background: #ff6b00;
                color: white;
                width: 22px;
                height: 22px;
                border-radius: 50%;
                display: none;
                align-items: center;
                justify-content: center;
                font-size: 11px;
                font-weight: bold;
                z-index: 11;
                border: 2px solid white;
            }

            /* Cart Badge Styles */


            .addons-badge,
            .notes-badge {
                font-size: 0.7rem;
                padding: 3px 10px;
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                white-space: nowrap;
                font-weight: 600;
                white-space: nowrap;
                min-width: fit-content;
                cursor: pointer;
                min-height: 26px;
                transition: transform 0.2s, background 0.2s;
            }

            .addons-badge {
                background: #e7f3ff;
                color: #007bff;
                border: 1px solid #cce5ff;
            }

            .notes-badge {
                background: #fff4e5;
                color: #ff9800;
                border: 1px solid #ffe8cc;
            }

            .addons-badge.suggestion-badge {
                background: #fffdf0;
                color: #d4a017;
                white-space: nowrap;
                min-width: fit-content;
                border: 1px dashed #ffc119;
                opacity: 0.9;
            }

            .addons-badge:hover,
            .notes-badge:hover {
                transform: scale(1.05);
                background: #f0f0f0;
            }

            .cart-item-size {
                display: block;
                font-size: 0.8rem;
                color: #777;
                margin-top: 2px;
            }

            .customized-cart-item .orderedItemName {
                color: #333;
                font-weight: 600;
            }

            .checkout-item-size {
                font-size: 0.85rem;
                color: #888;
                margin-right: 5px;
            }

            .checkout-item-badges {
                display: inline-flex;
                gap: 5px;
                margin-right: 10px;
            }

            .checkout-item-badges .addons-badge,
            .checkout-item-badges .notes-badge {
                cursor: pointer;
                padding: 2px 8px;
                border-radius: 10px;
                font-size: 0.75rem;
            }

            /* Compact Modal Styles */
            .compact-modal-container {
                display: flex;
                flex-direction: column;
                height: 100%;
                background: #f8f9fa;
                text-align: right;
            }

            .compact-modal-header {
                min-height: 50px;
                padding: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                background: white;
                border-bottom: 1px solid #eee;
            }

            .handle {
                width: 40px;
                height: 4px;
                background: #ddd;
                border-radius: 2px;
            }

            .compact-close {
                position: absolute;
                inset-inline-end: 12px;
                top: 50%;
                transform: translateY(-50%);
                background: #f0f0f0;
                border: none;
                width: 32px;
                height: 32px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
            }

            .modal-content-body {
                padding: 20px;
                overflow-y: auto;
                flex: 1;
            }

            .modal-main-info {
                margin-bottom: 20px;
            }

            .title-price-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 8px;
            }

            .modal-main-info h1 {
                font-size: 1.4rem;
                font-weight: 800;
                margin: 0;
                color: #1a1a1a;
            }

            .compact-price {
                font-size: 1.1rem;
                font-weight: 700;
                color: var(--fd-blue);
            }

            .modal-desc {
                color: #666;
                font-size: 0.9rem;
                margin: 8px 0 0;
                line-height: 1.5;
            }

            .modal-section {
                margin-top: 24px;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 12px;
            }

            .section-header h3 {
                margin: 0;
                font-size: 1rem;
                font-weight: 700;
                color: #333;
            }

            .optional-badge {
                background: #eee;
                padding: 3px 10px;
                border-radius: 12px;
                font-size: 0.75rem;
                color: #777;
            }

            #product-notes {
                width: 100%;
                border: 1px solid #ddd;
                border-radius: 12px;
                padding: 12px;
                min-height: 80px;
                font-family: inherit;
                resize: none;
                font-size: 0.95rem;
                background: #fff;
            }

            .modal-footer-sticky {
                position: sticky;
                bottom: 0;
                background: white;
                flex-wrap: wrap;
                padding: 16px 20px;
                display: flex;
                justify-content: baseline;
                align-items: center;
                gap: 16px;
                border-top: 1px solid #eee;
                box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.05);
                z-index: 100;
            }

            .qty-control {
                display: flex;
                align-items: center;
                background: #f0f0f0;
                border-radius: 25px;
                padding: 4px;
                gap: 15px;
            }

            .qty-control button {
                width: 26px;
                height: 26px;
                border-radius: 50%;
                border: none;
                background: white;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                color: #333;
            }

            #modal-qty {
                font-weight: 800;
                font-size: 1rem;
                min-width: 20px;
                text-align: center;
            }

            .add-to-cart-big {
                flex: 1;
                background: var(--fd-blue);
                color: white;
                border: none;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 20px;
                font-weight: 700;
                cursor: pointer;
                transition: opacity 0.2s;
            }

            .add-to-cart-big:active {
                opacity: 0.9;
            }

            .add-to-cart-big strong {
                font-size: 0.95rem;
                background: rgba(255, 255, 255, 0.2);
                padding: 4px 10px;
                border-radius: 8px;
            }

            /* Bottom Sheet Animations */
            @keyframes slideInUpCustom {
                from {
                    transform: translateY(100%);
                }

                to {
                    transform: translateY(0);
                }
            }

            @keyframes slideOutDownCustom {
                from {
                    transform: translateY(0);
                }

                to {
                    transform: translateY(100%);
                }
            }

            .animate__slideInUpCustom {
                animation: slideInUpCustom 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .animate__slideOutDownCustom {
                animation: slideOutDownCustom 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            }

            /* Nested Upsells in Cart */
            .cart-item-group {
                background: #fff;
                border: 1px solid rgba(0, 0, 0, 0.1);
                border-radius: 1.25rem;
                margin-bottom: 1rem;
                min-height: fit-content;
                /* padding: 0.5rem; */
                transition: all 0.3s ease;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            }

            .cart-item-group:hover {
                border-color: var(--fd-blue);
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
            }

            .cart-item-group .orderedItem {
                border: none !important;
                background: transparent !important;
                margin-bottom: 0 !important;
                padding-bottom: 0.75rem !important;
            }

            .cart-item-customizations {
                padding: 8px 12px 8px 45px;
                margin-top: 2px;
                border-top: 1px dashed #eee;
                display: flex;
                flex-direction: column;
                gap: 5px;
                background: #fcfcfc;
            }

            .customization-row {
                display: flex;
                justify-content: space-between;
                font-size: 0.85rem;
                color: #777;
                align-items: center;
            }

            .customization-row span:first-child {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .customization-row span:first-child::before {
                content: "أ¢â‚¬آ¢";
                color: var(--fd-blue);
                font-weight: bold;
            }

            .cust-price {
                font-weight: 600;
                color: #444;
                font-size: 0.8rem;
            }

            .cart-nested-upsells {
                margin-top: 2px;
            }

            .upsell-cart-item {
                background: #f9f9f9 !important;
                padding-block: 8px !important;
                padding-inline: 1rem !important;
                border: none !important;
                border-right: 3px solid #ffc119 !important;
                margin-bottom: 2px !important;
                border-radius: 0 !important;
                opacity: 0.95;
                display: flex !important;
                align-items: center;
            }

            .upsell-connector {
                width: 10px;
                height: 2px;
                background: #ffc119;
                margin-left: 8px;
                opacity: 0.5;
            }

            .orderedItem.upsell-cart-item {
                padding-inline: 1rem !important;
            }

            .upsell-qty-label {
                color: #ffc119;
                font-weight: 700;
                margin-inline-start: 5px;
            }

            .removeUpsellItem {
                color: #ccc;
                cursor: pointer;
                font-size: 1rem;
                padding: 5px;
                margin-inline-start: auto;
            }

            .removeUpsellItem:hover {
                color: #ff4d4d;
            }

            .bottom-sheet-modal {
                border-bottom-left-radius: 0 !important;
                border-bottom-right-radius: 0 !important;
                max-width: 800px;
            }

            .fav-nav-icon {
                transition: all 0.3s ease !important;
            }

            .fav-nav-icon.active i,
            .favorite-heart.active i {
                color: #ff4d4f !important;
            }

            @keyframes heartPop {
                0% {
                    transform: scale(1);
                }

                50% {
                    transform: scale(1.35);
                }

                100% {
                    transform: scale(1);
                }
            }

            @keyframes heartSink {
                0% {
                    transform: scale(1);
                }

                50% {
                    transform: scale(0.7);
                }

                100% {
                    transform: scale(1);
                }
            }

            .animate-pop {
                transition: none !important;
                animation: heartPop 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) !important;
            }

            .animate-sink {
                transition: none !important;
                animation: heartSink 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) !important;
            }

            /* Cart Addon Handlers */
            .cust-handlers {
                display: flex;
                width: fit-content;
                align-items: center;
                gap: 8px;
                background: #f8f8f8;
                padding: 4px 10px;
                border-radius: 20px;
                border: 1px solid #eee;
                margin-inline-start: 10px;

            }

            .custom-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr) !important;
            }

            @media (max-width: 768px) {
                .custom-grid {
                    display: none !important;
                }
            }

            .cust-handlers button {
                width: 18px;
                height: 18px;
                border-radius: 50%;
                border: none;
                background: var(--fd-blue);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                cursor: pointer;
                color: white;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                transition: all 0.2s;
            }

            .cust-handlers button:hover {
                background: var(--fd-blue);
                color: #fff;
            }

            .cust-qty-val {
                font-weight: 800;
                font-size: 11px;
                min-width: 12px;
                text-align: center;
                color: #333;
            }

            .remove-addon-btn,
            .removeUpsellItem {
                margin-inline-start: 8px;
                color: #ddd;
                cursor: pointer;
                font-size: 0.9rem;
                transition: color 0.2s;
            }

            .remove-addon-btn:hover,
            .removeUpsellItem:hover {
                color: #ff4d4d;
            }

            .cust-row-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-grow: 1;
            }

            .customization-row {
                flex-direction: row !important;
                align-items: center !important;
                justify-content: space-between !important;
                padding: 10px 0 !important;
                border-bottom: 1px dashed #eee;
                display: flex !important;
            }

            .customization-row:last-child {
                border-bottom: none;
            }

            .compact-modal-container .swal2-textarea {
                border-radius: 15px !important;
                padding: 15px !important;
                border: 1px solid #eee !important;
                box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.02) !important;
                font-size: 0.95rem !important;
                width: 100% !important;
                box-sizing: border-box !important;
            }

            .notes-badge {
                background: #e6f3ff;
                color: #007bff;
                padding: 2px 8px;
                border-radius: 10px;
                font-size: 11px;
                cursor: pointer;
                font-weight: 600;
                margin-inline-start: 5px;
            }

            /* Modal Radio-like behavior styling removed/updated */
            .quick-card.active .check-box {
                display: none !important;
            }

            .quick-card.active {
                border-color: var(--fd-blue) !important;
                background-color: #fff9e6 !important;
            }

            .quick-qty-control {
                position: absolute;
                bottom: 8px;
                right: 8px;
                display: none;
                align-items: center;
                background: #fff;
                border: 1px solid var(--fd-blue);
                border-radius: 20px;
                padding: 2px 6px;
                gap: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                z-index: 5;
            }

            .quick-card.active .quick-qty-control {
                display: flex;
            }

            .quick-qty-control button {
                background: var(--fd-blue);
                color: #fff;
                border: none;
                width: 22px;
                height: 22px;
                border-radius: 50%;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                transition: all 0.2s;
            }

            .quick-qty-control button:hover {
                transform: scale(1.1);
                background: #ff6b00;
            }

            .quick-qty-val {
                font-weight: 700;
                font-size: 14px;
                min-width: 18px;
                text-align: center;
                color: #333;
            }
        </style>

        <script>
            let currentTriggeringProduct = null;

            function shareShop(event) {
                event.preventDefault();
                event.stopPropagation();
                if (navigator.share) {
                    navigator.share({
                        title: document.querySelector('.availableShopName').innerText,
                        url: window.location.href
                    }).catch(() => { });
                } else {
                    // Clipboard fallback
                    navigator.clipboard.writeText(window.location.href).then(() => {
                        Swal.fire({ toast: true, position: 'top-end', icon: 'success', title: 'تم نسخ الرابط', showConfirmButton: false, timer: 1500 });
                    });
                }
            }

            function openProductModal(triggerEl, productName, description = "طعم لا يقاوم محضر من أجود المكونات", isCustom = false, price = 100) {
                currentTriggeringProduct = triggerEl;
                if (isCustom) {
                    openHardcodedModal(null, productName, price, triggerEl, description);
                    return;
                }

                window.history.pushState({ modal: 'product' }, '');
                basePrice = price;
                addonsPrice = 0;
                quantity = 1;

                const modalOptions = {
                    html: `
                    <div class="compact-modal-container">
                        <div class="compact-modal-header">
                            <div class="handle"></div>
                            <button class="compact-close" onclick="Swal.close()"><i class="fa-solid fa-xmark"></i></button>
                        </div>
                        <div class="modal-content-body">
                            <div class="modal-main-info">
                                <div class="title-price-row">
                                    <h1>${productName}</h1>
                                    <span class="compact-price">${price} ج.م</span>
                                </div>
                                <p class="modal-desc">${description}</p>
                            </div>
                            <div class="modal-section">
                                <div class="section-header">
                                    <h3>ملاحظات</h3>
                                    <span class="optional-badge">اختياري</span>
                                </div>
                                <textarea id="product-notes" placeholder="أضف ملاحظاتك هنا..."></textarea>
                            </div>
                        </div>

                        <div class="modal-footer-sticky">
                            <div class="qty-control">
                                <button onclick="updateModalQty(-1)"><i class="fa-solid fa-minus"></i></button>
                                <span id="modal-qty">1</span>
                                <button onclick="updateModalQty(1)"><i class="fa-solid fa-plus"></i></button>
                            </div>
                            <button class="add-to-cart-big" onclick="submitModalCart()">
                                <span>إضافة للسلة</span>
                                <strong id="modal-total-price">${price} ج.م</strong>
                            </button>
                        </div>
                    </div>
                `,
                    showConfirmButton: false,
                    width: '100%',
                    padding: '0',
                    background: '#f8f9fa',
                    position: 'bottom',
                    customClass: { popup: 'bottom-sheet-modal' },
                    scrollbarPadding: false,
                    showClass: { popup: 'animate__animated animate__slideInUpCustom animate__faster' },
                    hideClass: { popup: 'animate__animated animate__slideOutDownCustom animate__faster' },
                    didOpen: () => { },
                    willClose: () => {
                        if (window.history.state && window.history.state.modal === 'product') {
                            window.history.back();
                        }
                    }
                };
                Swal.fire(modalOptions);
            }



            let basePrice = 0;
            let currentProductBasePrice = 130;
            let addonsPrice = 0;
            let quantity = 1;
            let currentCustomization = { size: null, extras: [], upsells: [] };

            function selectModalOption(el, totalSizePrice, sizeId) {
                const rows = el.parentElement.querySelectorAll('.option-row');
                rows.forEach(r => r.classList.remove('active'));
                el.classList.add('active');

                currentCustomization.size = {
                    id: sizeId,
                    name: el.querySelector('span').innerText,
                    price: totalSizePrice
                };
                basePrice = totalSizePrice;
                updateModalTotal();
            }
            window.openNotesModal = function (itemId, shopId) {
                const currentCart = window.cart || cart;
                const item = currentCart.items.find(i => i.id === itemId && i.shopId === shopId);
                if (!item) return;

                // Redirect to the new compact notes modal for consistency
                if (typeof openSimpleNotesModal === 'function') {
                    openSimpleNotesModal(null, item.name, item.price, item.description || '', item.id);
                }
            };


            function toggleExtra(el, price, id, name) {
                el.classList.toggle('active');
                const isAdded = el.classList.contains('active');

                if (isAdded) {
                    // Add if not already there
                    if (!currentCustomization.extras.some(x => String(x.id) === String(id))) {
                        currentCustomization.extras.push({ id: id, name: name, price: price, qty: 1 });
                    }
                } else {
                    // Remove
                    currentCustomization.extras = currentCustomization.extras.filter(x => String(x.id) !== String(id));
                }

                // UI feedback for badge and controls
                const badge = el.querySelector('.extra-badge');
                const controls = el.querySelector('.extra-qty-control');
                if (badge) {
                    badge.style.display = isAdded ? 'flex' : 'none';
                    badge.innerText = '1';
                }
                if (controls) {
                    controls.style.display = isAdded ? 'flex' : 'none';
                    const qtyVal = controls.querySelector('.extra-qty-val');
                    if (qtyVal) qtyVal.innerText = '1';
                }

                recalculateAddonsPrice();
                updateModalTotal();
            }

            function recalculateAddonsPrice() {
                let total = 0;
                if (currentCustomization.extras) {
                    currentCustomization.extras.forEach(x => {
                        total += (x.price || 0) * (x.qty || 1);
                    });
                }
                if (currentCustomization.upsells) {
                    currentCustomization.upsells.forEach(x => {
                        total += (x.price || 0) * (x.qty || 1);
                    });
                }
                addonsPrice = total;
            }

            function updateExtraQty(event, delta, price, extraId) {
                if (event) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                const extra = currentCustomization.extras.find(e => String(e.id) === String(extraId));
                if (!extra) return;

                extra.qty = (extra.qty || 1) + delta;

                if (extra.qty < 1) {
                    // Remove the extra if qty becomes 0
                    currentCustomization.extras = currentCustomization.extras.filter(e => String(e.id) !== String(extraId));
                    const row = document.querySelector(`.extra-item[data-extra-id="${extraId}"]`);
                    if (row) {
                        row.classList.remove('active');
                        const badge = row.querySelector('.extra-badge');
                        if (badge) badge.style.display = 'none';
                        const controls = row.querySelector('.extra-qty-control');
                        if (controls) controls.style.display = 'none';
                    }
                } else {
                    // Update display
                    const row = document.querySelector(`.extra-item[data-extra-id="${extraId}"]`);
                    if (row) {
                        const badge = row.querySelector('.extra-badge');
                        if (badge) {
                            badge.innerText = extra.qty;
                            badge.style.display = 'flex';
                        }
                        const qtyVal = row.querySelector('.extra-qty-val');
                        if (qtyVal) qtyVal.innerText = extra.qty;
                    }
                }

                recalculateAddonsPrice();
                updateModalTotal();
            }

            function updateModalQty(delta) {
                quantity = Math.max(1, quantity + delta);
                const qtyEl = document.querySelector('.swal2-container #modal-qty') || document.getElementById('modal-qty');
                if (qtyEl) qtyEl.innerText = quantity;
                updateModalTotal();
            }

            function updateModalTotal() {
                const el = document.querySelector('.swal2-container #modal-total-price') || document.getElementById('modal-total-price');
                if (!el) return;

                // Check if sizes are present in the DOM (only for hardcoded customization modal)
                const hasSizes = !!(document.querySelector('.swal2-container .option-row') || document.getElementById('option-row'));

                if (hasSizes && !currentCustomization.size) {
                    el.innerHTML = 'اختار الحجم';
                    const btn = document.querySelector('.swal2-container .add-to-cart-big');
                    if (btn) btn.style.opacity = '0.5';
                    return;
                }

                const btn = document.querySelector('.swal2-container .add-to-cart-big');
                if (btn) btn.style.opacity = '1';

                const total = (basePrice * quantity) + addonsPrice;
                el.innerHTML = total.toFixed(2) + ' \u062C.\u0645';
            }

            function handleProductClick(el, event) {
                // Check if this is a custom item (like Quarter/Half Shawarma)
                const isCustom = el.classList.contains('custom-item');

                // For regular items, block modal if clicking cart buttons
                if (!isCustom) {
                    if (event.target.closest('.addToCart') || event.target.closest('.qty-control')) return;
                }
                const name = el.getAttribute('data-product-name');
                const desc = el.querySelector('.foodContent')?.innerText || '';
                const price = parseFloat(el.getAttribute('data-price')) || 100;
                openProductModal(el, name, desc, isCustom, price);
            }

            function handleAddToCartClick(event, btn) {
                event.preventDefault();
                event.stopPropagation();
                const itemEl = btn.closest('.foodItem');
                const id = itemEl.getAttribute('id');
                const name = itemEl.getAttribute('data-product-name');
                const price = parseFloat(itemEl.getAttribute('data-price'));

                const shopId = String(document.getElementById('shopId')?.innerText.trim() || '');
                if (window.cart) {
                    window.cart.addItem({
                        id, name, price,
                        shopId: shopId,
                        shopName: document.getElementById('shopNameContent')?.innerText.trim() || document.querySelector('.availableShopName')?.innerText.trim() || '',
                        deliveryTime: document.querySelector('.timer')?.innerText.trim() || '',
                        isCustomProduct: itemEl.getAttribute('data-has-addons') === '1' || itemEl.classList.contains('custom-item')
                    }, 1);
                }

                // UI Switch to Qty Control
                syncProductBadges();
            }

            function handleCardQty(event, btn, delta) {
                event.preventDefault();
                event.stopPropagation();
                const itemEl = btn.closest('.foodItem');
                const id = itemEl.getAttribute('id');
                const shopId = document.getElementById('shopId')?.innerText.trim() || '';

                if (window.cart) {
                    if (delta > 0) window.cart.increaseItem(id, shopId);
                    else window.cart.decreaseItem(id, shopId);
                }
                syncProductBadges();
            }

            function syncProductBadges() {
                if (!window.cart || !window.cart.items) return;
                const shopId = String(document.getElementById('shopId')?.innerText.trim() || '');
                const counts = {};
                window.cart.items.forEach(item => {
                    if (String(item.shopId) === shopId) {
                        // Get base ID (remove size suffix if exists)
                        const baseId = String(item.id).split('-size-')[0];
                        counts[baseId] = (counts[baseId] || 0) + item.amount;
                    }
                });

                document.querySelectorAll('.foodItem').forEach(el => {
                    const id = el.getAttribute('id');
                    const count = counts[id] || 0;

                    // Update badge
                    const badge = el.querySelector('.product-qty-badge');
                    if (badge) {
                        badge.innerText = count;
                        badge.style.display = count > 0 ? 'flex' : 'none';
                    }

                    // Update Card UI (plus button vs qty control)
                    const addBtn = el.querySelector('.addToCartBtn');
                    const qtyCtrl = el.querySelector('.card-qty');
                    const qtyVal = el.querySelector('.qty-val');

                    if (addBtn && qtyCtrl) {
                        if (count > 0 && !el.classList.contains('custom-item')) {
                            addBtn.style.display = 'none';
                            qtyCtrl.style.display = 'flex';
                            if (qtyVal) qtyVal.innerText = count;
                        } else {
                            addBtn.style.display = 'flex';
                            qtyCtrl.style.display = 'none';
                        }
                    }
                });
            }

            document.addEventListener('DOMContentLoaded', () => {
                setTimeout(syncProductBadges, 500); // Wait for cart initialization
            });

            let currentEditItem = null;

            function submitModalCart() {
                const popup = document.querySelector('.swal2-popup');
                if (!popup) {
                    Swal.close();
                    return;
                }

                const hasSizes = !!(popup.querySelector('.option-row') || document.getElementById('option-row'));
                if (hasSizes && (!currentCustomization || !currentCustomization.size)) {
                    const priceEl = popup.querySelector('#modal-total-price');
                    if (priceEl) {
                        priceEl.style.color = 'red';
                        setTimeout(() => priceEl.style.color = '', 1000);
                    }
                    return;
                }

                const productName = popup.querySelector('h1')?.innerText.split(' - ')[0] || 'Product';
                const notesEl = popup.querySelector('#product-notes') || popup.querySelector('textarea');
                const notes = notesEl?.value || '';

                const shopId = String(document.getElementById('shopId')?.innerText.trim() || '');
                const shopName = document.getElementById('shopNameContent')?.innerText.trim() || document.querySelector('.availableShopName')?.innerText.trim() || '';
                const deliveryTime = document.querySelector('.timer')?.innerText.trim() || '';

                // Unique ID based on product ID and size ID
                const baseId = currentCustomization?.baseItemId || currentTriggeringProduct?.id || (currentEditItem ? currentEditItem.id : 'custom');
                const sizeId = (currentCustomization && currentCustomization.size) ? currentCustomization.size.id : '';
                const uniqueId = baseId + (sizeId ? `-size-${sizeId}` : '');

                const isCustomProduct = !!(currentCustomization?.isCustomProduct || currentTriggeringProduct?.closest('.foodItem')?.classList.contains('custom-item') || currentTriggeringProduct?.classList.contains('custom-item') || currentEditItem?.isCustomProduct);
                const hasActualCustomizations = !!(currentCustomization && (
                    (currentCustomization.extras && currentCustomization.extras.length > 0) ||
                    (currentCustomization.upsells && currentCustomization.upsells.length > 0) ||
                    (currentCustomization.size && currentCustomization.size.id && currentCustomization.size.id !== 'size-small') ||
                    !!notes
                ));

                const mainItem = {
                    id: baseId,
                    cartItemId: uniqueId,
                    sizeId: sizeId,
                    name: productName,
                    price: basePrice,
                    productBasePrice: currentProductBasePrice,
                    isCustomProduct: isCustomProduct,
                    isCustomized: isCustomProduct || hasActualCustomizations,
                    hasActualCustomizations: hasActualCustomizations,
                    customization: isCustomProduct
                        ? {
                            size: currentCustomization?.size || null,
                            extras: currentCustomization?.extras || [],
                            upsells: currentCustomization?.upsells || [],
                            notes: notes || ''
                        }
                        : null,
                    shopId: shopId,
                    shopName: shopName,
                    deliveryTime: deliveryTime,
                    notes: notes,
                    image: popup.querySelector('.modal-banner img')?.src || ''
                };
                mainItem.hasAddons = mainItem.isCustomized;

                let addedStatus = false;
                if (window.cart) {
                    const targetShopId = mainItem.shopId || GLOBAL_shop_ID;
                    const shopExists = window.cart.items.some(i => String(i.shopId) === String(targetShopId));
                    const isSameShopEdit = currentEditItem && String(currentEditItem.shopId) === String(targetShopId);
                    const isDifferentShop = !isSameShopEdit && !shopExists && window.cart.items.length > 0;

                    if (!isDifferentShop && currentEditItem) {
                        window.cart.removeItem(currentEditItem.cartItemId || currentEditItem.id, currentEditItem.shopId);
                    }
                    addedStatus = window.cart.addItem(mainItem, quantity, !!currentEditItem);
                }

                if (addedStatus === false) return;

                // Force close current modal before showing success
                if (typeof Swal !== 'undefined') {
                    Swal.close();
                }

                setTimeout(() => {
                    if (typeof Swal !== 'undefined') {
                        Swal.fire({
                            icon: 'success',
                            title: 'تمت الإضافة بنجاح',
                            timer: 1500,
                            showConfirmButton: false,
                            toast: true,
                            position: 'top-end'
                        });
                    }
                }, 100);
            }

            function addUpsellItem(btn, price, id, name) {
                const wrapper = btn.closest('.upsell-img-wrapper');
                const qtyCtrl = wrapper.querySelector('.qty-control');
                const badge = wrapper.querySelector('.upsell-badge');

                btn.style.display = 'none';
                qtyCtrl.style.display = 'flex';
                if (badge) {
                    badge.style.display = 'flex';
                    badge.innerText = '1';
                }

                currentCustomization.upsells.push({ id: id, name: name, price: price, qty: 1 });
                addonsPrice += price;
                updateModalTotal();
            }

            function updateUpsellQty(btn, delta, price, id) {
                const container = btn.closest('.qty-control');
                const valSpan = container.querySelector('.upsell-qty-val');
                let currentQty = parseInt(valSpan.innerText);

                const newQty = Math.max(0, currentQty + delta);
                valSpan.innerText = newQty;

                // Update customization state
                const upsell = currentCustomization.upsells.find(x => x.id === id);
                if (upsell) {
                    upsell.qty = newQty;
                }

                // Update modal price
                addonsPrice += (delta * price);
                updateModalTotal();

                if (newQty === 0) {
                    currentCustomization.upsells = currentCustomization.upsells.filter(x => x.id !== id);
                    const wrapper = btn.closest('.upsell-img-wrapper');
                    wrapper.querySelector('.upsell-add-btn').style.display = 'flex';
                    wrapper.querySelector('.upsell-badge').style.display = 'none';
                    container.style.display = 'none';
                    valSpan.innerText = 1; // Reset for next time
                } else {
                    const wrapper = btn.closest('.upsell-img-wrapper');
                    const badge = wrapper.querySelector('.upsell-badge');
                    badge.innerText = newQty;
                    badge.style.display = 'flex';
                }
            }

            window.addEventListener('popstate', function () {
                if (Swal.isVisible()) {
                    Swal.close();
                }
                if (typeof closeSideCart === 'function') {
                    closeSideCart();
                }
            });

            function openSizesModal(el, name) { openProductModal(el, name); }
            function selectSwalSize(el) {
                document.querySelectorAll('.size-option').forEach(opt => opt.classList.remove('active'));
                el.classList.add('active');
            }


            function openSimpleNotesModal(el, name, price, desc = '', idOverride = null) {
                currentTriggeringProduct = el;
                currentEditItem = null;
                basePrice = parseFloat(price) || 0;
                addonsPrice = 0;
                quantity = 1;
                currentCustomization = {
                    size: null,
                    extras: [],
                    upsells: [],
                    notes: ''
                };

                const id = idOverride || el.getAttribute('id');
                const shopId = String(document.getElementById('shopId')?.innerText.trim() || '');

                // Check if already in cart to pre-populate notes
                const existingInCart = window.cart?.items.find(i => i.id === id && i.shopId === shopId);
                if (existingInCart) {
                    currentEditItem = existingInCart;
                    quantity = existingInCart.amount;
                    currentCustomization.notes = existingInCart.customization?.notes || existingInCart.notes || '';
                }

                const actualDesc = desc || el?.querySelector('.foodContent')?.innerText || '';
                const currency = 'ج.م';

                // IF ITS A CUSTOM ITEM i need the size cost instead and present the cost next to the name
                let displayPrice = price;
                if (existingInCart && existingInCart.isCustomized && existingInCart.customization?.size) {
                    displayPrice = existingInCart.customization.size.price || price;
                }

                const modalHtml = `
                <div class="compact-modal-container">
                    <div class="compact-modal-header">
                        <div class="handle"></div>
                        <button class="compact-close" onclick="event.preventDefault(); Swal.close();"><i class="fa-solid fa-xmark"></i></button>
                    </div>
                    <div class="modal-content-body">
                        <div class="modal-main-info">
                            <div class="title-price-row">
                                <h1>${name} - ${displayPrice} ${currency}</h1>
                            </div>
                            <p class="modal-desc">${actualDesc}</p>
                        </div>
                        <div class="modal-section">
                            <div class="section-header">
                                <h3>ملاحظات</h3>
                                <span class="optional-badge">اختياري</span>
                            </div>
                            <textarea id="product-notes" placeholder="أضف ملاحظاتك هنا...">${currentCustomization.notes}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer-sticky">
                        <div class="qty-control">
                            <button onclick="updateModalQty(-1)"><i class="fa-solid fa-minus"></i></button>
                            <span id="modal-qty">${quantity}</span>
                            <button onclick="updateModalQty(1)"><i class="fa-solid fa-plus"></i></button>
                        </div>
                        <button class="add-to-cart-big" onclick="submitModalCart()">
                            <span>${existingInCart ? 'حفظ' : 'إضافة للسلة'}</span>
                            <strong id="modal-total-price">${(displayPrice * quantity).toFixed(2)} ${currency}</strong>
                        </button>
                    </div>
                </div>
            `;

                Swal.fire({
                    html: modalHtml,
                    showConfirmButton: false,
                    position: 'bottom',
                    width: '100%',
                    padding: '0',
                    background: '#f8f9fa',
                    showClass: {
                        popup: 'animate__animated animate__slideInUpCustom animate__faster'
                    },
                    hideClass: {
                        popup: 'animate__animated animate__slideOutDownCustom animate__faster'
                    },
                    customClass: {
                        container: 'swal2-rtl',
                        popup: 'bottom-sheet-modal'
                    },
                    didOpen: () => {
                        updateModalTotal();
                    }
                });
            }

            function toggleFavorite(event, element) {
                if (event) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                const urlParams = new URLSearchParams(window.location.search);
                const shopId = urlParams.get('id');
                if (!shopId) return;

                let favorites = JSON.parse(localStorage.getItem('favoriteShops') || '[]');
                const index = favorites.findIndex(f => String(f.id) === String(shopId));

                if (index === -1) {
                    // Add to favorites
                    const shopData = {
                        id: shopId,
                        name: document.getElementById('shopNameContent')?.innerText.trim() || document.querySelector('.availableShopName')?.innerText.trim() || '',
                        nameEn: '',
                        img: document.querySelector('.shop-profile-img')?.src || document.querySelector('.availableShop img')?.src || '',
                        desc: document.getElementById('shopFoodsContent')?.innerText.trim() || '',
                        descEn: '',
                        deliveryTime: document.querySelector('.timer')?.innerText.trim() || '',
                        deliveryCost: document.getElementById('deliveryCostValue')?.innerText.trim() || '',
                        rate: (() => { const raw = document.getElementById('rawRating')?.innerText.trim() || document.querySelector('.shopRating .rating-number')?.innerText.trim() || '0'; return parseFloat(raw.replace(/[^\d.]/g, '')).toFixed(1); })(),
                        isOpened: document.getElementById('isOpened')?.innerText.trim() || '',
                        url: window.location.href
                    };
                    favorites.push(shopData);
                } else {
                    // Remove from favorites
                    favorites.splice(index, 1);
                }
                localStorage.setItem('favoriteShops', JSON.stringify(favorites));

                // Toast notification
                if (index === -1) {
                    Swal.fire({ toast: true, position: 'top-end', icon: 'success', title: '\u062a\u0645\u062a \u0627\u0644\u0625\u0636\u0627\u0641\u0629 \u0644\u0644\u0645\u0641\u0636\u0644\u0629', showConfirmButton: false, timer: 1500 });
                } else {
                    Swal.fire({ toast: true, position: 'top-end', icon: 'info', title: '\u062a\u0645\u062a \u0627\u0644\u0625\u0632\u0627\u0644\u0629 \u0645\u0646 \u0627\u0644\u0645\u0641\u0636\u0644\u0629', showConfirmButton: false, timer: 1500 });
                }

                // Sync other heart and animate both simultaneously
                syncAllHearts(true);
            }

            function syncAllHearts(animate = false) {
                const urlParams = new URLSearchParams(window.location.search);
                const shopId = urlParams.get('id');
                if (!shopId) return;
                const favorites = JSON.parse(localStorage.getItem('favoriteShops') || '[]');
                const isFav = favorites.some(f => String(f.id) === String(shopId));

                const hearts = [
                    document.querySelector('[id$="shopHeartIcon"]'),
                    document.getElementById('favIconNav')
                ];

                hearts.forEach(heart => {
                    if (!heart) return;
                    const icon = heart.querySelector('i');
                    const target = heart;

                    if (isFav) {
                        heart.classList.remove('is-favorite', 'active');
                        void heart.offsetWidth;
                        heart.classList.add('is-favorite', 'active');
                        if (icon) {
                            icon.classList.remove('fa-regular');
                            icon.classList.add('fa-solid');
                        }

                        if (animate) {
                            target.classList.remove('animate-pop', 'animate-sink');
                            void target.offsetWidth;
                            target.classList.add('animate-pop');
                            setTimeout(() => {
                                target.classList.remove('animate-pop');
                            }, 400);
                        }
                    } else {
                        heart.classList.remove('is-favorite', 'active');
                        if (icon) {
                            icon.classList.remove('fa-solid');
                            icon.classList.add('fa-regular');
                        }

                        if (animate) {
                            target.classList.remove('animate-pop', 'animate-sink');
                            void target.offsetWidth;
                            target.classList.add('animate-sink');
                            setTimeout(() => {
                                target.classList.remove('animate-sink');
                            }, 400);
                        }
                    }
                });
            }

            function handleNavFavorite(event, btn) {
                toggleFavorite(event, btn);
            }

            function handleNavSearch(event) {
                event.preventDefault();
                const searchInput = document.getElementById('selectedShopSearcher');
                if (searchInput) {
                    searchInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    searchInput.focus();
                }
            }

            function initFavorites() {
                syncAllHearts(false);
            }

            // Active Sidebar Styling logic with Scroll Spy
            function initSidebarActiveState() {
                const allLinks = document.querySelectorAll('.foodNavLinks a, .category-pill');
                const sections = document.querySelectorAll('.foodList');
                let isManualClick = false;
                let clickTimeout;
                let currentActiveId = null;

                function syncActiveState(id) {
                    if (!id || id === currentActiveId) return;
                    currentActiveId = id;

                    allLinks.forEach(l => l.classList.remove('active'));
                    const targetLinks = document.querySelectorAll(`.foodNavLinks a[href="#${id}"], .category-pill[href="#${id}"]`);

                    targetLinks.forEach(link => {
                        link.classList.add('active');
                    });

                    // Only update hash on manual click to avoid jumping/history pollution during scroll
                    if (history.replaceState && isManualClick) {
                        history.replaceState(null, null, '#' + id);
                    }
                }

                // Set initial state (Hash > Query Param > First Link)
                const urlParams = new URLSearchParams(window.location.search);
                const categoryIdParam = urlParams.get('categoryID');
                const hash = window.location.hash.replace('#', '');

                if (hash) {
                    syncActiveState(hash);
                } else if (categoryIdParam) {
                    syncActiveState(categoryIdParam);
                } else if (allLinks.length > 0) {
                    const firstId = allLinks[0].getAttribute('href')?.replace('#', '');
                    if (firstId) syncActiveState(firstId);
                }

                // Scroll Spy logic
                const observerOptions = {
                    root: null,
                    rootMargin: '-15% 0px -75% 0px',
                    threshold: 0
                };

                const observer = new IntersectionObserver((entries) => {
                    if (isManualClick) return;

                    // Find the entry that is most visible
                    const visibleEntries = entries.filter(e => e.isIntersecting);
                    if (visibleEntries.length > 0) {
                        // Sort by how close they are to the top
                        visibleEntries.sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
                        syncActiveState(visibleEntries[0].target.id);
                    }
                }, observerOptions);

                sections.forEach(section => observer.observe(section));

                // Click handling
                allLinks.forEach(link => {
                    link.addEventListener('click', function (e) {
                        const id = this.getAttribute('href').replace('#', '');
                        if (!id) return;

                        isManualClick = true;
                        clearTimeout(clickTimeout);

                        syncActiveState(id);

                        clickTimeout = setTimeout(() => {
                            isManualClick = false;
                        }, 800);
                    });
                });
            }

            function openHardcodedModal(editItem = null, prodName = null, prodPrice = null, triggerEl = null, prodDesc = null, focusNotes = false) {
                // This function now delegates to openProductModal to ensure we fetch real data from the database
                // instead of using the dummy hardcoded template.
                openProductModal(triggerEl || editItem?.id, editItem, focusNotes);
            }

            document.addEventListener('DOMContentLoaded', () => {
                // Override global favorites functions for PlaceShop page to ensure they sync in real-time
                window.toggleFavorite = toggleFavorite;
                window.initFavorites = initFavorites;
                window.handleNavFavorite = handleNavFavorite;
                window.handleNavSearch = handleNavSearch;

                initFavorites();
                initSidebarActiveState();

                // Show search + fav icons ONLY on PlaceShop page
                const searchIcon = document.getElementById('searchIconNav');
                const favIcon = document.getElementById('favIconNav');
                if (searchIcon) searchIcon.style.display = 'flex';
                if (favIcon) favIcon.style.display = 'flex';

                // Set page title from shop name
                const shopNameEl = document.getElementById('shopNameContent') || document.querySelector('.availableShopName');
                if (shopNameEl && shopNameEl.innerText.trim()) {
                    document.title = shopNameEl.innerText.trim();
                }
            });
        </script>
        <style>
            .swal-sizes-container {
                display: flex;
                flex-direction: column;
                gap: 10px;
                text-align: right;
            }

            .size-option {
                display: flex;
                justify-content: space-between;
                padding: 12px 15px;
                border: 1px solid #eee;
                border-radius: 10px;
                cursor: pointer;
                transition: 0.2s;
            }

            .size-option:hover {
                background: #fdfdfd;
                border-color: #ffc119;
            }

            .size-option.active {
                background: #fffdf5;
                border-color: #ffc119;
                box-shadow: 0 0 0 1px #ffc119;
            }

            /* Sidebar active styling */
            #foodListsNav {
                background: white;
                border-radius: 12px;
                overflow-x: hidden;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                border: 1px solid #eee;
                position: sticky;
                top: 140px;
            }

            #foodListsNav h3 {
                color: black;
                padding: 15px;
                margin: 0;
                font-size: 1.2rem;
                text-align: center;
                font-weight: 700;
            }

            .foodNavLinks {
                padding: 10px;
            }

            .foodNavLinks a {
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                padding: 12px 15px;
                display: flex;
                align-items: center;
                border-radius: 8px;
                margin-bottom: 5px;
                color: #555;
                text-decoration: none;
                font-size: 0.95rem;
                border: 1px solid transparent;
            }

            .foodNavLinks a:hover {
                background: #fff9e6;
                color: #ffc119;
                transform: translateX(-5px);
            }

            .swal2-popup.product-modal-popup {
                border-radius: 16px !important;
                overflow: hidden;
            }

            .full-modal-container {
                width: 100%;
                height: auto;
                max-height: 90vh;
                padding: 0;
                display: flex;
                flex-direction: column;
                background: #fff;
                position: relative;
                text-align: right;
                direction: rtl;
            }

            .modal-banner {
                position: relative;
                width: 100%;
                min-height: 225px;
                max-height: 225px;
                background: #eee;
                height: 225px;
            }

            .modal-banner img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .modal-close-btn {
                position: absolute;
                top: 15px;
                left: 15px;
                width: 40px;
                height: 40px;
                background: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                border: none;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
                cursor: pointer;
                z-index: 10;
            }

            .modal-content-body {
                flex: 1;
                overflow-y: auto;
                overflow-x: hidden;
                padding: 20px;
                padding-bottom: 0px;
            }

            .modal-main-info h1 {
                font-size: 1.5rem;
                margin-bottom: 5px;
                font-weight: 700;
            }

            .modal-desc {
                color: #777;
                font-size: 0.9rem;
                margin-bottom: 25px;
                text-align: initial;
            }

            .swal2-container {
                padding: 0;
            }

            .modal-section {
                margin-bottom: 30px;

                textarea {
                    width: 100%;
                    background-color: #fffcfc;
                    padding: 1rem;
                    border-radius: 1rem;
                    resize: none;
                    border-color: rgba(0, 0, 0, 0.1);
                    height: 150px;
                }
            }


            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
            }

            .section-header h3 {
                font-size: 1.1rem;
                font-weight: 700;
                margin: 0;
            }

            .required-badge {
                background: #fff3cd;
                color: #856404;
                font-size: 0.75rem;
                padding: 4px 8px;
                border-radius: 4px;
            }

            .optional-badge {
                background: #eee;
                color: #666;
                font-size: 0.75rem;
                padding: 4px 8px;
                border-radius: 4px;
            }

            /* Option Rows */
            .option-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid rgba(0, 0, 0, 0.1);
                cursor: pointer;
            }

            .price-radio {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .radio-circle {
                width: 20px;
                height: 20px;
                border: 2px solid #ddd;
                border-radius: 50%;
                position: relative;
            }

            .option-row.active .radio-circle {
                border-color: #ffc119;
            }

            .option-row.active .radio-circle::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 10px;
                height: 10px;
                background: #ffc119;
                border-radius: 50%;
            }

            /* Swiper Quick Cards */
            .quick-choices-swiper {
                padding: 5px 0;
                display: flex;
            }

            .quick-choices-swiper .swiper-wrapper {
                align-items: stretch;
            }

            .quick-card {
                width: 200px !important;
                height: auto;
                background: white;
                border: 1px solid rgba(0, 0, 0, 0.2);
                border-radius: 12px;
                padding: 15px;
                position: relative;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
            }

            .quick-card .check-box {
                margin-top: auto;
                align-self: flex-start;
            }

            .quick-card.active {
                border-color: #ffc119;
                background: #fffdf5;
            }

            .quick-card h4 {
                margin: 10px 0 5px;
                font-size: 0.95rem;
            }

            .quick-card-badge {
                font-size: 0.7rem;
                color: #e67e22;
                background: #fff3e0;
                padding: 2px 6px;
                border-radius: 4px;
                width: fit-content;
            }

            /* Extras List */
            .extra-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #fffcfc;
                cursor: pointer;
            }

            .check-box {
                width: 22px;
                height: 22px;
                border: 2px solid #ddd;
                border-radius: 4px;
                position: relative;
            }

            .extra-item.active .check-box,
            .quick-card.active .check-box {
                background: #ffc119;
                border-color: #ffc119;
            }

            .extra-item.active .check-box::after,
            .quick-card.active .check-box::after {
                content: '\f00c';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                color: white;
                font-size: 12px;
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }

            /* Sticky Footer */
            .modal-footer-sticky {
                position: sticky;
                bottom: 0;
                justify-content: center;
                background: white;
                flex-wrap: wrap;
                padding: 15px 20px;
                box-shadow: 0 -5px 20px rgba(0, 0, 0, 0.05);
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 15px;
                z-index: 100;
            }

            .qty-control {
                display: flex;
                align-items: center;
                gap: 15px;
                background: #f8f9fa;
                padding: 5px 15px;
                border-radius: 30px;
                border: 1px solid #eee;
            }

            .qty-control button {
                background: none;
                border: none;
                color: #ffc119;
                font-size: 1.1rem;
                cursor: pointer;
            }

            .add-to-cart-big {
                background: #ffc119;
                color: white;
                border: none;
                border-radius: 30px;
                padding: 12px 25px;
                display: flex;
                justify-content: center;
                gap: 20px;
                align-items: center;
                font-weight: 700;
                cursor: pointer;
                white-space: nowrap;
            }

            /* Upsell Cards */
            .related-products-swiper {
                padding: 10px 0;
            }

            .swiper-wrapper:has(.upsell-card) {
                max-height: 220px;
            }

            .upsell-card img {
                width: 100%;
                height: 100px;
                object-fit: cover;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;

            }

            .upsell-card {
                width: 200px !important;
                background: white;
                border: 1px solid #eee;
                border-radius: 12px;
                max-height: 220px;
                text-align: center;
                padding-bottom: 15px;
                height: 100%;
                /* Equal height */
                display: flex;
                flex-direction: column;
            }

            .upsell-card h5 {
                margin: 10px 10px 5px;
                font-size: 0.9rem;
                flex-grow: 1;
                /* Push button to bottom */
            }

            /* Swiper Slide Equal Height Fix */
            .swiper-wrapper {
                display: flex !important;
                align-items: stretch !important;
                touch-action: pan-y !important;
            }

            .swiper-slide {
                height: auto !important;
            }

            .quick-card {
                background: white;
                border: 1px solid rgba(0, 0, 0, 0.2);
                border-radius: 12px;
                padding: 15px;
                text-align: center;
                width: 200px !important;
                cursor: pointer;
                transition: all 0.2s;
                position: relative;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .upsell-card p {
                color: #ffc119;
                font-weight: 700;
                font-size: 0.85rem;
                margin-bottom: 10px;
            }

            .upsell-card button {
                background: #fff9e6;
                color: #ffc119;
                border: 1px solid #ffc119;
                border-radius: 20px;
                padding: 5px 20px;
                margin-inline: 0.5rem;
                font-size: 0.8rem;
                cursor: pointer;
                transition: all 0.2s;
            }

            .upsell-card button:hover {
                background: #ffc119;
                color: white;
            }

            /* Quantity Badge on Product Grid */
            .product-qty-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                background: #e88b0e;
                color: white;
                width: 28px;
                height: 26px;
                border-radius: 50%;
                display: none;
                /* Hidden by default */
                align-items: center;
                justify-content: center;
                font-size: 0.85rem;
                font-weight: 700;
                box-shadow: 0 2px 8px rgba(255, 193, 25, 0.4);
                z-index: 5;
                border: 2px solid white;
            }

            /* Upsell Quantity Control */
            .upsell-qty-container {
                display: none;
                /* Shown when item is added */
                align-items: center;
                justify-content: center;
                gap: 8px;
                margin-top: 5px;
            }

            .upsell-qty-btn {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                border: 1px solid #ffc119;
                background: white;
                color: #ffc119;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.7rem;
                cursor: pointer;
            }

            .upsell-qty-btn:hover {
                background: #ffc119;
                color: white;
            }

            .upsell-qty-val {
                font-size: 0.9rem;
                font-weight: 700;
                min-width: 15px;
                color: #333;
            }

            .upsell-remove-btn {
                color: #ff4d4d;
                font-size: 0.75rem;
                cursor: pointer;
                margin-top: 5px;
                display: block;
                text-decoration: underline;
            }

            /* Fix Swiper scroll blocking */
            .swiper-wrapper {
                touch-action: pan-y !important;
            }

            .related-products-swiper {
                overflow: visible !important;
            }

            /* User Edit Fix: Empty Cart Margin */
            #emptyCart {
                margin-bottom: 0px !important;
            }

            /* Shop Pay Methods Badges */
            .shopPayMethods {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .pay-badge {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                padding: 6px 10px;
                border-radius: 50px;
                font-size: 0.6rem;
                font-weight: 700;
                border: 1px solid transparent;
                transition: transform 0.2s;
                margin: 0;
            }

            .pay-badge i {
                font-size: 0.65rem;
            }

            /* Accent Colors */
            .pay-badge.tracking {
                color: #4361ee;
                background: #f0f3ff;
                border-color: #dbeafe;
            }

            .pay-badge.safe {
                color: #06d6a0;
                background: #e7fbf5;
                border-color: #cbf6eb;
            }

            .pay-badge.free {
                color: #ff2d55;
                /* Bright Pink Accent */
                background: #fff5f7;
                border-color: #ffe0e5;
            }

            .shopDelivery {
                display: flex;
                flex-wrap: wrap;
                color: #666;
            }

            .shopDelivery span {
                display: flex;
                align-items: center;
                gap: 3px;
                font-weight: 500;

                i {
                    font-size: 0.7rem;
                }
            }



            /* Mobile Full Screen Modal */
            @media (max-width: 600px) {
                #shopBanner {
                    height: 250px !important;
                }

                .swal2-container:has(.product-modal-popup) {
                    padding: 0 !important;
                }

                .swal2-popup.product-modal-popup {
                    width: 100vw !important;
                    max-width: 100vw !important;
                    height: 100dvh !important;
                    max-height: 100dvh !important;
                    border-radius: 0 !important;
                    margin: 0 !important;
                }

                .full-modal-container {
                    height: 100dvh !important;
                    max-height: 100dvh !important;
                }
            }

            /* Missing Modal Styles */
            .title-price-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 5px;
                width: 100%;
            }

            .compact-price {
                font-weight: 700;
                color: #ffc119;
                font-size: 1.2rem;
            }

            .upsell-card-new {
                width: 150px !important;
                flex-shrink: 0;
                background: white;
                border: 1px solid #eee;
                border-radius: 12px;
                padding: 10px;
                text-align: center;
            }

            .upsell-img-wrapper {
                position: relative;
                width: 100%;
                height: 100px;
                border-radius: 8px;
                overflow: hidden;
                margin-bottom: 8px;
            }

            .upsell-img-wrapper img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .upsell-badge {
                position: absolute;
                top: 5px;
                right: 5px;
                background: #ffc119;
                color: white;
                width: 22px;
                height: 22px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.75rem;
                font-weight: 800;
                z-index: 5;
                border: 1.5px solid white;
            }

            .upsell-add-btn {
                position: absolute;
                bottom: 5px;
                left: 5px;
                width: 30px;
                height: 30px;
                background: white;
                color: #ffc119;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                cursor: pointer;
                z-index: 5;
                font-size: 0.9rem;
            }

            .upsell-info h5 {
                font-size: 0.85rem;
                font-weight: 700;
                margin: 0 0 4px;
                color: #333;
            }

            .upsell-info p {
                font-size: 0.8rem;
                color: #ffc119;
                font-weight: 700;
                margin: 0;
                margin-top: auto;

            }

            .qty-control.card-qty {
                background: #f8f9fa;
                border-radius: 20px;
                padding: 2px 8px;
                gap: 10px;
            }

            .qty-control.card-qty button {
                background: var(--fd-blue);
                border: none;
                color: white;
                cursor: pointer;
                padding: 4px;
                font-size: 0.8rem;
            }
        </style>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script>
            currentCustomization = {
                baseItemId: null,
                selectedSizeId: null,
                extras: [],
                upsells: [], // أضف هذا السطر هنا
                quantity: 1,
                notes: ''
            };
            const currentLang = '<%= System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName.ToLower() %>';

            // نصوص المودال واللودر باللغات الثلاث
            const translations = {
                ar: {
                    loading: "جاري التحميل...",
                    errorTitle: "خطأ!",
                    connectionError: "حدث خطأ أثناء الاتصال بالسيرفر",
                    errorMessage: "عذراً، لم نتمكن من جلب البيانات"
                },
                en: {
                    loading: "Loading...",
                    errorTitle: "Error!",
                    connectionError: "Connection error with the server",
                    errorMessage: "Sorry, we couldn't fetch the data"
                },
                ru: {
                    loading: "Загрузка...",
                    errorTitle: "Ошибка!",
                    connectionError: "Ошибка соединения с сервером",
                    errorMessage: "К сожалению, لم نتمكن من الحصول على البيانات"
                }
            };

            // اختيار نصوص اللغة الحالية (الافتراضية هي العربية إذا لم تكن إنجليزية أو روسية)
            const t = translations[currentLang] || translations.ar;
            function openProductModal(triggerEl, arg2 = null, arg3 = null, arg4 = null, arg5 = null) {
                let editItem = null;
                let focusNotes = false;

                // Handle legacy signature: (triggerEl, name, desc, isCustom, price)
                if (typeof arg2 === 'string') {
                    focusNotes = false;
                } else {
                    // New signature: (triggerEl, editItem, focusNotes)
                    editItem = arg2;
                    focusNotes = !!arg3;
                }

                let id = (typeof triggerEl === 'object' && triggerEl !== null) ? triggerEl.getAttribute('id') : triggerEl;
                const shopId = String(document.getElementById('shopId')?.innerText.trim() || '');

                if (!editItem && id && window.cart) {
                    // Try to find the item in the cart by base ID or full ID (handling sizes)
                    editItem = window.cart.items.find(i => (String(i.id) === String(id) || String(i.id).startsWith(id + '-size-')) && String(i.shopId) === String(shopId));
                }

                // If id is not found and we have an editItem, use its ID
                if (!id && editItem) {
                    id = String(editItem.id).split('-size-')[0]; // Remove size suffix for the data fetch
                }

                currentTriggeringProduct = (typeof triggerEl === 'object') ? triggerEl : null;
                currentEditItem = editItem;

                Swal.fire({
                    title: t.loading,
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    },
                    customClass: {
                        container: currentLang === 'ar' ? 'swal2-rtl' : '' // ضبط الاتجاه للعربية
                    }
                });
                $.ajax({
                    type: "POST",
                    url: "PlaceShop.aspx/GetProductDetails",
                    data: JSON.stringify({ itemId: parseInt(id) }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        var data = res.d; // البيانات الناتجة من الـ WebMethod
                        if (data.success) {
                            renderProductModal(data, editItem, focusNotes);
                        } else {
                            alert(data.message);
                        }
                    }
                });

            }

            function renderProductModal(data, editItem = null, focusNotes = false) {
                // Initialize customization state
                const hasAvailableAddons = !!((data.sizes && data.sizes.length > 0) || (data.extras && data.extras.length > 0) || (data.upsellItems && data.upsellItems.length > 0));

                let savedSize = null;
                if (editItem) {
                    const editSizeId = editItem.customization?.size?.id || editItem.sizeId || (typeof editItem.customization?.size === 'string' || typeof editItem.customization?.size === 'number' ? editItem.customization.size : null);
                    if (editSizeId && data.sizes) {
                        const found = data.sizes.find(s => String(s.id) === String(editSizeId));
                        if (found) {
                            savedSize = { id: found.id, name: found.name, price: found.price };
                        }
                    }
                    if (!savedSize && editItem.customization?.size && typeof editItem.customization.size === 'object') {
                        savedSize = { ...editItem.customization.size };
                    }
                }

                currentCustomization = {
                    baseItemId: data.id,
                    isCustomProduct: hasAvailableAddons || editItem?.isCustomProduct,
                    selectedSizeId: savedSize?.id || null,
                    size: savedSize,
                    extras: editItem?.customization?.extras ? [...editItem.customization.extras] : [],
                    upsells: editItem?.customization?.upsells ? [...editItem.customization.upsells] : [],
                    quantity: editItem?.amount || 1,
                    notes: editItem?.customization?.notes || editItem?.notes || ''
                };

                // Initialize prices and quantity
                quantity = currentCustomization.quantity;
                currentProductBasePrice = data.price;
                basePrice = currentCustomization.size ? (currentCustomization.size.price || data.price) : data.price;
                recalculateAddonsPrice();

                // 1. Prepare Sizes HTML
                var sizesHtml = '';
                if (data.sizes && data.sizes.length > 0) {
                    data.sizes.forEach(function (size) {
                        var activeClass = (currentCustomization.size && String(currentCustomization.size.id) === String(size.id)) ? 'active' : '';
                        sizesHtml += `
                <div class="option-row ${activeClass}" data-item-id="${size.menuItemid}" data-size-id="${size.id}" onclick="selectModalOption(this, ${size.price}, '${size.id}')">
                    <span>${size.name}</span>
                    <div class="price-radio">
                        <span>${size.price} ج.م</span>
                        <div class="radio-circle"></div>
                    </div>
                </div>`;
                    });
                }

                // 2. Prepare Extras HTML (if any in data)
                var extrasHtml = '';
                if (data.extras && data.extras.length > 0) {
                    data.extras.forEach(function (ex) {
                        const existingExtra = currentCustomization.extras.find(e => String(e.id) === String(ex.id));
                        const isAdded = !!existingExtra;
                        const qty = existingExtra ? (existingExtra.qty || 1) : 1;
                        const activeClass = isAdded ? 'active' : '';

                        extrasHtml += `
                        <div class="option-row extra-item ${activeClass}" data-extra-id="${ex.id}" data-price="${ex.price}" onclick="toggleExtra(this, ${ex.price}, '${ex.id}', '${ex.name}')">
                            <div class="extra-main-info">
                                <div class="extra-badge" style="display: ${isAdded ? 'flex' : 'none'};">${qty}</div>
                                <span>${ex.name}</span>
                                <span class="extra-unit-price">+ ${ex.price} ج.م</span>
                            </div>
                            <div class="extra-actions">
                                <div class="qty-control extra-qty-control" style="display: ${isAdded ? 'flex' : 'none'};" onclick="event.stopPropagation()">
                                    <button onclick="updateExtraQty(event, -1, ${ex.price}, '${ex.id}')"><i class="fa-solid fa-minus"></i></button>
                                    <span class="extra-qty-val">${qty}</span>
                                    <button onclick="updateExtraQty(event, 1, ${ex.price}, '${ex.id}')"><i class="fa-solid fa-plus"></i></button>
                                </div>
                                <div class="price-radio">
                                    <div class="radio-circle"></div>
                                </div>
                            </div>
                        </div>`;
                    });
                }

                // 3. Prepare Upsells HTML
                var upsellHtml = '';
                if (data.upsellItems && data.upsellItems.length > 0) {
                    var upsellSlides = '';
                    data.upsellItems.forEach(function (item) {
                        const existingUpsell = currentCustomization.upsells.find(u => u.id === item.id);
                        const isAdded = !!existingUpsell;
                        const qty = existingUpsell ? existingUpsell.qty : 1;

                        upsellSlides += `
                <div class="swiper-slide upsell-card-new" data-item-id="${item.id}" data-upsell-id="${item.id}">
                    <div class="upsell-img-wrapper">
                        <div class="upsell-badge" style="display: ${isAdded ? 'flex' : 'none'};">${qty}</div>
                        <img src="${item.photoUrl || 'images/placeholderImage.webp'}" alt="${item.name}">
                        <div class="upsell-add-btn" style="display: ${isAdded ? 'none' : 'flex'};" onclick="addUpsellItem(this, ${item.price}, '${item.id}', '${item.name}')">
                            <i class="fa-solid fa-plus"></i>
                        </div>
                        <div class="qty-control" style="display: ${isAdded ? 'flex' : 'none'};" onclick="event.stopPropagation()">
                            <button onclick="updateUpsellQty(this, -1, ${item.price}, '${item.id}')"><i class="fa-solid fa-minus"></i></button>
                            <span class="upsell-qty-val">${qty}</span>
                            <button onclick="updateUpsellQty(this, 1, ${item.price}, '${item.id}')"><i class="fa-solid fa-plus"></i></button>
                        </div>
                    </div>
                    <div class="upsell-info">
                        <h5>${item.name}</h5>
                        <p>EGP ${item.price.toFixed(2)}</p>
                    </div>
                </div>`;
                    });

                    upsellHtml = `
            <div class="modal-section upsell-section">
                <div class="section-header">
                    <h3>غالباً ما يُطلب مع</h3>
                </div>
                <div class="swiper related-products-swiper">
                    <div class="swiper-wrapper">
                        ${upsellSlides}
                    </div>
                </div>
            </div>`;
                }

                // 4. Build Full Modal HTML
                var modalHtml = `
    <div class="full-modal-container">
        <div class="modal-banner">
            <img src="${data.photoUrl}" alt="${data.name}">
            <button class="modal-close-btn" onclick="Swal.close()">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="modal-content-body">
            <div class="modal-main-info">
                <div class="title-price-row">
                    <h1>${data.name}</h1>
                    <span class="compact-price" style="display:none;">${data.price} ج.م</span>
                </div>
                <p class="modal-desc">${data.description || ''}</p>
            </div>

            ${sizesHtml !== '' ? `
            <div class="modal-section">
                <div class="section-header">
                    <h3>اختار الحجم</h3>
                    <span class="required-badge">إجباري</span>
                </div>
                <div class="options-list">${sizesHtml}</div>
            </div>` : ''}

            ${extrasHtml !== '' ? `
            <div class="modal-section extras-section">
                <div class="section-header">
                    <h3>الإضافات</h3>
                    <span class="optional-badge">اختياري</span>
                </div>
                <div class="options-list">${extrasHtml}</div>
            </div>` : ''}

            ${upsellHtml}

            <div class="modal-section">
                <div class="section-header">
                    <h3>ملاحظات</h3>
                    <span class="optional-badge">اختياري</span>
                </div>
                <textarea id="product-notes" placeholder="أضف ملاحظاتك هنا...">${currentCustomization.notes}</textarea>
            </div>
        </div>

        <div class="modal-footer-sticky">
            <div class="qty-control">
                <button onclick="updateModalQty(-1)"><i class="fa-solid fa-minus"></i></button>
                <span id="modal-qty">${quantity}</span>
                <button onclick="updateModalQty(1)"><i class="fa-solid fa-plus"></i></button>
            </div>
            <button class="add-to-cart-big" onclick="submitModalCart(${data.id})">
                <span>${editItem ? 'تحديث السلة' : 'إضافة للسلة'}</span>
                <strong id="modal-total-price">...</strong>
            </button>
        </div>
    </div>`;

                // 5. Display Modal
                Swal.fire({
                    html: modalHtml,
                    showConfirmButton: false,
                    width: '500px',
                    padding: '0',
                    customClass: {
                        container: 'p-0',
                        popup: 'product-modal-popup'
                    },
                    didOpen: () => {
                        // Initialize Swipers
                        if (data.upsellItems && data.upsellItems.length > 0) {
                            new Swiper('.related-products-swiper', {
                                slidesPerView: 'auto',
                                spaceBetween: 10,
                                freeMode: true
                            });
                        }

                        // Handle focus notes
                        if (focusNotes) {
                            const notesArea = document.querySelector('.swal2-container #product-notes');
                            if (notesArea) {
                                setTimeout(() => {
                                    notesArea.focus();
                                    notesArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
                                }, 500);
                            }
                        }

                        updateModalTotal();
                    }
                });
            }

            function shareShop(e) {
                if (e) e.stopPropagation();
                const shopName = document.getElementById('shopName').innerText;
                const shopUrl = window.location.href;
                const template = texts.ShareMessage || "Order now from {0} via Fast Delivery! {1}";
                const text = template.replace('{0}', shopName).replace('{1}', shopUrl);

                if (navigator.share) {
                    navigator.share({
                        title: texts.ShareTitle || 'Fast Delivery',
                        text: text,
                        url: shopUrl,
                    }).catch(console.error);
                } else {
                    const modalHtml = `
                        <div class="share-modal" style="padding: 1rem; text-align: center;">
                            <h3 style="margin-bottom: 1.5rem;">${texts.ShareTitle || 'مشاركة المتجر'}</h3>
                            <div style="display: flex; justify-content: center; gap: 1.5rem; font-size: 2rem;">
                                <a href="https://wa.me/?text=${encodeURIComponent(text)}" target="_blank" style="color: #25D366;"><i class="fa-brands fa-whatsapp"></i></a>
                                <a href="https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shopUrl)}" target="_blank" style="color: #1877F2;"><i class="fa-brands fa-facebook"></i></a>
                                <a href="https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}" target="_blank" style="color: #1DA1F2;"><i class="fa-brands fa-twitter"></i></a>
                            </div>
                            <div style="margin-top: 1.5rem;">
                                <input type="text" value="${shopUrl}" id="shareUrlInput" readonly style="width: 100%; padding: 10px; border: 1px solid #eee; border-radius: 10px; text-align: center; margin-bottom: 10px;">
                                <button onclick="copyToClipboard('${shopUrl}')" style="background: var(--fd-blue); color: white; border: none; padding: 10px 20px; border-radius: 10px; cursor: pointer; width: 100%; font-weight: 700;">Copy Link</button>
                            </div>
                        </div>
                    `;
                    Swal.fire({
                        html: modalHtml,
                        showConfirmButton: false,
                        width: '320px',
                        padding: '10px'
                    });
                }
            }

            window.copyToClipboard = function (url) {
                navigator.clipboard.writeText(url).then(() => {
                    Swal.fire({ icon: 'success', title: 'Copied!', timer: 1500, showConfirmButton: false });
                });
            };

            document.addEventListener('DOMContentLoaded', function () {
                // Show Global Share buttons on PlaceShop page
                const desktopBtn = document.getElementById('navShareBtn');
                const mobileBtn = document.getElementById('mobileNavShare');
                if (desktopBtn) desktopBtn.style.display = 'inline-block';
                if (mobileBtn) mobileBtn.style.display = 'flex';
            });
        </script>
    </asp:Content>
