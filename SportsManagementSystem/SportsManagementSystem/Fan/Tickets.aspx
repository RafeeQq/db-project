<%@ Page Title="Your tickets" Language="C#" MasterPageFile="~/Fan/Fan.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="SportsManagementSystem.Fan.Tickets" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a href="/Fan/PurchaseTicket.aspx" class="btn btn-primary mb-3">Purchase a new ticket</a>
    <asp:GridView
        runat="server"
        ID="TicketsTable"
        class="table table-bordered table-condensed table-responsive table-hover"
        EmptyDataText="You have not purchased any tickets">
    </asp:GridView>
</asp:Content>
