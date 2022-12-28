using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class AddMatch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            ClubVsItselfMsg.Visible = false;
            StartTimeBeforeEndTimeMsg.Visible = false;
            InvalidDateFormatMsg.Visible = false;
            MatchTimingCollisionMsg.Visible = false;

            if (!Page.IsPostBack)
            {
                HostClub.DataSource = ClubHelper.All();
                GuestClub.DataSource = ClubHelper.All();
                HostClub.DataBind();
                GuestClub.DataBind();
            }
        }

        protected void AddMatchBtn_Click(object sender, EventArgs e)
        {
            if (StartTime.Text == "" || EndTime.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (HostClub.SelectedValue == GuestClub.SelectedValue)
            {
                ClubVsItselfMsg.Visible = true;
                return;
            }

            if (!Utils.IsValidDate(StartTime.Text) || !Utils.IsValidDate(EndTime.Text))
            {
                InvalidDateFormatMsg.Visible = true;
                return;
            }

            if (DateTime.Parse(StartTime.Text) >= DateTime.Parse(EndTime.Text))
            {
                StartTimeBeforeEndTimeMsg.Visible = true;
                return;
            }

            if (ClubHelper.HasMatchDuring(HostClub.SelectedValue, StartTime.Text, EndTime.Text) || ClubHelper.HasMatchDuring(GuestClub.SelectedValue, StartTime.Text, EndTime.Text))
            {
                MatchTimingCollisionMsg.Visible = true;
                return;
            }

            MatchHelper.Add(HostClub.SelectedValue, GuestClub.SelectedValue, StartTime.Text, EndTime.Text);

            Response.Redirect("/SportsAssociationManager/Default.aspx");
        }
    }
}