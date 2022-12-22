using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class AddStadium : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
        }

        protected void AddStadiumBtn_Click(object sender, EventArgs e)
        {
            /*
             * 	@stadium_name VARCHAR(20),
	@stadium_location VARCHAR(20),
	@stadium_capacity INT
*/
            if (StadiumName.Text == "" || StadiumLocation.Text == "" || StadiumCapacity.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            DbHelper.RunStoredProcedure(
                "addStadium",
                new Dictionary<string, object>()
                {
                    {"@stadium_name", StadiumName.Text},
                    {"@stadium_capacity", StadiumCapacity.Text},
                    {"@stadium_location", StadiumLocation.Text}
                }
            );

            Response.Redirect("/SystemAdmin/Stadiums.aspx");
        }
    }
}