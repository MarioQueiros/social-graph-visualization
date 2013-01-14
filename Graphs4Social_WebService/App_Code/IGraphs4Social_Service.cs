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
    [DataMember]
    public int NrNos { get; set; }
    [DataMember]
    public int NrArcos { get; set; }
    [DataMember]
    public IList<User> Users { get; set; }
    [DataMember]
    public IList<Ligacao> Ligacoes { get; set; }

    public Grafo(string username)
    {

        //  Carrega o user "dono" do grafo
        Users.Add(new User(username));
        
        //  Carrega as ligações do user
        //  IList<string> ligacoes = RedeNivel2(userdono,U)
        IList<Graphs4Social_AR.Ligacao> ligacoesDono = Graphs4Social_AR.Ligacao.LoadAllByUserName(username);

        //  Carrega as ligações dos amigos do user
        IList<Graphs4Social_AR.Ligacao> ligacoesAmigos;





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
        IList<string> ligacoesNaoDirectas = new List<string>();

        foreach (Graphs4Social_AR.Ligacao ligacao in ligacoesDono){

            string usernameAmigo = ligacao.UserLigado.Username;

            ligacoesAmigos = Graphs4Social_AR.Ligacao.LoadAllByUserName(username);

            foreach(User userAmigo in Users){
                if(!userAmigo.Username.Equals(usernameAmigo)){

                }
            }
        }

    }
}


[DataContract]
public class User
{
    [DataMember]
    public double X { get; set; }

    [DataMember]
    public double Y { get; set; }

    [DataMember]
    public double Z { get; set; }

    [DataMember]
    public string Username { get; set; }

    [DataMember]
    public IList<Graphs4Social_AR.Tag> Tags { get; set; }

    [DataMember]
    public IList<string> Profile { get; set; }

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



    [DataMember]
    public string Tag { get; set; }

    public Ligacao(int id1, int id2, string username1, string username2)
    {
        Id1 = id1;
        Id2 = id2;

        //  Para já não utilizado
        Peso = 1;

        //  Força e Tag
        Graphs4Social_AR.Ligacao lig = new Graphs4Social_AR.Ligacao();

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
        void DoWork();

        [OperationContract]
        string carregaGrafo(string username);


    }

