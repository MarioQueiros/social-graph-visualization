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
            return 0;
        var cmd = "runTamanhoNivel" + nivel + "(" + user + ").\n";

        try
        {
            var prolog = new LPA.IntServer("", 0, 1, 0);
            string s = prolog.InitGoal("load_files(prolog(sql)).\n");
            s = prolog.CallGoal();
            prolog.ExitGoal();

            s = prolog.InitGoal(cmd);
            s = prolog.CallGoal();
            var r = int.Parse(s.Substring(8));
            prolog.ExitGoal();
            return r;
        }catch(Exception except)
        {
            return -1;
        }
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

    public string debug()
    {
        //return System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath;
        var cmd = "runTamanhoNivel" + 2 + "(" + "bruno" + ").\n";

        try
        {
            var prolog = new LPA.IntServer("", 0, 1, 0);
            string s = prolog.InitGoal("load_files(prolog(sql)).\n");
            s = prolog.CallGoal();
            prolog.ExitGoal();

            s = prolog.InitGoal(cmd);
            s = prolog.CallGoal();
            var r =s.Substring(8);
            prolog.ExitGoal();
            return r;
        }
        catch (Exception except)
        {
            return except.Message;
        }
    }
}
