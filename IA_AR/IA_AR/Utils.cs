using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IA_AR
{
    public class Utils
    {

        protected int myID;

        public int ID
        {
            get
            {
                return myID;
            }
        }


        private const string _CONNSTR = "Data Source=gandalf.dei.isep.ipp.pt;Initial Catalog=ARQSI36;User ID=ARQSI36;Password=gaivota";

        private static string CONNSTR
        {
            get
            {
                return _CONNSTR;
            }
        }

        private static SqlTransaction myTx;
        private static SqlConnection myCnx;

        protected static SqlTransaction CurrentTransaction
        {
            get { return myTx; }
        }

        protected static SqlConnection GetConnection(bool open)
        {
            SqlConnection cnx = new SqlConnection(@CONNSTR);
            if (open)
                cnx.Open();
            return cnx;
        }

        protected static DataSet ExecuteQuery(SqlConnection cnx, string sql)
        {
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(sql, cnx);
                DataSet ds = new DataSet();
                da.Fill(ds);
                return ds;
            }
            catch (SqlException ex)
            {
                throw new ApplicationException("Erro BD", ex);
            }
        }

        protected static int ExecuteNonQuery(SqlConnection cnx, string sql)
        {
            SqlCommand cmd = new SqlCommand(sql, cnx);
            return cmd.ExecuteNonQuery();
        }

        protected static int ExecuteNonQuery(SqlTransaction tx, string sql)
        {
            SqlCommand cmd = new SqlCommand(sql, tx.Connection, tx);
            return cmd.ExecuteNonQuery();
        }

        protected static int ExecuteNonQuery(SqlTransaction tx, SqlCommand cmd)
        {
            cmd.Transaction = tx;
            return cmd.ExecuteNonQuery();
        }

        protected static DataSet ExecuteQuery(string sql)
        {
            try
            {
                if (myCnx == null)
                    myCnx = GetConnection(false);

                SqlDataAdapter da = new SqlDataAdapter(sql, myCnx);
                DataSet ds = new DataSet();
                da.Fill(ds);
                return ds;
            }
            catch (SqlException ex)
            {
                throw new ApplicationException("Erro BD", ex);
            }
        }

        protected static DataSet ExecuteTransactedQuery(string sql)
        {
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(sql, myCnx);
                DataSet ds = new DataSet();
                da.Fill(ds);
                return ds;
            }
            catch (SqlException ex)
            {
                throw new ApplicationException("Erro BD", ex);
            }
        }

        protected static int ExecuteNonQuery(string sql)
        {
            SqlConnection cnx = GetConnection(true);
            int r = ExecuteNonQuery(cnx, sql);
            cnx.Close();
            return r;
        }

        protected static int ExecuteTransactedNonQuery(string sql)
        {
            SqlCommand cmd = new SqlCommand(sql);
            return ExecuteTransactedNonQuery(cmd);
        }

        protected static int ExecuteTransactedNonQuery(SqlCommand cmd)
        {
            try
            {
                cmd.Transaction = CurrentTransaction;
                cmd.Connection = CurrentTransaction.Connection;
                return cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                throw ex;
            }
        }

        protected static void BeginTransaction()
        {
            try
            {
                //if (myTx == null)
                //  Retirado pois, após uma operação, não se conseguia criar uma connection
                myTx = GetConnection(true).BeginTransaction();
            }
            catch (SqlException ex)
            {

                throw new ApplicationException("Erro BD", ex);
            }
        }

        protected static void CommitTransaction()
        {
            if (myTx != null)
            {
                SqlConnection cnx = myTx.Connection;
                myTx.Commit();
                cnx.Close();
            }
        }

        protected static void RoolbackTransaction()
        {
            if (myTx != null)
            {
                SqlConnection cnx = myTx.Connection;
                myTx.Rollback();
                cnx.Close();
            }
        }

        public int insertTraducao(string orig, string final)
        {
            BeginTransaction();
            orig = orig.ToLower();
            final = final.ToLower();
            var sql = new SqlCommand
            {
                CommandText = "INSERT INTO IA_traduzir(orig,final) VALUES(@ORIG,@FINAL)",
                Transaction = CurrentTransaction
            };

            IDataParameter param = sql.Parameters.Add("@ORIG", SqlDbType.VarChar);
            param.Value = orig;

            param = sql.Parameters.Add("@FINAL", SqlDbType.VarChar);
            param.Value = final;

            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;

        }

        public int deleteTraducao(string orig)
        {
            BeginTransaction();
            orig = orig.ToLower();
            var sql = new SqlCommand();
            sql.CommandText = "DELETE FROM IA_traduzir WHERE orig=@ORIG";
            sql.Transaction = CurrentTransaction;

            IDataParameter param = sql.Parameters.Add("@ORIG", SqlDbType.VarChar);
            param.Value = orig;

            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;

        }

        public int insertLig(string orig, string destino, int forca)
        {
            if (forca < 0)
                return -1;
            orig = orig.ToLower();
            destino = destino.ToLower();
            BeginTransaction();
            var sql = new SqlCommand();
            sql.CommandText = "INSERT INTO IA_lig (orig,dest,forca) VALUES(@ORIG,@DEST,@FORCA)";
            sql.Transaction = CurrentTransaction;

            IDataParameter param = sql.Parameters.Add("@ORIG", SqlDbType.VarChar);
            param.Value = orig;

            param = sql.Parameters.Add("@DEST", SqlDbType.VarChar);
            param.Value = destino;

            param = sql.Parameters.Add("@FORCA", SqlDbType.Int);
            param.Value = forca;

            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;

        }

        public int deleteLig(string orig, string destino)
        {
            BeginTransaction();
            orig = orig.ToLower();
            destino = destino.ToLower();

            var sql = new SqlCommand
                          {
                              CommandText = "DELETE FROM IA_lig WHERE orig=@ORIG AND dest=@DEST",
                              Transaction = CurrentTransaction
                          };

            IDataParameter param = sql.Parameters.Add("@ORIG", SqlDbType.VarChar);
            param.Value = orig;

            param = sql.Parameters.Add("@DEST", SqlDbType.VarChar);
            param.Value = destino;
            
            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;
        }


        public int insertUser(string user)
        {
            BeginTransaction();
            user = user.ToLower();
            var sql = new SqlCommand
            {
                CommandText = "INSERT INTO IA_user(registo) VALUES(@USER)",
                Transaction = CurrentTransaction
            };

            IDataParameter param = sql.Parameters.Add("@USER", SqlDbType.VarChar);
            param.Value = user;

            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;

        }


        public int insertTag(string nome, string listaUser)
        {

            nome = nome.ToLower();
            listaUser = listaUser.ToLower();


            BeginTransaction();
            var sql = new SqlCommand();
            sql.CommandText = "INSERT INTO IA_tag (nome,listaUser) VALUES(@NOME,@LISTAUSER)";
            sql.Transaction = CurrentTransaction;

            IDataParameter param = sql.Parameters.Add("@NOME", SqlDbType.VarChar);
            param.Value = nome;

            param = sql.Parameters.Add("@LISTAUSER", SqlDbType.VarChar);
            param.Value = listaUser;

            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;

        }

        public int deleteTag(string nome)
        {
            BeginTransaction();
            nome = nome.ToLower();

            var sql = new SqlCommand
            {
                CommandText = "DELETE FROM IA_tag WHERE nome=@NOME",
                Transaction = CurrentTransaction
            };

            IDataParameter param = sql.Parameters.Add("@NOME", SqlDbType.VarChar);
            param.Value = nome;
            
            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;
        }

        /*public int insertIntoTag(string nome, string user)
        {

            nome = nome.ToLower();
            user = user.ToLower();

            DataSet dataSetLigacao = ExecuteQuery(GetConnection(false),"SELECT * FROM IA_tag WHERE nome = '" + nome+"'");


            //dataSetLigacao.

            var listaUser="";


            BeginTransaction();
            var sql = new SqlCommand();
            sql.CommandText = "INSERT INTO IA_tag (nome,listaUser) VALUES(@NOME,@LISTAUSER)";
            sql.Transaction = CurrentTransaction;

            IDataParameter param = sql.Parameters.Add("@NOME", SqlDbType.VarChar);
            param.Value = nome;

            param = sql.Parameters.Add("@LISTAUSER", SqlDbType.VarChar);
            param.Value = listaUser;

            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;

        }

        public int deleteFromTag(string nome)
        {
            BeginTransaction();
            nome = nome.ToLower();

            var sql = new SqlCommand
            {
                CommandText = "DELETE FROM IA_tag WHERE nome=@NOME",
                Transaction = CurrentTransaction
            };

            IDataParameter param = sql.Parameters.Add("@NOME", SqlDbType.VarChar);
            param.Value = nome;

            int rowsAfectadas = ExecuteTransactedNonQuery(sql);

            CommitTransaction();

            return rowsAfectadas;
        }*/


    }
}