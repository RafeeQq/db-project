<%@ Page Title="" Language="C#" MasterPageFile="~/ClubRepresentative/ClubRepresentative.Master" AutoEventWireup="true" CodeBehind="UpComingMatches.aspx.cs" Inherits="SportsManagementSystem.ClubRepresentative.UpComingMatches" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:GridView 
        runat="server" 
        ID="UpComingMatchesTable" 
        class="table table-bordered table-condensed table-responsive table-hover"
        EmptyDataText="No upcoming matches to display"></asp:GridView>
</asp:Content>
