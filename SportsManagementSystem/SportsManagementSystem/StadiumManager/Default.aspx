<%@ Page Title="" Language="C#" MasterPageFile="~/StadiumManager/StadiumManager.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SportsManagementSystem.StadiumManager.Default" %>

<asp:Content runat="server" ContentPlaceHolderID="MainContent">
    <asp:GridView
        runat="server"
        ID="StadiumInfo"
        class="table table-bordered table-condensed table-responsive table-hover">
    </asp:GridView>
</asp:Content>
