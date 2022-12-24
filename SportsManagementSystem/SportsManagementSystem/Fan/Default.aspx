<%@ Page Title="" Language="C#" MasterPageFile="~/Fan/Fan.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SportsManagementSystem.Fan.Default" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="SearchBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>

            <div>
                <asp:Label runat="server" Text="From Date" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="Date" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="SearchBtn" runat="server" Text="Search" OnClick="SearchBtn_Click" CssClass="btn btn-primary w-100" />
        </div>
    </asp:Panel>
    <asp:GridView runat="server" ID="MatchesTable" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
</asp:Content>
