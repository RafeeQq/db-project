using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace SportsManagementSystem.Auth
{
    public partial class RegisterClubRepresentative : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            DuplicateUsernameMsg.Visible = false;
            ClubAlreadyHaveRepresentativeMsg.Visible = false;


            if (!Page.IsPostBack)
            {
                ClubName.DataSource = ClubHelper.All();
                ClubName.DataBind(); ;
            }
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            if (Name.Text == "" || Username.Text == "" || Password.Text == "" || ClubName.SelectedValue == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (AuthHelper.UsernameExists(Username.Text))
            {
                DuplicateUsernameMsg.Visible = true;
                return;
            }

            if (ClubRepresentativeHelper.ExistsForClub(ClubName.SelectedValue))
            {
                ClubAlreadyHaveRepresentativeMsg.Visible = true;
                return;

            }

            ClubRepresentativeHelper.Add(Name.Text, Username.Text, Password.Text, ClubName.Text);

            Session["Username"] = Username.Text;

            Response.Redirect("/Default.aspx");
        }
    }



}