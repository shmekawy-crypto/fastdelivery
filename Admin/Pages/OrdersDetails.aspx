<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrdersDetails.aspx.cs" Inherits="Admin_Pages_OrdersDetails" %>
<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>تفاصيل الطلبات</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
</head>
<body dir="rtl">
    <style>
        .place-header {
            background-color: #f0f0f0;
            padding: 10px 15px;
            border-radius: 5px;
            margin-top: 20px;
            margin-bottom: 10px;
        }
        .place-header h5 {
            margin: 0;
        }
        .table thead th {
            background-color: #007bff;
            color: white;
        }
        .table tbody tr:nth-child(odd) {
            background-color: #f9f9f9;
        }
        .table tbody tr:nth-child(even) {
            background-color: #ffffff;
        }
        .table td, .table th {
            vertical-align: middle !important;
        }
    </style>
    <form id="form1" runat="server">
    <div class="container mt-4">
        <h3 class="mb-4">تفاصيل الطلب</h3>

    <asp:Literal ID="ltMapScript" runat="server"></asp:Literal>
        <asp:PlaceHolder ID="phPlaces" runat="server"></asp:PlaceHolder>
        <div class="mt-2">
            <asp:Label ID="lblMessage" runat="server" CssClass="text-danger"></asp:Label>
        </div>
        <div class="mb-3">
    <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-primary mb-3" Text="طباعة الصفحة" OnClientClick="window.print(); return false;" />
</div>
    </div>
        </form>    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
     <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script>
</script>
</body>
</html>
