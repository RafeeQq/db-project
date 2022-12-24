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
    }
}