<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.Default" %>

<asp:Content runat="server" ContentPlaceHolderID="MainContent">
    <div class="d-flex gap-2">
        <a href="/SystemAdmin/AddClub.aspx" class="btn btn-primary mb-2">Add Club</a>
        <a href="/SystemAdmin/DeleteClub.aspx" class="btn btn-danger mb-2">Delete Club</a>
    </div>

    <asp:GridView runat="server" ID="ClubsTable" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
</asp:Content>
