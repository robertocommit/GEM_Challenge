-- Create temporary tables with test data
WITH test_patients AS (
    SELECT 1 AS id, 101 AS surgeon_id UNION ALL
    SELECT 2 AS id, 102 AS surgeon_id UNION ALL
    SELECT 3 AS id, 103 AS surgeon_id UNION ALL
    SELECT 4 AS id, 104 AS surgeon_id UNION ALL
    SELECT 5 AS id, 105 AS surgeon_id
),
test_questionnaires AS (
    SELECT 1 AS id, 'pre' AS type, 'Hip' AS treatment UNION ALL
    SELECT 2 AS id, 'post' AS type, 'Hip' AS treatment
),
test_answers AS (
    -- Patient 1 (Moderate improvement)
    SELECT 1 AS patient_id, 1 AS questionnaire_id, 1 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 1 AS patient_id, 1 AS questionnaire_id, 2 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 1 AS patient_id, 1 AS questionnaire_id, 3 AS question_id, 'Severe' AS answer UNION ALL
    SELECT 1 AS patient_id, 1 AS questionnaire_id, 4 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 1 AS patient_id, 1 AS questionnaire_id, 5 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 1 AS patient_id, 2 AS questionnaire_id, 1 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 1 AS patient_id, 2 AS questionnaire_id, 2 AS question_id, 'No problems' AS answer UNION ALL
    SELECT 1 AS patient_id, 2 AS questionnaire_id, 3 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 1 AS patient_id, 2 AS questionnaire_id, 4 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 1 AS patient_id, 2 AS questionnaire_id, 5 AS question_id, 'No problems' AS answer UNION ALL

    -- Patient 2 (Significant improvement)
    SELECT 2 AS patient_id, 1 AS questionnaire_id, 1 AS question_id, 'Severe' AS answer UNION ALL
    SELECT 2 AS patient_id, 1 AS questionnaire_id, 2 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 2 AS patient_id, 1 AS questionnaire_id, 3 AS question_id, 'Severe' AS answer UNION ALL
    SELECT 2 AS patient_id, 1 AS questionnaire_id, 4 AS question_id, 'Extreme' AS answer UNION ALL
    SELECT 2 AS patient_id, 1 AS questionnaire_id, 5 AS question_id, 'Severe' AS answer UNION ALL
    SELECT 2 AS patient_id, 2 AS questionnaire_id, 1 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 2 AS patient_id, 2 AS questionnaire_id, 2 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 2 AS patient_id, 2 AS questionnaire_id, 3 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 2 AS patient_id, 2 AS questionnaire_id, 4 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 2 AS patient_id, 2 AS questionnaire_id, 5 AS question_id, 'Slight' AS answer UNION ALL

    -- Patient 3 (Slight improvement)
    SELECT 3 AS patient_id, 1 AS questionnaire_id, 1 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 3 AS patient_id, 1 AS questionnaire_id, 2 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 3 AS patient_id, 1 AS questionnaire_id, 3 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 3 AS patient_id, 1 AS questionnaire_id, 4 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 3 AS patient_id, 1 AS questionnaire_id, 5 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 3 AS patient_id, 2 AS questionnaire_id, 1 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 3 AS patient_id, 2 AS questionnaire_id, 2 AS question_id, 'No problems' AS answer UNION ALL
    SELECT 3 AS patient_id, 2 AS questionnaire_id, 3 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 3 AS patient_id, 2 AS questionnaire_id, 4 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 3 AS patient_id, 2 AS questionnaire_id, 5 AS question_id, 'Slight' AS answer UNION ALL

    -- Patient 4 (No improvement)
    SELECT 4 AS patient_id, 1 AS questionnaire_id, 1 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 4 AS patient_id, 1 AS questionnaire_id, 2 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 4 AS patient_id, 1 AS questionnaire_id, 3 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 4 AS patient_id, 1 AS questionnaire_id, 4 AS question_id, 'Severe' AS answer UNION ALL
    SELECT 4 AS patient_id, 1 AS questionnaire_id, 5 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 4 AS patient_id, 2 AS questionnaire_id, 1 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 4 AS patient_id, 2 AS questionnaire_id, 2 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 4 AS patient_id, 2 AS questionnaire_id, 3 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 4 AS patient_id, 2 AS questionnaire_id, 4 AS question_id, 'Severe' AS answer UNION ALL
    SELECT 4 AS patient_id, 2 AS questionnaire_id, 5 AS question_id, 'Moderate' AS answer UNION ALL

    -- Patient 5 (Slight deterioration)
    SELECT 5 AS patient_id, 1 AS questionnaire_id, 1 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 5 AS patient_id, 1 AS questionnaire_id, 2 AS question_id, 'No problems' AS answer UNION ALL
    SELECT 5 AS patient_id, 1 AS questionnaire_id, 3 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 5 AS patient_id, 1 AS questionnaire_id, 4 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 5 AS patient_id, 1 AS questionnaire_id, 5 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 5 AS patient_id, 2 AS questionnaire_id, 1 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 5 AS patient_id, 2 AS questionnaire_id, 2 AS question_id, 'Slight' AS answer UNION ALL
    SELECT 5 AS patient_id, 2 AS questionnaire_id, 3 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 5 AS patient_id, 2 AS questionnaire_id, 4 AS question_id, 'Moderate' AS answer UNION ALL
    SELECT 5 AS patient_id, 2 AS questionnaire_id, 5 AS question_id, 'Moderate' AS answer
),
test_answer_options AS (
    SELECT 1 AS question_id, 'No problems' AS answer, 0 AS central_estimate UNION ALL
    SELECT 1 AS question_id, 'Slight' AS answer, 0.058 AS central_estimate UNION ALL
    SELECT 1 AS question_id, 'Moderate' AS answer, 0.076 AS central_estimate UNION ALL
    SELECT 1 AS question_id, 'Severe' AS answer, 0.207 AS central_estimate UNION ALL
    SELECT 1 AS question_id, 'Unable' AS answer, 0.274 AS central_estimate UNION ALL
    SELECT 2 AS question_id, 'No problems' AS answer, 0 AS central_estimate UNION ALL
    SELECT 2 AS question_id, 'Slight' AS answer, 0.050 AS central_estimate UNION ALL
    SELECT 2 AS question_id, 'Moderate' AS answer, 0.080 AS central_estimate UNION ALL
    SELECT 2 AS question_id, 'Severe' AS answer, 0.164 AS central_estimate UNION ALL
    SELECT 2 AS question_id, 'Unable' AS answer, 0.203 AS central_estimate UNION ALL
    SELECT 3 AS question_id, 'No problems' AS answer, 0 AS central_estimate UNION ALL
    SELECT 3 AS question_id, 'Slight' AS answer, 0.050 AS central_estimate UNION ALL
    SELECT 3 AS question_id, 'Moderate' AS answer, 0.063 AS central_estimate UNION ALL
    SELECT 3 AS question_id, 'Severe' AS answer, 0.162 AS central_estimate UNION ALL
    SELECT 3 AS question_id, 'Unable' AS answer, 0.184 AS central_estimate UNION ALL
    SELECT 4 AS question_id, 'No problems' AS answer, 0 AS central_estimate UNION ALL
    SELECT 4 AS question_id, 'Slight' AS answer, 0.063 AS central_estimate UNION ALL
    SELECT 4 AS question_id, 'Moderate' AS answer, 0.084 AS central_estimate UNION ALL
    SELECT 4 AS question_id, 'Severe' AS answer, 0.276 AS central_estimate UNION ALL
    SELECT 4 AS question_id, 'Extreme' AS answer, 0.335 AS central_estimate UNION ALL
    SELECT 5 AS question_id, 'No problems' AS answer, 0 AS central_estimate UNION ALL
    SELECT 5 AS question_id, 'Slight' AS answer, 0.078 AS central_estimate UNION ALL
    SELECT 5 AS question_id, 'Moderate' AS answer, 0.104 AS central_estimate UNION ALL
    SELECT 5 AS question_id, 'Severe' AS answer, 0.285 AS central_estimate UNION ALL
    SELECT 5 AS question_id, 'Extreme' AS answer, 0.289 AS central_estimate
),
test_surgeons AS (
    SELECT 101 AS id, 'Dr. Smith' AS name UNION ALL
    SELECT 102 AS id, 'Dr. Johnson' AS name UNION ALL
    SELECT 103 AS id, 'Dr. Williams' AS name UNION ALL
    SELECT 104 AS id, 'Dr. Brown' AS name UNION ALL
    SELECT 105 AS id, 'Dr. Jones' AS name
),

-- Original query logic starts here
dimension_scores AS (
    SELECT 
        p.surgeon_id,
        p.id AS patient_id,
        q.type,
        SUM(1 - ao.central_estimate) AS health_score
    FROM test_patients p
    JOIN test_answers a ON p.id = a.patient_id
    JOIN test_answer_options ao ON a.question_id = ao.question_id AND a.answer = ao.answer
    JOIN test_questionnaires q ON a.questionnaire_id = q.id
    WHERE q.treatment = 'Hip'
    GROUP BY p.surgeon_id, p.id, q.type
),
score_improvements AS (
    SELECT 
        pre.surgeon_id,
        AVG(post.health_score - pre.health_score) AS avg_improvement
    FROM dimension_scores pre
    JOIN dimension_scores post 
      ON pre.patient_id = post.patient_id 
      AND pre.surgeon_id = post.surgeon_id
    WHERE pre.type = 'pre' AND post.type = 'post'
    GROUP BY pre.surgeon_id
),
final_results AS (
    SELECT 
        s.name AS surgeon_name,
        si.avg_improvement,
        RANK() OVER (ORDER BY si.avg_improvement DESC) AS skill_rank
    FROM score_improvements si
    JOIN test_surgeons s ON si.surgeon_id = s.id
    ORDER BY si.avg_improvement DESC
),
expected_improvements AS (
    SELECT
        p.surgeon_id,
        AVG(
            (SELECT SUM(1 - ao_post.central_estimate)
             FROM test_answers a_post
             JOIN test_answer_options ao_post ON a_post.question_id = ao_post.question_id AND a_post.answer = ao_post.answer
             WHERE a_post.patient_id = p.id AND a_post.questionnaire_id = 2)
            -
            (SELECT SUM(1 - ao_pre.central_estimate)
             FROM test_answers a_pre
             JOIN test_answer_options ao_pre ON a_pre.question_id = ao_pre.question_id AND a_pre.answer = ao_pre.answer
             WHERE a_pre.patient_id = p.id AND a_pre.questionnaire_id = 1)
        ) AS expected_improvement
    FROM test_patients p
    GROUP BY p.surgeon_id
)

-- Display results with test validation
SELECT 
    fr.surgeon_name,
    fr.avg_improvement,
    fr.skill_rank,
    ei.expected_improvement,
    CASE 
        WHEN ABS(fr.avg_improvement - ei.expected_improvement) < 0.00001 
        THEN 'PASS' 
        ELSE 'FAIL' 
    END AS test_result
FROM final_results fr
JOIN expected_improvements ei ON fr.surgeon_name = (SELECT name FROM test_surgeons WHERE id = ei.surgeon_id)
ORDER BY fr.avg_improvement DESC;
