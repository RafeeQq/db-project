using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.ClubRepresentative
{
    public partial class SendRequest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            StadiumDoesnotExist.Visible = false;
            MatchDoesNotExist.Visible = false;
            Sucessfally.Visible = false;
            NoManager.Visible = false;

        }
        protected void SendRequestBtn_Click(object sender, EventArgs e)
        {
            if(StadiumName.Text == "" || StartDateTime.Text == "" )
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }
            var stadium = DbHelper.RunQuery("SELECT * FROM allStadiums  WHERE  name = @StadiumName AND status = 1 ",
                new Dictionary<string, object> { { "@StadiumName", StadiumName.Text } });
            var managers = DbHelper.RunQuery("SELECT * FROM allStadiumManagers WHERE stadium_name =@StadiumName",
                new Dictionary<string, object>() { { "@StadiumName", StadiumName.Text } });
            if (stadium.Count == 0)
            {
                StadiumDoesnotExist.Visible = true;
                return;
            }
            if (managers.Count == 0)
            {
                NoManager.Visible = true;
                return;
            }
            var club = DbHelper.RunQuery("SELECT club_name FROM allClubRepresentatives WHERE username = @username",
                new Dictionary<string, object>() { { "@username", Session["username"].ToString() } });
            var matches = DbHelper.RunQuery("SELECT * FROM allMatches WHERE host = @club and start_time = @date",
                new Dictionary<string, object>() { { "@club", club[0]["club_name"] }, { "@date", StartDateTime.Text } }); 
            if (matches.Count == 0)
            {
                MatchDoesNotExist.Visible = true;
                return;
            }
             DbHelper.RunStoredProcedure("addHostRequest",
                new Dictionary<string, object>() { { "@clubName", club[0]["club_name"] }, { "@stadiumName", StadiumName.Text }, { "@startTime", StartDateTime.Text } });
            Sucessfally.Visible = true;
        }
    }
}