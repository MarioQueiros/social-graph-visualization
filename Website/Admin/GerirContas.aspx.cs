using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Resources;
using System.Web.UI.HtmlControls;

public partial class Admin_GerirContas : System.Web.UI.Page
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
        title.Text = rm.GetString("GerirC_Titulo", ci);
        nome.Text = rm.GetString("GerirC_Nome", ci);
        frie.Text = rm.GetString("GerirC_Amigos", ci);
        tags.Text = rm.GetString("GerirC_Tags", ci);
        

        FillContas();
        
    }

    protected void FillContas()
    {
        IList<Graphs4Social_AR.User> users = Graphs4Social_AR.User.LoadAllUsers();

        foreach (Graphs4Social_AR.User u in users)
        {
            HtmlTableRow rw = new HtmlTableRow();

            HtmlTableCell cell1 = new HtmlTableCell();
            HtmlTableCell cell2 = new HtmlTableCell();
            HtmlTableCell cell3 = new HtmlTableCell();

            Label l = new Label();
            l.Text=u.Username;
            cell1.Controls.Add(l);

            IList<Graphs4Social_AR.Tag> ltags = Graphs4Social_AR.Tag.LoadAllByUsername(u.Username);
            
            Label l1 = new Label();
            l1.Text = "";
            foreach (Graphs4Social_AR.Tag t in ltags)
            {
                l1.Text += t.Nome + ", ";
            }
            cell2.Controls.Add(l1);
            IList<Graphs4Social_AR.User> amg = Graphs4Social_AR.User.LoadAllAmigosUser(u.Username);
            
            foreach(Graphs4Social_AR.User usr in amg)
            {
                HyperLink h = new HyperLink();
                h.NavigateUrl = "~/Profile/Inicio.aspx?user=" + usr.Username;
                h.Text = usr.Username;
                Label l2 = new Label();
                l2.Text = ", ";
                cell3.Controls.Add(h);
                cell3.Controls.Add(l2);
                
                
            }
            
            rw.Controls.Add(cell1);
            rw.Controls.Add(cell2);
            rw.Controls.Add(cell3);

            contas.Controls.Add(rw);
        }
    }
}