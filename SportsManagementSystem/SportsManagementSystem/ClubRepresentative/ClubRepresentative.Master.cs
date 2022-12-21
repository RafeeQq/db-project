using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.ClubRepresentative
{
    public partial class ClubRepresentative : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!DbHelper.IsUserInRole(Session["Username"].ToString(), UserRole.ClubRepresentative))
            {
                Response.Redirect("/Default.aspx");
            }
        }
    }
}