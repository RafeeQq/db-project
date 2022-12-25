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
            /*
             * View all requests he already received (in a form of name of the sending club representative, name
of the host club of the requested match, name of the guest club of the requested match ,start time
of the match, end time of the match and the staus of the request).*/

            var requests = DbHelper.RunQuery(
                @"SELECT CR.name AS club_representative_name, HC.name AS host_club_name, GC.name AS guest_club_name, M.start_time, M.end_time, R.status
                  FROM 
                    HostRequest R
                    INNER JOIN ClubRepresentative CR ON CR.id = R.club_representative_id
                    INNER JOIN StadiumManager SM ON SM.id = R.stadium_manager_id
                    INNER JOIN Match M ON M.id = R.match_id
                    INNER JOIN Club HC ON HC.id = M.host_club_id
                    INNER JOIN Club GC ON GC.id = M.guest_club_id
                  WHERE SM.username = @username",
                new Dictionary<string, object>() { { "@username", Session["Username"].ToString() } }
            );

            RequestsTable.DataSource = DbHelper.ConvertToTable(requests);

            RequestsTable.DataBind();
        }

        protected void AcceptRequestsBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("/StadiumManager/AcceptRequests.aspx");
        }

        protected void RejectRequestsBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("/StadiumManager/RejectRequests.aspx");
        }
    }
}