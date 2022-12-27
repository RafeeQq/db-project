<%@ Page Title="" Language="C#" MasterPageFile="~/SportsAssociationManager/SportsAssociationManager.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SportsManagementSystem.SportsAssociationManager.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column gap-3">
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">All Matches</h3>
            </div>
            <div class="card-body">
                <div class="d-flex gap-2 mb-2">
                    <a href="/SportsAssociationManager/AddMatch.aspx" class="btn btn-primary">Add Match</a>
                    <a href="/SportsAssociationManager/DeleteMatch.aspx" class="btn btn-danger">Delete Match</a>
                </div>

                <asp:GridView
                    runat="server"
                    ID="AllMatchesTable"
                    class="table table-bordered table-condensed table-responsive table-hover"
                    DataKeyNames="host,guest,start_time,end_time"
                    OnRowCommand="AllMatchesTable_RowCommand"
                    EmptyDataText="No matches, yet! Add a few">
                    <Columns>
                        <asp:ButtonField
                            ButtonType="Button"
                            CommandName="DeleteMatch"
                            ControlStyle-CssClass="btn btn-danger"
                            Text="Delete" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Already Played Matches</h3>
            </div>
            <div class="card-body">
                <asp:GridView
                    runat="server"
                    ID="AlreadyPlayedMatchesTable"
                    class="table table-bordered table-condensed table-responsive table-hover"
                    EmptyDataText="No matches, yet! Add a few">
                </asp:GridView>
            </div>
        </div>
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Upcoming Matches</h3>
            </div>
            <div class="card-body">
                <asp:GridView
                    runat="server"
                    ID="UpcomingMatchesTable"
                    class="table table-bordered table-condensed table-responsive table-hover"
                    EmptyDataText="No matches, yet! Add a few">
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
