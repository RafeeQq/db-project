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
    public partial class RegisterFan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            DuplicateUsername.Visible = false;
            DuplicateNationalId.Visible = false;
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            // name, username, a password, national id number, phone number,birth date and an address
            if (Name.Text == "" || Username.Text == "" || Password.Text == "" || NationalId.Text == "" || PhoneNumber.Text == "" || BirthDate.Text == "" || Address.Text == "")
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


            var fans = DbHelper.RunQuery(
                "SELECT * FROM allFans WHERE national_id = @national_id",
                new Dictionary<string, object>()
                {
                    { "@national_id", NationalId.Text }
                }
            );

            if (fans.Count > 0)
            {
                DuplicateNationalId.Visible = true;
                return;
            }

            DbHelper.RunStoredProcedure("addFan", new Dictionary<string, object>()
            {
                { "@fan_name", Name.Text },
                { "@username", Username.Text },
                { "@password", Password.Text },
                { "@national_id_number", NationalId.Text },
                { "@birth_date", BirthDate.Text },
                { "@address", Address.Text },
                { "@phone_number", PhoneNumber.Text }
            });

            Session["Username"] = Username.Text;

            Response.Redirect("/Default.aspx");
        }
    }
}