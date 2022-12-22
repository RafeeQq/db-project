using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.SystemAdmin
{
    public partial class Fans : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var fans = DbHelper.RunQuery("SELECT * FROM allStadiums");

            FansTable.DataSource = DbHelper.ConvertToTable(fans);
            FansTable.DataBind();
        }
    }
}