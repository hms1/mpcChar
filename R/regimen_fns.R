pull_regimen_data <- function(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask){

  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "regimen_pull.sql",
                                           packageName = "determinePC",
                                           dbms = attr(connection, "dbms"),
                                           cohortDatabaseSchema = cohortDatabaseSchema,
                                           cdmDatabaseSchema = cdmDatabaseSchema,
                                           regimenIngredientsTable = regimenIngredientsTable,
                                           cohortTable = cohortTable)

  formatted_regimens_s <- DatabaseConnector::querySql(DatabaseConnector::connect(connectionDetails), sql)

  colnames(formatted_regimens_s) <- tolower(colnames(formatted_regimens_s))

  pathToCsv <- system.file("settings", "CohortsToCreate.csv", package = "determinePC")
  cohortsToCreate <- read.csv(pathToCsv)

  formatted_regimens_s %>%
    group_by(cohort_definition_id, subject_id, cohort_start_date, regimen_start_date) %>%
    mutate(categorized_regimen = str_c(sort(unique(ingredient[ingredient_start_date == regimen_start_date])), collapse = ", "),
           regimen = categorized_regimen) %>%
    ungroup %>%
    tbl_df %>%
    inner_join(cohortsToCreate %>% select(cohort_definition_id = cohortId, popn = atlasName)) %>%
    mutate(popn = str_remove(popn, " \\(.*")) %>%
    group_by(cohort_definition_id, popn, subject_id, year_of_birth, cohort_start_date, cohort_end_date, observation_period_start_date, observation_period_end_date,  categorized_regimen, regimen, regimen_start_date) %>% #
    summarise(regimen_end_date = max(ingredient_end_date)) %>%
    mutate(regimen_start_date = pmax(cohort_start_date, regimen_start_date)) %>%
    select(cohort_definition_id, popn, subject_id, year_of_birth, cohort_start_date, cohort_end_date, observation_period_start_date, observation_period_end_date,  regimen_start_date, regimen,regimen_end_date, categorized_regimen) %>% #
    distinct %>%
    group_by(cohort_definition_id, popn, subject_id, cohort_start_date) %>%
    arrange(cohort_definition_id, popn, subject_id, cohort_start_date,regimen_start_date) %>%
    mutate(new_line = coalesce(lag(regimen,1) != regimen, TRUE),
           ordinal = cumsum(new_line)) %>%
    group_by(cohort_definition_id, popn, subject_id, year_of_birth, cohort_start_date, cohort_end_date, observation_period_start_date, observation_period_end_date,  regimen, ordinal) %>% #
    summarise(regimen_start_date = min(regimen_start_date),
              regimen_end_date = max(regimen_end_date),
              categorized_regimen = categorized_regimen[1],
              treatment_year = lubridate::year(regimen_start_date))%>%
    mutate(ordinal = case_when(is.na(regimen) ~ as.integer(0), TRUE ~ ordinal)) %>% #
    group_by(cohort_definition_id, subject_id) %>%
    arrange(regimen_start_date) %>%
    mutate(next_regimen_start = lead(regimen_start_date,1),
           treatment_start_date = min(regimen_start_date),
           treatment_end_date = max(regimen_end_date))

}

generate_population_summary <- function(formatted_regimens){

  population_summary <- purrr::map(list(`Condition Index` = sym("cohort_start_date"), `Treatment Index` = sym("treatment_start_date")),
                                   function(.x){
                                     formatted_regimens %>%
                                       filter(!is.na(.data[[.x]])) %>%
                                       group_by(popn, subject_id, cohort_end_date, treatment_start_date, cohort_start_date) %>%
                                       summarise(lines_of_treatment = max(ordinal),
                                                 treatment_end_date =   max(case_when(is.na(regimen_end_date) ~ {{ .x }},TRUE ~ regimen_end_date))                                       ) %>%
                                       group_by(popn) %>%
                                       summarise(count_persons = n_distinct(subject_id),
                                                 avg_lines_of_treatment = mean(lines_of_treatment),
                                                 min_lines_of_treatment = quantile(lines_of_treatment, 0.05, na.rm = T),
                                                 lq_lines_of_treatment = quantile(lines_of_treatment, 0.25,na.rm = T),
                                                 med_lines_of_treatment = quantile(lines_of_treatment, 0.5, na.rm = T),
                                                 uq_lines_of_treatment = quantile(lines_of_treatment, 0.75, na.rm = T),
                                                 max_lines_of_treatment = quantile(lines_of_treatment, 0.99, na.rm = T),
                                                 lq_follow_up = quantile(cohort_end_date - {{ .x }}, 0.25,na.rm = T),
                                                 med_follow_up = quantile(cohort_end_date - {{ .x }}, 0.5, na.rm = T),
                                                 uq_follow_up = quantile(cohort_end_date - {{ .x }}, 0.75, na.rm = T),
                                                 lq_follow_up_cohort = quantile(cohort_end_date - cohort_start_date, 0.25,na.rm = T),
                                                 med_follow_up_cohort = quantile(cohort_end_date - cohort_start_date, 0.5, na.rm = T),
                                                 uq_follow_up_cohort = quantile(cohort_end_date - cohort_start_date, 0.75, na.rm = T),
                                                 lq_treatment_duration = quantile(treatment_end_date - treatment_start_date, 0.25,na.rm = T),
                                                 med_treatment_duration = quantile(treatment_end_date - treatment_start_date, 0.5, na.rm = T),
                                                 uq_treatment_duration = quantile(treatment_end_date - treatment_start_date, 0.75, na.rm = T)) %>%
                                       ungroup %>%
                                       mutate(`Data Source` =  "Oncology EMR",
                                              `Population` = popn,
                                              `Patients` = scales::comma(count_persons, big.mark=","),
                                              `Lines of treatment, avg` = scales::comma(avg_lines_of_treatment, accuracy = 0.01),
                                              `Lines of treatment, median (IQR)` = str_c(round(med_lines_of_treatment,0), " (",round(lq_lines_of_treatment,0),"-",  round(uq_lines_of_treatment,0),")"),
                                              `Lines of treatment, max` = round(max_lines_of_treatment, 0),
                                              `Treatment Duration, median (IQR)` =  str_c(round(med_treatment_duration,0), " days (",round(lq_treatment_duration,0),"-",  round(uq_treatment_duration,0),")"),
                                              `Follow-up from index, median (IQR)` =  str_c(round(med_follow_up,0), " days (",round(lq_follow_up,0),"-",  round(uq_follow_up,0),")"),
                                              `Follow-up from diagnosis, median (IQR)` =  str_c(round(med_follow_up_cohort,0), " days (",round(lq_follow_up_cohort,0),"-",  round(uq_follow_up_cohort,0),")")) %>%
                                       select(`Data Source`:`Follow-up from diagnosis, median (IQR)`)}) %>%
    bind_rows(.id = "index_date")


  population_summary %>%
    #mutate(Population = factor(Population, levels = c("PC","mHSPC","nmCRPC","BCR"))) %>%
    arrange(index_date,Population)

}

generate_stats_by_line <- function(formatted_regimens, count_mask){

stats_by_line <- purrr::map_df(c(1,2,3,4), function(therapy_line){

    formatted_regimens %>%
      filter(regimen != "") %>%
      group_by(cohort_definition_id, popn, subject_id) %>%
      arrange(cohort_definition_id, popn, subject_id,ordinal) %>%
      mutate(last_regimen_start = lag(regimen_start_date,1),
             last_regimen_end = lag(regimen_end_date, 1)) %>%
      ungroup %>%
      mutate(fr = case_when(therapy_line == 4 ~ ordinal >= 4,
                            TRUE ~ ordinal == therapy_line)) %>%
      filter(fr) %>%
      mutate(ordinal = therapy_line) %>%
      group_by(subject_id, cohort_definition_id, popn, cohort_start_date, cohort_end_date, ordinal) %>%
      summarise(regimen_start_date = min(regimen_start_date),
             regimen_end_date = max(regimen_end_date),
             last_regimen_start = min(last_regimen_start),
             last_regimen_end = min(last_regimen_end)) %>%
      group_by(cohort_definition_id,popn,ordinal) %>%
      summarise(count_persons_treated = n_distinct(subject_id),
                lq_time_since_diagnosis = quantile(regimen_start_date - cohort_start_date, 0.25,na.rm = T),
                med_time_since_diagnosis = quantile(regimen_start_date - cohort_start_date, 0.5, na.rm = T),
                uq_time_since_diagnosis = quantile(regimen_start_date - cohort_start_date, 0.75, na.rm = T),
                lq_treatment_length = quantile(regimen_end_date - regimen_start_date, 0.25, na.rm = T),
                med_treatment_length = quantile(regimen_end_date - regimen_start_date, 0.5,na.rm = T),
                uq_treatment_length = quantile(regimen_end_date - regimen_start_date, 0.75,na.rm = T),
                lq_time_since_last_regimen_end = quantile(regimen_start_date - last_regimen_end, 0.25, na.rm = T),
                med_time_since_last_regimen_end = quantile(regimen_start_date - last_regimen_end, 0.5, na.rm = T),
                uq_time_since_last_regimen_end = quantile(regimen_start_date - last_regimen_end, 0.75, na.rm = T),
                lq_time_since_last_regimen_start = quantile(regimen_start_date - last_regimen_start, 0.25, na.rm = T),
                med_time_since_last_regimen_start = quantile(regimen_start_date - last_regimen_start, 0.5, na.rm = T),
                uq_time_since_last_regimen_start = quantile(regimen_start_date - last_regimen_start, 0.75, na.rm = T)) %>%
      mutate_at(vars(lq_time_since_diagnosis:uq_time_since_last_regimen_start), as.integer)
  }) %>%
    ungroup %>%
    mutate(`Data Source` = "Oncology EMR",
           count_persons_treated = scales::comma(case_when(count_persons_treated <= count_mask ~ as.integer(count_mask), TRUE ~ as.integer(count_persons_treated))),
           `Time since diagnosis, median (IQR)` = str_c(round(med_time_since_diagnosis,0), " days (",
                                                        round(lq_time_since_diagnosis,0),"-",
                                                        round(uq_time_since_diagnosis,0),")"),
           `Treatment line duration, median (IQR)` = str_c(round(med_treatment_length,0), " days (",
                                                           round(lq_treatment_length,0),"-",
                                                           round(uq_treatment_length,0),")"),
           `Time since previous line end, median (IQR)`  = str_c(round(med_time_since_last_regimen_end, 0), " days (",
                                                                 round(lq_time_since_last_regimen_end, 0),"-",
                                                                 round(uq_time_since_last_regimen_end, 0),")"),
           `Time since previous line start, median (IQR)`  = str_c(round(med_time_since_last_regimen_start, 0), " days (",
                                                                   round(lq_time_since_last_regimen_start, 0),"-",
                                                                   round(uq_time_since_last_regimen_start, 0),")")) %>%
    select(`Data Source`,`Population` = popn, `Line of treatment` = ordinal, `Patients` = count_persons_treated,
           `Time since diagnosis, median (IQR)`, `Time since previous line end, median (IQR)`,`Time since previous line start, median (IQR)`, `Treatment line duration, median (IQR)`)

  stats_by_line %>%
    mutate(Population = factor(Population, levels = c("PC","mHSPC","nmCRPC","BCR"))) %>%
    arrange(`Line of treatment`,Population)

}

generate_regimens_by_line <- function(formatted_regimens, count_mask){

  formatted_regimen_ingredeients <- formatted_regimens %>%
    mutate(therapy_group = case_when(str_detect(regimen, ",") ~ "combination",
                                     TRUE ~ "monotherapy"),
           therapy = str_split(regimen, ",")) %>%
    unnest(therapy)

  ingredients_by_treatment_line <- purrr::map_df(unique(formatted_regimen_ingredeients$popn), function(popn_s){

    dta <- formatted_regimen_ingredeients %>%
      filter(popn == popn_s) %>%
      group_by(ordinal)  %>%
      mutate(count = n_distinct(subject_id)) %>%
      filter(count >= 0)

    if(nrow(dta) == 0){return(NULL)}

    dta %>%
      mutate(ordinal = case_when(ordinal > 3 ~ as.integer(4),
                                 TRUE ~ ordinal)) %>%
      ungroup %>%
      group_by(therapy, therapy_group, ordinal) %>%
      summarise(count = n_distinct(subject_id)) %>%
      ungroup %>%
      mutate(population = popn_s) %>%
      mutate(count = case_when(count <= count_mask ~ stringr::str_c("<",count_mask), TRUE ~ as.character(count)))

  }
  )

  regimens_by_treatment_line <- purrr::map_df(unique(formatted_regimen_ingredeients$popn), function(popn_s){

    dta <- formatted_regimens %>%
      filter(popn == popn_s) %>%
      group_by(ordinal)  %>%
      mutate(count = n_distinct(subject_id)) %>%
      filter(count >= 0)

    if(nrow(dta) == 0){return(NULL)}

    dta %>%
      mutate(ordinal = case_when(ordinal > 3 ~ as.integer(4),
                                 TRUE ~ ordinal)) %>%
      ungroup %>%
      mutate(therapy_group = "regimen",
             therapy = regimen) %>%
      group_by(therapy, therapy_group, ordinal) %>%
      summarise(count = n_distinct(subject_id)) %>%
      ungroup %>%
      mutate(population = popn_s) %>%
      mutate(count = case_when(count <= count_mask ~ stringr::str_c("<",count_mask), TRUE ~ as.character(count)))
  }
  )

  bind_rows(regimens_by_treatment_line, ingredients_by_treatment_line %>% mutate(count = as.character(count)))

}

generate_number_psa <- function(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask){

  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "number_psa.sql",
                                           packageName = "determinePC",
                                           dbms = attr(connection, "dbms"),
                                           oracleTempSchema = oracleTempSchema,
                                           cdm_database_schema = cdmDatabaseSchema,
                                           vocabulary_database_schema = cdmDatabaseSchema,
                                           cohort_database_schema = cohortDatabaseSchema,
                                           target_database_schema = cohortDatabaseSchema,
                                           cohort_table = cohortTable)

  psa <- DatabaseConnector::querySql(connection, sql)
  names(psa) <- SqlRender::snakeCaseToCamelCase(names(psa))

  psa %>%
    mutate(countPsa = coalesce(countPsa,0)) %>%
    group_by(cohortDefinitionId) %>%
    summarise(psa = n_distinct(subjectId[countPsa >= 1]),
              no_psa = n_distinct(subjectId[countPsa==0]),
              psa_1 = n_distinct(subjectId[countPsa == 1]),
              psa_g1 = n_distinct(subjectId[countPsa > 1]),
              psa_m = str_c(median(countPsa[countPsa >= 1]), " (",quantile(countPsa[countPsa >= 1],0.25),"-",quantile(countPsa[countPsa >= 1],0.75),")")) %>%
    mutate_at(vars(psa, no_psa, psa_1, psa_g1),  ~case_when(.x <= count_mask ~ as.integer(count_mask), TRUE ~ as.integer(.x)))


}

generate_ranges_psa <- function(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask){

  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "psa_range.sql",
                                           packageName = "determinePC",
                                           dbms = attr(connection, "dbms"),
                                           oracleTempSchema = oracleTempSchema,
                                           cdm_database_schema = cdmDatabaseSchema,
                                           vocabulary_database_schema = cdmDatabaseSchema,
                                           cohort_database_schema = cohortDatabaseSchema,
                                           target_database_schema = cohortDatabaseSchema,
                                           cohort_table = cohortTable)

  psa <- DatabaseConnector::querySql(connection, sql)
  names(psa) <- SqlRender::snakeCaseToCamelCase(names(psa))

  psa %>%
    mutate_at(vars(countPersons),  ~case_when(.x <= count_mask ~ as.integer(count_mask), TRUE ~ as.integer(.x)))


}

generate_survival_bcr <- function(connection, cohortDatabaseSchema, cdmDatabaseSchema, regimenIngredientsTable, cohortTable, count_mask, tryPlot = F){


  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "bcr_survival.sql",
                                           packageName = "determinePC",
                                           dbms = attr(connection, "dbms"),
                                           cohortDatabaseSchema = cohortDatabaseSchema,
                                           cdmDatabaseSchema = cdmDatabaseSchema,
                                           cohortTable = cohortTable)


  df <- DatabaseConnector::querySql(connect(connectionDetails), sql)

  names(df) <- tolower(names(df))

  map(list(crc = "crc", mpc = "mpc", either = "either"), function(endpoint){

    if(endpoint == "crc"){censor = "mpc"}
    if(endpoint == "mpc"){censor = "crc"}

    if(endpoint == "either"){
      data <- df %>%
        ungroup %>%
        mutate(age = cut(year(cohort_start_date)-year_of_birth, c(0,60,70,80,Inf), right = FALSE)) %>%
        tbl_df %>%
        mutate(
          outcome = !is.na(crc)|!is.na(mpc),
          days_to_end = case_when(outcome ~ as.integer(pmin(crc, mpc,na.rm=T) - cohort_start_date), TRUE ~ as.integer(cohort_end_date - cohort_start_date))
        ) %>%
        select(cohort_definition_id, subject_id, age, outcome, days_to_end) %>%
        distinct %>%
        mutate(popn = "BCR")
    }else{
      data <- df %>%
        ungroup %>%
        mutate(age = cut(year(cohort_start_date)-year_of_birth, c(0,60,70,80,Inf), right = FALSE)) %>%
        tbl_df %>%
        mutate(
          outcome = !is.na(!!sym(endpoint)) & (is.na(!!sym(censor))|(!!sym(endpoint) <= !!sym(censor))),
          days_to_end = case_when(outcome ~ as.integer(!!sym(endpoint) - cohort_start_date),
                                  TRUE ~ as.integer(pmin(!!sym(censor),cohort_end_date,na.rm=T) - cohort_start_date))
        ) %>%
        select(cohort_definition_id, subject_id, age, outcome, days_to_end) %>%
        distinct %>%
        mutate(popn = "BCR")
    }

    data <- bind_rows(data, data %>% mutate(age = "all"))

    surv_obj <- survfit(Surv(days_to_end, outcome) ~  age, data=data)

    if(tryPlot){
    plot <- autoplot(surv_obj, xlab = "Years since BCR", censor = FALSE) +
      coord_cartesian(ylim = c(0,1), x = c(0,5*365.25)) +
      scale_x_continuous(labels = function(x) as.integer(x/365.25), breaks = seq(0,5*365.25,365.25)) +
      facet_wrap(vars(strata)) +
      theme_bw() +
      theme(legend.position = "none") +
      labs(title = str_c("Time to ",toupper(endpoint)," by age group"))

    ggsave(file.path(outputFolder, str_c("BCRsurv_",endpoint,".jpg")), plot, width = 6, height = 4, units = "in")
    }

    by_age <- summary(surv_obj)$table %>% as.data.frame %>% mutate(age_group = row.names(.), popn = "BCR")

    bind_rows(by_age) %>%
      select(age_group, records, events, median) %>%
      mutate_at(vars(records, events), ~case_when(.x <= count_mask ~ as.integer(count_mask), TRUE ~ as.integer(.x)))

  }) %>% bind_rows(.id = "endpoint")

}

generate_survival_crpc <- function(formatted_regimens, count_mask, tryPlot=T){

  data <- formatted_regimens %>%
    ungroup %>%
    mutate(age = cut(year(cohort_start_date)-year_of_birth, c(0,60,70,80,Inf), right = FALSE)) %>%
    tbl_df %>%
    mutate(
      outcome = observation_period_end_date != cohort_end_date,
      days_to_end = as.integer(cohort_end_date - cohort_start_date)
    ) %>%
    select(popn, subject_id, age, outcome, days_to_end) %>%
    distinct

  surv_obj <- survfit(Surv(days_to_end, outcome) ~ popn, data= data %>% filter(popn %in% c("mHSPC","nmCRPC")))

  if(tryPlot){
    plot <- autoplot(surv_obj, censor = FALSE) +
      coord_cartesian(ylim = c(0,1), x = c(0,365.25*5)) +
      facet_wrap(vars(strata)) + theme_bw() +
      theme(legend.position = "none") +
      labs(title = str_c("Time to mCRPC")) +
      scale_x_continuous(breaks = seq(0,365.25*5,365.25), labels =function(x)x/365.25, name = "Years since diagnosis")

    ggsave(file.path(outputFolder, str_c("mCRPCsurv.jpg")), plot, width = 6, height = 3, units = "in")
  }

  totals <- summary(surv_obj)$table %>% as.data.frame %>% mutate(popn = rownames(.), age_group = "all")


  by_age <- map_df(c("mHSPC","nmCRPC"), function(i){

    surv_obj <- survfit(Surv(days_to_end, outcome) ~  age, data=data %>% filter(popn == i))

    if(tryPlot){
      plot <- autoplot(surv_obj, censor = FALSE) +
        coord_cartesian(ylim = c(0,1), x = c(0,365.25*5)) +
        facet_wrap(vars(strata)) + theme_bw() +
        theme(legend.position = "none") +
        labs(title = str_c("Time to mCRPC from ","i")) +
        scale_x_continuous(breaks = seq(0,365.25*5,365.25), labels =function(x)x/365.25, name = "Years since diagnosis")

      ggsave(file.path(outputFolder, str_c("mCRPCsurv_",i,".jpg")), plot, width = 6, height = 4, units = "in")
    }

    summary(surv_obj)$table %>% as.data.frame %>% mutate(popn =i, age_group = row.names(.))

  })

  bind_rows(totals, by_age) %>%
    select(popn, age_group, records, events, median) %>%
    mutate_at(vars(records, events), ~case_when(.x <= count_mask ~ as.integer(count_mask), TRUE ~ as.integer(.x)))

}
