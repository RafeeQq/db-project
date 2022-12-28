using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SportsManagementSystem.DbHelpers
{
    public static class StadiumHelper
    {
        public static bool Exists(string name)
        {
            return DbHelper.CheckExists("SELECT * FROM allStadiums WHERE name = @Name", new { Name = name });
        }

        public static DataTable All()
        {
            var table = DbHelper.ConvertToTable(DbHelper.RunQuery("SELECT * FROM allStadiums"));

            if (table.Rows.Count > 0)
            {
                table.Columns["status"].ColumnName = "available";
            }

            return table;
        }

        public static void Add(string name, string location, int capacity)
        {
            DbHelper.RunStoredProcedure(
                "addStadium",
                new
                {
                    stadium_name = name,
                    stadium_capacity = capacity,
                    stadium_location = location
                }
            );
        }

        public static void Delete(string name)
        {
            DbHelper.RunStoredProcedure("deleteStadium", new { n = name });
        }

        public static DataTable AvailableStadiumsOn(string date)
        {
            var stadiums = DbHelper.RunQuery("SELECT * FROM viewAvailableStadiumsOn(@Date)", new { Date = Utils.FormatDate(date) });

            return DbHelper.ConvertToTable(stadiums);
        }

        public static bool IsAvailable(string stadiumName)
        {
            return (bool)DbHelper.GetScalar("SELECT status FROM allStadiums WHERE name = @Name", new { Name = stadiumName });
        }

        public static bool IsAvailableDuringMatch(string stadiumName, string hostClubName, string startTime)
        {
            var endTime = (DateTime)DbHelper.GetScalar(
                "SELECT end_time FROM allMatches WHERE host = @Host AND start_time = @Start",
                new { Host = hostClubName, Start = Utils.FormatDate(startTime) }
            );

            return !DbHelper.CheckExists(
                "SELECT S.name FROM Stadium S INNER JOIN Match M ON M.stadium_id = S.id WHERE S.name = @Stadium AND NOT (M.start_time > @End OR @Start > M.end_time)",
                new
                {
                    Stadium = stadiumName,
                    Start = Utils.FormatDate(startTime),
                    End = Utils.FormatDate(endTime.ToString())
                }
            );
        }

        public static DataTable Get(object stadiumName)
        {
            var stadium = DbHelper.RunQuery("SELECT * FROM allStadiums WHERE name = @Name", new { Name = stadiumName });

            var table = DbHelper.ConvertToTable(stadium);

            table.Columns["status"].ColumnName = "available";

            return table;
        }
    }
}