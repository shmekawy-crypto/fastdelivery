<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeliveryZones2.aspx.cs" Inherits="DeliveryZones2" %>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <title>مناطق التوصيل</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server" class="container py-4">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <!-- إضافة منطقة -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">إضافة منطقة توصيل</h5>
                    </div>
                    <div class="card-body row g-3">

                        <div class="col-md-3">
                            <label class="form-label">المحافظة</label>
                            <asp:DropDownList ID="ddlGov" runat="server" CssClass="form-select"
                                AutoPostBack="true" OnSelectedIndexChanged="ddlGov_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">المنطقة</label>
                            <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">تكلفة التوصيل</label>
                            <asp:TextBox ID="txtCost" runat="server" CssClass="form-control" placeholder="أدخل التكلفة"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">مدة التوصيل</label>
                            <asp:TextBox ID="txtDeliveredTime" runat="server" CssClass="form-control" placeholder="مدة التوصيل"></asp:TextBox>
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                            <asp:Button ID="btnAdd" runat="server" Text="إضافة" CssClass="btn btn-success w-100" OnClick="btnAdd_Click" />
                        </div>

                    </div>
                </div>

                <!-- عرض وتعديل وحذف المناطق -->
                <div class="card shadow-sm">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0">قائمة مناطق التوصيل</h5>
                    </div>
                    <div class="card-body">

                        <asp:GridView ID="gvZones" runat="server" CssClass="table table-bordered table-hover text-center align-middle"
                            AutoGenerateColumns="false" DataKeyNames="ZoneID,Areas_id"
                            OnRowEditing="gvZones_RowEditing"
                            OnRowUpdating="gvZones_RowUpdating"
                            OnRowCancelingEdit="gvZones_RowCancelingEdit"
                            OnRowDeleting="gvZones_RowDeleting">

                            <Columns>
                                <asp:BoundField DataField="ZoneID" HeaderText="الرقم" ReadOnly="true" />

                                <asp:TemplateField HeaderText="المحافظة">
                                    <ItemTemplate>
                                        <%# Eval("GovName") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEditGov" runat="server" CssClass="form-select" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlEditGov_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="المنطقة">
                                    <ItemTemplate>
                                        <%# Eval("AreaName") %>
                                        <asp:HiddenField ID="hfAreaId" runat="server" Value='<%# Eval("Areas_id") %>' />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEditArea" runat="server" CssClass="form-select"></asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="التكلفة">
                                    <ItemTemplate>
                                        <%# Eval("DeliveryCost") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditCost" runat="server" Text='<%# Eval("DeliveryCost") %>' CssClass="form-control"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                  <asp:TemplateField HeaderText="مدة التوصيل">
                                    <ItemTemplate>
                                        <%# Eval("DeliveredTime") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditTime" runat="server" Text='<%# Eval("DeliveredTime") %>' CssClass="form-control"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ShowEditButton="true" ShowDeleteButton="true"
                                    EditText="تعديل" UpdateText="تحديث" CancelText="إلغاء" DeleteText="حذف" />
                            </Columns>

                        </asp:GridView>

                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
