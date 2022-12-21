using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class Default : System.Web.UI.Page
    {
        public List<Dictionary<string, object>> Clubs = new List<Dictionary<string, object>>();
        
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}