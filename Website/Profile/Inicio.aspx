<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Inicio.aspx.cs" Inherits="Profile_Inicio" MasterPageFile="~/Site.master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <hgroup class="title" runat="server">
        <%: Profile.UserName %>
    </hgroup>

    <asp:Label ID="Label1" runat="server" Text="Label" Font-Size="Large"></asp:Label>



</asp:Content>
