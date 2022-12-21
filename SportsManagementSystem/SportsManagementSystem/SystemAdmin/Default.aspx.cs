using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var clubs = DbHelper.RunQuery("SELECT * FROM allClubs");
            
            ClubsTable.DataSource = DbHelper.ConvertToTable(clubs);
            ClubsTable.DataBind();
        }
    }
}