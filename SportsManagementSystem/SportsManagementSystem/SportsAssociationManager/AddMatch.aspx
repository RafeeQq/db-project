<%@ Page Title="" Language="C#" MasterPageFile="~/SportsAssociationManager/SportsAssociationManager.Master" AutoEventWireup="true" CodeBehind="AddMatch.aspx.cs" Inherits="SportsManagementSystem.SportsAssociationManager.AddMatch" %>
    
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="AddMatchBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
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

            <asp:Button ID="AddMatchBtn" runat="server" Text="Add Match" OnClick="AddMatchBtn_Click" CssClass="btn btn-primary w-100" />
        </div>
    </asp:Panel>

</asp:Content>
