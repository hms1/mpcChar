CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 1 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (37201123)

) I
) C UNION ALL
SELECT 2 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (200962,4163261)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (200962,4163261)
  and c.invalid_reason is null

) I
) C UNION ALL
SELECT 3 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (937616,2110046,1531629,2780458,2780459,2780460,2780461,2780462,2777698,2777700,2777702,2777704,2777706,2110044,2109832,2109834,2109833,2003983,2004009,2003966,2109725,2110036,2110035,2110032,2110034,2110033,2110031,2110037,2110039,2110038,4096783,2780498,2780499,2780477,2780478,2780479,2780480,2109892,927097,2109893,2109825,2109830,42627874)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4096783)
  and c.invalid_reason is null

) I
) C UNION ALL
SELECT 4 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4215704,40480170,3013603,3039443,4272032,44793131,3005013,42529229)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4215704,40480170,3013603,3039443,4272032,44793131,3005013,42529229)
  and c.invalid_reason is null

) I
) C UNION ALL
SELECT 5 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4141448,45890260,2007468,2789832,2789831,2789833,2789835,2789834,2789829,2789828,2789830,45890648,2790073,2110041,2110043,2110042,46257457,2789849,2789845,2789847,2789846,2789850,2789848,42628035,2101759,42628582,2211875,2211874,2617415,2617416,2211891,2007487,2778476,2778477,2778478,2778479,2778480,46257688,46257736,2211872,45890647,2211897,2211896,2211895,2007506,2211894,2211893,2211892,2790075,42742550,42742549,2788785,2788993,2789008,2789251,2788795,2789003,2789018,2789855,2789851,2789853,2789852,2789856,2789854,43533205,2007502,2007488,2007503,2790076,2211885,2211884,2211883,2211882,2211877,45890641,45890642,45890640,45890639,2211865,2211866,2211864,2211869,2211870,2211868,2211867,2211863,2211859,2211861,2211862,2211860,45890637,45890638,45890636,2211855,2211854,2211858,45890643,2211876,2212073,2212077,2212072,2212066,2212080,2211902,2211903,2211904,42628030,42628064,42628642,42628483,42628029,2211873,2789872,2789870,2789871,2211856,2211879,2211878,2007504,2211906,2211905,2007485,2211871,2211907,2211881)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4141448,45890260,2007468)
  and c.invalid_reason is null

) I
) C UNION ALL
SELECT 6 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (963987,1361291,42900250,40239056,1551099)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (963987,1361291,42900250,40239056,1551099)
  and c.invalid_reason is null

) I
) C UNION ALL
SELECT 7 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4196262,193144,4312802,78097,4246450,4246451,4312290,140960,4247962,192568,4312023,200959,439751,200348,46273652,4281027,198700,44806773,254591,318096,442182,320342,434298,434875,373425,199752,72266,4147162,253717,4315806,196925,46270513,4281030,136354,198371,4314071,4158910,78987,432851)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4196262,193144,4312802,78097,4246450,4246451,4312290,140960,4247962,192568,4312023,200959,439751,200348,46273652,4281027,198700,44806773,254591,318096,442182,320342,434298,434875,373425,199752,72266,4147162,253717,4315806,196925,46270513,4281030,136354,198371,4314071,4158910,78987,432851)
  and c.invalid_reason is null

) I
) C UNION ALL
SELECT 8 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (3006575,35918383)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (3006575,35918383)
  and c.invalid_reason is null

) I
) C
;

CREATE TABLE #Measurement_criteria (
person_id bigint NOT NULL,
event_id bigint NOT NULL,
start_date date NOT NULL,
end_date date NOT NULL,
target_concept_id bigint NOT NULL,
visit_occurrence_id bigint NOT NULL,
sort_date date NOT NULL
)
;

INSERT INTO #Measurement_criteria (person_id, event_id, start_date, end_date, target_concept_id, visit_occurrence_id, sort_date)
SELECT DISTINCT C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as end_date, C.measurement_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,C.measurement_date as sort_date
FROM
      (
        select m.person_id, m.measurement_id, m.measurement_date, m.measurement_concept_id, m.visit_occurrence_id,
               case when unit_concept_id = 8842 then value_as_number
                    when unit_concept_id = 8817 then 100 * value_as_number
                    else value_as_number
               end as converted_value,
               row_number() OVER (PARTITION BY m.person_id ORDER BY m.measurement_date ASC) ordinal
        FROM @cdm_database_schema.MEASUREMENT m
        JOIN #Codesets codesets on (m.measurement_concept_id = codesets.concept_id and codesets.codeset_id = 12)
        WHERE unit_concept_id IN (8842,8817)
      ) C
      JOIN (
        select m.person_id, m.measurement_id, m.measurement_date, m.measurement_concept_id, m.visit_occurrence_id,
               case when unit_concept_id = 8842 then value_as_number
                    when unit_concept_id = 8817 then 100 * value_as_number
                    else value_as_number
               end as converted_value,
               row_number() OVER (PARTITION BY m.person_id ORDER BY m.measurement_date ASC) ordinal
        FROM @cdm_database_schema.MEASUREMENT m
        JOIN #Codesets codesets on (m.measurement_concept_id = codesets.concept_id and codesets.codeset_id = 12)
        WHERE unit_concept_id IN (8842,8817)
      ) C2 on (C.person_id = C2.person_id)
WHERE (C.converted_value - C2.converted_value) > 2.0000
AND C.measurement_date > C2.measurement_date;

with primary_events (event_id, person_id, start_date, end_date, op_start_date, op_end_date, visit_occurrence_id) as
(
  -- Begin Primary Events
  select P.ordinal as event_id, P.person_id, P.start_date, P.end_date, op_start_date, op_end_date, cast(P.visit_occurrence_id as bigint) as visit_occurrence_id
  FROM
  (
    select E.person_id, E.start_date, E.end_date,
    row_number() OVER (PARTITION BY E.person_id ORDER BY E.sort_date ASC) ordinal,
    OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date, cast(E.visit_occurrence_id as bigint) as visit_occurrence_id
    FROM
    (
      -- Begin Condition Occurrence Criteria
      SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
      C.CONDITION_CONCEPT_ID as TARGET_CONCEPT_ID, C.visit_occurrence_id,
      C.condition_start_date as sort_date
      FROM
      (
        SELECT co.*
          FROM @cdm_database_schema.CONDITION_OCCURRENCE co
        JOIN #Codesets codesets on ((co.condition_source_concept_id = codesets.concept_id and codesets.codeset_id = 1))
      ) C


      -- End Condition Occurrence Criteria

      UNION ALL
      select PE.person_id, PE.event_id, PE.start_date, PE.end_date, PE.target_concept_id, PE.visit_occurrence_id, PE.sort_date FROM (
        -- Begin Measurement Criteria
        select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
        C.measurement_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
        C.measurement_date as sort_date
        from
        (
          select m.*,
               case when unit_concept_id = 8842 then value_as_number
                    when unit_concept_id = 8817 then value_as_number * 100
                    else value_as_number
               end as converted_value
            FROM @cdm_database_schema.MEASUREMENT m
          JOIN #Codesets codesets on ((m.measurement_concept_id = codesets.concept_id and codesets.codeset_id = 4))
        ) C

        WHERE C.converted_value > 0.4000
        AND C.unit_concept_id in (8842, 8817)
        -- End Measurement Criteria

      ) PE
      JOIN (
        -- Begin Criteria Group
        select 0 as index_id, person_id, event_id
        FROM
        (
          select E.person_id, E.event_id
          FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
                FROM (-- Begin Measurement Criteria
                      select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
                      C.measurement_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
                      C.measurement_date as sort_date
                      from
                      (
                       select m.*,
                              case when unit_concept_id = 8842 then value_as_number
                                   when unit_concept_id = 8817 then value_as_number * 100
                                   else value_as_number
                              end as converted_value
            FROM @cdm_database_schema.MEASUREMENT m
          JOIN #Codesets codesets on ((m.measurement_concept_id = codesets.concept_id and codesets.codeset_id = 4))
        ) C

        WHERE C.converted_value > 0.4000
        AND C.unit_concept_id in (8842, 8817)
        -- End Measurement Criteria
                ) Q
                JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id
                and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
          ) E
          INNER JOIN
          (
            -- Begin Correlated Criteria
            SELECT 0 as index_id, p.person_id, p.event_id
            FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
                  FROM (-- Begin Measurement Criteria
                        select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
                        C.measurement_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
                        C.measurement_date as sort_date
                        from
                        (
                          select m.*,
                                 case when unit_concept_id = 8842 then value_as_number
                                      when unit_concept_id = 8817 then value_as_number * 100
                                      else value_as_number
                                 end as converted_value
            FROM @cdm_database_schema.MEASUREMENT m
          JOIN #Codesets codesets on ((m.measurement_concept_id = codesets.concept_id and codesets.codeset_id = 4))
        ) C

        WHERE C.converted_value > 0.4000
        AND C.unit_concept_id in (8842, 8817)
        -- End Measurement Criteria
                  ) Q
                  JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id
                  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
            ) P
            INNER JOIN
            (
              -- Begin Procedure Occurrence Criteria
              select C.person_id, C.procedure_occurrence_id as event_id, C.procedure_date as start_date, DATEADD(d,1,C.procedure_date) as END_DATE,
              C.procedure_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
              C.procedure_date as sort_date
              from
              (
                                select po.*
                  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
                JOIN #Codesets codesets on ((po.procedure_concept_id = codesets.concept_id and codesets.codeset_id = 3))
              ) C


              -- End Procedure Occurrence Criteria

            ) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= DATEADD(day,-90,P.START_DATE)
            GROUP BY p.person_id, p.event_id
            HAVING COUNT(A.TARGET_CONCEPT_ID) >= 1
            -- End Correlated Criteria

          ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
          GROUP BY E.person_id, E.event_id
          HAVING COUNT(index_id) = 1
        ) G
        -- End Criteria Group
      ) AC on AC.person_id = pe.person_id and AC.event_id = pe.event_id

      UNION ALL
      select PE.person_id, PE.event_id, PE.start_date, PE.end_date, PE.target_concept_id, PE.visit_occurrence_id, PE.sort_date FROM #Measurement_criteria PE
      JOIN (
        -- Begin Criteria Group
        select 0 as index_id, person_id, event_id
        FROM
        (
          select E.person_id, E.event_id
          FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
                FROM #Measurement_criteria Q
                JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id
                and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
          ) E
          INNER JOIN
          (
            -- Begin Correlated Criteria
            SELECT 0 as index_id, p.person_id, p.event_id
            FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
                  FROM #Measurement_criteria Q
                  JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id
                  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
            ) P
            INNER JOIN
            (
              -- Begin Procedure Occurrence Criteria
              select C.person_id, C.procedure_occurrence_id as event_id, C.procedure_date as start_date, DATEADD(d,1,C.procedure_date) as END_DATE,
              C.procedure_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
              C.procedure_date as sort_date
              from
              (
                	                  select po.*
                  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
                JOIN #Codesets codesets on ((po.procedure_concept_id = codesets.concept_id and codesets.codeset_id = 5))
              ) C


              -- End Procedure Occurrence Criteria

            ) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= DATEADD(day,-90,P.START_DATE)
            GROUP BY p.person_id, p.event_id
            HAVING COUNT(A.TARGET_CONCEPT_ID) >= 1
            -- End Correlated Criteria

          ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
          GROUP BY E.person_id, E.event_id
          HAVING COUNT(index_id) = 1
        ) G
        -- End Criteria Group
      ) AC on AC.person_id = pe.person_id and AC.event_id = pe.event_id

    ) E
    JOIN @cdm_database_schema.observation_period OP on E.person_id = OP.person_id and E.start_date >=  OP.observation_period_start_date and E.start_date <= op.observation_period_end_date
    WHERE DATEADD(day,0,OP.OBSERVATION_PERIOD_START_DATE) <= E.START_DATE AND DATEADD(day,0,E.START_DATE) <= OP.OBSERVATION_PERIOD_END_DATE
  ) P
  WHERE P.ordinal = 1
  -- End Primary Events

)
SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, visit_occurrence_id
INTO #qualified_events
FROM
(
  select pe.event_id, pe.person_id, pe.start_date, pe.end_date, pe.op_start_date, pe.op_end_date, row_number() over (partition by pe.person_id order by pe.start_date ASC) as ordinal, cast(pe.visit_occurrence_id as bigint) as visit_occurrence_id
  FROM primary_events pe

) QE

;

--- Inclusion Rule Inserts

select 0 as inclusion_rule_id, person_id, event_id
INTO #Inclusion_0
FROM
(
  select pe.person_id, pe.event_id
  FROM #qualified_events pe

  JOIN (
    -- Begin Criteria Group
    select 0 as index_id, person_id, event_id
    FROM
    (
      select E.person_id, E.event_id
      FROM #qualified_events E
      INNER JOIN
      (
        -- Begin Demographic Criteria
        SELECT 0 as index_id, e.person_id, e.event_id
        FROM #qualified_events E
        JOIN @cdm_database_schema.PERSON P ON P.PERSON_ID = E.PERSON_ID
        WHERE YEAR(E.start_date) - P.year_of_birth > 17 AND P.gender_concept_id in (8507)
        GROUP BY e.person_id, e.event_id
        -- End Demographic Criteria

      ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
      GROUP BY E.person_id, E.event_id
      HAVING COUNT(index_id) = 1
    ) G
    -- End Criteria Group
  ) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

select 1 as inclusion_rule_id, person_id, event_id
INTO #Inclusion_1
FROM
(
  select pe.person_id, pe.event_id
  FROM #qualified_events pe

  JOIN (
    -- Begin Criteria Group
    select 0 as index_id, person_id, event_id
    FROM
    (
      select E.person_id, E.event_id
      FROM #qualified_events E
      INNER JOIN
      (
        -- Begin Correlated Criteria
        SELECT 0 as index_id, p.person_id, p.event_id
        FROM #qualified_events P
        INNER JOIN
        (
          -- Begin Condition Occurrence Criteria
          SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
          C.CONDITION_CONCEPT_ID as TARGET_CONCEPT_ID, C.visit_occurrence_id,
          C.condition_start_date as sort_date
          FROM
          (
            SELECT co.*
              FROM @cdm_database_schema.CONDITION_OCCURRENCE co
            JOIN #Codesets codesets on ((co.condition_concept_id = codesets.concept_id and codesets.codeset_id = 2))
          ) C

          WHERE C.condition_start_date >= DATEFROMPARTS(2000, 01, 01)
          -- End Condition Occurrence Criteria

        ) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= DATEADD(day,0,P.START_DATE)
        GROUP BY p.person_id, p.event_id
        HAVING COUNT(A.TARGET_CONCEPT_ID) >= 1
        -- End Correlated Criteria

      ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
      GROUP BY E.person_id, E.event_id
      HAVING COUNT(index_id) = 1
    ) G
    -- End Criteria Group
  ) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

select 2 as inclusion_rule_id, person_id, event_id
INTO #Inclusion_2
FROM
(
  select pe.person_id, pe.event_id
  FROM #qualified_events pe

JOIN (
-- Begin Criteria Group
select 0 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id
  FROM #qualified_events E
  INNER JOIN
  (
    -- Begin Correlated Criteria
SELECT 0 as index_id, p.person_id, p.event_id
FROM #qualified_events P
LEFT JOIN
(
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
       C.CONDITION_CONCEPT_ID as TARGET_CONCEPT_ID, C.visit_occurrence_id,
       C.condition_start_date as sort_date
FROM
(
  SELECT co.*
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets codesets on ((co.condition_concept_id = codesets.concept_id and codesets.codeset_id = 7))
) C


-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= DATEADD(day,0,P.START_DATE)
GROUP BY p.person_id, p.event_id
HAVING COUNT(A.TARGET_CONCEPT_ID) = 0
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
SELECT 1 as index_id, p.person_id, p.event_id
FROM #qualified_events P
LEFT JOIN
(
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
       C.measurement_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
       C.measurement_date as sort_date
from
(
  select m.*
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets codesets on ((m.measurement_concept_id = codesets.concept_id and codesets.codeset_id = 8))
) C

WHERE C.value_as_concept_id in (45876322,45882500,45881618,45878386,46237067,46237075,35919762,35919199,35919922,35919359,35919520,35919183,35919664,35919321,35919223,35919795,35919415,35919132)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= DATEADD(day,0,P.START_DATE)
GROUP BY p.person_id, p.event_id
HAVING COUNT(A.TARGET_CONCEPT_ID) = 0
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) = 2
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

SELECT inclusion_rule_id, person_id, event_id
INTO #inclusion_events
FROM (select inclusion_rule_id, person_id, event_id from #Inclusion_0
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_1
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_2) I;
TRUNCATE TABLE #Inclusion_0;
DROP TABLE #Inclusion_0;

TRUNCATE TABLE #Inclusion_1;
DROP TABLE #Inclusion_1;

TRUNCATE TABLE #Inclusion_2;
DROP TABLE #Inclusion_2;


with cteIncludedEvents(event_id, person_id, start_date, end_date, op_start_date, op_end_date, ordinal) as
(
  SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, row_number() over (partition by person_id order by start_date ASC) as ordinal
  from
  (
    select Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date, SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) as inclusion_rule_mask
    from #qualified_events Q
    LEFT JOIN #inclusion_events I on I.person_id = Q.person_id and I.event_id = Q.event_id
    GROUP BY Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date
  ) MG -- matching groups

  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),3)-1)

)
select event_id, person_id, start_date, end_date, op_start_date, op_end_date
into #included_events
FROM cteIncludedEvents Results
WHERE Results.ordinal = 1
;



-- generate cohort periods into #final_cohort
with cohort_ends (event_id, person_id, end_date) as
(
	-- cohort exit dates
  -- By default, cohort exit at the event's op end date
select event_id, person_id, op_end_date as end_date from #included_events
UNION ALL
-- Censor Events
select i.event_id, i.person_id, MIN(c.start_date) as end_date
FROM #included_events i
JOIN
(
-- Begin Drug Exposure Criteria
select C.person_id, C.drug_exposure_id as event_id, C.drug_exposure_start_date as start_date,
       COALESCE(C.drug_exposure_end_date, DATEADD(day, 1, C.drug_exposure_start_date)) as end_date, C.drug_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
       C.drug_exposure_start_date as sort_date
from
(
  select de.*
  FROM @cdm_database_schema.DRUG_EXPOSURE de
JOIN #Codesets codesets on ((de.drug_concept_id = codesets.concept_id and codesets.codeset_id = 6))
) C


-- End Drug Exposure Criteria

) C on C.person_id = I.person_id and C.start_date >= I.start_date and C.START_DATE <= I.op_end_date
GROUP BY i.event_id, i.person_id

UNION ALL
select i.event_id, i.person_id, MIN(c.start_date) as end_date
FROM #included_events i
JOIN
(
-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
       C.CONDITION_CONCEPT_ID as TARGET_CONCEPT_ID, C.visit_occurrence_id,
       C.condition_start_date as sort_date
FROM
(
  SELECT co.*
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets codesets on ((co.condition_concept_id = codesets.concept_id and codesets.codeset_id = 7))
) C


-- End Condition Occurrence Criteria

) C on C.person_id = I.person_id and C.start_date >= I.start_date and C.START_DATE <= I.op_end_date
GROUP BY i.event_id, i.person_id

UNION ALL
select i.event_id, i.person_id, MIN(c.start_date) as end_date
FROM #included_events i
JOIN
(
-- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
       C.measurement_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id,
       C.measurement_date as sort_date
from
(
  select m.*
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets codesets on ((m.measurement_concept_id = codesets.concept_id and codesets.codeset_id = 8))
) C

WHERE C.value_as_concept_id in (45876322,45882500,45881618,45878386,46237067,46237075,35919762,35919199,35919922,35919359,35919520,35919183,35919664,35919321,35919223,35919795,35919415,35919132)
-- End Measurement Criteria

) C on C.person_id = I.person_id and C.start_date >= I.start_date and C.START_DATE <= I.op_end_date
GROUP BY i.event_id, i.person_id


),
first_ends (person_id, start_date, end_date) as
(
	select F.person_id, F.start_date, F.end_date
	FROM (
	  select I.event_id, I.person_id, I.start_date, E.end_date, row_number() over (partition by I.person_id, I.event_id order by E.end_date) as ordinal
	  from #included_events I
	  join cohort_ends E on I.event_id = E.event_id and I.person_id = E.person_id and E.end_date >= I.start_date
	) F
	WHERE F.ordinal = 1
)
select person_id, start_date, end_date
INTO #cohort_rows
from first_ends;

with cteEndDates (person_id, end_date) AS -- the magic
(
	SELECT
		person_id
		, DATEADD(day,-1 * 0, event_date)  as end_date
	FROM
	(
		SELECT
			person_id
			, event_date
			, event_type
			, MAX(start_ordinal) OVER (PARTITION BY person_id ORDER BY event_date, event_type ROWS UNBOUNDED PRECEDING) AS start_ordinal
			, ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY event_date, event_type) AS overall_ord
		FROM
		(
			SELECT
				person_id
				, start_date AS event_date
				, -1 AS event_type
				, ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY start_date) AS start_ordinal
			FROM #cohort_rows

			UNION ALL


			SELECT
				person_id
				, DATEADD(day,0,end_date) as end_date
				, 1 AS event_type
				, NULL
			FROM #cohort_rows
		) RAWDATA
	) e
	WHERE (2 * e.start_ordinal) - e.overall_ord = 0
),
cteEnds (person_id, start_date, end_date) AS
(
	SELECT
		 c.person_id
		, c.start_date
		, MIN(e.end_date) AS end_date
	FROM #cohort_rows c
	JOIN cteEndDates e ON c.person_id = e.person_id AND e.end_date >= c.start_date
	GROUP BY c.person_id, c.start_date
)
select person_id, min(start_date) as start_date, end_date
into #final_cohort
from cteEnds
group by person_id, end_date
;

DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;
INSERT INTO @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select @target_cohort_id as cohort_definition_id, person_id, start_date, end_date
FROM #final_cohort CO
;





TRUNCATE TABLE #cohort_rows;
DROP TABLE #cohort_rows;

TRUNCATE TABLE #final_cohort;
DROP TABLE #final_cohort;

TRUNCATE TABLE #inclusion_events;
DROP TABLE #inclusion_events;

TRUNCATE TABLE #qualified_events;
DROP TABLE #qualified_events;

TRUNCATE TABLE #included_events;
DROP TABLE #included_events;

TRUNCATE TABLE #Codesets;
DROP TABLE #Codesets;
