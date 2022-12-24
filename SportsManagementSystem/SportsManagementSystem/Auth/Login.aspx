<%@ Page Title="Login" Language="C#" MasterPageFile="~/Auth/Auth.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SportsManagementSystem.Auth.Login" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div id="InvalidCredientialsMsg" class="alert alert-danger" runat="server">
        Invalid username or password.
    </div>

    <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
        Please enter a username and a password.
    </div>

    <div>
        <asp:Label runat="server" Text="Username" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="Username" runat="server" CssClass="form-control"></asp:TextBox>
    </div>
    <div>
        <asp:Label runat="server" Text="Password" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
    </div>
    
    <asp:Button ID="LoginBtn" runat="server" Text="Login" OnClick="LoginBtn_Click" CssClass="btn btn-primary w-100" />
</asp:Content>
