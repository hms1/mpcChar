  --DROP TABLE IF EXISTS @cohort_database_schema.yearly_counts_bayer;
  IF OBJECT_ID('@cohort_database_schema.yearly_counts_bayer', 'U') IS NOT NULL 
	DROP TABLE @cohort_database_schema.yearly_counts_bayer;

  CREATE TABLE @cohort_database_schema.yearly_counts_bayer (obs_year int);

 -- INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2010),(2011),(2012),(2013),(2014),(2015),(2016),(2017),(2018),(2019);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2010);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2011);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2012);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2013);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2014);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2015);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2016);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2017);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2018);
INSERT INTO  @cohort_database_schema.yearly_counts_bayer values (2019);

  WITH CTE AS (
	SELECT obs_year, 'incident_cases' as category, cohort_definition_id, count(distinct subject_id) as count_cases
	FROM @cohort_database_schema.yearly_counts_bayer yr
	--INNER JOIN (SELECT cohort_definition_id, subject_id, DATEPART('year',cohort_start_date) as year_start, DATEPART('year', cohort_end_date) as year_end
	INNER JOIN (SELECT cohort_definition_id, subject_id, TO_CHAR(cohort_start_date, 'YYYY') as year_start, TO_CHAR(cohort_end_date, 'YYYY') as year_end
  FROM @cohort_database_schema.@cohort_table
  ) inc on inc.year_start = yr.obs_year
  --GROUP BY obs_year, category, cohort_definition_id
  GROUP BY obs_year, 'category', cohort_definition_id
  UNION
  SELECT obs_year, 'prevalent_cases' as category, cohort_definition_id, count(distinct subject_id) as count_cases
  FROM @cohort_database_schema.yearly_counts_bayer yr
  --INNER JOIN (SELECT cohort_definition_id, subject_id, DATEPART('year',cohort_start_date) as year_start, DATEPART('year', cohort_end_date) as year_end
  INNER JOIN (SELECT cohort_definition_id, subject_id, TO_CHAR(cohort_start_date, 'YYYY') as year_start, TO_CHAR(cohort_end_date, 'YYYY') as year_end
  FROM @cohort_database_schema.@cohort_table
  ) inc on inc.year_start <= yr.obs_year  and inc.year_end >= yr.obs_year
   --GROUP BY obs_year, category, cohort_definition_id
  GROUP BY obs_year, 'category', cohort_definition_id
  )
  SELECT * INTO #incidence_tmp FROM CTE;
