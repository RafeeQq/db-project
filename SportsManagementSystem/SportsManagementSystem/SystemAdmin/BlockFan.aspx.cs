using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class BlockFan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            NoFanFoundMsg.Visible = false;
        }

        protected void BlockFanBtn_Click(object sender, EventArgs e)
        {
            if (FanNationalId.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            var fans = DbHelper.RunQuery("SELECT * FROM allFans WHERE national_id = @national_id", new Dictionary<string, object>
            {
                {"@national_id", FanNationalId.Text}
            });

            if (fans.Count == 0)
            {
                NoFanFoundMsg.Visible = true;
                return;
            }
            
            
            DbHelper.RunStoredProcedure(
                "blockFan",
                new Dictionary<string, object>
                {
                    {"@national_id", FanNationalId.Text},
                }
            );

            Response.Redirect("/SystemAdmin/Fans.aspx");
        }

    }
}