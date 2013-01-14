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

        // Campo Tipo
        //
        //      1 - Mulher
        //      2 - Homem
        private int _tipo;

        // Campo Quantidade
        //
        //  Utilizado apenas para as tags comuns
        //  
        //  Utilizado para identificar a força das tags na rede social
        //  Começa a 0 caso a Tag for nova
        private int _quantidade=0;

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
                this._tipo = (int)row["TIPO"];
            }
            else
            {
                myID = (int)row["ID_TAG"];
                this._quantidade = (int)row["QUANTIDADE"];
            }

            this._eliminado = ((int)row["ELIMINADO"] == 1) ? true : false;
            this._nome = (string)row["NOME"];
            this._estado = (int)row["ESTADO"];
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

        public int Tipo
        {
            get { return _tipo; }
            set { _tipo = value; }
        }
        public int Quantidade
        {
            get { return _quantidade; }
            set { _quantidade = value; }
        }


        // To String
        //
        //
        //
        public override string ToString()
        {
            return Relacao + " " + Nome + " "
                + Estado + " " + Gravado + " " + Eliminado + " " + Tipo;
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
                tag = new Tag(false);
                tag.Nome = nome;
                tag.Save();

                return tag;
            }

            return tag;
        }
        //
        //
        // Mudar o estado da Tag
        public bool MudarEstadoTagInt(int estado)
        {
            if (estado > -2 && estado < 2)
            {

                Estado = estado;
                Save();

                return Gravado;
            }

            return false;
        }
        //
        //
        // Acrescentar ou retirar uma ocorrência a uma Tag
        public void Ocorrencia(int val)
        {
            Quantidade = Quantidade + (val);
            if (Quantidade >= 0)
                Save();
            else
                Quantidade = 0;
        }
        //
        //
        // 
        public static void RefreshTagsUser(IList<string> tagsAnteriores, IList<string> tagsActuais, string username)
        {
            IList<int> idAdd = new List<int>();
            IList<int> idRem = new List<int>();
                        
            if(tagsActuais.Count==1 && tagsActuais[0].Equals(""))
            {

                tagsActuais.Remove(tagsActuais[0]);
            
            }

            IList<string> list = new List<string>(tagsActuais);

            foreach(string tagN in list)
            {
                Tag tag = Tag.LoadTagByNome(tagN);
                if (tagsAnteriores.Contains(tagN))
                {
                    tagsAnteriores.Remove(tagN);
                    tagsActuais.Remove(tagN);
                }
                else
                {
                    tag.Ocorrencia(1);
                    idAdd.Add(tag.ID);
                }
            }
            
            foreach (string tagR in tagsAnteriores)
            {

                Tag tag = Tag.LoadTagByNome(tagR);
                tag.Ocorrencia(-1);
                idRem.Add(tag.ID);

            }
            
            string userId = User.LoadByUserName(username).UniqueIdentifierUserId;

            AdicionarTagsUser(userId, idAdd);
            RemoverTagsUser(userId, idRem);
        }


        // Modificações Tabela N para N
        //
        //
        //
        public static void AdicionarTagsUser(string userId, IList<int> idsTags)
        {
            BeginTransaction();

            foreach (int id in idsTags)
            {

                SqlCommand sql = new SqlCommand();
                sql.CommandText = "INSERT INTO [Tag/User](UserId,ID_TAG) VALUES(@UserID,@ID_TAG)";
                sql.Transaction = CurrentTransaction;

                IDataParameter param = sql.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier);
                param.Value = new Guid(userId);

                param = sql.Parameters.Add("@ID_TAG", SqlDbType.Int);
                param.Value = id;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);


            }

            CommitTransaction();
        }
        //
        //
        public static void RemoverTagsUser(string userId, IList<int> idsTags)
        {
            BeginTransaction();

            foreach (int id in idsTags)
            {

                SqlCommand sql = new SqlCommand();
                sql.CommandText = "DELETE FROM [Tag/User] WHERE UserId=@UserID AND ID_TAG=@ID_TAG";
                sql.Transaction = CurrentTransaction;

                IDataParameter param = sql.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier);
                param.Value = new Guid(userId);

                param = sql.Parameters.Add("@ID_TAG", SqlDbType.Int);
                param.Value = id;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);


            }

            CommitTransaction();
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
        public static IList<Tag> LoadTagsByEstado(int estado)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag WHERE ESTADO='" + estado + "' AND ELIMINADO ='" + 0 + "'");
            IList<Tag> tags = new List<Tag>();
            foreach(DataRow row in ds.Tables[0].Rows)
            {
                tags.Add(new Tag(row, false));
            }

            return tags;
        }
        //
        //
        public static IList<Tag> LoadAllTag()
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag WHERE ELIMINADO ='"+0+"' AND ESTADO='"+1+"'");

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


            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM [Tag/User] WHERE UserId = '"
                + User.LoadByUserName(username).UniqueIdentifierUserId + "'");

            IList<Tag> lista = new List<Tag>();

            Tag tag = null;
            int idTag = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["ID_TAG"] != idTag)
                {

                    tag = Tag.LoadTagById((int)row["ID_TAG"]);
                    if(!tag.Eliminado)
                        lista.Add(tag);

                    idTag = (int)row["ID_TAG"];
                }
            }

            return lista;

        }


        public static IList<Tag> LoadAllMenTagRelacao()
        {

            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE TIPO = '2'");

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


        public static IList<Tag> LoadAllWomenTagRelacao()
        {

            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE TIPO = '1'");

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


                DataSet dataSetLigacao = ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE "
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
                    CommitTransaction();
                    // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                    if (rowsAfectadas > 0)
                    {
                        Gravado = true;

                        // Vai buscar a tabela o Id atribuido por increment a Nova Entrada
                        myID = (int)ExecuteQuery(GetConnection(false), "SELECT * FROM TagRelacao WHERE "
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
                    sql.CommandText = "UPDATE TagRelacao SET ESTADO=@ESTADO, ELIMINADO=@ELIMINADO WHERE ID_REL=@ID_REL";

                    sql.Transaction = CurrentTransaction;

                    IDataParameter param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                    param.Value = Estado;

                    param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                    param.Value = Eliminado ? 1 : 0;

                    param = sql.Parameters.Add("@ID_REL", SqlDbType.Int);
                    param.Value = myID;
                    
                    int rowsAfectadas = ExecuteTransactedNonQuery(sql);
                    CommitTransaction();
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


                DataSet dataSetLigacao = ExecuteQuery(GetConnection(false), "SELECT * FROM Tag WHERE "
                    + "NOME = '" + Nome + "'");


                if (dataSetLigacao.Tables[0].Rows.Count > 0)
                {

                    novaEntrada = false;

                }

                if (novaEntrada)
                {

                    sql.CommandText = "INSERT INTO Tag(NOME,ESTADO,ELIMINADO,QUANTIDADE) "
                        + "VALUES(@NOME,@ESTADO,@ELIMINADO,@QUANTIDADE)";
                    sql.Transaction = CurrentTransaction;

                    IDataParameter param = sql.Parameters.Add("@NOME", SqlDbType.VarChar);
                    param.Value = Nome;

                    param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                    param.Value = Estado;

                    param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                    param.Value = Eliminado ? 1 : 0;

                    param = sql.Parameters.Add("@QUANTIDADE", SqlDbType.Int);
                    param.Value = Quantidade;

                    int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                    CommitTransaction();

                    // Através do rowsAfectadas conseguiremos saber se foi gravado ou não
                    
                    if (rowsAfectadas > 0)
                    {
                        Gravado = true;

                        // Vai buscar a tabela o Id atribuido por increment a Nova Entrada
                        myID = (int)ExecuteQuery(GetConnection(false),"SELECT * FROM Tag WHERE "
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
                    sql.CommandText = "UPDATE Tag SET ESTADO=@ESTADO, QUANTIDADE=@QUANT, ELIMINADO=@ELIMINADO WHERE ID_TAG=@ID_TAG";

                    sql.Transaction = CurrentTransaction;

                    IDataParameter param = sql.Parameters.Add("@QUANT", SqlDbType.Int);
                    param.Value = Quantidade;

                    param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                    param.Value = Estado;

                    param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                    param.Value = Eliminado ? 1 : 0;

                    param = sql.Parameters.Add("@ID_TAG", SqlDbType.Int);
                    param.Value = myID;
                    
                    int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                    CommitTransaction();

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
        }



        // Delete
        //
        //
        //
        public bool Delete()
        {

            SqlCommand sql = new SqlCommand();

            if (Relacao)
            {
                BeginTransaction();

                sql.CommandText = "UPDATE TagRelacao SET ELIMINADO=@ELIMINADO WHERE ID_REL=@ID_REL";

                sql.Transaction = CurrentTransaction;

                IDataParameter param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                param.Value = 1;

                param = sql.Parameters.Add("@ID_REL", SqlDbType.Int);
                param.Value = ID;

                Eliminado = true;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                CommitTransaction();

                // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                if (rowsAfectadas == 0)
                {

                    return false;

                }

            }
            else
            {

                BeginTransaction();

                sql.CommandText = "UPDATE Tag SET ELIMINADO=@ELIMINADO WHERE ID_TAG=@ID_TAG";

                sql.Transaction = CurrentTransaction;

                IDataParameter param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                param.Value = 1;

                param = sql.Parameters.Add("@ID_TAG", SqlDbType.Int);
                param.Value = ID;

                Eliminado = true;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                CommitTransaction();

                // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                if (rowsAfectadas == 0)
                {

                    return false;

                }

            }

            return true;
        }

    }
}
