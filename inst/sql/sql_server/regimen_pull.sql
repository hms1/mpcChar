SELECT DISTINCT c.cohort_definition_id, c.subject_id, c.cohort_start_date, c.cohort_end_date,
                op.observation_period_start_date, op.observation_period_end_date, concept.concept_name as gender, p.year_of_birth,
                r.ingredient, r.drug_era_id, r.ingredient_start_date, r.ingredient_end_date, r.regimen_start_date, r.regimen_end_date
FROM @cohortDatabaseSchema.@cohortTable c
LEFT JOIN @cohortDatabaseSchema.@regimenIngredientsTable r
  on r.person_id = c.subject_id
  and r.regimen_start_date >= DATEADD(day, -14, c.cohort_start_date)
  and r.regimen_end_date >= c.cohort_start_date
  and r.regimen_start_date < c.cohort_end_date
LEFT JOIN @cdmDatabaseSchema.observation_period op
  on op.person_id = c.subject_id
  and op.observation_period_start_date <= c.cohort_start_date
  and op.observation_period_end_date >= c.cohort_end_date
LEFT JOIN @cdmDatabaseSchema.person p on c.subject_id = p.person_id
LEFT JOIN @cdmDatabaseSchema.concept on concept.concept_id = p.gender_concept_id
ORDER BY c.cohort_definition_id, c.subject_id, r.regimen_start_date
