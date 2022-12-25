<%@ Page Title="" Language="C#" MasterPageFile="~/Auth/Auth.Master" AutoEventWireup="true" CodeBehind="RegisterStadiumManager.aspx.cs" Inherits="SportsManagementSystem.Auth.RegisterStadiumManager" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <link href="../StyleSheet.css" rel="stylesheet" type="text/css" />
    <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
        Please enter all fields.
    </div>

    <div id="DuplicateUsername" class="alert alert-danger" runat="server">
        This username is already taken. Try another one.
    </div>

    <div id="DuplicateStadium" class="alert alert-danger" runat="server">
        This stadium has already been registered.
    </div>

    <div id="StadiumDoesNotExist" class="alert alert-danger" runat="server">
        This stadium does not exist. Please check the name.
    </div>

    <div>
        <asp:Label runat="server" Text="Name" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="Name" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div>
        <asp:Label runat="server" Text="Username" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="Username" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div>
        <asp:Label runat="server" Text="Password" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
    </div>

    <div>
        <asp:Label runat="server" Text="Stadium Name" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="StadiumName" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <asp:Button ID="RegisterBtn" runat="server" Text="Register" OnClick="RegisterBtn_Click" CssClass="btn" />
</asp:Content>
