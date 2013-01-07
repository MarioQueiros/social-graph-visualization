<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Pedidos.aspx.cs" Inherits="Profile_Pedidos" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">



    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowCommand="GridView1_RowCommand1">
        <Columns>

            <asp:TemplateField>
                <ItemTemplate>
                    <asp:LinkButton ID="aceitar" runat="server" CommandName="Aceitar" Text="Aceitar"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:LinkButton ID="rejeitar" runat="server" CommandName="Rejeitar" Text="Rejeitar"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>



</asp:Content>
