<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Tags.aspx.cs" Inherits="Profile_Tags" MasterPageFile="~/Site.master"%>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <ul id="array_tag_handler"></ul>

<script type="text/javascript" src="../Scripts/jquery.taghandler.min.js"></script>
<link rel="stylesheet" href="../Content/jquery.taghandler.css" />
<script type="text/javascript">

    $("#array_tag_handler").tagHandler({
                    assignedTags: [],
                    availableTags: ['Isep', 'Porto', 'Futebol', 'Internet'],
                    autocomplete: true
                });

</script>

</asp:Content>
