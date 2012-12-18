using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Membership.OpenAuth;
using System.Collections;
using System.Drawing;

public partial class Profile_Editar : System.Web.UI.Page
{

    protected string SuccessMessage
    {
        get;
        private set;
    }

    protected bool CanRemoveExternalLogins
    {
        get;
        private set;
    }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        init();
    }

    protected void Page_Load()
    {
        if (!IsPostBack)
        {

            fillSexo();
            if (!(Profile.Sexo == null || Profile.Sexo.Equals("")))
            {
                DropDownList1.SelectedValue = Profile.Sexo;
            }
            
            string data = Profile.DataNas.Month+"/"+Profile.DataNas.Day+"/"+Profile.DataNas.Year;

            datepicker.Text = data;
            
            
            TextBox1.Text = Profile.Regiao;

            TextBox2.Text = Convert.ToString(Profile.Contacto);

            fillLinguagem();

            if (!(Profile.Language == null || Profile.Language.Equals("")))
            {
                DropDownList2.SelectedValue = Profile.Language;
            }
        }
    }

    private void fillLinguagem()
    {
        IList<string> linguas = new List<string>();
        linguas.Add("Português");
        linguas.Add("Inglês");

        DropDownList2.DataSource = linguas;
        DropDownList2.DataBind();
    }

    private void fillSexo()
    {
        IList<string> sexos = new List<string>();
        sexos.Add("Masculino");
        sexos.Add("Feminino");
        sexos.Add("Digo depois");
        sexos.Add("Indeciso");

        DropDownList1.DataSource = sexos;
        DropDownList1.DataBind();
    }

    protected void init()
    {
        
        
    }

    
    public IEnumerable<OpenAuthAccountData> GetExternalLogins()
    {
        var accounts = OpenAuth.GetAccountsForUser(User.Identity.Name);
        CanRemoveExternalLogins = CanRemoveExternalLogins || accounts.Count() > 1;
        return accounts;
    }

    public void RemoveExternalLogin(string providerName, string providerUserId)
    {
        var m = OpenAuth.DeleteAccount(User.Identity.Name, providerName, providerUserId)
        ? "?m=RemoveLoginSuccess"
        : String.Empty;
        Response.Redirect("~/Account/E.aspx" + m);
    }

    protected static string ConvertToDisplayDateTime(DateTime? utcDateTime)
    {
        return utcDateTime.HasValue ? utcDateTime.Value.ToLocalTime().ToString("G") : "[never]";
    }

    protected void setDataNasc_click(object sender, EventArgs e)
    {
        if(!(datepicker.Text.Equals("")))
        {
            string[] data = datepicker.Text.Split('/');
            DateTime date = new DateTime(Convert.ToInt32(data[2]),Convert.ToInt32(data[0]),Convert.ToInt32(data[1]));
            Profile.DataNas = date;
        }
        else
        {
            Label1.Visible = true;
        }
    }

    protected void setSexo_click(object sender, EventArgs e)
    {
        Profile.Sexo = DropDownList1.SelectedValue;
    }

    protected void setRegiao_click(object sender, EventArgs e)
    {
        if (!(TextBox1.Text.Equals("")))
        {
            Label1.Visible = false;
            Profile.Regiao = TextBox1.Text;
        }
        else
        {
            Label1.Visible = true;
        }
    }

    protected void setContacto_click(object sender, EventArgs e)
    {
        if (!(TextBox2.Text.Equals("")) || TextBox2.Text.Length != 9)
        {
            Label2.Visible = false;
            try
            {
                Profile.Contacto = Convert.ToInt32(TextBox2.Text);
            }
            catch (Exception ex)
            {
                ex.ToString();
                Label2.Visible = true;
            }
        }
        else
        {
            Label2.Visible = true;
        }
    }

    protected void setLinguagem_click(object sender, EventArgs e)
    {
        Profile.Language = DropDownList2.SelectedValue;
    }

}