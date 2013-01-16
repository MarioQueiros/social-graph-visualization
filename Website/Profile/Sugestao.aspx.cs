using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Resources;
using System.Resources;
using System.Globalization;

public partial class Profile_Sugestao : System.Web.UI.Page
{
    private static string baseName = "Resources.Graphs4Social";
    private static ResourceManager rm = new ResourceManager(baseName, System.Reflection.Assembly.Load("App_GlobalResources"));
    private CultureInfo ci;

    private void chooseLanguage()
    {

        if (Profile.Language != null && !Profile.Language.Equals(""))
        {

            if (Profile.Language.Equals("Português") || Profile.Language.Equals("Portuguese"))
            {
                ci = new CultureInfo("pt");

            }
            else
            {
                ci = new CultureInfo("en-US");
            }
        }
        else
        {
            ci = new CultureInfo("en-US");
        }

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        chooseLanguage();
        titulo.Text = rm.GetString("Sugestao_Titulo", ci);
        if (!IsPostBack)
        {
            carregaSugestao();
        }
    }

    private void carregaSugestao()
    {
        var proxy = new ModuloIA.ModuloIaClient();
        var nome = Profile.UserName.ToLower();

        var resposta = proxy.sugerirAmigos(nome.ToLower());
        if (resposta.Trim() == "no" || resposta.Trim() == "[]" || resposta.Trim().Equals("-1"))
        {
            GridView1.Visible = false;
            erro.Text = rm.GetString("Sugestao_Erro", ci);
            erro.Visible = true;
        }else
        {
            var r = resposta.Replace('[', ' ');
            r = r.Replace(']', ' ');
            r =r.Trim();
            var t = r.Split(',');
            
            IList<string> users = new List<string>();

            foreach (var user in t)
            {
                users.Add(Graphs4Social_AR.User.LoadByUserName(user).Username);
            }

            GridView1.DataSource = users;
            GridView1.DataBind();
            erro.Visible = false;
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Redirect("~/Profile/Inicio.aspx?user=" + GridView1.SelectedRow.Cells[1].Text);
    }
}