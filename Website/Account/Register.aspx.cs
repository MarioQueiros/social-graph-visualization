using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Resources;
using System.Reflection;
using System.Globalization;

public partial class Account_Register : Page
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
        RegisterUser.ContinueDestinationPageUrl = Request.QueryString["ReturnUrl"];

        chooseLanguage();

        ((Label)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("pass1")).Text = rm.GetString("Register_Pass1", ci);
        ((Label)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("pass2")).Text = rm.GetString("Register_Pass2", ci);
        ((Label)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("registration")).Text = rm.GetString("Register_Registration", ci);
        ((Label)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("username1")).Text = rm.GetString("Login_Username", ci);
        ((Label)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("password1")).Text = rm.GetString("Login_Password", ci);
        ((Label)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("email1")).Text = rm.GetString("Register_Email", ci);
        ((Label)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("confpassword")).Text = rm.GetString("Register_ConfPass", ci);
        ((Button)RegisterUser.WizardSteps[0].FindControl("CreateUserStepContainer").FindControl("registar")).Text = rm.GetString("Register_Button", ci);

        useform.Text = rm.GetString("Register_UseForm", ci);
        register1.Text = rm.GetString("Login_Register", ci);
    }

    protected void RegisterUser_CreatedUser(object sender, EventArgs e)
    {
        FormsAuthentication.SetAuthCookie(RegisterUser.UserName, createPersistentCookie: false);

        string continueUrl = RegisterUser.ContinueDestinationPageUrl;
        
        Response.Redirect(continueUrl);
    }
}