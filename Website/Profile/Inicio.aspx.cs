using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Graphs4Social_AR;
using System.Resources;
using System.Globalization;
using TagCloud;

public partial class Profile_Inicio : System.Web.UI.Page
{
    protected int forca = 1;
    protected string estadohumorStr;

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
        bool flag = true;
        if (!IsPostBack)
        {
            chooseLanguage();
            string username = Request.QueryString["user"];

            subEstadoHumor.Text = rm.GetString("Editar_Button", ci);
            Label19.Text = rm.GetString("Inicio_Amigo", ci) + "s";
            Label20.Text = rm.GetString("Inicio_Tags", ci);
            

            if (username == null)
            {
                username = Profile.UserName;
                Server.Transfer("~/Profile/Inicio.aspx?user=" + username);
            }

                // Ver apos enviar pedido
            else
            {
                if (!Profile.UserName.Equals(username))
                {
                    
                    Ligacao lig = null;
                    try
                    {
                        lig = Ligacao.LoadByUserNames(Profile.UserName, username);
                    }
                    catch (Exception ex)
                    {
                        flag = false;
                        Response.Redirect("404.aspx");
                    }

                    if (flag)
                    {
                        Button1.Visible = true;

                        DropDownList1.Visible = true;

                        tagsRelacao.Visible = true;

                        IList<string> lis = Graphs4Social_AR.User.LoadProfileByUser(username);

                        string sexo = "";

                        if (lis != null)
                        {
                            foreach (string elemento in lis)
                            {

                                if (elemento.Contains("Sexo:"))
                                {
                                    sexo = elemento.Split(':')[1];
                                    break;
                                }

                            }
                        }
                        else
                        {
                            sexo = rm.GetString("Editar_Indeciso", ci);
                        }

                    IList<Graphs4Social_AR.Tag> listatagsM=null;
                    IList<Graphs4Social_AR.Tag> listatagsF=null;

                        if (sexo.Contains("Masculino") || sexo.Contains("Male"))
                        {
                        listatagsM = Graphs4Social_AR.Tag.LoadAllMenTagRelacao();
                        foreach (Graphs4Social_AR.Tag tag in listatagsM)
                            {
                                tagsRelacao.Items.Add(tag.Nome);
                            }
                        }
                        else if (sexo.Contains("Feminino") || sexo.Contains("Female"))
                        {
                        listatagsF = Graphs4Social_AR.Tag.LoadAllWomenTagRelacao();
                        foreach (Graphs4Social_AR.Tag tag in listatagsF)
                            {
                                tagsRelacao.Items.Add(tag.Nome);
                            }
                        }
                        else
                        {
                        listatagsM = Graphs4Social_AR.Tag.LoadAllMenTagRelacao();
                        listatagsF = Graphs4Social_AR.Tag.LoadAllWomenTagRelacao();
                        foreach (Graphs4Social_AR.Tag tag in listatagsF)
                            {
                                tagsRelacao.Items.Add(tag.Nome);
                            }
                        foreach (Graphs4Social_AR.Tag tag in listatagsM)
                            {
                                tagsRelacao.Items.Add(tag.Nome);
                            }
                        }


                        if (lig == null)
                        {

                            Button1.Text = rm.GetString("Inicio_Pedido", ci);

                        }
                        else
                        {
                            if (lig.Estado == -1)
                            {

                                Button1.Text = rm.GetString("Inicio_Rejeitado", ci);
                                Button1.Enabled = true;

                            }
                            else if (lig.Estado == 0)
                            {
                                if (lig.ForcaDeLigacao == -1)
                                {

                                    Button1.Text = rm.GetString("Inicio_Aceitar", ci);
                                    Button1.Enabled = true;

                                }
                                else if (lig.ForcaDeLigacao > 0)
                                {
                                    Button1.Text = rm.GetString("Inicio_Enviado", ci);
                                    Button1.Enabled = false;

                                    DropDownList1.Enabled = false;
                                    Ligacao l = Ligacao.LoadByUserNames(Profile.UserName, username);
                                    DropDownList1.SelectedValue = l.ForcaDeLigacao.ToString();

                                    tagsRelacao.Enabled = false;
                                    tagsRelacao.SelectedValue = l.TagRelacao.Nome;
                                }
                            }
                            else if (lig.Estado == 1)
                            {

                                Button1.Text = rm.GetString("Inicio_Amigo", ci);
                                Button1.Enabled = false;
                                DropDownList1.Enabled = false;
                                Ligacao l = Ligacao.LoadByUserNames(username, Profile.UserName);
                                DropDownList1.SelectedValue = l.ForcaDeLigacao.ToString();

                                tagsRelacao.Enabled = false;
                                tagsRelacao.SelectedValue = l.TagRelacao.Nome;
                            }

                        }
                    }
                }
            }
            if (flag)
            
            {
                tituloPerfil.InnerText = Graphs4Social_AR.User.LoadByUserName(username).Username;
                FillProfileLabels(username);

                FillTabelaDeAmigos(username);
            }


        }

    }

    protected string mudarEstadoHumor()
    {
        if (Profile.EstadoHumor != "")
            return Profile.EstadoHumor;
        else
            return "Smiley.png";
    }

    protected string setEstadoHumor()
    {
        string username = Request.QueryString["user"];

        IList<string> profile = Graphs4Social_AR.User.LoadProfileByUser(username);

        foreach (string elemento in profile)
        {

            if (elemento.Contains("EstadoHumor:"))
            {
                
                return elemento.Split(':')[1];
            }

        }

        return "Smiley";
    }

    protected void FillTabelaDeAmigos(string username)
    {


        IList<Graphs4Social_AR.User> amigos = Graphs4Social_AR.User.LoadAllAmigosUser(username);

        int total = amigos.Count;
        int index = 0;

        if (total > 0)
        {
            Label18.Text = Convert.ToString(total);
            if (total == 1)
                Label18.Text += " " + rm.GetString("Inicio_Amigo", ci);
            else
                Label18.Text += " " + rm.GetString("Inicio_Amigo", ci) + "s";




            HtmlTableRow row = new HtmlTableRow();

            foreach (Graphs4Social_AR.User amigo in amigos)
            {

                HtmlTable amigoTable = new HtmlTable();

                HtmlTableCell cell = new HtmlTableCell();
                HtmlTableCell cell1 = new HtmlTableCell();
                HtmlTableCell cell2 = new HtmlTableCell();


                HtmlTableRow imagem = new HtmlTableRow();
                HtmlTableRow titulo = new HtmlTableRow();

                IList<string> profile = Graphs4Social_AR.User.LoadProfileByUser(amigo.Username);


                //imagem.Controls.Add(cell);
                System.Web.UI.WebControls.Image img = new System.Web.UI.WebControls.Image();
                foreach (string elemento in profile)
                {

                    if (elemento.Contains("Imagem:"))
                    {
                        FillImagemPerfil(img, elemento.Split(':')[1]);
                        break;
                    }

                }
                if (img.ImageUrl.Equals(""))
                {
                    img.ImageUrl = "~/Images/404-image.png";
                }
                cell1.Controls.Add(img);


                HtmlAnchor a = new HtmlAnchor();
                a.InnerHtml = amigo.Username;
                a.HRef = "~/Profile/Inicio.aspx?user=" + amigo.Username;
                cell2.Controls.Add(a);


                imagem.Controls.Add(cell1);
                amigoTable.Controls.Add(imagem);


                titulo.Controls.Add(cell2);
                amigoTable.Controls.Add(titulo);

                cell.Controls.Add(amigoTable);


                if (index % 3 == 0 || index == 0)
                {
                    row = new HtmlTableRow();
                    row.Controls.Add(cell);
                    tabelaDeAmigos.Controls.Add(row);

                }
                else
                {
                    row.Controls.Add(cell);
                }

                index++;
            }


        }
        else
        {
            Label18.Text = "0 " + rm.GetString("Inicio_Amigo", ci) + "s";
            Image2.Visible = true;
            Image2.ImageUrl = "~/Images/foreveralone.png";
            Image3.Visible = true;
            Image3.ImageUrl = "~/Images/foreveralonetext.png";
        }
    }

    protected void FillProfileLabels(string username)
    {
        IList<string> profile = Graphs4Social_AR.User.LoadProfileByUser(username);
        string sexo = "";

        if (profile != null)
        {
            foreach (string elemento in profile)
            {

                if (elemento.Contains("Regiao:"))
                {
                    Label2.Visible = true;
                    Label10.Visible = true;

                    Label10.Text = rm.GetString("Inicio_Regiao", ci) + " : ";
                    Label2.Text = elemento.Split(':')[1];
                }
                else if (elemento.Contains("Contacto:"))
                {
                    Label5.Visible = true;
                    Label13.Visible = true;

                    Label13.Text = rm.GetString("Inicio_Contacto", ci) + " : ";
                    Label5.Text = elemento.Split(':')[1];
                }
                else if (elemento.Contains("PerfilFb:"))
                {

                    Label7.Visible = true;
                    Label15.Visible = true;

                    Label15.Text = "Facebook : ";
                    // A ser alterado pelo nome de conta
                    Label7.Text = "Conta do Facebook";
                    HyperLink1.NavigateUrl = elemento.Split(':')[1];
                }
                else if (elemento.Contains("PerfilLk:"))
                {
                    Label8.Visible = true;
                    Label16.Visible = true;

                    Label16.Text = "LinkedIn : ";
                    // A ser alterado pelo nome da conta
                    Label8.Text = "Conta do LinkedIn";
                    HyperLink2.NavigateUrl = elemento.Split(':')[1];
                }
                else if (elemento.Contains("Sexo:"))
                {
                    Label4.Visible = true;
                    Label12.Visible = true;

                    Label12.Text = rm.GetString("Inicio_Sexo", ci) + " : ";
                    Label4.Text = translateValues(elemento.Split(':')[1]);
                    sexo = Label4.Text;
                }
                else if (elemento.Contains("Language:"))
                {
                    Label6.Visible = true;
                    Label14.Visible = true;

                    Label14.Text = rm.GetString("Inicio_Lingua", ci) + " : ";
                    Label6.Text = translateValues(elemento.Split(':')[1]);
                }
                else if (elemento.Contains("DataNas:"))
                {
                    Label1.Visible = true;
                    Label9.Visible = true;

                    Label3.Visible = true;
                    Label11.Visible = true;

                    string[] data = (elemento.Split(':')[1]).Split('-');

                    DateTime dt = new DateTime(Convert.ToInt32(data[0]),
                        Convert.ToInt32(data[1]),
                        Convert.ToInt32(data[2]));

                    Label9.Text = rm.GetString("Inicio_Idade", ci) + " : ";
                    Label11.Text = rm.GetString("Inicio_DataNasc", ci) + " : ";

                    string ano = Convert.ToString(DateTime.Today.Year - dt.Year);
                    if (ano.Equals("1"))
                        Label1.Text = ano + " " + rm.GetString("Inicio_Ano", ci);
                    else
                        Label1.Text = ano + " " + rm.GetString("Inicio_Ano", ci) + "s";

                    Label3.Text = data[2] + "/" + data[1] + "/" + data[0];
                }
                else if (elemento.Contains("Imagem:"))
                {
                    if (elemento.Split(':')[1].Contains("Masculino") ||
                        elemento.Split(':')[1].Contains("Feminino") ||
                        elemento.Split(':')[1].Contains("Digo depois") ||
                        elemento.Split(':')[1].Contains("Indeciso"))
                    {
                        if (!sexo.Equals(""))
                        {
                            FillImagemPerfil(Image1, sexo);
                        }
                    }
                    else
                        FillImagemPerfil(Image1, elemento.Split(':')[1]);
                }
            }
        }
        else
        {

            Label4.Visible = true;
            Label4.Text = rm.GetString("Inicio_Info", ci);


        }

        if (Image1.ImageUrl.Equals(""))
        {
            if (!sexo.Equals(""))
            {
                FillImagemPerfil(Image1, sexo);
            }
            else if (sexo.Equals("") && Profile.UserName.Equals(username))
            {
                FillImagemPerfil(Image1, rm.GetString("Editar_Indeciso", ci));

                Label4.Visible = true;
                Label12.Visible = true;

                Label12.Text = rm.GetString("Inicio_Sexo", ci) + " : ";
                Label4.Text = rm.GetString("Editar_Indeciso", ci);
                Profile.Sexo = Label4.Text;
            }
            else
            {
                FillImagemPerfil(Image1, "404-image.png");
            }
        }

    }

    protected void FillImagemPerfil(System.Web.UI.WebControls.Image img, string elemento)
    {
        if (elemento.Equals("Masculino") || elemento.Equals("Male"))
        {
            img.ImageUrl = "~/Images/Masculino.png";
        }
        else if (elemento.Equals("Feminino") || elemento.Equals("Female"))
        {
            img.ImageUrl = "~/Images/Feminino.png";
        }
        else if (elemento.Equals("Digo depois") || elemento.Equals("Tell you later"))
        {
            img.ImageUrl = "~/Images/Digo depois.png";
        }
        else if (elemento.Equals("Undecided") || elemento.Equals("Indeciso"))
        {
            img.ImageUrl = "~/Images/Indeciso.png";
        }
        else
        {
            img.ImageUrl = "~/Images/" + elemento;
        }

        img.Height = 150;
        img.Width = 150;
        img.BorderWidth = 2;
        img.BorderColor = Color.Gray;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {

        forca = Convert.ToInt32(DropDownList1.SelectedValue);
        string tag = tagsRelacao.SelectedValue;
        if (Button1.Text.Equals("Aceitar Pedido"))
        {
            Ligacao.AceitarPedido(Profile.UserName, Request.QueryString["user"], forca, tag);
        }
        else
        {
            Ligacao.PedidoAmizade(Profile.UserName, Request.QueryString["user"], forca, tag);
        }

        Response.Redirect("~/Profile/Inicio.aspx?user="+Request.QueryString["user"],true);
    }

    private string translateValues(string value)
    {

        if (value.Equals("Portuguese") || value.Equals("Português"))
        {
            return rm.GetString("Editar_IdiomaPt", ci);
        }
        if (value.Equals("English") || value.Equals("Inglês"))
        {

            return rm.GetString("Editar_IdiomaEnUS", ci);

        }
        if (value.Equals("Male") || value.Equals("Masculino"))
        {
            return rm.GetString("Editar_Masculino", ci);
        }
        else if (value.Equals("Female") || value.Equals("Feminino"))
        {
            return rm.GetString("Editar_Feminino", ci);
        }
        else if (value.Equals("Undecided") || value.Equals("Indeciso"))
        {
            return rm.GetString("Editar_Indeciso", ci);
        }
        else if (value.Equals("Tell you later") || value.Equals("Digo depois"))
        {
            return rm.GetString("Editar_Digote", ci);
        }
        else
            return rm.GetString("Editar_Indeciso", ci);
    }

    protected bool checkUsername()
    {
        string username = Request.QueryString["user"];
        if(username!=null)
        {
            if (!Profile.UserName.Equals(username))
            {
                return false;
            }else{
                return true;
            }
        }
        return false;
    }

    protected string fillEstadoHumor()
    {
        return "../Images/"+Profile.EstadoHumor;
    }
    protected void subEstadoHumor_Click(object sender, EventArgs e)
    {
        Profile.EstadoHumor = Hidden1.Value;
    }

    protected IDictionary<string, int> LoadTags()
    {
        IDictionary<string, int> tags = new Dictionary<string,int>();
        IList <Graphs4Social_AR.Tag> list = new List <Graphs4Social_AR.Tag>();
        IList <Graphs4Social_AR.Tag> listall = Graphs4Social_AR.Tag.LoadAllTag();

        int numTags = listall.Count;

        int numTotal = 0;

        if (numTags > 0)
        {
            foreach (Graphs4Social_AR.Tag tag in listall)
            {

                numTotal += tag.Quantidade;

            }

            if (Request.QueryString["user"] != null)
                list = Graphs4Social_AR.Tag.LoadAllByUsername(Request.QueryString["user"]);
            else
                list = Graphs4Social_AR.Tag.LoadAllByUsername(Profile.UserName);

            if (list.Count > 0)
            {
                foreach (Graphs4Social_AR.Tag tag in list)
                {

                    tags.Add(tag.Nome, (1-(tag.Quantidade/numTotal))*100);

                }
            }
            else
            {
                tags.Add(rm.GetString("Inicio_NoTags", ci), 100);
            }
        }
        else
        {
            tags.Add(rm.GetString("Inicio_NoTags", ci), 100);
        }
        return tags;
    }
}