<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="Stadiums.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.Stadiums" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex gap-2">
        <a href="/SystemAdmin/AddStadium.aspx" class="btn btn-primary mb-2">Add Stadium</a>
        <a href="/SystemAdmin/DeleteStadium.aspx" class="btn btn-danger mb-2">Delete Stadium</a>
    </div>

    <asp:GridView runat="server" ID="StadiumTable" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
</asp:Content>
