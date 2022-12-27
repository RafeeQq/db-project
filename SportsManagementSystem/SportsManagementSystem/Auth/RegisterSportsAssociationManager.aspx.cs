using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.Auth
{
    public partial class RegisterSportsAssociationManager : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            DuplicateUsernameMsg.Visible = false;
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            // name, username, a password, national id number, phone number,birth date and an address
            if (Name.Text == "" || Username.Text == "" || Password.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }


            if (AuthHelper.UsernameExists(Username.Text))
            {
                DuplicateUsernameMsg.Visible = true;
                return;
            }

            SportsAssociationManagerHelper.Add(Name.Text, Username.Text, Password.Text);

            Session["Username"] = Username.Text;

            Response.Redirect("/Default.aspx");

        }
    }
}