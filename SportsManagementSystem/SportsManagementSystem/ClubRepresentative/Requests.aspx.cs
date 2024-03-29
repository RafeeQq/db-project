﻿using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.ClubRepresentative
{
    public partial class Requests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            DuplicateRequestMsg.Visible = false;
            MatchAlreadyOnStadiumMsg.Visible = false;
            StadiumNotAvailableMsg.Visible = false;
            StadiumNotAvailableDuringMatchMsg.Visible = false;

            RequestsTable.DataSource = ClubRepresentativeHelper.AllSentHostRequestsOfCurrentUser();
            RequestsTable.DataBind();

            if (!Page.IsPostBack)
            {
                var stadiumManagers = StadiumManagerHelper.All();
                var matches = ClubRepresentativeHelper.AllUpcomingMatchesHostbedByCurrentUserClub();

                stadiumManagers.Columns.Add("label");
                matches.Columns.Add("label");

                foreach (DataRow row in stadiumManagers.Rows)
                {
                    row["label"] = row["stadium_manager_name"] + " " + "(" + row["stadium_name"] + ")";
                }

                foreach (DataRow row in matches.Rows)
                {
                    var hostClubName = row["host_club_name"];
                    var guestClubName = row["guest_club_name"];
                    var startTime = row["start_time"];
                    var endTime = row["end_time"];

                    row["label"] = $"{hostClubName} vs {guestClubName} from {startTime} to {endTime}";
                }

                Stadium.DataSource = stadiumManagers;
                Stadium.DataTextField = "label";
                Stadium.DataValueField = "stadium_name";
                Stadium.DataBind();

                Match.DataSource = matches;
                Match.DataTextField = "label";
                Match.DataValueField = "start_time";
                Match.DataBind();
            }
        }

        protected void SendRequestBtn_Click(object sender, EventArgs e)
        {
            if (Stadium.Text == "" || Match.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (ClubRepresentativeHelper.HasSentRequest(AuthHelper.GetCurrentUsername(), Stadium.Text, Match.Text))
            {
                DuplicateRequestMsg.Visible = true;
                return;
            }

            if (MatchHelper.HasStadium(ClubRepresentativeHelper.GetClubNameOfCurrentUser(), Match.Text))
            {
                MatchAlreadyOnStadiumMsg.Visible = true;
                return;
            }

            if (!StadiumHelper.IsAvailable(Stadium.Text))
            {
                StadiumNotAvailableMsg.Visible = true;
                return;
            }

            if (!StadiumHelper.IsAvailableDuringMatch(Stadium.Text, ClubRepresentativeHelper.GetClubNameOfCurrentUser(), Match.Text))
            {
                StadiumNotAvailableDuringMatchMsg.Visible = true;
                return;
            }


            HostRequestHelper.SendRequest(
                ClubRepresentativeHelper.GetClubNameOfCurrentUser(),
                Stadium.Text,
                Match.Text
            );

            Response.Redirect("/ClubRepresentative/Requests.aspx");
        }
    }
}