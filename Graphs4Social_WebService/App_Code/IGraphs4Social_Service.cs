using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Graphs4Social_AR;

[DataContract]
public class Grafo
{
    public int NrNos { get; set; }

    public int NrArcos { get; set; }

    public IList<User> Users { get; set; }

    public IList<Ligacao> Ligacoes { get; set; }

    public Grafo(string username)
    {
        Users = new List<User>();
        Ligacoes = new List<Ligacao>();

        //  Carrega o user "dono" do grafo
        Users.Add(new User(username));
        Users[0].Definido = true;
        Users[0].X = 0;
        Users[0].Y = 0;
        Users[0].Z = 0;
        //
        double numTags = Users[0].Tags.Count;
        double numTagsTotal = Graphs4Social_AR.Tag.LoadAllTag().Count;
        //
        double minraio = 3;
        double maxraio = 7.5;
        double raio = minraio + ((maxraio - minraio) * (numTags / numTagsTotal));
        Users[0].Raio = raio;
        //  Carrega as ligações do user
        //  IList<string> ligacoes = RedeNivel2(userdono,U)

        IList<Graphs4Social_AR.User> usersAmigos = Graphs4Social_AR.User.LoadAllAmigosUser(username);

        IList<Graphs4Social_AR.Ligacao> ligacoesDono = new List<Graphs4Social_AR.Ligacao>();

        foreach (Graphs4Social_AR.User user in usersAmigos)
        {
            ligacoesDono.Add(Graphs4Social_AR.Ligacao.LoadByUserNames(username, user.Username));
        }

        int i=1;

        foreach (Graphs4Social_AR.Ligacao ligacao in ligacoesDono)
        {
            string usernameAmigo = ligacao.UserLigado.Username;

            //  Aqui cria os amigos do "dono" e adiciona-os
            Users.Add(new User(usernameAmigo));

            //  Cria a Ligacao
            Ligacoes.Add(new Ligacao(0, i, username, usernameAmigo));
            

            i++;
        }


        

        // RedeNivel3-RedeNivel2
        /*IList<string> ligacoesNaoDirectas = new List<string>();

        foreach (Graphs4Social_AR.Ligacao ligacao in ligacoesDono){

            string usernameAmigo = ligacao.UserLigado.Username;

            ligacoesAmigos = Graphs4Social_AR.Ligacao.LoadAllByUserName(username);

            foreach(User userAmigo in Users){
                if(!userAmigo.Username.Equals(usernameAmigo)){
                    liga

                }
            }
        }*/

        NrNos = Users.Count;
        NrArcos = Ligacoes.Count;

        int tentativas = 0;
        bool notDone = true;

        int max = 20*NrArcos;
        Random valor = new Random();

        // Cota - NAO ESQUECER - NR LIGACOES DIRECTAS - PROLOG
        double cota = 0;

        while(notDone){
            foreach (Ligacao ligacao in Ligacoes)
            {
                if (!Users[ligacao.Id2].Definido)
                {
                    if (valor.NextDouble() >= 0.5)
                    {
                        Users[ligacao.Id2].X = valor.Next(10, max) * -1;
                    }
                    else
                    {
                        Users[ligacao.Id2].X = valor.Next(10, max);
                    }
                    //
                    if (valor.NextDouble() >= 0.5)
                    {
                        Users[ligacao.Id2].Y = valor.Next(10, max) * -1;
                    }
                    else
                    {
                        Users[ligacao.Id2].Y = valor.Next(10, max);
                    }
                    //
                    Users[ligacao.Id2].Z = cota;
                    //
                    numTags = Users[ligacao.Id2].Tags.Count;
                    //
                    raio = minraio + ((maxraio - minraio) * (numTags / numTagsTotal));
                    Users[ligacao.Id2].Raio = raio;
                }
                else
                    tentativas = 4;

                for (int j = 0; j < NrArcos; j++)
                {
                    if (!(tentativas >= 5))
                    {
                        if (!(Ligacoes[j].Id1 == ligacao.Id1 && Ligacoes[j].Id2 == ligacao.Id2))
                        {
                            if (this.intersecta(Users[Ligacoes[j].Id1], Users[Ligacoes[j].Id2], Users[ligacao.Id1], Users[ligacao.Id2], Users[ligacao.Id2].Raio))
                            {
                                tentativas++;
                                j = 0;
                                break;
                            }

                        }
                    }
                    else
                        break;

                }
                if (tentativas >= 5)
                    break;

            }
            if (!(tentativas >= 5))
                notDone = false;
            else
            {
                tentativas = 0;
                for (int j = i; j < NrNos; j++)
                {
                    Users[j].Definido = false;
                }
            }
        }

    }

    public bool intersecta(User userDono1, User userLigado1, User userDono2, User userLigado2, double raio)
    {
        if (userLigado1.Definido)
        {
            double x = 0, y = 0, z = 0;

            bool intersect = false;
            bool flag = false;

            double ua_t = (userLigado2.X - userDono2.X) * (userDono1.Y - userDono2.Y) - (userLigado2.Y - userDono2.Y) * (userDono1.X - userDono2.X);
            double ub_t = (userLigado1.X - userDono1.X) * (userDono1.Y - userDono2.Y) - (userLigado1.Y - userDono1.Y) * (userDono1.X - userDono2.X);
            double u_b = (userLigado2.Y - userDono2.Y) * (userLigado1.X - userDono1.X) - (userLigado2.X - userDono2.X) * (userLigado1.Y - userDono1.Y);


            double hip = Math.Sqrt(Math.Pow(raio, 2) + Math.Pow(raio, 2));

            if (u_b != 0)
            {
                double ua = ua_t / u_b;
                double ub = ub_t / u_b;

                if (0 <= ua && ua <= 1 && 0 <= ub && ub <= 1)
                {

                    x = userDono1.X + ua * (userLigado1.X - userDono1.X);
                    y = userDono1.Y + ua * (userLigado1.Y - userDono1.Y);

                    intersect = true;
                    flag = true;
                }
            }
            else
            {
                if (ua_t == 0 || ub_t == 0)
                {
                    intersect = true;
                }
            }

            if (!intersect)
            {
                userLigado2.Definido = true;
                return false;
            }
            else
            {
                if (flag)
                {
                    if (userLigado2.Definido)
                        return false;
                    else
                    {
                        if ((userDono1.X == userLigado2.X && userDono1.Y == userLigado2.Y) || (userLigado1.X == userLigado2.X && userLigado1.Y == userLigado2.Y) || (userDono2.X == userLigado2.X && userDono2.Y == userLigado2.Y))
                        {
                            return true;
                        }
                        else
                        {
                            if (userDono1.X < x && x < userLigado1.X)
                            {
                                if (userDono1.Y < y && y < userLigado1.Y)
                                {
                                    return true;
                                }
                                else if (userDono1.Y > y && y > userLigado1.Y)
                                {
                                    return true;
                                }
                            }
                            else if (userDono1.X > x && x > userLigado1.X)
                            {
                                if (userDono1.Y < y && y < userLigado1.Y)
                                {
                                    return true;
                                }
                                else if (userDono1.Y > y && y > userLigado1.Y)
                                {
                                    return true;
                                }

                            }


                            IList<double> pontosLigacao = this.criarRectanguloEspaco(userDono1, userLigado1, raio, hip);
                            //
                            //  Topo    -   Esquerda     [0] - [1]
                            //  Topo    -   Direita      [2] - [3]
                            //  Baixo   -   Esquerda     [4] - [5]
                            //  Baixo   -   Direita      [6] - [7]
                            //
                            double minX = pontosLigacao[0];
                            double maxX = pontosLigacao[0];
                            //
                            if (pontosLigacao[2] < minX)
                            {
                                minX = pontosLigacao[2];
                            }
                            if (pontosLigacao[2] > maxX)
                            {
                                maxX = pontosLigacao[2];
                            }
                            //
                            //
                            //
                            if (pontosLigacao[4] < minX)
                            {
                                minX = pontosLigacao[4];
                            }
                            if (pontosLigacao[4] > maxX)
                            {
                                maxX = pontosLigacao[4];
                            }
                            //
                            //
                            //
                            if (pontosLigacao[6] < minX)
                            {
                                minX = pontosLigacao[6];
                            }
                            if (pontosLigacao[6] > maxX)
                            {
                                maxX = pontosLigacao[6];
                            }
                            //
                            //
                            //
                            //
                            double minY = pontosLigacao[1];
                            double maxY = pontosLigacao[1];
                            //
                            if (pontosLigacao[3] < minY)
                            {
                                minY = pontosLigacao[2];
                            }
                            if (pontosLigacao[3] > maxY)
                            {
                                maxY = pontosLigacao[2];
                            }
                            //
                            //
                            //
                            if (pontosLigacao[5] < minY)
                            {
                                minY = pontosLigacao[5];
                            }
                            if (pontosLigacao[5] > maxY)
                            {
                                maxY = pontosLigacao[5];
                            }
                            //
                            //
                            //
                            if (pontosLigacao[7] < minY)
                            {
                                minY = pontosLigacao[7];
                            }
                            if (pontosLigacao[7] > maxY)
                            {
                                maxY = pontosLigacao[7];
                            }
                            //
                            //
                            //
                            //  Sabendo o max e min do X e do Y
                            //
                            //
                            if (verificarEspaco(userLigado2.X, userLigado2.Y, raio, maxX, maxY, minX, minY, 1))
                            {
                                return true;
                            }
                        }

                    }
                }
                else
                {
                    return true;
                }

            }
            userLigado2.Definido = true;
            return false;
        }
        else
        {
            userLigado2.Definido = true;
            return false;
        }
    }

    private bool verificarEspaco(double x, double y, double raio, double maxX, double maxY, double minX, double minY, double extra)
    {
        if (maxX >= ((x - raio) - extra) && minX <= ((x + raio) + extra))
        {
            if (maxY >= ((y-raio) - extra) && minY <= ((y + raio) - extra))
            {
                return true;
            }
        }
        return false;
    }

    private IList<double> criarRectanguloEspaco(User userDono, User userLigado, double raio, double hip)
    {
        //  Intersecção de rectangulos formados pelas ligacoes no 3D
        //
        //
        //  Topo - Esquerda
        //
        double pontoL1_P1_X = 0;
        double pontoL1_P1_Y = 0;
        //
        //  Topo - Direita
        //
        double pontoL1_P2_X = 0;
        double pontoL1_P2_Y = 0;
        //
        //  Baixo - Esquerda
        //
        double pontoL2_P1_X = 0;
        double pontoL2_P1_Y = 0;
        //
        //  Baixo - Direita
        //
        double pontoL2_P2_X = 0;
        double pontoL2_P2_Y = 0;
        //
        //  O que é retornado
        IList<double> pontos = new List<double>();

        if (userDono.X == userLigado.X)
        {
            if (userDono.Y > userLigado.Y)
            {
                pontoL1_P1_X = userDono.X - raio;
                pontoL1_P1_Y = userDono.Y + raio;
                pontoL1_P2_X = userDono.X + raio;
                pontoL1_P2_Y = userDono.Y + raio;

                pontoL2_P1_X = userLigado.X - raio;
                pontoL2_P1_Y = userLigado.Y - raio;
                pontoL2_P2_X = userLigado.X + raio;
                pontoL2_P2_Y = userLigado.Y - raio;

                

            }
            else if (userDono.Y == userLigado.Y)
            {
                return pontos;
            }
            else
            {
                pontoL1_P1_X = userDono.X - raio;
                pontoL1_P1_Y = userDono.Y - raio;
                pontoL1_P2_X = userDono.X + raio;
                pontoL1_P2_Y = userDono.Y - raio;

                pontoL2_P1_X = userLigado.X - raio;
                pontoL2_P1_Y = userLigado.Y + raio;
                pontoL2_P2_X = userLigado.X + raio;
                pontoL2_P2_Y = userLigado.Y + raio;

            }
        }
        else if (userDono.Y == userLigado.Y)
        {
            if (userDono.X > userLigado.X)
            {
                pontoL1_P1_X = userDono.X + raio;
                pontoL1_P1_Y = userDono.Y - raio;
                pontoL1_P2_X = userDono.X + raio;
                pontoL1_P2_Y = userDono.Y + raio;

                pontoL2_P1_X = userLigado.X - raio;
                pontoL2_P1_Y = userLigado.Y - raio;
                pontoL2_P2_X = userLigado.X - raio;
                pontoL2_P2_Y = userLigado.Y + raio;
            }
            else if (userDono.X == userLigado.X)
            {
                return pontos;
            }
            else
            {
                pontoL1_P1_X = userDono.X - raio;
                pontoL1_P1_Y = userDono.Y - raio;
                pontoL1_P2_X = userDono.X - raio;
                pontoL1_P2_Y = userDono.Y + raio;

                pontoL2_P1_X = userLigado.X + raio;
                pontoL2_P1_Y = userLigado.Y - raio;
                pontoL2_P2_X = userLigado.X + raio;
                pontoL2_P2_Y = userLigado.Y + raio;

            }

        }
        else if (userDono.X > userLigado.X)
        {
            if (userDono.Y > userLigado.Y)
            {
                pontoL1_P1_X = userDono.X;
                pontoL1_P1_Y = userDono.Y + hip;
                pontoL1_P2_X = userDono.X + hip;
                pontoL1_P2_Y = userDono.Y;

                pontoL2_P1_X = userLigado.X - hip;
                pontoL2_P1_Y = userLigado.Y;
                pontoL2_P2_X = userLigado.X;
                pontoL2_P2_Y = userLigado.Y - hip;


            }
            else
            {

                pontoL1_P1_X = userDono.X + hip;
                pontoL1_P1_Y = userDono.Y;
                pontoL1_P2_X = userDono.X;
                pontoL1_P2_Y = userDono.Y - hip;

                pontoL2_P1_X = userLigado.X;
                pontoL2_P1_Y = userLigado.Y + hip;
                pontoL2_P2_X = userLigado.X - hip;
                pontoL2_P2_Y = userLigado.Y;


            }
        }
        else if (userDono.X < userLigado.X)
        {
            if (userDono.Y > userLigado.Y)
            {
                pontoL1_P1_X = userDono.X;
                pontoL1_P1_Y = userDono.Y + hip;
                pontoL1_P2_X = userDono.X - hip;
                pontoL1_P2_Y = userDono.Y;

                pontoL2_P1_X = userLigado.X + hip;
                pontoL2_P1_Y = userLigado.Y;
                pontoL2_P2_X = userLigado.X;
                pontoL2_P2_Y = userLigado.Y - hip;


            }
            else
            {

                pontoL1_P1_X = userDono.X - hip;
                pontoL1_P1_Y = userDono.Y;
                pontoL1_P2_X = userDono.X;
                pontoL1_P2_Y = userDono.Y - hip;

                pontoL2_P1_X = userLigado.X;
                pontoL2_P1_Y = userLigado.Y + hip;
                pontoL2_P2_X = userLigado.X + hip;
                pontoL2_P2_Y = userLigado.Y;


            }
        }
        else
            return pontos;

        pontos.Add(pontoL1_P1_X);
        pontos.Add(pontoL1_P1_Y);
        pontos.Add(pontoL1_P2_X);
        pontos.Add(pontoL1_P2_Y);

        pontos.Add(pontoL2_P1_X);
        pontos.Add(pontoL2_P1_Y);
        pontos.Add(pontoL2_P2_X);
        pontos.Add(pontoL2_P2_Y);

        return pontos;
    }

    public string toString()
    {
        string txt = "";

        txt += NrNos;
        
        foreach (User user in Users)
        {
            txt += "\n";
            txt += user.X + " ";
            txt += user.Y + " ";
            txt += user.Z + " ";
            txt += user.Raio;
            txt += "||";
            txt += user.Username + "||[";

            foreach (string text in user.Profile)
            {
                if (user.Profile.ElementAt(0).Equals(text))
                {
                    txt += text;
                }
                else
                {
                    txt += "|" + text;
                } 
            }


            txt += "]||[";

            foreach (Tag tag in user.Tags)
            {
                if (user.Tags.ElementAt(0).Nome.Equals(tag.Nome))
                {
                    txt += tag.Nome;
                }
                else
                {
                    txt += "|" + tag.Nome;
                }
            }

            txt += "]";
        }
        txt += "\n";
        txt += NrArcos;
        

        foreach (Ligacao ligacao in Ligacoes)
        {
            txt += "\n";
            txt += ligacao.Id1 + " ";
            txt += ligacao.Id2 + " ";
            txt += ligacao.Peso + " ";
            txt += ligacao.Forca;
        }

        return txt;
    }
}


public class User
{
    public double X { get; set; }

    public double Y { get; set; }

    public double Z { get; set; }

    public string Username { get; set; }

    public IList<Graphs4Social_AR.Tag> Tags { get; set; }

    public IList<string> Profile { get; set; }

    public double Raio { get; set; }

    public bool Definido { get; set; }

    public User(string username)
    {
        Username = username;
        Profile = Graphs4Social_AR.User.LoadProfileByUser(username);
        Tags = Graphs4Social_AR.Tag.LoadAllByUsername(username);
    }
}

[DataContract]
public class Ligacao
{
    [DataMember]
    public int Id1 { get; set; }

    [DataMember]
    public int Id2 { get; set; }


    [DataMember]
    public int Peso { get; set; }

    [DataMember]
    public int Forca { get; set; }

    

    public string Tag { get; set; }

    public Ligacao(int id1, int id2, string username1, string username2)
    {
        Id1 = id1;
        Id2 = id2;

        //  Para já não utilizado
        Peso = 1;

        //  Força e Tag
        Graphs4Social_AR.Ligacao lig = Graphs4Social_AR.Ligacao.LoadByUserNames(username1, username2);

        if (lig.TagRelacao != null)
        {

            Tag = lig.TagRelacao.Nome;

        }

        Forca = lig.ForcaDeLigacao;
    }
}

[ServiceContract]
public interface IGraphs4Social_Service
{
    [OperationContract]
    string carregaGrafo(string username);


}

