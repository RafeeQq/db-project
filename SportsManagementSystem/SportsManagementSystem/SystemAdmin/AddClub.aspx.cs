using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class AddClub : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
        }

        protected void AddClubBtn_Click(object sender, EventArgs e)
        {
            if (ClubName.Text == "" || ClubLocation.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            DbHelper.RunStoredProcedure(
                "addClub",
                new Dictionary<string, object>
                {
                    {"@club_name", ClubName.Text},
                    {"@club_location", ClubLocation.Text}
                }
            );

            Response.Redirect("/SystemAdmin/Default.aspx");
        }
    }
}