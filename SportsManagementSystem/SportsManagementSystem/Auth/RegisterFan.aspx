<%@ Page Title="Register as Fan" Language="C#" MasterPageFile="~/Auth/Auth.Master" AutoEventWireup="true" CodeBehind="RegisterFan.aspx.cs" Inherits="SportsManagementSystem.Auth.RegisterFan" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server" visible="false">
        Please enter all fields.
    </div>

    <div id="DuplicateUsernameMsg" class="alert alert-danger" runat="server" visible="false">
        This username is already taken. Try another one.
    </div>
    
    <div id="DuplicateNationalIdMsg" class="alert alert-danger" runat="server" visible="false">
        This national id is already taken. Try another one.
    </div>

    <div id="NationalIdMustBeNumberMsg" class="alert alert-danger" runat="server" visible="false">
        National id must be a number.
    </div>
    
    <div id="PhoneNumberMustBeNumberMsg" class="alert alert-danger" runat="server" visible="false">
        Phone number must be a number.
    </div>
    
    <div id="InvalidDateFormatMsg" class="alert alert-danger" runat="server" visible="false">
        Please enter a valid birth date. (Formatted like Year-Month-Day)
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
        <asp:TextBox ID="BirthDate" runat="server" CssClass="form-control" type="datetime-local"></asp:TextBox>
    </div>

    <div>
        <asp:Label runat="server" Text="Address" CssClass="form-label"></asp:Label>
        <asp:TextBox ID="Address" runat="server" CssClass="form-control"></asp:TextBox>
    </div>


    <asp:Button ID="RegisterBtn" runat="server" Text="Register" OnClick="RegisterBtn_Click" CssClass="btn btn-primary w-100" />
</asp:Content>
