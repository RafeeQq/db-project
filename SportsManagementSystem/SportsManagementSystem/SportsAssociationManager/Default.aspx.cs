using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UpcomingMatchesTable.DataSource = MatchHelper.AllUpcomingMatches();
            UpcomingMatchesTable.DataBind();

            AllMatchesTable.DataSource = MatchHelper.All();
            AllMatchesTable.DataBind();

            AlreadyPlayedMatchesTable.DataSource = MatchHelper.AllAlreadyPlayedMatches();
            AlreadyPlayedMatchesTable.DataBind();
        }
        
        protected void AllMatchesTable_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteMatch")
            {
                int i = Convert.ToInt32(e.CommandArgument);
                var host = (string)AllMatchesTable.DataKeys[i]["host"];
                var guest = (string)AllMatchesTable.DataKeys[i]["guest"];
                var startTime = (string)AllMatchesTable.DataKeys[i]["start_time"];
                var endTime = (string)AllMatchesTable.DataKeys[i]["end_time"];

                MatchHelper.Delete(host, guest, startTime, endTime);

                Response.Redirect("/SportsAssociationManager/Default.aspx");
            }
        }
    }
}