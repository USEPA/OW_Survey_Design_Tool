source("global.R")
addResourcePath(prefix = 'www', directoryPath = './www')

ui <- div(fixedPage(theme=bs_theme(version=3, bootswatch="yeti"), 
                    tags$html(class = "no-js", lang="en"),
                    useShinyjs(),
                    tags$head(
                      tags$title('Survey Design Tool | US EPA'),
                      tags$style(
                        #Controls tabsetPanel display
                        HTML(".nav:not(.nav-hidden) {display: block !important;}
                           .dataTables_scrollBody {transform:rotateX(180deg);}
                           .dataTables_scrollBody table {transform:rotateX(180deg);}
                           .has-feedback .form-control {padding-right: 0px;}
                           ")),
                      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
                      includeHTML("www/header.html")
                      ),
	####Instructions####
	# Application title 
	titlePanel(span("Survey Design Tool (v. 2.0.0)", 
	                style = "font-weight: bold; font-size: 28px")),
	navbarPage(id = "inTabset", 
	           title = "",
	           selected='instructions', position='static-top',
	           inverse = TRUE,
	           # Panel with instructions for using this tool
	           tabPanel(title=span(strong("Step 1: Instructions for Use"), 
	                               style = "font-weight: bold; font-size: 17px"), value='instructions',
	                    bsCollapse(id = "instructions",   
	                               bsCollapsePanel(title = h1(strong("Overview")), value="Overview",
	                                               p("This application allows for the calculation of spatially balanced survey designs of point, linear, or areal resources using the Generalized Random-Tessellation Stratified (GRTS) algorithm,", tags$a(href= "https://cfpub.epa.gov/ncer_abstracts/index.cfm/fuseaction/display.files/fileID/13339", "Stevens and Olsen (2004).", target="blank"), 
	                                                 "The Survey Design Tool utilizes functions found within the R package", tags$a(href="https://cran.r-project.org/package=spsurvey", "spsurvey: Spatial Sampling Design and Analysis", target="blank"), "and presents an easy-to-use user interface for many sampling design features including stratification, unequal and proportional inclusion probabilities, replacement (oversample) sites, and legacy (historical) sites. 
                                      The output of the Survey Design Tool contains sites designed and balanced by user specified inputs and allows the user to export sampling locations as a point shapefile or a flat file. The output also provides design weights which can be used in categorical and continuous variable analyses (i.e., population estimates). 
                                      The tool also gives the user the ability to adjust initial survey design weights when implementation results in the use of replacement sites or when it is desired to have final weights sum to a known frame size."), 
                                      
                                      p("This app does not include all possible design options and tools found in the spsurvey package. Please review the package", tags$a(href= "https://www.rdocumentation.org/packages/spsurvey", "Documentation", target="blank"), "and", tags$a(href= "https://github.com/USEPA/spsurvey", "Vignettes", target="blank"), "for more options and details.  
                                      For further survey discussion and use cases, visit the website for", tags$a(href="https://www.epa.gov/national-aquatic-resource-surveys", "EPAs National Aquatic Resource Surveys (NARS)", target="blank"), 
                                      "which are designed to assess the quality of the nation's coastal waters, lakes and reservoirs, rivers and streams, and wetlands using GRTS survey designs. We encourage users to consult with a statistician about your design to prevent design issues and errors."),
                                      p("For Survey Design Tool questions, bugs, feedback, or tool modification suggestions, please contact Garrett Stillings at", tags$a(href="mailto:stillings.garrett@epa.gov", "stillings.garrett@epa.gov.", target="blank"),
                                        "The application code and test datasets are offered at the", tags$a(href="https://github.com/USEPA/OW_Survey_Design_Tool", "Survey Design Tool GitHub page.", target="blank"), 
                                        "For statistical survey design and analysis, and other technical questions, please contact Michael Dumelle at", tags$a(href="mailto:dumelle.michael@epa.gov", "dumelle.michael@epa.gov.", target="blank")),
                                      h4(strong("Vignette")),
                                      h4(strong(tags$ul(
                                        tags$li(tags$a(href="https://cran.r-project.org/web/packages/spsurvey/vignettes/sampling.html",
                                                       "Spatially Balanced Sampling", target="blank")))))),
	                               bsCollapsePanel(title = h3(strong("Prepare Survey Design Tab")), value="prepare",
	                                               tags$ol(
	                                                 h4(strong("Requirements")),
	                                                 tags$ul(
	                                                   tags$li("The Survey Design Tool located on the EPA shiny server is only capable of running designs which use less than 2GB of memory. Please visit the Survey Design Tool GitHub site for the source code to run the app locally for much improved processing."),
	                                                   tags$li("The coordinate reference system (CRS) for the sample frame should use an area-preserving projection such as Albers or UTM so that spatial distances are equivalent for all directions. Geographic CRS are not accepted."),
	                                                   tags$li("All design attribute variables, such as the Strata and Categories, must be contained in the user's sample frame file. You may run the design without these inputs as an unstratified equal probability design."),
	                                                   tags$li("When constructing your design, the user must decide how they want their survey to be designed and which random selection to use:"),
	                                                   tags$ul(
	                                                     tags$li(strong("Equal Probability Sampling")," - equal inclusion probability. Selection where all units of the population have the same probability of being selected."),
	                                                     tags$li(strong("Stratified Sampling")," - Selection where the sample frame is divided into non-overlapping strata which independent random samples are calculated."),
	                                                     tags$li(strong("Unequal Probability Sampling")," - unequal inclusion probability. Selection where the chance of being included is calculated relative to the distribution of a categorical variable across the population which does not guarantee a user specified sample size. This type of sampling can give smaller populations a greater chance of being selected."), 
	                                                     tags$li(strong("Proportional Probability Sampling")," - proportional inclusion probability. Selection where the chance of being included is proportional to the values of a positive auxiliary variable. For example, if you have many strata in your design, this will ensure each stratum has a sample."))),
	                                                 br(),
	                                                 bsCollapsePanel(title = h4(strong("Designing the Survey")), value="design",
	                                                                 tags$li("Select the Sample Frame. Sample frames must be an ESRI shapefile. The user must select all parts of the shapefiles which include .shp, .dbf, .shx. and .prj files (Tip: Hold down ctrl and select each file). The coordinate system for the sample frame must be one where distance for the coordinates is meaningful. The attributes in the file will populate as possible inputs for the design. Maximum size is currently 10GB."),
	                                                                 tags$li("Choose your desired Design Type:",
	                                                                         tags$ul(
	                                                                           tags$li(strong("GRTS")," - Generalized Random Tessellation Stratified. For survey designs desiring spatially balanced samples."),
	                                                                           tags$li(strong("IRS")," - Independent Random Sample. For survey designs desiring non-spatially balanced samples."))),
	                                                                 tags$li("Select Strata attribute. If your design is stratified, select the attribute which indicates the desired Strata. If Stratum equals 'None', the design is unstratified. The default is 'None'. Example Strata could be Stream Type (Perennial and Intermittent) or Size (Large and Small)."),
	                                                                 tags$li("Select Category attribute. For an unequal inclusion probability design, select the attribute which indicates the categorical variable which the selection will be based on. Often, the output Category sample sizes will be close, but not exact to the user's sample sizes allocated for each Category. This is because the Category-level sample sizes are random variables. The default is 'None'. An example Category could be stream order or elevation (high/low)."),
	                                                                 br(),
	                                                                 h4(strong(em("Optional: Additional Design Attributes"))),
	                                                                 tags$ul(
	                                                                   tags$li("Additional design attributes such as Auxiliary Variables, Reproducible Seed, DesignID, Minimum Distance, Maximum Attempts, Point Density, and Nearest Neighbor Replacement Sites are also available. Descriptions of these inputs can be found in the grts section on the spsurvey manual as well as the helper buttons next to the inputs."),
	                                                                   br(),
	                                                                   h4(strong(em("Legacy Sampling"))),
	                                                                   tags$li("Legacy sites are sites that have been selected in a previous probability sample and are to be automatically included in the current probability sample."),
	                                                                   tags$li("Upload a POINT sample frame which contains the Legacy sites you would like included in the design. All sites in the legacy file will be considered legacy sites."),
	                                                                   tags$li("If your Legacy sample frame has different Strata, Category or Auxiliary variable names than your design sample frame, select the corresponding attribute(s) from the legacy sample frame. These inputs will not appear if the names match your design sample frame."),
	                                                                   tags$li("The number of legacy sites must be greater than number of base sites in at least one stratum.")
	                                                                 ))),
	                                               tags$ol(
	                                                 bsCollapsePanel(title = h4(strong("Determine Survey Sample Sizes")), value="samplesize",
	                                                                 p("Setting an appropriate sample size and considering how they should be allocated across a sample frame is a fundamental step in designing a successful survey. Many surveys, especially those used for environmental monitoring, are limited by budgetary and logistical constraints. The designer must determine a sample size which can overcome these constraints while ensuring the survey estimates the parameter(s) of interest with a low margin of error.
                                                                      The designer can consider a few elements when determining a survey sample size:"),
	                                                                 tags$ul(
	                                                                   tags$li("Select a spatially balanced survey using the spatial balance metrics provided. Typically, estimates from spatially balanced surveys are more precise (vary less) than estimates from non-spatially balanced surveys."),
	                                                                   tags$li("Consider what will be measured in the survey. If you anticipate the parameter of interest to result in low variation across the survey, a smaller sample size can yield a low margin of error estimate. Conversely, if you anticipate the parameter of interest to result in high variation, you should consider increasing the sample size to account for a higher margin of error."),
	                                                                   tags$li("Allocate additional sampling time to survey extra sites if needed. When designing the survey, be sure to generate replacement sites to use for oversampling.")),
	                                                                 br(),
	                                                                 p("To aid the user, in the 'Survey Design tab' simulated population estimates using the local neighborhood variance estimator (uses a site's nearest neighbors to estimate variance, tending to result in smaller 
                                         variance values) and will be calculated using the users defined sample sizes. This can give the user insight on the survey estimates potential margin of error if the sample size(s) chosen is used."),
                                         tags$li("For unstratified equal probability designs, set the desired Base site sample size."),
                                         tags$li("If you supplied a Stratum attribute, a tab is populated for each Stratum of the design."),
                                         tags$li("Set the sample size of Base sites you desire for each stratum."),
                                         tags$li("If you supplied a Category attribute, these categories will automatically populate. Choose the sample sizes for each. NOTICE: the sum of the sample sizes must equal the base site sample size."),
                                         tags$li("Choose the sample size of the Replacement Sites you desire, if any. Replacement sites are an additional set of sites that can be used to replace the main sample list sites when they are found to be non-target or inaccessible. When replacing a site with a replacement, the user must FOLLOW THE ORDER of the design output and select a replacement site of the same Stratum, if used. If replacement sites are used improperly it may result in spatial imbalance. 
                                              The tool attempts to distribute the replacement sites proportionately among sample sizes for the Categories. If the replacement proportion for one or more Categories is not a whole number, the proportion is rounded to the next higher integer. Choose a reasonable replacment sample size as requesting too many unused sites can impact the spatial balance of your design."),
                                         tags$li("Once your design has been prepared, click the 'Calculate Survey Design' button to be transported to the Survey Design Results tab.")
	                                                 ))),
	                               bsCollapsePanel(title = h3(strong("Survey Design Results Tab")), value="survey",
	                                               tags$ol(
	                                                 h4(strong("Survey Design")),
	                                                 tags$li("The process of calculating your Survey Design can take a while. The spinner will stop when your Survey Design is complete. If you have errors in your Design inputs, a message with the error will be displayed under 'Design Errors'. "),
	                                                 tags$li("A table of your Survey Design will appear if successful. A table will be displayed with totals of your sample sizes allocated across strata and categories, if used."),
	                                                 tags$li("The Population Estimate Simulation module can give the user insight on the survey estimates potential margin of error if the input sample size(s) are used. Condition classes assigned to each site are randomly selected using user specified probability weights. Typically, margin of error will decrease if the condition class distribution is unequally distributed.
                                                            The user can choose the number of condition classes used, modify the probability of being selected, and refresh the simulation to view different condition scenarios. The user can adjust the sample size and refresh the design to determine an appropriate margin of error for the survey."),
	                                                 tags$li("Choose a Spatial Balance Metric. All spatial balance metrics provided have a lower bound of zero, which indicates perfect spatial balance. As the metric value increases, the spatial balance decreases. This is useful in comparing survey designs."),
	                                                 tags$li("Click the 'Download Survey Design' button to download a zip file which contains a POINT shapefile of your designs survey sample sites, the users sample frame, and README which includes information about your design."),
	                                                 tags$li("A table of the users Probability Survey Site Results is presented for review. Please note the Lat/Longs are transformed to WGS84 coordinate system. The xcoord and ycoord are Conus Albers (a projected CRS) coordinates which is an area-preserving projection. These coordinates can be used for the local neighborhood variance estimator when calculating population estimates."),
	                                                 br(),
	                                                 h4(strong("Survey Map")),
	                                                 tags$li("The Survey Map tab provides an interactive and static map of the sample frame and the survey sample sites.")
	                                               )),
	                               bsCollapsePanel(title = h3(strong("Adjust Survey Weights Tab")), value="adjust",
	                                               p("Adjusting initial survey design weights is necessary when implementation results in the use of replacement sites or when it is desired to have final weights sum to known frame size of the desired population. This includes samples that are smaller or larger than planned, instances where an oversample is used, or samples impacted by frame error or nonresponse error. Adjusted weights are equal to initial weight * framesize/sum(initial weights). The adjustment is done separately for each 
                                                    Category specified in Weighting Category input. The tool allows the user to manually enter a desired population Frame Size or an automated calculation of the frame size by totaling the initial weights and adjusting it by the users site Evaluation Status inputs. By using the automated method, the output will render two adjusted weights:"),
	                                               tags$ul(
	                                                 tags$li(strong("WGT_TP_EXTENT")," - Weights based on the evaluation of all target and non-target probability sites. These weights are only used to estimate extent for target and non-target populations."),
	                                                 tags$li(strong("WGT_TP_CORE")," - Weights based on the evaluation of the target population based on sampled probability sites. These weights can be used to estimate condition for the 'target population'. Current NARS population estimates only use WGT_TP_CORE for all estimates related to condition.")
	                                               ),
	                                               p(tags$a(href="https://rdrr.io/cran/spsurvey/man/adjwgt.html", "Weights Adjustment Example", target= "_blank")),
	                                               p(tags$a(href="https://rdrr.io/cran/spsurvey/man/adjwgtNR.html", "Weights Adjustment Example (Non-response)", target= "_blank")),
	                                               tags$ol(
	                                                 h4(strong("Weight Adjustment File Setup Examples")),
	                                                 fixedRow(column(4,
	                                                                 tags$table(border = 5, 
	                                                                            tags$thead(
	                                                                              tags$tr(
	                                                                                tags$th(colspan = 3, height = 10, width = 500,
	                                                                                        style="text-align: center", "Equal Probability Design")
	                                                                              )
	                                                                            ), 
	                                                                            tags$tbody(
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", strong("SiteID")),
	                                                                                tags$td(align = "center", strong("Weight")),
	                                                                                tags$td(align = "center", strong("Site Evaluation")),
	                                                                              ),
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_01"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              ),
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_02"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Non-Target"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_02_Replace"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_03"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Access_Denied"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_03_Replace"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_04"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              )))),
	                                                          column(5, offset = 1,
	                                                                 tags$table(border = 5, 
	                                                                            tags$thead(
	                                                                              tags$tr(
	                                                                                tags$th(colspan = 4, height = 10, width = 500,
	                                                                                        style="text-align: center", "Unequal Probability Design")
	                                                                              )
	                                                                            ), 
	                                                                            tags$tbody(
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", strong("SiteID")),
	                                                                                tags$td(align = "center", strong("Category")),
	                                                                                tags$td(align = "center", strong("Weight")),
	                                                                                tags$td(align = "center", strong("Site Evaluation")),
	                                                                              ),
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_01"),
	                                                                                tags$td(align = "center", "1st Order"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              ),
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_02"),
	                                                                                tags$td(align = "center", "2nd Order"),
	                                                                                tags$td(align = "center", "3"),
	                                                                                tags$td(align = "center", "Non-Target"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_02_Replace"),
	                                                                                tags$td(align = "center", "2nd Order"),
	                                                                                tags$td(align = "center", "3"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_03"),
	                                                                                tags$td(align = "center", "3rd Order"),
	                                                                                tags$td(align = "center", "4"),
	                                                                                tags$td(align = "center", "Access_Denied"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_03_Replace"),
	                                                                                tags$td(align = "center", "3rd Order"),
	                                                                                tags$td(align = "center", "4"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              ), 
	                                                                              tags$tr(
	                                                                                tags$td(align = "center", "Site_04"),
	                                                                                tags$td(align = "center", "1st Order"),
	                                                                                tags$td(align = "center", "2"),
	                                                                                tags$td(align = "center", "Target-Sampled"),
	                                                                              ))))),
	                                                 br(),
	                                                 h4(strong("Weight Adjustment Inputs")),
	                                                 tags$li("Upload the file which contains the required weight adjustment inputs. See below for the descriptions of each input."),
	                                                 tags$li("Select the column which has the initial unadjusted weights for each site."),                                        
	                                                 tags$li("Select the column which contains the Site Evaluation Attributes which categorically evaluate which sites are target-sampled, non-response (not sampled) and non-target (not sampled) sites."),
	                                                 tags$ul(
	                                                   tags$li("Select the attribute(s) which indicate if the site was a Target site (Base and Replacement sites) and has been sampled. If available, this input should include additional Replacement sites which were added to the design and not used as replacement."),
	                                                   tags$li("Select the attribute(s) which indicate if the site was a Non-Response site and was not sampled (e.g. Landowner Denials, Inaccessible, Target-Not Sampled). Non-target sites should NOT be included in this input.")
	                                                 ),
	                                                 tags$li("Select the Weighting Category column. A weight adjustment category represents if a Stratum and/or an Unequal Probability Category was used in the design as implemented. If the design was unequally stratified, this attribute should contain a combination of the stratum and category used (i.e. Stratum-Category). 
                                             The default is all sites are in the same category, which assumes every site is in the same category and an equal probability design is being adjusted."),
                                             tags$li("Input the initial sample frame size(s). Based on if you entered a weighting category, a frame size input for each weight category will be generated."),
                                             tags$li("Press the 'Calculate Adjusted Survey Weights' button for the adjusted weight output.")
	                                               ))),
	                    hr(),
	                    h3(strong('Citation')),
	                    tags$head(
	                      tags$style(
	                        HTML("#citation {font-size: 14px;}"))),
	                    p("If you have used the Survey Design Tool to generate a survey used in publication or reporting, please reference the tool URL (https://owshiny.epa.gov/survey-design-tool/) and cite the spsurvey package."),
	                    verbatimTextOutput("citation"),
	                    br(),hr(),
	                    h3(strong('Disclaimer')),
	                    p('The United States Environmental Protection Agency (EPA) Survey Design tool and code is provided on an "as is" basis and the user assumes responsibility for its use.  
                                      EPA has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information.  
                                      Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their 
                                      endorsement, recommendation or favoring by EPA.  The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity 
                                      by EPA or the United States Government.'),
	                    br(), hr()),
	           
	           ####Prepare Design####
	           # Panel to import and prepare survey design
	           tabPanel(title=span(strong('Step 2: Prepare Survey Design'), 
	                               style = "font-weight: bold; font-size: 17px"), value='Step 2: Prepare Survey Design',
	                    sidebarPanel(
	                      h4(strong(HTML("<center>Select the Survey Sample Frame<center/>"))),
	                      #h5(strong(HTML("<center>Use Your Own Sample Frame<center>"))),
	                      
	                      # Input: Select sample frame files 
	                      fileInput(
	                        inputId = "filemap",
	                        label = HTML("<b>Choose all files of the Sample Frame </br>Required: (.shp, .dbf, .prj, .shx)</b>"),
	                        multiple = TRUE,
	                        accept = c(".gdb", ".shp", ".prj", ".shx", ".dbf", ".sbn", ".sbx", ".cpg", ".gpkg"), 
	                        width = "600px") %>%
	                        #User Sample Frame helper
	                        helper(icon = "circle-question",type = "inline",
	                               title = "Survey Sample Frame",
	                               content = c("A Survey Sample Frame is an ESRI shapefile which contains geographic features represented by points, lines or polygons which is used in the selection of the sample. Maximum sample frame size is currently 10GB.",
	                                           "The coordinate reference system (CRS) for the sample frame should be an area-preserving projection. If a geographic CRS is used, the user may choose to transform the CRS to NAD83 / Conus Albers (a projected CRS) by checking the box below.",
	                                           "<b>Required Files:</b>",
	                                           "<b>Shapefiles (.shp, .dbf, .prj, .shx)</b>"),
	                               
	                               size = "s", easyClose = TRUE, fade = TRUE),
	                      checkboxInput(inputId = "NAD83", 
	                                    label= strong("Transform CRS to NAD83 / Conus Albers"), 
	                                    value = FALSE, 
	                                    width = NULL),
	                      hr(),
	                      h4(strong(HTML("<center>Design Attributes<center/>"))),
	                      fixedRow(
	                        column(6,
	                               #Design Type Input
	                               radioButtons(inputId="designtype", 
	                                            label=strong("Choose Design Type"), 
	                                            choices=c("GRTS","IRS"),
	                                            inline=TRUE) %>%
	                                 #Design Type helper
	                                 helper(icon = "circle-question",type = "inline",
	                                        title = "Design Type",
	                                        content = c("<b>GRTS:</b> Generalized Random Tessellation Stratified-for spatially balanced samples",
	                                                    "<b>IRS:</b> Independent Random Sample- for non-spatially balanced samples"),
	                                        size = "s", easyClose = TRUE, fade = TRUE))),
	                      
	                      #Stratum Input
	                      selectInput(inputId = "stratum",
	                                  label = strong("Select Attribute Which Contains Strata"),
	                                  choices = "",
	                                  selected = NULL,
	                                  multiple = FALSE, 
	                                  width = "300px")  %>%
	                        #Strata helper
	                        helper(icon = "circle-question",type = "inline",
	                               title = "Stratum",
	                               content = c("A subpopulation within your sample frame to independently sample. Use the default <b>None</b> if your design is unstratified.",
	                                           "<b>Examples:</b> Stream Type (Perennial and Intermittent), Size (Large and Small"),
	                               size = "s", easyClose = TRUE, fade = TRUE),
	                      
	                      #Category Input
	                      selectInput(inputId = "caty",
	                                  label = strong("Select Attribute Which Contains Categories"),
	                                  choices = "",
	                                  selected = NULL,
	                                  multiple = FALSE, 
	                                  width = "300px") %>%
	                        #Category helper
	                        helper(icon = "circle-question",type = "inline",
	                               title = "Unequal Probability Category",
	                               content = c("Variables used to define design weights for unequal probability selections. Use the default <b>None</b> if your design is an equal probability design.",
	                                           "<b>Examples:</b> Stream Order, Lake Area, Basin, Ecoregion"),
	                               size = "s", easyClose = TRUE, fade = TRUE),
	                      checkboxInput(inputId = "addoptions", 
	                                    label=strong("Optional Design Attributes"), 
	                                    value = FALSE),
	                      uiOutput('addoptions'),
	                      conditionalPanel(condition = "input.addoptions == 1",
	                                       hr(),
	                                       h4(strong(HTML("<center>Legacy Site Sampling<center/>"))),
	                                       ####Legacy Sampling####
	                                       uiOutput("legacyfile"),
	                                       
	                                       
	                                       uiOutput("legacyvar"),
	                                       
	                                       
	                                       uiOutput('legacystrat'),
	                                       
	                                       uiOutput('legacycat'),
	                                       
	                                       uiOutput('legacyaux')),
	                      
	                      hr(),
	                      
	                      # Press button for analysis 
	                      actionButton("goButton", strong("Calculate Survey Design"), icon=icon("circle-play"), 
	                                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4; font-size:130%")),#sidebarPanel
	                    mainPanel(
	                      uiOutput('mytabs'),
	                      conditionalPanel(condition = "output.mytabs",
	                                       hr(),
	                                       fixedRow(
	                                         column(4,
	                                                checkboxInput(inputId = "addSF_SUM", 
	                                                              label=span(strong("Sample Frame Summary"),
	                                                                         style="font-weight: bold; font-size: 18px"), 
	                                                              value = FALSE) %>%
	                                                  #SF Summary helper
	                                                  helper(icon = "circle-question",type = "inline",
	                                                         title = "Sample Frame Summary",
	                                                         content = c("Aids user in summarizing the sample frame based on the selected Strata and Categories. These proportions can assist in setting sample size(s)."),
	                                                         size = "s", easyClose = TRUE, fade = TRUE)))),
	                      conditionalPanel(condition = "input.addSF_SUM",
	                                       br(),
	                                       fixedRow(
	                                         h3(HTML("<center><b>Sample Frame Summary</b></center>")),
	                                         column(4,
	                                                DT::dataTableOutput("SF_SUM") %>% withSpinner(color="#0275d8"))),
	                                       br(),
	                                       fixedRow(
	                                         conditionalPanel(condition = "output.LEGACY_SUM",
	                                                          h3(HTML("<center><b>Legacy Sample Frame Summary</b></center>"))),
	                                         column(4,
	                                                DT::dataTableOutput("LEGACY_SUM") %>% withSpinner(color="#0275d8")))
	                      )
	                    ) #mainPanel
	           ), #tabPanel (Prepare and Run Survey Design)
	           ####Design Results####
	           tabPanel(title=span(strong("Step 3: Survey Design Results"), 
	                               style = "font-weight: bold; font-size: 17px"),
	                    value="Step 3: Survey Design Results",
	                    conditionalPanel(condition = "input.goButton",
	                                     tagList(span("Remove/Restore Sidebar", style = "font-weight: bold; font-size: 25px; font-style:italic;",
	                                                  actionLink("sidebar_button","", icon = icon("bars")))),
	                                     sidebarLayout(
	                                       div(class="sidebar", 
	                                           sidebarPanel(
	                                             conditionalPanel(condition = "output.error",
	                                                              h4(HTML("<center><b>Design Errors</b></center>"))),
	                                             tableOutput("error"),
	                                             conditionalPanel(condition = "output.table",
	                                                              hr(),                 
	                                                              h4(HTML("<center><b>Survey Site Summary</b></center>")),
	                                                              dataTableOutput("summary"), 
	                                                              style = "overflow-x: scroll;"),
	                                             conditionalPanel(condition = "output.summary",
	                                                              br(), hr(),
	                                                              h4(HTML("<center><b>Population Estimate Simulation</b></center>")) %>%
	                                                                #Simulation helper
	                                                                helper(icon = "circle-question",type = "inline",
	                                                                       title = "Population Estimate Simulation",
	                                                                       content = c("This module assists the user in simulating total population proportion estimates of a population based on the sample size used in the survey design. Error bars displayed show the Margin of Error for a condition.
                                                            The condition classes are randomly assigned by user specified probability weights and can be refreshed with new probability weights to simulate the change in conditions. 
                                                            Adjust the sample size of the design to increase or decrease the Margin of Error estimate."),
                                                            size = "s", easyClose = TRUE, fade = TRUE),
                                                            fixedRow(
                                                              column(6, offset=3,
                                                                     radioButtons(inputId="connumber", 
                                                                                  label=strong("Choose Condition Class Size"), 
                                                                                  choices=c("2","3","4","5"), 
                                                                                  selected = "3",
                                                                                  inline=TRUE) %>%
                                                                       #Condition Class helper
                                                                       helper(icon = "circle-question",type = "inline",
                                                                              title = "Conditional Class Size",
                                                                              content = c("Choose the condition class size of your indicator. Assign random selection probabilities for each condition class to simulate potential population estimate results.
                                                            Indicators with larger condition class sizes often have lower margin of error estimates.",
                                                            "<b>If condition probabilities do not sum to 100%, weights will be normalized to sum to 100%.</b>"),
                                                            size = "s", easyClose = TRUE, fade = TRUE))),
                                                            uiOutput('conditionprb'),
                                                            radioButtons(inputId="conflim", 
                                                                         label=strong("Choose Confidence Limit"), 
                                                                         choices=c("90%","95%"), 
                                                                         selected = "95%",
                                                                         inline=TRUE)),
	                                             conditionalPanel(condition = "input.CON2",
	                                                              plotOutput("ssplot") %>% withSpinner(color="#0275d8"),
	                                                              br(),
	                                                              actionButton("ssbtn", strong("Refresh Simulation"), icon=icon("arrow-rotate-right"), 
	                                                                           style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
	                                             hr(),
	                                             conditionalPanel(condition = "output.ssplot",
	                                                              h4(HTML("<center><b>Design Spatial Balance</b></center>")) %>%
	                                                                #Spatial Balance helper
	                                                                helper(icon = "circle-question",type = "inline",
	                                                                       title = "Spatial Balance",
	                                                                       content = c("All spatial balance metrics have a lower bound of zero, which indicates perfect spatial balance. As the metric value increases, the spatial balance decreases."),
	                                                                       size = "s", easyClose = TRUE, fade = TRUE),
	                                                              tags$head(
	                                                                tags$style(
	                                                                  HTML("#balance {font-size: 14px;}"))),
	                                                              verbatimTextOutput("balance", placeholder = TRUE) %>% withSpinner(color="#0275d8"),
	                                                              actionButton("balancebtn", strong("Calculate Spatial Balance"), icon=icon("circle-play"), 
	                                                                           style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
	                                                              br(), br(),
	                                                              radioButtons("balance", strong("Spatial Balance Metric:"),
	                                                                           selected = "pielou",
	                                                                           c("Pielou's Evenness Index" = "pielou",
	                                                                             "Simpsons Evenness Index" = "simpsons",
	                                                                             "Root-Mean-Squared Error" = "rmse",
	                                                                             "Mean-Squared Error" = "mse",
	                                                                             "Median-Absolute Error" = "mae",
	                                                                             "Mean-Absolute Error" = "medae",
	                                                                             "Chi-Squared Loss" = "chisq")) %>%
	                                                                #Spatial Balance metric helper
	                                                                helper(icon = "circle-question",type = "inline",
	                                                                       title = "Spatial Balance Metrics",
	                                                                       content = c("<b>Pielou's Evenness Index</b> This statistic can take on a value between zero and one.",
	                                                                                   "<b>Simpsons Evenness Index</b> This statistic can take on a value between zero and logarithm of the sample size.",
	                                                                                   "<b>Root-Mean-Squared Error</b> This statistic can take on a value between zero and infinity.",
	                                                                                   "<b>Mean-Squared Error</b> This statistic can take on a value between zero and infinity.",
	                                                                                   "<b>Median-Absolute Error</b> This statistic can take on a value between zero and infinity.",
	                                                                                   "<b>Mean-Absolute Error</b> This statistic can take on a value between zero and infinity.",
	                                                                                   "<b>Chi-Squared Loss</b> This statistic can take on a value between zero and infinity."),
	                                                                       size = "s", easyClose = TRUE, fade = TRUE)), width = 5
	                                           )),#sidebarPanel
	                                       mainPanel(
	                                         
	                                         tabsetPanel(
	                                           tabPanel(title=strong("Design"),
	                                                    mainPanel(
	                                                      br(),
	                                                      conditionalPanel(condition = "output.table",
	                                                                       h3(HTML("<center><b>Probability Survey Site Results</b></center>"))),
	                                                      br(),
	                                                      
	                                                      uiOutput("shp_btn"),
	                                                      br(),
	                                                      dataTableOutput(outputId = "table"),
	                                                      style="width: 110%;"
	                                                    )),
	                                           
	                                           tabPanel(title=strong("Survey Map"),
	                                                    br(),
	                                                    conditionalPanel(condition = "output.ssplot",
	                                                                     h3(HTML("<center><b>Interactive Map</b></center>")),
	                                                                     fixedRow(
	                                                                       column(3, offset = 3,
	                                                                              selectInput(inputId = "color",
	                                                                                          label = HTML("<b>Select Color <br/> Attribute</b>"),
	                                                                                          choices = c("Site Use" = "siteuse", 
	                                                                                                      "Stratum" = "stratum", 
	                                                                                                      "Category" = "caty"),
	                                                                                          selected = "siteuse",
	                                                                                          multiple = FALSE, 
	                                                                                          width = "200px"))),
	                                                                                      leafletOutput("map", width="100%", height="70vh") %>% withSpinner(color="#0275d8"))
	                                           )#tabPanel(Survey Map)
	                                         )#tabsetPanel
	                                         , width = 7)#mainPanel
	                                       , position = c("left", "right"), fluid = TRUE)#sidebarLayout
	                    )#Condition panel
	           ),#tabPanel(Survey Design)
	           ####Adjust Weights####
	           tabPanel(title=span(strong("Step 4: Adjust Survey Weights"), 
	                               style = "font-weight: bold; font-size: 17px"), value="Step 4: Adjust Survey Weights",
	                    sidebarPanel(
	                      h4(strong(HTML("<center>Select the Weight Adjustment File<center/>"))),
	                      fileInput(
	                        inputId = "adjdata",
	                        label = strong("(Must be a .csv file)"),
	                        accept = c(".csv")) %>%
	                        #Weight file helper
	                        helper(icon = "circle-question",type = "inline",
	                               title = "Weight Adjustment File",
	                               content = c("Choose the .csv file which contains all sites which were evaluated in the design. This should include all target sites sampled, sites evaluated as non-target, replacement sites sampled (including additional sites used as oversamples) and non-response sites such as landowner denials and inaccessible sites.",
	                                           "<b>See Instructions For Use tab for examples on how to setup the Weight Adjustment File.</b>"),
	                               size = "s", easyClose = TRUE, fade = TRUE),
	                      hr(),
	                      column(12,
	                             h4(strong(HTML("<center>Set Adjustment Inputs<center/>"))),
	                             selectInput(inputId = "adjwgt",
	                                         label = strong("Select Column Containing Initial Site Weights"),
	                                         choices = "",
	                                         selected = NULL,
	                                         multiple = FALSE, 
	                                         width = "200px") %>%
	                               #Weight helper
	                               helper(icon = "circle-question",type = "inline",
	                                      title = "Site Weights",
	                                      content = c("Choose the column in the Weight Adjustment file which contains the initial survey design weights for each site."),
	                                      size = "s", easyClose = TRUE, fade = TRUE),
	                             
	                             selectInput(inputId = "adjsiteeval",
	                                         label = strong("Select Column Containing Site Evaluations"),
	                                         choices = "",
	                                         selected = NULL,
	                                         multiple = FALSE, 
	                                         width = "200px") %>%
	                               #Site Evaluation helper
	                               helper(icon = "circle-question",type = "inline",
	                                      title = "Site Evaluation Attributes",
	                                      content = c("Choose the column in the Weight Adjustment file which contains site evaluations of if the site was target and sampled, not sampled (target or non-response), and/or non-target."),
	                                      size = "s", easyClose = TRUE, fade = TRUE)
	                      ),
	                      conditionalPanel(condition = "input.adjsiteeval != ''",
	                                       column(12,
	                                              hr(),
	                                              strong(HTML("<center>Select Site Evaluation Attributes<center/>")) %>%
	                                                #Site eval helper
	                                                helper(icon = "circle-question",type = "inline",
	                                                       title = "Site Evaluation Attributes",
	                                                       content = c("<b>Sampled Target Sites:</b> Choose the class(es) which defines if the site was sampled and found to be member of the target population. This should also include additional sampled replacement sites.",
	                                                                   "<b>Non-Response Sites:</b> Choose the class(es) which defines if the site was a member of the target population, but was not sampled.",
	                                                                   "<b>If a site was not evaluated as a sampled target site or a non-response site, it will be evaluated as a non-target site.</b>"),
	                                                       size = "s", easyClose = TRUE, fade = TRUE)),
	                                       column(12, offset = 1,
	                                              
	                                              
	                                              #Select Site Attribute(s) That Apply to Your Dataset
	                                              selectInput(inputId = "sampled_site",
	                                                          label = strong("Sampled Sites"),
	                                                          choices = "",
	                                                          selected = NULL,
	                                                          multiple = TRUE,
	                                                          width = "200px"), 
	                                              selectInput(inputId = "nonresponse_site",
	                                                          label = strong("Non-Response Sites"),
	                                                          choices = "",
	                                                          selected = NULL,
	                                                          multiple = TRUE,
	                                                          width = "200px")),
	                      ),
	                      column(12,
	                             hr(),
	                             selectInput(inputId = "adjwgtcat",
	                                         label = strong("Select Column Containing Weight Categories"),
	                                         choices = "",
	                                         selected = "",
	                                         multiple = FALSE, 
	                                         width = "200px") %>%
	                               #Weight Category helper
	                               helper(icon = "circle-question",type = "inline",
	                                      title = "Weight Adjustment Category",
	                                      content = c("Choose the column in the Weight Adjustment file which contains the weight adjustment category. A weight adjustment category represents if a Stratum and/or Unequal Probability Category was used in the design as implemented. If the design was unequally stratified, this attribute should contain a combination of the stratum and category used (i.e. Stratum-Category). 
                                The default selection assumes every site is in the same category.")),
	                             size = "s", easyClose = TRUE, fade = TRUE),
	                      conditionalPanel(condition = "output.frame",
	                                       column(12,
	                                              strong(HTML("<center>Input Weight Category <br/>Frame Size<center/>")) %>%
	                                                #framesize helper
	                                                helper(icon = "circle-question",type = "inline",
	                                                       title = "Frame Size",
	                                                       content = c("Set the Frame Size for each Weight Category from the surveys sampling frame."),
	                                                       size = "s", easyClose = TRUE, fade = TRUE))
	                      ),
	                      uiOutput("frame"),
	                      # Press button for analysis 
	                      actionButton("adjButton", HTML("<b>Calculate Adjusted <br/> Survey Weights</b>"), icon=icon("circle-play"), 
	                                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
	                    ), #sidebarPanel
	                    mainPanel(
	                      conditionalPanel(condition = "input.adjButton",
	                                       span(h3(strong("Export Data As:")), style = "color:#337ab7;"),
	                                       downloadButton("dwnldcsv", icon=NULL, "CSV", 
	                                                      style = "background-color:#337AB7;
                                                                               color:#FFFFFF;
                                                                               border-color:#BEBEBE;
                                                                               border-style:solid;
                                                                               border-width:1px;
                                                                               border-radius:2px;
                                                                               font-size:16px;")),
	                      br(),
	                      DT::dataTableOutput("adjtable"), style = "font-weight:bold; font-size:90%;"
	                    )#mainPanel
	           )#tabPanel(Adjust Weights)
	) #navbarPage
	# Individual Page Footer
	,includeHTML("www/footer.html")
	, style = "width:1300px;")) #fluidPage


server <- function(input, output, session) {
  
  observe({
    updateCollapse(session, "instructions", open = "Overview")
    updateCollapse(session, "instructions", open = "design")
    updateCollapse(session, "instructions", open = "samplesize")
  })
  
  output$citation <-  renderPrint({
    citation(package = "spsurvey")
  })
  
  observe_helpers()
  
  
  observeEvent(input$sidebar_button, {
    shinyjs::toggle(selector = ".sidebar")
    js_maintab <- paste0('$(".tab-pane.active div[role=',"'main'",']")')
    
    if((input$sidebar_button %% 2) != 0) {
      runjs(paste0('
          width_percent = parseFloat(',js_maintab,'.css("width")) / parseFloat(',js_maintab,'.parent().css("width"));
            ',js_maintab,'.css("width","100%");
          '))
    } else {
      runjs(paste0('
          width_percent = parseFloat(',js_maintab,'.css("width")) / parseFloat(',js_maintab,'.parent().css("width"));
            ',js_maintab,'.css("width","");
          '))
    }
  })
  
  
  dbfdata <- reactive({
    
    req(input$filemap)
    shpdf <- input$filemap
    
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
    setwd(uploaddirectory)
    for(i in 1:nrow(shpdf)){
      file.rename(shpdf$datapath[i], shpdf$name[i])
    }
    setwd(previouswd)
    
    att <- read.dbf(paste(uploaddirectory, shpdf$name[grep(pattern="*.dbf$", shpdf$name)], sep="/")) %>%
    #We add a column called "None" with "None" values to handle designs without strata or categories.
    mutate(None="None") %>% relocate(None)
  })
  
  sfobject <- reactive({
    req(input$filemap)
    shpdf <- input$filemap
    
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
    setwd(previouswd)
    
    map <- st_read(paste(uploaddirectory, shpdf$name[grep(pattern="*.shp$", shpdf$name)], sep="/")) %>% 
      mutate(None="None") %>% relocate(None)
    
    
    if(!is.null(input$legacy)){
      legacyobject <- legacyobject()
      geometry<-class(legacyobject$geometry[[1]])
      frame_type<-strsplit(geometry," ")[[2]]
      
      #Removes legacyobjects from sframe
      if(frame_type=="POINT" || frame_type=="MULTIPOINT") {
        map <- map[!st_geometry(map) %in% st_geometry(legacyobject), , drop = FALSE]
      }
    }
    map <- st_zm(map)
  })
  

  #Load legacy shapefile
  legacyobject <- reactive({
    req(input$legacy)
    shpdf <- input$legacy
    
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
    setwd(uploaddirectory)
    for(i in 1:nrow(shpdf)){
      file.rename(shpdf$datapath[i], shpdf$name[i])
    }
    setwd(previouswd)
    
    map <- st_read(paste(uploaddirectory, shpdf$name[grep(pattern="*.shp$", shpdf$name)], sep="/")) %>% 
      mutate(None="None") %>% relocate(None)
    map <- st_zm(map)
  })
  
  
  
  
  
  
  
  #Stratum Event
  observe({
    req(dbfdata())
    if(input$caty != "") {
      strat_cols <- dbfdata() %>% select_if(~!is.numeric(.x)) %>% select(-input$caty)
      updateSelectInput(session, "stratum", selected = isolate(input$stratum), choices = c("None", colnames(strat_cols)))
    } else {
      strat_cols <- dbfdata() %>% select_if(~!is.numeric(.x))
      updateSelectInput(session, "stratum", selected = "None", choices = c("None", colnames(strat_cols)))
    }
    
  })
  
  #Category Event
  observe({
    req(dbfdata())
    if(input$stratum != "") {
      caty_cols <- dbfdata() %>% select_if(~!is.numeric(.x)) %>% select(-input$stratum)
      updateSelectInput(session, "caty", selected = isolate(input$caty), choices = c("None", colnames(caty_cols)))
    } else {
      caty_cols <- dbfdata() %>% select_if(~!is.numeric(.x))
      updateSelectInput(session, "caty", selected = "None", choices = c("None", colnames(caty_cols)))
    }
    
  })
  
  #Auxiliary Variable Event
  observe({
    req(input$addoptions==TRUE)
    aux_cols <- dbfdata() %>% select_if(~is.numeric(.x)) 
    updateSelectInput(session, "aux_var", selected = NULL, choices = c("None", colnames(aux_cols)))
  })

  
  #Stratum Length
  S <- reactive({
    req(input$stratum)
    if (input$stratum != "None") {
      dbfdata() %>% select(input$stratum) %>% 
        arrange(.data[[input$stratum]]) %>% 
        unique() %>% 
        pluck(input$stratum) %>% n_distinct()
    } else {1
    }
  })
  
  #Category Length
  C <- reactive({
    req(input$caty)
    
    if(input$caty != "None" && input$stratum == "None" || input$caty == "None" && input$stratum == "None"){
      split <- dbfdata() %>% select(input$caty) %>% unique() %>% pluck(input$caty) %>% n_distinct()
    } else if(input$caty != "None" && input$stratum != "None") {
      split <- dbfdata() %>%
        select(stratum = input$stratum, category = input$caty) %>% unique()
      split <- split(split$category, split$stratum)
      split <- lengths(split)
    } else {
      split <- dbfdata() %>%
        select(stratum = input$stratum, category = input$caty) %>% unique()
      split <- split(split$stratum, split$category)
      split <- lengths(simplify2array(split))
    }
  })
  
  #Category Length
  Z <- reactive({
    req(input$caty)
    if (input$caty != "None") {
      dbfdata() %>% select(input$caty) %>% unique() %>% pluck(input$caty) %>% n_distinct()
    } else {1
    }
  })
  
  strat_choices <- reactive({req(dbfdata())
    dbfdata() %>% select(input$stratum) %>% arrange(.data[[input$stratum]]) %>% unique()
  })
  
  caty_choices <- reactive({
    req(dbfdata())
    
    if(input$stratum != "None" && input$caty != "None" || input$stratum != "None" && input$caty == "None") {
      split <- dbfdata() %>%
        select(stratum = input$stratum, category = input$caty) %>% 
        arrange(category) %>% unique()
      split <- split(split$category, split$stratum)
    } else{
      split <- dbfdata() %>% select(input$caty) %>% arrange(.data[[input$caty]]) %>% unique()
    }
  })
  
  
  ####Legacy UI####
  output$legacyfile <- renderUI({
    fileInput(
      inputId = "legacy",
      placeholder = "Optional",
      label = HTML("<b>Choose all files of the Legacy Sites<br/> POINT Shapefile<br/>  Required: (.shp, .dbf, .prj, .shx)</b>"),
      multiple = TRUE,
      accept = c(".shp", ".prj", ".shx", ".dbf", ".sbn", ".sbx", ".cpg"), 
      width = "600px") %>%
      #User legacy helper
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Sample Frame",
             content = c("Legacy Sample Frame is a POINT or MULTIPOINT shapefile which contains sites that have been selected in a previous probability sample and are to be automatically included in a current probability sample. If the user transforms the samples frames CRS to NAD83/Albers Conus, the legacy object will also be transformed. The number of legacy sites must be greater than number of base sites in at least one stratum."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  
  
  #Render selectInput if stratum name is NOT in design shapefiles column names.
  output$legacystrat <- renderUI({
    req(input$stratum != "None" && input$stratum %!in% colnames(legacyobject()))
    
    legacy_cols <- legacyobject() %>% st_drop_geometry() %>% select_if(~!is.numeric(.x))
    selectInput(inputId = "legacy_strat",
                label = strong("Select Stratum from Legacy File"),
                selected = "None",
                multiple = FALSE,
                choices = colnames(legacy_cols),
                width = "200px") %>%
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Stratum",
             content = c("A Legacy Stratum is the same stratum used for a stratified design. This input is useful if the stratification variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  #Render selectInput if category name is NOT in design shapefiles column names.
  output$legacycat <- renderUI({
    req(input$caty != "None" && input$caty %!in% colnames(legacyobject()))
    legacy_cols <- legacyobject() %>% st_drop_geometry() %>% select_if(~!is.numeric(.x))
    selectInput(inputId = "legacy_cat",
                label = strong("Select Category from Legacy File"),
                selected = "None",
                multiple = FALSE,
                choices = colnames(legacy_cols),
                width = "200px") %>%
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Category",
             content = c("A Legacy Category is the same category used for the unequal design. This input is useful if the category variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  #Render selectInput if auxiliary variable name is NOT in design shapefiles column names.
  output$legacyaux <- renderUI({
    req(input$addoptions==TRUE && input$aux_var != "None" && input$aux_var %!in% colnames(legacyobject()))
    legacy_cols <- legacyobject() %>% st_drop_geometry() %>% select_if(~is.numeric(.x))
    selectInput(inputId = "legacy_aux",
                label = strong("Select Auxiliary Variable from Legacy File"),
                selected = "",
                multiple = FALSE,
                choices = colnames(legacy_cols),
                width = "200px") %>%
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Auxiliary",
             content = c("A Legacy Auxiliary variable is the same auxiliary variable used for the design. This input is useful if the auxiliary variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  
  
  ####Additional UI####
  output$addoptions <- renderUI({
    req(input$addoptions==TRUE)
    
    #DesignID Input
    fixedRow(
      column(6, offset=1,
             
             #Auxiliary variable input
             selectInput(inputId = "aux_var",
                         label = strong("Auxiliary Variable"),
                         choices = "",
                         selected = NULL,
                         multiple = FALSE, 
                         width = "200px") %>%
               #Auxiliary variable helper
               helper(icon = "circle-question",type = "inline",
                      title = "Auxiliary Variable",
                      content = c("Used for proportional probability selection where the selection for each sampling unit in the population is proportional to a positive <b>Auxiliary Variable</b>.
                                   Larger values of the auxiliary variable result in higher inclusion probabilities. Can be used in unstratified or stratified sampling."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Reproducible seed input
             numericInput("seed", strong(HTML("Set Reproducible</br> Seed")), rseed, width = "200px") %>%
               #Random Seed helper
               helper(icon = "circle-question",type = "inline",
                      title = "Reproducible Seed",
                      content = c("The randomization of the design is indexed by a 'seed'.",
                                  "A reproducible seed allows the user to obtain an identical draw when the same seed is used. If you wish to reproduce a previously constructed survey design, use the seed value from that design.",
                                  "Each time the tool is closed and reopened, a new random seed is used."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #DesignID input
             textInput(inputId = "DesignID", 
                       label = strong("DesignID"), 
                       value = "Site", 
                       width = "200px") %>%
               #DesignID helper
               helper(icon = "circle-question",type = "inline",
                      title = "DesignID",
                      content = c("A character string indicating the naming structure for each site's identifier selected in the sample, which is included as a variable in the shapefile in the tools output."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Minimum Distance input
             numericInput(inputId = "mindist", 
                          label = strong("Minimum Distance"),
                          value = NA, min = NA, max = NA, width="200px") %>%
               #Minimum Distance helper
               helper(icon = "circle-question",type = "inline",
                      title = "Minimum Distance",
                      content = c("A numeric value indicating the desired minimum distance between sampled sites. If design is stratified, then minimum distance is applied separately for each stratum. The units must match the units in the sample frame."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Maximum Attempts input
             numericInput(inputId = "maxtry", 
                          label = strong("Maximum Attempts"), 
                          value = 10, min = 0, max = NA, width="200px") %>%
               #Maximum Attempts helper
               helper(icon = "circle-question",type = "inline",
                      title = "Maximum Attempts",
                      content = c("The number of maximum attempts to apply the minimum distance algorithm to obtain the desired minimum distance between sites. Each iteration takes roughly as long as the standard GRTS algorithm. Successive iterations will always contain at least as many sites satisfying the minimum distance requirement as the previous iteration. The algorithm stops when the minimum distance requirement is met or there are maximum attempt iterations. The default number of maximum iterations is 10."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Nearest neighbor input
             numericInput(inputId = "n_near", 
                          label = strong("Nearest Neighbor Replacement Sites"), 
                          value = NA, min = 1, max = 10, width="200px") %>%
               #n_near helper
               helper(icon = "circle-question",type = "inline",
                      title = "Nearest Neighbor Replacements",
                      content = c("An integer from 1 to 10 specifying the number of nearest neighbor replacement sites to be selected for each base site. For point sample frames, the distance between a site and its nearest neighbor depends on point density. This tool does not offer stratum-specific nearest neighbor requirements."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             #Point Density input
             numericInput(inputId = "pt_density", 
                          label = strong("Point Density"), 
                          value = 10, min = 1, max = NA, width="200px") %>%
               #n_near helper
               helper(icon = "circle-question",type = "inline",
                      title = "Point Density",
                      content = c("A positive integer controlling the density of the GRTS approximation for infinite sampling frames. 
                         The default value of pt_density is 10. Note that when used with categories, the unequal inclusion probabilities generated from this approach are also approximations."),
                      size = "s", easyClose = TRUE, fade = TRUE)))
  })
  
  
  ####MainPanel UI####
  output$mytabs = renderUI({
    do.call(tabsetPanel, c(lapply(1:S(), function(s) {
      tabPanel(strong(paste0("Stratum: ", strat_choices()[s,1])),
               fixedRow(
                 column(3,
                        #Stratum Inputs
                        selectInput(inputId = paste0("strat",s),
                                    label = paste0("Stratum ",s),
                                    choices = strat_choices()[s,1],
                                    selected = "",
                                    multiple = FALSE) %>%
                          #Strata helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Stratum",
                                 content = c("Choose a stratum which defines how your sample sites will be stratified.",
                                             "If your design is not stratified, use the default <b>None</b>."),
                                 size = "s", easyClose = TRUE, fade = TRUE)),
                 
                 column(2, 
                        #Stratum Base sample sizes
                        numericInput(inputId = paste0("strat",s,"_base"), 
                                     label = "Base Sites",
                                     width = "100px",
                                     value = 0, min = 0, max = 10000) %>%
                          #Base helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Base Sites",
                                 content = c("If the design is unstratified, <b>Base Sites</b> is the overall sample size of the survey. If your design is stratified, set the sample size for each strata."),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        numericInput(inputId = paste0("Over",s), 
                                     label = "Replacement Sites",
                                     width = "100px",
                                     value = 0, min = 0, max = 10000) %>%
                          #Replacement helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Replacement Sites",
                                 content = c("Define number of Replacement sites needed for a stratum.",
                                             "Replacement sites are a set of spatially balanced sites that can be used for the replacement of a non-target or inaccessible sites.
                                                Misuse can cause spatial imbalance in your survey."),
                                 size = "s", easyClose = TRUE, fade = TRUE)),
                 
                 conditionalPanel(condition="input.caty != 'None'",
                                  column(3, offset = 1,
                                         #Category Inputs
                                         lapply(1:C()[s], function(i) {
                                           selectInput(inputId = paste0("S",s,"_C",i),
                                                       label = paste0("Category ",i),
                                                       choices = caty_choices()[[s]][i],
                                                       selected = "",
                                                       multiple = FALSE)
                                         }) %>%
                                           #Category helper
                                           helper(icon = "circle-question",type = "inline",
                                                  title = "Multi-density Categories",
                                                  content = c("Name and set the sample size of each Category.",
                                                              "<b>Note:</b> The total sample size defined in category inputs must equal the total sample size defined in the Base input."),
                                                  size = "s", easyClose = TRUE, fade = TRUE)),
                                  column(3,
                                         lapply(1:C()[s], function(i) {
                                           numericInput(inputId = paste0("S",s,"_C",i,"_Site"), 
                                                        label = paste0("Category ",i," Sites"),
                                                        width = "100px",
                                                        value = "0", min = 0, max = 100000)
                                          })
                                         )
            )#Conditionalpanel
          )#fixedRow
        )#tabPanel
      }))#stratum apply  
    ) #tabsetPanel
  })#renderUI
  
  ####SF Summary####
  sumdata <- reactive({
    req(dbfdata(), sfobject(), input$stratum, input$caty)
    
    sfobject <- sfobject()
    if(input$NAD83 == TRUE) {
      sfobject <- st_transform(sfobject, crs = 5070)
    }
    
    geometry<-class(sfobject$geometry[[1]])
    frame_type<-strsplit(geometry," ")[[2]]
    
    if(frame_type=="MULTIPOLYGON" || frame_type=="POLYGON") {
      Dist <- st_area(sfobject)
      Dist <- as.data.frame(Dist)
      st_geometry(sfobject) <- NULL
      sumdata <- cbind(sfobject, Dist)
    } else if(frame_type=="POINT" || frame_type=="MULTIPOINT" && is.null(input$legacy)) {
      sumdata <- sfobject() %>% st_drop_geometry() %>% mutate(Dist = 1)
    } else {
      Dist <- st_length(sfobject)
      Dist <- as.data.frame(Dist)
      st_geometry(sfobject) <- NULL
      sumdata <- cbind(sfobject, Dist)
    }
    sumdata
  })
  
  output$SF_SUM <- renderDataTable({
    req(dbfdata(), sfobject(), input$stratum, input$caty)
    
    if(input$stratum != "None" || input$caty != "None"){
      Summary <- sumdata() %>%
        rename(STRATUM = input$stratum,
               CATEGORY = input$caty) %>%
        group_by(STRATUM, CATEGORY) %>%
        summarise(RESOURCE_units = round(sum(Dist)), .groups = 'drop') %>%
        mutate(`Proportion_%` = round((RESOURCE_units/sum(RESOURCE_units))*100, 1)) %>%
        group_split(STRATUM) %>% 
        map_dfr(~ .x %>% 
                  janitor::adorn_totals(.) %>%
                  mutate(STRATUM = replace(STRATUM, n(), str_c(STRATUM[n()], "_", 
                                                               first(STRATUM)))))
      
      rows <- nrow(Summary)
      DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>% 
        formatStyle('CATEGORY',
                    target = 'row',
                    fontWeight = styleEqual(c("-"), c('bold')))
      
    } else {
      Summary <- sumdata() %>%
        rename(GROUP = None) %>%
        group_by(GROUP) %>%
        summarise(RESOURCE_units = sum(Dist), .groups = 'drop') %>%
        mutate(RESOURCE_units = round(RESOURCE_units))
      
      rows <- nrow(Summary)
      DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>%
        formatStyle('RESOURCE_units', fontWeight = 'bold')
    }
  })
  
  
  ####Legacy Summary####
  legacysum <- reactive({
    req(legacyobject())
    sumdata <- legacyobject() %>% st_drop_geometry() %>% mutate(Dist = 1)
  })
  
  output$LEGACY_SUM <- renderDataTable({
    req(legacyobject())
    
    if(input$stratum %in% colnames(legacyobject()) && input$caty %in% colnames(legacyobject())) {
      if(input$stratum != "None" || input$caty != "None"){
        Summary <- legacysum() %>%
          rename(STRATUM = input$stratum,
                 CATEGORY = input$caty) %>%
          group_by(STRATUM, CATEGORY) %>%
          summarise(RESOURCE_units = round(sum(Dist)), .groups = 'drop') %>%
          mutate(`Proportion_%` = round((RESOURCE_units/sum(RESOURCE_units))*100, 1)) %>%
          group_split(STRATUM) %>% 
          map_dfr(~ .x %>% 
                    janitor::adorn_totals(.) %>%
                    mutate(STRATUM = replace(STRATUM, n(), str_c(STRATUM[n()], "_", 
                                                                 first(STRATUM)))))
        
        rows <- nrow(Summary)
        DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>% 
          formatStyle('CATEGORY',
                      target = 'row',
                      fontWeight = styleEqual(c("-"), c('bold')))
        
      } else {
        Summary <- legacysum() %>%
          rename(GROUP = None) %>%
          group_by(GROUP) %>%
          summarise(RESOURCE_units = sum(Dist), .groups = 'drop') %>%
          mutate(RESOURCE_units = round(RESOURCE_units))
        
        rows <- nrow(Summary)
        DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>%
          formatStyle('RESOURCE_units', fontWeight = 'bold')
      }
    } else{
      Summary <- legacysum() %>%
        rename(GROUP = None) %>%
        group_by(GROUP) %>%
        summarise(RESOURCE_units = sum(Dist), .groups = 'drop') %>%
        mutate(RESOURCE_units = round(RESOURCE_units))
      
      rows <- nrow(Summary)
      DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>%
        formatStyle('RESOURCE_units', fontWeight = 'bold')
    }
  })
  
  
  
  #Updates Aux var type based on category input
  observe({
    req(input$aux_var != "None") 
    updateSelectInput(session, "caty", 
                      selected = "None")
  })
  
  
  observe({
    req(input$caty != "None" | input$stratum != "None") 
    updateSelectInput(session, "aux_var", 
                      selected = "None")
  })
  
  #Transfers user to Survey Design Results tab after pressing button
  observeEvent(input$goButton, {
    updateNavbarPage(session, "inTabset",
                     selected = "Step 3: Survey Design Results")
  })
  
  #Observer to sum categorical sites to update stratum base sites 
  observe({
    req(input$caty != "None" && input$S1_C1 != "None")
    
    sumCAT <- list() #empty list
    for(i in 1:S()) {
      for (x in 1:C()[i]) {
        sumCAT[[paste0("strat", i)]][paste0("S",i, "_C",x)] = input[[paste0("S",i,"_C",x,"_Site")]]
      }
    }
    sumCAT <- sapply(sumCAT, sum)
    
    lapply(1:S(), function(s) {
      updateNumericInput(session, 
                         paste0("strat",s,"_base"),  
                         value = unname(sumCAT[s]))
    })
  })
  
  
  ####Design####
  DESIGN <- eventReactive(input$goButton,{
    
    #Validates there is a complete sample frame added
    CRS <- st_crs(sfobject())
    
    validate(
      need(input$filemap != FALSE, 
           "Please input a Sample Frame."),
      need(!is.na(CRS),  
           "Please input the required file .prj of the sample frame."),
      if(!is.null(input$legacy)) {
        sumSTRAT<- c() #empty vector
        for(i in 1:S()) {
          sumSTRAT[[paste0("strat", i)]] = input[[paste0("strat",i,"_base")]]
        }
        sumSTRAT <- sum(unlist(sumSTRAT))
        legacypoints<- npts(legacyobject())
        need(legacypoints < sumSTRAT,
             "The number of legacy sites is greater than number of base sites in at least one stratum. 
      Please check that all strata have fewer legacy sites than base sites.")
      })
    
    show_modal_spinner(spin = 'flower', text = 'Processing...If the Design is taking too long or has timed out, consider visiting the apps GitHub site
                       and launching it locally for much improved processing.')
    
    #Sets reproducible seed
    if (input$addoptions == TRUE) {
      set.seed(input$seed)
    } else {
      set.seed(rseed)
    }
    
    ####Strata Conditionals####
    #Unstratified 
    if (input$stratum == "None") {
      stratum_var <- NULL
      n_base <- input$strat1_base
      #Stratified
    } else {
      stratum_var <- input$stratum
      #Creates Stratum named vector
      n_base <- c() #empty vector
      for(i in 1:S()) {
        n_base[[paste0("strat", i)]] = input[[paste0("strat",i,"_base")]]
        #Renames vectors
        name<-input[[paste0('strat',i)]]
        names(n_base)[i] <- name
      }
      n_base <- unlist(n_base)
    }
    
    ####Category Conditionals####
    #equal probablity
    if (input$caty == "None") {
      caty_var <- NULL
      caty_n <- NULL
      
      #Stratified, unequal probability
    } else if (input$caty != "None" && input$stratum != "None") {
      caty_var <- input$caty
      
      #Creates Category List
      caty_n <- list() #empty list
      for(i in 1:S()) {
        for (x in 1:C()[i]) {
          caty_n[[paste0("strat", i)]][paste0("S",i, "_C",x)] = input[[paste0('S',i,'_C',x, "_Site")]]
          #Renames Category names in list
          catname <- input[[paste0("S",i,"_C",x)]]
          names(caty_n[[i]])[x] <- catname
        }
      }
      
      #Renames Strata names in Categorical list
      for(i in 1:S()) {
        stratname <- input[[paste0("strat", i)]]
        names(caty_n)[i] <- stratname
      }
      #Removes categories == 0
      #caty_n <- lapply(caty_n, function(x) {x[x!=0]})
      #Unstratified, Unequal Probability
    } else {
      caty_var <- input$caty
      #Creates Category named vector
      caty_n <- c() #empty vector
      for(x in 1:Z()) {
        caty_n[[paste0("caty", x)]] = input[[paste0('S1_C',x, "_Site")]]
        #Renames vectors
        catname<-input[[paste0("S1_C",x)]]
        names(caty_n)[x] <- catname
      }
      caty_n <- unlist(caty_n)
    }
    
    ####Replacement Conditionals####
    #input for conditional below
    replace_con <- c()
    for(i in 1:S()) {
      replace_con[[paste0("Over", i)]] = input[[paste0('Over',i)]]
      stratname <- input[[paste0("strat", i)]]
      names(replace_con)[i] <- stratname
    }
    replace_con <- unlist(replace_con)
    replace_con <- length(unique(replace_con))
    
    #Equal Probability
    if(input$stratum == "None" && input$caty == "None") {
      n_over <- input$Over1
      #Stratified Equal Probability
    } else if (input$stratum != "None" && input$caty == "None") {
      #Creates Replacement sites List
      n_over <- list()
      for(i in 1:S()) {
        n_over[[paste0("Over", i)]] = input[[paste0('Over',i)]]
        stratname <- input[[paste0("strat", i)]]
        names(n_over)[i] <- stratname
      }
      #Unstratified Unequal Probability
    } else if(input$stratum == "None" && input$caty != "None") {
      #Creates replacement named vector
      n_over <- c() #empty vector
      for(i in 1:S()) {
        for(x in 1:C()[i]) {
          n_over[[paste0("caty", x)]] = input$Over1
          #Renames vectors
          catname <- input[[paste0("S1_C",x)]]
          names(n_over)[x] <- catname
        }
      }
      n_over <- unlist(n_over)
      #Stratified Unequal Probability (Where n_over changes among strata) 
      #} else if(input$stratum != "None" && input$caty != "None" && replace_con != 1) {
    }else{
      #Creates replacement List
      n_over <- list() #empty list
      for(i in 1:S()) {
        for (x in 1:C()[i]) {
          n_over[[paste0("strat", i)]][paste0("S",i, "_C",x)] = input[[paste0('Over',i)]]
          #Renames Category names in list
          catname <- input[[paste0("S",i,"_C",x)]]
          names(n_over[[i]])[x] <- catname
        }
        stratname <- input[[paste0("strat", i)]]
        names(n_over)[i] <- stratname
      }
    }  
    #Stratified Unequal Probability (Where n_over DOES NOT change among strata) 
    # } else{
    #   n_over <- list()
    #    for(i in 1:S()) {
    #      n_over[[paste0("Over", i)]] = input[[paste0('Over',i)]]
    #      stratname <- input[[paste0("strat", i)]]
    #      names(n_over)[i] <- stratname
    #    }
    #   }
    
    #Replacement input cannot be 0, this handles this instance by adding all oversamples and checks if its over 0
    for(i in 1:S()) {
      total <- 0
      over <- total + input[[paste0('Over',i)]]
    }
    if (over == 0) {
      n_over <- NULL
    }
    
    ####Legacy Conditionals####    
    
    if(!is.null(input$legacy) && input$NAD83 == TRUE) {
      legacy_sites <- legacyobject()
      legacy_sites <- st_transform(legacy_sites, crs = 5070)
    } else if(!is.null(input$legacy)) {
      legacy_sites <- legacyobject()
    } else {
      legacy_sites <- NULL
    }
    
    
    if(!is.null(input$legacy_strat)) {
      legacy_stratum_var <- input$legacy_strat
    } else {
      legacy_stratum_var <- NULL
    }
    
    if(!is.null(input$legacy_cat)) {
      legacy_caty_var <- input$legacy_cat
    } else {
      legacy_caty_var <- NULL
    }
    
    if(!is.null(input$legacy_aux)) {
      legacy_aux_var <- input$legacy_aux
    } else {
      legacy_aux_var <- NULL
    }
    
    
    
    ####Additional Attribute Conditionals####
    aux_var <- NULL
    mindis <- NULL
    maxtry <- 10
    n_near <- NULL
    DesignID <- "Site"
    pt_density <- 10
    
    if (input$addoptions == TRUE && input$aux_var != "None") {
      aux_var <- input$aux_var
    }
    if (input$addoptions == TRUE && !is.na(input$mindist)) {
      mindis <- input$mindist
    }
    if (input$addoptions == TRUE && input$maxtry != 10) {
      maxtry <- input$maxtry
    }
    if (input$addoptions == TRUE && !is.na(input$n_near)) {
      n_near <- input$n_near
    } 
    if (input$addoptions == TRUE && input$DesignID != "Site") {
      DesignID <- input$DesignID
    } 
    if (input$addoptions == TRUE && input$pt_density != 10) {
      pt_density <- input$pt_density
    } 
    
    sample_frame <- sfobject()
    
    if(input$NAD83 == TRUE) {
      sample_frame <- st_transform(sample_frame, crs = 5070)
    }
    
    #Removes stop_df if calculate button has been previously pressed
    if(exists('stop_df')) {
      rm('stop_df', envir=.GlobalEnv)
    }
    
    if(input$designtype=="GRTS") {
      
      design <- try(spsurvey::grts(sample_frame,
                         n_base = n_base,
                         stratum_var = stratum_var,
                         caty_var = caty_var,
                         caty_n = caty_n,
                         n_over = n_over,
                         aux_var = aux_var,
                         #legacy_var = legacy_var,
                         legacy_sites = legacy_sites,
                         legacy_stratum_var = legacy_stratum_var,
                         legacy_caty_var = legacy_caty_var,
                         legacy_aux_var = legacy_aux_var,
                         mindis = mindis,
                         maxtry = maxtry,
                         n_near = n_near,
                         pt_density = pt_density,
                         DesignID = DesignID))
    }
    
    else {
      design <- try(spsurvey::irs(sample_frame,
                        n_base = n_base,
                        stratum_var = stratum_var,
                        caty_var = caty_var,
                        caty_n = caty_n,
                        n_over = n_over,
                        aux_var = aux_var,
                        #legacy_var = legacy_var,
                        legacy_sites = legacy_sites,
                        legacy_stratum_var = legacy_stratum_var,
                        legacy_caty_var = legacy_caty_var,
                        legacy_aux_var = legacy_aux_var,
                        mindis = mindis,
                        maxtry = maxtry,
                        n_near = n_near,
                        pt_density = pt_density,
                        DesignID = DesignID))
    }
    
    remove_modal_spinner()
    
    #If grts or irs is unsuccessful, reactive returns error message data frame (stop_df)
    if(exists('stop_df')){
      stop_df
      #If grts or irs is unsuccessful, reactive returns list (design)
    } else {
      # find the call list
      call_list <- as.list(design$design$call)
      # only replace specific elements
      replace_names <- names(call_list)[!names(call_list) %in% c("", "sframe","legacy_sites")]
      call_list[replace_names] <- lapply(replace_names, function(x) eval(call_list[[x]]))
      # save new call list as a call
      new_call <- as.call(call_list)
      
      design$design <- data.frame(call = deparse1(new_call))
      
      design
    }
  })
  
  
  ####Design Error####
  output$error <- renderTable({
    if(is.data.frame(DESIGN())) {
      DESIGN()
    } else {
      print("No Design Errors Found. Way To Go!")
    }
  })
  
  
  ####SS Summary####
  output$summary <- renderDataTable({
    
    Summary <- sp_rbind(DESIGN())
    st_geometry(Summary) <- NULL
    Summary <- Summary %>% filter(!(is.na(wgt))) %>%
      group_by(siteuse, stratum, caty) %>%
      summarise(SITES = n(), .groups = 'drop') %>%
      group_split(siteuse) %>% 
      map_dfr(~ .x %>% 
                janitor::adorn_totals(.) %>% 
                mutate(siteuse = replace(siteuse, n(), str_c(siteuse[n()], "_", 
                                                             first(siteuse))))) %>% 
      rename_with(toupper)%>% rename(CATEGORY = CATY)
    rows <- nrow(Summary)
    DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>% 
      formatStyle('STRATUM',
                  target = 'row',
                  fontWeight = styleEqual(c("-"), c('bold')))
  })
  
  ####PopEst Sim UI####
  output$conditionprb <- renderUI({
    
    if(input$connumber == "2") {
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON2", 
                       label = "Good Probability (%)", 
                       value = 50, min = 0, max = 100., width = "80px"),
          numericInput(inputId = "CON4", 
                       label = "Poor Probability (%)", 
                       value = 50, min = 0, max = 100, width = "80px")))
    } else if(input$connumber == "3") {
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON2", 
                       label = HTML("Good</br> Probability (%)"), 
                       value = 33, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON3", 
                       label = HTML("Fair</br> Probability (%)"), 
                       value = 33, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON4", 
                       label = HTML("Poor</br> Probability (%)"), 
                       value = 33, min = 0, max = 100, width = "80px")))
    } else if(input$connumber == "4") {
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON2", 
                       label = HTML("Good</br> Probability (%)"), 
                       value = 25, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON3", 
                       label = HTML("Fair</br> Probability (%)"), 
                       value = 25, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON4", 
                       label = HTML("Poor</br> Probability (%)"), 
                       value = 25, min = 0, max = 100, width = "80px")),
        numericInput(inputId = "CON5", 
                     label = HTML("Very Poor</br> Probability (%)"), 
                     value = 25, min = 0, max = 100, width = "80px"))
    } else{
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON1", 
                       label = HTML("Very Good</br> Probability (%)"), 
                       value = 20, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON2", 
                       label = HTML("Good</br> Probability (%)"), 
                       value = 20, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON3", 
                       label = HTML("Fair</br> Probability (%)"), 
                       value = 20, min = 0, max = 100, width = "80px")),
        column(9,
               splitLayout(
                 numericInput(inputId = "CON4", 
                              label = HTML("Poor</br> Probability (%)"), 
                              value = 20, min = 0, max = 100, width = "80px"),
                 numericInput(inputId = "CON5", 
                              label = HTML("Very Poor</br> Probability (%)"), 
                              value = 20, min = 0, max = 100, width = "80px"))))
    }
  })
  
  ####PopEst Simulation####
  samplesize <- eventReactive(c(input$ssbtn, input$goButton), {
    #req(input$CON2, input$CON4)
    
    forcat <- DESIGN()$sites_base
    units(forcat$wgt) <- NULL
    
    
    
    if (input$connumber == "2"){
      forcat$Condition <- sample(c("Good", "Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON2, input$CON4))
      colors <- c("#f55b5b", "#5796d1")
    }
    if (input$connumber == "3"){
      forcat$Condition <- sample(c("Good", "Fair", "Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON2, input$CON3, input$CON4))
      colors <- c("#f55b5b", "#EE9A00", "#5796d1")
    }
    if (input$connumber == "4"){
      forcat$Condition <- sample(c("Good", "Fair", "Poor", "Very Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON2, input$CON3, input$CON4, input$CON5))
      colors <- c("#d15fee", "#f55b5b", "#EE9A00", "#5796d1")
    }
    if (input$connumber == "5"){
      forcat$Condition <- sample(c("Very Good", "Good", "Fair", "Poor", "Very Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON1, input$CON2, input$CON3, input$CON4, input$CON5))
      colors <- c("#d15fee", "#f55b5b", "#EE9A00", "#5796d1", "blue")
    }
    
    if (input$stratum == "None") {
      if(input$conflim == "95%") {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt")
      } else {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt",
          conf = 90)
      }
    }
    
    if (input$stratum != "None") {
      stratum_var <- input$stratum
      if(input$conflim == "95%") {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt",
          stratumID = stratum_var)
      } else {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt",
          stratumID = stratum_var,
          conf = 90)
      }
    }
    
    cat_ests <- cat_ests %>%
      filter(!(Category == "Total")) %>%
      mutate(Category = factor(Category, levels=c("Very Poor", "Poor", "Fair", "Good", "Very Good"))) %>%
      rename(UCB = contains("UCB") & contains("Pct.P"),
             LCB = contains("LCB") & contains("Pct.P")) %>%
      mutate(Estimate.P = round(Estimate.P, 0),
             UCB = round(UCB, 0),
             LCB = round(LCB, 0),
             MarginofError.P = round(MarginofError.P, 0))
    
    avgMOE <- round(mean(cat_ests$MarginofError.P),0)
    nResp <- sum(cat_ests$nResp)
    
    #Create Plots
    plot <- ggplot(cat_ests, aes(x = Category, y = Estimate.P)) +
      geom_bar(aes(fill = Category, color = Category), alpha = 0.5, stat="identity", position = position_dodge()) +
      geom_errorbar(aes(ymin = LCB, ymax = UCB, color = Category), linewidth=2, width=0) +
      scale_x_discrete(labels = function(x) str_wrap(x, width = 8)) +
      scale_fill_manual(values = colors) +
      scale_color_manual(values = colors) +
      theme_bw() +
      labs(
        title = paste0("Average Margin of Error: ±", avgMOE,"%"),
        subtitle = paste0("   n=", nResp),
        x = "",
        y = "Percent of Resource") +
      theme(
        plot.title = element_text(size = 16, face = "bold", family="sans", hjust=0.5),
        plot.subtitle = element_text(size = 15, face = "bold", family="sans"),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "aliceblue"),
        legend.position="none",
        axis.text.x=element_text(face = "bold", size=14),
        axis.text.y=element_text(face = "bold", size=13),
        axis.title.y = element_text(face = "bold", size=14),
        axis.title.x = element_text(face = "bold", size=14)) +
      geom_text(aes(label=paste(format(Estimate.P),"%",
                                sep=""), y=Estimate.P), hjust = -.05, size = 4, fontface = "bold", color = "#4D4D4D", family="sans", position = position_nudge(x = -0.2)) +
      scale_y_continuous(labels = scales::percent_format(scale = 1), breaks=c(0,25,50,75,100)) +
      coord_flip(ylim=c(-2, 110)) +
      geom_text(aes(label=paste(format(LCB),"%",
                                sep=""), y=LCB), hjust = 1.1, size = 3.5, fontface = "bold", 
                color = "#4D4D4D", family="sans", position = position_nudge(x = 0.15)) +
      geom_text(aes(label=paste(format(UCB),"%",
                                sep=""), y=UCB), hjust = -.15,size = 3.5, fontface = "bold", 
                color = "#4D4D4D", family="sans", position = position_nudge(x = 0.15))
    plot
  })
  
  
  output$ssplot <- renderPlot({
    samplesize()
  })
  
  ####Spatial Balance####
  sbresult <- eventReactive(input$balancebtn, {
    # req(input$caty == "None")
    
    #if(input$stratum != "None") {
    #  sp_balance(DESIGN()$sites_base, sfobject(), stratum_var = input$stratum, metrics = input$balance)
    #} else {
    sp_balance(DESIGN()$sites_base, sfobject(), metrics = input$balance)  
    # } 
  })
  
  output$balance <-  renderPrint({
    sbresult()
  })
  
  
  ####Design Table####
  output$table <- renderDataTable(server = FALSE, {
    req(!is.data.frame(DESIGN()))
    if (input$addoptions == TRUE) {
      rseed <- input$seed
    }
    
    DES_SD <- sp_rbind(DESIGN())  
    #Add xcoord/ycoord
    DES_SD <- DES_SD %>% 
      mutate(xcoord = unlist(map(DES_SD$geometry, 1)),
             ycoord = unlist(map(DES_SD$geometry, 2)), .after = lat_WGS84)
    st_geometry(DES_SD) <- NULL
    DESIGN<- DES_SD %>% filter(!(is.na(wgt))) %>% 
      select(-None) %>% 
      mutate(rep_seed = rseed, .after= "caty")
    
    DT::datatable(
      DESIGN,
      rownames = FALSE,
      options = list(dom = 'Blrtip',
                     autowidth = TRUE,
                     scrollX = TRUE)
                  )
  })
  
  
  
  ####Download Shapefile and README####
  output$shp_btn <- renderUI({
    req(!is.data.frame(DESIGN()))
    downloadButton("download_shp", HTML("Download Survey <br/> Design"), icon=icon("compass"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
  })
  
  output$download_shp  <- downloadHandler(
    filename = function() {
      shpdf <- input$filemap
      paste0(gsub('.{4}$', '', shpdf$name[1]), "_Survey_Design_", format(Sys.Date(), "%Y-%m-%d"), 
             ".zip", sep="")
    },
    content = function(file) {
      tmp.path <- dirname(file)
      
      shpdf <- input$filemap
      name.base <- file.path(tmp.path, "Survey_Sites")
      name.shp  <- paste0(name.base, ".shp")
      name.glob <- paste0(name.base, ".*")
      
      name.base2 <- file.path(tmp.path, shpdf$name[grep(pattern="*.shp$", shpdf$name)])
      name.glob2  <- paste0(tmp.path, "/", shpdf$name)
      
     
      #if(length(Sys.glob(name.glob)) > 0) file.remove(Sys.glob(name.glob))
           DES_SD <- sp_rbind(DESIGN())
           DES_SD <- DES_SD %>% filter(!(is.na(wgt))) %>% select(-None)
      
           st_write(DES_SD, dsn = name.shp,
                    driver = "ESRI Shapefile", quiet = TRUE, append=FALSE)
           
           sfobject <- sfobject()
           st_write(sfobject, dsn = name.base2,
                    driver = "ESRI Shapefile", quiet = TRUE, append=FALSE)
      
           if(input$addoptions == TRUE) {
             seed <- input$seed
           }else{
             seed <- rseed
           }
           
           DESIGN <- DES_SD %>% 
             mutate(xcoord = unlist(map(DES_SD$geometry, 1)),
                    ycoord = unlist(map(DES_SD$geometry, 2)), .after = lat_WGS84)
           st_geometry(DESIGN) <- NULL
           DESIGN <- DESIGN %>% filter(!(is.na(wgt))) %>% 
             mutate(rep_seed = rseed, .after= "caty")
           
           write.csv(DESIGN, file.path(tmp.path, "Survey_Sites.csv"), row.names = FALSE)
           # name.glob3  <- paste0(tmp.path, "/Survey_Sites.csv")
           
      sample_frame_name <- paste0(gsub('.{4}$', '', shpdf$name[1]))
      
      README <- writeLines(c(
        "Thank you for using EPA's Office of Water Survey Design Tool.",
        "Please read this file in its entirety.",
        "",
        "This .zip contains all the necessary files associated with your survey",
        "design. It is important that you keep them bundled together and saved in a",
        "secure location, so that if you need to reproduce your results in the future",
        "or ask for clarification, we will have all the tools we need to be able to",
        "efficiently help.",
        "",
        "The .zip contains three files:",
        "",
        "1. The original sample frame used to create the design (as its own .zip)",
        paste("    a. ", sample_frame_name, ".dbf", " (a database file)", sep = ""), 
        paste("    b. ", sample_frame_name, ".prj", " (a projection file)", sep = ""), 
        paste("    c. ", sample_frame_name, ".shp", " (a main file)", sep = ""), 
        paste("    d. ", sample_frame_name, ".shx", " (an index file)", sep = ""), 
        "",
        "2. The sites selected by the survey design.",
        paste("    a. Survey_Sites.dbf (a database file)", sep = ""), 
        paste("    b. Survey_Sites.prj (a projection file)", sep = ""), 
        paste("    c. Survey_Sites.shp (a main file)", sep = ""), 
        paste("    d. Survey_Sites.shx (an index file)", sep = ""), 
        paste("    e. Survey_Sites.csv (a flat file)", sep = ""), 
        "",
        "3. This README, which describes all files associated with your design and",
        "and contains relevant R software code and metadata used to carry out the design.",
        "",
        "For questions, please contact Garrett Stillings (Stillings.Garrett@epa.gov)",
        "and/or Michael Dumelle (Dumelle.Michael@epa.gov).",
        "",
        "R software code and metadata:",
        "",
        paste("seed number:", seed, sep = " "),
        paste(""),
        paste("sf/spsurvey call:"),
        paste0("sample_frame <- sf::st_read(“user_defined_path/", sample_frame_name, ".shp”)"),
        paste(DESIGN()$design, sep = " "),
        paste(""),
        paste("spsurvey version:", as.character(packageVersion("spsurvey")), sep = " "),
        paste("CRS: 5070", sep = " "),
        paste("R version:", R.version$major, R.version$minor, sep = "."),
        paste("Survey Design Tool version: 2.0.0"),
        paste("Date:", date(), sep = " "),
        ""
      ),
      con ="README.txt")
      
      fs <- c(Sys.glob(name.glob2), Sys.glob(name.glob), Sys.glob("Survey_Sites.csv"), "README.txt") %>% unique()
      
      zip::zipr(zipfile = file, files = fs)
      if(file.exists(paste0(file, ".zip"))) {file.rename(paste0(file, ".zip"), file)}
    },
    contentType = "application/zip"
  ) 
  
  
  ####Mapping####
  
  output$map <- renderLeaflet({
    req(input$goButton, DESIGN())
    
    surveypts <- sp_rbind(DESIGN())
    surveypts <- surveypts %>% filter(!(is.na(stratum))) %>% filter(!(is.na(caty))) %>%
      st_transform(crs=4269)
    
    sfobject <- sfobject()
    geometry<-class(sfobject$geometry[[1]])
    frame_type<-strsplit(geometry," ")[[2]]
    
    if (frame_type=="MULTIPOLYGON" || frame_type=="POLYGON") {
      frame_type<-"area"
    } else if (frame_type=="POINT" || frame_type=="MULTIPOINT") {
      frame_type<-"finite"
    } else {
      frame_type<-"linear"
    }
    
    frame <- sfobject %>%
      st_transform(crs=4269) 
    
    m<-mapview(surveypts, zcol = input$color)
    
    
    if(frame_type=="linear") {
      m@map <- m@map %>%
        addPolylines(data=frame, color="blue") %>%
        addProviderTiles("OpenTopoMap")}
    else if(frame_type=="area") {
      m@map <- m@map %>%
        addPolygons(data=frame, color="blue") %>%
        addProviderTiles("OpenTopoMap")}
    else {
      m@map <- m@map %>%
        addProviderTiles("OpenTopoMap")}  
    
    m@map
  })
  
  
  ####Weight Adjustment####
  adjdata <- reactive({
    adj<-read.csv(req(input$adjdata$datapath))
  })
  
  
  #Adjustment Weight Input
  observe({
    req(adjdata())
    adj_cols_wgt <- adjdata() %>% select_if(~is.numeric(.x))
    updateSelectInput(session, "adjwgt", selected = NULL, choices = c("Required" = "", colnames(adj_cols_wgt)))
  })  
  
  observe({
    req(adjdata())
    adj_cols_cat <- adjdata() %>% select_if(~!is.numeric(.x)) %>% colnames()
    adj_cols_eval <- adjdata() %>% select_if(~!is.numeric(.x)) %>% colnames() 
    
    #Adjustment Weight Category Input
    updateSelectInput(session, "adjwgtcat", selected = isolate(input$adjwgtcat), choices = c("All Same Category"="", adj_cols_cat[! adj_cols_cat %in% input$adjsiteeval]))
    
    #Adjustment Site Input
    updateSelectInput(session, "adjsiteeval", selected = isolate(input$adjsiteeval), choices = c("Required" = "", adj_cols_eval[! adj_cols_eval %in% input$adjwgtcat]))
  })
  
  
  observe({
    req(input$adjsiteeval != "")
    sampled_choices <- adjdata() %>% filter(!(.data[[input$adjsiteeval]] %in% c(.env$input$nonresponse_site)))%>% unique() %>% pluck(input$adjsiteeval)
    nonresponse_choices <- adjdata() %>% filter(!(.data[[input$adjsiteeval]] %in% c(.env$input$sampled_site)))%>% unique() %>% pluck(input$adjsiteeval)
    
    updateSelectInput(session,'sampled_site', selected = isolate(input$sampled_site), choices = c("Required" = "", sampled_choices))
    updateSelectInput(session,'nonresponse_site', selected = isolate(input$nonresponse_site), choices = nonresponse_choices)
  })
  
  
  catname <- reactive({ 
    adjdata() %>% pluck(input$adjwgtcat) %>% unique()
  })
  
  output$frame <- renderUI({
    req(input$adjsiteeval!="")
    
    if(input$adjwgtcat != ""){
      lapply(catname(), function(i) {
        numericInput(
          inputId=paste0("CAT_", i),
          label=paste0(i, "-Frame Size"),
          value=0,
          width = "200px")
      })
    } else {
      numericInput(
        inputId="CAT_1",
        label="Total Frame Size",
        value=0,
        width = "200px")
    }
  })
  
  
  
  #Weight Adjustment
  adjbutton <- eventReactive(input$adjButton,{
    validate(
      need(input$adjwgt != "", 
           "Please input initial site weights."),
      need(input$adjsiteeval != "", 
           "Please input site evaluations."),
      need(input$sampled_site != "", 
           "Please input attribute(s) which indicate site has been sampled.")
    )
    
    adjdata <- adjdata() %>% filter(!is.na(.data[[input$adjsiteeval]]))
    
    wgt <- adjdata %>% pluck(input$adjwgt)
    EvalStatus <- adjdata %>% pluck(input$adjsiteeval)
    
    if(input$adjwgtcat!=""){
      MARClass <- adjdata %>% pluck(input$adjwgtcat)
      
      datalist <- list()
      for(n in catname()) {
        framesize <- input[[paste0("CAT_",n)]]
        datalist[[n]] <- framesize
      } 
      framesize <- do.call(cbind.data.frame, datalist)
      framesize <- unlist(framesize)
    } else {
      MARClass <- adjdata %>% mutate(WGT_CATEGORY = "Total Frame Size") %>% pluck("WGT_CATEGORY")
      
      framesize <- c("Total Frame Size" = input$CAT_1)
    }
    
    adjdata$WGT_TP_EXTENT <-adjwgt(wgt = wgt, wgtcat = MARClass, 
                                   framesize = framesize, sites = NULL)
    
    if(!is.null(input$nonresponse_site)) {
      
      TNRClass <-  input$nonresponse_site
      TRClass <- input$sampled_site
      adjdata$WGT_TP_CORE <- adjwgtNR(adjdata$WGT_TP_EXTENT, MARClass, EvalStatus, TNRClass, TRClass)
    }
    
    adjdata
  })
  
  
  output$adjtable <- renderDataTable({
    DT::datatable(
      if(input$adjButton) {
        adjbutton() 
      } else {
        adjdata()  
      }, 
      filter = list(position = 'top'),
      rownames = FALSE,
      options = list(
        autowidth = TRUE,
        scrollX = TRUE,
        searchHighlight = TRUE)
    )
  })
  
  
  output$dwnldcsv <- downloadHandler(
    filename = function() {
      paste("Survey_adjwgts_", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(adjbutton(), file, row.names = FALSE)
    }
  )
  
  #session$onSessionEnded(stopApp) 
}
# shinyApp()
shinyApp(ui = ui, server = server)