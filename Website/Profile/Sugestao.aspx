<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Sugestao.aspx.cs" Inherits="Profile_Sugestao" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" Runat="Server">
    <p>
        Sugestoes de amizade:</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:GridView ID="GridView1" runat="server">
    </asp:GridView>
</asp:Content>

