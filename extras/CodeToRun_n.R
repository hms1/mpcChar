## determinePc depends on the following package versions:
# DatabaseConnector (>= 3.0.0),
# SqlRender (>= 1.6.8),
# dplyr (>= 1.0.2),
# purrr (>= 0.3.4),
# readr (>= 1.4.0),
# tidyr (>= 1.1.2),
# stringr (>= 1.4.0),
# lubridate (>= 1.7.9),
# survival (>= 2.43-1)
# ggfortify
#survminer

library(determinePC)
library(ggfortify)
library(dplyr)

# Set up output and storage folders
options(andromedaTempFolder = str_c(getwd(),"/tmp"))

outputFolder <- file.path(getwd(),"results_n2")
dir.create(outputFolder)

# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "redshift",
  server = paste0(Sys.getenv("ONCO_SERVER"),"/prod_oncoemr"),
  user = "asiapos@uk.imshealth.com",#Sys.getenv("REDSHIFT_USER"),
  password = Sys.getenv("REDSHIFT_PASSWORD"),
  port = "5439")

# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL


cohortDatabaseSchema <- "study_reference"
cdmDatabaseSchema <- "full_201909_omop_v5"


# Table names. regimenIngredientsTable should match the table created by OncologyRegimenFinder
cohortTable <- "bayer_determinePC_new3"
regimenIngredientsTable <- "pc_90_regimen_ingredients"

# The minimum count reported in the results. Any count less than this will be masked
minCount <- 5

determinePC::execute(
  connection = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  vocabularyDatabaseSchema = cdmDatabaseSchema,
  cohortDatabaseSchema = cohortDatabaseSchema,
  regimenIngredientsTable = regimenIngredientsTable,
  cohortTable = cohortTable,
  oracleTempSchema = NULL,
  outputFolder = outputFolder,
  createCohorts = F,
  createCohortTable = F,
  runCharacterization = F,
  getTreatmentInfo = T,
  minCount = minCount
)
