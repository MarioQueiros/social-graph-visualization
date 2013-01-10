using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Resources;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : Page
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
        if(Profile.IsAnonymous){
            Label1.Text = rm.GetString("Default_Title", ci);
            Label2.Text = rm.GetString("Default_Text", ci);
            world.ImageUrl = "~/Images/BlankMap-World-1985.png";
            world.Height = 300;
            world.Width = 800;
        }
        else{
            Response.Redirect("~/Profile/Inicio.aspx?user="+Profile.UserName,true);
        }
    }
}