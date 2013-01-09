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

    <asp:DropDownList ID="tagsRelacao" runat="server" CssClass="tagsProfile" AutoPostBack="false" Visible="false">
        
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
    
    <div id="profiletab">
        <ul>
            <li><a href="#tabs-1"><asp:Label ID="Label19" runat="server" Text=""></asp:Label></a></li>
            <li><a href="#tabs-2"><asp:Label ID="Label20" runat="server" Text=""></asp:Label></a></li>
        </ul>
        <div id="tabs-1">
            <asp:Label ID="Label18" runat="server" Text=""></asp:Label>

            <br />
            <br />
            <table id="tabelaDeAmigos" runat="server"></table>

            <table>
                <tr>
                    <td>
                        <asp:Image ID="Image2" runat="server" Visible="false" ImageAlign="Middle" />
                    </td>
                    <td>
                        <asp:Image ID="Image3" runat="server" Visible="false" ImageAlign="Middle" /></td>
                </tr>
            </table>
        </div>
        <div id="tabs-2">
            <asp:Label ID="Label17" runat="server" Text="Label"></asp:Label>

            


        </div>
    </div>

                <div id="tagcloud">
                    <a href="#" rel="0.1">Lorem</a>
                    <a href="#" rel="2">ipsum</a>
                    <a href="#" rel="9">dolor</a>
                </div>

    
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.8.3.js"></script>
    <script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
	<script src="Scripts/jquery.tagcloud.js" type="text/javascript" charset="utf-8"></script>

    <script>
        $(function () {
            $("#tagcloud a").tagcloud({
                size: {
                    start: 14,
                    end: 18,
                    unit: 'px'
                },
                color: {
                    start: '#cde',
                    end: '#f52'
                }
            })
        });</script>

    <style>
        #tagcloud a {
            text-decoration: none;
        }

            #tagcloud a:hover {
                text-decoration: underline;
            }

        #tagcloud {
            margin: 25px auto;
            font: 75% Arial, "MS Trebuchet", sans-serif;
        }

        .btProfile {
            width: 200px;
            height: 40px;
            padding: 5px;
            color: #333333;
            background-color: white;
            border-color: gray;
            border-style: solid;
            font-variant: small-caps;
            font-weight: bold;
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
        .tagsProfile {
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
