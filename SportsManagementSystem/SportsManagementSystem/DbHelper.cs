using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace SportsManagementSystem
{
    public class DbHelper
    {
        public static string GetConnectionString()
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["Default"].ToString();
        }

        public static List<Dictionary<string, object>> RunQuery(string sql, Dictionary<string, object> parameters = null)
        {
            List<Dictionary<string, object>> results = new List<Dictionary<string, object>>();

            var conn = new SqlConnection(GetConnectionString());

            var cmd = new SqlCommand(sql, conn);

            if (parameters != null)
            {
                foreach (var paramInfo in parameters)
                {
                    cmd.Parameters.Add(new SqlParameter(paramInfo.Key, paramInfo.Value));
                }
            }

            conn.Open();

            using (var reader = cmd.ExecuteReader())
            {

                while (reader.Read())
                {
                    results.Add(Enumerable.Range(0, reader.FieldCount).ToDictionary(reader.GetName, reader.GetValue));
                }
            }

            conn.Close();

            return results;
        }

        public static void RunStoredProcedure(string sql, Dictionary<string, object> parameters = null)
        {
            var conn = new SqlConnection(GetConnectionString());

            var cmd = new SqlCommand(sql, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            if (parameters != null)
            {
                foreach (var paramInfo in parameters)
                {
                    cmd.Parameters.Add(new SqlParameter(paramInfo.Key, paramInfo.Value));
                }
            }

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        public static bool IsUserInRole(string username, UserRole role)
        {
            var results = RunQuery(
                "SELECT * FROM " + Enum.GetName(typeof(UserRole), role) + " WHERE username = @Username",
                new Dictionary<string, object>() {
                    { "Username", username }
                }
            );

            return results.Count() > 0;
        }

        public static string GetRole(string username)
        {
            foreach (var role in Enum.GetValues(typeof(UserRole)).Cast<UserRole>())
            {
                if (IsUserInRole(username, role))
                {
                    return Enum.GetName(typeof(UserRole), role);
                }
            }

            return "";
        }

        public static DataTable ConvertToTable(List<Dictionary<string, object>> data)
        {
            var table = new DataTable();

            if (data.Count() > 0)
            {
                foreach (var key in data[0].Keys)
                {
                    table.Columns.Add(key);
                }

                foreach (var row in data)
                {
                    var newRow = table.NewRow();

                    foreach (var key in row.Keys)
                    {
                        newRow[key] = row[key];
                    }

                    table.Rows.Add(newRow);
                }
            }

            return table;
        }

        public static List<Dictionary<string, object>> RunQuery(string sql, object parameters)
        {
            List<Dictionary<string, object>> results = new List<Dictionary<string, object>>();

            var conn = new SqlConnection(GetConnectionString());

            var cmd = new SqlCommand(sql, conn);

            if (parameters != null)
            {
                foreach (var property in parameters.GetType().GetProperties())
                {
                    cmd.Parameters.Add(new SqlParameter("@" + property.Name, property.GetValue(parameters)));
                }
            }

            conn.Open();

            using (var reader = cmd.ExecuteReader())
            {

                while (reader.Read())
                {
                    results.Add(Enumerable.Range(0, reader.FieldCount).ToDictionary(reader.GetName, reader.GetValue));
                }
            }

            conn.Close();

            return results;
        }

        public static bool CheckExists(string sql, object parameters)
        {
            var results = RunQuery(sql, parameters);

            return results.Count() > 0;
        }

        public static void RunStoredProcedure(string sql, object parameters = null)
        {
            var conn = new SqlConnection(GetConnectionString());

            var cmd = new SqlCommand(sql, conn);
            cmd.CommandType = CommandType.StoredProcedure;

            if (parameters != null)
            {
                foreach (var property in parameters.GetType().GetProperties())
                {
                    cmd.Parameters.Add(new SqlParameter("@" + property.Name, property.GetValue(parameters)));
                }
            }

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        public static object GetScalar(string sql, object parameters = null)
        {
            var results = RunQuery(sql, parameters);

            if (results.Count() > 0)
            {
                return results[0].Values.First();
            }

            return null;
        }
    }
}