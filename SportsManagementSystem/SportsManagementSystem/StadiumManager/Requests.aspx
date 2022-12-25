<%@ Page Title="" Language="C#" MasterPageFile="~/StadiumManager/StadiumManager.Master" AutoEventWireup="true" CodeBehind="Requests.aspx.cs" Inherits="SportsManagementSystem.StadiumManager.Requests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:GridView runat="server" ID="RequestsTable" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
    <asp:Button ID="AcceptRequestsBtn" runat="server" Text="Accept Requests" OnClick="AcceptRequestsBtn_Click" CssClass="btn btn-primary w-100" />
    <asp:Button ID="RejectRequestsBtn" runat="server" Text="Reject Requests" OnClick="RejectRequestsBtn_Click" CssClass="btn btn-primary w-100" />
</asp:Content>
