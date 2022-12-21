using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class DeleteClub : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            NoClubFoundMsg.Visible = false;
        }

        protected void AddClubBtn_Click(object sender, EventArgs e)
        {
            if (ClubName.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            var clubs = DbHelper.RunQuery("SELECT * FROM allClubs WHERE name = @name", new Dictionary<string, object>
            {
                {"@name", ClubName.Text}
            });

            if (clubs.Count == 0)
            {
                NoClubFoundMsg.Visible = true;
                return;
            }

            DbHelper.RunStoredProcedure(
                "deleteClub",
                new Dictionary<string, object>
                {
                    {"@club_name", ClubName.Text},
                }
            );

            Response.Redirect("/SystemAdmin/Default.aspx");
        }
    }
}