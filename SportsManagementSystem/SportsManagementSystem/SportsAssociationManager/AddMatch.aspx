<%@ Page Title="" Language="C#" MasterPageFile="~/SportsAssociationManager/SportsAssociationManager.Master" AutoEventWireup="true" CodeBehind="AddMatch.aspx.cs" Inherits="SportsManagementSystem.SportsAssociationManager.AddMatch" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="AddMatchBtn" runat="server">
        <div class="d-flex flex-column gap-3">
            <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                Please enter all fields.
            </div>
            
            <div id="ClubVsItselfMsg" class="alert alert-danger" runat="server">
                Please enter two different clubs.
            </div>
            
            <div id="InvalidDateFormatMsg" class="alert alert-danger" runat="server">
                The date format is invalid. Enter valid dates.
            </div>
            
            <div id="StartTimeBeforeEndTimeMsg" class="alert alert-danger" runat="server">
                Start time must be before end time.
            </div>

            <div id="MatchTimingCollisionMsg" class="alert alert-danger" runat="server">
                One of the clubs is will already be playing a match at that time interval.
            </div>
            
            <div>
                <asp:Label runat="server" Text="Host Club Name" CssClass="form-label"></asp:Label>
                <asp:DropDownList
                    ID="HostClub"
                    runat="server"
                    CssClass="form-control"
                    DataValueField="name" />
            </div>

            <div>
                <asp:Label runat="server" Text="Guest Club Name" CssClass="form-label"></asp:Label>
                <asp:DropDownList
                    ID="GuestClub"
                    runat="server"
                    CssClass="form-control"
                    DataValueField="name" />
            </div>

            <div>
                <asp:Label runat="server" Text="Start Time" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="StartTime" runat="server" CssClass="form-control" type="datetime-local"></asp:TextBox>
            </div>

            <div>
                <asp:Label runat="server" Text="End Time" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="EndTime" runat="server" CssClass="form-control" type="datetime-local"></asp:TextBox>
            </div>

            <asp:Button ID="AddMatchBtn" runat="server" Text="Add Match" OnClick="AddMatchBtn_Click" CssClass="btn btn-primary w-100" />
        </div>
    </asp:Panel>

</asp:Content>
