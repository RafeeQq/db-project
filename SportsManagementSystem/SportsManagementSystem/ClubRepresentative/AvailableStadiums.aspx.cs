using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.ClubRepresentative
{
    public partial class AvailableStadiums : System.Web.UI.Page
    {
        protected void SearchBtn_Click(object sender, EventArgs e)
        {
            var stadiums = DbHelper.RunQuery("SELECT * FROM viewAvailableStadiumsOn (@date)" ,
                new Dictionary<string, object>() { { "@date",startDateTime.Text} });
            StadiumTable.DataSource = DbHelper.ConvertToTable(stadiums);
            StadiumTable.DataBind();
        }
    }
}