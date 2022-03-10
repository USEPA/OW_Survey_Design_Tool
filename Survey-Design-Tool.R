packages <- c("shiny", "spsurvey", "tidyverse", "janitor", "DT", "zip", "foreign", "sf", "sp", "leaflet", "mapview", "ggspatial", "shinythemes", "shinybusy", "shinycssloaders", "shinyhelper", "shinyBS")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
lapply(packages, library, character.only = TRUE)



rseed <- sample(10000,1)
#state_name <- state.name

#Allows the upload of large files
options(shiny.maxRequestSize = 10000*1024^2)
#Creates new operator %!in%
`%!in%` <- Negate(`%in%`)

####Instructions####
# Define UI
ui <- fluidPage(theme = shinytheme("yeti"), 
                # Application title 
                navbarPage(id = "inTabset", 
                           title = span("Survey Design Tool (v. 1.0.1)", 
                                        style = "font-weight: bold; font-size: 28px"),
                           selected='instructions', position='static-top',
                           inverse = TRUE,
                           # Panel with instructions for using this tool
                           
                           tabPanel(title=span(strong("Step 1: Instructions for Use"), 
                                                      style = "font-weight: bold; font-size: 18px"), value='instructions',
                              bsCollapse(id = "instructions",   
                                  bsCollapsePanel(title = h1(strong("Overview")), value="Overview",
                                     p("This R Shiny app allows for the calculation of spatially balanced survey designs of point, linear, or areal resources using the Generalized Random-Tessellation Stratified (GRTS) algorithm,", tags$a(href= "https://cfpub.epa.gov/ncer_abstracts/index.cfm/fuseaction/display.files/fileID/13339", "Stevens and Olsen (2004).", target="blank"), 
                                       "The Survey Design Tool utilizes functions found within the R package", tags$a(href="https://cran.r-project.org/package=spsurvey",
                                      "spsurvey: Spatial Sampling Design and Analysis", target="blank"), "and presents an easy-to-use user interface for many sampling design features including stratification, unequal and proportional inclusion probabilities, replacement (oversample) sites, and legacy (historical) sites. 
                                      The output of the Survey Design Tool contains sites designed and balanced by user specified inputs and allows the user to export sampling locations as a point shapefile or a flat file. The output also provides design weights which can be used in categorical and continuous variable analyses (i.e., population estimates). 
                                      The tool also gives the user the ability to adjust initial survey design weights when implementation results in the use of replacement sites or when it is desired to have final weights sum to a known frame size."), 
                                      
                                      p("This app does not include all possible design options and tools found in the spsurvey package. Please review the package", tags$a(href= "https://www.rdocumentation.org/packages/spsurvey", "Documentation", target="blank"), "and", tags$a(href= "https://github.com/USEPA/spsurvey", "Vignettes", target="blank"), "for more options and details.  
                                      For further survey discussion and use cases, visit the website for", tags$a(href="https://www.epa.gov/national-aquatic-resource-surveys", "EPAs National Aquatic Resource Surveys (NARS)", target="blank"), 
                                      "which are designed to assess the quality of the nation's coastal waters, lakes and reservoirs, rivers and streams, and wetlands using GRTS survey designs. We encourage users to consult with a statistician about your design to prevent design issues and errors."),
                                      p("For Survey Design Tool questions, bugs, feedback, or tool modification suggestions, please contact Garrett Stillings at", tags$a(href="mailto:stillings.garrett@epa.gov", "stillings.garrett@epa.gov", target="blank")),
                                      h4(strong("Vignette")),
                                    h4(strong(tags$ul(
                                      tags$li(tags$a(href="https://cran.r-project.org/web/packages/spsurvey/vignettes/sampling.html",
                                                     "Spatially Balanced Sampling", target="blank")))))),
                                    #br(),hr(),
                              bsCollapsePanel(title = h3(strong("Prepare Survey Design Tab")), value="prepare",
                                    tags$ol(
                                    h4(strong("Requirements")),
                                      tags$ul(
                                        tags$li("The coordinate reference system (crs) for the sample frame should use projected coordinates NOT geographic coordinates."),
                                        tags$li("All design attribute variables, such as the Strata and Categories, must be contained in the user's sample frame file. You may run the design without these inputs as an unstratified equal probability design."),
                                        tags$li("When constructing your design, the user must identify how they want their survey to be designed and which random selection to use:"),
                                            tags$ul(
                                              tags$li(strong("Equal Probability Sampling")," - equal inclusion probability. Selection where all units of the population have the same probability of being selected."),
                                              tags$li(strong("Stratified Sampling")," - Selection where the sample frame is divided into non-overlapping strata which independent random samples are calculated."),
                                              tags$li(strong("Unequal Probability Sampling")," - unequal inclusion probability. Selection where the chance of being included is calculated relative to the distribution of a categorical variable across the population. This type of sampling can give smaller populations a greater chance of being selected."), 
                                              tags$li(strong("Proportional Probability Sampling")," - proportional inclusion probability. Selection where the chance of being included is proportional to the values of a positive auxiliary variable. For example, if you have a large number of strata in your design, this will ensure each stratum has a sample."))),
                                    bsCollapsePanel(title = h4(strong("Designing the Survey")), value="design",
                                      tags$li("Select the Sample Frame. Sample frames must be an ESRI shapefile. The user must select all parts of the shapefiles which include .shp, .dbf, .shx. and .prj files (Tip: Hold down ctrl and select each file). The coordinate system for the sample frame must be one where distance for the coordinates is meaningful. The attributes in the file will populate as possible inputs for the design. Maximum size is currently 10GB."),
                                      tags$li("Choose your desired Design Type:",
                                            tags$ul(
                                              tags$li(strong("GRTS")," - Generalized Random Tessellation Stratified. For survey designs desiring spatially balanced samples."),
                                              tags$li(strong("IRS")," - Independent Random Sample. For survey designs desiring non-spatially balanced samples."))),
                                      tags$li("Select Strata attribute. If your design is stratified, select the attribute which indicates the desired Strata. If Stratum equals 'None', the design is unstratified. The default is 'None'. Example Strata could be Stream Type (Perennial and Intermittent) or Size (Large and Small)."),
                                      tags$li("Select Category attribute. For an unequal inclusion probability design, select the attribute which indicates the categorical variable which the selection will be based on. Often, the output Category sample sizes will be close, but not exact to the user's sample sizes allocated for each Category. This is because the Category-level sample sizes are random variables. The default is 'None'. An example Category could be stream order or elevation (high/low)."),
                                    
                                    h4(strong(em("Optional: Additional Design Attributes"))),
                                      tags$li("Additional design attributes such as Auxiliary Variables, Reproducible Seed, DesignID, Minimum Distance, Maximum Attempts, and Nearest Neighbor Replacement Sites are also available. Descriptions of these inputs can be found in the grts section on the spsurvey manual as well as the helper buttons next to the inputs."),
                                    h4(strong(em("Optional: Legacy Sampling"))),
                                      tags$li("Legacy sites are sites that have been selected in a previous probability sample and are to be automatically included in the current probability sample."),
                                      tags$li("Upload a POINT sample frame which contains the Legacy sites you would like included in the design. All sites in the sample frame file will be considered legacy sites."),
                                      tags$li("If your Legacy sample frame has different Strata, Category or Auxiliary variable names than your design sample frame, select the corresponding attribute(s) from the legacy sample frame. These inputs will not appear if the names match your design sample frame.")
                                    )),
                                    tags$ol(
                                      bsCollapsePanel(title = h4(strong("Determine Survey Sample Sizes")), value="samplesize",
                                      p("Setting an appropriate sample size and considering how they should be allocated across a sample frame is a fundamental step in designing a successful survey. Many surveys, especially those used for environmental monitoring, are limited by budgetary and logistical constraints. The designer must determine a sample size which can overcome these constraints while ensuring the survey estimates the parameter(s) of interest with a low margin of error.
                                      The designer can consider a few elements when determining a survey sample size:"),
                                      tags$ul(
                                        tags$li("Select a spatially balanced survey using the spatial balance metrics provided. Typically, estimates from spatially balanced surveys are more precise (vary less) than estimates from non-spatially balanced surveys."),
                                        tags$li("Consider what will be measured in the survey. If you anticipate the parameter of interest to result in low variation across the survey, a smaller sample size can yield a low margin of error estimate. Conversely, if you anticipate the parameter of interest to result in high variation, you should consider increasing the sample size to account for a higher margin of error."),
                                        tags$li("Allocate additional sampling time to survey extra sites if needed. When designing the survey, be sure to generate replacement sites to use for oversampling.")),
                                      p("To aid the user, in the 'Survey Design tab' simulated population estimates using the local neighborhood variance estimator (uses a site's nearest neighbors to estimate variance, tending to result in smaller 
                                         variance values) will be calculated using the users defined sample sizes. This can give the user insight on the survey estimates potential margin of error if the sample size(s) chosen is used."),
                                      tags$li("For unstratified equal probability designs, set the desired Base site sample size."),
                                      tags$li("If you supplied a Stratum attribute, a tab is populated for each Stratum of the design."),
                                      tags$li("Set the sample size of Base sites you desire for each stratum."),
                                      tags$li("If you supplied a Category attribute, these categories will automatically populate. Choose the sample sizes for each. NOTICE: the sum of the sample sizes must equal the base site sample size."),
                                      tags$li("Choose the sample size of the Replacement Sites you desire, if any. Replacement sites are an additional set of sites that can be used to replace the main sample list sites when they are found to be non-target or inaccessible. When replacing a site with a replacement, the user must FOLLOW THE ORDER of the design output and select a replacement site of the same Stratum and Category, if used. If replacement sites are used improperly it may result in spatial imbalance. 
                                              The tool attempts to distribute the replacement sites proportionately among sample sizes for the Categories. If the replacement proportion for one or more Categories is not a whole number, the proportion is rounded to the next higher integer."),
                                      tags$li("Once your design has been prepared, click the 'Calculate Survey Design' button to be transported to the Survey Design Results tab.")
                                    ))),
                              bsCollapsePanel(title = h3(strong("Survey Design Tab")), value="survey",
                                    tags$ol(
                                      h4(strong("Survey Design")),
                                      tags$li("The process of calculating your Survey Design can take a while. The spinner will stop when your Survey Design is complete. If you have errors in your Design inputs, a message with the error will be displayed under 'Design Errors'. "),
                                      tags$li("A table of your Survey Design will appear if successful. A table will be displayed with totals of your sample sizes allocated across strata and categories, if used."),
                                      tags$li("The Population Estimate Simulation module can give the user insight on the survey estimates potential margin of error if the input sample size(s) are used. Condition classes assigned to each site are randomly selected using user specified probability weights. Typically, margin of error will decrease if the condition class distribution is unequally distributed.
                                               The user can choose the number of condition classes used, modify the probability of being selected, and refresh the simulation to view different condition scenarios. The user can adjust the sample size and refresh the design to determine an appropriate margin of error for the survey."),
                                      tags$li("Choose a Spatial Balance Metric. All spatial balance metrics provided have a lower bound of zero, which indicates perfect spatial balance. As the metric value increases, the spatial balance decreases. This is useful in comparing survey designs."),
                                      tags$li("Click the 'Download Survey Site Shapefile' button to download a zip file which contains a POINT shapefile of your designs survey sample sites."),
                                      tags$li("To download the design attributes table, use the buttons to choose how you would like it to be saved. Please note the Lat/Longs are transformed to WGS84 coordinate system. The xcoord and ycoord are the survey sites spatial geometry and can be used for the local neighborhood variance estimator when calculating population estimates."),
                                      h4(strong("Survey Map")),
                                      tags$li("The Survey Map tab provides an interactive and static map of the sample frame and the survey sample sites.")
                                    )),
                              bsCollapsePanel(title = h3(strong("Adjust Survey Weights Tab")), value="adjust",
                                    p("Adjusting initial survey design weights is necessary when implementation results in the use of replacement sites or when it is desired to have final weights sum to known frame size of the desired population. Adjusted weights are equal to initial weight * framesize/sum(initial weights). The adjustment is done separately for each 
                                      Category specified in Weighting Category input. The tool allows the user to manually enter a desired population Frame Size or an automated calculation of the frame size by totaling the initial weights and adjusting it by the users site Evaluation Status inputs. By using the automated method, the output will render two adjusted weights:"),
                                    tags$ul(
                                      tags$li(strong("WGT_TP_EXTENT")," - Weights based on the evaluation of all target and non-target probability sites. These weights are only used to estimate extent for target and non-target populations."),
                                      tags$li(strong("WGT_TP_CORE")," - Weights based on the evaluation of the target population based on sampled probability sites. These weights can be used to estimate condition for the 'target population'. Current NARS population estimates only use WGT_TP_CORE for all estimates related to condition.")
                                    ),
                                    p(tags$a(href="https://rdrr.io/cran/spsurvey/man/adjwgt.html", "Weights Adjustment Example", target= "_blank")),
                                    tags$ol(
                                      h4(strong("Weight Adjustment File Setup Examples")),
                                    fluidRow(column(4,
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
                                                             tags$td(align = "center", "Target-Replacement-Sampled"),
                                                           ), 
                                                           tags$tr(
                                                             tags$td(align = "center", "Site_03"),
                                                             tags$td(align = "center", "2"),
                                                             tags$td(align = "center", "Target-Access_Denied"),
                                                           ), 
                                                           tags$tr(
                                                             tags$td(align = "center", "Site_03_Replace"),
                                                             tags$td(align = "center", "2"),
                                                             tags$td(align = "center", "Target-Replacement-Sampled"),
                                                           ), 
                                                           tags$tr(
                                                             tags$td(align = "center", "Site_04"),
                                                             tags$td(align = "center", "2"),
                                                             tags$td(align = "center", "Target-Sampled-Additional"),
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
                                                   tags$td(align = "center", "Target-Replacement-Sampled"),
                                                 ), 
                                                 tags$tr(
                                                   tags$td(align = "center", "Site_03"),
                                                   tags$td(align = "center", "3rd Order"),
                                                   tags$td(align = "center", "4"),
                                                   tags$td(align = "center", "Target-Access_Denied"),
                                                 ), 
                                                 tags$tr(
                                                   tags$td(align = "center", "Site_03_Replace"),
                                                   tags$td(align = "center", "3rd Order"),
                                                   tags$td(align = "center", "4"),
                                                   tags$td(align = "center", "Target-Replacement-Sampled"),
                                                 ), 
                                                 tags$tr(
                                                   tags$td(align = "center", "Site_04"),
                                                   tags$td(align = "center", "1st Order"),
                                                   tags$td(align = "center", "2"),
                                                   tags$td(align = "center", "Target-Sampled-Additional"),
                                                 ))))),
                                      h4(strong("Weight Adjustment Inputs")),
                                      tags$li("Upload the file which contains the required weight adjustment inputs. See below for the descriptions of each input."),
                                      tags$li("Select the column which has the initial unadjusted weights for each site. The sum of these weights is how the tool calculates the frame size. You also have the option to input the frame size manually."),
                                      tags$li("Select the Weighting Category column used in an unequal survey design. Use 'None' if the design is an equal probability design and all sites are in the same category."),
                                      tags$li("Select the column which contains the Site Evaluation Attributes which categorically evaluate which sites are target and non-target sites and which have been sampled, including Replacement sites both as replacement and additional (e.g., Target-Sampled, Non-Target, Target-Landowner Denial, Target-Sampled-Additional). 
                                              These inputs aid in the automated calculation of the Frame Size used for both the TP_EXTENT and TP_CORE Weights. To manually enter the Frame Size by Category, ignore the 3 inputs below and click the 'Adjust the Frame Size Manually' radio button."),
                                      tags$ul(
                                        tags$li("Select the attribute(s) which indicate if the site was a Target site (Base and Replacement sites) and has been sampled. If available, this input should include additional Replacement sites which were added to the design and not used as replacement (e.g., Target-Sampled, Target-Sampled-Additional)."),
                                        tags$li("Select the attribute(s) which indicate if the site was a Target Replacement site added to the survey as an additional site and not as a replacement (e.g., Target-Sampled-Additional)."),
                                        tags$li("Select the attribute(s) which indicate if the site was a Non-Target site and was not sampled (e.g., Non-Target).")
                                      ),
                                      tags$li("Press the radio button if you wish to input the frame size manually. Based on if you entered a weighting category, the number of frame sizes needed will be generated. The adjusted weights will now be based on this Frame Size."),
                                      tags$li("Press the 'Calculate Adjusted Survey Weights' button for the adjusted weight output.")
                                    ))),
                                    hr(),
                                    h3(strong('Citation')),
                              tags$head(
                                tags$style(
                                  HTML("#citation {font-size: 14px;}"))),
                                    p("If you have used the Survey Design Tool to generate a survey used in publication or reporting, please reference the tool URL and cite the spsurvey package."),
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
                                               style = "font-weight: bold; font-size: 18px"), value='Step 2: Prepare Survey Design',
                                    sidebarPanel(
                                      
                                      h4(strong(HTML("<center>Select the Survey Sample Frame<center/>"))),
                                      #h5(strong(HTML("<center>Use Your Own Sample Frame<center>"))),
                                      
                                      # Input: Select sample frame files 
                                      fileInput(
                                        inputId = "filemap",
                                        label = strong("Choose all files of the Sample Frame"),
                                        multiple = TRUE,
                                        accept = c(".shp", ".prj", ".shx", ".dbf", ".sbn", ".sbx", ".cpg"), 
                                        width = "600px") %>%
                                        #User Sample Frame helper
                                        helper(type = "inline",
                                               title = "Survey Sample Frame",
                                               content = c("A Survey Sample Frame is an ESRI shapefile which contains geographic features represented by points, lines or polygons which is used in the selection of the sample. Maximum size is currently 10GB.",
                                                           "The coordinate reference system (CRS) for the sample frame should use projected coordinates. The user may choose to transform the CRS to NAD83 / Conus Albers (a projected CRS) by checking the box below.",
                                                           "<b>Required Files:</b>",
                                                           "<b>Shapefiles (.shp, .dbf, .prj, .shx)</b>"),
                                                           
                                               size = "s", easyClose = TRUE, fade = TRUE),
                                      checkboxInput(inputId = "NAD83", 
                                                    label= strong("Transform CRS to NAD83 / Conus Albers"), 
                                                    value = FALSE, 
                                                    width = NULL),
                                      
                                  #    h4(strong(HTML("<center><p>OR</p><center/>"))),
                                  #    h5(strong(HTML("<center>(Coming Soon!) <p> Subset A NARS Sample Frame By State</p></center>"))),
                                      # Choose NARS Sample Frame
                                      
                                #      radioButtons(inputId="narsframe", 
                                #                   label=strong("NARS Sample Frame"), 
                                 #                  choices=c("NRSA","NWCA", "NCCA", "NLA"), 
                                  #                 selected = FALSE,
                                   #                inline=TRUE) %>%
                                        #NARS Sample Frame helper
                                  #      helper(type = "inline",
                                   #            title = "National Aquatic Resource Surveys",
                                    #           content = c("<b>NRSA:</b> National Rivers and Streams Assessment",
                                     #                      "<b>NWCA:</b> National Wetland Condition Assessment",
                                      #                     "<b>NCCA:</b> National Coastal Condition Assessment",
                                       #                    "<b>NLA:</b> National Lakes Assessment"),
                                        #       size = "s", easyClose = TRUE, fade = TRUE),
                                      
                                    #  selectInput(inputId = "state",
                                    #              label = strong("Choose State(s) to Subset"),
                                    #              choices = c("", as.character(state_name)),
                                     #             selected = NULL,
                                     #             multiple = TRUE, 
                                     #             width = "300px"),
                                      
                                      hr(),
                                      h4(strong(HTML("<center>Design Attributes<center/>"))),
                                fluidRow(
                                  column(5,
                                      #Design Type Input
                                      radioButtons(inputId="designtype", 
                                                   label=strong("Choose Design Type"), 
                                                   choices=c("GRTS","IRS"),
                                                   inline=TRUE) %>%
                                        #Design Type helper
                                        helper(type = "inline",
                                               title = "Design Type",
                                               content = c("<b>GRTS:</b> Generalized Random Tessellation Stratified-for spatially balanced samples",
                                                           "<b>IRS:</b> Independent Random Sample- for non-spatially balanced samples"),
                                               size = "s", easyClose = TRUE, fade = TRUE))),
                                fluidRow(
                                  column(10,
                                      #Stratum Input
                                      selectInput(inputId = "stratum",
                                                  label = strong("Select Attribute Which Contains Strata"),
                                                  choices = "",
                                                  selected = NULL,
                                                  multiple = FALSE, 
                                                  width = "300px")  %>%
                                        #Strata helper
                                        helper(type = "inline",
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
                                        helper(type = "inline",
                                               title = "Multi-density Category",
                                               content = c("Variables found within a stratum used to define design weights for unequal probability selections. Use the default <b>None</b> if your design is an equal probability design.",
                                                           "<b>Examples:</b> Stream Order, Lake Area, Basin, Ecoregion"),
                                               size = "s", easyClose = TRUE, fade = TRUE))),
                                      checkboxInput(inputId = "addoptions", 
                                              label=strong("Optional Design Attributes"), 
                                              value = FALSE),
                                      uiOutput('addoptions'),
                                conditionalPanel(condition = "input.addoptions == 1",
                                      hr(),
                                      h4(strong(HTML("<center>Legacy Site Attributes<center/>"))),
                                      ####Legacy####
                                      uiOutput("legacyfile"),
                                
                                      uiOutput("legacyvar"),
                                      
                                      uiOutput('legacystrat'),
                                
                                      uiOutput('legacycat'),
                                
                                      uiOutput('legacyaux')),
                                
                                      hr(),
                                
                                      # Press button for analysis 
                                      actionButton("goButton", strong("Calculate Survey Design"), icon=icon("play-circle"), 
                                                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),#sidebarPanel
                                    mainPanel(
                                      uiOutput('mytabs')
                                      
                                    ) #mainPanel
                           ), #tabPanel (Prepare and Run Survey Design)
                           ####Design Results####
                           tabPanel(title=span(strong("Step 3: Survey Design Results"), 
                                               style = "font-weight: bold; font-size: 18px"),
                                    value="Step 3: Survey Design Results",
                                    sidebarPanel(
                                      conditionalPanel(condition = "output.error",
                                      h4(HTML("<center><b>Design Errors</b></center>"))),
                                      tableOutput("error"),
                                      conditionalPanel(condition = "output.table",
                                      hr(),                 
                                      h4(HTML("<center><b>Survey Site Summary</b></center>")),
                                        DT::dataTableOutput("summary")),
                                      conditionalPanel(condition = "output.summary",
                                      br(), hr(),
                                     h4(HTML("<center><b>Population Estimate Simulation</b></center>")) %>%
                                                         #Simulation helper
                                                         helper(type = "inline",
                                                                title = "Population Estimate Simulation",
                                                                content = c("This module assists the user in simulating proportion estimates of a population based on the sample size used in the survey design. Error bars displayed show the Margin of Error for a condition using a 95% confidence limit.
                                                            The condition classes are randomly assigned by user specified probability weights and can be refreshed with new probability weights to simulate the change in conditions. 
                                                            Adjust the sample size of the design to increase or decrease the Margin of Error estimate."),
                                                            size = "s", easyClose = TRUE, fade = TRUE),
                                     fluidRow(
                                       column(7, offset=3,
                                          radioButtons(inputId="connumber", 
                                                       label=strong("Choose Condition Class Size"), 
                                                       choices=c("2","3","4","5"), 
                                                       selected = "3",
                                                       inline=TRUE) %>%
                                        #Condition Class helper
                                        helper(type = "inline",
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
                                                       actionButton("ssbtn", strong("Refresh Simulation"), icon=icon("redo"), 
                                                                    style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
                                                       hr(),
                                      conditionalPanel(condition = "output.ssplot",
                                                       h4(HTML("<center><b>Design Spatial Balance</b></center>")) %>%
                                                         #Spatial Balance helper
                                                         helper(type = "inline",
                                                                title = "Spatial Balance",
                                                                content = c("All spatial balance metrics have a lower bound of zero, which indicates perfect spatial balance. As the metric value increases, the spatial balance decreases."),
                                                                size = "s", easyClose = TRUE, fade = TRUE),
                                                       verbatimTextOutput("balance", placeholder = TRUE) %>% withSpinner(color="#0275d8"),
                                                       actionButton("balancebtn", strong("Calculate Spatial Balance"), icon=icon("play-circle"), 
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
                                        helper(type = "inline",
                                               title = "Spatial Balance Metrics",
                                               content = c("<b>Pielou's Evenness Index</b> This statistic can take on a value between zero and one.",
                                                           "<b>Simpsons Evenness Index</b> This statistic can take on a value between zero and logarithm of the sample size.",
                                                           "<b>Root-Mean-Squared Error</b> This statistic can take on a value between zero and infinity.",
                                                           "<b>Mean-Squared Error</b> This statistic can take on a value between zero and infinity.",
                                                           "<b>Median-Absolute Error</b> This statistic can take on a value between zero and infinity.",
                                                           "<b>Mean-Absolute Error</b> This statistic can take on a value between zero and infinity.",
                                                           "<b>Chi-Squared Loss</b> This statistic can take on a value between zero and infinity."),
                                               size = "s", easyClose = TRUE, fade = TRUE)),
                                      
                                    ),#sidebarPanel
                                    mainPanel(
                                      tabsetPanel(
                                        tabPanel(strong("Design"),
                                                 mainPanel(
                                                   fluidRow(
                                                     column(12, offset= 3,
                                                    br(),
                                                   conditionalPanel(condition = "output.table",
                                                   h3(HTML("<center><b>Probability Survey Site Results</b></center>"))))),
                                                   br(),
                                                   fluidRow(
                                                     column(12, offset = 1, 
                                                      uiOutput("shp_btn"))),
                                                   br(),
                                                   DT::dataTableOutput("table"))),
                                        
                                        tabPanel(title=strong("Survey Map"),
                                                 br(),
                                                 conditionalPanel(condition = "output.ssplot",
                                                 h3(HTML("<center><b>Interactive and Static Maps</b></center>")),
                                                 fluidRow(
                                                  tags$head(tags$style(HTML("#maptype ~ .selectize-control.single .selectize-input {background-color: #FFD133;}"))),
                                                   selectInput(inputId = "maptype",
                                                                      label = strong("Select Type of Map"),
                                                                      choices = c("Interactive", "Static"),
                                                                      selected = NULL,
                                                                      multiple = FALSE, 
                                                                      width = "200px"), 
                                                   column(3, offset = 3,
                                                                  selectInput(inputId = "color",
                                                                              label = strong("Select Color Attribute"),
                                                                              choices = c("Site Use" = "siteuse", 
                                                                                          "Stratum" = "stratum", 
                                                                                          "Category" = "caty"),
                                                                              selected = "siteuse",
                                                                              multiple = FALSE, 
                                                                              width = "200px")),
                                                column(3, offset = 1,
                                                conditionalPanel(condition = "input.maptype == 'Static'",
                                                                  selectInput(inputId = "shape",
                                                                              label = strong("Select Shape Attribute"),
                                                                              choices = c("Site Use" = "siteuse", 
                                                                                          "Stratum" = "stratum", 
                                                                                          "Category" = "caty"),
                                                                              selected = "stratum",
                                                                              multiple = FALSE, 
                                                                              width = "200px")))),
                                                conditionalPanel(condition = "input.maptype == 'Interactive'",
                                                 leafletOutput("map", width="100%", height="70vh") %>% withSpinner(color="#0275d8")),
                                                conditionalPanel(condition = "input.maptype == 'Static'",
                                                 plotOutput("plot") %>% withSpinner(color="#0275d8"))) 
                                        )#tabPanel(Survey Map)
                                      )#tabsetPanel
                                    )#mainPanel
                           ),#tabPanel(Survey Design)
                           ####Adjust Weights####
                           tabPanel(title=span(strong("Step 4: Adjust Survey Weights"), 
                                               style = "font-weight: bold; font-size: 18px"), value="Step 4: Adjust Survey Weights",
                                    sidebarPanel(
                                      h4(strong(HTML("<center>Select the Weight Adjustment File<center/>"))),
                                      fileInput(
                                        inputId = "adjdata",
                                        label = strong("(Must be a .csv file)"),
                                        accept = c(".csv")) %>%
                                        #Weight file helper
                                        helper(type = "inline",
                                               title = "Weight Adjustment File",
                                               content = c("Choose the .csv file which contains all base sites which were given initial weights and replacement sites which were sampled. This should include all target sites sampled, replacement sites sampled (including additional sites used as oversamples), not evaluated and non-target sites which were sampled, but were given an initial weight.",
                                                           "<b>See Instructions For Use tab for examples on how to setup the Weight Adjustment File.</b>"),
                                               size = "s", easyClose = TRUE, fade = TRUE),
                                      hr(),
                                      h4(strong(HTML("<center>Set Adjustment Inputs<center/>"))),
                                      fluidRow(
                                        column(10,
                                      selectInput(inputId = "adjwgt",
                                                  label = strong("Select Attribute Containing Initial Site Weights"),
                                                  choices = "",
                                                  selected = NULL,
                                                  multiple = FALSE, 
                                                  width = "300px") %>%
                                        #Weight helper
                                        helper(type = "inline",
                                               title = "Site Weights",
                                               content = c("Choose the column in the Weight Adjustment file which contains the initial site weights. Replace Replacement sites with Base sites. Set additional Replacement site weights to 0."),
                                               size = "s", easyClose = TRUE, fade = TRUE),
                                      
                                      selectInput(inputId = "adjwgtcat",
                                                  label = strong("Select Attribute Containing Weighting Categories"),
                                                  choices = "",
                                                  selected = NULL,
                                                  multiple = FALSE, 
                                                  width = "300px") %>%
                                        #Weight Category helper
                                        helper(type = "inline",
                                               title = "Weight Category",
                                               content = c("For unequal probability designs, choose the column in the Weight Adjustment file which contains the weight category. The default is None, which assumes every site is in the same category and an equal probability design is being adjusted."),
                                               size = "s", easyClose = TRUE, fade = TRUE),
                                      
                                      selectInput(inputId = "adjsitesampled",
                                                  label = strong("Select Attribute Containing Site Evaluations"),
                                                  choices = "",
                                                  selected = NULL,
                                                  multiple = FALSE, 
                                                  width = "300px") %>%
                                        #Site Info helper
                                        helper(type = "inline",
                                               title = "Site Evaluation Attributes",
                                               content = c("Choose the column in the Weight Adjustment file which contains attributes defining if the site was sampled, not sampled, and/or non-target."),
                                               size = "s", easyClose = TRUE, fade = TRUE),
                                      hr(),
                                      strong(HTML("Select Site Evaluation Attribute(s)")) %>%
                                        #Site eval helper
                                        helper(type = "inline",
                                               title = "Site Evaluation Attributes",
                                               content = c("<b>Sampled Target Sites:</b> Choose the attribute which defines if the site was sampled and found to be member of the target population. This should also include additional sampled replacement sites.",
                                                           "<b>Additional Replacements:</b> Choose the attribute which defines if the site is a replacement site and was added to the design without replacing a base site.",
                                                           "<b>Non-Target Sites:</b> Choose the attribute which defines if the site was not sampled and found to NOT be a member of the target population.",
                                                           "<b>You are not required to input target sites which have not been sampled for reasons such as landowner denials, site was inaccessible, or not evaluated.</b>"),
                                               size = "s", easyClose = TRUE, fade = TRUE))),
                                      #Select Site Attribute(s) That Apply to Your Dataset
                                      column(12, offset = 1,
                                             selectInput(inputId = "sampled_site",
                                                         label = strong("Sampled Sites"),
                                                         choices = "",
                                                         selected = NULL,
                                                         multiple = TRUE,
                                                         width = "200px"), 
                                             selectInput(inputId = "addoversample_site",
                                                         label = strong("Additional Replacements"),
                                                         choices = "",
                                                         selected = NULL,
                                                         multiple = TRUE,
                                                         width = "200px"), 
                                             selectInput(inputId = "nontarget_site",
                                                         label = strong("Non-Target Sites"),
                                                         choices = "",
                                                         selected = NULL,
                                                         multiple = TRUE,
                                                         width = "200px")),
                                        checkboxInput(inputId = "frameadj", 
                                                    label= strong("Adjust the Weighting Category Frame Size Manually"), 
                                                    value = FALSE, 
                                                    width = NULL),
                                      hr(),
                                      uiOutput("frame"),
                                      
                                      # Press button for analysis 
                                      actionButton("adjButton", HTML("<b>Calculate Adjusted <br/> Survey Weights</b>"), icon=icon("play-circle"), 
                                                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                                      ), #sidebarPanel
                                    mainPanel(
                                      DT::dataTableOutput("adjtable"),
                                      
                                      uiOutput("table_download")
                                    )#mainPanel
                           )#tabPanel(Adjust Weights)
                ) #navbarPage
) #fluidPage


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
    
    att <- read.dbf(paste(uploaddirectory, shpdf$name[grep(pattern="*.dbf$", shpdf$name)], sep="/"))#,  delete_null_obj=TRUE)
    #We add a column called "None" with "None" values to handle designs without strata or categories.
    att <- att %>% mutate(None="None") %>% relocate(None)
  })
  
  sfobject <- reactive({
    req(input$filemap)
    shpdf <- input$filemap
    
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
  #   setwd(uploaddirectory)
  #   for(i in 1:nrow(shpdf)){
  #   file.rename(shpdf$datapath[i], shpdf$name[i])}
    setwd(previouswd)
    
    map <- st_read(paste(uploaddirectory, shpdf$name[grep(pattern="*.shp$", shpdf$name)], sep="/")) %>% 
      mutate(None="None") %>% relocate(None) #
    
    map <- st_zm(map)
  
  })
  
  #Identifies geometry type of sample frame for legacy inputs
 # legacytype <- eventReactive(input$filemap, {
 #   sfobject <- sfobject()
  #  geometry<-class(sfobject$geometry[[1]])
  #  strsplit(geometry," ")[[2]]
  #})
  
  
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
      mutate(None="None") %>% relocate(None) #%>% st_transform(crs = 5070)
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

  
  observe({
    req(!is.null(input$legacy_strat))
    legacy_cols <- legacyobject() %>% select_if(~!is.numeric(.x))
    updateSelectInput(session, "legacy_strat", selected = "", choices = colnames(legacy_cols))
  })
  
  observe({
    req(!is.null(input$legacy_cat))
    legacy_cols <- legacyobject() %>% select_if(~!is.numeric(.x))
    updateSelectInput(session, "legacy_cat", selected = "", choices = colnames(legacy_cols))
  })
  
  observe({
    req(!is.null(input$legacy_aux))
    legacy_cols <- legacyobject() %>% select_if(~!is.character(.x))
    updateSelectInput(session, "legacy_aux", selected = "", choices = colnames(legacy_cols))
  })
  
  #Stratum Length
  S <- reactive({
    req(input$stratum)
    if (input$stratum != "None") {
    dbfdata() %>% select(input$stratum) %>% arrange(input$stratum) %>% unique() %>% pluck(input$stratum) %>% n_distinct()
    } else {1
    }
  })
  
  #Category Length
  C <- reactive({
    req(input$caty)
    if (input$caty != "None") {
    dbfdata() %>% select(input$caty) %>% arrange(input$stratum) %>% unique() %>% pluck(input$caty) %>% n_distinct()
    } else {1
      }
  })
  
  strat_choices <- reactive({req(dbfdata())
    dbfdata() %>% select(input$stratum) %>% unique()
  })
  
  caty_choices <- reactive({req(dbfdata())
    dbfdata() %>% select(input$caty) %>% unique()
  })
  
  
  
  
  ####Legacy UI####
  output$legacyfile <- renderUI({
    req(input$addoptions==TRUE)
    fileInput(
      inputId = "legacy",
      placeholder = "Optional",
      label = HTML("<b>Choose all files of the Legacy Sites POINT Shapefile <br/> Required: (.shp, .dbf, .prj, .shx)</b>"),
      multiple = TRUE,
      accept = c(".shp", ".prj", ".shx", ".dbf", ".sbn", ".sbx", ".cpg"), 
      width = "600px") %>%
      #User legacy helper
      helper(type = "inline",
             title = "Legacy Sample Frame",
             content = c("Legacy Sample Frame is a POINT or MULTIPOINT shapefile which contains sites that have been selected in a previous probability sample and are to be automatically included in a current probability sample. If the users transforms the samples frames CRS to NAD83/Albers Conus, the legacy object will also be transformed."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  
  
   #Render selectInput if stratum name is NOT in design shapefiles column names.
  output$legacystrat <- renderUI({
    req(input$stratum != "None" && input$stratum %!in% colnames(legacyobject()))
    selectInput(inputId = "legacy_strat",
                label = strong("Select Stratum from Legacy File"),
                selected = "",
                multiple = FALSE,
                choices = colnames(legacyobject()),
                width = "200px") %>%
      helper(type = "inline",
             title = "Legacy Stratum",
             content = c("A Legacy Stratum is the same stratum used for a stratified design. This input is useful if the stratification variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  #Render selectInput if category name is NOT in design shapefiles column names.
  output$legacycat <- renderUI({
    req(input$caty != "None" && input$caty %!in% colnames(legacyobject()))
    selectInput(inputId = "legacy_cat",
                label = strong("Select Category from Legacy File"),
                selected = "",
                multiple = FALSE,
                choices = colnames(legacyobject()),
                width = "200px") %>%
      helper(type = "inline",
             title = "Legacy Category",
             content = c("A Legacy Category is the same category used for the unequal design. This input is useful if the category variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  #Render selectInput if auxiliary variable name is NOT in design shapefiles column names.
  output$legacyaux <- renderUI({
    req(input$addoptions==TRUE && input$aux_var != "None" && input$aux_var %!in% colnames(legacyobject()))
    selectInput(inputId = "legacy_aux",
                label = strong("Select Auxiliary Variable from Legacy File"),
                selected = "",
                multiple = FALSE,
                choices = colnames(legacyobject()),
                width = "200px") %>%
      helper(type = "inline",
             title = "Legacy Auxiliary",
             content = c("A Legacy Auxiliary variable is the same auxiliary variable used for the design. This input is useful if the auxiliary variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  
  
  ####Additional UI####
  output$addoptions <- renderUI({
    req(input$addoptions==TRUE)
    
    #DesignID Input
    fluidRow(
      column(6, offset=1,
      
      #Auxiliary variable input
      selectInput(inputId = "aux_var",
                label = strong("Auxiliary Variable"),
                choices = "",
                selected = NULL,
                multiple = FALSE, 
                width = "200px") %>%
      #Auxiliary variable helper
      helper(type = "inline",
             title = "Auxiliary Variable",
             content = c("Numeric attribute which represents the proportional (to size) inclusion probability variable (auxiliary variable). 
                         This selection type will result in an unstratified GRTS sample where each site in the sample frame has inclusion probability proportional to a positive, continuous variable. 
                         Larger values of the auxiliary variable result in higher inclusion probabilities."),
             size = "s", easyClose = TRUE, fade = TRUE),
      
      #Reproducible seed input
      numericInput("seed", strong("Set Reproducible Seed:"), rseed, width = "200px") %>%
        #Random Seed helper
        helper(type = "inline",
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
        helper(type = "inline",
               title = "DesignID",
               content = c("A character string indicating the naming structure for each site's identifier selected in the sample, which is included as a variable in the shapefile in the tools output."),
               size = "s", easyClose = TRUE, fade = TRUE),
      
    #Minimum Distance input
    numericInput(inputId = "mindist", 
                 label = strong("Minimum Distance"),
                 value = NA, min = NA, max = NA, width="200px") %>%
      #Minimum Distance helper
      helper(type = "inline",
             title = "Minimum Distance",
             content = c("A numeric value indicating the desired minimum distance between sampled sites. If design is stratified, then minimum distance is applied separately for each stratum. The units must match the units in the sample frame."),
             size = "s", easyClose = TRUE, fade = TRUE),
    
    #Maximum Attempts input
    numericInput(inputId = "maxtry", 
                 label = strong("Maximum Attempts"), 
                 value = 10, min = 0, max = NA, width="200px") %>%
      #Maximum Attempts helper
      helper(type = "inline",
             title = "Maximum Attempts",
             content = c("The number of maximum attempts to apply the minimum distance algorithm to obtain the desired minimum distance between sites. Each iteration takes roughly as long as the standard GRTS algorithm. Successive iterations will always contain at least as many sites satisfying the minimum distance requirement as the previous iteration. The algorithm stops when the minimum distance requirement is met or there are maximum attempt iterations. The default number of maximum iterations is 10."),
             size = "s", easyClose = TRUE, fade = TRUE),
    
    #Nearest neighbor input
    numericInput(inputId = "n_near", 
                 label = strong("Nearest Neighbor Replacement Sites"), 
                 value = NA, min = 1, max = 10, width="200px") %>%
      #n_near helper
      helper(type = "inline",
             title = "Nearest Neighbor Replacements",
             content = c("An integer from 1 to 10 specifying the number of nearest neighbor replacement sites to be selected for each base site. For infinite sample frames, the distance between a site and its nearest neighbor depends on point density. This tool does not offer stratum-specific nearest neighbor requirements."),
             size = "s", easyClose = TRUE, fade = TRUE)))
  })
  
  
  ####MainPanel UI####
  output$mytabs = renderUI({
    do.call(tabsetPanel, c(lapply(1:S(), function(s) {
      tabPanel(strong(paste0("Stratum: ", strat_choices()[s,1])),
               fluidRow(
                 column(2,
                        #Stratum Inputs
                        selectInput(inputId = paste0("strat",s),
                                    label = paste0("Stratum ",s),
                                    choices = strat_choices()[s,1],
                                    selected = "",
                                    multiple = FALSE) %>%
                          #Strata helper
                          helper(type = "inline",
                                 title = "Stratum",
                                 content = c("Choose a stratum which defines how your sample sites will be stratified.",
                                             "If your design is not stratified, use the default <b>None</b>."),
                                 size = "s", easyClose = TRUE, fade = TRUE)),
                 
                 column(2, 
                        #Stratum Base sample sizes
                          numericInput(inputId = paste0("strat",s,"_base"), 
                                       label = "Base Sites", 
                                       value = 0, min = 0, max = 10000) %>%
                          #Base helper
                          helper(type = "inline",
                                 title = "Base Sites",
                                 content = c("If the design is unstratified, <b>Base Sites</b> is the overall sample size of the survey. If your design is stratified, set the sample size for each strata."),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        numericInput(inputId = paste0("Over",s), 
                                     label = "Replacement Sites", 
                                     value = 0, min = 0, max = 10000) %>%
                          #Replacement helper
                          helper(type = "inline",
                                 title = "Replacement Sites",
                                 content = c("Define number of Replacement sites needed for a stratum.",
                                             "Replacement sites are a set of spatially balanced sites that can be used for the replacement of a non-target or inaccessible sites.
                                                Misuse can cause spatial imbalance in your survey."),
                                 size = "s", easyClose = TRUE, fade = TRUE)),
                       
                 # Stratum category sites
                 conditionalPanel(condition="input.caty != 'None'",
                 column(2, offset = 1,
                        #Panel 1 Category Inputs
                        lapply(1:C(), function(i) {
                          selectInput(inputId = paste0("S",s,"_C",i),
                                      label = paste0("Category ",i),
                                      choices = caty_choices()[i,1],
                                      selected = "",
                                      multiple = FALSE)
                        }) %>%
                          #Category helper
                          helper(type = "inline",
                                 title = "Multi-density Categories",
                                 content = c("Name and set the sample size of each Category.",
                                             "<b>Note:</b> The total sample size defined in category inputs must equal the total sample size defined in the Base input."),
                                 size = "s", easyClose = TRUE, fade = TRUE)),
                 column(2,
                        lapply(1:C(), function(i) {
                          numericInput(inputId = paste0("S",s,"_C",i,"_Site"), 
                                       label = paste0("Category ",i," Sites"), 
                                       value = "0", min = 0, max = 100000)
                        })
                 ))
          )#fluidrow
        )#tabPanel
    }))#stratum apply  
    ) #tabsetPanel
  })#renderUI
  
  
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

####Design####
  DESIGN <- eventReactive(input$goButton,{
    
    
    #Validates there is a complete sample frame added
    CRS <- st_crs(sfobject())
    
    validate(
      need(input$filemap != FALSE, 
           "Please input a Sample Frame."),
      need(!is.na(CRS),  
           "Please input the required file .prj of the sample frame.")
    )
    
    show_modal_spinner(spin = 'flower', text = 'Grab a snack...this could take a while.')
    
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
        strata_n <- input$strat1_base
    #Stratified
    } else {
        stratum_var <- input$stratum
    #Creates Stratum named vector
        strata_n <- c() #empty vector
      for(i in 1:S()) {
        strata_n[[paste0("strat", i)]] = input[[paste0("strat",i,"_base")]]
    #Renames vectors
        name<-input[[paste0('strat',i)]]
        names(strata_n)[i] <- name
      }
        strata_n <- unlist(strata_n)
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
          for (x in 1:C()) {
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
        
        #Unstratified, Unequal Probability
    } else {
        caty_var <- input$caty
        #Creates Category named vector
        caty_n <- c() #empty vector
        for(x in 1:C()) {
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
    
    #Equal Probability
      if(input$stratum == "None" && input$caty == "None") {
      replace_n <- input$Over1
      #Stratified Equal Probability
    } else if (input$stratum != "None" && input$caty == "None") {
      #Creates Replacement sites List
      replace_n <- list()
      for(i in 1:S()) {
        replace_n[[paste0("Over", i)]] = input[[paste0('Over',i)]]
        stratname <- input[[paste0("strat", i)]]
        names(replace_n)[i] <- stratname
      }
      #Unstratified Unequal Probability
    } else if(input$stratum == "None" && input$caty != "None") {
      #Creates replacement named vector
      replace_n <- c() #empty vector
      for(x in 1:C()) {
        replace_n[[paste0("caty", x)]] = input$Over1
        #Renames vectors
        catname <- input[[paste0("S1_C",x)]]
        names(replace_n)[x] <- catname
      }
      replace_n <- unlist(replace_n)
      #Stratified Unequal Probability (Where n_over changes among strata) 
    } else if (input$stratum != "None" && input$caty != "None" && length(unique(replace_con)) != 1) {
      #Creates replacement List
      replace_n <- list() #empty list
      for(i in 1:S()) {
        for (x in 1:C()) {
          replace_n[[paste0("strat", i)]][paste0("S",i, "_C",x)] = input[[paste0('Over',i)]]
          #Renames Category names in list
          catname <- input[[paste0("S",i,"_C",x)]]
          names(replace_n[[i]])[x] <- catname
        }
      }
      #Renames Strata names in Replacement list
      for(i in 1:S()) {
        stratname <- input[[paste0("strat", i)]]
        names(replace_n)[i] <- stratname
      }
    #Stratified Unequal Probability (Where n_over DOES NOT change among strata) 
    } else  {
      replace_n <- c() #empty vector
      for(x in 1:C()) {
        replace_n[[paste0("caty", x)]] = input$Over1
        #Renames vectors
        catname <- input[[paste0("S1_C",x)]]
        names(replace_n)[x] <- catname
      }
      replace_n <- unlist(replace_n)
    } 
    
    #Replacement input cannot be 0, this handles this instance by adding all oversamples and checks if its over 0
    for(i in 1:S()) {
      total <- 0
      over <- total + input[[paste0('Over',i)]]
    }
    if (over == 0) {
      replace_n <- NULL
    }
 
    ####Legacy Conditionals####    

    if(!is.null(input$legacy) && input$NAD83 == TRUE) {
      legacyobject <- legacyobject()
      legacyobject <- st_transform(legacyobject, crs = 5070)
    } else if(!is.null(input$legacy)) {
      legacyobject <- legacyobject()
    } else {
      legacyobject <- NULL
    }
    
    if(!is.null(input$legacy_strat)) {
      legacy_strat <- input$legacy_strat
    } else {
      legacy_strat <- NULL
    }
    
    if(!is.null(input$legacy_cat)) {
      legacy_cat <- input$legacy_cat
    } else {
      legacy_cat <- NULL
    }
    
    if(!is.null(input$legacy_aux)) {
      legacy_aux <- input$legacy_aux
    } else {
      legacy_aux <- NULL
    }
    
    ####Additional Attribute Conditionals####
    aux_var <- NULL
    mindist <- NULL
    maxtry <- 10
    n_near <- NULL
    DesignID <- "Site"
    
    if (input$addoptions == TRUE && input$aux_var != "None") {
      aux_var <- input$aux_var
    }
    if (input$addoptions == TRUE && !is.na(input$mindist)) {
      mindist <- input$mindist
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
    
    sfobject <- sfobject()
    
    if(input$NAD83 == TRUE) {
      sfobject <- st_transform(sfobject, crs = 5070)
    }
    
    
    #Removes stop_df if calculate button has been previously pressed
    if(exists('stop_df')) {
    rm('stop_df', envir=.GlobalEnv)
    }
   
    if(input$designtype=="GRTS") {
    design <- try(grts(sfobject,
                       n_base = strata_n,
                       stratum_var = stratum_var,
                       caty_var = caty_var,
                       caty_n = caty_n,
                       n_over = replace_n,
                       aux_var = aux_var,
                       #legacy_var = legacy_var,
                       legacy_sites = legacyobject,
                       legacy_stratum_var = legacy_strat,
                       legacy_caty_var = legacy_cat,
                       legacy_aux_var = legacy_aux,
                       mindis = mindist,
                       maxtry = maxtry,
                       n_near = n_near,
                       DesignID = DesignID))
    }

    else {
    design <- try(irs(sfobject,
                      n_base = strata_n,
                      stratum_var = stratum_var,
                      caty_var = caty_var,
                      caty_n = caty_n,
                      n_over = replace_n,
                      aux_var = aux_var,
                      #legacy_var = legacy_var,
                      legacy_sites = legacyobject,
                      legacy_stratum_var = legacy_strat,
                      legacy_caty_var = legacy_cat,
                      legacy_aux_var = legacy_aux,
                      mindis = mindist,
                      maxtry = maxtry,
                      n_near = n_near,
                      DesignID = DesignID))
    }
    
        remove_modal_spinner()
        
      #If grts or irs is unsuccessful, reactive returns error message data frame (stop_df)
      if(exists('stop_df')){
          stop_df
      #If grts or irs is unsuccessful, reactive returns list (design)
       } else {
          design
       }
        
  })
  
  
  ####Design Errors####
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
      fluidRow(
        splitLayout(
      numericInput(inputId = "CON2", 
                 label = "Good Probability (%)", 
                 value = 50, min = 0, max = 100., width = "80px"),
      numericInput(inputId = "CON4", 
                 label = "Poor Probability (%)", 
                 value = 50, min = 0, max = 100, width = "80px")))
    } else if(input$connumber == "3") {
      fluidRow(
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
      fluidRow(
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
      fluidRow(
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
  samplesize <- eventReactive(c(input$ssbtn, input$conflim, input$goButton), {
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
    
    avgMOE <- mean(cat_ests$MarginofError.P)
    avgMOE <- round(cat_ests$MarginofError.P, 0)
    nResp <- sum(cat_ests$nResp)
    #Create Plots
    plot <- ggplot(cat_ests, aes(x = Category, y = Estimate.P)) +
      geom_bar(aes(fill = Category, color = Category), alpha = 0.5, stat="identity", position = position_dodge()) +
      geom_errorbar(aes(ymin = LCB, ymax = UCB, color = Category), size=2, width=0) +
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
    req(input$caty == "None")
    
    if(input$stratum != "None") {
      sp_balance(DESIGN()$sites_base, sfobject(), stratum_var = input$stratum, metrics = input$balance)
    } else {
      sp_balance(DESIGN()$sites_base, sfobject(), metrics = input$balance)  
    } 
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
      callback=JS('$("button.buttons-copy").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-csv").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-excel").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-pdf").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-print").css("background","#337ab7").css("color", "#fff");
                   return table;'),
      extensions = c("Buttons"),
      rownames = FALSE,
      options = list(dom = 'Bfrtip',
                     buttons = list(
                       list(extend = 'copy', filename = paste("Survey_Design_", Sys.Date(), sep="")),
                       list(extend = 'csv', filename = paste("Survey_Design_", Sys.Date(), sep="")),
                       list(extend = 'excel', filename = paste("Survey_Design_", Sys.Date(), sep="")),
                       list(extend = 'pdf', filename = paste("Survey_Design_", Sys.Date(), sep="")),
                       list(extend = 'print', filename = paste("Survey_Design_", Sys.Date(), sep="")))
      ))
   })
  
  ####Download Shapefile####
  output$shp_btn <- renderUI({
    req(!is.data.frame(DESIGN()))
    #req(DESIGN())
    downloadButton("download_shp", HTML("Download Survey <br/> Site Shapefile"), icon=icon("compass"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
    })
  
  
  output$download_shp <- downloadHandler(
      filename <- function() {
        paste(format(Sys.Date(), "%Y-%m-%d"), "_Survey_Design.zip", sep="")
        
      },
      content = function(file) {
          tmp.path <- dirname(file)
          
          name.base <- file.path(tmp.path, "Survey_Sites")
          name.glob <- paste0(name.base, ".*")
          name.shp  <- paste0(name.base, ".shp")
          name.zip  <- paste0(name.base, ".zip")
          
          if (length(Sys.glob(name.glob)) > 0) file.remove(Sys.glob(name.glob))
          DES_SD <- sp_rbind(DESIGN())
          DES_SD <- DES_SD %>% filter(!(is.na(wgt))) %>% select(-None) %>% 
            mutate(xcoord = unlist(map(DES_SD$geometry, 1)),
                   ycoord = unlist(map(DES_SD$geometry, 2)), .after = lat_WGS84) 
          
          st_write(DES_SD, dsn = name.shp, ## layer = "shpExport",
                       driver = "ESRI Shapefile", quiet = TRUE)
         
          zip::zipr(zipfile = name.zip, files = Sys.glob(name.glob))
          req(file.copy(name.zip, file))
          
          if (length(Sys.glob(name.glob)) > 0) file.remove(Sys.glob(name.glob))
      }  
    )
  
  ####Mapping####

  output$map <- renderLeaflet({
    req(input$goButton, DESIGN())
    
    surveypts <- sp_rbind(DESIGN())
    surveypts <- surveypts %>% filter(!(is.na(stratum))) %>% filter(!(is.na(caty))) %>%
      st_transform(CRS("+proj=longlat  +datum=WGS84"))
    
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
      st_transform(CRS("+proj=longlat  +datum=WGS84")) 
    
    m<-mapview(surveypts, zcol = input$color, burst = TRUE)
    
    
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
  
  
  output$plot <- renderPlot({
    req(input$goButton, DESIGN())
    
    surveypts <- sp_rbind(DESIGN())
    surveypts <- surveypts %>% filter(!(is.na(stratum))) %>% filter(!(is.na(caty)))
    
    sfobject <- sfobject()
    
    plot<-ggplot()+
      geom_sf(data = sfobject, color = "blue", fill = "blue") +
      geom_sf(data = surveypts, aes_string(color=input$color, shape=input$shape), size=5) +
      scale_color_viridis_d() +
      xlab("Latitude") + ylab("Longitude") +
      labs(color = input$color, shape = input$shape) +
      annotation_scale(location = "bl", width_hint = 0.5) + 
      annotation_north_arrow(location = "tr", height = unit(3, "cm"),
                             width = unit(3, "cm"), which_north = "true", 
                             style = north_arrow_fancy_orienteering) + 
      theme(text=element_text(family="serif"),
            axis.text=element_text(color="#000000", size = 18, face="bold"),
            axis.title=element_text(face="bold", size = 20),
            legend.text = element_text(size=16),
            legend.title = element_text(size=18, face="bold"),
            legend.margin=margin(),
            panel.grid.major = element_line(color = gray(0.5), 
                                            linetype = "dashed", size = 0.5), 
            panel.background = element_rect(fill = "aliceblue"))
    print(plot)
  }, height = 900, width = 900)  
  
  
  ####Weight Adjustment####
  adjdata <- reactive({
    adj<-read.csv(req(input$adjdata$datapath))
  })
  
  
  #Adjustment Weight Input
  observeEvent(adjdata(), {
    adj_cols <- adjdata() %>% select_if(~is.numeric(.x)) 
    updateSelectInput(session, "adjwgt", selected = NULL, choices = c("Required" = "", colnames(adj_cols)))
  })
  
  #Adjustment Weight Category Input
  observeEvent(adjdata(), {
    adj_cols <- adjdata() %>% select_if(~!is.numeric(.x)) 
    updateSelectInput(session, "adjwgtcat", selected = NULL, choices = c("None", colnames(adj_cols)))
  })
  
  #Adjustment Site Input
  observeEvent(adjdata(), {
    adj_cols <- adjdata() %>% select_if(~!is.numeric(.x)) 
    updateSelectInput(session, "adjsitesampled", selected = NULL, choices = c("Required" = "", colnames(adj_cols)))
  })
  
  #Sites Sampled Reactive
  sampled_choices <- reactive({ 
    adjdata() %>% select(input$adjsitesampled) %>% unique()
  })
  
  
  #Sites sampled Events
  observeEvent(input$adjsitesampled, {
    updateSelectInput(session,'sampled_site', selected = NULL, choices = c("Required" = "", sampled_choices()))
    })
  
  #Additional Oversample sampled Events
  observeEvent(input$adjsitesampled, {
    updateSelectInput(session,'addoversample_site', selected = NULL, choices = c(sampled_choices()))
  })
  
  #Sites sampled Events
  observeEvent(input$adjsitesampled, {
    updateSelectInput(session,'nontarget_site', selected = NULL, choices = c(sampled_choices()))
  })
  
  catname <- reactive({ 
    adjdata() %>% pluck(input$adjwgtcat) %>% unique()
  })
  
  output$frame <- renderUI({
    req(input$frameadj==TRUE)
    
    if (input$adjwgtcat != "None") {
    lapply(catname(), function(i) {
         numericInput(
              inputId=paste0("CAT_", i),
              label=paste0(i, "-Frame Size"),
              value=0,
              width = "200px")
       })
    } else {
      numericInput(
        inputId = "CAT_1",
        label = "Frame Size",
        value = 0,
        width = "200px")
    }
  })
  
  output$table_download <- renderUI({
    req(adjbutton())
  downloadButton("adjdownload", HTML("<b>Download Adjusted <br/> Weights Table</b>"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
})
  
  #Weight Adjustment
  adjbutton <- eventReactive(input$adjButton,{
    validate(
      need(input$adjwgt != "", 
           "Please input initial site weights."),
      need(input$adjsitesampled != "", 
           "Please input site evaluations."),
      need(input$sampled_site != "", 
           "Please input attribute(s) which indicate site has been sampled."),
      )
    
    adjdata <- adjdata() %>% mutate(None = "None")
    
    wgt <- adjdata %>% pluck(input$adjwgt)
    
    if (input$adjwgtcat == "None") {
      wtcat <- NULL
    } else {
    wtcat <- adjdata %>% pluck(input$adjwgtcat)
    }
    
    
    sites <- adjdata %>% 
      mutate(SITES_SAMPLED = case_when(.data[[input$adjsitesampled]] %in% .env$input$sampled_site ~ TRUE,
                                       TRUE ~ FALSE)) %>% pluck("SITES_SAMPLED") 
    
    #Calculate Sample Frame Size
    if (input$frameadj == FALSE) {
      tpextentframesize <- adjdata %>% 
        filter(!(.data[[input$adjsitesampled]] %in% .env$input$addoversample_site)) %>%
        group_by(.data[[input$adjwgtcat]]) %>% 
        summarize(SUM = sum(.data[[input$adjwgt]])) %>%
        pivot_wider(names_from = .data[[input$adjwgtcat]], values_from = "SUM") %>% unlist()
      
      tpcoreframesize <- adjdata %>% 
        filter(!(.data[[input$adjsitesampled]] %in% c(.env$input$nontarget_site, .env$input$addoversample_site))) %>%
        group_by(.data[[input$adjwgtcat]]) %>% 
        summarize(SUM = sum(.data[[input$adjwgt]])) %>%
        pivot_wider(names_from = .data[[input$adjwgtcat]], values_from = "SUM") %>% unlist()
      
      
      WGT_TP_EXTENT <- adjwgt(wgt, wtcat, tpextentframesize, sites)
      WGT_TP_CORE <- adjwgt(wgt, wtcat, tpcoreframesize, sites)
      
      df <- cbind(adjdata, WGT_TP_EXTENT, WGT_TP_CORE)
    }
    else {
      if(input$adjwgtcat != "None") {
      datalist <- list()
      for (n in catname()) {
        framesize <- input[[paste0("CAT_",n)]]
        datalist[[n]] <- framesize
      } 
      framesize <- do.call(cbind.data.frame, datalist)
      framesize <- unlist(framesize)
     
      ADJWGT <- adjwgt(wgt, wtcat, framesize, sites)
      
      #adjdata <- adjdata()
      df <- cbind(adjdata, ADJWGT)
      } else {
      framesize <- input$CAT_1
      ADJWGT <- adjwgt(wgt, wtcat, framesize, sites)
      df <- cbind(adjdata, ADJWGT)
      }
    }
    
    df <- df %>% select(!(None))
    df
    
  })
  
  
  output$adjtable <- renderDataTable({
    adjbutton() 
  })
  
  output$adjdownload <- downloadHandler(
    filename = function() {
      paste("Survey_adjwgts_", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(adjbutton(), file, row.names = FALSE)
    })
  
  session$onSessionEnded(stopApp) 
}
# shinyApp()
shinyApp(ui = ui, server = server)
