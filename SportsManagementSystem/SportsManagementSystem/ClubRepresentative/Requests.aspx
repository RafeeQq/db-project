﻿<%@ Page Title="" Language="C#" MasterPageFile="~/ClubRepresentative/ClubRepresentative.Master" AutoEventWireup="true" CodeBehind="Requests.aspx.cs" Inherits="SportsManagementSystem.ClubRepresentative.Requests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel DefaultButton="SendRequestBtn" runat="server">
        <div class="card mb-3">
            <div class="card-body d-flex flex-column gap-3">
                <div id="EmptyFieldsMsg" class="alert alert-danger" runat="server">
                    Please enter all fields.
                </div>

                <div id="DuplicateRequestMsg" class="alert alert-danger" runat="server">
                    You have already sent a request for this match to this stadium.
                </div>

                <asp:DropDownList
                    runat="server"
                    ID="Stadium"
                    class="form-control" />

                <asp:DropDownList
                    runat="server"
                    ID="Match"
                    class="form-control" />

                <asp:Button ID="SendRequestBtn" runat="server" Text="Send Request" OnClick="SendRequestBtn_Click" CssClass="btn btn-primary w-100" />
            </div>
        </div>
    </asp:Panel>


    <asp:GridView
        runat="server"
        ID="RequestsTable"
        class="table table-bordered table-condensed table-responsive table-hover"
        EmptyDataText="No requests, yet!">
    </asp:GridView>
</asp:Content>
