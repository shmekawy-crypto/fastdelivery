<%@ Page Title="لوحة التحكم" Language="C#" MasterPageFile="~/Places/MasterPages/Site.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Places_MasterPages_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .stat-card { border-radius: 15px; color: white; padding: 25px; text-align: center; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); position: relative; overflow: hidden; }
        .stat-card i { position: absolute; right: -10px; bottom: -10px; font-size: 5rem; opacity: 0.2; }
        .chart-container { background: white; border-radius: 15px; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .section-title { font-weight: bold; color: #2c3e50; border-right: 5px solid #e67e22; padding-right: 15px; margin-bottom: 20px; }
    </style>

    <div class="container-fluid">
        <h2 class="page-header" style="font-weight:bold; color:#2c3e50;">
            <i class="fa fa-dashboard"></i> إحصائيات الأداء - <asp:Label ID="lblPlaceName" runat="server" />
        </h2>

        <div class="row">
            <div class="col-md-4">
                <div class="stat-card" style="background: #3498db;">
                    <h4>إجمالي المبيعات</h4>
                    <h2 style="font-weight:bold;"><asp:Label ID="lblTotalSales" runat="server" Text="0" /> ج.م</h2>
                    <i class="fa fa-money"></i>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: #27ae60;">
                    <h4>إجمالي الطلبات المقبولة</h4>
                    <h2 style="font-weight:bold;"><asp:Label ID="lblTotalOrders" runat="server" Text="0" /> طلب</h2>
                    <i class="fa fa-shopping-cart"></i>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card" style="background: #f1c40f;">
                    <h4>عدد أصناف المنيو</h4>
                    <h2 style="font-weight:bold;"><asp:Label ID="lblMenuCount" runat="server" Text="0" /> صنف</h2>
                    <i class="fa fa-list"></i>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="chart-container">
                    <h4 class="section-title">حجم المبيعات (آخر 7 أيام)</h4>
                    <canvas id="salesChart" height="150"></canvas>
                </div>
            </div>
            <div class="col-md-4">
                <div class="chart-container">
                    <h4 class="section-title">الأصناف الأكثر طلباً</h4>
                    <canvas id="topItemsPie" height="300"></canvas>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="chart-container">
                    <h4 class="section-title">نسبة المبيعات حسب المنطقة (%)</h4>
                    <div style="max-width: 400px; margin: 0 auto;">
                        <canvas id="regionPieChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="chart-container">
                    <h4 class="section-title">تفاصيل مبيعات المناطق</h4>
                    <asp:GridView ID="gvRegionStats" runat="server" CssClass="table table-hover" AutoGenerateColumns="false" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="RegionName" HeaderText="المنطقة" />
                            <asp:BoundField DataField="TotalSales" HeaderText="المبيعات" DataFormatString="{0:N0}" />
                            <asp:TemplateField HeaderText="النسبة">
                                <ItemTemplate>
                                    <span class="label label-info" style="font-size: 13px;"><%# Eval("Percentage") %>%</span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="chart-container">
                    <h4 class="section-title">أداء الأصناف بالتفصيل</h4>
                    <asp:GridView ID="gvItemsStats" runat="server" CssClass="table table-striped" AutoGenerateColumns="false" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="ItemName" HeaderText="اسم الصنف" />
                            <asp:BoundField DataField="QuantitySold" HeaderText="الكمية المباعة" />
                            <asp:BoundField DataField="TotalRevenue" HeaderText="إجمالي الدخل" DataFormatString="{0:N2} ج.م" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfSalesData" runat="server" Value="[0,0,0,0,0,0,0]" />
    <asp:HiddenField ID="hfTopItemsLabels" runat="server" Value="[]" />
    <asp:HiddenField ID="hfTopItemsValues" runat="server" Value="[]" />
    <asp:HiddenField ID="hfRegionLabels" runat="server" Value="[]" />
    <asp:HiddenField ID="hfRegionValues" runat="server" Value="[]" />

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 1. Line Chart
            var salesCtx = document.getElementById('salesChart').getContext('2d');
            new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'],
                    datasets: [{
                        label: 'المبيعات اليومية',
                        data: <%= hfSalesData.Value %>,
                        borderColor: '#3498db',
                        backgroundColor: 'rgba(52, 152, 219, 0.1)',
                        fill: true, tension: 0.4
                    }]
                }
            });

            // 2. Top Items
            var pieCtx = document.getElementById('topItemsPie').getContext('2d');
            new Chart(pieCtx, {
                type: 'doughnut',
                data: {
                    labels: <%= hfTopItemsLabels.Value %>,
                    datasets: [{
                        data: <%= hfTopItemsValues.Value %>,
                        backgroundColor: ['#e74c3c', '#2ecc71', '#f1c40f', '#3498db', '#9b59b6']
                    }]
                }
            });

            // 3. Regions Chart
            var regionCtx = document.getElementById('regionPieChart').getContext('2d');
            new Chart(regionCtx, {
                type: 'pie',
                data: {
                    labels: <%= hfRegionLabels.Value %>,
                    datasets: [{
                        data: <%= hfRegionValues.Value %>,
                        backgroundColor: ['#1abc9c', '#34495e', '#d35400', '#27ae60', '#2980b9']
                    }]
                }
            });
        });
    </script>
</asp:Content>