<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Sugestao.aspx.cs" Inherits="Profile_Sugestao" %>



        
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" Runat="Server">
<h1><asp:Label ID="titulo" runat="server" Text=""></asp:Label></h1>

<asp:GridView ID="GridView1" runat="server" AllowPaging="True" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" BackColor="#efeeef" BorderColor="#CCCCCC" AutoGenerateColumns="true" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" >
        <Columns>
            
            <asp:ButtonField CommandName="Select" Text="Visitar" />

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
</asp:Content>

