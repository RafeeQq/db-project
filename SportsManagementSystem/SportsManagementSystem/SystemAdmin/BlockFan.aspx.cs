using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class BlockFan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            NoFanFoundMsg.Visible = false;
            NationalIdMustBeNumberMsg.Visible = false;
        }

        protected void BlockFanBtn_Click(object sender, EventArgs e)
        {
            if (FanNationalId.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!Utils.IsNumber(FanNationalId.Text))
            {
                NationalIdMustBeNumberMsg.Visible = true;
                return;
            }

            if (!FanHelper.Exists(FanNationalId.Text))
            {
                NoFanFoundMsg.Visible = true;
                return;
            }

            FanHelper.Block(FanNationalId.Text);

            Response.Redirect("/SystemAdmin/Fans.aspx");
        }

    }
}