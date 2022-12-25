using SportsManagementSystem.DbHelpers;
using System;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.Fan
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            InvalidDateFormatMsg.Visible = false;
        }

        protected void SearchBtn_Click(object sender, EventArgs e)
        {
            if (Date.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!Utils.IsValidDate(Date.Text))
            {
                InvalidDateFormatMsg.Visible = true;
                return;
            }

            MatchesTable.DataSource = MatchHelper.AllAvailableMatchesToAttendStartingFrom(Date.Text);
            MatchesTable.DataBind();
        }

        protected void MatchesTable_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "PurchaseTicket")
            {
                int i = Convert.ToInt32(e.CommandArgument);

                var hostClubName = (string)MatchesTable.DataKeys[i]["host_club_name"];
                var guestClubName = (string)MatchesTable.DataKeys[i]["guest_club_name"];
                var startTime = (string)MatchesTable.DataKeys[i]["start_time"];

                TicketHelper.Purchase(hostClubName, guestClubName, startTime);

                Response.Redirect("/Fan/Tickets.aspx");
            }
        }
    }
}