using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class DeleteMatch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
        }

        protected void DeleteMatchBtn_Click(object sender, EventArgs e)
        {
            if (HostName.Text == "" || GuestName.Text == "" || StartTime.Text == "" || EndTime.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            DbHelper.RunStoredProcedure(
               "deleteMatch",
               new Dictionary<string, object>
               {
                    {"@host", HostName.Text},
                    {"@guest", GuestName.Text},
                    {"@start_time", StartTime.Text},
                    {"@end_time", EndTime.Text}
               }
           );

            Response.Redirect("/SportsAssociationManager/Default.aspx");
        }
    }
}