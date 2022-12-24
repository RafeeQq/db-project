<%@ Page Title="" Language="C#" MasterPageFile="~/SystemAdmin/SystemAdmin.Master" AutoEventWireup="true" CodeBehind="AddStadium.aspx.cs" Inherits="SportsManagementSystem.SystemAdmin.AddStadium" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="AddStadiumBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>
            
            <div id="StadiumCapacityMustBeNumberMsg" class="alert alert-danger" runat="server">
                Stadium capacity must be a number
            </div>

            <div id="StadiumAlreadyExistsMsg" class="alert alert-danger" runat="server">
                A stadium with the exact same name already exists.
            </div>

            <div>
                <asp:Label runat="server" Text="Stadium Name" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="StadiumName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div>
                <asp:Label runat="server" Text="Stadium Location" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="StadiumLocation" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div>
                <asp:Label runat="server" Text="Stadium Capacity" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="StadiumCapacity" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="AddStadiumBtn" runat="server" Text="Add Stadium" OnClick="AddStadiumBtn_Click" CssClass="btn btn-primary w-100" />
        </div>
    </asp:Panel>

</asp:Content>
