<%@ Page Title="إدارة عروض وإعلانات الأصناف" Language="C#" MasterPageFile="~/Places/MasterPages/Site.master" AutoEventWireup="true" CodeFile="RestaurantBanners.aspx.cs" Inherits="Places_MasterPages_RestaurantBanners" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .dashboard-header { background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); margin-bottom: 25px; border-right: 5px solid #ff9800; }
        .search-card { background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); margin-bottom: 20px; }
        .table-card { background: #fff; border-radius: 12px; padding: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); }
        .btn-modern { border-radius: 6px; font-weight: bold; }
        
        /* تنسيقات قائمة تاغات الأصناف المضافة داخل البانر */
        .selected-items-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 12px;
            padding: 12px;
            border: 1px dashed #cccccc;
            border-radius: 8px;
            background-color: #fafafa;
            min-height: 50px;
        }
        .item-tag {
            background: #ff9800;
            color: #ffffff;
            padding: 6px 14px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(255,152,0,0.15);
        }
        .item-tag .remove-tag-btn {
            cursor: pointer;
            background: rgba(255,255,255,0.25);
            border-radius: 50%;
            width: 16px;
            height: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            transition: background 0.2s, color 0.2s;
        }
        .item-tag .remove-tag-btn:hover {
            background: #dc3545;
            color: #ffffff;
        }
    </style>

    <asp:ScriptManager ID="sm2" runat="server"></asp:ScriptManager>

    <div class="container-fluid">
        <div class="dashboard-header">
            <div class="row">
                <div class="col-md-6">
                    <h2 style="margin:0; font-weight:bold; color:#2c3e50;">إدارة عروض وبانرات الأصناف الداخلية للمطعم</h2>
                </div>
                <div class="col-md-6 text-left">
                    إجمالي البانرات الحالية للمطعم: <b><asp:Label ID="lblTotalBanners" runat="server" Text="0" /></b>
                </div>
            </div>
        </div>

        <div class="search-card">
            <h4 style="font-weight:bold; color:#2c3e50; margin-bottom:15px; border-bottom:1px solid #eee; padding-bottom:10px;">إضافة بانر عروض جديد لأصناف مطعمكم</h4>
            
            <div class="row">
                <%-- 1. ترتيب الظهور --%>
                <div class="col-md-6 form-group">
                    <label>ترتيب ظهور البانر الداخلي ضمن قائمة البانرات التابعة لكم:</label>
                    <asp:TextBox ID="txtSortOrder" runat="server" CssClass="form-control" Text="0" TextMode="Number"></asp:TextBox>
                </div>

                <%-- 2. حالة النشاط التوجلي --%>
                <div class="col-md-6 form-group" style="padding-top: 30px;">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" Style="transform: scale(1.3); margin-left: 10px;" />
                    <label style="font-weight: bold; color: #27ae60; cursor: pointer;">تشغيل وتفعيل العرض فوراً للعملاء داخل تطبيق وموقع مطعمكم</label>
                </div>
            </div>

            <div class="row" style="margin-top: 10px;">
                <%-- 3. اختيار أصناف المطعم الحالي حصراً --%>
                <div class="col-md-12 form-group">
                    <label>اختر الأصناف والأحجام المشمولة في هذا البانر (يمكنك إضافة صنف واحد أو عدة أصناف معاً):</label>
                    <div class="row">
                        <div class="col-md-9">
                            <asp:DropDownList ID="ddlMenuSizes" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <button type="button" class="btn btn-success btn-block btn-modern" onclick="addSizeItemToBannerList(event); return false;">
                                <i class="fa fa-plus"></i> إضافة صنف للعرض
                            </button>
                        </div>
                    </div>

                    <%-- صندوق تاغات الأصناف المضافة تلقائياً بالجافا سكريبت --%>
                    <div id="selectedItemsContainer" class="selected-items-container"></div>
                    
                    <%-- حقل مجمع لنقل أرقام الأصناف المختارة بفاصلة لملف الـ C# --%>
                    <asp:HiddenField ID="hfSelectedSizeIDs" runat="server" ClientIDMode="Static" />
                </div>
            </div>

            <div class="row" style="margin-top: 15px;">
                <%-- 4. رفع صورة الإعلان --%>
                <div class="col-md-6 form-group">
                    <label>اختر صورة البانر (مقاس عريض انسيابي موصى به 16:5):</label>
                    <asp:FileUpload ID="fuBannerPhoto" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvPhoto" runat="server" ErrorMessage="ملف صورة العرض مطلوب" ControlToValidate="fuBannerPhoto" ValidationGroup="RestaurantBannerGroup" Display="Dynamic" ForeColor="Red" Font-Size="12px"></asp:RequiredFieldValidator>
                </div>
                
                <%-- 5. أزرار التحكم بالحفظ --%>
                <div class="col-md-6 text-left" style="padding-top: 25px;">
                    <asp:Button ID="btnSave" runat="server" Text="حفظ وتشغيل البانر المجمع" CssClass="btn btn-primary btn-modern" OnClick="btnSave_Click" ValidationGroup="RestaurantBannerGroup" Style="padding: 8px 30px;" />
                    <asp:Button ID="btnCancel" runat="server" Text="إلغاء التعيين" CssClass="btn btn-default btn-modern" OnClick="btnCancel_Click" Style="padding: 8px 20px; margin-right:10px;" />
                </div>
            </div>
        </div>

        <div class="table-card">
            <asp:UpdatePanel ID="upBannersGrid" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:GridView ID="gvBanners" runat="server" CssClass="table table-hover" AutoGenerateColumns="false" DataKeyNames="id" OnRowCommand="gvBanners_RowCommand" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="#" />
                            
                            <asp:TemplateField HeaderText="الأصناف المرتبطة بالـ Pop-up الحالي" HeaderStyle-Width="50%">
                                <ItemTemplate>
                                    <div style="font-size:12px; font-weight:600; color:#e67e22; text-align:right;">
                                        <%# Eval("ConnectedItems") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="معاينة البانر">
                                <ItemTemplate>
                                    <asp:Image ID="imgGrid" runat="server" ImageUrl='<%# "~/" + Eval("PhotoUrl") %>' Width="160" Height="60" Style="object-fit:cover; border-radius:6px; border:1px solid #eee;" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:CheckBoxField HeaderText="نشط" DataField="IsActive" />
                            <asp:BoundField DataField="SortOrder" HeaderText="الترتيب" />
                            
                            <asp:TemplateField HeaderText="الإجراء">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteBanner" CommandArgument='<%# Eval("id") %>' CssClass="btn btn-danger btn-sm btn-modern" OnClientClick="return confirm('هل أنت متأكد من حذف هذا البانر المجمع وتطهير علاقات الأصناف الحالية؟');"><i class="fa fa-trash"></i> حذف العرض</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <%-- كود الجافا سكريبت المضمون لعدم حدوث PostBack وتجميع الأرقام المحددة من القائمة بدقة --%>
    <script type="text/javascript">
        if (typeof bannerSelectedItems === 'undefined') {
            var bannerSelectedItems = [];
        }

        function addSizeItemToBannerList(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            const dropdown = document.getElementById('<%= ddlMenuSizes.ClientID %>');
            if (!dropdown) return false;

            const id = dropdown.value;
            const name = dropdown.options[dropdown.selectedIndex].text;

            if (!id || id === "0") {
                alert('يرجى اختيار صنف من قائمة طعام مطعمكم أولاً قبل إضافة العرض');
                return false;
            }

            if (bannerSelectedItems.some(item => item.id === id)) {
                alert('هذا الصنف مضاف بالفعل بداخل قائمة هذا البانر مسبقاً');
                return false;
            }

            bannerSelectedItems.push({ id: parseInt(id), name: name });
            renderBannerItemTags();

            dropdown.value = "0";
            return false;
        }

        function removeSizeItemTag(id) {
            bannerSelectedItems = bannerSelectedItems.filter(item => item.id !== id);
            renderBannerItemTags();
        }

        function renderBannerItemTags() {
            const container = document.getElementById('selectedItemsContainer');
            const hfIDs = document.getElementById('hfSelectedSizeIDs');
            if (!container || !hfIDs) return;
            container.innerHTML = '';

            bannerSelectedItems.forEach(item => {
                const tag = document.createElement('div');
                tag.className = 'item-tag';
                tag.innerHTML = `${item.name} <span class="remove-tag-btn" onclick="removeSizeItemTag(${item.id})"><i class="fa fa-times"></i></span>`;
                container.appendChild(tag);
            });

            const idsArray = bannerSelectedItems.map(item => item.id);
            hfIDs.value = idsArray.join(',');
        }

        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                renderBannerItemTags();
            });
        }
    </script>
</asp:Content>