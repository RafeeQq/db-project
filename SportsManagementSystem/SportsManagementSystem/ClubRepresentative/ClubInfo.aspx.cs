using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.ClubRepresentative
{
    public partial class ClubInfo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var clubInfo = DbHelper.RunQuery("SELECT AC.*" +
                " FROM  allCLubs AC , allClubRepresentatives ACR " +
                "WHERE AC.name =ACR.club_name AND ACR.username = @username",
                new Dictionary<string, object>() { { "@username", Session["username"] } });
            ClubTable.DataSource = DbHelper.ConvertToTable(clubInfo);
            ClubTable.DataBind();
        }
    }
}