library(shiny)
library(spsurvey)
library(janitor)
library(DT)
library(zip)
library(foreign)
library(sf)
library(leaflet)
library(mapview)
library(ggspatial)
library(bslib)
library(shinybusy)
library(shinycssloaders)
library(shinyhelper)
library(shinyBS)
library(dplyr)
library(ggplot2)
library(purrr)
library(tidyr)
library(stringr)
library(shinyjs)

rseed <- sample(10000,1)
#state_name <- state.name

#Allows the upload of large files
options(shiny.maxRequestSize = 10000*1024^2)
#Creates new operator %!in%
`%!in%` <- Negate(`%in%`)