using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Xml.Linq;

namespace SportsManagementSystem.DbHelpers
{
    public static class MatchHelper
    {
        public static DataTable All()
        {
            return DbHelper.ConvertToTable(DbHelper.RunQuery("SELECT * FROM allMatches"));
        }

        public static void Add(string host, string guest, string startTime, string endTime)
        {
            DbHelper.RunStoredProcedure(
               "addNewMatch",
               new
               {
                   host,
                   guest,
                   start_time = Utils.FormatDate(startTime),
                   end_time = Utils.FormatDate(endTime)
               }
           );
        }

        public static DataTable AllUpcomingMatches()
        {
            var matches = DbHelper.RunQuery("SELECT * FROM allMatches WHERE start_time >= CURRENT_TIMESTAMP");

            return DbHelper.ConvertToTable(matches);
        }

        public static DataTable AllAlreadyPlayedMatches()
        {
            var matches = DbHelper.RunQuery("SELECT * FROM allMatches WHERE end_time < CURRENT_TIMESTAMP");

            return DbHelper.ConvertToTable(matches);
        }

        public static DataTable AllForHostClub(string hostClub)
        {
            return DbHelper.ConvertToTable(DbHelper.RunQuery(
                "SELECT * FROM allMatches WHERE host = @HostClubName",
                new { HostClubName = hostClub }
            ));
        }

        public static DataTable AllAvailableMatchesToAttendStartingFrom(string datetime)
        {
            return DbHelper.ConvertToTable(
                DbHelper.RunQuery(
                    "SELECT * FROM availableMatchesToAttend(@Date)",
                    new { Date = Utils.FormatDate(datetime) }
                )
            );
        }

        public static bool Exists(string hostClub, string guestClub, string startTime)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM allMatches WHERE host = @HostClubName AND guest = @GuestClubName AND start_time = @MatchStartTime",
                new
                {
                    HostClubName = hostClub,
                    GuestClubName = guestClub,
                    MatchStartTime = Utils.FormatDate(startTime)
                }
            );
        }

        public static bool Exists(string host, string guest, string start, string end)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM allMatches WHERE host = @host AND guest = @guest AND start_time = @start AND end_time = @end",
                new { host, guest, start = Utils.FormatDate(start), end = Utils.FormatDate(end) }
            );
        }

        public static bool HasAvailableTickets(string hostClub, string guestClub, string startTime)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM allTickets WHERE host_club_name = @HostClubName AND guest_club_name = @GuestClubName AND start_time = @MatchStartTime AND status = 1",
                new
                {
                    HostClubName = hostClub,
                    GuestClubName = guestClub,
                    MatchStartTime = Utils.FormatDate(startTime)
                }
            );
        }

        public static void Delete(string host, string guest, string startTime, string endTime)
        {
            DbHelper.RunStoredProcedure(
               "deleteMatch",
               new
               {
                   host = host,
                   guest = guest,
                   start_time = Utils.FormatDate(startTime),
                   end_time = Utils.FormatDate(endTime)
               }
           );
        }

        public static bool HasStadium(string hostClubName, string startTime)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM upcomingMatchesOfClub(@Host) WHERE start_time = @StartTime AND stadium_name IS NOT NULL",
                new
                {
                    Host = hostClubName,
                    StartTime = Utils.FormatDate(startTime)
                }
            );
        }
    }
}