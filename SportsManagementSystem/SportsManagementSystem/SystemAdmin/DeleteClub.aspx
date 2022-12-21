<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="DeleteClub.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.DeleteClub" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="DeleteClubBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>
            <div id="NoClubFoundMsg" class="alert alert-danger" runat="server">
                No club with the given name was found.
            </div>

            <div>
                <asp:Label runat="server" Text="Club Name" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="ClubName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="DeleteClubBtn" runat="server" Text="Delete Club" OnClick="AddClubBtn_Click" CssClass="btn btn-danger w-100" />
        </div>
    </asp:Panel>
</asp:Content>
