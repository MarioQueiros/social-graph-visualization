using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Graphs4Social_AR
{
    public class User : ActiveRecord
    {

        // Classe Users da Base de Dados
        //      Classe de interação com o Membership do Website
        //      
        //      Tem um identificador do User:
        //      -> Unique Identifier
        //
        //      Tem um campo atribuido aquando a tabela UserLigado
        //

        // Unique Identifier do User
        private string _uniqueIdentifierUserId;

        // Inteiro id do User Ligado (Cada user também vai ter um id de user ligado, pois vão ser users ligados
        //      de um user "dono"
        private int _idUserLigado;

        // Campo para verificar se foi gravado com sucesso ( iniciado a false ) e um campo para delete
        private bool _gravado = false;
        private bool _eliminado = false;

        // Nome do User
        private string _username;

        public User()
        {
            _idUserLigado = -1;
        }

        // O Website não vai precisar de um construtor com dados string mas sim de um user com dados
        //      de um DataRow
        //
        public User(DataRow user, DataRow ligado)
        {
            if (user != null)
            {
                this._uniqueIdentifierUserId = Convert.ToString(user["UserId"]);
                this._username = Convert.ToString(user["UserName"]);

                if (ligado != null)
                {
                    this._idUserLigado = (int)ligado["ID_ULIG"];
                    if ((int)ligado["ELIMINADO"] == 0)
                        this._eliminado = false;
                    else
                        this._eliminado = true;
                }
                else
                    Save();
            }
            else
            {
                this._uniqueIdentifierUserId = Convert.ToString(-1);
                this._idUserLigado = -1;
            }
        }



        // Gets e Sets
        //
        //
        //
        public string UniqueIdentifierUserId
        {
            get { return _uniqueIdentifierUserId; }
            set { this._uniqueIdentifierUserId = value; }
        }

        public int IdUserLigado
        {
            get { return _idUserLigado; }
            set { this._idUserLigado = value; }
        }

        public bool Gravado
        {
            get { return _gravado; }
            set { this._gravado = value; }
        }

            public bool Eliminado
        {
            get { return _eliminado; }
            set { this._eliminado = value; }
        }

            public string Username
            {
                get { return _username; }
                set { this._username = value; }

            }


        // To String
        //
        //
        //
        public override string ToString()
        {
            return UniqueIdentifierUserId+" "+IdUserLigado+" "+Gravado+" "+Eliminado;
        }
        

        
        // Metodos
        //
        //
        // Não há necessidade de criar uma entrada na tabela UserLigado porque o construtor do User
        //      através de um Save no mesmo fazendo algo do género de Lazy Load mas diferente em
        //      termos de como foi feito e o que influencia ( Uma tabela de uma Db e não um objecto )
        //
        // Remover um User por username. No fim retorna true pois não apagou por nem existir (fake delete)
        public static bool RemoverUser(string username)
        {
            User user = User.LoadByUserName(username);

            if (user != null)
            {

                return user.Delete();

            }

            return true;
        }




        // Load
        //
        //
        //
        // Load da tabela User através do Unique Identifier
        public static User LoadByUniqueIdentifier(string uniqueIdentifier)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Users WHERE UserId='" + uniqueIdentifier + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
            {
                DataSet dt = ExecuteQuery(GetConnection(false), "SELECT * FROM UserLigado WHERE UserId='" + uniqueIdentifier + "' AND ELIMINADO ='" + 0 + "'");
                if (dt.Tables[0].Rows.Count < 1)
                {
                    return new User(ds.Tables[0].Rows[0], null);
                }
                else
                {
                    return new User(ds.Tables[0].Rows[0], dt.Tables[0].Rows[0]);
                }
            }
        }
                      
        // Load da tabela UserLigado através do Id da respectiva tabela
        public static User LoadByUserLigadoId(int idUserLigado)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM UserLigado WHERE ID_ULIG='" + idUserLigado + "' AND ELIMINADO ='" + 0 + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
            {
                DataSet dt = ExecuteQuery(GetConnection(false), "SELECT * FROM Users WHERE UserId='" + (int)ds.Tables[0].Rows[0]["UserId"] + "'");
                return new User(dt.Tables[0].Rows[0], ds.Tables[0].Rows[0]);
            }
        }

        // Load de um User através do Username
        public static User LoadByUserName(string username)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Users WHERE UserName ='" + username + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
            {
                DataSet dt = ExecuteQuery(GetConnection(false), "SELECT * FROM UserLigado WHERE UserId='" + ds.Tables[0].Rows[0]["UserId"] + "' AND ELIMINADO ='" + 0 + "'");
                if (dt.Tables[0].Rows.Count < 1)
                {
                        return new User(ds.Tables[0].Rows[0], null);
                }
                else
                {
                    return new User(ds.Tables[0].Rows[0], dt.Tables[0].Rows[0]);
                    
                }
            }
        }

        public static IList<User> LoadAllAmigosUser(string username)
        {
            if (LoadByUserName(username) != null)
            {
                DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE UserId ='"
                    + LoadByUserName(username).UniqueIdentifierUserId + "' AND ELIMINADO ='" + 0 + "' AND ESTADO ='"
                    + 1 + "'");

                IList<Ligacao> lista = new List<Ligacao>();

                Ligacao ligacao = null;
                int idLigacao = -1;

                foreach (DataRow row in ds.Tables[0].Rows)
                {

                    ligacao = new Ligacao(row);
                    lista.Add(ligacao);

                    idLigacao = (int)row["ID_LIG"];
                }

                IList<User> amigos = new List<User>();

                foreach (Ligacao lig in lista)
                {
                    amigos.Add(User.LoadByUserLigadoId(lig.IdUserLigado));
                }

                return amigos;
            }
            else
            {

                IList<User> amigos = new List<User>();
                return amigos;
            }
        }

        public static IList<User> LoadAllPedidosUser(string username)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE UserId ='"
                + LoadByUserName(username).UniqueIdentifierUserId + "' AND ELIMINADO ='" + 0 + "' AND ESTADO ='"
                + 0 + "'");

            IList<Ligacao> lista = new List<Ligacao>();

            Ligacao ligacao = null;
            int idLigacao = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {

                ligacao = new Ligacao(row);
                lista.Add(ligacao);

                idLigacao = (int)row["ID_LIG"];
            }

            IList<User> amigos = new List<User>();

            foreach (Ligacao lig in lista)
            {
                amigos.Add(User.LoadByUserLigadoId(lig.IdUserLigado));
            }

            return amigos;
        }



        public static IList<string> LoadProfileByUser(string username)
        {
            User user = User.LoadByUserName(username);

            IList<string> profile = new List<string>();

            if (user != null)
            {
                DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM [Profiles] WHERE UserId = '" + user.UniqueIdentifierUserId + "'");

                if (ds.Tables[0].Rows.Count > 0)
                {

                    IList<string> nomes = ((string)ds.Tables[0].Rows[0]["PropertyNames"]).Split(':');
                    string valores = ((string)ds.Tables[0].Rows[0]["PropertyValueStrings"]);

                    for (int i = 0; i < nomes.Count - 1; i = i + 3)
                    {

                        int inicio = Convert.ToInt32(nomes[i + 1]);
                        int fim = Convert.ToInt32(nomes[i + 2]);
                        profile.Add(nomes[i] + ":" + valores.Substring(inicio, fim));

                    }
                    return profile;
                }
            }
            return null;
        }


        // Save
        //
        //
        // O Membership vai criar os Users logo esta classe apenas vai gravar uma única vez
        //      na tabela UserLigado uma nova referência
        public override void Save()
        {

            BeginTransaction();


            SqlCommand sql = new SqlCommand();

           

            bool novaEntrada = true;

            // Verifica-se se existe uma entrada na tabela UserLigado do mesmo User
            //
            // Se for o caso o Save não é efectuado


            DataSet dataSetLigacao = ExecuteQuery(GetConnection(false),"SELECT * FROM UserLigado WHERE UserId = '" + UniqueIdentifierUserId + "'");

            if (dataSetLigacao.Tables[0].Rows.Count > 0)
            {
                novaEntrada = false;
            }

            if (novaEntrada)
            {

                sql.CommandText = "INSERT INTO UserLigado (UserId,ELIMINADO) VALUES (@UserId,@ELIMINADO)";

                sql.Transaction = CurrentTransaction;
                sql.Connection = sql.Transaction.Connection;

                IDataParameter param = sql.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier);
                param.Value = new Guid(UniqueIdentifierUserId);

                param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                param.Value = 0;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                CommitTransaction();

                if (rowsAfectadas > 0)
                {
                    Gravado = true;
                    dataSetLigacao = ExecuteQuery(GetConnection(false), "SELECT * FROM UserLigado WHERE UserId = '" + UniqueIdentifierUserId + "'");
                    IdUserLigado = (int) dataSetLigacao.Tables[0].Rows[0]["ID_ULIG"];
                }
                else
                {
                    Gravado = false;
                }
            }

            
        }


        // Delete
        //
        //
        // Se retirarmos um user temos que remover primeiro a UserLigado e depois das tabelas do Membership
        //
        // Para remover do Membership existe um método próprio, por isso não temos que eliminar aqui
        //      Membership.DeleteUser
        // 
        public bool Delete()
        {
            SqlCommand sql = new SqlCommand();

            if (IdUserLigado != -1)
            {
                BeginTransaction();

                sql.CommandText = "UPDATE FROM UserLigado SET ELIMINADO=@ELIMINADO WHERE ID_ULIG=@ID_ULIG";

                sql.Transaction = CurrentTransaction;

                IDataParameter param = sql.Parameters.Add("@ID_ULIG", SqlDbType.Int);
                param.Value = IdUserLigado;

                param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                param.Value = 1;

                Eliminado = true;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);



                // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                if (rowsAfectadas == 0)
                {

                    CommitTransaction();
                    return false;

                }

                // Para remover um User temos que remover as ligações do mesmo e em que ele está presente
                
                // Ligações em que ele é User dono
                IList<Ligacao> lista = Ligacao.LoadAllByUserId(UniqueIdentifierUserId);

                bool delete = false;

                foreach (Ligacao ligacao in lista)
                {
                    delete = ligacao.Delete();
                    if (!delete)
                        return false;
                }


                // Ligações em que ele é o UserLigado
                lista = Ligacao.LoadAllByUserLigadoId(IdUserLigado);


                delete = false;

                foreach (Ligacao ligacao in lista)
                {
                    delete = ligacao.Delete();
                    if (!delete)
                        return false;
                }

                return true;
            }

            return false;
        }


    }
}
