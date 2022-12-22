<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="Fans.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.Fans" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex gap-2">
        <a href="/SystemAdmin/BlockFan.aspx" class="btn btn-primary mb-2">Block Fan</a>
    </div>

    <asp:GridView runat="server" ID="FansTable" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
</asp:Content>
