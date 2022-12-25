<%@ Page Title="" Language="C#" MasterPageFile="~/ClubRepresentative/ClubRepresentative.Master" AutoEventWireup="true" CodeBehind="SendRequest.aspx.cs" Inherits="SportsManagementSystem.ClubRepresentative.SendRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="SendRequestBtn" runat="server">
        <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
            Please enter all fields.
        </div>

        <div id="StadiumDoesnotExist" class="alert alert-danger" runat="server">
            This manager is not found.
        </div>

        <div id="MatchDoesNotExist" class="alert alert-danger" runat="server">
            This match is not found.
        </div>

        <div id="Sucessfally" class="alert alert-success" runat="server">
            This request is sent successfully.
        </div>

        <div id="NoManager" class="alert alert-danger" runat="server">
            This stadium has no manager yet.
        </div>

        <div>
            <asp:Label runat="server" Text="StadiumName" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="StadiumName" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div>
            <asp:Label runat="server" Text="StartDateTime" CssClass="form-label"></asp:Label>
            <asp:TextBox ID="StartDateTime" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        
        <asp:Button ID="SendRequestBtn" runat="server" Text="SendRequest" OnClick="SendRequestBtn_Click" CssClass="btn btn-primary w-100" />
        
        <asp:GridView runat="server" ID="Table" class="table table-bordered table-condensed table-responsive table-hover"></asp:GridView>
    </asp:Panel>
</asp:Content>
