<%@ Page Language="C#" MasterPageFile="~/Admin/MasterPages/MasterPage.master" AutoEventWireup="true" CodeFile="Drivers.aspx.cs" Inherits="Admin_Pages_Drivers" Title="تسجيل المناديب" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphead" runat="Server">
    المناديب
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="100" DynamicLayout="true">
        <ProgressTemplate>
            <div class="update"></div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="page-bar">
                <div class="page-title-breadcrumb">
                    <div class="pull-right">
                        <div class="page-title">تسجيل مناديب التوصيل</div>
                    </div>
                    <ol class="breadcrumb page-breadcrumb pull-left">
                        <li><i class="fa fa-home"></i>&nbsp;<a class="parent-item" href="#">البيانات الأساسية</a>&nbsp;<i class="fa fa-angle-left"></i></li>
                        <li class="active">تسجيل المناديب</li>
                    </ol>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="card card-box">
                        <div class="card-head">
                            <header>بيانات المناديب</header>
                            <div class="tools">
                                <a class="fa fa-repeat btn-color box-refresh" href="javascript:;"></a>
                                <a class="t-collapse btn-color fa fa-chevron-down" href="javascript:;"></a>
                                <a class="t-close btn-color fa fa-times" href="javascript:;"></a>
                            </div>
                        </div>
                        <div class="card-body" id="bar-parent">
                            <div class="form-horizontal">
                                <div class="form-body">
                                    <div class="form-group row">
                                        <label class="control-label col-sm-2">اسم المندوب <span class="required">*</span></label>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtDriverName" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfv1" runat="server" ErrorMessage="اسم المندوب مطلوب" ControlToValidate="txtDriverName" ValidationGroup="Drivers" Display="Dynamic" CssClass="help-block text-danger"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="control-label col-sm-2">رقم الهاتف <span class="required">*</span></label>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfv2" runat="server" ErrorMessage="رقم الهاتف مطلوب" ControlToValidate="txtPhone" ValidationGroup="Drivers" Display="Dynamic" CssClass="help-block text-danger"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="form-group row">
                                        <label class="control-label col-sm-2">رقم المركبة</label>
                                        <div class="col-md-8">
                                            <asp:TextBox ID="txtVehicleNo" runat="server" CssClass="form-control input-height"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-lg-12 p-t-5 text-center">
                                        <asp:Button ID="btnSave" class="btn btn-info m-r-20" runat="server" Text="حفظ" OnClick="btnSave_Click" ValidationGroup="Drivers" />
                                        <asp:Button ID="btnCancel" class="btn btn-default" runat="server" Text="الغاء" OnClick="btnCancel_Click" />
                                        <asp:HiddenField ID="hfID" runat="server" Value="0" />
                                    </div>

                                    <div class="table-scrollable">
                                        <div id="example4_wrapper" class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">
                                            <div class="form-group row">
                                                <div class="col-md-5">
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"></asp:TextBox>
                                                        <asp:Button ID="btnSearch" class="btn btn-default" runat="server" Text="بحث" OnClick="btnSearch_Click" />
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <asp:GridView ID="gvDrivers" OnRowCommand="gvDrivers_RowCommand" runat="server" AutoGenerateColumns="False" 
                                                        AllowPaging="True" PageSize="10" OnPageIndexChanging="gvDrivers_PageIndexChanging"
                                                        CssClass="table table-striped table-bordered table-hover table-checkable order-column valign-middle">
                                                        <HeaderStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                                        <RowStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                                        <PagerStyle CssClass="bs4-aspnet-pager" />
                                                        <Columns>
                                                            <asp:BoundField HeaderText="اسم المندوب" DataField="DriverName" />
                                                            <asp:BoundField HeaderText="رقم الهاتف" DataField="Phone" />
                                                            <asp:BoundField HeaderText="رقم المركبة" DataField="VehicleNo" />
                                                            <asp:TemplateField HeaderText="الحالة">
                                                                <ItemTemplate>
                                                                    <%# Eval("Status").ToString() == "1" ? "<span class='label label-sm label-success'>متاح</span>" : "<span class='label label-sm label-warning'>مشغول</span>" %>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="التحكم">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lbEdit" runat="server" CommandName="EditDriver" CommandArgument='<%#Eval("DriverID") %>' class="btn btn-xs btn-info"><i class="fa fa-pencil"></i></asp:LinkButton>
                                                                    <asp:LinkButton ID="lbDelete" runat="server" CommandName="DeleteDriver" CommandArgument='<%#Eval("DriverID") %>' class="btn btn-xs btn-danger" OnClientClick="return confirm('هل أنت متأكد من حذف المندوب؟');"><i class="fa fa-trash-o"></i></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <label class="control-label col-md-12">عدد المناديب المسجلين : <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>