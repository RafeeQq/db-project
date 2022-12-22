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
            DuplicateUsername.Visible = false;
            DuplicateStadium.Visible = false;
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            // name, username, a password, national id number, phone number,birth date and an address
            if (Name.Text == "" || Username.Text == "" || Password.Text == "" || StadiumName.Text == "0")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }
            var users = DbHelper.RunQuery(
                "SELECT * FROM SystemUser WHERE username = @username",
                new Dictionary<string, object>()
                {
                    { "@username", Username.Text }
                }
            );

            if (users.Count > 0)
            {
                DuplicateUsername.Visible = true;
                return;
            }

            DbHelper.RunStoredProcedure("addAssociationManager", new Dictionary<string, object>()
            {
                { "@name", Name.Text },
                { "@username", Username.Text },
                { "@password", Password.Text },
            });

            Session["Username"] = Username.Text;

            Response.Redirect("/Default.aspx");

        }
    }
}