using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.ClubRepresentative
{
    public partial class UpComingMatches : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var club = DbHelper.RunQuery("SELECT club_name FROM allClubRepresentatives WHERE username = @username",
                new Dictionary<string, object>() { {   "@username", Session["username"].ToString() } });

            var matches = DbHelper.RunQuery("SELECT * FROM upcomingMatchesOfClub (@C)",
                new Dictionary<string, object>() { { "@c", club[0]["club_name"].ToString() } });
            UpComingMatchesTable.DataSource = DbHelper.ConvertToTable(matches);
            UpComingMatchesTable.DataBind();

        }
    }
}