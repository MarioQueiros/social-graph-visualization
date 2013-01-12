using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

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

    public Grafo(string username);
}


[DataContract]
public class User
{
    [DataMember]
    public string Coordenadas { get; set; }

    [DataMember]
    public string Avatar { get; set; }

    [DataMember]
    public IList<string> Tags { get; set; }

    [DataMember]
    public IList<string> Profile { get; set; }

    public User(string username);
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


}

