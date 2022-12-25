using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.StadiumManager
{
    public partial class RejectRequests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            RequestDoesNotExist.Visible = false;
        }

        protected void AcceptRequestBtn_Click(object sender, EventArgs e)
        {
            if (HostName.Text == "" || GuestName.Text == "" || Time.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }
            var request = DbHelper.RunQuery("SELECT * FROM HostRequest HS INNER JOIN StadiumManager SM ON HS.stadium_manager_id = SM.id" +
                                            "INNER JOIN ClubRepresentative CR ON HS.club_representative_id = CR.id" +
                                            "INNER JOIN Match M ON M.id = HS.match_id" +
                                            "WHERE SM.username = @username",
            new Dictionary<string, object>()
            {
                {"@username", Session["Username"].ToString()}
            });
            if (request.Count == 0)
            {
                RequestDoesNotExist.Visible = true; return;
            }

            DbHelper.RunStoredProcedure("rejectRequest",
                        new Dictionary<string, object>()
                        {
                     {"@stadium_manager_username", Session["Username"].ToString()},
                            {"@host_club", HostName.Text},
                            {"@guest_club", GuestName.Text},
                            {"@date",Time.Text}
                        });

        }
    }
}