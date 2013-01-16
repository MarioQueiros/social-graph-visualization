<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="GerirContas.aspx.cs" Inherits="Admin_GerirContas" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1><asp:Label ID="title" runat="server" Text=""></asp:Label></h1>

    <table id="contas" runat="server">
        <tr>
            <td><b><asp:Label ID="nome" runat="server" Text=""></asp:Label></b></td>
            <td><b><asp:Label ID="tags" runat="server" Text=""></asp:Label></b></td>
            <td><b><asp:Label ID="frie" runat="server" Text=""></asp:Label></b></td>
        </tr>
    </table>
</asp:Content>