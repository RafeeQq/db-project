using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SportsManagementSystem.DbHelpers
{
    public static class AuthHelper
    {
        public static bool UsernameExists(string username)
        {
            return DbHelper.CheckExists("SELECT * FROM SystemUser WHERE username = @Username", new { Username = username });
        }

        public static bool CheckUsernameAndPassword(string username, string password)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM SystemUser WHERE Username = @username AND Password = @Password",
                new
                {
                    Username = username,
                    Password = password
                }
            );
        }

        public static string GetCurrentUsername()
        {
            return HttpContext.Current.Session["Username"].ToString();
        }
    }
}