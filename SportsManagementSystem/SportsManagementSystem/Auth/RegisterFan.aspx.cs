using SportsManagementSystem.DbHelpers;
using System;

namespace SportsManagementSystem.Auth
{
    public partial class RegisterFan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
            NationalIdMustBeNumberMsg.Visible = false;
            PhoneNumberMustBeNumberMsg.Visible = false;
            InvalidDateFormatMsg.Visible = false;
            DuplicateUsernameMsg.Visible = false;
            DuplicateNationalIdMsg.Visible = false;
        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            if (Name.Text == "" || Username.Text == "" || Password.Text == "" || NationalId.Text == "" || PhoneNumber.Text == "" || BirthDate.Text == "" || Address.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
                return;
            }

            if (!Utils.IsNumber(NationalId.Text))
            {
                NationalIdMustBeNumberMsg.Visible = true;
                return;
            }

            if (!Utils.IsNumber(PhoneNumber.Text))
            {
                PhoneNumberMustBeNumberMsg.Visible = true;
                return;
            }

            if (!Utils.IsValidDate(BirthDate.Text))
            {
                InvalidDateFormatMsg.Visible = true;
                return;
            }
            
            if (AuthHelper.UsernameExists(Username.Text))
            {
                DuplicateUsernameMsg.Visible = true;
                return;
            }
            
            if (FanHelper.Exists(NationalId.Text))
            {
                DuplicateNationalIdMsg.Visible = true;
                return;
            }

            FanHelper.Add(
                Name.Text,
                Username.Text,
                Password.Text,
                NationalId.Text,
                BirthDate.Text,
                Address.Text,
                PhoneNumber.Text
            );
            
            Session["Username"] = Username.Text;

            Response.Redirect("/Default.aspx");
        }
    }
}