using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.Fan
{
    public partial class Fan : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!DbHelper.IsUserInRole(Session["Username"].ToString(), UserRole.Fan))
            {
                Response.Redirect("/Default.aspx");
            }
        }
    }
}