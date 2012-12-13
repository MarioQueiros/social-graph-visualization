<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Editar.aspx.cs" Inherits="Profile_Editar" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <hgroup class="title">
    </hgroup>

    <section id="SetSexo">
        <h3>Sou</h3>
        <fieldset>
            <legend>O seu sexo</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder1" Visible="True">
                <ol>
                    <li>
                        <asp:DropDownList ID="DropDownList1" runat="server"></asp:DropDownList>
                    </li>
                </ol>
                <asp:Button ID="Button2" Height="40px" runat="server" Text="Gravar" ValidationGroup="SetSexo" OnClick="setSexo_click" />
            </asp:PlaceHolder>
        </fieldset>
    </section>

    

    

    <section id="SetDataNasc">
        <h3>Data de nascimento</h3>
        <fieldset>
            <legend>Insira a sua data de nascimento</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder2" Visible="True">
                <ol>
                    <asp:Calendar ID="Calendar1" runat="server"></asp:Calendar>
                </ol>
                <asp:Button ID="Button3" Height="40px" runat="server" Text="Gravar" ValidationGroup="SetDataNasc" OnClick="setDataNasc_click" />
            </asp:PlaceHolder>
        </fieldset>
    </section>


    <section id="SetRegiao">
        <h3>A sua região</h3>
        <fieldset>
            <legend>Insira a sua região</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder3" Visible="True">
                <ol>
                    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Text="Região inválida" Visible ="false" ForeColor="Red"></asp:Label>
                </ol>
                <asp:Button ID="Button1" Height="40px" runat="server" Text="Gravar" ValidationGroup="SetRegiao" OnClick="setRegiao_click" />
            </asp:PlaceHolder>
        </fieldset>
    </section>

    <section id="SetContacto">
        <h3>O seu contacto pessoal</h3>
        <fieldset>
            <legend>Insira o seu número de telefone</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder4" Visible="True">
                <ol>
                    <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                    <asp:Label ID="Label2" runat="server" Text="Contacto inválido" Visible ="false" ForeColor="Red"></asp:Label>
                </ol>
                <asp:Button ID="Button4" Height="40px" runat="server" Text="Gravar" ValidationGroup="SetContacto" OnClick="setContacto_click" />
            </asp:PlaceHolder>
        </fieldset>
    </section>


    <section id="SetLinguagem">
        <h3>O seu idioma</h3>
        <fieldset>
            <legend>Insira o seu idioma</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder5" Visible="True">
                <ol>
                    <asp:DropDownList ID="DropDownList2" runat="server"></asp:DropDownList>
                </ol>
                <asp:Button ID="Button5" Height="40px" runat="server" Text="Gravar" ValidationGroup="SetLinguagem" OnClick="setLinguagem_click" />
            </asp:PlaceHolder>
        </fieldset>
    </section>

    <section id="FacebookLogin">
        <h3>Associe a sua conta do Facebook</h3>
        <fieldset>
            <legend>Login com Facebook</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder6" Visible="True">
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
            </asp:PlaceHolder>
        </fieldset>
    </section>








    <section id="LinkedInLogin">
        <h3>Associe a sua conta do LinkedIn</h3>
        <fieldset>
            <legend>Login com LinkedIn</legend>
            <asp:PlaceHolder runat="server" ID="PlaceHolder7" Visible="True">

                <script type="text/javascript" src="http://platform.linkedin.com/in.js">
                    api_key: numnh65zep53
                </script>

                <asp:Label ID="Label3" runat="server" Text="Olá ,"></asp:Label>
                <script type="in/Login">
                    <?js= firstName ?> <?js= lastName ?>.
                </script>

                <script type="text/javascript" src="http://platform.linkedin.com/in.js">
                    api_key: numnh65zep53
                    authorize: true
                </script>

                <script type="IN/Login"> 
                    <form action="/register.html"> 
                    <p>Your Name: <input type="text" name="name" value="<?js= firstName ?> <?js= lastName ?>" /></p>
                    <p>Your Password: <input type="password" name="password" /></p>
                    <input type="hidden" name="linkedin-id" value="<?js= id ?>" />
                    <input type="submit" name="submit" value="Sign Up"/>
                </script>


                <script type="text/javascript">
                    function onLinkedInAuth() {
                        IN.API.Profile("me")
                          .result(function (me) {
                              var id = me.values[0].id;
                              // AJAX call to pass back id to your server
                          });
                    }
                </script>
                <script type="IN/Login" data-onAuth="onLinkedInAuth"></script>
            </asp:PlaceHolder>
        </fieldset>
    </section>

    
</asp:Content>