using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Web.Security;

    public class Graphs4Social_Service : IGraphs4Social_Service
    {

        

        public Grafo carregaGrafo(string username)
        {
            return new Grafo(username, "");
        }

        public Grafo carregaGrafoAmigosComum(string username1, string username2)
        {
            return new Grafo(username1, username2);
        }

        public string caminhoMaisCurto(string username1, string username2)
        {
            ModuloIAProlog.ModuloIaClient prologService = new ModuloIAProlog.ModuloIaClient();

            string aux = prologService.caminhoCurto(username1, username2);

            prologService.Close();

            return aux;
        }

        public bool verificarUser(string username)
        {

            Graphs4Social_AR.User user = Graphs4Social_AR.User.LoadByUserName(username);

            if (user != null)
            {

                return true;
            }

            return false;
        }
    }