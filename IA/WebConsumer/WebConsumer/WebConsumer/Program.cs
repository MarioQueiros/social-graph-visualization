using System;
using System.Collections.Generic;
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
         
          /*Console.WriteLine("Nome do user:");
          string x = Console.ReadLine();*/
         
          /* var x = "bruno";
          var r = proxy.tamanhoRede(2, x);*/

          var r = proxy.debug();
          Console.Write(r);
          Console.ReadLine();
          
          //System.Diagnostics.Process.Start("C:/Users/Administrador/Documents/LaprV/IA/WebConsumer/WebConsumer/WebConsumer/WIN-PROLOG 4900/PRO386W.EXE", "/V1 consult('try.pl')");
        System.Diagnostics.Process.Start("C:/Users/Administrador/Desktop/WIN-PROLOG 4900/WINPRO386W.EXE", "/V1 consult('cons.pl')");
      
      }
    }
}

