using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.ClubRepresentative
{
    public partial class AvailableStadiums : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InvalidDateFormatMsg.Visible = false;
            EmptyFieldsMsg.Visible = false;
        }

        protected void SearchBtn_Click(object sender, EventArgs e)
        {
            if (StartDateTime.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!Utils.IsValidDate(StartDateTime.Text))
            {
                InvalidDateFormatMsg.Visible = true;
                return;
            }
            
            StadiumTable.DataSource = StadiumHelper.AvailableStadiumsOn(StartDateTime.Text);
            StadiumTable.DataBind();
        }
    }
}