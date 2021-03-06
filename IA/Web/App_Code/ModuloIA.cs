﻿using System;
using System.Diagnostics;
using System.Security;

public class moduloIA : IModuloIa
{
    public string tamanhoRede(int nivel, string user)
    {
        if (nivel != 2 && nivel != 3)
            return "-1";
        var op = "tamanho" + nivel + "(" + user.ToLower() + ",R)";

        return carregaPL(op).Trim();
    }

    public string redeNivel(int nivel, string user)
    {
        if (nivel != 2 && nivel != 3)
            return "-1";
        var op = "redeNivel" + nivel + "(" + user.ToLower() + ",R)";

        return carregaPL(op);
    }

    public string amigosTag(string user, string tags)
    {
        if (tags.Contains("[") || tags.Contains("]"))
            return "verifique o envio de tags (colocou '[|]'?)";
        return carregaPL("amigosTag(" + user.ToLower() + ",[" + tags.ToLower() + "],R)");
    }

    public string sugerirAmigos(string user)
    {
        return carregaPL("sugereAmigos(" + user.ToLower() + ",R)");
    }

    public string maven(string tag)
    {
        return carregaPL("maven(" + tag.ToLower() + ",R)");
    }

    public string amigosComuns(string user1, string user2)
    {
        return carregaPL("grafoComum(" + user1.ToLower() + "," + user2.ToLower() + ",R)");
    }

    public string caminhoForte(string userOrigem, string userDestino)
    {
        return carregaPL("camForte(" + userOrigem.ToLower() + "," + userDestino.ToLower() + ",R)");
    }

    public string caminhoCurto(string userOrigem, string userDestino)
    {
        return carregaPL("camCurto(" + userOrigem.ToLower() + "," + userDestino.ToLower() + ",R)");
    }

    public string grauMedioSeparacao()
    {
        const string op = "grauMedio(R)";
        var x = carregaPL(op).Trim();
        if (x != "-1")
            return x.Substring(0, 5);
        else
            return "ERRO! verifique se existem ligacoes na bd do prolog";
    }

    public string grafoNivel3(string user)
    {
        return carregaPL("grafoNivel3(" + user.ToLower() + ",R)");
    }

    public string traduzir(string orig)
    {
        return carregaPL("traduzir(" + orig.ToLower()+ ",R)");
    }

    public string debug()
    {
        return System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath;
        //return Process.GetProcesses()[0].Modules[0].FileName;
        /*const string op = "grauMedio(R)";
        return carregaPL(op);*/
    }

    private string carregaPL(string op)
    {

        const string dir = "C:\\inetpub\\wwwroot\\PL\\";
        var cmd = "run:-iniDb,tell('" + dir + "output.txt'),(" + op + ";R is -1),write(R),endDb,nl,told,exit(0).";

        string[] lines = { ":-ensure_loaded('" + dir + "bd').", cmd, ":-run." };

        try
        {
            System.IO.File.WriteAllLines(dir + "exe.pl", lines);
        }
        catch (Exception e)
        {
            System.Threading.Thread.Sleep(2000);
            try
            {
                System.IO.File.WriteAllLines(dir + "exe.pl", lines);
            }
            catch (Exception es)
            {
                System.Threading.Thread.Sleep(4000);
                System.IO.File.WriteAllLines(dir + "exe.pl", lines);
            }
        }

        const string exe = dir + "PRO386W.EXE";
        const string arg = "consult('C:\\inetpub\\wwwroot\\PL\\exe.pl').";

        var processStartInfo = new ProcessStartInfo(exe, arg) { UseShellExecute = false };
        var xs = Process.Start(processStartInfo);
        xs.WaitForExit(5000);
  

        string text = System.IO.File.ReadAllText(dir + "output.txt");
        return text;


        //teste iis local c/ drive mapeada em W
        // var cmd = "run:-iniDb,tell('W:\\PL\\output.txt')," + op + ",write(R),endDb,nl,told,exit(0).";
        // string[] lines = { ":-ensure_loaded('W:\\PL\\bd').", cmd, ":-run." };
        // System.IO.File.WriteAllLines(@"W:\\PL\\exe.pl", lines);

        // String exe = "W:\\PL\\PRO386W.EXE";
        // //String arg = "/V1 consult('C:\\inetpub\\wwwroot\\PL\\exe.pl').";
        // String arg = "consult('W:\\PL\\exe.pl').";
        // var processStartInfo = new System.Diagnostics.ProcessStartInfo(exe, arg);
        // processStartInfo.UseShellExecute = false;
        // System.Diagnostics.Process.Start(processStartInfo);

        // String[] temp = { exe + " " + arg };
        // System.IO.File.WriteAllLines(@"W:\PL\DEBUG.TXT", temp);*/

        // System.Diagnostics.Process.Start(processStartInfo);

        // System.Threading.Thread.Sleep(1500);

        // string text = System.IO.File.ReadAllText(@"W:\PL\output.txt");
        // return text;
    }
}
