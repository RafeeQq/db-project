<%@ Page Title="" Language="C#" MasterPageFile="~/Fan/Fan.Master" AutoEventWireup="true" CodeBehind="PurchaseTicket.aspx.cs" Inherits="SportsManagementSystem.Fan.PurchaseTicket" %>


<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="PurchaseTicketBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>

            <div id="NoTicketsAvailableMsg" class="alert alert-danger" runat="server">
                No tickets available for that match
            </div>

            <div id="MatchNotFoundMsg" class="alert alert-danger" runat="server">
                A match with the given information is not found.
            </div>

            <div id="InvalidDateFormat" class="alert alert-danger" runat="server">
                Enter valid a date time. Valid formats are Year/Month/Day Hour:Minute:Second
            </div>

            <div>
                <asp:Label runat="server" Text="Host Club Name" CssClass="form-label"></asp:Label>
                <asp:DropDownList ID="HostClubName" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <div>
                <asp:Label runat="server" Text="Guest Club Name" CssClass="form-label"></asp:Label>
                <asp:DropDownList ID="GuestClubName" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div>
                <asp:Label runat="server" Text="Match Start Time" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="MatchStartTime" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="PurchaseTicketBtn" runat="server" Text="Purchase Ticket" OnClick="PurchaseTicketBtn_Click" CssClass="btn btn-primary w-100" />
        </div>
    </asp:Panel>
</asp:Content>

