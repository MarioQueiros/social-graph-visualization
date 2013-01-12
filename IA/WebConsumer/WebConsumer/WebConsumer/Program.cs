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

          /* var x = "bruno";
          var r = proxy.tamanhoRede(2, x);*/

          var r = proxy.debug();
          Console.Write(r);
          Console.ReadLine();

      }
    }
}

