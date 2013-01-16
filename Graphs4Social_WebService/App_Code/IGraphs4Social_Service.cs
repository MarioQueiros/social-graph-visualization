using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Graphs4Social_AR;

[ServiceContract]
public interface IGraphs4Social_Service
{
    [OperationContract]
    Grafo carregaGrafo(string username);

    [OperationContract]
    Grafo carregaGrafoAmigosComum(string username1, string username2);

    [OperationContract]
    string caminhoMaisCurto(string username1, string username2);

}



[DataContract]
public class Grafo
{
    [DataMember]
    public int NrNos { get; set; }

    [DataMember]
    public int NrArcos { get; set; }

    [DataMember]
    public IList<User> Users { get; set; }

    [DataMember]
    public IList<Ligacao> Ligacoes { get; set; }

    //  Username apenas para grafo simples.
    //  Ambos usernames definidos para grafo de amigos em comum

    public Grafo(string username,string username1)
    {

        ModuloIAProlog.ModuloIaClient prologService = new ModuloIAProlog.ModuloIaClient();

        Users = new List<User>();
        Ligacoes = new List<Ligacao>();
        int numTagsTotal = Graphs4Social_AR.Tag.LoadAllTag().Count;
        //

        if (!username1.Equals(""))
        {
            string pedidosuser = prologService.redeNivel(2, username);
            string pedidosuser1 = prologService.redeNivel(2, username1);

            char[] separator = new char[3];

            separator[0] = ']';
            separator[1] = ',';
            separator[2] = '[';

            string[] arraytemp = new string[pedidosuser.Length + pedidosuser1.Length];

            IList<string> ligacoes = pedidosuser.Split(separator);

            IList<string> ligacoes1 = pedidosuser1.Split(separator);
            ligacoes.CopyTo(arraytemp, 0);

            ligacoes1.CopyTo(arraytemp, ligacoes.Count);



            ligacoes = new List<string>();

            for (int i = 0; i < arraytemp.Length; i++)
            {
                if (!ligacoes.Contains(arraytemp[i]) && !(arraytemp[i].Equals("") || arraytemp[i] == null))
                {
                    ligacoes.Add(arraytemp[i]);
                }

            }


            //  Carrega o user "dono" do grafo
            Users.Add(new User(username, 0, prologService,numTagsTotal));
            Users[0].Definido = true;
            Users[0].X = -50;
            Users[0].Y = -50;
            //  Carrega as ligações do user
            //  IList<string> ligacoes = RedeNivel2(userdono,U)

            Users.Add(new User(username1, 1, prologService,numTagsTotal));
            Users[1].Definido = true;
            Users[1].X = 50;
            Users[1].Y = 50;
        }
        else
        {
            
            //  Carrega as ligações do grafo do username a nível 3
            string pedidoLigacoes = prologService.grafoNivel3(username);

            pedidoLigacoes = pedidoLigacoes.Substring(1, pedidoLigacoes.Length - 2);




            char [] separator = new char [3];

            separator[0]=']';
            separator[1]=',';
            separator[2]='[';

            IList<string> ligacoes = pedidoLigacoes.Split(separator);



            while(true){

                if (!(ligacoes.Count < 2))
                {
                    Ligacoes = Ligacao.trataListas(ligacoes, username, prologService, numTagsTotal);
                    break;
                }

                pedidoLigacoes = prologService.grafoNivel3(username);

                pedidoLigacoes = pedidoLigacoes.Substring(1, pedidoLigacoes.Length - 2);

                ligacoes = pedidoLigacoes.Split(separator);

                prologService.Close();
            }



            foreach(Ligacao lig in Ligacoes)
            {
                if(!Users.Contains(lig.User1)){
                    Users.Add(lig.User1);
                }
                if(!Users.Contains(lig.User2)){
                    Users.Add(lig.User2);
                }
            }

            //  Carrega o user "dono" do grafo
            Users[0].Definido = true;
            Users[0].X = 0;
            Users[0].Y = 0;
        }

        prologService.Close();

        NrNos = Users.Count;
        NrArcos = Ligacoes.Count;

        int tentativas = 0;
        bool notDone = true;
        bool flagBreak = false;

        int max = 8 * NrArcos;
        Random valor = new Random();


        while (notDone)
        {
            for(int k = 0;k<Ligacoes.Count;k++)
            {
                if (!Ligacoes[k].User2.Definido)
                {
                    if (valor.NextDouble() >= 0.5)
                    {
                        Ligacoes[k].User2.X = valor.Next(10, max) * -1;
                    }
                    else
                    {
                        Ligacoes[k].User2.X = valor.Next(10, max);
                    }
                    //
                    if (valor.NextDouble() >= 0.5)
                    {
                        Ligacoes[k].User2.Y = valor.Next(10, max) * -1;
                    }
                    else
                    {
                        Ligacoes[k].User2.Y = valor.Next(10, max);
                    }
                    
                }
                else
                    tentativas = 49;

                
                for (int j = 0; j < NrArcos; j++)
                {
                    if (!(tentativas >= 50))
                    {
                        if (!(Ligacoes[j].User1.Id == Ligacoes[k].User1.Id && Ligacoes[j].User2.Id == Ligacoes[k].User2.Id))
                        {
                            if (intersecta(Ligacoes[j].User1, Ligacoes[j].User2, Ligacoes[k].User1, Ligacoes[k].User2))
                            {
                                tentativas++;
                                flagBreak = true;
                                break;
                            }

                        }
                    }
                    else
                        break;

                }
                if (tentativas >= 50)
                {
                    flagBreak = false;
                    break;
                }
                else if (!flagBreak)
                    Ligacoes[k].User2.Definido = true;
                else
                {
                    flagBreak = false;
                    k--;
                }
            }
            if (!(tentativas >= 50))
                notDone = false;
            else
            {
                tentativas = 0;
                for (int j = 0; j < NrNos; j++)
                {
                    Users[j].Definido = false;
                }
            }
        }

    }

    public bool intersecta(User userDono1, User userLigado1, User userDono2, User userLigado2)
    {
        if (userLigado1.Definido)
        {
            double x = 0, y = 0;

            bool intersect = false;
            bool flag = false;

            double ua_t = (userLigado2.X - userDono2.X) * (userDono1.Y - userDono2.Y) - (userLigado2.Y - userDono2.Y) * (userDono1.X - userDono2.X);
            double ub_t = (userLigado1.X - userDono1.X) * (userDono1.Y - userDono2.Y) - (userLigado1.Y - userDono1.Y) * (userDono1.X - userDono2.X);
            double u_b = (userLigado2.Y - userDono2.Y) * (userLigado1.X - userDono1.X) - (userLigado2.X - userDono2.X) * (userLigado1.Y - userDono1.Y);

            double extra = 2;


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
                return false;
            }
            else
            {
                if (flag)
                {
                    if (userLigado2.Definido)
                    {
                        if ((userDono2.X == userLigado1.X && userDono2.Y == userLigado1.Y))
                        {
                            if (intersectaCirculoCirculo(userDono1, userLigado2, extra))
                            {
                                return true;
                            }
                        }
                        else if ((userDono2.X == userDono1.X && userDono2.Y == userDono1.Y))
                        {
                            if (intersectaCirculoCirculo(userDono2, userLigado2, extra))
                            {
                                return true;
                            }
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
                        }
                        return false;
                    }
                    else
                    {
                        if ((userDono1.X == userLigado2.X && userDono1.Y == userLigado2.Y)
                            || (userLigado1.X == userLigado2.X && userLigado1.Y == userLigado2.Y)
                            || (userDono2.X == userLigado2.X && userDono2.Y == userLigado2.Y))
                        {
                            return true;
                        }
                        else if ((userDono2.X == userLigado1.X && userDono2.Y == userLigado1.Y))
                        {
                            if (intersectaCirculoCirculo(userDono1, userLigado2, extra))
                            {
                                return true;
                            }
                        }
                        else if ((userDono2.X == userDono1.X && userDono2.Y == userDono1.Y))
                        {
                            if (intersectaCirculoCirculo(userDono2, userLigado2, extra))
                            {
                                return true;
                            }
                        }
                        else
                        {

                            if (intersectaCirculoCirculo(userDono2, userLigado2, extra))
                            {
                                return true;
                            }
                            if (intersectaCirculoCirculo(userDono1, userLigado2, extra))
                            {
                                return true;
                            }
                            if (intersectaCirculoCirculo(userLigado1, userLigado2, extra))
                            {
                                return true;
                            }
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
                        }


                        IList<double> pontosLigacao = this.criarRectanguloEspaco(userDono1, userLigado1, extra);
                        //
                        //  Topo    -   Esquerda     [0] - [1]
                        //  Topo    -   Direita      [2] - [3]
                        //  Baixo   -   Esquerda     [4] - [5]
                        //  Baixo   -   Direita      [6] - [7]
                        //
                        //
                        //
                        if (interseccaoLinhaCirculo(userLigado2, extra, pontosLigacao[0], pontosLigacao[1], pontosLigacao[4], pontosLigacao[5]))
                            {
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado2, extra, pontosLigacao[2], pontosLigacao[3], pontosLigacao[6], pontosLigacao[7]))
                            {
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado2, extra , pontosLigacao[0], pontosLigacao[1], pontosLigacao[2], pontosLigacao[3])){
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado2, extra , pontosLigacao[4], pontosLigacao[5], pontosLigacao[6], pontosLigacao[7])){
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado2, extra , pontosLigacao[0], pontosLigacao[1], pontosLigacao[6], pontosLigacao[7])){
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado2, extra , pontosLigacao[2], pontosLigacao[3], pontosLigacao[4], pontosLigacao[5])){
                                return true;
                            }
                        //
                        //
                        //  Verificar se o circulo UserLigado1 intersecta nos limites do rectangulo formado pela nova ligacao
                        //
                        //
                        if (!(userLigado1.X == userDono2.X && userLigado1.Y == userDono2.Y))
                        {
                            pontosLigacao = this.criarRectanguloEspaco(userDono2, userLigado2, extra);
                            //
                            //  Topo    -   Esquerda     [0] - [1]
                            //  Topo    -   Direita      [2] - [3]
                            //  Baixo   -   Esquerda     [4] - [5]
                            //  Baixo   -   Direita      [6] - [7]
                            //
                            //
                            //
                            if (interseccaoLinhaCirculo(userLigado1, extra, pontosLigacao[0], pontosLigacao[1], pontosLigacao[4], pontosLigacao[5]))
                            {
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado1, extra, pontosLigacao[2], pontosLigacao[3], pontosLigacao[6], pontosLigacao[7]))
                            {
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado1, extra , pontosLigacao[0], pontosLigacao[1], pontosLigacao[2], pontosLigacao[3])){
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado1, extra , pontosLigacao[4], pontosLigacao[5], pontosLigacao[6], pontosLigacao[7])){
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado1, extra , pontosLigacao[0], pontosLigacao[1], pontosLigacao[6], pontosLigacao[7])){
                                return true;
                            }
                            else if (interseccaoLinhaCirculo(userLigado1, extra, pontosLigacao[2], pontosLigacao[3], pontosLigacao[4], pontosLigacao[5]))
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
            return false;
        }
        else
        {
            return false;
        }
    }

    private bool intersectaCirculoCirculo(User userDono, User userLigado, double extra)
    {
        // Determine minimum and maximum radii where circles can intersect
        double r_max = (userDono.Raio + extra) + (userLigado.Raio + extra);

        // Determine actual distance between circle circles
        double c1 = Math.Abs(userDono.X - userLigado.X);
        //
        double c2 = Math.Abs(userDono.Y - userLigado.Y);
        //
        double c_dist = Math.Sqrt(Math.Pow(c1, 2) + Math.Pow(c2, 2));

        if (c_dist > r_max)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    private bool interseccaoLinhaCirculo(User user, double extra, double user1X, double user1Y, double user2X, double user2Y)
    {
        double raio = user.Raio + extra;

        double a = (user2X - user1X) * (user2X - user1X) +
                 (user2Y - user1Y) * (user2Y - user1Y);
        double b = 2 * ((user2X - user1X) * (user1X - user.X) +
                       (user2Y - user1Y) * (user1Y - user.Y));
        double cc = user.X * user.X + user.Y * user.Y + user1X * user1X + user1Y * user1Y -
                 2 * (user.X * user1X + user.Y * user1Y) - raio * raio;
        double deter = b * b - 4 * a * cc;

        if (deter < 0)
        {
            return false;
        }
        else if (deter == 0)
        {
            return true;
        }
        else
        {
            double e = Math.Sqrt(deter);
            double u1 = (-b + e) / (2 * a);
            double u2 = (-b - e) / (2 * a);

            if ((u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1))
            {
                if ((u1 < 0 && u2 < 0) || (u1 > 1 && u2 > 1))
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else
            {
                return true;
            }
        }
    }

    private bool verificarEspaco(double x, double y, double raio, double maxX, double maxY, double minX, double minY)
    {
        if (maxX >= (x + raio) && minX <= (x - raio))
        {
            if (maxY >= (y + raio) && minY <= (y - raio))
            {
                return true;
            }
        }
        return false;
    }

    private IList<double> criarRectanguloEspaco(User userDono, User userLigado,double extra)
    {
        double raio = extra;
        double hip = 0;

        if (userDono.Raio > userLigado.Raio)
        {
            raio = raio + userDono.Raio;
            hip = Math.Sqrt(Math.Pow(userDono.Raio, 2) + Math.Pow(userDono.Raio, 2));
        }
        else
        {
            raio = raio + userLigado.Raio;
            hip = Math.Sqrt(Math.Pow(userLigado.Raio, 2) + Math.Pow(userLigado.Raio, 2));
        }

        

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
            txt += Convert.ToString(user.X).Replace(',','.') + " ";
            txt += Convert.ToString(user.Y).Replace(',', '.') + " ";
            txt += Convert.ToString(user.Z).Replace(',', '.') + " ";
            txt += Convert.ToString(user.Raio).Replace(',', '.');
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

            foreach (string tag in user.Tags)
            {
                if (user.Tags.ElementAt(0).Equals(tag))
                {
                    txt += tag;
                }
                else
                {
                    txt += "|" + tag;
                }
            }

            txt += "]";
        }
        txt += "\n";
        txt += NrArcos;


        foreach (Ligacao ligacao in Ligacoes)
        {
            txt += "\n";
            txt += ligacao.User1.Id + " ";
            txt += ligacao.User2.Id + " ";
            txt += ligacao.Peso + " ";
            txt += ligacao.Forca;
        }

        return txt;
    }
}


[DataContract]
public class User
{
    [DataMember]
    public int Id { get; set; }

    [DataMember]
    public double X { get; set; }

    [DataMember]
    public double Y { get; set; }

    [DataMember]
    public double Z { get; set; }

    [DataMember]
    public string Username { get; set; }

    [DataMember]
    public IList<string> Tags { get; set; }

    [DataMember]
    public IList<string> Profile { get; set; }

    [DataMember]
    public double Raio { get; set; }

    [DataMember]
    public bool Definido { get; set; }

    public User(string username, int id, ModuloIAProlog.ModuloIaClient prologService,int numTagsTotal)
    {
        double minraio = 3;
        double maxraio = 7.5;

        Id = id;
        Username = username;

        Profile = Graphs4Social_AR.User.LoadProfileByUser(username);

        IList<Graphs4Social_AR.Tag> tagList = Graphs4Social_AR.Tag.LoadAllByUsername(username);
        Tags = new List<string>();
        foreach (Graphs4Social_AR.Tag tag in tagList)
        {
            Tags.Add(tag.Nome);
        }

        Z = Convert.ToDouble(prologService.tamanhoRede(2, Username));
        //
        int numTags = Tags.Count;
        //
        Raio = minraio + ((maxraio - minraio) * (Convert.ToDouble(numTags) / Convert.ToDouble(numTagsTotal)));

    }
}

[DataContract]
public class Ligacao
{
    [DataMember]
    public User User1 { get; set; }

    [DataMember]
    public User User2 { get; set; }

    [DataMember]
    public int Peso { get; set; }

    [DataMember]
    public int Forca { get; set; }


    public Ligacao(User user1, User user2, int forca)
    {
        User1 = user1;
        User2 = user2;

        //  Para já não utilizado
        Peso = 1;

        //  Força

        Forca = forca;
    }

    public static IList<Ligacao> trataListas(IList<string> ligacoes1, string username, ModuloIAProlog.ModuloIaClient prologService, int numTagsTotal)
    {
        IList<string> ligacoes = new List<string>();
        IList<string> tags = new List<string>();

        


        foreach (string lig in ligacoes1)
        {

            if (!lig.Equals(""))
            {
                ligacoes.Add(lig);

            }
        }


        IList<User> users = new List<User>();
        IList<string> usernames = new List<string>();

        IList<Ligacao> ligacoesRetornadas = new List<Ligacao>();
        IList<Ligacao> ligacoesDirectas = new List<Ligacao>();

        users.Add(new User(username,0,prologService,numTagsTotal));
        usernames.Add(username);

        int id = 1;

        for(int k=0;k<ligacoes.Count-1;k=k+3)
        {

            if (!usernames.Contains(ligacoes[k + 1]))
            {
                usernames.Add(ligacoes[k + 1]);
                users.Add(new User(ligacoes[k + 1], id, prologService, numTagsTotal));
                id++;
            }

            if (usernames.IndexOf(ligacoes[k]) == 0)
            {
                ligacoesDirectas.Add(new Ligacao(users[0], users[usernames.IndexOf(ligacoes[k + 1])], Convert.ToInt32(ligacoes[k + 2])));
            }
            else
            {
                ligacoesRetornadas.Add(new Ligacao(users[usernames.IndexOf(ligacoes[k])], users[usernames.IndexOf(ligacoes[k + 1])], Convert.ToInt32(ligacoes[k + 2])));
            }

        }




        Ligacao aux;

        //  Depois fazemos sort
        for(int i = 0;i< ligacoesDirectas.Count-1; i++)
        {

            if(ligacoesDirectas[i].Forca < ligacoesDirectas[i+1].Forca){
                aux = ligacoesDirectas[i];
                ligacoesDirectas[i] = ligacoesDirectas[i + 1];
                ligacoesDirectas[i + 1] = aux;
                i = 0;
            }

        }

        Ligacao[] arraytemp = new Ligacao[ligacoesDirectas.Count+ligacoesRetornadas.Count];

        
        ligacoesDirectas.CopyTo(arraytemp, 0);
        ligacoesRetornadas.CopyTo(arraytemp, ligacoesDirectas.Count);

        ligacoesRetornadas = arraytemp.ToList();

        ligacoesDirectas = new List<Ligacao>();

        foreach (Ligacao lig in ligacoesRetornadas)
        {
            if (lig.User2.Id > lig.User1.Id)
            {
                ligacoesDirectas.Add(lig);
            }
        }

        return ligacoesDirectas;
    }
}




