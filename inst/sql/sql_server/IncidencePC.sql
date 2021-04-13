IF OBJECT_ID('@cohort_database_schema.yearly_counts_bayer', 'U') IS NOT NULL
  DROP TABLE @cohort_database_schema.yearly_counts_bayer;

  CREATE TABLE @cohort_database_schema.yearly_counts_bayer (obs_year int);

  INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2010),(2011),(2012),(2013),(2014),(2015),(2016),(2017),(2018),(2019);

  WITH CTE AS (
  SELECT obs_year, 'incident_cases' as category, cohort_definition_id, count_cases
  FROM
    (SELECT obs_year, cohort_definition_id,  count(distinct subject_id) as count_cases
     FROM @cohort_database_schema.yearly_counts_bayer yr
     INNER JOIN (SELECT cohort_definition_id, subject_id, YEAR(cohort_start_date) as year_start, YEAR(cohort_end_date) as year_end
                 FROM @cohort_database_schema.@cohort_table) inc on inc.year_start = yr.obs_year
     GROUP BY obs_year, cohort_definition_id) v1

  UNION

  SELECT obs_year, 'prevalent_cases' as category, cohort_definition_id, count_cases
  FROM
    (SELECT obs_year, cohort_definition_id,  count(distinct subject_id) as count_cases
     FROM @cohort_database_schema.yearly_counts_bayer yr
     INNER JOIN (SELECT cohort_definition_id, subject_id, YEAR(cohort_start_date) as year_start, YEAR(cohort_end_date) as year_end
                 FROM @cohort_database_schema.@cohort_table) inc on inc.year_start <= yr.obs_year  and inc.year_end >= yr.obs_year
     GROUP BY obs_year, cohort_definition_id) v2
  )
  SELECT * INTO #incidence_tmp FROM CTE;
