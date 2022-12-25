using SportsManagementSystem.DbHelpers;
using System;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ClubsTable.DataSource = ClubHelper.All();
            ClubsTable.DataBind();
        }

        protected void ClubsTable_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteClub")
            {
                var i = Convert.ToInt32(e.CommandArgument);
                var clubName = (string)ClubsTable.DataKeys[i]["name"];

                ClubHelper.Delete(clubName);

                Response.Redirect("/SystemAdmin/Default.aspx");
            }
        }
    }
}