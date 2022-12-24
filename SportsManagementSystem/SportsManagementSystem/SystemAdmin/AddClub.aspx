<%@ Page Title="Add Club" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="AddClub.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.AddClub" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="AddClubBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>

            <div id="ClubAlreadyExistsMsg" class="alert alert-danger" runat="server">
                A club with the exact same name already exists.
            </div>

            <div>
                <asp:Label runat="server" Text="Club Name" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="ClubName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div>
                <asp:Label runat="server" Text="Club Location" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="ClubLocation" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="AddClubBtn" runat="server" Text="Add Club" OnClick="AddClubBtn_Click" CssClass="btn btn-primary w-100" />
        </div>
    </asp:Panel>

</asp:Content>
