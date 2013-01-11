using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Membership.OpenAuth;
using System.Collections;
using System.Drawing;
using System.Resources;
using System.Reflection;
using System.Globalization;

public partial class Profile_Editar : System.Web.UI.Page
{
    private static string baseName = "Resources.Graphs4Social";
    private static ResourceManager rm = new ResourceManager(baseName, System.Reflection.Assembly.Load("App_GlobalResources"));
    private CultureInfo ci;

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

            LoadLabels();

        }
    }

    private void LoadLabels()
    {

        chooseLanguage();

        Button1.Text = rm.GetString("Editar_Button", ci);
        Button2.Text = rm.GetString("Editar_Button", ci);
        Button3.Text = rm.GetString("Editar_Button", ci);
        Button4.Text = rm.GetString("Editar_Button", ci);
        Button5.Text = rm.GetString("Editar_Button", ci);
        Button6.Text = rm.GetString("Editar_Button", ci);

        translateValues();

        fillSexo();
        if (!(Profile.Sexo == null || Profile.Sexo.Equals("")))
        {
            DropDownList1.SelectedValue = Profile.Sexo;
        }

        Label4.Text = rm.GetString("Editar_DataNascimentoTexto", ci);

        string data = Profile.DataNas.Month + "/" + Profile.DataNas.Day + "/" + Profile.DataNas.Year;

        datepicker.Text = data;

        Label5.Text = rm.GetString("Editar_RegiaoTexto", ci);

        TextBox1.Text = Profile.Regiao;

        Label6.Text = rm.GetString("Editar_NumeroTelefoneTexto", ci);

        TextBox2.Text = Convert.ToString(Profile.Contacto);

        fillLinguagem();

        if (!(Profile.Language == null || Profile.Language.Equals("")))
        {
            DropDownList2.SelectedValue = Profile.Language;
        }

        Label10.Text = rm.GetString("Editar_Avatar", ci);

        fillAvatar();
        
        Label8.Text = rm.GetString("Editar_Facebook", ci);
        Label9.Text = rm.GetString("Editar_Linkedin", ci);


    }

    private void fillAvatar()
    {
        if (!(Profile.Imagem.Contains("Feminino") || Profile.Imagem.Contains("Female") || Profile.Imagem.Contains("Masculino") || Profile.Imagem.Contains("Male") || Profile.Imagem.Contains("Undecided") || Profile.Imagem.Contains("Indeciso") || Profile.Imagem.Contains("Tell") || Profile.Imagem.Contains("Digo")))
        {
            if (Profile.Imagem.Contains("anonymous"))
            {
                r1.Checked = true;
            }
            else if (Profile.Imagem.Contains("Atlas_RobotPortal"))
            {
                r2.Checked = true;
            }
            else if (Profile.Imagem.Contains("bugsbunny"))
            {
                r3.Checked = true;
            }
            else if (Profile.Imagem.Contains("DarthVader"))
            {
                r4.Checked = true;
            }
            else if (Profile.Imagem.Contains("girl"))
            {
                r5.Checked = true;
            }
            else if (Profile.Imagem.Contains("nuku_Girl"))
            {
                r6.Checked = true;
            }
            else if (Profile.Imagem.Contains("P-Body_RobotPortal"))
            {
                r7.Checked = true;
            }
            else if (Profile.Imagem.Contains("Spiderman"))
            {
                r8.Checked = true;
            }
        }
    }


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
            Profile.Language = "English";
            DropDownList2.SelectedIndex = 1;
        }

    }

    private void fillLinguagem()
    {
        Label7.Text = rm.GetString("Editar_IdiomaTexto", ci);

        IList<string> linguas = new List<string>();
        linguas.Add(rm.GetString("Editar_IdiomaPt", ci));
        linguas.Add(rm.GetString("Editar_IdiomaEnUS", ci));

        DropDownList2.DataSource = linguas;
        DropDownList2.DataBind();
    }

    private void fillSexo()
    {

        Label3.Text = rm.GetString("Editar_Sexo_Label", ci);
        IList<string> sexos = new List<string>();
        sexos.Add(rm.GetString("Editar_Masculino", ci));
        sexos.Add(rm.GetString("Editar_Feminino", ci));
        sexos.Add(rm.GetString("Editar_Digote", ci));
        sexos.Add(rm.GetString("Editar_Indeciso", ci));

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
        if (!(datepicker.Text.Equals("")))
        {
            string[] data = datepicker.Text.Split('/');
            DateTime date = new DateTime(Convert.ToInt32(data[2]), Convert.ToInt32(data[0]), Convert.ToInt32(data[1]));
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


        translateValues();

        LoadLabels();

        Response.Redirect("~/Profile/Editar.aspx", true);
    }

    private void translateValues()
    {
        if (Profile.Language.Equals("Inglês") || Profile.Language.Equals("English"))
        {
            if (Profile.Language.Equals("Inglês"))
            {
                Profile.Language = "English";
            }
            if (Profile.Sexo.Equals("Masculino"))
            {
                Profile.Sexo = "Male";
            }
            else if (Profile.Sexo.Equals("Feminino"))
            {
                Profile.Sexo = "Female";
            }
            else if (Profile.Sexo.Equals("Indeciso"))
            {
                Profile.Sexo = "Undecided";
            }
            else if (Profile.Sexo.Equals("Digo depois"))
            {
                Profile.Sexo = "Tell you later";
            }
        }
        else if (Profile.Language.Equals("Português") || Profile.Language.Equals("Portuguese"))
        {
            if (Profile.Language.Equals("Portuguese"))
            {
                Profile.Language = "Português";
            }
            if (Profile.Sexo.Equals("Male"))
            {
                Profile.Sexo = "Masculino";
            }
            else if (Profile.Sexo.Equals("Female"))
            {
                Profile.Sexo = "Feminino";
            }
            else if (Profile.Sexo.Equals("Undecided"))
            {
                Profile.Sexo = "Indeciso";
            }
            else if (Profile.Sexo.Equals("Tell you later"))
            {
                Profile.Sexo = "Digo depois";
            }
        }
    }

    protected void setAvatar_Click(object sender, EventArgs e)
    {
        if (r1.Checked)
        {
            Profile.Imagem = "anonymous.png";
        }
        else if (r2.Checked)
        {
            Profile.Imagem = "Atlas_RobotPortal.png";
        }
        else if (r3.Checked)
        {
            Profile.Imagem = "bugsbunny.png";
        }
        else if (r4.Checked)
        {
            Profile.Imagem = "DarthVader.png";
        }
        else if (r5.Checked)
        {
            Profile.Imagem = "girl.png";
        }
        else if (r6.Checked)
        {
            Profile.Imagem = "nuku_Girl.png";
        }
        else if (r7.Checked)
        {
            Profile.Imagem = "P-Body_RobotPortal.png";
        }
        else if (r8.Checked)
        {
            Profile.Imagem = "Spiderman.png";
        }
    }
}