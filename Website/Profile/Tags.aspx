<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Tags.aspx.cs" Inherits="Profile_Tags" MasterPageFile="~/Site.master"%>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">



<ul id="array_tag_handler" onchange="change()"></ul>

<input id="save" class="btSave" type="button" value="<%= rm.GetString("Editar_Button",ci) %>" />

<asp:Label ID="label1" runat="server" Text="" CssClass="label"></asp:Label>



<script type="text/javascript" src="../Scripts/jquery.taghandler.min.js"></script>
<link rel="stylesheet" href="../Content/jquery.taghandler.css" />



<script type="text/javascript">


    $("#array_tag_handler").tagHandler({
                    assignedTags: [],
                    availableTags: [<%= setTags() %>],
                    autocomplete: true
    });


    $("#save").click(function () {
        window.location.href= "Tags.aspx?tags="+$("#array_tag_handler").tagHandler("getSerializedTags");

    });
</script>

<style>

    .label {
        color:white;
    }

</style>

</asp:Content>
