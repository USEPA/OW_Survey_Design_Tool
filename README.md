# OW_Survey_Design_Tool
This R Shiny app allows for the calculation of spatially balanced survey designs of point, linear, or areal resources (i.e. lakes, streams, wetlands and coastal resources) using 
the Generalized Random-Tessellation Stratified (GRTS) algorithm (Stevens and Olson 2004). The tool utilizes functions found within the R package, spsurvey: Spatial Sampling Design 
and Analysis and presents an easy-to-use user interface for many sampling design features including stratification, unequal and proportional inclusion probabilities, replacement 
(oversample) sites, and legacy (historical) sites.
The output of the Survey Design Tool contains sampling locations designed and balanced by user specified inputs and allows the user to export these locations as a point shapefile 
or a flat file. The output also provides design weights which can be used in categorical and continuous variable analyses (i.e., population estimates). The tool also gives the 
user the ability to adjust initial survey design weights when implementation results in the use of replacement sites or when it is desired to have final weights sum to a known 
frame size. 
For further survey design discussion and use cases, review the spurvey vignette for Spatially Balanced Sampling and the website for EPAs National Aquatic Resource Surveys (NARS) 
which are designed to assess the quality of the nation's coastal waters, lakes and reservoirs, rivers and streams, and wetlands using GRTS survey designs. 
For Survey Design Tool questions, bugs, feedback, or tool modification suggestions, please contact Garrett Stillings at: Stillings.Garrett@epa.gov. 
