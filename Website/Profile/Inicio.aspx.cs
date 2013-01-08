﻿using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Graphs4Social_AR;

public partial class Profile_Inicio : System.Web.UI.Page
{
    protected int forca = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string username = Request.QueryString["user"];

            if (username == null)
            {
                username = Profile.UserName;
                Server.Transfer("~/Profile/Inicio.aspx?user=" + username);
            }

                // Ver apos enviar pedido
            else{
                if (!Profile.UserName.Equals(username))
                {
                    Ligacao lig = Ligacao.LoadByUserNames(Profile.UserName, username);
                    Button1.Visible = true;
                    
                    DropDownList1.Visible = true;

                    tagsRelacao.Visible = true;
                    
                    IList<string> lis = Graphs4Social_AR.User.LoadProfileByUser(username);

                    string sexo="";

                    foreach(string elemento in lis){

                        if (elemento.Contains("Sexo:")){
                            sexo = elemento.Split(':')[1];
                            break;
                        }

                    }
                    IList<Tag> listatagsM=null;
                    IList<Tag> listatagsF=null;

                    if (sexo.Contains("Masculino") || sexo.Contains("Male"))
                    {
                        listatagsM = Tag.LoadAllMenTagRelacao();
                        foreach (Tag tag in listatagsM)
                        {
                            tagsRelacao.Items.Add(tag.Nome);
                        }
                    }
                    else if (sexo.Contains("Feminino") || sexo.Contains("Female"))
                    {
                        listatagsF = Tag.LoadAllWomenTagRelacao();
                        foreach (Tag tag in listatagsF)
                        {
                            tagsRelacao.Items.Add(tag.Nome);
                        }
                    }
                    else
                    {
                        listatagsM = Tag.LoadAllMenTagRelacao();
                        listatagsF = Tag.LoadAllWomenTagRelacao();
                        foreach (Tag tag in listatagsF)
                        {
                            tagsRelacao.Items.Add(tag.Nome);
                        }
                        foreach (Tag tag in listatagsM)
                        {
                            tagsRelacao.Items.Add(tag.Nome);
                        }
                    }


                    if (lig == null)
                    {

                        Button1.Text = "Enviar Pedido de Amizade";

                    }
                    else
                    {
                        if (lig.Estado == -1)
                        {

                            Button1.Text = "Pedido Rejeitado";
                            Button1.Enabled = true;

                        }
                        else if (lig.Estado == 0)
                        {
                            if (lig.ForcaDeLigacao == -1)
                            {

                                Button1.Text = "Aceitar Pedido";
                                Button1.Enabled = true;

                            }
                            else if (lig.ForcaDeLigacao > 0)
                            {
                                Button1.Text = "Pedido Enviado";
                                Button1.Enabled = false;
                            }
                        }
                        else if (lig.Estado == 1)
                        {

                            Button1.Text = "Amigo";
                            Button1.Enabled = false;
                            DropDownList1.Enabled = false;
                        }

                    }
                }
            }

            tituloPerfil.InnerText = username;

            FillProfileLabels(username);

            FillTabelaDeAmigos(username);



        }

    }

    protected void FillTabelaDeAmigos(string username)
    {


        Label17.Text = "Amigos - ";
        IList<Graphs4Social_AR.User> amigos = Graphs4Social_AR.User.LoadAllAmigosUser(username);

        int total = amigos.Count;
        int index = 0;

        if (total > 0)
        {
            Label18.Text = Convert.ToString(total);
            if (total == 1)
                Label18.Text += " amigo";
            else
                Label18.Text += " amigos";




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
            Label18.Text = "0 amigos";
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

                    Label10.Text = "Região : ";
                    Label2.Text = elemento.Split(':')[1];
                }
                else if (elemento.Contains("Contacto:"))
                {
                    Label5.Visible = true;
                    Label13.Visible = true;

                    Label13.Text = "Contacto : ";
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

                    Label12.Text = "Sexo : ";
                    Label4.Text = elemento.Split(':')[1];
                    sexo = Label4.Text;
                }
                else if (elemento.Contains("Language:"))
                {
                    Label6.Visible = true;
                    Label14.Visible = true;

                    Label14.Text = "Lingua : ";
                    Label6.Text = elemento.Split(':')[1];
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

                    Label9.Text = "Idade : ";
                    Label11.Text = "Data de Nascimento : ";

                    string ano = Convert.ToString(DateTime.Today.Year - dt.Year);
                    if (ano.Equals("1"))
                        Label1.Text = ano + " ano";
                    else
                        Label1.Text = ano + " anos";

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
            Label4.Text = "Sem informação disponível";


        }

        if (Image1.ImageUrl.Equals(""))
        {
            if (!sexo.Equals(""))
            {
                FillImagemPerfil(Image1, sexo);
            }
            else if (sexo.Equals(""))
            {
                FillImagemPerfil(Image1, "Indeciso");

                Label4.Visible = true;
                Label12.Visible = true;

                Label12.Text = "Sexo : ";
                Label4.Text = "Indeciso";
                sexo = Label4.Text;
            }
        }

    }

    protected void FillImagemPerfil(System.Web.UI.WebControls.Image img, string elemento)
    {
        if (elemento.Equals("Masculino") ||
            elemento.Equals("Feminino") ||
            elemento.Equals("Digo depois") ||
            elemento.Equals("Indeciso"))
        {
            img.ImageUrl = "~/Images/" + elemento + ".png";
            if (elemento.Equals("Indeciso"))
                Profile.Sexo = elemento;

            Profile.Imagem = elemento + ".png";
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
    }
}