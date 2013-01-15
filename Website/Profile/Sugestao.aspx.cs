using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Resources;

public partial class Profile_Sugestao : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            carregaSugestao();
        }
    }

    private void carregaSugestao()
    {
        //throw new NotImplementedException();
        var proxy = new ModuloIA.ModuloIaClient();
        var nome = Profile.UserName.ToLower();

        var resposta = proxy.sugerirAmigos(nome);
        if(resposta=="no"||resposta=="[]")
        {
            GridView1.Visible = false;
        }else
        {
            var r = resposta.Replace('[', ' ');
            r = r.Replace(']', ' ');
            r =r.Trim();
            var t = r.Split(',');
            //var dt;
            IList<string> users = new List<string>();

            foreach (var user in t)
            {
                /*
                 * Carrega User e adiciona o seu nome à gridview
                 * dt.add(.....)
                 */
                users.Add(Graphs4Social_AR.User.LoadByUserName(user).Username);
            }

            GridView1.DataSource = users;
            GridView1.DataBind();
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Redirect("~/Profile/Inicio.aspx?user=" + GridView1.SelectedRow.Cells[1].Text);
    }
}