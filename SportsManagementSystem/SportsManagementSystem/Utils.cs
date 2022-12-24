using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SportsManagementSystem
{
    public static class Utils
    {
        public static bool IsValidDate(string date)
        {
            return DateTime.TryParseExact(
                date,
                "yyyy-MM-dd HH:mm:ss",
                null,
                System.Globalization.DateTimeStyles.None, out _
            );
        }

        public static bool IsNumber(string str)
        {
            return int.TryParse(str, out _);
        }
    }
}