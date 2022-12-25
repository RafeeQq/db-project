using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class Fans : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            FansTable.DataSource = FanHelper.All();
            FansTable.DataBind();
        }

        protected void FansTable_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Block")
            {
                var i = Convert.ToInt32(e.CommandArgument);
                var nationalId = (string)FansTable.DataKeys[i]["national_id"];

                FanHelper.Block(nationalId);

                Response.Redirect("/SystemAdmin/Fans.aspx");
            }
        }
    }
}