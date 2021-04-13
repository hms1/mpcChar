With CTE as (
select bd.*, de.*, c.concept_name
from @cohortDatabaseSchema.@cohortTable bd
left join @cdmDatabaseSchema.drug_exposure de on de.person_id = bd.subject_id and de.drug_exposure_start_date between bd.cohort_start_date and bd.cohort_end_date
inner join @cdmDatabaseSchema.concept_ancestor ca on ca.descendant_concept_id = de.drug_concept_id
inner join @cdmDatabaseSchema.concept c on c.concept_id = ca.ancestor_concept_id
where c.concept_id in (
          select descendant_concept_id as drug_concept_id from @cdmDatabaseSchema.concept_ancestor ca1
          where ancestor_concept_id in (42900250, 1361291, 963987, 1315286, 1356461,1344381,40224095,35603551,43526934,1551099,1315942,40239056,1343039,19094980,1507558,1300978,1500211,1351541,1366773,1366310,19089810,1536743,1349025,1525866,19058410,19010792,1503983,19033280,19010868
 ) /* */
)
and c.concept_class_id = 'Ingredient'
--and cohort_definition_id = 1490
),
CTE_aggregate as (
select c.subject_id,c.concept_name, c.cohort_definition_id, min(drug_exposure_start_date) as min_date, max(drug_exposure_start_date) as max_date, count(*) , max_date - min_date as treatment_duration
from CTE c
group by subject_id, drug_concept_id, c.cohort_definition_id, c.concept_name
)
select * INTO #treatment_tmp from CTE_aggregate;
