<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PesquisarPorTag.aspx.cs" Inherits="Profile_PesquisarPorTag" %>

<asp:Content ContentPlaceHolderID="MainContent" ID="BodyContent" runat="server">

    <h1><asp:Label ID="titulo" runat="server" Text=""></asp:Label></h1>

    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" BackColor="#efeeef" BorderColor="#CCCCCC" AutoGenerateColumns="true" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" >
        <Columns>          
            <asp:TemplateField HeaderText="Escolha">
                <ItemTemplate>
                    <asp:CheckBox id="chkSelect1" runat="server"/>
                </ItemTemplate>
            </asp:TemplateField>
            
        </Columns>
        <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
        <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="#efeeef" />
        <PagerStyle BackColor="#efeeef" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
        <SortedAscendingCellStyle BackColor="#F7F7F7" />
        <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
        <SortedDescendingCellStyle BackColor="#E5E5E5" />
        <SortedDescendingHeaderStyle BackColor="#242121" />
    </asp:GridView>
<asp:Button ID="pesquisar" runat="server" Text="" OnClick="pesquisar_Click" />

<br />
<h2><asp:Label ID="erro" runat="server" Text="" Visible="false"></asp:Label></h2>
<h2><asp:Label ID="lblamigos" runat="server" Text=""></asp:Label></h2>
<table runat="server" id="amigosTable"></table>

</asp:Content>