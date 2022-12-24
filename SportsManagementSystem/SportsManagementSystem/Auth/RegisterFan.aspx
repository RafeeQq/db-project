<%@ Page Title="" Language="C#" MasterPageFile="~/Auth/Auth.Master" AutoEventWireup="true" CodeBehind="RegisterFan.aspx.cs" Inherits="SportsManagementSystem.Auth.RegisterFan" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
        Please enter all fields.
    </div>

    <div id="DuplicateUsername" class="alert alert-danger" runat="server">
        This username is already taken. Try another one.
    </div>
    
    <div id="DuplicateNationalId" class="alert alert-danger" runat="server">
        This national id is already taken. Try another one.
    </div>
    <div id="NationalIdMustBeNumber" class="alert alert-danger" runat="server">
        National id must be a number.
    </div>
    <div id="PhoneNumberMustBeNumber" class="alert alert-danger" runat="server">
        Phone number must be a number.
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
        <asp:Label runat="server" Text="National ID" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="NationalId" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div>
        <asp:Label runat="server" Text="Phone Number" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="PhoneNumber" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div>
        <asp:Label runat="server" Text="Birth Date" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="BirthDate" runat="server" CssClass="form-control" type="datetime"></asp:TextBox>
    </div>

    <div>
        <asp:Label runat="server" Text="Address" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="Address" runat="server" CssClass="form-control"></asp:TextBox>
    </div>


    <asp:Button ID="RegisterBtn" runat="server" Text="Register" OnClick="RegisterBtn_Click" CssClass="btn btn-primary w-100" />
</asp:Content>
