using System;

namespace SportsManagementSystem
{
    public partial class User : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("/Auth/Login.aspx");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            var role = DbHelper.GetRole(Session["Username"].ToString());
            CurrentUserDropdown.InnerText = Session["Username"] + " (" + role + ")";
        }

        protected void LogoutBtn_Click(object sender, EventArgs e)
        {
            Session["Username"] = null;
            Response.Redirect("/Auth/Login.aspx");
        }
    }
}