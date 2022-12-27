<%@ Page Title="" Language="C#" MasterPageFile="~/StadiumManager/StadiumManager.Master" AutoEventWireup="true" CodeBehind="Requests.aspx.cs" Inherits="SportsManagementSystem.StadiumManager.Requests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="RequestAlreadyHandledMsg" class="alert alert-danger mb-3" runat="server">
        This request was already accepted or rejected, you can't change a request once it has been handled.
    </div>

    <asp:GridView
        runat="server"
        ID="RequestsTable"
        class="table table-bordered table-condensed table-responsive table-hover"
        EmptyDataText="No requests to display"
        OnRowCommand="RequestsTable_RowCommand"
        DataKeyNames="host_club_name,guest_club_name,start_time">
        <Columns>
            <asp:ButtonField
                ButtonType="Button"
                Text="Accept"
                CommandName="AcceptRequest"
                ControlStyle-CssClass="btn btn-primary"></asp:ButtonField>
            <asp:ButtonField
                ButtonType="Button"
                Text="Reject"
                CommandName="RejectRequest"
                ControlStyle-CssClass="btn btn-danger"></asp:ButtonField>
        </Columns>
    </asp:GridView>
</asp:Content>
