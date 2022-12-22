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
            DuplicateUsername.Visible = false;
            DuplicateClub.Visible = false;
            ClubAlreadyHaveRepresentative.Visible = false;
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            // name, username, a password, national id number, phone number,birth date and an address
            if (Name.Text == "" || Username.Text == "" || Password.Text == "" || ClubName.Text == "")
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


            var clubs = DbHelper.RunQuery(
                "SELECT * FROM allClubs WHERE name = @ClubName",
                new Dictionary<string, object>()
                {
                    { "@ClubName", ClubName.Text }
                }
            );

            if (clubs.Count == 0)
            {
                DuplicateClub.Visible = true;
                return;
            }
            var clubsReserved = DbHelper.RunQuery(
                "SELECT * FROM allClubRepresentatives WHERE club_name = @ClubName",
                new Dictionary<string, object>()
                {
                             { "@ClubName", ClubName.Text }
                }

            );
            if (clubsReserved.Count > 0)
            {
                ClubAlreadyHaveRepresentative.Visible = true;
                return;

            }
            //           @representive_name VARCHAR(20),
            //@club_name VARCHAR(20),
            //@username VARCHAR(20),
            //@password VARCHAR(20)
            DbHelper.RunStoredProcedure("addRepresentative", new Dictionary<string, object>()
            {
                { "@representive_name ", Name.Text },
                { "@username", Username.Text },
                { "@password", Password.Text },
                { "@club_name", ClubName.Text },
            });

            Session["Username"] = Username.Text;

            Response.Redirect("/Default.aspx");
        }
    }



}