using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Runtime.Remoting.Lifetime;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.Fan
{
    public partial class PurchaseTicket : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            NoTicketsAvailableMsg.Visible = false;
            MatchNotFoundMsg.Visible = false;
            InvalidDateFormat.Visible = false;


            if (!Page.IsPostBack)
            {
                var clubs = DbHelper.ConvertToTable(
                    DbHelper.RunQuery("SELECT name FROM allClubs")
                );

                HostClubName.DataSource = clubs;
                HostClubName.DataValueField = "name";
                HostClubName.DataBind();

                GuestClubName.DataSource = clubs;
                GuestClubName.DataValueField = "name";
                GuestClubName.DataBind();
            }
        }

        protected void PurchaseTicketBtn_Click(object sender, EventArgs e)
        {
            if (HostClubName.SelectedValue == "" || GuestClubName.SelectedValue == "" || MatchStartTime.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!Utils.IsValidDate(MatchStartTime.Text))
            {
                InvalidDateFormat.Visible = true;
                return;
            }
            
            if (!MatchHelper.Exists(HostClubName.Text, GuestClubName.Text, MatchStartTime.Text))
            {
                MatchNotFoundMsg.Visible = true;
                return;
            }
            
            if (!MatchHelper.HasAvailableTickets(HostClubName.Text, GuestClubName.Text, MatchStartTime.Text))
            {
                NoTicketsAvailableMsg.Visible = true;
                return;
            }

            TicketHelper.Purchase(
                HostClubName.SelectedValue,
                GuestClubName.SelectedValue,
                MatchStartTime.Text
            );

            Response.Redirect("/Fan/Tickets.aspx");
        }
    }
}