using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SportsManagementSystem.DbHelpers
{
    public static class ClubHelper
    {
        public static bool Exists(string name)
        {
            return DbHelper.CheckExists("SELECT * FROM allClubs WHERE name = @Name", new { Name = name });
        }

        public static DataTable All()
        {
            return DbHelper.ConvertToTable(DbHelper.RunQuery("SELECT * FROM allClubs"));
        }

        public static DataTable AllNeverMatchedClubs()
        {
            var clubs = DbHelper.RunQuery("SELECT * FROM clubsNeverMatched");

            return DbHelper.ConvertToTable(clubs);
        }

        public static void Add(string name, string location)
        {
            DbHelper.RunStoredProcedure(
                "addClub",
                new
                {
                    club_name = name,
                    club_location = location
                }
            );
        }

        public static void Delete(string name)
        {
            DbHelper.RunStoredProcedure(
                "deleteClub",
                new
                {
                    club_name = name
                }
            );
        }

        public static DataTable Get(string clubName)
        {
            return DbHelper.ConvertToTable(DbHelper.RunQuery("SELECT * FROM allClubs WHERE name = @Name", new { Name = clubName }));
        }

        public static DataTable AllUpcomingMatches(string clubName)
        {
            var matches = DbHelper.RunQuery(
                "SELECT * FROM upcomingMatchesOfClub(@Club)",
                new { Club = clubName }
            );


            return DbHelper.ConvertToTable(matches);
        }
    }
}