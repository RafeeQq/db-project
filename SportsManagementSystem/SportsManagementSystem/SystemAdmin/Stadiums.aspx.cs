using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class Stadiums : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var stadiums = DbHelper.RunQuery("SELECT * FROM allStadiums");

            StadiumTable.DataSource = DbHelper.ConvertToTable(stadiums);
            StadiumTable.DataBind();
        }
    }
}