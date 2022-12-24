using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace SportsManagementSystem
{
    public static class Utils
    {
        public static bool IsValidDate(string date)
        {
            return DateTime.TryParse(
                date,
                out _
            );
        }

        public static string FormatDate(string date)
        {
            return DateTime.Parse(date).ToString("yyyy-MM-dd HH:mm:ss");
        }

        public static bool IsNumber(string str)
        {
            return Regex.IsMatch(str, @"^\d+$");
        }
    }
}