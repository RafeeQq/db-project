using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class AddStadium : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            StadiumAlreadyExistsMsg.Visible = false;
            StadiumCapacityMustBeNumberMsg.Visible = false;
        }

        protected void AddStadiumBtn_Click(object sender, EventArgs e)
        {
            if (StadiumName.Text == "" || StadiumLocation.Text == "" || StadiumCapacity.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!Utils.IsNumber(StadiumCapacity.Text))
            {
                StadiumCapacityMustBeNumberMsg.Visible = true;
                return;
            }
            
            if (StadiumHelper.Exists(StadiumName.Text))
            {
                StadiumAlreadyExistsMsg.Visible = true;
                return;
            }

            StadiumHelper.Add(StadiumName.Text, StadiumLocation.Text, int.Parse(StadiumCapacity.Text));

            Response.Redirect("/SystemAdmin/Stadiums.aspx");
        }
    }
}