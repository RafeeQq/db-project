<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="DeleteStadium.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.DeleteStadium" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="DeleteStadiumBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>

            <div id="NoStadiumFoundMsg" class="alert alert-danger" runat="server">
                No stadium with the given name was found.
            </div>
            
            <div>
                <asp:Label runat="server" Text="Stadium Name" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="StadiumName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="DeleteStadiumBtn" runat="server" Text="Delete Stadium" OnClick="DeleteStadiumBtn_Click" CssClass="btn btn-danger w-100" />
        </div>
    </asp:Panel>
</asp:Content>
