using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Graphs4Social_AR;

public partial class Pesquisar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void pesquisarUser_Click(object sender, EventArgs e)
    {
        if(!(TextBox1.Text.Equals("")))
        {
            Graphs4Social_AR.User u = Graphs4Social_AR.User.LoadByUserName(TextBox1.Text);
            if(u==null)
            {
                Label1.Visible = true;
            }
            else
            {
                Label1.Visible = false;
                
                //Fazer
                //Response.Redirect("Link do profile do amigo");
            }
        }
    }
}