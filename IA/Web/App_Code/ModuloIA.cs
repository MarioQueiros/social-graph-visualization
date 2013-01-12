using System;
using System.Collections.Generic;
using System.Diagnostics;
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
        var op = "tamanho" + nivel + "(" + user + ",R)";

        string r = carregaPL(op);

        return int.Parse(r.Trim());
    }

    public string redeNivel(int nivel, string user)
    {
        if (nivel != 2 && nivel != 3)
            return "-1";
        var op = "redeNivel" + nivel + "(" + user + ",R)";

        return carregaPL(op);
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

    public float grauMedioSeparacao()
    {
        const string op = "grauMedio(R)";
        return float.Parse(carregaPL(op).Trim());
    }

    public string debug()
    {
        //return System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath;
        const string op = "grauMedio(R)";
        return carregaPL(op).Trim();
    }

    private string carregaPL(string op)
    {
        var cmd = "run:-iniDb,tell('output.txt')," + op + ",endDb,write(R),nl,told,exit(0).";

        string[] lines = { ":-ensure_loaded(bd).", cmd, ":-run." };
        System.IO.File.WriteAllLines(@"C:\inetpub\wwwroot\IA\WIN-PROLOG_4900\exe.pl", lines);

        var process = new Process();
        process.StartInfo.WorkingDirectory = "C:/inetpub/wwwroot/IA/WIN-PROLOG_4900/";
        process.StartInfo.FileName = "PRO386W.EXE";
        process.StartInfo.Arguments = "PRO386W.EXE /V1 consult('C:/inetpub/wwwroot/IA/WIN-PROLOG_4900/exe.pl')";
        process.Start();

        process.WaitForExit(5000);

       // Process.Start(@"C:/inetpub/wwwroot/IA/WIN-PROLOG_4900/PRO386W.EXE", "PRO386W.EXE /V1 consult('C:/inetpub/wwwroot/IA/WIN-PROLOG_4900/exe.pl')");

        var text = System.IO.File.ReadAllText(@"C:\inetpub\wwwroot\IA\WIN-PROLOG_4900\output.txt");
        return text;
    }
}
