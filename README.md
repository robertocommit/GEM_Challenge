# Surgeon Performance Analysis for Hip Replacement Operations

## Introduction

This project analyzes the performance of surgeons conducting hip replacement operations. The analysis is based on patient-reported outcomes using the EQ-5D-5L questionnaire, which measures quality of life before and after surgery.

## Objective

To identify the most and least skillful surgeons for hip replacement operations based on patient outcome improvements.

## EQ-5D-5L Questionnaire

The EQ-5D-5L questionnaire consists of five dimensions:

1. Mobility
2. Self-Care
3. Usual Activities
4. Pain/Discomfort
5. Anxiety/Depression

Each dimension has five levels:

1. No problems
2. Slight problems
3. Moderate problems
4. Severe problems
5. Unable to do / Extreme problems

## Conversion Table

The conversion table provides central estimates for each level of each dimension. These estimates are used to calculate the overall health state score.

| Dimension          | Slight | Moderate | Severe | Unable/Extreme |
|--------------------|--------|----------|--------|----------------|
| Mobility           | 0.058  | 0.076    | 0.207  | 0.274          |
| Self-care          | 0.050  | 0.080    | 0.164  | 0.203          |
| Usual activities   | 0.050  | 0.063    | 0.162  | 0.184          |
| Pain/discomfort    | 0.063  | 0.084    | 0.276  | 0.335          |
| Anxiety/depression | 0.078  | 0.104    | 0.285  | 0.289          |

## Data Sources

The analysis uses the following tables from the database schema `ce75a2772c067990e714f61ceff7b8a30`:

- `patients`: Contains patient information, including the surgeon who performed their operation.
- `surgeons`: Contains information about the surgeons.
- `questionnaires`: Contains information about the questionnaires, including type (pre or post) and treatment.
- `questions`: Contains the questions asked in the questionnaires.
- `answers`: Contains the patients' responses to the questionnaires.
- `answer_options`: Contains the possible answers and their corresponding central estimates for score calculation.

## Methodology

1. **Data Validation**
   - Verify the presence of both pre- and post-operation questionnaires for hip replacement patients.
   - Confirm that answers are correctly mapped to central estimates in the `answer_options` table.

2. **Health Score Calculation**
   - For each questionnaire (pre and post):
     - Sum the central estimates for all five dimensions.
     - Subtract this sum from 1 to get the health score.

3. **Improvement Calculation**
   - For each patient, calculate the difference between post-operation and pre-operation health scores.

4. **Surgeon Performance Evaluation**
   - Group improvements by surgeon.
   - Calculate the average improvement for each surgeon.

5. **Ranking**
   - Rank surgeons based on their average improvement scores.

## SQL Query

<details>
<summary>Click to expand the full test query</summary>

```sql
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
```

</details>

## Query Results

Here are the results of our analysis, showing the average improvement scores and skill rankings for each surgeon:

| Surgeon Name    | Avg. Improvement | Skill Rank |
|-----------------|------------------|------------|
| Boba Fett       | 0.1296688815     | 1          |
| Luke Skywalker  | 0.1248244897     | 2          |
| Han Solo        | 0.1230739176     | 3          |
| Padme Amidala   | 0.1223412271     | 4          |
| Darth Vader     | 0.1217098765     | 5          |
| Princess Leia   | 0.1186246185     | 6          |
| Mon Mothma      | 0.1113545647     | 7          |
| Yoda            | 0.1091864057     | 8          |
| Darth Maul      | 0.1090649895     | 9          |
| Obi-Wan Kenobi  | 0.1078102108     | 10         |

## Results Interpretation

Based on the query results, we can interpret the data as follows:

1. **Performance Range**: The average improvement scores range from approximately 0.1078 to 0.1296, indicating a relatively narrow spread of performance across all surgeons. This suggests a consistent level of care across the surgical team.

2. **Top Performers**: Boba Fett and Luke Skywalker stand out as the top performers, with the highest average improvement scores. Their patients showed the greatest positive change in reported health outcomes following hip replacement surgery.

3. **Bottom Performers**: Obi-Wan Kenobi and Darth Maul have the lowest average improvement scores. However, it's important to note that their scores are still positive, indicating that their patients generally experienced improved health outcomes post-surgery.

4. **Marginal Differences**: The differences in average improvement scores between adjacent ranks are small, particularly in the middle of the rankings. This suggests that the performance of many surgeons is quite similar.

5. **Overall Positive Outcomes**: All surgeons have positive average improvement scores, which is encouraging. This indicates that, on average, patients reported better health outcomes after their hip replacement surgeries, regardless of the surgeon.

6. **Context for Interpretation**: While these rankings provide valuable insights, they should be interpreted with caution. Factors such as patient complexity, pre-existing conditions, and the number of surgeries performed by each surgeon are not accounted for in this analysis.

7. **Use of Results**: These results can be used as a starting point for further investigation. For instance, examining the techniques or practices of the top-performing surgeons could potentially identify best practices that could be shared across the team.

8. **Continuous Improvement**: Even the highest-ranked surgeons have room for improvement, as the maximum average improvement score is still significantly below the theoretical maximum of 1.0.

## Limitations and Considerations

- This analysis assumes that the difference between pre- and post-operation scores is the best indicator of a surgeon's skill.
- It does not account for factors such as patient complexity or initial condition severity.
- The results should be interpreted in conjunction with other performance metrics and clinical expertise.
- The number of surgeries performed by each surgeon may vary, which could affect the reliability of the average improvement score.

## Future Improvements

- Incorporate additional factors such as patient demographics and medical history.
- Analyze performance trends over time.
- Include statistical significance tests for the differences in surgeon performance.
- Consider the volume of surgeries performed by each surgeon in the analysis.
- Investigate any outliers or unexpected results in more detail.

## Test

To ensure the accuracy of our surgeon performance analysis, we've implemented a testing strategy using mock data. This approach validates our SQL query and confirms correct calculation of surgeon performance based on patient outcomes.

### Test Strategy

1. Create mock data for patients, surgeons, and questionnaire responses.
2. Calculate expected outcomes manually.
3. Run the analysis query on mock data.
4. Compare query results with expected outcomes.

### Test Query

<details>
<summary>Click to expand the full test query</summary>

```sql
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
```

</details>

### Test Validation

A result is considered valid if the difference between calculated and expected improvement is less than 0.00001.

### Importance of Testing

This testing approach:
1. Validates SQL query logic correctness.
2. Ensures changes don't affect results unexpectedly.
3. Provides a safety net for future modifications.
4. Helps understand expected behavior for different scenarios.

## Test Results

After running our test query with mock data, we obtained the following results:

| Surgeon Name | Avg. Improvement | Skill Rank | Expected Improvement | Test Result |
|--------------|------------------|------------|----------------------|-------------|
| Dr. Johnson  | 0.7360           | 1          | 0.7360               | PASS        |
| Dr. Smith    | 0.2660           | 2          | 0.2660               | PASS        |
| Dr. Williams | 0.0840           | 3          | 0.0840               | PASS        |
| Dr. Brown    | 0.0000           | 4          | 0.0000               | PASS        |
| Dr. Jones    | -0.1070          | 5          | -0.1070              | PASS        |
