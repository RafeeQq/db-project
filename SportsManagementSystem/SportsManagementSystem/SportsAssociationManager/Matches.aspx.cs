using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class Matches : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void UpcomingMatches_Click(object sender, EventArgs e)
        {
          
            Response.Redirect("/SportsAssociationManager/UpcomingMatches.aspx");
        }

        protected void AlreadyPlayedMatches_Click(object sender, EventArgs e)
        {
            Response.Redirect("/SportsAssociationManager/AlreadyPlayedMatches.aspx");
        }

        protected void ClubsNeverMatched_Click(object sender, EventArgs e)
        {
            Response.Redirect("/SportsAssociationManager/ClubsNeverMatched.aspx");
        }

        protected void AddMatch_Click(object sender, EventArgs e)
        {
            Response.Redirect("/SportsAssociationManager/AddMatch.aspx");
        }
    }
}