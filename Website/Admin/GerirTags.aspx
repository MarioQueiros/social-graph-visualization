<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="GerirTags.aspx.cs" Inherits="Admin_GerirTags" %>

<asp:Content ContentPlaceHolderID="MainContent" ID="BodyContent" runat="server">

<h1><asp:Label ID="title" runat="server" Text=""></asp:Label></h1>
<br />
<h3><asp:Label ID="subtitle1" runat="server" Text=""></asp:Label></h3>
<b><asp:Label ID="semTags" runat="server" Text="" Visible="false"></asp:Label></b>
<table id="contentTags">
<tr>
<td>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" BackColor="#efeeef" BorderColor="#CCCCCC" AutoGenerateColumns="false" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" >
        <Columns>
            <asp:BoundField DataField="nome" HeaderText="Nome"/>
            <asp:TemplateField HeaderText="Escolha">
                <ItemTemplate>
                    <asp:CheckBox id="chkSelect1" runat="server"/>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:BoundField DataField="ID" Visible="false">
                <ItemStyle CssClass="hidden"/>
            </asp:BoundField>
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
</td>
<td>
<asp:Button ID="aceitar" Text="" runat="server" OnClick="aceitar_Click" />
<br />
<asp:Button ID="rejeitar" runat="server" Text="" OnClick="rejeitar_Click"/>
</td>
</tr>    
</table>
<br />
<br />

<h3><asp:Label ID="subtitle2" runat="server" Text=""></asp:Label></h3>
<table id="contentTags2">
<tr>
</tr>
    <tr>
        <td>
            <asp:GridView ID="GridView2" runat="server" AllowPaging="True" BackColor="#efeeef" BorderColor="#CCCCCC" AutoGenerateColumns="false" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal" >
        <Columns>
            <asp:BoundField DataField="nome" HeaderText="Nome"/>
			<asp:BoundField DataField="quantidade" HeaderText="Quantidade"/>
            <asp:TemplateField HeaderText="Escolha">
                <ItemTemplate>
                    <asp:CheckBox id="chkSelect2" runat="server"/>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:BoundField DataField="ID" Visible="false">
                <ItemStyle CssClass="hidden"/>
            </asp:BoundField>
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

        </td>
        <td>
            <asp:Button ID="delete" runat="server" Text="" OnClick="delete_Click" />
        </td>
    </tr>
</table>


<br />
<br />

<h3><asp:Label ID="subtitle3" runat="server" Text=""></asp:Label></h3>

<asp:Label ID="lblorig" runat="server" Text=""></asp:Label><asp:TextBox ID="tb1" runat="server" Text=""></asp:TextBox> - <asp:Label ID="lblfinal" Text="" runat="server"></asp:Label><asp:TextBox ID="tb2" runat="server" Text=""></asp:TextBox> <asp:Button runat="server" ID="btsave" OnClick="btsave_Click" />
<br />
<asp:Label ID="error" runat="server" Text="" Visible="false"></asp:Label>
</asp:Content>
