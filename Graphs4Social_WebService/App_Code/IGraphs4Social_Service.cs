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
        //Graphs4Social_AR.User user = Graphs4Social_AR.User.LoadByUserName(username);
        
        //  Carrega as ligações do user
        IList<Graphs4Social_AR.Ligacao> ligacoes = Graphs4Social_AR.Ligacao.LoadAllByUserName(username);
        
        //  Carrega as ligações dos amigos do user
        IList<Graphs4Social_AR.Ligacao> ligacoesAmigos = new List<Graphs4Social_AR.Ligacao>();

        foreach (Graphs4Social_AR.Ligacao ligacao in ligacoes)
        {
            ligacao.

        }

        NrNos = 1 + ligacoes.Count;
        NrArcos = ligacoes.Count;
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
    public string Avatar { get; set; }

    [DataMember]
    public IList<string> Tags { get; set; }

    [DataMember]
    public IList<string> Profile { get; set; }

    public User(string username)
    {

        Graphs4Social_AR.User user = Graphs4Social_AR.User.LoadByUserName(username);
        Profile = Graphs4Social_AR.User.LoadProfileByUser(username);
        
    }
}

[DataContract]
public class Ligacao
{
    [DataMember]
    public string Informacao { get; set; }

    [DataMember]
    public string Tag { get; set; }

    public Ligacao(int id1, int id2, string username1, string username2);
}

[ServiceContract]
public interface IGraphs4Social_Service
{
    [OperationContract]
    void DoWork();

    [OperationContract]
    string carregaGrafo(string username);


}

