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
            if (Request.QueryString["id"] != null)
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

            // أضفنا mi.PrepearMin في الاستعلام
            string query = @"
                SELECT od.id, od.Order_id, p.Name AS Place, p.Address AS PlaceAddress, a.Name AS Area, g.Name AS Gov,
                       m.Name AS Menu, mi.Name AS Item, mi.PrepearMin, od.Amount, od.Price, od.Amount * od.Price AS total,
                       u.Name AS Fname, u.Lname, addr.AddressName, addr.Mobile, addr.phone, addr.AType, 
                       addr.StreetName, addr.Build, addr.FloorNo, addr.adepartmentNo, addr.Instructions,
                       Gov_1.Name AS UGov, Areas_1.Name AS UArea, o.DeliveryCost,
                       addr.Latitude, addr.Longitude
                FROM Order_Details od
                INNER JOIN MenuItems mi ON od.MenuItems_id = mi.id
                INNER JOIN Menus m ON mi.MenuID = m.id
                INNER JOIN Places p ON mi.PlaceID = p.id
                INNER JOIN Areas a ON p.Areas_id = a.id
                INNER JOIN Gov g ON a.gov_id = g.id
                INNER JOIN Orders o ON od.Order_id = o.id
                INNER JOIN Addresses addr ON o.Address_id = addr.ID
                INNER JOIN Users u ON addr.UserID = u.Id
                INNER JOIN Areas AS Areas_1 ON addr.Area_id = Areas_1.id
                INNER JOIN Gov AS Gov_1 ON Areas_1.gov_id = Gov_1.id
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
                Text = string.Format("<div class='mt-4'><h5><i class='fa-solid fa-shop'></i> {0} ({1})</h5></div>", grp.Key.Place, grp.Key.Area)
            });

            GridView gv = new GridValueConfigurator();
            gv.CssClass = "table table-bordered table-hover";
            gv.AutoGenerateColumns = false;
            gv.ShowFooter = true;

            // الأعمدة
            gv.Columns.Add(new BoundField { HeaderText = "الصنف", DataField = "Item" });

            // عمود وقت التحضير المخصص
            TemplateField prepField = new TemplateField();
            prepField.HeaderText = "وقت التحضير";
            prepField.ItemTemplate = new PrepTimeTemplate();
            gv.Columns.Add(prepField);

            gv.Columns.Add(new BoundField { HeaderText = "الكمية", DataField = "Amount" });
            gv.Columns.Add(new BoundField { HeaderText = "السعر", DataField = "Price", DataFormatString = "{0:N2}" });
            gv.Columns.Add(new BoundField { HeaderText = "الإجمالي", DataField = "total", DataFormatString = "{0:N2}" });

            DataTable dtPlace = grp.CopyToDataTable();
            gv.DataSource = dtPlace;
            gv.DataBind();

            decimal totalPerPlace = dtPlace.AsEnumerable().Sum(r => Convert.ToDecimal(r["total"]));
            grandTotal += totalPerPlace;

            if (gv.FooterRow != null)
            {
                gv.FooterRow.Cells[0].Text = "إجمالي المكان:";
                gv.FooterRow.Cells[4].Text = totalPerPlace.ToString("N2");
            }

            phPlaces.Controls.Add(gv);
        }

        // المجموع النهائي
        decimal deliveryCost = Convert.ToDecimal(rowCustomer["DeliveryCost"]);
        phPlaces.Controls.Add(new Literal
        {
            Text = string.Format("<div class='alert alert-success mt-3'><strong>الصافي المطلوب: {0:N2} ج.م</strong></div>", grandTotal + deliveryCost)
        });
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