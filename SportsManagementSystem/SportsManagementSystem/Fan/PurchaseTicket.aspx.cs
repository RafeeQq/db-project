using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.Fan
{
    public partial class PurchaseTicket : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void PurchaseTicketBtn_Click(object sender, EventArgs e)
        {
            // Check no empty fields
            if (HostClubName.Text == "" || GuestClubName.Text == "" || MatchStartTime.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            // Check valid datetime.
            if (!Utils.IsValidDate(MatchStartTime.Text))
            {
                InvalidDateFormat.Visible = true;
                return;
            }

            // Check a match exists matching the given information
            var matchExists = DbHelper.CheckExists(
                "SELECT * FROM allMatches WHERE host = @HostClubName AND guest = @GuestClubName AND start_time = @MatchStartTime",
                new
                {
                    HostClubName = HostClubName.Text,
                    GuestClubName = GuestClubName.Text,
                    MatchStartTime = MatchStartTime.Text
                }
            );

            if (!matchExists)
            {
                MatchNotFoundMsg.Visible = true;
            }

            // Check if there are tickets available for that match
            var ticketsExist = DbHelper.CheckExists(
                "SELECT * FROM allTickets WHERE host_club_name = @HostClubName AND guest_club_name = @GuestClubName AND start_time = @MatchStartTime",
                new
                {
                    HostClubName = HostClubName.Text,
                    GuestClubName = GuestClubName.Text,
                    MatchStartTime = MatchStartTime.Text
                }
            );

            if (!ticketsExist)
            {
                NoTicketsAvailableMsg.Visible = true;
                return;
            }

            // Get current logged in fan national id
            var national_id = DbHelper.GetScalar(
                "SELECT national_id FROM allFans WHERE username = @Username",
                new
                {
                    Username = Session["Username"].ToString()
                }
            );

            // Buy the ticket
            DbHelper.RunStoredProcedure(
                "purchaseTicket",
                new
                {
                    national_id_number = national_id,
                    host_club_name = HostClubName.Text,
                    guest_club_name = GuestClubName.Text,
                    start_time = MatchStartTime.Text
                }
            );

            Response.Redirect("/Fan/Default.aspx");
        }
    }
}