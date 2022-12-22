<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="ClubInfo.aspx.cs" Inherits="SportsManagementSystem.ClubRepresentative.ClubInfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Navbar" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<asp:GridView runat="server" ID="ClubTable" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
</asp:Content>
