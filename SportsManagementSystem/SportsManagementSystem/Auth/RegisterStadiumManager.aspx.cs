using SportsManagementSystem.DbHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.Auth
{
    public partial class RegisterStadiumManager : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            DuplicateUsername.Visible = false;
            DuplicateStadiumManager.Visible = false;

            if (!Page.IsPostBack)
            {
                StadiumName.DataSource = StadiumHelper.All();
                StadiumName.DataBind();
            }
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            // name, username, a password, national id number, phone number,birth date and an address
            if (Name.Text == "" || Username.Text == "" || Password.Text == "" || StadiumName.SelectedValue == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (AuthHelper.UsernameExists(Username.Text))
            {
                DuplicateUsername.Visible = true;
                return;
            }


            if (StadiumManagerHelper.ExistsForStadium(StadiumName.SelectedValue))
            {
                DuplicateStadiumManager.Visible = true;
                return;
            }

            StadiumManagerHelper.Add(Name.Text, Username.Text, Password.Text, StadiumName.SelectedValue);

            Session["Username"] = Username.Text;

            Response.Redirect("/Default.aspx");

        }
    }
}