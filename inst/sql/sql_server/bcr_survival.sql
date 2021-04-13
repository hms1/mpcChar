SELECT
  b.cohort_definition_id as cohort_definition_id,
  p.year_of_birth as year_of_birth,
  b.subject_id as subject_id,
  b.cohort_start_date as cohort_start_date,
  b.cohort_end_date as cohort_end_date,
  min(d.drug_exposure_start_date) as crc,
  min(c.condition_start_date) as mpc
FROM @cohortDatabaseSchema.@cohortTable b
LEFT JOIN @cdmDatabaseSchema.person p on p.person_id = b.subject_id
LEFT JOIN (

  SELECT * FROM @cdmDatabaseSchema.drug_exposure
  WHERE drug_concept_id IN (SELECT descendant_concept_id FROM @cdmDatabaseSchema.concept_ancestor WHERE ancestor_concept_id IN (963987,1361291,42900250,40239056,1551099))
           ) d ON d.person_id = b.subject_id and d.drug_exposure_start_date >= b.cohort_start_date
LEFT JOIN (

  SELECT person_id, condition_start_date FROM @cdmDatabaseSchema.condition_occurrence
  WHERE condition_concept_id IN (SELECT descendant_concept_id FROM @cdmDatabaseSchema.concept_ancestor WHERE ancestor_concept_id IN (4196262,193144,4312802,78097,4246450,4246451,4312290,140960,4247962,192568,4312023,200959,439751,200348,46273652,4281027,198700,44806773,254591,318096,442182,320342,434298,434875,373425,199752,72266,4147162,253717,4315806,196925,46270513,4281030,136354,198371,4314071,4158910,78987,432851))

  UNION

  SELECT person_id, measurement_date as condition_start_date FROM @cdmDatabaseSchema.measurement
  WHERE measurement_concept_id IN (SELECT descendant_concept_id FROM @cdmDatabaseSchema.concept_ancestor WHERE ancestor_concept_id IN (3006575,35918383))
  AND value_as_concept_id in (45876322,45882500,45881618,45878386,46237067,46237075,35919762,35919199,35919922,35919359,35919520,35919183,35919664,35919321,35919223,35919795,35919415,35919132)
           ) c ON  c.person_id = b.subject_id and c.condition_start_date >= b.cohort_start_date
WHERE cohort_definition_id = 1
GROUP BY b.cohort_definition_id, p.year_of_birth, cohort_start_date, cohort_end_date, subject_id;
