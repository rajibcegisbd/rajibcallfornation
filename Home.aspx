<%@ Page Title="COVID-19 ::. Home" Language="C#" MasterPageFile="~/MyMaster.master" %>

<script runat="server">
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;
        try
        {
            var masterPage = this.Master;
            if (masterPage != null)
            {
                try
                {
                    ((Label)masterPage.FindControl("pagetitle")).Text = "Home";
                    ((HtmlGenericControl)masterPage.FindControl("A1")).Attributes.Add("Class", "current");
                }
                catch
                {
                }
            }
        }
        catch
        {
        }
    }

</script>

<asp:Content ID="contentHead" ContentPlaceHolderID="HeadContent" Runat="Server">
    
    <script type="text/javascript" language="javascript">

        function SetMapHeight() {
            var wHeight = $(window).height() - 250;
            if ($('#homeInfo').height() < wHeight)
                $('#homeInfo').css('height', wHeight);
        }

        $(document).ready(function() {
            SetMapHeight();
        });

    </script>

    <style type="text/css">
    
        .homeInfo
        {
            margin: 0 auto;
            padding: 15px;
            width: auto;
            height: auto;
        }
    
        .homeInfo .prjInfo 
        {
            margin: 0;
            padding: 10px 5px;
            min-height: 345px;
            background-color: #fff;
        }
    
        .homeInfo .prjInfo  p 
        {
            margin: 0;
            padding: 5px 10px;
	        font: normal 12.25pt/1.25 Calibri, Verdana, Helvetica, Arial, sans-serif;
            text-align: justify;
        } 

        
    
    </style>

</asp:Content>
<asp:Content ID="contentHome" ContentPlaceHolderID="DataContent" Runat="Server">
    <div id="homeInfo" class="homeInfo">
        <div class="prjInfo">
            
            <p>
                Bangladesh is not new to disasters or major humanitarian crises. Sitting astride a river delta at the bottom of the Himalayan range, the country is fighting a longstanding battle against the impact of climate change and currently hosts the world’s largest refugee camp along its southern border. In its 49-year existence, Bangladesh and its people have shown tremendous resilience in fending off not only natural disasters such as floods and cyclones but also manmade ones, like the 1997 Asian financial crisis and 2008 global financial crisis. 
            </p>

            <p>
              The COVID-19 pandemic, however, is a crisis of a completely different magnitude and one that will require a response of unprecedented scale. Bangladesh’s leaders in the public and private sector must come together to respond to the immediate threats to health systems and the long-term effects to the country’s economy. 
            </p>

            <p>
                

Bangladesh detected its first confirmed coronavirus case on 8 March. As of this writing, the number of confirmed cases in Bangladesh is more than 620, and the virus has claimed more than 30 lives.

               
                
            </p>
            <p>
                In early February, the government evacuated close to 300 Bangladeshi citizens from China. The government also installed screening devices across its international airports and land-ports, which have so far screened more than 650,000 passengers, of which 37,000 were immediately quarantined. 
            </p>
            
          
            <p>
                The government also moved swiftly to transform two religious centers into temporary quarantine facilities. In addition, after the first case was detected, the government closed education institutions and encouraged all non-essential businesses to move their activities online. It initially declared a nationwide public holiday until April 4 which has been subsequently extended to April 14. 
            </p>

            <table style="width:100%; margin:0 auto; padding:8px; font-weight:bold; font-size:9.25pt;" cellpadding="8" cellspacing="8">
                <tr>
                    <td style="width:50%;">
                       
                        <img width="100%" src="Photos/coronabd.jpg" alt=""/>
                    </td>
                    <td  style="width:50%;">
                        <img width="100%" src="Photos/Garments_Covid.jpeg" alt="" /> 

<%--                        <img  width="100%" src="Photos/drought2.png" alt="Drought Stressed Crops"/> --%>


                    </td>
                </tr>
                <tr>
                    <td>Figure 1 : Bangladesh Corona Status</td>
                    <td>Figure 2 : Corona Virus impact on Economy</td>
                    </tr>
               <%-- <tr>
                    <td>
                        <img  width="100%" src="Photos/drought3.png" alt="Water-saving irrigation of a maize crop using raised beds, in Southern Bangladesh"/>
                    </td>
                    <td  style="width:53%;" >
                        <img  width="100%" src="Photos/drought2.png" alt="STARS researchers flying the octocopter in Barisal, Bangladesh"/>
                    </td>

                </tr>
                <tr>
                    <td>Severely drought-stressed corn</td>
                    <td>drought stressed crops down </td>
                </tr>--%>
            </table>
            
        </div>
    </div>
</asp:Content>

