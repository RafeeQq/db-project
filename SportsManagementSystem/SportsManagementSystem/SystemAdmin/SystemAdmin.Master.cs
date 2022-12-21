using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class SystemAdmin : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!DbHelper.IsUserInRole(Session["Username"].ToString(), UserRole.SystemAdmin))
            {
                Response.Redirect("/Default.aspx");
            }
        }
    }
}