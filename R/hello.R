execute <- function(connectionDetails,
                    cdmDatabaseSchema,
                    vocabularyDatabaseSchema,
                    cohortDatabaseSchema,
                    cohortTable,
                    regimenIngredientsTable,
                    oracleTempSchema = NULL,
                    outputFolder,
                    createCohorts = T,
                    createCohortTable = T,
                    runCharacterization = T,
                    getTreatmentInfo = T,
                    minCount = 5) {

  connection <- DatabaseConnector::connect(connectionDetails)

  if(createCohorts){

    createCohorts(
      connection = connection,
      cdmDatabaseSchema = cdmDatabaseSchema,
      vocabularyDatabaseSchema = vocabularyDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      oracleTempSchema = oracleTempSchema,
      outputFolder = outputFolder,
      createTable = createCohortTable)

    yearly_counts <- IncidencePC(connection = connection,
                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                 vocabularyDatabaseSchema = cdmDatabaseSchema,
                                 cohortDatabaseSchema = cohortDatabaseSchema,
                                 cohortTable = cohortTable,
                                 oracleTempSchema = oracleTempSchema,
                                 outputFolder = outputFolder)

    write.csv(yearly_counts, file.path(outputFolder, "IncidencePC.csv"))

    sql <- "DELETE FROM @cohort_database_schema.@cohort_table WHERE cohort_start_date < DATEFROMPARTS(2010,01,01);"
    sql <- SqlRender::render(sql,
                             cohort_database_schema = cohortDatabaseSchema,
                             cohort_table = cohortTable)
    sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))
    DatabaseConnector::executeSql(connection, sql)

  }

  if(runCharacterization){

    ParallelLogger::logInfo("Running characterization")

    temporalCovariateSettings <- FeatureExtraction::createTemporalCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = TRUE,
      useDemographicsAgeGroup = TRUE,
      useDemographicsRace = TRUE,
      useDemographicsEthnicity = TRUE,
      useDemographicsPriorObservationTime = TRUE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsIndexYearMonth = TRUE,
      useConditionEraGroupOverlap = TRUE,
      useDrugEraOverlap = TRUE,
      useDrugEraGroupOverlap = TRUE,
      useProcedureOccurrence = TRUE,
      useDeviceExposure = TRUE,
      useMeasurement = TRUE,
      useMeasurementValue = TRUE,
      useObservation = TRUE,
      useVisitConceptCount = TRUE,
      temporalStartDays = c(-730,0),
      temporalEndDays = c(-1,99999)
    )

    counts <- readr::read_csv(file.path(outputFolder, "CohortCounts.csv"))

    characteristics <- purrr::map(
      split(counts, counts$cohortDefinitionId),
      ~getCohortCharacteristics(
        connectionDetails = NULL,
        connection = connection,
        cdmDatabaseSchema = cdmDatabaseSchema,
        oracleTempSchema = NULL,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        cohortId = .x$cohortDefinitionId,
        covariateSettings = temporalCovariateSettings,
        minCellCount = minCount
      )
    )

    purrr::map(characteristics, ~.x$continuousCovs) %>%
      bind_rows(.id = "cohortDefinitionId") %>%
      readr::write_csv(file.path(outputFolder, "continuousCovs.csv"))

    purrr::map(characteristics, ~.x$binaryCovs) %>%
      bind_rows(.id = "cohortDefinitionId") %>%
      readr::write_csv(file.path(outputFolder, "binaryCovs.csv"))

    purrr::map(characteristics, ~.x$covariateRef) %>%
      bind_rows %>%
      distinct %>%
      readr::write_csv(file.path(outputFolder, "covariateRef.csv"))

    ### Cancer not prostate
    temporalCovariateSettings <- FeatureExtraction::createTemporalCovariateSettings(
      useConditionEraGroupOverlap = TRUE,
      includedCovariateConceptIds = c(439392),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(200962),
      addDescendantsToExclude = TRUE,
      temporalStartDays = c(-730,0),
      temporalEndDays = c(-1,99999)
    )

    neoplasms <- purrr::map(
      split(counts, counts$cohortDefinitionId),
      ~getCohortCharacteristics(
        connectionDetails = NULL,
        connection = connection,
        cdmDatabaseSchema = cdmDatabaseSchema,
        oracleTempSchema = NULL,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        cohortId = .x$cohortDefinitionId,
        covariateSettings = temporalCovariateSettings,
        minCellCount = minCount
      )
    )

    purrr::map(neoplasms, ~.x$binaryCovs) %>%
      bind_rows(.id = "cohortDefinitionId") %>%
      readr::write_csv(file.path(outputFolder, "binaryCovsOtherNeoplasms.csv"))

  }

  if(getTreatmentInfo){

    generate_ranges_psa(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask = minCount) %>%
      readr::write_csv(file.path(outputFolder, "psa_baseline_ranges.csv"))

    generate_number_psa(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask = minCount) %>%
      readr::write_csv(file.path(outputFolder, "numberPsa.csv"))

    formatted_regimens <- pull_regimen_data(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask = minCount)

    generate_population_summary(formatted_regimens) %>%
      readr::write_csv(file.path(outputFolder, "population_summary.csv"))

    generate_stats_by_line(formatted_regimens, count_mask = minCount) %>%
      readr::write_csv(file.path(outputFolder, "stats_by_line.csv"))

    generate_regimens_by_line(formatted_regimens, count_mask = minCount) %>%
      readr::write_csv(file.path(outputFolder, "regimens_by_line.csv"))

    generate_survival_crpc(formatted_regimens, count_mask = minCount, tryPlot=T) %>%
      readr::write_csv(file.path(outputFolder, "survival_mcrpc.csv"))

    # generate_survival_bcr(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask = minCount, tryPlot=F) %>%
    # readr::write_csv(file.path(outputFolder, "survival_bcr.csv"))

    generate_number_psa(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask = minCount) %>%
      readr::write_csv(file.path(outputFolder, "psa_followup.csv"))

  }

}




