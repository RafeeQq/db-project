using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.StadiumManager
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var manager = DbHelper.RunQuery("SELECT allstadiums.name AS Stadium_Name, allstadiums.location As Location, allstadiums.capacity AS Capacity, allstadiums.status AS Status FROM allStadiumManagers INNER JOIN allStadiums ON" +
                                            " allStadiums.name = allStadiumManagers.stadium_name WHERE allStadiumManagers.username = @username",
                new Dictionary<string, object>()
                {
                    { "@username", Session["Username"] }
                }
                );


            StadiumInfo.DataSource = DbHelper.ConvertToTable(manager);
            StadiumInfo.DataBind();
        }
    }
}