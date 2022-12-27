using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.StadiumManager
{
    public partial class Requests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RequestAlreadyHandledMsg.Visible = false;
            
            RequestsTable.DataSource = HostRequestHelper.AllPendingRequestsForCurrentUser();
            RequestsTable.DataBind();
        }

        protected void RequestsTable_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var i = Convert.ToInt32(e.CommandArgument);

            var stadiumManagerUsername = AuthHelper.GetCurrentUsername();
            var hostClubName = RequestsTable.DataKeys[i]["host_club_name"].ToString();
            var guestClubName = RequestsTable.DataKeys[i]["guest_club_name"].ToString();
            var startTime = RequestsTable.DataKeys[i]["start_time"].ToString();

            if (HostRequestHelper.IsHandled(stadiumManagerUsername, hostClubName, guestClubName, startTime))
            {
                RequestAlreadyHandledMsg.Visible = true;
                return;
            }

            if (e.CommandName == "AcceptRequest")
            {
                HostRequestHelper.AcceptRequest(stadiumManagerUsername, hostClubName, guestClubName, startTime);
            }
            else if (e.CommandName == "RejectRequest")
            {
                HostRequestHelper.RejectRequest(stadiumManagerUsername, hostClubName, guestClubName, startTime);
            }

            Response.Redirect("/StadiumManager/Requests.aspx");
        }
    }
}