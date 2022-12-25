using SportsManagementSystem.DbHelpers;
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
            StadiumsTable.DataSource = StadiumHelper.All();
            StadiumsTable.DataBind();
        }

        protected void StadiumsTable_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteStadium")
            {
                var i = Convert.ToInt32(e.CommandArgument);
                var stadiumName = (string) StadiumsTable.DataKeys[i]["name"];
                
                StadiumHelper.Delete(stadiumName);
                
                Response.Redirect("/SystemAdmin/Stadiums.aspx");
            }
        }
    }
}