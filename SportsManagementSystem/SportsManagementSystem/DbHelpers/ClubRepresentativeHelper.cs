using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace SportsManagementSystem.DbHelpers
{
    public static class ClubRepresentativeHelper
    {
        public static DataTable All()
        {
            var clubRepresentatives = DbHelper.RunQuery("SELECT * FROM allClubRepresentatives");

            return DbHelper.ConvertToTable(clubRepresentatives);
        }

        public static bool ExistsForClub(string clubName)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM allClubRepresentatives WHERE club_name = @ClubName",
                new { ClubName = clubName }
            );
        }

        public static void Add(string name, string username, string password, string clubName)
        {
            DbHelper.RunStoredProcedure("addRepresentative", new
            {
                representive_name = name,
                username = username,
                password = password,
                club_name = clubName
            });
        }

        public static DataTable GetClub(string representativeUsername)
        {
            var clubName = (string)DbHelper.GetScalar(
                "SELECT club_name FROM allClubRepresentatives WHERE username = @Username",
                new { Username = representativeUsername }
            );

            return ClubHelper.Get(clubName);
        }

        public static DataTable GetClubOfCurrentUser()
        {
            return GetClub(AuthHelper.GetCurrentUsername());
        }

        public static string GetClubNameOfCurrentUser()
        {
            var club = GetClubOfCurrentUser();

            return (string)club.Rows[0]["name"];
        }

        public static DataTable AllClubMatches()
        {
            return MatchHelper.AllForHostClub(GetClubNameOfCurrentUser());
        }

        public static DataTable AllSentHostRequests(string representativeUsername)
        {
            return DbHelper.ConvertToTable(DbHelper.RunQuery(
                "SELECT * FROM dbo.allHostRequestsForRepresentative(@Username)",
                new { Username = representativeUsername }
            ));
        }

        public static DataTable AllSentHostRequestsOfCurrentUser()
        {
            return AllSentHostRequests(AuthHelper.GetCurrentUsername());
        }

        public static bool HasSentRequest(string representativeUsername, string stadiumName, string startTime)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM dbo.allHostRequestsForRepresentative(@Username) WHERE stadium_name = @Stadium AND start_time = @StartTime",
                new
                {
                    Username = representativeUsername,
                    Stadium = stadiumName,
                    StartTime = Utils.FormatDate(startTime)
                }
            );
        }

        public static DataTable AllUpcomingMatchesForCurrentUserClub()
        {
            return ClubHelper.AllUpcomingMatches(GetClubNameOfCurrentUser());
        }
    }
}