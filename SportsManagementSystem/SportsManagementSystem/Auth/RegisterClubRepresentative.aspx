<%@ Page Title="Register as Club Representative" Language="C#" MasterPageFile="~/Auth/Auth.Master" AutoEventWireup="true" CodeBehind="RegisterClubRepresentative.aspx.cs" Inherits="SportsManagementSystem.Auth.RegisterClubRepresentative" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
        Please enter all fields.
    </div>

    <div id="DuplicateUsernameMsg" class="alert alert-danger" runat="server">
        This username is already taken. Try another one.
    </div>

    <div id="ClubAlreadyHaveRepresentativeMsg" class="alert alert-danger" runat="server">
        This club already have representative. Try another one.
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
        <asp:Label runat="server" Text="Club Name" CssClass="form-label"></asp:Label>
        <asp:DropDownList
            ID="ClubName"
            runat="server"
            CssClass="form-control"
            DataTextField="name"
            DataValueField="name">
        </asp:DropDownList>

    </div>

    <asp:Button ID="RegisterBtn" runat="server" Text="Register" OnClick="RegisterBtn_Click" CssClass="btn btn-primary w-100" />
</asp:Content>
