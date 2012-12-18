﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Graphs4Social_AR
{
    /// <summary>
    /// Summary description for BaseGateway.
    /// </summary>
    public abstract class ActiveRecord
    {
        public ActiveRecord()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public abstract void Save();

        protected int myID;

        public int ID
        {
            get
            {
                return myID;
            }
        }


        private const string _CONNSTR = "workstation id=Graphs4Social.mssql.somee.com;packet size=4096;user id=MpApQ_SQLLogin_1;pwd=e1i75j78ls;data source=Graphs4Social.mssql.somee.com;persist security info=False;initial catalog=Graphs4Social";

        private static string CONNSTR
        {
            get
            {
                //return System.Configuration.ConfigurationSettings.AppSettings["ConnStr"];
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
                da.SelectCommand.Connection = myCnx;
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
    }
}
