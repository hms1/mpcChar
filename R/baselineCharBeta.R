getCharacterizations <- function(connection,
                                 cdmDatabaseSchema,
                                 vocabularyDatabaseSchema = cdmDatabaseSchema,
                                 cohortDatabaseSchema,
                                 cohortTable,
                                 oracleTempSchema,
                                 outputFolder,
                                 dayStart,
                                 dayEnd){

  cohorts <- read.csv(system.file("settings", "CohortsToCreate.csv", package = "determinePC")) %>%
    select(atlasName, cohortId) %>%
    split(.$atlasName, drop = TRUE) %>%
    purrr::map(~.x$cohortId)

  covariateSettings <- FeatureExtraction::createDefaultCovariateSettings()

  covariateSettings <- FeatureExtraction::createCovariateSettings(
    useDemographicsGender = TRUE,
    useDemographicsAge = TRUE,
    useDemographicsAgeGroup = TRUE,
    useDemographicsRace = TRUE,
    useDemographicsEthnicity = TRUE,
    useDemographicsIndexYear = TRUE,
    useDemographicsIndexMonth = TRUE,
    useDemographicsPriorObservationTime = TRUE,
    useDemographicsPostObservationTime = TRUE,
    useDemographicsTimeInCohort = TRUE,
    useConditionEraLongTerm = TRUE,
    useConditionGroupEraLongTerm = TRUE,
    useDrugEraLongTerm = TRUE,
    useDrugGroupEraLongTerm = TRUE,
    useProcedureOccurrenceLongTerm = TRUE,
    useMeasurementLongTerm = TRUE,
    longTermStartDays = dayStart,
    endDays = dayEnd
  )

  connection <- DatabaseConnector::connect(connectionDetails)

  chars <-
    purrr:::map(cohorts,
                function(cohortId){

                  data <- FeatureExtraction::getDbCovariateData(
                    connection = connection,
                    oracleTempSchema = oracleTempSchema,
                    cdmDatabaseSchema = cdmDatabaseSchema,
                    cohortDatabaseSchema = cohortDatabaseSchema,
                    cohortTable = cohortTable,
                    cohortId = cohortId,
                    covariateSettings = covariateSettings,
                    aggregated = TRUE)

                  result <- data.frame()

                  if (!is.null(data$covariates)) {
                    counts <- data$covariates %>% dplyr::select(.data$sumValue) %>% dplyr::pull()
                    n <- attr(data, "metaData")$populationSize
                    binaryCovs <- data$covariates %>%
                      dplyr::select(.data$covariateId, .data$averageValue) %>%
                      dplyr::rename(mean = .data$averageValue) %>%
                      dplyr::collect()
                    binaryCovs$sd <- sqrt((n * counts + counts)/(n^2))
                    result <- rbind(result, binaryCovs)
                  }

                  if (!is.null(data$covariatesContinuous)) {
                    continuousCovs <- data$covariatesContinuous %>%
                      dplyr::select(.data$covariateId, .data$averageValue, .data$standardDeviation) %>%
                      dplyr::rename(mean = .data$averageValue, sd = .data$standardDeviation) %>%
                      dplyr::collect()
                    result <- rbind(result, continuousCovs)
                  }

                  if (nrow(result) > 0) {
                    result <- merge(result, data$covariateRef %>% dplyr::collect())
                    result$conceptId <- NULL
                  }

                  result$cohortId <- cohortId

                  return(result)

                })

  return(chars)

}

