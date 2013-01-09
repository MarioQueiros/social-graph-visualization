using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Graphs4Social_AR;
using System.Reflection;

public partial class Profile_Pedidos : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        
        btt.Visible = false;
        btt1.Visible = false;
        dropi.Visible = false;
        int forca = -1;
        if (Request.QueryString["user"] != null && Request.QueryString["forca"] != null)
        {
            try
            {
                FillTagsCombo(Request.QueryString["user"]);
                forca = Convert.ToInt32(Request.QueryString["forca"]);
                /*******************************/
                //alterar para aceitar tags!!!!!
                //bool a = Graphs4Social_AR.Ligacao.AceitarPedido(Profile.UserName, Request.QueryString["user"], Convert.ToInt32(Request.QueryString["forca"]));
                /*
                if (!a)
                {
                    Graphs4Social_AR.Ligacao.RejeitarPedido(Profile.UserName, Request.QueryString["user"]);
                }*/

                Label1.Visible = true;

                IList<string> profile = Graphs4Social_AR.User.LoadProfileByUser(Request.QueryString["user"]);

                string imagem = "", sexo = "";

                foreach (string element in profile)
                {
                    if (element.Contains("Imagem:"))
                    {
                        imagem = element;
                    }
                    else if (element.Contains("Sexo:"))
                    {
                        sexo = element;
                    }

                }

                if (!imagem.Equals(""))
                {
                    if (imagem.Split(':')[1].Contains("Masculino") ||
                                imagem.Split(':')[1].Contains("Feminino") ||
                                imagem.Split(':')[1].Contains("Digo depois") ||
                                imagem.Split(':')[1].Contains("Indeciso"))
                    {
                        if (!sexo.Equals(""))
                        {
                            FillImagemPerfil(img, sexo.Split(':')[1] + ".png");
                        }
                    }
                    else
                        FillImagemPerfil(img, imagem.Split(':')[1]);
                }
                else
                {
                    FillImagemPerfil(img, "Indeciso.png");
                }

                //Globalization aqui!!!
                Label2.Text = "Amigo adicionado com sucesso";
                Label2.Visible = true;
            }
            catch (Exception ex)
            {
                Label2.Text = "Ocorreu um erro. Tente mais tarde";
                Label2.Visible = true;
            }
        }
        else
        {

            if (!IsPostBack)
            {

                IList<User> list = Graphs4Social_AR.User.LoadAllPedidosUser(Profile.UserName);


                HtmlTable htmltb = new HtmlTable();


                HtmlTableRow rw = new HtmlTableRow();
                HtmlTableRow rw1 = new HtmlTableRow();
                HtmlTableRow rw2 = new HtmlTableRow();
                HtmlTableRow rw3 = new HtmlTableRow();
                HtmlTableRow rw4 = new HtmlTableRow();


                HtmlTableCell cell = new HtmlTableCell();
                HtmlTableCell cell1 = new HtmlTableCell();
                HtmlTableCell cell2 = new HtmlTableCell();
                HtmlTableCell cell3 = new HtmlTableCell();
                HtmlTableCell cell4 = new HtmlTableCell();


                for (int i = 0; i < list.Count; i++)
                {


                    Image img1 = new Image();
                    img1.ImageUrl = "~/Images/cookie-avatar-350x350.jpeg";
                    img1.Height = 150;
                    img1.Width = 150;
                    img1.BorderWidth = 2;
                    img1.BorderColor = System.Drawing.Color.Gray;
                    cell1.Controls.Add(img1);


                    Label name = new Label();
                    name.Text = list[i].Username;
                    cell2.Controls.Add(name);


                    Button btA = new Button();
                    btA = (Button)CloneObject(btt);
                    btA.Text = "Aceitar";
                    btA.PostBackUrl = "~/Profile/Pedidos.aspx?user=" + list[i].Username;
                    btA.Visible = true;
                    cell3.Controls.Add(btA);



                    Button btR = new Button();
                    btR = (Button)CloneObject(btt1);
                    btR.Text = "Rejeitar";
                    btR.PostBackUrl = "~/Profile/Pedidos.aspx?user=" + list[i].Username;
                    btR.Visible = true;
                    cell4.Controls.Add(btR);


                    rw1.Controls.Add(cell1);
                    htmltb.Controls.Add(rw1);


                    rw2.Controls.Add(cell2);
                    htmltb.Controls.Add(rw2);


                    rw3.Controls.Add(cell3);
                    htmltb.Controls.Add(rw3);


                    rw4.Controls.Add(cell4);
                    htmltb.Controls.Add(rw4);


                    cell.Controls.Add(htmltb);


                    if (i % 3 == 0 && i != 0)
                    {
                        pedidosTable.Controls.Add(rw);

                        rw = new HtmlTableRow();

                        rw.Controls.Add(cell);

                    }
                    else
                    {
                        rw.Controls.Add(cell);
                    }

                    cell = new HtmlTableCell();

                    cell1 = new HtmlTableCell();
                    cell2 = new HtmlTableCell();
                    cell3 = new HtmlTableCell();
                    cell4 = new HtmlTableCell();


                    rw1 = new HtmlTableRow();
                    rw2 = new HtmlTableRow();
                    rw3 = new HtmlTableRow();
                    rw4 = new HtmlTableRow();

                    htmltb = new HtmlTable();
                }

                if (list.Count % 3 > 0)
                    pedidosTable.Controls.Add(rw);

                btt.Visible = false;
                btt1.Visible = false;
                dropi.Visible = false;
            }
            else
            {
                btt.Visible = false;
                btt1.Visible = false;
                dropi.Visible = false;

            }
        }
    }

    private void FillTagsCombo(string username)
    {

        IList<string> lis = Graphs4Social_AR.User.LoadProfileByUser(username);

        string sexo = "";

        foreach (string elemento in lis)
        {

            if (elemento.Contains("Sexo:"))
            {
                sexo = elemento.Split(':')[1];
                break;
            }

        }
        IList<Tag> listatagsM = null;
        IList<Tag> listatagsF = null;

        if (sexo.Contains("Masculino") || sexo.Contains("Male"))
        {
            listatagsM = Tag.LoadAllMenTagRelacao();
            foreach (Tag tag in listatagsM)
            {
                tagsdrop.Items.Add(tag.Nome);
            }
        }
        else if (sexo.Contains("Feminino") || sexo.Contains("Female"))
        {
            listatagsF = Tag.LoadAllWomenTagRelacao();
            foreach (Tag tag in listatagsF)
            {
                tagsdrop.Items.Add(tag.Nome);
            }
        }
        else
        {
            listatagsM = Tag.LoadAllMenTagRelacao();
            listatagsF = Tag.LoadAllWomenTagRelacao();
            foreach (Tag tag in listatagsF)
            {
                tagsdrop.Items.Add(tag.Nome);
            }
            foreach (Tag tag in listatagsM)
            {
                tagsdrop.Items.Add(tag.Nome);
            }
        }
    }

    private void FillImagemPerfil(Image img, string image)
    {
        img.ImageUrl = "~/Images/" + image;
        img.Height = 150;
        img.Width = 150;
        img.BorderWidth = 2;
        img.BorderColor = System.Drawing.Color.Gray;
        Label1.Text = Request.QueryString["user"];
    }

    public static Object CloneObject(object o)
    {
        Type t = o.GetType();
        PropertyInfo[] info = t.GetProperties();
        Object p = t.InvokeMember("", System.Reflection.BindingFlags.CreateInstance, null, o, null);
        foreach (PropertyInfo pi in info)
        {
            if (pi.CanWrite)
            {
                pi.SetValue(p, pi.GetValue(o, null), null);
            }
        }
        return p;
    }
    protected void btt1_Click(object sender, EventArgs e)
    {

    }
}