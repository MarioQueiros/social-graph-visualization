using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Graphs4Social_AR
{
    public class Tag : ActiveRecord
    {

        // Classe Tag correspondente as tabelas Tag e TagRelacao
        //
        // Tabela Tag - Tags dos Users
        // Tabela TagRelacao - Tags das relações dos Users

        // Campo que os distingue em código - isRelacao - Por definição é uma Tag de Users logo começa a false
        private bool _relacao = false;

        // Nome da Tag
        private string _nome;

        // Campo Estado - Estado actual da Tag na aplicação e base de dados
        //      Inteiro
        //
        //      -1 - Removido
        //       0 - A validar
        //       1 - Validado e aceite no site
        private int _estado = 0;

        // Campo Gravado e Campo Eliminado
        private bool _gravado = false;
        private bool _eliminado = false;

        // Construtor vazio não pode existir, temos sempre que referir o tipo de tag que queremos
        //      True - TagRelacao
        //      False - Tag
        public Tag(bool relacao)
        {
            _relacao = relacao;
        }

        public Tag(DataRow row, bool rel)
        {
            Relacao = rel;

            if (Relacao)
            {
                myID = (int)row["ID_REL"];
            }
            else
            {
                myID = (int)row["ID_TAG"];
            }

            this._eliminado = ((int)row["ELIMINADO"] == 1) ? true : false;

        }


        // Gets e Sets
        //
        //
        //
        public bool Relacao
        {
            get { return _relacao; }
            set { _relacao = value; }
        }

        public string Nome
        {
            get { return _nome; }
            set { _nome = value; }
        }

        public int Estado
        {
            get { return _estado; }
            set { _estado = value; }
        }

        public bool Gravado
        {
            get { return _gravado; }
            set { _gravado = value; }
        }

        public bool Eliminado
        {
            get { return _eliminado; }
            set { _eliminado = value; }
        }


        // To String
        //
        //
        //
        public override string ToString()
        {
            return Relacao + " " + Nome + " "
                + Estado + " " + Gravado + " " + Eliminado;
        }


        // Métodos
        //
        //
        // Adicionar uma Tag na Bd, havendo a possibilidade de retornar null
        public static Tag AdicionarTag(string nome)
        {
            Tag tag = Tag.LoadTagByNome(nome);
            if (tag == null)
            {
                tag.Nome = nome;
                tag.Save();

                return tag;
            }

            return tag;
        }
        //
        //
        // Mudar o estado da Tag
        public bool MudarEstadoTag(int estado)
        {
            if (estado > -2 && estado < 2)
            {

                Estado = estado;
                Save();

                return Gravado;
            }

            return false;
        }






        // Loads
        //
        //
        //
        // Load das Tags do User
        public static Tag LoadTagById(int idTag)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag WHERE ID_TAG='" + idTag + "' AND ELIMINADO ='" + 0 + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
            {
                return new Tag(ds.Tables[0].Rows[0], false);
            }
        }
        //
        // 
        public static Tag LoadTagByNome(string nome)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag WHERE NOME='" + nome + "' AND ELIMINADO ='" + 0 + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
                return new Tag(ds.Tables[0].Rows[0], false);
        }
        //
        //
        public static Tag LoadTagByEstado(int estado)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag WHERE ESTADO='" + estado + "' AND ELIMINADO ='" + 0 + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
                return new Tag(ds.Tables[0].Rows[0], false);
        }
        //
        //
        public static IList<Tag> LoadAllTag()
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag WHERE ELIMINADO ='"+0+"'");

            IList<Tag> lista = new List<Tag>();

            Tag tag = null;
            int idTag = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["ID_TAG"] != idTag)
                {
                    tag = new Tag(row,false);
                    lista.Add(tag);

                    idTag = (int)row["ID_TAG"];
                }
            }

            return lista;
        }


        // Load das Tags das Ligações
        public static Tag LoadTagRelacaoById(int idTagRelacao)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE ID_REL='" + idTagRelacao + "' AND ELIMINADO ='"+0+"'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
            {
                return new Tag(ds.Tables[0].Rows[0], true);
            }
        }
        //
        // 
        public static Tag LoadTagRelacaoByNome(string nome)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE NOME='" + nome + "' AND ELIMINADO ='" + 0 + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
                return new Tag(ds.Tables[0].Rows[0], true);
        }
        //
        //
        public static Tag LoadTagRelacaoByEstado(int estado)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE ESTADO='" + estado + "' AND ELIMINADO ='" + 0 + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
                return new Tag(ds.Tables[0].Rows[0], true);
        }
        //
        //
        public static IList<Tag> LoadAllTagRelacao()
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE ELIMINADO ='"+0+"'");

            IList<Tag> lista = new List<Tag>();

            Tag tag = null;
            int idTag = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["ID_REL"] != idTag)
                {
                    tag = new Tag(row, true);
                    lista.Add(tag);

                    idTag = (int)row["ID_REL"];
                }
            }

            return lista;
        }

        // Load by User através do NickName
        public static IList<Tag> LoadAllByUsername(string username)
        {


            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag/User WHERE UserId = '"
                + User.LoadByUserName(username).UniqueIdentifierUserId + "' AND ELIMINADO ='" + 0 + "'");

            IList<Tag> lista = new List<Tag>();

            Tag tag = null;
            int idTag = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["ID_TAG"] != idTag)
                {
                    tag = new Tag(row, false);
                    lista.Add(tag);

                    idTag = (int)row["ID_TAG"];
                }
            }

            return lista;

        }





        // Save
        //
        //
        //
        public override void Save()
        {
            SqlCommand sql = new SqlCommand();

            bool novaEntrada = true;

            BeginTransaction();

            if (Relacao)
            {


                // Verifica-se se existe uma TagRelacao com o mesmo nome
                //
                // Se for o caso o Save é um update, mais provavel do Estado da Tag


                DataSet dataSetLigacao = ExecuteTransactedQuery("SELECT * FROM TagRelacao WHERE "
                    + "NOME = '" + Nome + "'");


                if (dataSetLigacao.Tables[0].Rows.Count > 0)
                {

                    novaEntrada = false;

                }

                if (novaEntrada)
                {

                    sql.CommandText = "INSERT INTO TagRelacao(NOME,ESTADO,ELIMINADO) "
                        + "VALUES(@NOME,@ESTADO,@ELIMINADO)";
                    sql.Transaction = CurrentTransaction;

                    IDataParameter param = sql.Parameters.Add("@NOME", SqlDbType.Int);
                    param.Value = Nome;

                    param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                    param.Value = Estado;

                    param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                    param.Value = Eliminado ? 1 : 0;

                    int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                    // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                    if (rowsAfectadas > 0)
                    {
                        Gravado = true;

                        // Vai buscar a tabela o Id atribuido por increment a Nova Entrada
                        myID = (int)ExecuteTransactedQuery("SELECT * FROM TagRelacao WHERE "
                                                            + "NOME = '" + Nome + "'")
                                                            .Tables[0].Rows[0]["ID_REL"];
                    }
                    else
                    {
                        Gravado = false;
                    }
                }
                else
                {
                    sql.CommandText = "UPDATE FROM TagRelacao SET ESTADO=@ESTADO AND ELIMINADO=@ELIMINADO WHERE ID_REL=@ID_REL";

                    sql.Transaction = CurrentTransaction;

                    IDataParameter param = sql.Parameters.Add("@ID_REL", SqlDbType.Int);
                    param.Value = myID;

                    param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                    param.Value = Estado;

                    param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                    param.Value = Eliminado ? 1 : 0;

                    int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                    // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                    if (rowsAfectadas > 0)
                    {
                        Gravado = true;
                    }
                    else
                    {
                        Gravado = false;
                    }
                }




            }
            else
            {
                // Verifica-se se existe uma Tag com o mesmo nome
                //
                // Se for o caso o Save é um update, mais provavel do Estado da Tag


                DataSet dataSetLigacao = ExecuteTransactedQuery("SELECT * FROM Tag WHERE "
                    + "NOME = '" + Nome + "'");


                if (dataSetLigacao.Tables[0].Rows.Count > 0)
                {

                    novaEntrada = false;

                }

                if (novaEntrada)
                {

                    sql.CommandText = "INSERT INTO Tag(NOME,ESTADO,ELIMINADO) "
                        + "VALUES(@NOME,@ESTADO,@ELIMINADO)";
                    sql.Transaction = CurrentTransaction;

                    IDataParameter param = sql.Parameters.Add("@NOME", SqlDbType.VarChar);
                    param.Value = NOME;

                    param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                    param.Value = Estado;

                    param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                    param.Value = Eliminado ? 1 : 0;

                    int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                    // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                    if (rowsAfectadas > 0)
                    {
                        Gravado = true;

                        // Vai buscar a tabela o Id atribuido por increment a Nova Entrada
                        myID = (int)ExecuteTransactedQuery("SELECT * FROM Tag WHERE "
                                                            + "NOME = '" + Nome + "'")
                                                            .Tables[0].Rows[0]["ID_TAG"];
                    }
                    else
                    {
                        Gravado = false;
                    }
                }
                else
                {
                    sql.CommandText = "UPDATE FROM Tag SET ESTADO=@ESTADO AND ELIMINADO=@ELIMINADO WHERE ID_TAG=@ID_TAG";

                    sql.Transaction = CurrentTransaction;

                    IDataParameter param = sql.Parameters.Add("@ID_TAG", SqlDbType.Int);
                    param.Value = myID;

                    param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                    param.Value = Estado;

                    param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                    param.Value = Eliminado ? 1 : 0;

                    int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                    // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                    if (rowsAfectadas > 0)
                    {
                        Gravado = true;
                    }
                    else
                    {
                        Gravado = false;
                    }
                }

            }

            CommitTransaction();
        }



        // Delete
        //
        //
        //
        public bool Delete()
        {


        }

    }
}
