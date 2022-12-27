using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SportsManagementSystem.DbHelpers
{
    public static class HostRequestHelper
    {
        public static DataTable AllPendingRequests(string stadiumManagerUsername)
        {
            var requests = DbHelper.RunQuery("SELECT * FROM dbo.allPendingRequests(@Username)", new { Username = stadiumManagerUsername });

            return DbHelper.ConvertToTable(requests);
        }

        public static DataTable AllPendingRequestsForCurrentUser()
        {
            return AllPendingRequests(AuthHelper.GetCurrentUsername());
        }

        public static bool Exists(string stadiumManagerUsername, string hostClubName, string guestClubName, string startTime)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM allPendingRequests(@Username) WHERE host_club_name = @HostClubName AND guest_club_name = @GuestClubName AND start_time = @StartTime",
                new
                {
                    Username = stadiumManagerUsername,
                    HostClubName = hostClubName,
                    GuestClubName = guestClubName,
                    StartTime = Utils.FormatDate(startTime)
                }
            );
        }

        public static void AcceptRequest(string stadiumManagerUsername, string hostClubName, string guestClubName, string startTime)
        {
            DbHelper.RunStoredProcedure("acceptRequest", new
            {
                stadium_manager_username = stadiumManagerUsername,
                host_club = hostClubName,
                guest_club = guestClubName,
                date = startTime
            });
        }

        public static void RejectRequest(string stadiumManagerUsername, string hostClubName, string guestClubName, string startTime)
        {
            DbHelper.RunStoredProcedure("rejectRequest", new
            {
                m = stadiumManagerUsername,
                h = hostClubName,
                g = guestClubName,
                d = startTime
            });
        }

        public static void SendRequest(string hostClubName, string stadiumName, string startTime)
        {
            DbHelper.RunStoredProcedure(
                "addHostRequest",
                new { clubName = hostClubName, stadiumName, startTime = Utils.FormatDate(startTime) }
            );
        }

        public static bool IsHandled(string stadiumManagerUsername, string hostClubName, string guestClubName, string startTime)
        {
            return DbHelper.CheckExists(
                "SELECT * FROM allPendingRequests(@Username) WHERE host_club_name = @HostClubName AND guest_club_name = @GuestClubName AND start_time = @StartTime and status <> 'unhandled'",
                new
                {
                    Username = stadiumManagerUsername,
                    HostClubName = hostClubName,
                    GuestClubName = guestClubName,
                    StartTime = Utils.FormatDate(startTime)
                }
            );
        }
    }
}