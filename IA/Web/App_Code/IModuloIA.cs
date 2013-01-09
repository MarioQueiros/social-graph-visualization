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
	int tamanhoRede(int nivel,string user);

    string amigosTag(string user, string tags);

    string sugerirAmigos(string user);

    string maven(string tag);

    string amigosComuns(string user1, string user2 );

    string caminhoForte(string userOrigem, string userDestino);

    string caminhoCurto(string userOrigem, string userDestino);

    float grauMedioSeparacao(string userOrigem, string userDestino);

}
