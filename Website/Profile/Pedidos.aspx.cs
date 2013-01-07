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

    protected string forca;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["user"] != null && Request.QueryString["forca"] != null)
        {
            Label1.Visible = true;

            btt.Visible = false;
            btt1.Visible = false;
            dropi.Visible = false;

            IList<string> profile = Graphs4Social_AR.User.LoadProfileByUser(Request.QueryString["user"]);

            foreach (string element in profile)
            {

                if (element.Contains("Imagem:"))
                {

                    img.ImageUrl = "~/Images/" + element.Split(':')[1];
                    img.Height = 150;
                    img.Width = 150;
                    img.BorderWidth = 2;
                    img.BorderColor = System.Drawing.Color.Gray;
                    Label1.Text = Request.QueryString["user"];
                    break;
                }

            }

            if (img.ImageUrl.Equals(""))
            {
                img.ImageUrl = "~/Images/Indeciso.png";
                img.Height = 150;
                img.Width = 150;
                img.BorderWidth = 2;
                img.BorderColor = System.Drawing.Color.Gray;
                Label1.Text = Request.QueryString["user"];
            }
            //
            //
            //
            //remover comentário
            //
            //
            //
            /*try
            {
                bool a = Graphs4Social_AR.Ligacao.AceitarPedido(Profile.UserName, Request.QueryString["user"], Convert.ToInt32(Request.QueryString["forca"]));
                if (!a)
                {
                    Graphs4Social_AR.Ligacao.RejeitarPedido(Profile.UserName, Request.QueryString["user"]);
                }
            }
            catch (Exception ex)
            {
                ex.ToString(); 
            }*/
        }
        else
        {

            if (!IsPostBack)
            {

                IList<User> list = Graphs4Social_AR.User.LoadAllPedidosUser(Profile.UserName);

                HtmlTableRow rw = new HtmlTableRow();
                HtmlTableCell cell = new HtmlTableCell();

                HtmlTable htmltb = new HtmlTable();
                HtmlTableRow rw1 = new HtmlTableRow();
                HtmlTableRow rw2 = new HtmlTableRow();
                HtmlTableRow rw3 = new HtmlTableRow();
                HtmlTableRow rw4 = new HtmlTableRow();

                HtmlTableCell cell1 = new HtmlTableCell();
                HtmlTableCell cell2 = new HtmlTableCell();
                HtmlTableCell cell3 = new HtmlTableCell();
                HtmlTableCell cell4 = new HtmlTableCell();

                int numAmigos = 10;

                //mudar length para list.Count
                for (int i = 0; i < numAmigos; i++)
                {


                    Image img1 = new Image();
                    img1.ImageUrl = "~/Images/cookie-avatar-350x350.jpeg";
                    img1.Height = 150;
                    img1.Width = 150;
                    img1.BorderWidth = 2;
                    img1.BorderColor = System.Drawing.Color.Gray;
                    cell1.Controls.Add(img1);


                    Label name = new Label();
                    //name.Text = list[i].Username;
                    name.Text = "texto something";
                    cell2.Controls.Add(name);


                    Button btA = new Button();
                    btA = (Button)CloneObject(btt);
                    btA.Text = "Aceitar";
                    // NÂO ESQUECER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
                    btA.PostBackUrl = "~/Profile/Pedidos.aspx?user=" + Profile.UserName;


                    cell3.Controls.Add(btA);



                    Button btR = new Button();
                    btR = (Button)CloneObject(btt1);
                    btR.Text = "Rejeitar";
                    // NÂO ESQUECER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
                    btR.PostBackUrl = "~/Profile/Pedidos.aspx?user=" + Profile.UserName;
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

                        rw.Cells.Add(cell);

                    }
                    else
                    {
                        rw.Cells.Add(cell);
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

                if (numAmigos % 3 > 0)
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

    protected void btA_Click(object sender, EventArgs e)
    {
        btt.Visible = false;
        dropi.Visible = false;

        Button bt = (Button)sender;
        string s = Request.QueryString["user"];

        Label1.Text = "index:" + forca + "  - ";

        Label1.Text += "Aceitar=" + s + " - forca: ";
        Label1.Visible = true;
        //Graphs4Social_AR.Ligacao.AceitarPedido(Profile.UserName, s, 0);
    }

    protected void btR_Click(object sender, EventArgs e)
    {

        btt.Visible = false;
        btt1.Visible = false;
        dropi.Visible = false;

        Button bt = (Button)sender;
        string s = Request.QueryString["user"];

        Label1.Text = "Rejeitar=" + s;
        Label1.Visible = true;
        //Graphs4Social_AR.Ligacao.RejeitarPedido(Profile.UserName, s);
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
    protected void drop_SelectedIndexChanged(object sender, EventArgs e)
    {
        forca = ((DropDownList)sender).SelectedValue;
    }
}