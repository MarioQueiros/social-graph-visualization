using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Graphs4Social_AR
{
    public class Ligacao : ActiveRecord
    {
        // Classe Ligação da Base de Dados
        //      Identifica a Ligação entre dois Users
        //      
        //      Tem dois identificadores dos Users:
        //      -> Um do "dono" da ligação
        //      -> Outro do User que o "dono" liga
        //
        //      Tem um campo atribuido aquando a criação da relação
        //      Os campos de uma relação entre dois Users podem ter valores diferentes, depende da perspectiva
        //      Valores -> De 1 a 5
        //
        //      Pode também ter uma tag da relação:
        //      -> Identifica a relação com um nome/tag

        // Unique Identifier do User "dono"
        private string _uniqueIdentifierUserId;

        // Id da tabela de User Ligado do User a ser ligado
        private int _idUserLigado;
        private int _forcaDeLigacao;
        private int _idTagRelacao;

        // Estado da Ligação
        // Inteiro
        //
        //      -1 - Rejeitado
        //       0 - Pedido de Amizade
        //       1 - Amigo
        //
        private int _estado = 0;

        private User _userDono;
        private User _userLigado;

        private Tag _tagRelacao;

        // Campo para verificar se foi gravado com sucesso ( iniciado a false ) e se foi removido
        private bool _gravado = false;
        private bool _eliminado = false;
        

        public Ligacao()
        {
            // Para garantir consistência de informação e impendir um falso pedido de DELETE
            myID = -1;
        }

        // Construtor a ser usado para criar uma ligação no Website
        // O website deverá conhecer o Unique Identifier do "dono" da ligação
        //
        // Deverá conhecer o id da tabela intermédia User Ligado ( tabela para garantir a possibilidade de 
        //      relacionar duas chaves primárias de Users
        //
        // Deverá também saber a forca de ligação e possivel Tag de Relação escolhido( -1 no último se não existir )
        public Ligacao(string uniqueIdentifierId, int idUserLigado, int forcaDeLigacao, int idTagRelacao)
        {
            // myId ainda não é aqui atribuido, porque este construtor não garante que haja
            //      o conhecimento do estado da tabela afectada ( Ligacao )
            //      Mesmo assim é posto a -1 para garantir consistência de informação e impendir um falso pedido de DELETE

            myID = -1;

            this._uniqueIdentifierUserId = uniqueIdentifierId;
            this._idUserLigado = idUserLigado;
            this._forcaDeLigacao = forcaDeLigacao;

            // Enviado a -1 se não existir
            this._idTagRelacao = idTagRelacao;
        }


        // Construtor usado para as chamadas do "Load" da Classe
        public Ligacao(DataRow row)
        {

            this.myID = (int)row["ID_LIG"];
            this._uniqueIdentifierUserId = Convert.ToString(row["UserId"]);
            this._idUserLigado = (int)row["ID_ULIG"];
            this._forcaDeLigacao = (int)row["FORCALIGACAO"];

            string rel = Convert.ToString(row["ID_REL"]);

            if (!rel.Equals(""))
            {

                this._idTagRelacao = (int)row["ID_REL"];

            }
            else
            {

                this._idTagRelacao = -1;

            }

            this._eliminado = ((int)row["ELIMINADO"] == 1) ? true : false;
            this._estado = (int)row["ESTADO"];
            
        }



        // Gets e Sets
        //
        //
        // Lazy Load para os Objectos de User e Tag
        public User UserDono
        {
            get {
                //Lazy Load
                if (this._userDono == null)
                {

                    this._userDono = User.LoadByUniqueIdentifier(this.UniqueIdentifierUserId);

                }
                return _userDono; 
            }
        }

        public User UserLigado
        {
            get
            {
                //Lazy Load
                if (this._userLigado == null)
                    this._userLigado = User.LoadByUserLigadoId(this.IdUserLigado);
                return this._userLigado;

            }
        }

        public Tag TagRelacao
        {
            get
            {
                //Lazy Load
                if (this._tagRelacao == null)
                    this._tagRelacao = Tag.LoadTagRelacaoById(this.IdTagRelacao);
                return this._tagRelacao;

            }
        }



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

        public int ForcaDeLigacao
        {
            get { return _forcaDeLigacao; }
            set { this._forcaDeLigacao = value; }
        }

        public int IdTagRelacao
        {
            get { return _idTagRelacao; }
            set { this._idTagRelacao = value; }
        }

        public int Estado
        {
            get { return _estado; }
            set { this._estado = value; }
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



        // To String
        //
        //
        //

        public override string ToString()
        {
            return UniqueIdentifierUserId + " " + IdUserLigado + " " + ForcaDeLigacao + " "
                + IdTagRelacao + " " + Estado +" "+ Gravado + " " + Eliminado;
        }



        // Metodos
        //
        //
        // Adicionar ligação através de dois Usernames e um nome de Tag
        public static Ligacao AddLigacao(string username1, string username2, string tagS, int forca){

            Ligacao ligacao = Ligacao.LoadByUserNames(username1,username2);
            Tag tag = Tag.LoadTagRelacaoByNome(tagS);
            
            if(ligacao == null){

                if(tag != null)
                    ligacao = new Ligacao(User.LoadByUserName(username1).UniqueIdentifierUserId,
                        User.LoadByUserName(username2).IdUserLigado, 
                        forca,
                        tag.ID);
                else
                {
                    ligacao = new Ligacao(User.LoadByUserName(username1).UniqueIdentifierUserId,
                        User.LoadByUserName(username2).IdUserLigado, 
                        forca,
                        -1);
                }
                    
            }
            else{
                if(tag == null){
                    ligacao.IdTagRelacao = -1;
                }
                else{
                    ligacao.IdTagRelacao = tag.ID;
                }
                ligacao.ForcaDeLigacao = forca;
                
            }
            return ligacao;
        }
        //
        //
        // Pedidos de amizade ( Ligações estado = 0 ) por username
        //
        public static bool PedidoAmizade(string username1, string username2, int forca){
            Ligacao ligacao = AddLigacao(username1, username2, "",forca);

            if (ligacao != null)
            {

                ligacao.Estado = 0;
                ligacao.Save();

                ligacao = AddLigacao(username2, username1, "",-1);

                if (ligacao != null)
                {
                    ligacao.Estado = 0;
                    ligacao.Save();
                    return true;
                }
                return false;
            }

            return false;
        }
        //
        // Aceitar um pedido de amizade
        //
        public static bool AceitarPedido(string username1, string username2, int forca)
        {
            Ligacao ligacao = AddLigacao(username1, username2, "", forca);

            if (ligacao != null)
            {
                ligacao.Estado = 1;
                ligacao.Save();

                ligacao = Ligacao.LoadByUserNames(username2, username1);
                if (ligacao != null)
                {

                    ligacao.Estado = 1;
                    ligacao.Save();
                    return true;
                }
                return false;
            }
            return false;
        }
        //
        // Rejeitar um pedido de amizade
        //
        public static bool RejeitarPedido(string username1, string username2)
        {
            Ligacao ligacao = AddLigacao(username1, username2, "", -1);

            if (ligacao != null)
            {
                ligacao.Estado = -1;
                ligacao.Save();

                ligacao = Ligacao.LoadByUserNames(username2, username1);
                if (ligacao != null)
                {

                    ligacao.Estado = -1;
                    ligacao.Save();
                    return true;
                }
                return false;
            }
            return false;
        }
        //
        // Mudar Tag de uma Relação
        //
        public static bool MudarTagRelacao(string username1, string username2, string tagS)
        {

            Ligacao ligacao = Ligacao.LoadByUserNames(username1, username2);

            if (ligacao != null)
            {

                Tag tag = Tag.LoadTagByNome(tagS);

                if (tag != null)
                {

                    ligacao.IdTagRelacao = tag.ID;

                    return true;

                }


            }

            return false;
        }

        //
        // Mudar Forca de uma Relação
        //
        public static bool MudarTagRelacao(string username1, string username2, int forca)
        {

            Ligacao ligacao = Ligacao.LoadByUserNames(username1, username2);

            if (ligacao != null && forca < 6 && forca > 0)
            {

                ligacao.ForcaDeLigacao = forca;

                return true;
                
            }

            return false;
        }
        

        
        // Loads 
        //
        //
        //

        // Load pelo Id da Ligacao
        //
        // Retorna uma Ligacao, se encontrar, ou null, se não encontrar

        public static Ligacao LoadById(int idLigacao)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE ID_LIG='" + idLigacao  + "' AND ELIMINADO ='" + 0 + "'");
            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
            {
                    return new Ligacao(ds.Tables[0].Rows[0]);
            }
        }

        // Load By Usernames
        //
        // Retorna uma ligação entre dois Users, 
        //      username1 - username do User Dono da Ligacao
        //      username2 - username do User Ligado da ligacao

        public static Ligacao LoadByUserNames(string username1, string username2)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE UserId='" 
                + User.LoadByUserName(username1).UniqueIdentifierUserId  
                + "' AND ID_ULIG='" 
                + User.LoadByUserName(username2).IdUserLigado
                + "' AND ELIMINADO ='" + 0 + "'");

            if (ds.Tables[0].Rows.Count < 1)
                return null;
            else
            {
                    return new Ligacao(ds.Tables[0].Rows[0]);
            }
        }


        // Load de todas as entradas na Tabela Ligacao
        //
        // Retorna uma IList com elementos ou vazia, se não existir nenhuma Ligacao

        public static IList<Ligacao> LoadAll()
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao ELIMINADO ='" + 0 + "'");

            IList<Ligacao> lista = new List<Ligacao>();

            Ligacao ligacao = null;
            int idLigacao = -1;

            foreach (DataRow row in ds.Tables[0].Rows )
            {
                if ((int)row["ID_LIG"] != idLigacao)
                {
                    ligacao = new Ligacao(row);
                    lista.Add(ligacao);

                    idLigacao = (int)row["ID_LIG"];
                }
            }

            return lista;
        }


        // Load de ligações de um User dono por Username

        public static IList<Ligacao> LoadAllByUserName(string username)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE UserId ='"
                +User.LoadByUserName(username).UniqueIdentifierUserId + "' AND ELIMINADO ='" + 0 + "'");

            IList<Ligacao> lista = new List<Ligacao>();

            Ligacao ligacao = null;
            int idLigacao = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["ID_LIG"] != idLigacao)
                {
                    ligacao = new Ligacao(row);
                    lista.Add(ligacao);

                    idLigacao = (int)row["ID_LIG"];
                }
            }

            return lista;
        }

        // Load de ligações de um User dono por Unique Identifier UserId
        //
        public static IList<Ligacao> LoadAllByUserId(string userId)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE UserId ='"
                + userId + "' AND ELIMINADO ='" + 0 + "'");

            IList<Ligacao> lista = new List<Ligacao>();

            Ligacao ligacao = null;
            int idLigacao = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["ID_LIG"] != idLigacao)
                {
                    ligacao = new Ligacao(row);
                    lista.Add(ligacao);

                    idLigacao = (int)row["ID_LIG"];
                }
            }

            return lista;
        }
        //
        //
        // Load de ligações de um User Ligado por IdUserLigado
        public static IList<Ligacao> LoadAllByUserLigadoId(int IdUserLigado)
        {
            DataSet ds = ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE ID_ULIG ='"
                + IdUserLigado + "' AND ELIMINADO ='" + 0 + "'");

            IList<Ligacao> lista = new List<Ligacao>();

            Ligacao ligacao = null;
            int idLigacao = -1;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["ID_LIG"] != idLigacao)
                {
                    ligacao = new Ligacao(row);
                    lista.Add(ligacao);

                    idLigacao = (int)row["ID_LIG"];
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

            BeginTransaction();

            bool novaEntrada = true;


            // Verifica-se se existe uma ligacao com os mesmos users
            //
            // Se for o caso o Save é um update, mais provavel do Tag de Relação e/ou Força da mesma


            DataSet dataSetLigacao = ExecuteQuery(GetConnection(false),"SELECT * FROM Ligacao WHERE"
                + " UserId = '" + UniqueIdentifierUserId
                + "' AND ID_ULIG = '" + IdUserLigado+"'");


            if (dataSetLigacao.Tables[0].Rows.Count > 0)
            {

                novaEntrada = false;

            }

            if (novaEntrada)
            {

                IDataParameter param;

                if (IdTagRelacao <= 0)
                {
                    sql.CommandText = "INSERT INTO Ligacao(UserId, ID_ULIG, FORCALIGACAO,ELIMINADO,ESTADO) "
                        + "VALUES(@UserId, @ID_ULIG,@FORCA,@ELIMINADO,@ESTADO)";

                }
                else
                {
                    sql.CommandText = "INSERT INTO Ligacao(UserId, ID_ULIG, ID_REL,FORCALIGACAO,ELIMINADO,ESTADO) "
                        + "VALUES(@UserId, @ID_ULIG, @ID_REL,@FORCA,@ELIMINADO,@ESTADO)";
                    
                    param = sql.Parameters.Add("@ID_REL", SqlDbType.Int);
                    param.Value = IdTagRelacao;

                }
                sql.Transaction = CurrentTransaction;

                param = sql.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier);
                param.Value = new Guid(UniqueIdentifierUserId);

                param = sql.Parameters.Add("@ID_ULIG", SqlDbType.Int);
                param.Value = IdUserLigado;

                

                param = sql.Parameters.Add("@FORCA", SqlDbType.Int);
                param.Value = ForcaDeLigacao;

                param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                param.Value = Eliminado ? 1 : 0;

                param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                param.Value = Estado;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                CommitTransaction();

                if (rowsAfectadas > 0)
                {
                    Gravado = true;
                    // Vai buscar a tabela o Id atribuido por increment a Nova Entrada
                    myID = Convert.ToInt32(ExecuteQuery(GetConnection(false), "SELECT * FROM Ligacao WHERE UserId = '" 
                        + UniqueIdentifierUserId
                        + "' AND ID_ULIG = '" + IdUserLigado + "'")
                        .Tables[0].Rows[0]["ID_LIG"]);
                }
                else
                {
                    Gravado = false;
                }

            }
            else
            {

                IDataParameter param;

                if (IdTagRelacao <= 0)
                {
                    sql.CommandText = "UPDATE Ligacao SET FORCALIGACAO=@FORCA, ELIMINADO=@ELIMINADO, ESTADO=@ESTADO WHERE ID_LIG=@ID_LIG";
                }
                else
                {
                    sql.CommandText = "UPDATE Ligacao SET ID_REL=@ID_REL, FORCALIGACAO=@FORCA, ELIMINADO=@ELIMINADO, ESTADO=@ESTADO WHERE ID_LIG=@ID_LIG";
                    param = sql.Parameters.Add("@ID_REL", SqlDbType.Int);
                    param.Value = IdTagRelacao;
                }
                sql.Transaction = CurrentTransaction;

                

                param = sql.Parameters.Add("@FORCA", SqlDbType.Int);
                param.Value = ForcaDeLigacao;

                param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                param.Value = Eliminado ? 1 : 0;

                param = sql.Parameters.Add("@ESTADO", SqlDbType.Int);
                param.Value = Estado;

                param = sql.Parameters.Add("@ID_LIG", SqlDbType.Int);
                param.Value = myID;

                int rowsAfectadas = ExecuteTransactedNonQuery(sql);

                // Através do rowsAfectadas conseguiremos saber se foi gravado ou não

                CommitTransaction();

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

        

        // Remoção
        //
        //
        // A remoção de ligações afecta só a tabela Ligacao
        //
        // As restantes tabelas ficam intactas pois a chave primária da Ligacao é apenas usada na mesma

        public bool Delete()
        {

            SqlCommand sql = new SqlCommand();

            if (myID != -1)
            {

                BeginTransaction();

                sql.CommandText = "UPDATE UserLigado SET ELIMINADO=@ELIMINADO WHERE ID_LIG=@ID_LIG";

                sql.Transaction = CurrentTransaction;

                IDataParameter param = sql.Parameters.Add("@ID_LIG", SqlDbType.Int);
                param.Value = myID;

                param = sql.Parameters.Add("@ELIMINADO", SqlDbType.Int);
                param.Value = 1;

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
                return false;
            }

            return true;
        }





        
    }
}
