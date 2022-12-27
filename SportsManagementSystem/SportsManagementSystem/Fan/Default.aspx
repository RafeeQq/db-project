<%@ Page Title="Available matches to attend" Language="C#" MasterPageFile="~/Fan/Fan.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SportsManagementSystem.Fan.Default" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="SearchBtn" runat="server">
        <div class="card mb-3">
            <div class="card-body">
                <div class="d-flex flex-column gap-3">
                    <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                        Please enter all fields.
                    </div>
                    <div id="InvalidDateFormatMsg" class="alert alert-danger" runat="server">
                        Please enter a valid date time.
                    </div>

                    <div>
                        <asp:Label runat="server" Text="From Date" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="Date" runat="server" CssClass="form-control" type="datetime-local"></asp:TextBox>
                    </div>

                    <asp:Button ID="SearchBtn" runat="server" Text="Search" OnClick="SearchBtn_Click" CssClass="btn btn-primary w-100" />
                </div>
            </div>
        </div>

    </asp:Panel>

    <div class="card">
        <div class="card-body">
            <asp:GridView
                runat="server"
                ID="MatchesTable"
                class="table table-bordered table-condensed table-responsive table-hover"
                EmptyDataText="No data to display"
                OnRowCommand="MatchesTable_RowCommand"
                DataKeyNames="host_club_name,guest_club_name,start_time">
                <Columns>
                    <asp:ButtonField
                        ButtonType="Button"
                        Text="Purchase Ticket"
                        CommandName="PurchaseTicket"
                        ControlStyle-CssClass="btn btn-primary"></asp:ButtonField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
