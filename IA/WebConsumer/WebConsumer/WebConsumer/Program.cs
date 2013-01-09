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
          var proxy =
               new moduloIA.ModuloIaClient();
          Console.WriteLine("Nome do user:");
          string x = Console.ReadLine();
          int tamanhoRede = proxy.tamanhoRede(2, x);
          Console.Write(tamanhoRede);
      }
    }
}

