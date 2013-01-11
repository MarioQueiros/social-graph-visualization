<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <h2><asp:Label ID="Label1" runat="server"></asp:Label></h2>
        </div>
    </section>
</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <br />
    <br />
    <h3><asp:Label ID="Label2" runat="server"></asp:Label></h3>
    <br />
    <br />
    <asp:Image ID="world" runat="server" />
</asp:Content>