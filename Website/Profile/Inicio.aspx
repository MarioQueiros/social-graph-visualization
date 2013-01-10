<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Inicio.aspx.cs" Inherits="Profile_Inicio" MasterPageFile="~/Site.master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <table>
        <tr>
            <td>
                <asp:Image ID="Image1" runat="server" />
            </td>
            <td style="text-align: right; width: 250px; font-size: xx-large; font-variant: small-caps;">
                <hgroup id="tituloPerfil" class="title" runat="server">
                </hgroup>
            </td>
            <td style="width: 150px;">
                <fieldset>
                    <legend><asp:Label ID="Label17" runat="server" Text=""></asp:Label></legend>
                    <table style="height: 200px; width: 150px; text-align: center; vertical-align: text-top;">
                        <tr>
                            <td style="padding-left:15px">
                                <img src="<%= fillEstadoHumor() %>" id="imgestadohumor" /></td>
                        </tr>
                        <tr>
                            <td>
                                <table style="text-align: center; vertical-align: text-top; width: 150px;">
                                    <tr>
                                        <td style="padding-left:45px;">
                                            <input id="Hidden1" name="Hidden1" type="Hidden" runat="server" value="" />
                                            <select id="dropestadohumor" class="tagsProfile" onchange="alterar();">
                                                <option value="Bored"><%= rm.GetString("Estado_Aborrecido", ci) %></option>
                                                <option value="Pleased"><%= rm.GetString("Estado_Entusiasmado", ci) %></option>
                                                <option value="Sad"><%= rm.GetString("Estado_Triste", ci) %></option>
                                                <option value="Sleepy"><%= rm.GetString("Estado_Sonolento", ci) %></option>
                                                <option value="Smiley"><%= rm.GetString("Estado_Alegre", ci) %></option>
                                                <option value="Teards"><%= rm.GetString("Estado_Chorar", ci) %></option>
                                                <option value="Upset"><%= rm.GetString("Estado_Baixo", ci) %></option>
                                            </select></td>
                                        <td id="buttonTD">
                                            <asp:Button ID="subEstadoHumor" runat="server" Text="" OnClick="subEstadoHumor_Click" CssClass="btSave" /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>
        </tr>
        </table>
    <br />
    <asp:Button ID="Button1" runat="server" Text="" Visible="false" OnClick="Button1_Click" CssClass="btProfile" />

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
    <br />

    <asp:Label ID="Label9" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label1" runat="server" Text="" Visible="false"></asp:Label>

    <br />

    <asp:Label ID="Label10" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label2" runat="server" Text="" Visible="false"></asp:Label>

    <br />

    <asp:Label ID="Label11" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label3" runat="server" Text="" Visible="false"></asp:Label>

    <br />
    <br />

    <asp:Label ID="Label12" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label4" runat="server" Text="" Visible="false"></asp:Label>

    <br />

    <asp:Label ID="Label13" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label5" runat="server" Text="" Visible="false"></asp:Label>

    <br />

    <asp:Label ID="Label14" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Label ID="Label6" runat="server" Text="" Visible="false"></asp:Label>

    <br />
    <br />

    <asp:Label ID="Label15" runat="server" Text="" Visible="false"></asp:Label>
    <asp:HyperLink ID="HyperLink1" runat="server">
        <asp:Label ID="Label7" runat="server" Text="" Visible="false"></asp:Label>
    </asp:HyperLink>

    <br />
    <br />

    <asp:Label ID="Label16" runat="server" Text="" Visible="false"></asp:Label>
    <asp:HyperLink ID="HyperLink2" runat="server">
        <asp:Label ID="Label8" runat="server" Text="" Visible="false"></asp:Label>
    </asp:HyperLink>

    <br />

    <div id="profiletab">
        <ul>
            <li><a href="#tabs-1">
                <asp:Label ID="Label19" runat="server" Text=""></asp:Label></a></li>
            <li><a href="#tabs-2">
                <asp:Label ID="Label20" runat="server" Text=""></asp:Label></a></li>
        </ul>
        <div id="tabs-1">
            <br />
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
            <br />
            <br />
            <%= new TagCloud.TagCloud( 
                    LoadTags(),
                new TagCloud.TagCloudGenerationRules
                {
                    Order = TagCloud.TagCloudOrder.Alphabetical,
                    TagCssClassPrefix = "tagGraphs",
                    WeightClassPartitioning = new System.Collections.ObjectModel.ReadOnlyCollection<int>(new[] { 10, 10, 10, 10, 10, 10, 10, 10, 10, 10})
                    })
        
            %>


        </div>
    </div>

    

    <link rel="stylesheet" href="http://code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.8.3.js"></script>
    <script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>

    
    <script>
        function alterar() {
            var aux = document.getElementById("dropestadohumor").value;
            
            document.getElementById("imgestadohumor").src = "../Images/" + aux + ".png";
            document.getElementById("<%= Hidden1.ClientID %>").value = aux + ".png";
        }

        function mudarEstado() {
            var str = "<%= mudarEstadoHumor() %>";
            var aux =  str.split(".");
            switch (aux[0])
            {
                case 'Bored':
                    document.getElementById("dropestadohumor").selectedindex = 1;
					document.getElementById("imgestadohumor").src="../Images/Bored.png";
					break;
                case 'Pleased':
                    document.getElementById("dropestadohumor").selectedindex = 2;
					document.getElementById("imgestadohumor").src="../Images/Pleased.png";
                    break;
                case 'Sad':
                    document.getElementById("dropestadohumor").selectedindex = 3;
					document.getElementById("imgestadohumor").src="../Images/Sad.png";
                    break;
                case 'Sleepy':
                    document.getElementById("dropestadohumor").selectedindex = 4;
					document.getElementById("imgestadohumor").src="../Images/Sleepy.png";
                    break;
                case 'Smiley':
                    document.getElementById("dropestadohumor").selectedindex = 5;
					document.getElementById("imgestadohumor").src="../Images/Smiley.png";
                    break;
                case 'Teards':
                    document.getElementById("dropestadohumor").selectedindex = 6;
					document.getElementById("imgestadohumor").src="../Images/Teards.png";
                    break;
                case 'Upset':
                    document.getElementById("dropestadohumor").selectedindex = 7;
					document.getElementById("imgestadohumor").src="../Images/Upset.png";
                    break;
            }
            document.getElementById("dropestadohumor").value = aux[0];
        }

        function setEstado() {
			var str = "<%= setEstadoHumor() %>";
            var aux =  str.split(".");
            switch (aux[0])
            {
                case 'Bored':
                    document.getElementById("dropestadohumor").selectedindex = 1;
					document.getElementById("dropestadohumor").disabled = "true";
					//document.getElementById("<%= subEstadoHumor.ClientID %>").style.visibility = "hidden";
                    document.getElementById("buttonTD").parentNode.removeChild(document.getElementById("buttonTD"));
					document.getElementById("imgestadohumor").src="../Images/Bored.png";
					break;
                case 'Pleased':
                    document.getElementById("dropestadohumor").selectedindex = 2;
					document.getElementById("dropestadohumor").disabled = "true";
					//document.getElementById("<%= subEstadoHumor.ClientID %>").style.visibility = "hidden";
                    document.getElementById("buttonTD").parentNode.removeChild(document.getElementById("buttonTD"));
					document.getElementById("imgestadohumor").src="../Images/Pleased.png";
                    break;
                case 'Sad':
                    document.getElementById("dropestadohumor").selectedindex = 3;
					document.getElementById("dropestadohumor").disabled = "true";
					//document.getElementById("<%= subEstadoHumor.ClientID %>").style.visibility = "hidden";
                    document.getElementById("buttonTD").parentNode.removeChild(document.getElementById("buttonTD"));
					document.getElementById("imgestadohumor").src="../Images/Sad.png";
                    break;
                case 'Sleepy':
                    document.getElementById("dropestadohumor").selectedindex = 4;
					document.getElementById("dropestadohumor").disabled = "true";
					//document.getElementById("<%= subEstadoHumor.ClientID %>").style.visibility = "hidden";
                    document.getElementById("buttonTD").parentNode.removeChild(document.getElementById("buttonTD"));
					document.getElementById("imgestadohumor").src="../Images/Sleepy.png";
                    break;
                case 'Smiley':
                    document.getElementById("dropestadohumor").selectedindex = 5;
					document.getElementById("dropestadohumor").disabled = "true";
					//document.getElementById("<%= subEstadoHumor.ClientID %>").style.visibility = "hidden";
                    document.getElementById("buttonTD").parentNode.removeChild(document.getElementById("buttonTD"));
					document.getElementById("imgestadohumor").src="../Images/Smiley.png";
                    break;
                case 'Teards':
                    document.getElementById("dropestadohumor").selectedindex = 6;
					document.getElementById("dropestadohumor").disabled = "true";
					//document.getElementById("<%= subEstadoHumor.ClientID %>").style.visibility = "hidden";
                    document.getElementById("buttonTD").parentNode.removeChild(document.getElementById("buttonTD"));
					document.getElementById("imgestadohumor").src="../Images/Teards.png";
                    break;
                case 'Upset':
                    document.getElementById("dropestadohumor").selectedindex = 7;
					document.getElementById("dropestadohumor").disabled = "true";
					//document.getElementById("<%= subEstadoHumor.ClientID %>").style.visibility = "hidden";
                    document.getElementById("buttonTD").parentNode.removeChild(document.getElementById("buttonTD"));
					document.getElementById("imgestadohumor").src="../Images/Upset.png";
                    break;
            }
            document.getElementById("dropestadohumor").value = aux[0];
        }
		
        function pageLoad() {
            var aux = "<%= checkUsername() %>";
            var flag = aux.toLowerCase();
            if (flag == "true") {
                mudarEstado();
            } else {
                setEstado();
            }   
        }
    </script>

    <style>
        
        .tagGraphs10 {
            font-size: 31px;
            color:#15376a;
        }

        .tagGraphs9 {
            font-size: 29px;
            color:#18407b;
        }

        .tagGraphs8 {
            font-size: 27px;
            color:#1f529d;
        }

        .tagGraphs7 {
            font-size: 25px;
            color:#225aae;
        }

        .tagGraphs6 {
            font-size: 23px;
            color:#2868c7;
        }

        .tagGraphs5 {
            font-size: 21px;
            color:#3f7dd8;
        }

        .tagGraphs4 {
            font-size: 19px;
            color:#5088dc;
        }

        .tagGraphs3 {
            font-size: 17px;
            color:#6194df;
        }

        .tagGraphs2 {
            font-size: 15px;
            color:#729fe2;
        }

        .tagGraphs1 {
            font-size: 13px;
            color:#9dbceb;
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
            text-align: center;
            color: #333333;
            background-color: white;
            border-color: gray;
            border-style: solid;
            border-width: 2px;
            font-variant: small-caps;
            font-weight: bold;
        }

        .tagsProfile {
            height: 40px;
            padding: 5px;
            text-align: center;
            color: #333333;
            background-color: white;
            border-color: gray;
            border-style: solid;
            border-width: 2px;
            font-variant: small-caps;
            font-weight: bold;
        }

        #imgestadohumor {
            width: 100px;
            height: 100px;
        }

        .btSave {
            height: 40px;
			padding-top: 5px;
			padding-bottom: 5px;
			padding-left:15px;
			padding-right:15px;
            color: #333333;
            background-color: white;
            border-color: gray;
            border-style: solid;
            font-variant: small-caps;
            font-weight: bold;
        }
    </style>


</asp:Content>
