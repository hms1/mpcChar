WITH psa_counts AS (
  select cohort_definition_id, subject_id, count(distinct measurement_date) as count_psa
  from @cohort_database_schema.@cohort_table c
  left join
        (
        select *
        FROM @cdm_database_schema.MEASUREMENT m
        WHERE measurement_concept_id IN (
          select c.concept_id
          from @vocabulary_database_schema.CONCEPT c
          join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
          and ca.ancestor_concept_id in (4215704,40480170,3013603,3039443,4272032,44793131,42529229)
          and c.invalid_reason is null
        )
        AND unit_concept_id IN (8842) or unit_source_value in ('ng/mL')
      ) m on m.person_id = c.subject_id
  where (m.measurement_date >= c.cohort_start_date and m.measurement_date <= c.cohort_end_date)
  group by cohort_definition_id, subject_id)

SELECT c.cohort_definition_id, c.subject_id, p.count_psa
from @cohort_database_schema.@cohort_table c
LEFT JOIN psa_counts p on p.subject_id = c.subject_id and p.cohort_definition_id = c.cohort_definition_id;
