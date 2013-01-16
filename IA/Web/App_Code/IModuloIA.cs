using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

// NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "ImoduloIA" in both code and config file together.
[ServiceContract]
public interface IModuloIa
{
	[OperationContract]
	string tamanhoRede(int nivel,string user);

    [OperationContract]
    string redeNivel(int nivel, string user);

    [OperationContract]
    string amigosTag(string user, string tags);

    [OperationContract]
    string sugerirAmigos(string user);

    [OperationContract]
    string maven(string tag);

    [OperationContract]
    string amigosComuns(string user1, string user2 );

    [OperationContract]
    string caminhoForte(string userOrigem, string userDestino);

    [OperationContract]
    string caminhoCurto(string userOrigem, string userDestino);

    [OperationContract]
    string grauMedioSeparacao();

    [OperationContract]
    string grafoNivel3(string user);

    [OperationContract]
    string debug();

}
