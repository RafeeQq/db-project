using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class ClubsNeverMatched : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ClubsNeverMatchedTable.DataSource = ClubHelper.AllNeverMatchedClubs();
            ClubsNeverMatchedTable.DataBind();
        }
    }
}