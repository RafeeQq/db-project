using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class Already_Played_Matches : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var matches = DbHelper.RunQuery("SELECT * FROM allMatches WHERE end_time < CURRENT_TIMESTAMP");
            AlreadyPlayedMatchesTable.DataSource = DbHelper.ConvertToTable(matches);
            AlreadyPlayedMatchesTable.DataBind();
        }
    }
}