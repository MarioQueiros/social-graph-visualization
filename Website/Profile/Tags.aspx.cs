using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Resources;
using System.Globalization;

public partial class Profile_Tags : System.Web.UI.Page
{

    protected static string baseName = "Resources.Graphs4Social";
    protected static ResourceManager rm = new ResourceManager(baseName, System.Reflection.Assembly.Load("App_GlobalResources"));
    protected CultureInfo ci;

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
        if (Request.QueryString["tags"] != null)
        {
            saveTags(Request.QueryString["tags"]);
            Response.Redirect("~/Profile/Tags.aspx");
        }
    }

    protected string setTags()
    {
        IList<Graphs4Social_AR.Tag> tags = Graphs4Social_AR.Tag.LoadAllTag();

        string s = "";

        foreach (Graphs4Social_AR.Tag t in tags)
        {
            s += "'" + t.Nome + "', ";
        }
        s += "";

        return s;
    }

    protected void saveTags(string text)
    {
        string s = text;


        string[] array = s.Split(',');

        for (int i = 0; i < array.Length; i++)
        {
            if (array[i].Equals(""))
            {
                Graphs4Social_AR.Tag tag = Graphs4Social_AR.Tag.AdicionarTag(array[i]);
            }
        }

        IList<string> list = new List<string>();
        if (array.Length < 2)
        {
            list.Add(array[0]);
        }
        else
        {
            foreach (string str in array)
            {
                list.Add(str);
            }
        }
        IList<Graphs4Social_AR.Tag> al = Graphs4Social_AR.Tag.LoadAllByUsername(Profile.UserName);

        IList<string> alist = new List<string>();

        foreach (Graphs4Social_AR.Tag t in al)
        {

            alist.Add(t.Nome);

        }

        Graphs4Social_AR.Tag.RefreshTagsUser(alist, list, Profile.UserName);

    }

    protected string setUserTags()
    {

        IList<Graphs4Social_AR.Tag> tags = Graphs4Social_AR.Tag.LoadAllByUsername(Profile.UserName);

        string s = "";

        foreach (Graphs4Social_AR.Tag t in tags)
        {
            s += "'" + t.Nome + "', ";
        }
        s += "";

        return s;

    }
}