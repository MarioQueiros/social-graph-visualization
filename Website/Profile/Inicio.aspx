<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Inicio.aspx.cs" Inherits="Profile_Inicio" MasterPageFile="~/Site.master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <table>
        <tr>
            <td>
                <asp:Image ID="Image1" runat="server" />
            </td>
            <td style="text-align:right; width:250px; font-size:xx-large;font-variant:small-caps;">
                <hgroup id="tituloPerfil" class="title" runat="server">
                </hgroup>
            </td>
        </tr>
    </table>
    <br />
    <asp:Button ID="Button1" runat="server" Text="" Visible="false" OnClick="Button1_Click" CssClass="btProfile"/>
    
    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="listProfile" AutoPostBack="false" Visible="false">
        <asp:ListItem Value="1">1</asp:ListItem>
        <asp:ListItem Value="2">2</asp:ListItem>
        <asp:ListItem Value="3">3</asp:ListItem>
        <asp:ListItem Value="4">4</asp:ListItem>
        <asp:ListItem Value="5">5</asp:ListItem>
    </asp:DropDownList>

    <br />

    <asp:Label ID="Label9" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label1" runat="server" Text="" Visible="false"></asp:Label>

    <br />

    <asp:Label ID="Label10" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label2" runat="server" Text="" Visible="false"></asp:Label>
    
    <br />

    <asp:Label ID="Label11" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label3" runat="server" Text="" Visible="false"></asp:Label>

    <br /><br />

    <asp:Label ID="Label12" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label4" runat="server" Text="" Visible="false"></asp:Label>

    <br />

    <asp:Label ID="Label13" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label5" runat="server" Text="" Visible="false"></asp:Label>

    <br />

    <asp:Label ID="Label14" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label6" runat="server" Text="" Visible="false"></asp:Label>

    <br /><br />

    <asp:Label ID="Label15" runat="server" Text="" Visible="false"></asp:Label>
    <asp:HyperLink ID="HyperLink1" runat="server">
        <asp:Label ID="Label7" runat="server" Text="" Visible="false"></asp:Label>
    </asp:HyperLink>

    <br /><br />

    <asp:Label ID="Label16" runat="server" Text="" Visible="false"></asp:Label>
    <asp:HyperLink ID="HyperLink2" runat="server">
        <asp:Label ID="Label8" runat="server" Text="" Visible="false"></asp:Label>
    </asp:HyperLink>

    <br />
    <hr />
    <br />

    <asp:Label ID="Label17" runat="server" Text=""></asp:Label>
    <asp:Label ID="Label18" runat="server" Text=""></asp:Label>

    <br />
    <br />

    <table id="tabelaDeAmigos" runat="server"></table>

    <style>
        .btProfile {
            width: 200px;
            height: 40px;
            padding: 5px;
            color: #333333;
            background-color: white;
            border-color: gray;
            border-style:solid;
            font-variant:small-caps;
            font-weight:bold;
        }
        .listProfile {
            width: 50px;
            height: 40px;
            padding: 5px;
            text-align:center;
            color: #333333;
            background-color: white;
            border-color: gray;
            border-style:solid;
            border-width: 2px;
            font-variant:small-caps;
            font-weight:bold;
        }
    </style>
</asp:Content>
