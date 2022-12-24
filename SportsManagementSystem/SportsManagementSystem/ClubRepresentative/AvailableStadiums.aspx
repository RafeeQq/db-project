<%@ Page Title="" Language="C#" MasterPageFile="~/ClubRepresentative/ClubRepresentative.Master" AutoEventWireup="true" CodeBehind="AvailableStadiums.aspx.cs" Inherits="SportsManagementSystem.ClubRepresentative.AvailableStadiums" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="SearchBtn" runat="server">
        <div>
            <asp:Label runat="server" Text="startDateTime" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="startDateTime" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <asp:Button ID="SearchBtn" runat="server" Text="Search" OnClick="SearchBtn_Click" CssClass="btn btn-primary w-100" />
        <asp:GridView runat="server" ID="StadiumTable" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
    </asp:Panel>
</asp:Content>
