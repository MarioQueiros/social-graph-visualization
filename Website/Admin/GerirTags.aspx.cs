using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Resources;

public partial class Admin_GerirTags : System.Web.UI.Page
{
    private static string baseName = "Resources.Graphs4Social";
    private static ResourceManager rm = new ResourceManager(baseName, System.Reflection.Assembly.Load("App_GlobalResources"));
    private CultureInfo ci;


    private void chooseLanguage()
    {

        if (Profile.Language != null && !Profile.Language.Equals(""))
        {

            if (Profile.Language.Equals("Português") || Profile.Language.Equals("Portuguese"))
            {
                ci = new CultureInfo("pt");

            }
            else
            {
                ci = new CultureInfo("en-US");
            }
        }
        else
        {
            ci = new CultureInfo("en-US");
        }

    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillTags();
            FillActuaisTags();
        }
        
        chooseLanguage();
        title.Text = rm.GetString("Gerir_Titulo", ci);
        subtitle1.Text = rm.GetString("Gerir_SubTit1", ci);
        subtitle2.Text = rm.GetString("Gerir_SubTit2", ci);
        delete.Text = rm.GetString("Gerir_Delete", ci);
        aceitar.Text = rm.GetString("Gerir_Aceitar",ci);
        rejeitar.Text = rm.GetString("Gerir_Rejeitar", ci);
    }

    protected void FillTags()
    {
        GridView1.DataSource = Graphs4Social_AR.Tag.LoadTagsByEstado(0);
        GridView1.DataBind();
    }

    protected void FillActuaisTags()
    {
        GridView2.DataSource = Graphs4Social_AR.Tag.LoadAllTag();
        GridView2.DataBind();
    }
 
    protected void delete_Click(object sender, EventArgs e)
    {
        IList<Graphs4Social_AR.Tag> tagsList = Graphs4Social_AR.Tag.LoadAllTag();
        int i = 0;
        foreach (GridViewRow row in GridView2.Rows)
        {
            CheckBox check = (CheckBox)row.FindControl("chkSelect2");

            if (check.Checked)
            {
                tagsList[i].MudarEstadoTagInt(-1);
                tagsList[i].Eliminado = true;
                tagsList[i].Save();
            }
            i++;
        }

        FillTags();
        FillActuaisTags();
    }


    protected void aceitar_Click(object sender, EventArgs e)
    {
        IList<Graphs4Social_AR.Tag> tagsList = Graphs4Social_AR.Tag.LoadTagsByEstado(0);
        int i = 0;
        foreach (GridViewRow row in GridView1.Rows)
        {
            CheckBox check = (CheckBox)row.FindControl("chkSelect1");

            if (check.Checked)
            {
                tagsList[i].MudarEstadoTagInt(1);
                tagsList[i].Save();
            }
            i++;
        }

        FillTags();
        FillActuaisTags();
    }

    protected void rejeitar_Click(object sender, EventArgs e)
    {
        IList<Graphs4Social_AR.Tag> tagsList = Graphs4Social_AR.Tag.LoadTagsByEstado(0);
        int i = 0;
        foreach (GridViewRow row in GridView1.Rows)
        {
            CheckBox check = (CheckBox)row.FindControl("chkSelect1");

            if (check.Checked)
            {
                tagsList[i].MudarEstadoTagInt(-1);
                tagsList[i].Eliminado = true;
                tagsList[i].Save();
            }
            i++;
        }

        FillTags();
        FillActuaisTags();
    }
}