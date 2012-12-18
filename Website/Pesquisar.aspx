<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Pesquisar.aspx.cs" Inherits="Pesquisar" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <section id="SetSexo">
        <h3>Procurar amigos por username</h3>
        <fieldset>
            <legend>Insira um username</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder1" Visible="True">
                <ol>
                    <li>
                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox><br />
                        <asp:Label ID="Label1" runat="server" Text="Username não encontrado" Visible="false" ForeColor="Red"></asp:Label>
                    </li>
                </ol>
                <asp:Button ID="Button2" Height="40px" runat="server" Text="Pesquisar" ValidationGroup="pesquisarUser" OnClick="pesquisarUser_Click" />
            </asp:PlaceHolder>
        </fieldset>
    </section>

    

</asp:Content>