using System;


public partial class Profile_Sugestao : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        carregaSugestao();
    }

    private void carregaSugestao()
    {
        throw new NotImplementedException();
        var GV = GridView1;
        var proxy = new ModuloIA.ModuloIaClient();
        var nome = Profile.UserName.ToLower();

        var resposta = proxy.sugerirAmigos(nome);
        if(resposta=="no"||resposta=="[]")
        {
            GV.Visible = false;
        }else
        {
            var r = resposta.Replace('[', ' ');
            r = r.Replace(']', ' ');
            r =r.Trim();
            var t = r.Split(',');
            //var dt;
            foreach (var user in t)
            {
                /*
                 * Carrega User e adiciona o seu nome à gridview
                 * dt.add(.....)
                 */
            }

        }


       // GV.DataSource = dt;
    }
}