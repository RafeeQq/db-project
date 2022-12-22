using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class Upcoming_Matches : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var matches = DbHelper.RunQuery("SELECT * FROM Match WHERE start_date > CURRENT_TIMESTAMP");
            UpcomingMatchesTable.DataSource = DbHelper.ConvertToTable(matches);
            UpcomingMatchesTable.DataBind();
        }
    }
}