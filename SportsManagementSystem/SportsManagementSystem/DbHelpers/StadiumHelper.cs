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
            return DbHelper.ConvertToTable(DbHelper.RunQuery("SELECT * FROM allStadiums"));
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
    }
}