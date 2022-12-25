using SportsManagementSystem.DbHelpers;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;

namespace SportsManagementSystem.Auth
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InvalidCredientialsMsg.Visible = false;
            EmptyFieldsMsg.Visible = false;
        }

        protected void LoginBtn_Click(object sender, EventArgs e)
        {
            if (Username.Text == "" || Password.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (AuthHelper.CheckUsernameAndPassword(Username.Text, Password.Text))
            {
                Session["Username"] = Username.Text;
                Response.Redirect("/Default.aspx");
            }
            else
            {
                InvalidCredientialsMsg.Visible = true;
            }
        }
    }
}