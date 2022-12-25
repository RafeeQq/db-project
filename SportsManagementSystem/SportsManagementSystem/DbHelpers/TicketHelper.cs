using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SportsManagementSystem.DbHelpers
{
    public class TicketHelper
    {
        public static DataTable TicketsForCurrentUser()
        {
            var tickets = DbHelper.RunQuery(
                @"
                SELECT 
                    C1.name AS host_club_name, 
                    C2.name AS guest_club_name, 
                    S.name AS stadium_name, 
                    M.start_time
                FROM 
                    Ticket T
                    INNER JOIN Match M ON T.match_id = M.id
                    INNER JOIN Club C1 ON M.host_club_id = C1.id
                    INNER JOIN Club C2 ON M.guest_club_id = C2.id
                    INNER JOIN TicketBuyingTransactions TBT ON TBT.ticket_id = T.id
                    INNER JOIN Fan F ON TBT.fan_national_id = F.national_id
                    LEFT OUTER JOIN Stadium S ON M.stadium_id = S.id
                WHERE F.username = @Username",
                new { Username = AuthHelper.GetCurrentUsername() }
            );

            return DbHelper.ConvertToTable(tickets);
        }

        public static void Purchase(string hostClub, string guestClub, string startTime)
        {
            DbHelper.RunStoredProcedure(
                "purchaseTicket",
                new
                {
                    fan_national_id = FanHelper.GetNationalIdForCurrentUser(),
                    host_club_name = hostClub,
                    guest_club_name = guestClub,
                    match_start_time = Utils.FormatDate(startTime)
                }
            );

        }

    }
}