using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class DeleteStadium : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            NoStadiumFoundMsg.Visible = false;
        }

        protected void DeleteStadiumBtn_Click(object sender, EventArgs e)
        {
            if (StadiumName.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            var clubs = DbHelper.RunQuery("SELECT * FROM allStadiums WHERE name = @name", new Dictionary<string, object>
            {
                {"@name", StadiumName.Text}
            });

            if (clubs.Count == 0)
            {
                NoStadiumFoundMsg.Visible = true;
                return;
            }

            DbHelper.RunStoredProcedure(
                "deleteStadium",
                new Dictionary<string, object>
                {
                    {"@n", StadiumName.Text},
                }
            );

            Response.Redirect("/SystemAdmin/Stadiums.aspx");
        }
    }
}