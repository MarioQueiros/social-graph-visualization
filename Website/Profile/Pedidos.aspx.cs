using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Graphs4Social_AR;

public partial class Profile_Pedidos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            BindGridView();

        }
    }

    public void BindGridView()
    {
        GridView1.DataSource = Graphs4Social_AR.User.LoadAllPedidosUser(Profile.UserName);
        GridView1.DataBind();
    }


    protected void GridView1_RowCommand1(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Rejeitar")
        {
            GridViewRow gvr = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);
            int rowIndex = gvr.RowIndex;

            

        }
        else if (e.CommandName == "Aceitar")
        {
            GridViewRow gvr = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);
            int rowIndex = gvr.RowIndex;



        }
    }
}