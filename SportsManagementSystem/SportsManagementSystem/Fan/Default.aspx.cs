using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SportsManagementSystem.Fan
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            EmptyFieldsMsg.Visible = false;
        }

        protected void SearchBtn_Click(object sender, EventArgs e)
        {
            if (Date.Text == "")
            {
                EmptyFieldsMsg.Visible = true;
            }

            var matches = DbHelper.RunQuery("SELECT * FROM availableMatchesToAttend(@date)", new Dictionary<string, object>() { { "@date", Date.Text } });

            MatchesTable.DataSource = DbHelper.ConvertToTable(matches);
            MatchesTable.DataBind();
        }
    }
}