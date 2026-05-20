using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;

public partial class Admin_Pages_OrdersDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int orderId = 0;
            // تصحيح الاستقبال هنا ليطابق الربط القادم من الجريد فيو الرئيسي (orderId) بدلاً من (id)
            if (Request.QueryString["orderId"] != null)
                int.TryParse(Request.QueryString["orderId"], out orderId);
            else if (Request.QueryString["id"] != null) // خطوة أمان إضافية لدعم كلا الاسمين
                int.TryParse(Request.QueryString["id"], out orderId);

            BindOrders(orderId);
        }
    }

    private void BindOrders(int orderId)
    {
        string connStr = ConfigurationManager.ConnectionStrings["Conn"].ConnectionString;
        DataTable dt = new DataTable();

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            // تصحيح الكويري وتحويل ربط المطاعم إلى LEFT JOIN لتفادي أي نقص في بيانات عناوين الأماكن ومطابقة أسماء الأعمدة بدقة
            string query = @"
                SELECT od.id, od.Order_id, p.Name AS Place, p.Address AS PlaceAddress, a.Name AS Area, g.Name AS Gov,
                       m.Name AS Menu, mi.Name + ' (' + sz.Name + ')' AS Item, mi.PrepearMin, od.Amount, od.Price, od.Amount * od.Price AS total,
                       u.Name AS Fname, u.Lname, addr.AddressName, addr.Mobile, addr.phone, addr.AType, 
                       addr.StreetName, addr.Build, addr.FloorNo, addr.adepartmentNo, addr.Instructions,
                       Gov_1.Name AS UGov, Areas_1.Name AS UArea, o.DeliveryCost,
                       addr.Latitude, addr.Longitude,
                       o.DeliveryMethod, o.PaymentMethod, o.WalletNumber, o.TransferPhoto, o.ContactMethod, o.ODTime,
                       ISNULL(o.CoponDiscountR, 0) AS CoponDiscountR, ISNULL(o.CoponDiscountD, 0) AS CoponDiscountD,
                       o.CoponDiscountRU, o.CoponDiscountDU,
                       (SELECT STUFF((SELECT ', ' + ex.Name + ' (عدد: ' + CAST(ISNULL(ode.Amount, 1) AS VARCHAR) + ' × ' + CAST(ode.Price AS VARCHAR) + ')'
                               FROM Order_Details_Extras ode
                               JOIN MenuItems_Extras mie ON ode.MenuItems_Extra_id = mie.id
                               JOIN Extras ex ON mie.Extra_id = ex.id
                               WHERE ode.Order_Detail_id = od.id
                               FOR XML PATH('')), 1, 2, '')) AS Extras,
                       -- جلب إجمالي سعر الإضافات للسطر الحالي لإدخالها في وعاء الحسبة المالية الصحيحة
                       ISNULL((SELECT SUM(ISNULL(ode2.Amount, 1) * ode2.Price) 
                               FROM Order_Details_Extras ode2 
                               WHERE ode2.Order_Detail_id = od.id), 0) AS ExtrasTotalTotal
                FROM Order_Details od
                INNER JOIN MenuItems_Sizes mis ON od.MenuItems_id = mis.id
                INNER JOIN MenuItems mi ON mis.MenuItems_id = mi.id
                INNER JOIN Sizes sz ON mis.Size_id = sz.id
                INNER JOIN Menus m ON mi.MenuID = m.id
                INNER JOIN Places p ON mi.PlaceID = p.id
                INNER JOIN Orders o ON od.Order_id = o.id
                INNER JOIN Addresses addr ON o.Address_id = addr.ID
                INNER JOIN Users u ON addr.UserID = u.Id
                INNER JOIN Areas AS Areas_1 ON addr.Area_id = Areas_1.id
                INNER JOIN Gov AS Gov_1 ON Areas_1.gov_id = Gov_1.id
                LEFT JOIN Areas a ON p.Areas_id = a.id
                LEFT JOIN Gov g ON a.gov_id = g.id
                WHERE od.Order_id = @OrderId";

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@OrderId", orderId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
        }

        if (dt.Rows.Count == 0)
        {
            phPlaces.Controls.Add(new Literal { Text = "<div class='alert alert-warning'>لا توجد بيانات لهذا الطلب</div>" });
            return;
        }

        // --- بيانات العميل ---
        var rowCustomer = dt.Rows[0];
        string custName = string.Format("{0} {1}", rowCustomer["Fname"], rowCustomer["Lname"]);
        string fullAddress = string.Format("{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}",
          rowCustomer["AddressName"], rowCustomer["StreetName"], rowCustomer["Build"],
          rowCustomer["FloorNo"], rowCustomer["adepartmentNo"], rowCustomer["Instructions"],
          rowCustomer["UArea"], rowCustomer["UGov"]);

        Label lblCustomer = new Label();
        lblCustomer.Text = string.Format(
          "<div class='alert alert-secondary'>" +
          "<div><strong>العميل:</strong> {0}</div>" +
          "<div><strong>الموبايل:</strong> {1}</div>" +
          "<div><strong>العنوان:</strong> {2}</div>" +
          "</div><div id='map' style='height: 300px; margin-top:10px;'></div>",
          custName, rowCustomer["Mobile"], fullAddress
        );
        phPlaces.Controls.Add(lblCustomer);

        // سكربت الخريطة
        string mapScript = string.Format(@"
            <script>
            window.onload = function() {{
                var map = L.map('map').setView([{0}, {1}], 16);
                L.tileLayer('https://{{s}}.tile.openstreetmap.org/{{z}}/{{x}}/{{y}}.png').addTo(map);
                L.marker([{0}, {1}]).addTo(map).bindPopup('<b>{2}</b>').openPopup();
            }};
            </script>", rowCustomer["Latitude"], rowCustomer["Longitude"], custName.Replace("'", "\\'"));
        ltMapScript.Text = mapScript;

        // --- التقسيم حسب المكان والعرض في GridView ---
        var grouped = dt.AsEnumerable().GroupBy(r => new {
            Place = r.Field<string>("Place"),
            Address = r.Field<string>("PlaceAddress"),
            Area = r.Field<string>("Area"),
            Gov = r.Field<string>("Gov")
        });

        decimal grandTotal = 0;

        foreach (var grp in grouped)
        {
            phPlaces.Controls.Add(new Literal
            {
                Text = string.Format("<div class='place-header'><h5><i class='fa-solid fa-shop'></i> {0} ({1})</h5></div>", grp.Key.Place, grp.Key.Area != null ? grp.Key.Area : "غير محدد")
            });

            GridValueConfigurator gv = new GridValueConfigurator();
            gv.CssClass = "table table-bordered table-hover text-center";
            gv.AutoGenerateColumns = false;
            gv.ShowFooter = true;

            // الأعمدة
            gv.Columns.Add(new BoundField { HeaderText = "الصنف", DataField = "Item" });
            gv.Columns.Add(new BoundField { HeaderText = "الكمية", DataField = "Amount" });
            gv.Columns.Add(new BoundField { HeaderText = "السعر", DataField = "Price", DataFormatString = "{0:N2} ج.م" });
            gv.Columns.Add(new BoundField { HeaderText = "إجمالي الصنف", DataField = "total", DataFormatString = "{0:N2} ج.م" });

            // تفاصيل وعواميد الإضافات بالتفصيل
            gv.Columns.Add(new BoundField { HeaderText = "تفاصيل الإضافات", DataField = "Extras", NullDisplayText = "بدون" });
            gv.Columns.Add(new BoundField { HeaderText = "إجمالي الإضافات", DataField = "ExtrasTotalTotal", DataFormatString = "{0:N2} ج.م" });

            // عمود وقت التحضير المخصص
            TemplateField prepField = new TemplateField();
            prepField.HeaderText = "وقت التحضير";
            prepField.ItemTemplate = new PrepTimeTemplate();
            gv.Columns.Add(prepField);

            DataTable dtPlace = grp.CopyToDataTable();
            gv.DataSource = dtPlace;
            gv.DataBind();

            // احتساب إجمالي الأطباق مضافاً إليها قيم إضافاتها الخاصة بها لكل مكان
            decimal totalItemsOnly = dtPlace.AsEnumerable().Sum(r => Convert.ToDecimal(r["total"]));
            decimal totalExtrasOnly = dtPlace.AsEnumerable().Sum(r => Convert.ToDecimal(r["ExtrasTotalTotal"]));
            decimal totalPerPlace = totalItemsOnly + totalExtrasOnly;

            grandTotal += totalPerPlace;

            if (gv.FooterRow != null)
            {
                gv.FooterRow.Cells[0].Text = "إجمالي المكان:";
                gv.FooterRow.Cells[3].Text = totalItemsOnly.ToString("N2") + " ج.م";
                gv.FooterRow.Cells[4].Text = "إجمالي إضافات المطعم:";
                gv.FooterRow.Cells[5].Text = totalExtrasOnly.ToString("N2") + " ج.م";

                // إضافة سطر فرعي داخل الفوتر لعرض المجموع النهائي الصافي للمطعم
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            phPlaces.Controls.Add(gv);

            // طباعة ملخص مالي منسق لكل مطعم أسفل جدوله مباشرة لبيان وضوح الحسابات
            phPlaces.Controls.Add(new Literal { Text = string.Format("<div class='text-end mb-4 px-2' style='font-size:13px;'><strong>إجمالي المطعم الحالي (شامل إضافاته): <span class='text-primary'>{0:N2} ج.م</span></strong></div>", totalPerPlace) });
        }

        // جلب قيم حقول وتفاصيل الدفع، الكوبونات والوسائل المضافة
        int deliveryMethod = rowCustomer["DeliveryMethod"] != DBNull.Value ? Convert.ToInt32(rowCustomer["DeliveryMethod"]) : 1;
        int paymentMethod = rowCustomer["PaymentMethod"] != DBNull.Value ? Convert.ToInt32(rowCustomer["PaymentMethod"]) : 1;
        int contactMethod = rowCustomer["ContactMethod"] != DBNull.Value ? Convert.ToInt32(rowCustomer["ContactMethod"]) : 1;
        string walletNumber = rowCustomer["WalletNumber"] != DBNull.Value && !string.IsNullOrEmpty(rowCustomer["WalletNumber"].ToString()) ? rowCustomer["WalletNumber"].ToString() : "-";
        string transferPhoto = rowCustomer["TransferPhoto"] != DBNull.Value ? rowCustomer["TransferPhoto"].ToString() : "";
        string odTimeStr = rowCustomer["ODTime"] != DBNull.Value ? Convert.ToDateTime(rowCustomer["ODTime"]).ToString("yyyy-MM-dd HH:mm") : "-";

        decimal deliveryCost = Convert.ToDecimal(rowCustomer["DeliveryCost"]);
        decimal coponDiscountR = Convert.ToDecimal(rowCustomer["CoponDiscountR"]);
        decimal coponDiscountD = Convert.ToDecimal(rowCustomer["CoponDiscountD"]);
        string coponDiscountRU = rowCustomer["CoponDiscountRU"] != DBNull.Value && !string.IsNullOrEmpty(rowCustomer["CoponDiscountRU"].ToString()) ? rowCustomer["CoponDiscountRU"].ToString() : "-";
        string coponDiscountDU = rowCustomer["CoponDiscountDU"] != DBNull.Value && !string.IsNullOrEmpty(rowCustomer["CoponDiscountDU"].ToString()) ? rowCustomer["CoponDiscountDU"].ToString() : "-";

        // الحسبة المالية الدقيقة شاملة الكوبونات بنسب مئوية وطرحها من الأوعية المخصصة لها
        decimal restaurantDiscountAmount = grandTotal * (coponDiscountR / 100.0m);
        decimal totalAfterRestaurantDiscount = grandTotal - restaurantDiscountAmount;

        decimal deliveryDiscountAmount = deliveryCost * (coponDiscountD / 100.0m);
        decimal deliveryCostAfterDiscount = deliveryCost - deliveryDiscountAmount;

        decimal netFinalAmount = totalAfterRestaurantDiscount + deliveryCostAfterDiscount;

        // دمج وعرض لوحة تفاصيل الدفع والكوبونات والصافي المطلوب برمجياً أسفل الجداول
        string paymentAndSummaryHtml = string.Format(@"
            <div class='row mt-4'>
                <div class='col-md-6'>
                    <div class='card mb-3'>
                        <div class='card-header bg-primary text-white'><h5><i class='fa fa-credit-card'></i> تفاصيل الاستلام والدفع الإلكتروني</h5></div>
                        <div class='card-body' style='font-size:13px; line-height:1.6; text-align:right;'>
                            <p><strong>وسيلة الاستلام:</strong> {0}</p>
                            <p><strong>طريقة الدفع:</strong> {1}</p>
                            <p><strong>طريقة التواصل المفضلة:</strong> {2}</p>
                            <p><strong>ميعاد الاستلام المحدد:</strong> {3}</p>
                            <p><strong>رقم المحفظة / الحساب (إن وجد):</strong> <span class='text-primary fw-bold'>{4}</span></p>
                            {5}
                        </div>
                    </div>
                </div>
                <div class='col-md-6'>
                    <div class='card mb-3'>
                        <div class='card-header bg-success text-white'><h5><i class='fa fa-calculator'></i> الخلاصة المالية الشاملة</h5></div>
                        <div class='card-body'>
                            <table class='table table-borderless mb-0' style='font-size:13px; direction:rtl;'>
                                <tr><td>إجمالي الأصناف والإضافات:</td><td class='text-end'>{6:N2} ج.م</td></tr>
                                <tr><td>كوبون خصم المطعم ({7}):</td><td class='text-end text-danger'>-{8:N2} ج.م ({9}%)</td></tr>
                                <tr class='border-top'><td><strong>صافي الأصناف بعد الخصم:</strong></td><td class='text-end'><strong>{10:N2} ج.م</strong></td></tr>
                                <tr><td>مصاريف خدمة التوصيل:</td><td class='text-end'>{11:N2} ج.م</td></tr>
                                <tr><td>كوبون خصم التوصيل ({12}):</td><td class='text-end text-danger'>-{13:N2} ج.م ({14}%)</td></tr>
                                <tr class='border-top'><td>خدمة التوصيل الصافية:</td><td class='text-end'>{15:N2} ج.m</td></tr>
                                <tr class='table-success border-top' style='font-size:1.1rem; font-weight:bold;'><td>الصافي النهائي المطلوب سداده:</td><td class='text-end text-success'>{16:N2} ج.م</td></tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>",
            GetDeliveryMethodName(deliveryMethod),
            GetPaymentMethodName(paymentMethod),
            GetContactMethodName(contactMethod),
            odTimeStr,
            walletNumber,
            !string.IsNullOrEmpty(transferPhoto) ? string.Format("<div class='mt-2'><strong>صورة إيصال التحويل:</strong><br/><a href='../../{0}' target='_blank'><img src='../../{0}' class='img-thumbnail mt-1' style='max-width:180px; max-height:200px;' /></a></div>", transferPhoto) : "<p><strong>صورة الإيصال:</strong> <span class='text-muted'>لا يوجد إيصال مرفق.</span></p>",
            grandTotal,
            coponDiscountRU,
            restaurantDiscountAmount,
            coponDiscountR,
            totalAfterRestaurantDiscount,
            deliveryCost,
            coponDiscountDU,
            deliveryDiscountAmount,
            coponDiscountD,
            deliveryCostAfterDiscount,
            netFinalAmount
        );

        phPlaces.Controls.Add(new Literal { Text = paymentAndSummaryHtml });
    }

    public string GetDeliveryMethodName(int methodId)
    {
        if (methodId == 2) return "استلام من المطعم (تيك اواي)";
        return "توصيل للمنزل (دليفري)";
    }

    public string GetPaymentMethodName(int paymentId)
    {
        switch (paymentId)
        {
            case 1: return "كاش عند الاستلام";
            case 2: return "محفظة إلكترونية (فودافون كاش / اتصالات ...)";
            case 3: return "انستا باي (InstaPay)";
            case 4: return "الدفع من خلال المحفظة الخاصة بالبرنامج";
            default: return "كاش عند الاستلام";
        }
    }

    public string GetContactMethodName(int contactId)
    {
        if (contactId == 2) return "تحدث عبر الواتساب";
        return "اتصال هاتفي مباشر";
    }
}

// كلاس لتنسيق عرض وقت التحضير داخل الـ GridView
public class PrepTimeTemplate : ITemplate
{
    public void InstantiateIn(Control container)
    {
        Literal lit = new Literal();
        lit.DataBinding += (sender, e) => {
            var row = (DataRowView)((GridViewRow)lit.NamingContainer).DataItem;
            int mins = row["PrepearMin"] != DBNull.Value ? Convert.ToInt32(row["PrepearMin"]) : 0;

            if (mins > 0)
            {
                lit.Text = string.Format(
                  "<span style='color: #e67e22; font-weight: bold;'><i class='fa-solid fa-clock-rotate-left'></i> {0} دقيقة</span>",
                  mins);
            }
            else
            {
                lit.Text = "<span class='text-muted'>---</span>";
            }
        };
        container.Controls.Add(lit);
    }
}

// كلاس مساعد لتسهيل إعداد الـ GridView برمجياً
public class GridValueConfigurator : GridView { }