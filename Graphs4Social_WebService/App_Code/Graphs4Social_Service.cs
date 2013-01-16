using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

    public class Graphs4Social_Service : IGraphs4Social_Service
    {

        public string DoWork()
        {
            return "Enviado.";
        }

        public Grafo carregaGrafo(string username)
        {
            return new Grafo(username, "");
        }

        public string carregaGrafoAmigosComum(string username1, string username2)
        {
            Grafo grafo = new Grafo(username1, username2);
            return grafo.toString();
        }
    }