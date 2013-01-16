using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Resources;
using System.Globalization;

public partial class Profile_Mavens : System.Web.UI.Page
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
        titulo.Text = rm.GetString("Master_Mavens", ci);
        userMaven.Text = rm.GetString("Master_User", ci);
        if(!IsPostBack)
            FillGridView();
    }

    private void FillGridView()
    {
        IList<string> lists = new List<string>();
        IList<Graphs4Social_AR.Tag> tags = Graphs4Social_AR.Tag.LoadAllTag();
        foreach(Graphs4Social_AR.Tag t in tags)
        {
            lists.Add(t.Nome);
        }
        GridView1.DataSource = lists;
        GridView1.DataBind();
    }
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        var proxy = new ModuloIA.ModuloIaClient();
        string s = proxy.maven(GridView1.SelectedRow.Cells[1].Text.ToLower());
        if (s.Trim().Equals("-1"))
        {
            erro.Text = rm.GetString("Maven_Erro", ci);
            erro.Visible = true;
            hl.Visible = false;
            userMaven.Visible = false;
        }
        else
        {
            erro.Visible = false;
            hl.Text = s.Trim();
            hl.Visible = true;
            hl.NavigateUrl = "~/Profile/Inicio.aspx?user=" + s;
            userMaven.Visible = true;
        }
    }
}