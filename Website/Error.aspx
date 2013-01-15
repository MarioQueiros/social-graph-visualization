<%@ Page Language="C#" MasterPageFile="~/Site.master"AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="Profile_404" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <table>
        <tr>
            <td>
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/warning.jpg"/>
            </td>
            <td style="width: inherit; font-variant: small-caps;">
                <fieldset>
                    <legend><b>
                        <asp:Label ID="Label1" runat="server" Text=""></asp:Label></b></legend>
                    <asp:Label ID="Label2" runat="server" Text=""></asp:Label>
                    <br />
                    <br />
                    <asp:Label ID="Label3" runat="server" Text=""></asp:Label>
                    <br />
                    <br />
                    <asp:HyperLink ID="HyperLink1" runat="server">HyperLink</asp:HyperLink>
                </fieldset>

                <fieldset id="errorField" runat="server">
                    <legend>Error</legend>
                    <asp:Label ID="erro" runat="server" Text=""></asp:Label>
                </fieldset>
            </td>
        </tr>
    </table>



</asp:Content>
