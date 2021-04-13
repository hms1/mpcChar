WITH psa_concepts AS (
select distinct concept_id FROM
  (
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4215704,40480170,3013603,3039443,4272032,44793131,42529229)
  UNION
  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4215704,40480170,3013603,3039443,4272032,44793131,42529229)
  and c.invalid_reason is null
  )
),
psa_counts AS (
  select cohort_definition_id, m.*, row_number()over(partition by cohort_definition_id, subject_id order by measurement_date desc) as rn,
         case when value_as_number < 4 then '<4'
              when value_as_number < 10 then '4- <10'
              when value_as_number < 20 then '10- <20'
              else '20+' end as psa_range
  from @cohort_database_schema.@cohort_table c
  left join
        (
        select *
        FROM @cdm_database_schema.MEASUREMENT m
        WHERE measurement_concept_id IN (SELECT * FROM psa_concepts)
        AND unit_concept_id IN (8842) or unit_source_value in ('ng/mL')
      ) m on m.person_id = c.subject_id
  where m.measurement_date <= c.cohort_start_date and value_as_number is not null)

SELECT cohort_definition_id, psa_range, count(distinct person_id) as count_persons
FROM psa_counts
WHERE rn = 1
GROUP BY cohort_definition_id, psa_range;
