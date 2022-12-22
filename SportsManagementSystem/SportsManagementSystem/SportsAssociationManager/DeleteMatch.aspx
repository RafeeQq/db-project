<%@ Page Title="" Language="C#" MasterPageFile="~/SportsAssociationManager/SportsAssociationManager.Master" AutoEventWireup="true" CodeBehind="DeleteMatch.aspx.cs" Inherits="SportsManagementSystem.SportsAssociationManager.DeleteMatch" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="DeleteMatchBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>

            <div id="MatchDoesNotExist" class="alert alert-danger" runat="server">
               The info entered doesn't match any matches.
            </div>

            <div>
                <asp:Label runat="server" Text="Host Club Name" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="HostName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div>
                <asp:Label runat="server" Text="Guest Club Name" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="GuestName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div>
                <asp:Label runat="server" Text="Start Time" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="StartTime" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div>
                <asp:Label runat="server" Text="End Time" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="EndTime" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="DeleteMatchBtn" runat="server" Text="Delete Match" OnClick="DeleteMatchBtn_Click" CssClass="btn btn-primary w-100" />
        </div>
    </asp:Panel>

</asp:Content>
