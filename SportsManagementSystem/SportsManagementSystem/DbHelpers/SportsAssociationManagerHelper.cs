using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace SportsManagementSystem.DbHelpers
{
    public static class SportsAssociationManagerHelper
    {
        public static void Add(string name, string username, string password)
        {
            DbHelper.RunStoredProcedure("addAssociationManager", new
            {
                name,
                username,
                password,
            });
        }
    }
}