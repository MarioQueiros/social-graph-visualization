

/*
 * (c) 2006 - José Tavares - DEI/ISEP
 * 
 * Toda a informação necessária para fazer a interface entre o LPAProlog e o C# (.NET)
 * pode ser encontrada na documentação relacionada com o "Intelligente Server" ('INT_REF.PDF'),
 * principamente no capítulo 2 e capítulo 8.
 * 
 * Em baixo segue um pequeno exemplo de como é possível invocar predicados em Prolog a partir
 * de código em C#. Para funcionar é necessário adicionar no projecto da aplicação uma referência
 * para o assembly 'LPA.DLL'. É ainda necessário colocar os ficheiros do código fonte em PROLOG
 * na parte onde será colocado o ficheiro executável da aplicação. Devem ser também copiados para
 * essa pasta os ficheiros INT386.DLL, Pro386.EXE e INT386W.OVL (Este ficheiros estão na pasta bin/Debug
 * deste projecto).
 * 
 */


using System;
using System.Collections.Generic;
using System.Text;

namespace PrologApp
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // inicia o motor do prolog
                LPA.IntServer prolog = new LPA.IntServer("", 0, 1, 0);

                // carrega o programa em prolog ('teste.pl')
                string s = prolog.InitGoal("load_files(prolog(teste)).\n");
                s = prolog.CallGoal();
                prolog.ExitGoal();

                // executa um predicado
                //s = prolog.InitGoal("run1.\n");
                s = prolog.InitGoal("run1(hugo,mario).\n");
                s = prolog.CallGoal();
                int i = 0;
                while (s.StartsWith("T"))
                {
                    Console.WriteLine(i+" - -" +s.Substring(8));
                    s = prolog.CallGoal();
                    i++;
                }

                prolog.ExitGoal();

                // executa um predicado

              /*  prolog = new LPA.IntServer("", 0, 1, 0);
                
                s = prolog.InitGoal("run2.\n");

                s = prolog.CallGoal();
                s = prolog.TellGoal("def.\n");


                prolog.ExitGoal();*/
                //Console.WriteLine("Teste: "+s+"FIM TESTE\n");
                //Console.WriteLine("Sucesso...");
                Console.ReadLine();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.ReadLine();
            }
        }
    }
}
