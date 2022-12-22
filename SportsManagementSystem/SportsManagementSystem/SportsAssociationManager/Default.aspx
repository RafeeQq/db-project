<%@ Page Title="" Language="C#" MasterPageFile="~/SportsAssociationManager/SportsAssociationManager.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SportsManagementSystem.SportsAssociationManager.Default" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
          <asp:Button ID="UpcomingMatches" runat="server" Text="Upcoming Matches" OnClick="UpcomingMatches_Click"  CssClass="btn btn-primary w-100" />
          <asp:Button ID="AlreadyPlayedMatches" runat="server" Text="Already Played Matches" OnClick="AlreadyPlayedMatches_Click" CssClass="btn btn-primary w-100" />
          <asp:Button ID="ClubsNeverMatched" runat="server" Text="Clubs Not Yet Matched" OnClick="ClubsNeverMatched_Click" CssClass="btn btn-primary w-100" />
          <asp:Button ID="AddMatch" runat="server" Text="Add Match" OnClick="AddMatch_Click" CssClass="btn btn-primary w-100" />
          <asp:Button ID="DeleteMatch" runat="server" Text="Delete Match" OnClick="DeleteMatch_Click" CssClass="btn btn-primary w-100" />
</asp:Content>
