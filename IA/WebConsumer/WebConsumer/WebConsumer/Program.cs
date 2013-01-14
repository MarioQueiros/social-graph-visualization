using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebConsumer
{
    class Program
    {
      static  void Main(string[] args)
      {
          var proxy =new moduloIA.ModuloIaClient();

          /* var x = "bruno";
          var r = proxy.tamanhoRede(2, x);*/

         /* var p = new Process();
          p.StartInfo = new ProcessStartInfo("cmd", "notepad" + " " + "exe.txt")
          {
              UseShellExecute = false,
              CreateNoWindow = false
          };
          p.Start();

          p.WaitForExit();*/

          Console.Write("A Pedir tamanho de rede, aguarde...\n");
          string r = proxy.tamanhoRede(2, "sara").ToString();
          Console.WriteLine(r);

          Console.WriteLine("A pedir rede nivel 3, aguarde...");
          r = proxy.redeNivel(3, "sara");
          Console.WriteLine(r);

          Console.WriteLine("A pedir amigos tag, aguarde...(deve ser bruno)");
          r = proxy.amigosTag("sara", "chelsea");
          Console.WriteLine(r);
          
          Console.WriteLine("A pedir sugestoes amigos, aguarde (deve ser vazio)...");
          r = proxy.sugerirAmigos("carlos");
          Console.WriteLine(r);

          Console.WriteLine("A pedir maven, aguarde (mario)...");
          r = proxy.maven("comida");
          Console.WriteLine(r);

          Console.WriteLine("A pedir amigosComuns, aguarde (? mario,)...");
          r = proxy.amigosComuns("bruno","carlos");
          Console.WriteLine(r);

          Console.WriteLine("A pedir caminhoForte hugo-sara, aguarde(hugo,mario,bruno,catia,sara)...");
          r = proxy.caminhoForte("hugo", "sara");
          Console.WriteLine(r);

          Console.WriteLine("A pedir caminhoCurto hugo-sara, aguarde(hugo,catia,sara)...");
          r = proxy.caminhoCurto("hugo", "sara");
          Console.WriteLine(r);

          Console.WriteLine("A pedir GMS, aguarde(~3.1)...");
          float f = proxy.grauMedioSeparacao();
          Console.WriteLine(f);

          Console.WriteLine("termine o programa.");
          Console.ReadLine();
      }
    }
}

