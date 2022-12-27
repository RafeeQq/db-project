<%@ Page Title="" Language="C#" MasterPageFile="~/ClubRepresentative/ClubRepresentative.Master" AutoEventWireup="true" CodeBehind="AvailableStadiums.aspx.cs" Inherits="SportsManagementSystem.ClubRepresentative.AvailableStadiums" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="SearchBtn" runat="server">
        <div class="card mb-3">
            <div class="card-body d-flex flex-column gap-2">
                <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                    Please enter all fields.
                </div>
                <div id="InvalidDateFormatMsg" class="alert alert-danger" runat="server">
                    Please enter a valid date.
                </div>
                <asp:Label runat="server" Text="Start Date Time" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="StartDateTime" runat="server" CssClass="form-control" type="datetime-local"></asp:TextBox>
                <asp:Button ID="SearchBtn" runat="server" Text="Search" OnClick="SearchBtn_Click" CssClass="btn btn-primary w-100" />
            </div>
        </div>

        <asp:GridView
            runat="server"
            ID="StadiumTable"
            class="table table-bordered table-condensed table-responsive table-hover"
            EmptyDataText="No stadiums to display">
        </asp:GridView>
    </asp:Panel>
</asp:Content>
