<%@ Page Title="" Language="C#" MasterPageFile="~/SportsAssociationManager/SportsAssociationManager.Master" AutoEventWireup="true" CodeBehind="ClubsNeverMatched.aspx.cs" Inherits="SportsManagementSystem.SportsAssociationManager.ClubsNeverMatched" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:GridView 
        runat="server" 
        ID="ClubsNeverMatchedTable" 
        class="table table-bordered table-condensed table-responsive table-hover"
        EmptyDataText="No clubs to display."></asp:GridView>
</asp:Content>
