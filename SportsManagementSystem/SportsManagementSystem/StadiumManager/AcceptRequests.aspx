<%@ Page Title="" Language="C#" MasterPageFile="~/StadiumManager/StadiumManager.Master" AutoEventWireup="true" CodeBehind="AcceptRequests.aspx.cs" Inherits="SportsManagementSystem.StadiumManager.AcceptRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex flex-column gap-3">
        <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
            Please enter all fields.
        </div>
        <div id="RequestDoesNotExist" class="alert alert-danger" runat="server">
            The entered information does not match an unhandled request.
        </div>
        <div>
            <asp:Label runat="server" Text="Host Club Name" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="HostName" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div>
            <asp:Label runat="server" Text="Guest Club Name" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="GuestName" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div>
            <asp:Label runat="server" Text="Match Time" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="Time" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <asp:Button ID="AcceptRequestBtn" runat="server" Text="Accept Request" OnClick="AcceptRequestBtn_Click" CssClass="btn btn-primary w-100" />
</asp:Content>
