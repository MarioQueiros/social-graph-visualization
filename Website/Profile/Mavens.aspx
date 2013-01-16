<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Mavens.aspx.cs" Inherits="Profile_Mavens" %>

<asp:Content ContentPlaceHolderID="MainContent" ID="BodyContent" runat="server">

    <h1><asp:Label ID="titulo" runat="server" Text=""></asp:Label></h1>

    <br />

    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" BackColor="#efeeef" BorderColor="#CCCCCC" AutoGenerateColumns="true" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" >
        <Columns>
            
            <asp:ButtonField CommandName="Select" Text="Escolher" />

        </Columns>
        <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
        <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="#efeeef" />
        <PagerStyle BackColor="#efeeef" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#7ac0da" Font-Bold="True" ForeColor="White" />
        <SortedAscendingCellStyle BackColor="#F7F7F7" />
        <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
        <SortedDescendingCellStyle BackColor="#E5E5E5" />
        <SortedDescendingHeaderStyle BackColor="#242121" />
    </asp:GridView>

<br />
<b><asp:Label ID="userMaven" runat="server" Text="" Visible="false"></b></asp:Label><b> <asp:HyperLink ID="hl" runat="server" Visible="false" Text="" NavigateUrl="#"></asp:HyperLink></b>

<br />

<h3><asp:Label ID="erro" runat="server" Text="" Visible="false"></asp:Label></h3>

</asp:Content>