<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <%= HttpContext.GetGlobalResourceObject("Texts", "Hero_Title") %>
<%= System.Threading.Thread.CurrentThread.CurrentUICulture.Name %>
    </div>
    </form>
</body>
</html>
