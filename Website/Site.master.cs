using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Resources;
using System.Globalization;
using System.Drawing;

public partial class SiteMaster : MasterPage
{
    private const string AntiXsrfTokenKey = "__AntiXsrfToken";
    private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
    private string _antiXsrfTokenValue;
    private static string baseName = "Resources.Graphs4Social";
    private static ResourceManager rm = new ResourceManager(baseName, System.Reflection.Assembly.Load("App_GlobalResources"));
    private CultureInfo ci;

    protected void Page_Init(object sender, EventArgs e)
    {
        // The code below helps to protect against XSRF attacks
        var requestCookie = Request.Cookies[AntiXsrfTokenKey];
        Guid requestCookieGuidValue;
        if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
        {
            // Use the Anti-XSRF token from the cookie
            _antiXsrfTokenValue = requestCookie.Value;
            Page.ViewStateUserKey = _antiXsrfTokenValue;
        }
        else
        {
            // Generate a new Anti-XSRF token and save to the cookie
            _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
            Page.ViewStateUserKey = _antiXsrfTokenValue;

            var responseCookie = new HttpCookie(AntiXsrfTokenKey)
            {
                HttpOnly = true,
                Value = _antiXsrfTokenValue
            };
            if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
            {
                responseCookie.Secure = true;
            }
            Response.Cookies.Set(responseCookie);
        }

        Page.PreLoad += master_Page_PreLoad;
    }

    void master_Page_PreLoad(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Set Anti-XSRF token
            ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
            ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
        }
        else
        {
            // Validate the Anti-XSRF token
            if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
            {
                throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!Profile.IsAnonymous)
            {
                chooseLanguage();

                HtmlAnchor hl = loginView.FindControl("linkProfile") as HtmlAnchor;
                
                hl.HRef += "?user=" + Profile.UserName;

                Label1.Text = rm.GetString("Master_Warning",ci);

                Label1.ForeColor = Color.Red;

                
            }

        }
    }

    private void chooseLanguage()
    {

        if (Profile.Language != null || !Profile.Language.Equals(""))
        {

            if (Profile.Language.Equals("Português") || Profile.Language.Equals("Portuguese"))
            {
                ci = new CultureInfo("pt");

            }
            else if (Profile.Language.Equals("Inglês") || Profile.Language.Equals("English"))
            {
                ci = new CultureInfo("en-US");
            }
        }
        else
        {
            ci = new CultureInfo("en-US");
            Profile.Language = "English";
        }

    }

    public void search(){
        if (!Page.IsPostBack)
        {
            string aux = this.pesquisarText.Value;
            Graphs4Social_AR.User user = Graphs4Social_AR.User.LoadByUserName(aux);
            if (user != null)
            {
                pesquisarLink.NavigateUrl = "~/Profile/Inicio.aspx?user=" + aux;
                warningDiv.Visible = false;
            }
            else if (!aux.Equals("Pesquisar..."))
            {
                warningDiv.Visible = true;
            }
        }
    }
    
}