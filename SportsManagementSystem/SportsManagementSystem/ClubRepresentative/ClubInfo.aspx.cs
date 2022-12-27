using SportsManagementSystem.DbHelpers;
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
            ClubTable.DataSource = ClubRepresentativeHelper.GetClubOfCurrentUser();
            ClubTable.DataBind();
        }
    }
}