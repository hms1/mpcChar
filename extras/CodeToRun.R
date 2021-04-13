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

library(determinePC)

# Set up output and storage folders
options(andromedaTempFolder = str_c(getwd(),"/tmp"))

outputFolder <- file.path(getwd(),"results")
dir.create(outputFolder)

# Specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "/home/cbj/temp")

dbms <- "sql server"
user <- 'cbj'
pw <- 'qwer1234!@'
server <- '128.1.99.58'
port <- 1433
# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# For Oracle: define a schema that can be used to emulate temp tables:
cdmDatabaseSchema <- 'CDMPv532.dbo'
# Add a sharebale name for the database containing the OMOP CDM data
cdmDatabaseName <- 'AUSOM'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'cohortDB.dbo'
databaseId <- "AUSOM"
databaseName <- "AUSOM"
databaseDescription <- "AUSOM"


# Table names. regimenIngredientsTable should match the table created by OncologyRegimenFinder
cohortTable <- "bayer_determinePC_p"
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
  createCohorts = T,
  createCohortTable = T,
  runCharacterization = T,
  getTreatmentInfo = T,
  minCount = minCount
)
