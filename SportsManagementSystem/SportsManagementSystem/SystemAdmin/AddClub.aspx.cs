using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class AddClub : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            ClubAlreadyExistsMsg.Visible = false;
        }

        protected void AddClubBtn_Click(object sender, EventArgs e)
        {
            if (ClubName.Text == "" || ClubLocation.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (ClubHelper.Exists(ClubName.Text))
            {
                ClubAlreadyExistsMsg.Visible = true;
                return;
            }

            ClubHelper.Add(ClubName.Text, ClubLocation.Text);

            Response.Redirect("/SystemAdmin/Default.aspx");
        }
    }
}