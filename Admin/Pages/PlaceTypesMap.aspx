<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PlaceTypesMap.aspx.cs" Inherits="Admin_Pages_PlaceTypesMap" %>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>إدارة فئات المكان</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background-color: #f8f9fa; }
        .card { margin-top: 30px; }
        .form-label { font-weight: bold; }
        .table th { background-color: #198754; color: #fff; } /* لون أخضر للتمييز عن المواعيد */
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container">
        <div class="card shadow-sm">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">ربط الفئات بالمكان: <asp:Label ID="lblPlaceName" runat="server"></asp:Label></h4>
            </div>
            <div class="card-body">
                <asp:HiddenField ID="hfPlaceId" runat="server" />

                <div class="row mb-3 align-items-end">
                    <div class="col-md-6 mb-2">
                        <label class="form-label">الفئة (Type)</label>
                        <asp:DropDownList ID="ddlTypes" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="col-md-3 d-grid mb-2">
                        <asp:Button ID="btnAdd" runat="server" Text="إضافة الفئة" CssClass="btn btn-success" OnClick="btnAdd_Click" />
                    </div>
                    <div class="col-md-3 d-grid mb-2">
                        <a href="Places.aspx" class="btn btn-secondary">العودة للأماكن</a>
                    </div>
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mb-3 d-block"></asp:Label>

                <div class="table-responsive">
                    <asp:GridView ID="gvMap" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered"
                        DataKeyNames="MapID" OnRowDeleting="gvMap_RowDeleting">
                        <Columns>
                            <asp:BoundField DataField="MapID" HeaderText="الرقم" ReadOnly="True" ItemStyle-Width="50px" />
                            <asp:BoundField DataField="TypeName" HeaderText="اسم الفئة" />
                            
                            <asp:TemplateField HeaderText="التحكم">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelete" runat="server" CommandName="Delete" 
                                        OnClientClick="return confirm('هل تريد حذف هذه الفئة من المكان؟');" 
                                        CssClass="btn btn-danger btn-sm">حذف الربط</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>