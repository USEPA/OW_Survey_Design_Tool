# Survey Design Tool
*Current version: 1.0.2 Last updated: 3/28/2022
## How to Launch the Tool
* To launch, download the file <b>app.R</b> and open the file in RStudio for local app deployment. RStudio will recognize the Shiny script and provide a Run App button at the top of the editor pane (look for the green play triangle).
     * <b>Note:</b> Requires the R package <b>spsurvey Version <span>&#8805;</span>5.1.0</b>.
* We are currently working on deploying the app on a cloud infrastructure which will allow users to access and run the the tool via a web browser. Please check back for updates.

## Overview
This R Shiny app presents an easy-to-use user interface for the calculation of spatially balanced survey designs of point, linear, or areal resources (i.e. lakes, streams, wetlands and coastal resources) using the Generalized Random-Tessellation Stratified (GRTS) algorithm ([Stevens and Olsen 2004](https://cfpub.epa.gov/ncer_abstracts/index.cfm/fuseaction/display.files/fileID/13339)). The tool utilizes functions found within the R package, [spsurvey: Spatial Sampling Design and Analysis](https://cran.r-project.org/package=spsurvey) and contains many sampling design features including stratification, unequal and proportional inclusion probabilities, replacement (oversample) sites, and legacy (historical) sites.

The output of the Survey Design Tool contains sampling locations which are designed and balanced by user specified inputs and allows the user to export these locations as a point shapefile or a flat file. The output provides design weights which can be used in categorical and continuous variable analyses (i.e., population estimates). The tool also gives the user the ability to adjust initial survey design weights when implementation results in the use of replacement sites or when it is desired to have the final weights sum to a known frame size. 

* For further survey design discussion and use cases, review the spsurvey vignette for [Spatially Balanced Sampling](https://cran.r-project.org/web/packages/spsurvey/vignettes/sampling.html) and EPAs [National Aquatic Resource Surveys (NARS)](https://www.epa.gov/national-aquatic-resource-surveys) which are designed to assess the quality of the nation's rivers and streams, lakes and reservoirs, wetlands, and coastal waters using GRTS survey designs. 
* For Survey Design Tool questions, bugs, feedback, or tool modification suggestions, please contact Garrett Stillings at: Stillings.Garrett@epa.gov. 

## Disclaimer
The United States Environmental Protection Agency (EPA) GitHub project code is provided on an "as is" basis and the user assumes responsibility for its use.  EPA has relinquished control of the information and no longer has responsibility to protect the integrity , confidentiality, or availability of the information.  Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by EPA.  The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity by EPA or the United States Government.
