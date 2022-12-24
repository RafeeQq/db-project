<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="Stadiums.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.Stadiums" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex gap-2">
        <a href="/SystemAdmin/AddStadium.aspx" class="btn btn-primary mb-2">Add Stadium</a>
        <a href="/SystemAdmin/DeleteStadium.aspx" class="btn btn-danger mb-2">Delete Stadium</a>
    </div>

    <asp:GridView
        runat="server"
        ID="StadiumsTable"
        class="table table-bordered table-condensed table-responsive table-hover"
        DataKeyNames="name"
        OnRowCommand="StadiumsTable_RowCommand"
        EmptyDataText="No stadiums, yet! Add a few.">
        <Columns>
            <asp:ButtonField
                ButtonType="Button"
                CommandName="DeleteStadium"
                ControlStyle-CssClass="btn btn-danger"
                Text="Delete" />
        </Columns>
    </asp:GridView>
</asp:Content>
