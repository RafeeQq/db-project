using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class DeleteStadium : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            NoStadiumFoundMsg.Visible = false;
        }

        protected void DeleteStadiumBtn_Click(object sender, EventArgs e)
        {
            if (StadiumName.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!StadiumHelper.Exists(StadiumName.Text))
            {
                NoStadiumFoundMsg.Visible = true;
                return;
            }

            StadiumHelper.Delete(StadiumName.Text);

            Response.Redirect("/SystemAdmin/Stadiums.aspx");
        }
    }
}