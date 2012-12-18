using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Profile_Inicio : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string username = Request.QueryString["user"];

            IList<string> profile = Graphs4Social_AR.User.LoadProfileByUser(username);

            


        }
    }
}