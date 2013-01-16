using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Resources;
using System.Web.UI.HtmlControls;

public partial class Profile_PesquisarPorTag : System.Web.UI.Page
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

        titulo.Text = rm.GetString("PesquisarTags_Titulo", ci);
        erro.Visible = false;
        pesquisar.Text = rm.GetString("PesquisarTags_Button", ci);

        if (!IsPostBack)
        {
            FillGridView();
        }
    }

    private void FillGridView()
    {
        IList<string> list = new List<string>();
        IList<Graphs4Social_AR.Tag> tags = Graphs4Social_AR.Tag.LoadAllTag();

        foreach (Graphs4Social_AR.Tag t in tags)
        {
            list.Add(t.Nome);
        }

        GridView1.DataSource = list;
        GridView1.DataBind();
    }
    protected void pesquisar_Click(object sender, EventArgs e)
    {
        string s = "";

        foreach (GridViewRow row in GridView1.Rows)
        {
            CheckBox check = (CheckBox)row.FindControl("chkSelect1");

            if (check.Checked)
            {
                s += row.Cells[1].Text.ToLower() + ",";
            }
        }
        string aux = s.Remove(s.Length - 1, 1);

        var proxy = new ModuloIA.ModuloIaClient();
        string amigos = proxy.amigosTag(Profile.UserName.ToLower(), aux.ToLower());


        if (amigos.Trim() == "no" || amigos.Trim() == "[]" || amigos.Trim().Equals("-1"))
        {
            erro.Visible = true;
            erro.Text = rm.GetString("PesquisarTags_Erro", ci);
            lblamigos.Visible = false;
            amigosTable.Visible = false;
        }
        else
        {
            var r = amigos.Replace('[', ' ');
            r = r.Replace(']', ' ');
            r = r.Trim();
            var t = r.Split(',');
            
            if (t.Contains("-1"))
            {
                erro.Visible = true;
                erro.Text = rm.GetString("PesquisarTags_Erro", ci);
                lblamigos.Visible = false;
                amigosTable.Visible = false;
            }
            else
            {
                foreach (var user in t)
                {
                    HtmlTableRow rw = new HtmlTableRow();
                    HtmlTableCell cell = new HtmlTableCell();

                    HyperLink h = new HyperLink();
                    string username = Graphs4Social_AR.User.LoadByUserName(user).Username;
                    h.NavigateUrl = "~/Profile/Inicio.aspx?user=" + username;
                    h.Text = username;

                    cell.Controls.Add(h);
                    rw.Controls.Add(cell);
                    amigosTable.Controls.Add(rw);
                }
                lblamigos.Text = rm.GetString("PesquisarTags_Amigos", ci);
                lblamigos.Visible = true;
                amigosTable.Visible = true;
            }
        }
    }
}