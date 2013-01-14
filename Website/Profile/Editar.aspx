<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Editar.aspx.cs" Inherits="Profile_Editar" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <hgroup class="title">
    </hgroup>
    <div id="editarProfile">
        <section id="SetSexo">

            <fieldset>
                <legend>
                    <asp:Label ID="Label3" runat="server" Text=""></asp:Label>
                </legend>
                <asp:PlaceHolder runat="server" ID="PlaceHolder1" Visible="True">
                    <table class="tablesEditar">
                        <tr style="width: 500px;">
                            <td style="width: 250px; float: left;">
                                <asp:DropDownList ID="DropDownList1" runat="server"></asp:DropDownList>
                            </td>
                            <td style="width: 250px; vertical-align: middle;">
                                <asp:Button ID="Button2" Height="30px" runat="server" Text="" ValidationGroup="SetSexo" OnClick="setSexo_click" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
            </fieldset>
        </section>
        <br />
        <section id="SetDataNasc">
            <fieldset>
                <legend>
                    <asp:Label ID="Label4" runat="server" Text=""></asp:Label></legend>
                <asp:PlaceHolder runat="server" ID="PlaceHolder2" Visible="True">
                    <table class="tablesEditar">
                        <tr style="width: 500px;">
                            <td style="width: 250px; float: left;">
                                <asp:TextBox ID="datepicker" runat="server" CssClass="DatepickerInput" />

                                <asp:Literal ID="litMessage" runat="server" />
                            </td>
                            <td style="width: 250px; vertical-align: middle;">
                                <asp:Button ID="Button3" Height="30px" runat="server" Text="" ValidationGroup="SetDataNasc" OnClick="setDataNasc_click" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>

            </fieldset>
        </section>
        <br />
        <section id="SetRegiao">
            <fieldset>
                <legend>
                    <asp:Label ID="Label5" runat="server" Text=""></asp:Label></legend>
                <asp:PlaceHolder runat="server" ID="PlaceHolder3" Visible="True">
                    <table class="tablesEditar">
                        <tr style="width: 500px;">
                            <td style="width: 250px; float: left;">
                                <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                                <asp:Label ID="Label1" runat="server" Text="Região inválida" Visible="false" ForeColor="Red"></asp:Label>
                            </td>
                            <td style="width: 250px; vertical-align: middle;">
                                <asp:Button ID="Button1" Height="30px" runat="server" Text="" ValidationGroup="SetRegiao" OnClick="setRegiao_click" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
            </fieldset>
        </section>
        <br />
        <section id="SetContacto">
            <fieldset>
                <legend>
                    <asp:Label ID="Label6" runat="server" Text=""></asp:Label></legend>
                <asp:PlaceHolder runat="server" ID="PlaceHolder4" Visible="True">
                    <table class="tablesEditar">
                        <tr style="width: 500px;">
                            <td style="width: 250px; float: left;">
                                <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                                <asp:Label ID="Label2" runat="server" Text="Contacto inválido" Visible="false" ForeColor="Red"></asp:Label>
                            </td>
                            <td style="width: 250px; vertical-align: middle;">
                                <asp:Button ID="Button4" Height="30px" runat="server" Text="" ValidationGroup="SetContacto" OnClick="setContacto_click" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
            </fieldset>
        </section>
        <br />
        <section id="SetLinguagem">
            <fieldset>
                <legend>
                    <asp:Label ID="Label7" runat="server" Text=""></asp:Label></legend>
                <asp:PlaceHolder runat="server" ID="PlaceHolder5" Visible="True">
                    <table class="tablesEditar">
                        <tr style="width: 500px;">
                            <td style="width: 250px; float: left;">


                                <asp:DropDownList ID="DropDownList2" runat="server"></asp:DropDownList>
                            </td>
                            <td style="width: 250px; vertical-align: middle;">
                                <asp:Button ID="Button5" Height="30px" runat="server" Text="" ValidationGroup="SetLinguagem" OnClick="setLinguagem_click" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
            </fieldset>
        </section>
        <br />
        <section id="setAvatar">
            <fieldset>
                <legend>
                    <asp:Label ID="Label10" runat="server" Text=""></asp:Label></legend>
                <asp:PlaceHolder runat="server" ID="PlaceHolder10" Visible="True">
                    <table class="tablesEditar">
                        <tr style="width: 500px;">
                            <td style="width: 250px; float: left;">
                                <table>
                                    <tr>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/anonymous.png" onClick="avatarClick(1);" />
                                                        <input name="avatar" runat="server" type="radio" id="r1" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/hostage.png" onclick="avatarClick(2);" />
                                                        <input name="avatar" runat="server" type="radio" id="r2" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/bugsbunny.png" onclick="avatarClick(3);" />
                                                        <input name="avatar" runat="server" type="radio" id="r3" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/DarthVader.png" onclick="avatarClick(4);" />
                                                        <input name="avatar" runat="server" type="radio" id="r4" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/scientist.png" onclick="avatarClick(5);" />
                                                        <input name="avatar" runat="server" type="radio" id="r5" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/nuku_Girl.png" onclick="avatarClick(6);" />
                                                        <input name="avatar" runat="server" type="radio" id="r6" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/urban.png" onclick="avatarClick(7);" />
                                                        <input name="avatar" runat="server" type="radio" id="r7" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <table class="tableavatar">
                                                <tr>
                                                    <td>
                                                        <img class="avatar" src="../Images/Spiderman.png" onClick="avatarClick(8);" />
                                                        <input name="avatar" runat="server" type="radio" id="r8" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    </table>
                                </td>
                        </tr>

                    <tr>
                        <td style="width: 250px; vertical-align: middle;">
                            <asp:Button ID="Button6" Height="30px" runat="server" Text="" ValidationGroup="SetAvatar" OnClick="setAvatar_Click" />
                        </td>
                    </tr>
                    </table>
                </asp:PlaceHolder>
            </fieldset>
        </section>
        <br />
        <section id="FacebookLogin">
            <fieldset>
                <legend>
                    <asp:Label ID="Label8" runat="server" Text=""></asp:Label></legend>
                <!--<asp:PlaceHolder runat="server" ID="PlaceHolder6" Visible="True">
                <br />
                <div id="fb-root"></div>
                <script>(function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/pt_PT/all.js#xfbml=1&appId=393390987406022";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
                </script>

                <div class="fb-login-button" data-show-faces="true" data-width="500" data-max-rows="3"></div>
            </asp:PlaceHolder>-->
            </fieldset>
        </section>
        <br />
        <section id="LinkedInLogin">
            <fieldset>
                <legend>
                    <asp:Label ID="Label9" runat="server" Text=""></asp:Label></legend>
                <!--<asp:PlaceHolder runat="server" ID="PlaceHolder7" Visible="True">

                <script type="in/Login">
                Hello, <?js= firstName ?> <?js= lastName ?>.
                </script>



            </asp:PlaceHolder>-->
            </fieldset>
        </section>
    </div>
    <script type="text/javascript">
        
        function avatarClick(num) {
            document.getElementById('MainContent_r' + num).checked = true;
        }

    </script>

</asp:Content>
