using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Xml.Linq;

namespace SportsManagementSystem.DbHelpers
{
    public static class FanHelper
    {
        public static DataTable All()
        {
            var table = DbHelper.ConvertToTable(DbHelper.RunQuery("SELECT * FROM allFans"));

            if (table.Rows.Count > 0)
            {
                table.Columns["status"].ColumnName = "not blocked";
            }

            return table;
        }

        public static bool Exists(string nationalId)
        {
            return DbHelper.CheckExists("SELECT * FROM allFans WHERE national_id = @NationalId", new { NationalId = nationalId });
        }

        public static void Add(string name, string username, string password, string nationalId, string birthDate, string address, string phoneNumber)
        {
            DbHelper.RunStoredProcedure("addFan", new
            {
                fan_name = name,
                username = username,
                password = password,
                national_id_number = nationalId,
                birth_date = Utils.FormatDate(birthDate),
                address = address,
                phone_number = phoneNumber
            });
        }

        public static void Block(string nationalId)
        {
            DbHelper.RunStoredProcedure(
                "blockFan",
                new
                {
                    @national_id = nationalId
                }
            );
        }

        public static bool IsBlocked(string username)
        {
            return !(bool)DbHelper.GetScalar(
                "SELECT status FROM allFans WHERE username = @Username",
                new
                {
                    Username = username
                }
            );
        }

        public static bool IsCurrentUserBlocked()
        {
            return IsBlocked(AuthHelper.GetCurrentUsername());
        }

        public static string GetNationalId(string username)
        {
            return (string)DbHelper.GetScalar("SELECT national_id FROM allFans WHERE username = @Username", new { Username = username });
        }

        public static string GetNationalIdForCurrentUser()
        {
            return GetNationalId(AuthHelper.GetCurrentUsername());
        }
    }
}