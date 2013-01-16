using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IA_AR;

namespace IA_DLL_Consumer
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("A iniciar teste...\n");
            var r = new IA_AR.Utils();

            Console.Write("Nova traducao c#...\n");
            r.insertTraducao("C#", "csharp");

            Console.Write("nova lig TesteOrig/Dest...\n");
            r.insertLig("TesTeOrig", "TestEdEstino", 5);

            Console.Write("nova tag testeTag ([carlos,bruno]...\n");
            r.insertTag("testeTag", "[carlos,bruno]");

            Console.Write("novo user testeUser\n");
            r.insertUser("testeUser");

            Console.Write("novo user na tag testeTag(testeUser)\n");
            r.insertIntoTag("testeTag", "testeUser");

            Console.Write("\nVerifique agora os valores na db e pressione enter..\n");
            Console.ReadLine();

            Console.Write("A apagar traducao c#...\n");
            r.deleteTraducao("c#");

            Console.Write("A apagar lig  TesteOrig/Dest...\n");
            r.deleteLig("TesTeOrig", "TesTeOrig");

            Console.Write("A apagar tag testeTag ([carlos,bruno]...\n");
            r.deleteTag("testeTag");


            Console.Write("\nVerifique agora os valores na db e pressione enter para terminar..\n");
            Console.ReadLine();

        }
    }
}
