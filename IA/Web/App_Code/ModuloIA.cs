using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

public class moduloIA : IModuloIa
{
    public int tamanhoRede(int nivel, string user)
    {
        if (nivel != 2 && nivel != 3)
            return -1;
        var cmd = "runTamanhoNivel" + nivel + "(" + user + ").\n";
        var prolog = new LPA.IntServer("", 0, 1, 0);
        string s = prolog.InitGoal("load_files(prolog(db)).\n");
        s = prolog.CallGoal();
        prolog.ExitGoal();
        s = prolog.InitGoal("runTamanhoNivel"+nivel+"(+"+user+"user).\n");
        s = prolog.CallGoal();
        prolog.ExitGoal();
        return int.Parse(s.Substring(8));
    }

    public string amigosTag(string user, string tags)
    {
        throw new NotImplementedException();
    }

    public string sugerirAmigos(string user)
    {
        throw new NotImplementedException();
    }

    public string maven(string tag)
    {
        throw new NotImplementedException();
    }

    public string amigosComuns(string user1, string user2)
    {
        throw new NotImplementedException();
    }

    public string caminhoForte(string userOrigem, string userDestino)
    {
        throw new NotImplementedException();
    }

    public string caminhoCurto(string userOrigem, string userDestino)
    {
        throw new NotImplementedException();
    }

    public float grauMedioSeparacao(string userOrigem, string userDestino)
    {
        throw new NotImplementedException();
    }
}
