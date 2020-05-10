<%@ Page Title="BMD :. Map Explorer" EnableEventValidation="false" Language="C#" MasterPageFile="~/MyMaster.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="MapExplorer.aspx.cs" Inherits="MapExplorer" %>

<%@ Register TagPrefix="aspmap" Namespace="AspMap.Web" Assembly="AspMapNET" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link rel="stylesheet" type="text/css" href="Resources/mystyles.css" />
    <link rel="stylesheet" type="text/css" href="Resources/mystyle.css" />
    <link rel="stylesheet" type="text/css" href="Resources/gridview.css" />
    <link rel="stylesheet" type="text/css" href="Resources/menu.css" />

    <script type="text/javascript" src="Resources/jquery.js"></script>
    <script type="text/javascript" src="Resources/menu.js"></script>
 

</asp:Content>


<asp:Content ContentPlaceHolderID="DataContent" runat="server">
    <script type="text/javascript" language="javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequest);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);

        function beginRequest(sender, args) {
            window.$find('<%=mpeLoading.ClientID %>').show();
        }

        function endRequest(sender, args) {
            window.$find('<%=mpeLoading.ClientID %>').hide();
        }

        function SetMapHeight() {
            var wHeight = $(window).height() - 230;
            if ($("#data_content").height() < wHeight)
                $("#data_content").css("height", wHeight + parseInt(($(".map_center_panel").width() - $(".map_center_panel").height()) / 5));
            $("#data_content").css("height", $("#data_content").height() + parseInt(($(".map_center_panel").width() - $(".map_center_panel").height()) / 3));

            //$("#divMapFilter").css({ maxHeight: ($("#tdLeftPanel").height() - $("#divLeftPanelMapInfo").height() + 50) + 'px' });

//            var maxHeight = $("#tdLeftPanel").height() - $("#divLeftPanelMapInfo").height() + 50;
//            $("#divMapFilter").css({ maxHeight: maxHeight + 'px' });
            //$("#divMapFilter").css("max-height", $("#data_content").height() -500);

        }

        $(document).ready(function() {
            SetMapHeight();
        });

        function pageLoad() {
            //$("#divMapFilter").css({ maxHeight: ($("#tdLeftPanel").height() - $("#divLeftPanelMapInfo").height() + 50) + 'px' });
            $(".cb_gm input[type='checkbox']").each(function() {
                $(this).change(function() {
                    var isChk = $(this).is(":checked");
                    $(".cb_gm input[type='checkbox']").prop('checked', false);
                    if (isChk)
                        $(".cb_gm input[type='checkbox']").filter(':first').prop('checked', true);
                    else
                        $(this).prop('checked', true);
                });
            });
        }

    </script>
    
    

    <script language="javascript" type="text/javascript">
        /***************** TreeView ****************/
        function postBackOnCheck(e) {

            var isNav = (window.navigator.appName.toLowerCase().indexOf("netscape") >= 0);
            var obj;

            if (isNav && e != null)
                obj = e.target;
            else
                obj = window.event.srcElement;

            if (obj.tagName == "INPUT" && obj.type == "checkbox" && obj.name != null && obj.name.indexOf("CheckBox") > -1)
                __doPostBack("<%=tvMapLayers.ClientID%>", "");
        }

        function OnTreeClick(evt) {

            


            var src = window.event != window.undefined ? window.event.srcElement : evt.target;
            var isChkBoxClick = (src.tagName.toLowerCase() == "input" && src.type == "checkbox");
            if (isChkBoxClick) {
                var parentTable = GetParentByTagName("table", src);
                var nxtSibling = parentTable.nextSibling;
                if (nxtSibling && nxtSibling.nodeType == 1)//check if nxt sibling is not null & is an element node
                {
                    if (nxtSibling.tagName.toLowerCase() == "div") //if node has children
                    {
                        //check or uncheck children at all levels
                        CheckUncheckChildren(parentTable.nextSibling, src.checked);
                    }
                }
                //check or uncheck parents at all levels
                CheckUncheckParents(src, src.checked);
            }


             //========= start RBA ===================//
              var isNav = (window.navigator.appName.toLowerCase().indexOf("netscape") >= 0);
            var obj;

            if (isNav && e != null)
                obj = e.target;
            else
                obj = window.event.srcElement;

            if (obj.tagName == "INPUT" && obj.type == "checkbox" && obj.name != null && obj.name.indexOf("CheckBox") > -1)
                __doPostBack("<%=tvFilterOptions.ClientID%>", "");
            //=========  end RBA ====================//
           

        }

        function CheckUncheckChildren(childContainer, check) {
            var childChkBoxes = childContainer.getElementsByTagName("input");
            var childChkBoxCount = childChkBoxes.length;
            for (var i = 0; i < childChkBoxCount; i++) {
                childChkBoxes[i].indeterminate = false;

               
                childChkBoxes[i].checked = check;
               
            }
        }

        function CheckUncheckParents(srcChild, check) {
            var parentDiv = GetParentByTagName("div", srcChild);
            var parentNodeTable = parentDiv.previousSibling;

            if (parentNodeTable) {
                var checkUncheckSwitch;

                if (check || check == null) //checkbox checked
                {
                    var isAllSiblingsChecked = AreAllSiblingsChecked(srcChild);
                    if (isAllSiblingsChecked)
                        checkUncheckSwitch = true;
                    else
                        checkUncheckSwitch = null;
                    //do not need to check parent if any(one or more) child not checked
                }
                else //checkbox unchecked
                {
                    var isAllSiblingsUnChecked = AreAllSiblingsUnChecked(srcChild);
                    if (isAllSiblingsUnChecked)
                        checkUncheckSwitch = false;
                    else 
                        checkUncheckSwitch = null;
                }

                var inpElemsInParentTable = parentNodeTable.getElementsByTagName("input");
                if (inpElemsInParentTable.length > 0) {
                    var parentNodeChkBox = inpElemsInParentTable[0];

                    if (checkUncheckSwitch != null) {
                        parentNodeChkBox.indeterminate = false;
                        parentNodeChkBox.checked = checkUncheckSwitch; 
                    }
                    else
                        parentNodeChkBox.indeterminate = true;
                    //do the same recursively
                    CheckUncheckParents(parentNodeChkBox, checkUncheckSwitch);
                }
            }
        }

        function AreAllSiblingsChecked(chkBox) {
            var parentDiv = GetParentByTagName("div", chkBox);
            var childCount = parentDiv.childNodes.length;
            for (var i = 0; i < childCount; i++) {
                if (parentDiv.childNodes[i].nodeType == 1) //check if the child node is an element node
                {
                    if (parentDiv.childNodes[i].tagName.toLowerCase() == "table") {
                        var prevChkBox = parentDiv.childNodes[i].getElementsByTagName("input")[0];
                        //if any of sibling nodes are not checked, return false
                        if (!prevChkBox.checked || prevChkBox.indeterminate) {
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        function AreAllSiblingsUnChecked(chkBox) {
            var parentDiv = GetParentByTagName("div", chkBox);
            var childCount = parentDiv.childNodes.length;
            for (var i = 0; i < childCount; i++) {
                if (parentDiv.childNodes[i].nodeType == 1) //check if the child node is an element node
                {
                    if (parentDiv.childNodes[i].tagName.toLowerCase() == "table") {
                        var prevChkBox = parentDiv.childNodes[i].getElementsByTagName("input")[0];
                        //if any of sibling nodes are not checked, return false
                        if (prevChkBox.checked || prevChkBox.indeterminate) {
                            return false;
                            
                        }
                    }
                }
            }
            return true;
        }

        //utility function to get the container of an element by tagname
        function GetParentByTagName(parentTagName, childElementObj) {
            var parent = childElementObj.parentNode;
            while (parent.tagName.toLowerCase() != parentTagName.toLowerCase()) {
                parent = parent.parentNode;
               
            }
            return parent;
        }


        function initialize() {
            var latlng = new google.maps.LatLng(-34.397, -100.64);
            var options =
        {
            zoom: 6,
            center: new google.maps.LatLng(27.09, 90.71),
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControl: true,
            mapTypeControlOptions:
            {
                style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
                poistion: google.maps.ControlPosition.TOP_RIGHT,
                mapTypeIds: [google.maps.MapTypeId.ROADMAP, google.maps.MapTypeId.TERRAIN, google.maps.MapTypeId.HYBRID, google.maps.MapTypeId.SATELLITE]
            },
            navigationControl: true,
            navigationControlOptions:
            {
                style: google.maps.NavigationControlStyle.ZOOM_PAN
            },
            scaleControl: true,
            disableDoubleClickZoom: true,
            streetViewControl: true,
            draggableCursor: 'move'
        };
            var gmap = new google.maps.Map(document.getElementById("gmapdiv"), options);
        }
        window.onload = initialize;

    </script>
    

    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopup" Style="display:none; z-index: 999999 !important;">
        <div class="pageloading">
            <p>
                Please wait ... . .
            </p>
        </div>
    </asp:Panel>
    <asp:ModalPopupExtender ID="mpeLoading" runat="server" TargetControlID="pnlPopup"
        PopupControlID="pnlPopup" BackgroundCssClass="modal_bg" />

    <table id="data_content" cellpadding="5px" cellspacing="5px" border="0" style="height:100%;">
        <tr>
            <td id="tdLeftPanel" class="left_panel">
                <div>
                    <%--<div class="mapHeader"><div class="mapTitle">Map Layers</div></div>--%>
                    <div class="maplayHeadern"><div class="docTitlelay">Layers</div></div>
                    <div id="divLeftPanelMapInfo" class="left_panel_map_info">
                        <asp:UpdatePanel ID="uptvMapLayers" runat="server" UpdateMode="Conditional">
                             <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="myMap" />
                                    <asp:AsyncPostBackTrigger ControlID="myMapLocator" />
                                    
                                </Triggers>
                            <ContentTemplate>
                                <asp:TreeView ID="tvMapLayers" runat="server" ShowCheckBoxes="Leaf" ShowLines="True"
                                    OnClick="postBackOnCheck(event)" OnTreeNodeCheckChanged="tvMapLayers_TreeNodeCheckChanged">
                                    <RootNodeStyle Font-Bold="True" Font-Size="9.5pt" ForeColor="#079ed7" />
                                </asp:TreeView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        
                        
                        
                        

                        <div style="height: 10px;"></div>
                       

                        <div class="tblheadcegis" style="margin-top:0;">
                            Year </div>
                              
                        <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlyear" runat="server" CssClass="ddList" BackColor="#D4F6FB"  Width="100%"  Font-Names="Trebuchet MS, Arial, Times New Roman, system" Font-Size="10pt" ForeColor="#072358"      >
                                                
                                </asp:DropDownList>
                                

                            </ContentTemplate>
                          <%--  <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="rbTheme"/> 
                                <asp:AsyncPostBackTrigger ControlID="rbDiv"/>

                            </Triggers>--%>
                            

                        </asp:UpdatePanel>
                        
                        
                        
                        
                        
                        
                        <div style="height: 10px;"></div>
                       

                        <div class="tblheadcegis" style="margin-top:0;">
                            Month </div>
                              
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlmonth" runat="server" CssClass="ddList" BackColor="#D4F6FB"  Width="100%"  Font-Names="Trebuchet MS, Arial, Times New Roman, system" Font-Size="10pt" ForeColor="#072358"     >
                                                
                                </asp:DropDownList>
                                

                            </ContentTemplate>
                            <%--  <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="rbTheme"/> 
                                <asp:AsyncPostBackTrigger ControlID="rbDiv"/>

                            </Triggers>--%>
                            

                        </asp:UpdatePanel>

                        

                        
                        



                        <div class="tvdtsrc">
                            <asp:UpdatePanel ID="upMapLayersInfo" runat="server" UpdateMode="Conditional">
                                <%-- Class="tvdtsrc"--%>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnMapClear" EventName="Click" />
                                   <%--  <asp:AsyncPostBackTrigger ControlID="myMap" />--%>
                                </Triggers>
                                <ContentTemplate>
                                    <script type="text/javascript">
                                        function pageLoad() {
                                            $("#treeBtn").click(function () {
                                                if ($(this).prop('class') === "treeClp") {
                                                    $(this).prop('class', "treeExp");
                                                    $("#tree").hide(230);
                                                } else {
                                                    $(this).prop('class', "treeClp");
                                                    $("#tree").show(230);
                                                }
                                            });
                                        }
                                    </script>
                                    <div id="treeBtn" class="treeClp" style="width: auto; height: auto; padding-left: 17px;
                                        font-size: 9.5pt; color: #079ed7;">
                                        <strong>Drought(SPI) Analysis</strong></div>
                                    <div id="tree" style="padding-left: 17px;">
                                        <asp:Table ID="tblMapActiveLayers" runat="server" Style="background-color: #f5f7fa;"
                                            BorderWidth="0" GridLines="Horizontal">
                                        </asp:Table>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <asp:UpdatePanel ID="upMapOptions" runat="server" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnMapClear" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="btnMapFilterDone" EventName="Click" />
                                </Triggers>
                                <ContentTemplate>
                                    <script type="text/javascript">
                                        function pageLoad() {
                                            $("#divMapFilter").css({ maxHeight: ($("#tdLeftPanel").height() - ($("#divLeftPanelMapInfo").height() - $("#divMapFilter").height() - 150)) + 'px' });
                                        }
                                    </script>
                                    <div id="divMapFilterInfo" runat="server" Visible="False">
                                       <%-- <strong>Map Filter:</strong>--%>
                                        <div id="divMapFilter" style="border: 1px solid #ddd; max-height: 240px; margin: 0;
                                            padding: 0; overflow: auto; background-color: #fff;">
                                            <asp:TreeView ID="tvFilterOptions" runat="server" visible="False" ShowCheckBoxes="All" ForeColor="#232428"
                                                Font-Size="9.25pt" OnClick="OnTreeClick(event)"  OnTreeNodePopulate="tvFilterOptions_TreeNodePopulate">
                                            </asp:TreeView>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <asp:Button ID="btnMapFilterDone" runat="server" Text="Go >>" OnClick="btnMapFilterDone_Click"
                                CssClass="mybtns sbtns" Style="float: right; margin-top: 5px; padding: 2px 5px;" />
                        </div>
                    </div>

                    <hr style="border-width:1px; border-style:solid; border-color:#BDBDBD #FFFFFF #FFFFFF #FFFFFF; margin:5px 0; clear:both;" />
                <asp:UpdatePanel ID="upMapButtons" runat="server" UpdateMode="Conditional">
                    
                       <Triggers>
                          <asp:AsyncPostBackTrigger ControlID="tvMapLayers" EventName="TreeNodeCheckChanged" />
                          <asp:AsyncPostBackTrigger ControlID="tvFilterOptions"  />
                        
                    </Triggers>
                    <ContentTemplate>
                        <asp:Button ID="btnMapClear" runat="server" CssClass="mybtns" Text="Clear Map" 
                                Style="width:85px; float:right; margin:5px; padding:3px 5px;" OnClick="btnMapClear_Click" />
                      
                     <%--   <asp:Button ID="zlButton" Visible="true" runat="server" Text="Add Layer" 
                            onclick="zlButton_Click" />
                            
                            <asp:Button ID="Button1" Visible="true" runat="server" Text="Remove Layer" 
                            onclick="zlButton_Click1" />--%>
                            


                        <%--<asp:Button ID="btnMapFilterDone" runat="server" CssClass="mybtns" Text="Go >>"
                                Style="width:85px; float:right; margin:5px; padding:3px 5px;" OnClick="btnMapFilterDone_Click" />--%>
                    </ContentTemplate>
                </asp:UpdatePanel>

                </div>            
            </td>
            <td class="data_panel">
                <table cellpadding="0" cellspacing="0" style="border:0 none; width:100%; height:100%; margin:0; padding:0; font-size:9.25pt;">
                    <tr>
                        <td colspan="3" class="map_top_td">
                            <table cellpadding="3" cellspacing="1" style="width:100%; margin:0; padding:0; line-height:1;">
                                <tr>
                                    <td style="width:85px; text-align:center;">
                                        <asp:CheckBox ID="cbLegend" runat="server" TextAlign="Left" Text="Legend" Checked="False" Style="padding: 1px 5px;" OnClick="$('.trLegend').css('display', this.checked?'':'none');" />
                                    </td>
                                    <td style="width:60px; text-align:left;">
                                        <asp:CheckBox ID="cbLabel" runat="server" TextAlign="Left" Text="Label" Checked="False" AutoPostBack="True" OnCheckedChanged="cbLabel_CheckedChanged" />
                                    </td>
                                    <td style="width:85px; text-align:left;">
                                        <asp:CheckBox ID="cbFillColor" runat="server" TextAlign="Left" Text="FillColor" Checked="True" AutoPostBack="True" OnCheckedChanged="cbFillColor_CheckedChanged" />
                                    </td>
                                    <td style="margin:0; padding:0; vertical-align:bottom; line-height:1;">
                                        <asp:ImageButton ID="zoomFull" runat="server" ImageUrl="Resources/images/full_extent_m3.png"
                                            BorderStyle="Outset" BorderWidth="1px" ToolTip="Zoom All" BorderColor="White"
                                            OnClick="zoomFull_Click" />
                                        <aspmap:MapToolButton ID="zoomInTool" runat="server" ImageUrl="Resources/images/zoom_in_m.png"
                                            Map="myMap" ToolTip="Zoom In" Argument="" BorderColor="White" BorderStyle="Outset"
                                            BorderWidth="1px" MapCursor="" MapTool="ZoomIn" SelectedBorderStyle="Inset" SelectedImageUrl="" />
                                        <aspmap:MapToolButton ID="zoomOutTool" runat="server" ImageUrl="Resources/images/zoom_out_m.png"
                                            ToolTip="Zoom Out" Map="myMap" MapTool="ZoomOut" Argument="" BorderColor="White"
                                            BorderStyle="Outset" BorderWidth="1px" MapCursor="" SelectedBorderStyle="Inset"
                                            SelectedImageUrl="" />
                                        <aspmap:MapToolButton ID="panTool" runat="server" ImageUrl="Resources/images/pan_1.png"
                                            ToolTip="Pan" Map="myMap" MapTool="Pan" Argument="" BorderColor="White" BorderStyle="Outset"
                                            BorderWidth="1px" MapCursor="" SelectedBorderStyle="Inset" SelectedImageUrl="" />
                                        <aspmap:MapToolButton ID="centerTool" runat="server" ImageUrl="Resources/images/center.png"
                                            ToolTip="Center" Map="myMap" MapTool="Center" Argument="" BorderColor="White"
                                            BorderStyle="Outset" BorderWidth="1px" MapCursor="" SelectedBorderStyle="Inset"
                                            SelectedImageUrl="" />
                                        <aspmap:MapToolButton ID="distanceTool" runat="server" ImageUrl="Resources/images/ruler.png"
                                            Map="myMap" MapTool="Distance" ToolTip="Measure Distance" Argument="" BorderColor="White"
                                            BorderStyle="Outset" BorderWidth="1px" MapCursor="" SelectedBorderStyle="Inset"
                                            SelectedImageUrl="" />
                                       <%-- <aspmap:MapToolButton ID="infoTool" runat="server" ImageUrl="Resources/images/info.gif"
                                            ToolTip="Identify" Map="myMap" MapTool="Info" Argument="" BorderColor="White"
                                            BorderStyle="Outset" BorderWidth="1px" MapCursor="" SelectedBorderStyle="Inset"
                                            SelectedImageUrl="" />--%>
                                        &nbsp;
                                        <aspmap:MapToolButton ID="infoWindowTool" runat="server" ImageUrl="Resources/images/identify.png"
                                            ToolTip="Info Window" Map="myMap" MapTool="InfoWindow" Argument="" BorderColor="White"
                                            BorderStyle="Outset" BorderWidth="1px" MapCursor="" SelectedBorderStyle="Inset"
                                            SelectedImageUrl="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="map_center_td">
                            <asp:UpdatePanel ID="upMapContent" runat="server" class="map_center_panel">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="myMapLocator" />
                                    <asp:AsyncPostBackTrigger ControlID="zoomFull" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="cbLegend" EventName="CheckedChanged" />
                                    <asp:AsyncPostBackTrigger ControlID="cbLabel" EventName="CheckedChanged" />
                                    <asp:AsyncPostBackTrigger ControlID="cbFillColor" EventName="CheckedChanged" />
                                    <asp:AsyncPostBackTrigger ControlID="btnMapClear" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="btnMapFilterDone" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="tvMapLayers" EventName="TreeNodeCheckChanged" />
                                </Triggers>
                                <ContentTemplate>
                                    <aspmap:Map ID="myMap" runat="server"  EnableSession="True"  
                                        ImageFormat="Png" ImageOpacity="0.87"  HotspotPostBack="False"  ImageQuality="87" FontQuality="ClearType" Width="100%" Height="100%" SmoothingMode="AntiAlias"
                                        OnInfoTool="map_InfoTool" OnInfoWindowTool="map_InfoWindowTool" /> 
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    <%--    ImageFormat="Png" ImageOpacity="0.87"  HotspotPostBack="False"  ImageQuality="87" FontQuality="ClearType" Width="100%" Height="100%" SmoothingMode="AntiAlias"--%>
                        <td class="map_right_td">
                            <div class="map_right_panel">
                              <%--  <strong style="clear:both; margin-top:25px;">Map Locator:</strong>--%>
                                
                                <div class="maplayHeadern"><div class="maptoolbar">Map Locator</div></div>

                                <div style="border:1px solid #E3E3E3; width:170px; height:175px; margin:0 auto; padding:0;">
                                    <asp:UpdatePanel ID="upMapLocator" runat="server">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="myMap" />
                                            <asp:AsyncPostBackTrigger ControlID="zoomFull" />
                                          
                                        </Triggers>
                                        <ContentTemplate>
                                            <aspmap:Map ID="myMapLocator" runat="server" Width="170px" Height="175px" 
                                                BorderStyle="None" BorderWidth="0" BackColor="#d7ebf2" ImageFormat="Gif" 
                                                SmoothingMode="None" FontQuality="ClearType" EnableSession="True"
                                                ClientScript="NoScript" MapTool="Point" OnPointTool="mapLocator_PointTool" />
                                                
                                                

                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                     <%--<div id ="gmapdiv" style="height: 500px; width: 768px; vertical-align: top; horiz-align:center  ">
                                     </div>--%>

                                </div>
                                
                                

                                <aspmap:ZoomBar ID="ZoomBar1" Visible="True" runat="server"  Map="myMap" Enabled="True" ClientIDMode="AutoID"  ShowLevels="True" Position="TopLeft" ButtonStyle="Flat" />
                         <%--    <div style="display:none;">--%>
                        <div >
                                <hr style="border-width:1px; border-style:solid; border-color:#BDBDBD #FFFFFF #FFFFFF #FFFFFF; margin:5px 0; clear:both;" />
                            <div class="maplayHeadern"><div class="docTitlegm">Google Map</div></div>
                             <%--   <strong>Google Map</strong>--%>
                                <table cellspacing="7" cellpadding="5" style="border:1px solid #ddd; width:100%; margin:0; padding:0; text-align:left; background-color:#fff;">
                                   <%-- <tr>
                                        <td>
                                            <asp:CheckBox ID="chkGeomap" Visible="True" runat="server" AutoPostBack="True" Text="Google Map" 
                                                OnCheckedChanged="chkGeomap_CheckedChanged" />
                                        </td>
                                        <td>
                                        </td>
                                    </tr>--%>
                                    
                                    <tr>
                                        <td>
                                          
                                            
                                           
                                            <%--<asp:Label ID="GoogleMapLbl" runat="server"  Text=""></asp:Label>  --%>
                                
                                        </td>
                                        <td>
                                            
<%--                                            <asp:DropDownList ID="ActiveLayddl" Width="160px" CssClass="btn btn-default btn-sm" data-style="btn-info" AutoPostBack="True" runat="server" OnSelectedIndexChanged="ActiveLayddl_SelectedIndexChanged"></asp:DropDownList>--%>

                                            <asp:DropDownList ID="GoogleMapddl" runat="server" style="border: 1px solid #adadad;" Width="160px" Height="25px"
                                            AutoPostBack="True" Font-Names="Trebuchet MS, Arial, Times New Roman, system" BackColor="#D4F6FB"
                                                            Font-Size="9pt" onselectedindexchanged="GoogleMapddl_SelectedIndexChanged"  >
                                         
                                          
                                            <asp:ListItem text="Normal" value="Normal" />
                                            <asp:ListItem text="Satellite" value="Satellite" />
                                            <asp:ListItem text="Hybrid" value="Hybrid" />
                                            <asp:ListItem text="Physical" value="Physical" />
                                            <asp:ListItem text="No Map" value="NoGoogleMap" />
                                             </asp:DropDownList> 

                                        </td>

                                    </tr>


                                   <%-- <tr>
                                        <td>
                                            <asp:CheckBox ID="cbGM_Normal" Visible="True" CssClass="cb_gm" runat="server" AutoPostBack="True" Text="Normal" 
                                               OnCheckedChanged="chkGeomap_CheckedChanged" />
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="cbGM_Physical" Visible="True" CssClass="cb_gm" runat="server" AutoPostBack="True" Text="Physical" 
                                               OnCheckedChanged="chkGeomap_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:CheckBox ID="cbGM_Satellite" Visible="True" CssClass="cb_gm" runat="server" AutoPostBack="True" Text="Satellite" 
                                               OnCheckedChanged="chkGeomap_CheckedChanged" />
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="cbGM_Hybrid" Visible="True" CssClass="cb_gm" runat="server" AutoPostBack="True" Text="Hybrid" 
                                                OnCheckedChanged="chkGeomap_CheckedChanged" />
                                        </td>
                                    </tr>--%>
                                </table>
                                </div>
                                

                                <hr style="border-width:1px; border-style:solid; border-color:#BDBDBD #FFFFFF #FFFFFF #FFFFFF; margin:5px 0; clear:both;" />
                                
                                <asp:UpdatePanel ID="upMapData" runat="server">
                                    <ContentTemplate>
                                        <div style="border:1px solid #AFAFAF; width:175px; margin:10px auto; padding:0; overflow:auto;">
                                            <asp:DataGrid ID="dataGrid" runat="server" HorizontalAlign="Center" BackColor="#E5E5E5">
                                            </asp:DataGrid>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    

</asp:Content>
