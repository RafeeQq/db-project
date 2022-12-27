using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace SportsManagementSystem.DbHelpers
{
    public static class StadiumManagerHelper
    {
        public static DataTable All()
        {
            return DbHelper.ConvertToTable(DbHelper.RunQuery("SELECT * FROM allStadiumManagers"));
        }

        public static string GetUsernameOfStadiumManager(string stadiumName)
        {
            return (string)DbHelper.GetScalar(
                "SELECT username FROM allStadiumManagers WHERE stadium_name = @Stadium",
                new { Stadium = stadiumName }
            );
        }

        public static bool ExistsForStadium(string stadiumName)
        {
            return DbHelper.CheckExists(
               "SELECT * FROM allStadiumManagers WHERE stadium_name = @stadiumName",
               new { stadiumName }
           );
        }


        public static void Add(string name, string username, string password, string stadiumName)
        {
            DbHelper.RunStoredProcedure("addStadiumManager", new
            {
                name,
                username,
                password,
                stadiumName
            });
        }


        public static DataTable GetStadium(string managerUsername)
        {
            var stadiumName = (string)DbHelper.GetScalar(
                "SELECT stadium_name FROM allStadiumManagers WHERE username = @Username",
                new { Username = managerUsername }
            );

            return StadiumHelper.Get(stadiumName);
        }

        public static DataTable GetStadiumOfCurrentUser()
        {
            return GetStadium(AuthHelper.GetCurrentUsername());
        }
    }
}