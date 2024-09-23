-- Gather patient data and calculate central estimates
WITH dimension_scores AS (
    SELECT 
        p.surgeon_id,
        p.id AS patient_id,
        q.type,
        SUM(1 - ao.central_estimate) AS health_score
    FROM ce75a2772c067990e714f61ceff7b8a30.patients p
    JOIN ce75a2772c067990e714f61ceff7b8a30.answers a ON p.id = a.patient_id
    JOIN ce75a2772c067990e714f61ceff7b8a30.answer_options ao ON a.question_id = ao.question_id AND a.answer = ao.answer
    JOIN ce75a2772c067990e714f61ceff7b8a30.questionnaires q ON a.questionnaire_id = q.id
    WHERE q.treatment = 'Hip'
    GROUP BY p.surgeon_id, p.id, q.type
),

-- Calculate average improvement for each surgeon
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
)

-- Final result: Rank surgeons based on average improvement scores
SELECT 
    s.name AS surgeon_name,
    si.avg_improvement,
    RANK() OVER (ORDER BY si.avg_improvement DESC) AS skill_rank
FROM score_improvements si
JOIN ce75a2772c067990e714f61ceff7b8a30.surgeons s ON si.surgeon_id = s.id
ORDER BY si.avg_improvement DESC;
