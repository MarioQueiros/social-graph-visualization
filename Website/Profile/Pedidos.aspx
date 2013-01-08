<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Pedidos.aspx.cs" Inherits="Profile_Pedidos" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <script type="text/javascript">

        function pageLoad(sender, args) {
            $("#<%=btt.ClientID %>").click(function () {

                $("#dialog").dialog("open");

            });

            $("#dialog").dialog({
                autoOpen: false,
                buttons: {
                    "Ok": function () {
                        var v = $("#MainContent_btt").attr("onclick");

                        var f = v.split(",");

                        var s = f[4].replace('"', '');
                        var s1 = s.replace('"', '');

                        var nome = s1.split("=");

                        window.location = "Pedidos.aspx?user=" + nome[1] + "&forca=" + $("#dropdown option:selected").text();
                    },
                    "Cancelar": function () {
                        $(this).dialog("close");
                    }
                }
            });
        }

    </script>
    <table id="pedidosTable" runat="server"></table>

    <asp:Button ID="btt" runat="server" OnClientClick="return false;"/>
    <asp:Button ID="btt1" runat="server" UseSubmitBehavior="false" OnClick="btt1_Click"/>
    <asp:DropDownList ID="dropi" runat="server" AutoPostBack="True"/>
    <asp:Image ID="img" runat="server" />
    <asp:Label ID="Label1" runat="server" Visible="false"></asp:Label>
    <br />
    <br />
    <br />
    <asp:Label ID="Label2" runat="server" Visible="false" style="font-weight: 700"></asp:Label>

    <div id="dialog" title="Força Ligação">
        Escolha a força da ligação:<br />
        <select id="dropdown">
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
            <option>5</option>
        </select>
        <asp:DropDownList ID="tagsdrop" runat="server"></asp:DropDownList>
    </div>

</asp:Content>
