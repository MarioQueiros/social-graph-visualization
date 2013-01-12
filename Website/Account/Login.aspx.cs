using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Resources;
using System.Reflection;
using System.Globalization;

public partial class Account_Login : Page
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

        RegisterHyperLink.Text = rm.GetString("Login_Register", ci);

        ((Label)loginView1.FindControl("Label11")).Text = rm.GetString("Login_Entrar", ci);
        ((Label)loginView1.FindControl("username1")).Text = rm.GetString("Login_Username", ci);
        ((Label)loginView1.FindControl("password1")).Text = rm.GetString("Login_Password", ci);
        ((Label)loginView1.FindControl("lembrar")).Text = rm.GetString("Login_Lembrar", ci);
        ((Button)loginView1.FindControl("entrar")).Text = rm.GetString("Login_Entrar", ci);

        entrar1.Text = rm.GetString("Login_Entrar", ci);
        ifdont.Text = rm.GetString("Login_IfDont", ci);



        RegisterHyperLink.NavigateUrl = "Register.aspx";

        var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
        if (!String.IsNullOrEmpty(returnUrl))
        {
            RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + returnUrl;
        }
    }
}