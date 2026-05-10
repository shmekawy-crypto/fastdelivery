<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PlacesDelivery.aspx.cs" Inherits="Admin_Pages_PlacesDelivery" %>
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>جدول مواعيد التوصيل</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            margin-top: 30px;
        }
        .form-label {
            font-weight: bold;
        }
        .table th {
            background-color: #0d6efd;
            color: #fff;
        }
        .btn-primary {
            background-color: #0d6efd;
            border: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">جدول مواعيد التوصيل للمطعم</h4>
            </div>
            <div class="card-body">
                <asp:HiddenField ID="hfPlaceId" runat="server" />

                <div class="row mb-3">
                    <div class="col-md-3 mb-2">
                        <label class="form-label">اليوم</label>
                        <asp:DropDownList ID="ddlDays" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label class="form-label">وقت البداية</label>
                        <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label class="form-label">وقت النهاية</label>
                        <asp:TextBox ID="txtEndTime" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    </div>
                    <div class="col-md-2 mb-2 d-flex align-items-center">
                        <div class="form-check mt-4">
                            <asp:CheckBox ID="chkIsActiveAdd" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label">فعال</label>
                        </div>
                    </div>
                    <div class="col-md-3 d-grid mb-2">
                        <asp:Button ID="btnAdd" runat="server" Text="إضافة" CssClass="btn btn-primary" OnClick="btnAdd_Click" />
                    </div>
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger mb-3 d-block"></asp:Label>

                <div class="table-responsive">
                    <asp:GridView ID="gvSchedules" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered"
                        DataKeyNames="Id,DayId" OnRowEditing="gvSchedules_RowEditing" OnRowCancelingEdit="gvSchedules_RowCancelingEdit"
                        OnRowUpdating="gvSchedules_RowUpdating" OnRowDeleting="gvSchedules_RowDeleting">
                        <Columns>
                            <asp:BoundField DataField="Id" HeaderText="الرقم" ReadOnly="True" ItemStyle-Width="50px" />

                            <asp:TemplateField HeaderText="اليوم">
                                <ItemTemplate>
                                    <%# Eval("DayName") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditDay" runat="server" CssClass="form-select" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="وقت البداية">
                                <ItemTemplate>
                                    <%# Eval("StartTime") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditStart" runat="server" Text='<%# Bind("StartTime") %>' TextMode="Time" CssClass="form-control" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="وقت النهاية">
                                <ItemTemplate>
                                    <%# Eval("EndTime") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditEnd" runat="server" Text='<%# Bind("EndTime") %>' TextMode="Time" CssClass="form-control" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="فعال">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkActiveItem" runat="server" Enabled="false" Checked='<%# Convert.ToBoolean(Eval("IsActive")) %>' />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:CheckBox ID="chkActiveEdit" runat="server" Checked='<%# Convert.ToBoolean(Eval("IsActive")) %>' />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" EditText="تعديل" UpdateText="تحديث" CancelText="إلغاء" DeleteText="حذف" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
