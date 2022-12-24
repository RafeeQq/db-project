<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="BlockFan.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.BlockFan" %>


<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="BlockFanBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>

            <div id="NoFanFoundMsg" class="alert alert-danger" runat="server">
                No fan with the given national id was found.
            </div>

            <div>
                <asp:Label runat="server" Text="Fan National ID" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="FanNationalId" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="BlockFanBtn" runat="server" Text="Block Fan" OnClick="BlockFanBtn_Click" CssClass="btn btn-danger w-100" />
        </div>
    </asp:Panel>
</asp:Content>
