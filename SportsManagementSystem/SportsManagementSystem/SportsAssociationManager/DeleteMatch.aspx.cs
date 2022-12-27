using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SportsAssociationManager
{
    public partial class DeleteMatch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            MatchDoesNotExist.Visible = false;
            InvalidDateFormatMsg.Visible = false;

            if (!Page.IsPostBack)
            {
                HostClub.DataSource = ClubHelper.All();
                GuestClub.DataSource = ClubHelper.All();
                HostClub.DataBind();
                GuestClub.DataBind();
            }
        }

        protected void DeleteMatchBtn_Click(object sender, EventArgs e)
        {

            if (StartTime.Text == "" || EndTime.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!Utils.IsValidDate(StartTime.Text) || !Utils.IsValidDate(EndTime.Text))
            {
                InvalidDateFormatMsg.Visible = true;
                return;
            }

            if (!MatchHelper.Exists(HostClub.Text, GuestClub.Text, StartTime.Text, EndTime.Text))
            {
                MatchDoesNotExist.Visible = true;
                return;
            }

            MatchHelper.Delete(HostClub.Text, GuestClub.Text, StartTime.Text, EndTime.Text);

            Response.Redirect("/SportsAssociationManager/Default.aspx");
        }
    }
}