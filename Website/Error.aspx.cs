using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Resources;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Profile_404 : System.Web.UI.Page
{

    private static string baseName = "Resources.Graphs4Social";
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
        string error = Request.QueryString["error"];

        Label1.Text = rm.GetString("Error_Texto1", ci);
        Label2.Text = rm.GetString("Error_Texto2", ci);
        Label3.Text = rm.GetString("Error_Texto3", ci);
        HyperLink1.Text = rm.GetString("Error_Link", ci);
        HyperLink1.NavigateUrl = "~/Profile/Inicio.aspx";

        if (error == null)
        {
            errorField.Visible = false;
        }
        else
        {
            erro.Text = error;
        }
    }
}