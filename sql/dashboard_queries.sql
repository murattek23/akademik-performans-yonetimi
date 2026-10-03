-- Bölüm Başkanı / Dekan Dashboard - Filtreli Sorguları

-- 1. DEKAN DASHBOARD: Tüm bölümlerin genel performans özeti
CREATE OR REPLACE VIEW vw_dean_dashboard_summary AS
SELECT
    d.id AS department_id,
    d.name AS department_name,
    d.code AS department_code,
    COUNT(DISTINCT u.id) AS total_staff,
    COUNT(DISTINCT CASE WHEN u.is_active = TRUE THEN u.id END) AS active_staff,
    ROUND(AVG(COALESCE(pe.total_score, 0)), 2) AS avg_performance_score,
    ROUND(AVG(COALESCE(pe.teaching_score, 0)), 2) AS avg_teaching_score,
    ROUND(AVG(COALESCE(pe.research_score, 0)), 2) AS avg_research_score,
    ROUND(AVG(COALESCE(pe.service_score, 0)), 2) AS avg_service_score,
    ROUND(AVG(COALESCE(pe.admin_score, 0)), 2) AS avg_admin_score
FROM departments d
LEFT JOIN users u ON u.department_id = d.id
LEFT JOIN performance_evaluations pe ON pe.user_id = u.id
GROUP BY d.id, d.name, d.code
ORDER BY avg_performance_score DESC;

-- 2. BÖLÜM BAŞKANI DASHBOARD: Bölüm içindeki personel performansı (dönem bazlı)
CREATE OR REPLACE VIEW vw_department_head_dashboard AS
SELECT
    u.id AS user_id,
    u.full_name,
    u.academic_rank,
    u.title,
    d.name AS department_name,
    at.id AS academic_term_id,
    at.name AS academic_term_name,
    EXTRACT(YEAR FROM at.start_date)::int AS report_year,
    COUNT(DISTINCT ca.id) AS course_count,
    COALESCE(SUM(ca.student_count), 0) AS total_students,
    COUNT(DISTINCT p.id) AS publication_count,
    COALESCE(SUM(pm.citation_count), 0) AS total_citations,
    COUNT(DISTINCT ar.id) AS advising_count,
    COUNT(DISTINCT adt.id) AS admin_task_count,
    ROUND(COALESCE(pe.teaching_score, 0), 2) AS teaching_score,
    ROUND(COALESCE(pe.research_score, 0), 2) AS research_score,
    ROUND(COALESCE(pe.service_score, 0), 2) AS service_score,
    ROUND(COALESCE(pe.admin_score, 0), 2) AS admin_score,
    ROUND(COALESCE(pe.total_score, 0), 2) AS total_score,
    pe.comments AS evaluation_comments
FROM users u
JOIN departments d ON d.id = u.department_id
LEFT JOIN course_assignments ca ON ca.user_id = u.id
LEFT JOIN academic_terms at ON at.id = ca.academic_term_id
LEFT JOIN publications p ON p.user_id = u.id AND EXTRACT(YEAR FROM p.publication_date) = EXTRACT(YEAR FROM at.start_date)
LEFT JOIN publication_metrics pm ON pm.publication_id = p.id
LEFT JOIN advising_records ar ON ar.user_id = u.id AND ar.academic_term_id = at.id
LEFT JOIN administrative_tasks adt ON adt.user_id = u.id AND EXTRACT(YEAR FROM adt.start_date) = EXTRACT(YEAR FROM at.start_date)
LEFT JOIN performance_evaluations pe ON pe.user_id = u.id AND pe.academic_term_id = at.id
WHERE u.is_active = TRUE
GROUP BY
    u.id, u.full_name, u.academic_rank, u.title,
    d.name, at.id, at.name,
    pe.teaching_score, pe.research_score, pe.service_score, pe.admin_score,
    pe.total_score, pe.comments
ORDER BY at.start_date DESC, total_score DESC NULLS LAST;

-- 3. YILLIK PERFORMANS RAPORU (Bölüm Başkanı filtreleme)
CREATE OR REPLACE VIEW vw_yearly_department_performance AS
WITH yearly_data AS (
    SELECT
        u.id AS user_id,
        u.full_name,
        u.academic_rank,
        d.id AS department_id,
        d.name AS department_name,
        EXTRACT(YEAR FROM at.start_date)::int AS report_year,
        COUNT(DISTINCT ca.id) AS course_count,
        COALESCE(SUM(ca.student_count), 0) AS total_students,
        COUNT(DISTINCT p.id) AS publication_count,
        COALESCE(SUM(pm.citation_count), 0) AS total_citations,
        COUNT(DISTINCT rp.id) AS project_count,
        COUNT(DISTINCT ar.id) AS advising_count,
        COUNT(DISTINCT adt.id) AS admin_task_count,
        ROUND(
            (COUNT(DISTINCT ca.id) * 20) +
            (COALESCE(SUM(ca.student_count), 0) * 0.05),
            2
        ) AS teaching_score,
        ROUND(
            (COUNT(DISTINCT p.id) * 20) +
            (COALESCE(SUM(pm.citation_count), 0) * 0.7) +
            (COUNT(DISTINCT rp.id) * 12),
            2
        ) AS research_score,
        ROUND(
            (COUNT(DISTINCT adt.id) * 10) +
            (COUNT(DISTINCT ar.id) * 8),
            2
        ) AS service_score
    FROM users u
    JOIN departments d ON d.id = u.department_id
    CROSS JOIN academic_terms at
    LEFT JOIN course_assignments ca ON ca.user_id = u.id AND ca.academic_term_id = at.id
    LEFT JOIN publications p ON p.user_id = u.id AND EXTRACT(YEAR FROM p.publication_date) = EXTRACT(YEAR FROM at.start_date)
    LEFT JOIN publication_metrics pm ON pm.publication_id = p.id
    LEFT JOIN research_projects rp ON rp.principal_investigator_id = u.id AND EXTRACT(YEAR FROM rp.start_date) = EXTRACT(YEAR FROM at.start_date)
    LEFT JOIN advising_records ar ON ar.user_id = u.id AND ar.academic_term_id = at.id
    LEFT JOIN administrative_tasks adt ON adt.user_id = u.id AND EXTRACT(YEAR FROM adt.start_date) = EXTRACT(YEAR FROM at.start_date)
    WHERE u.is_active = TRUE
    GROUP BY u.id, u.full_name, u.academic_rank, d.id, d.name, EXTRACT(YEAR FROM at.start_date)::int
)
SELECT
    user_id,
    full_name,
    academic_rank,
    department_id,
    department_name,
    report_year,
    course_count,
    total_students,
    publication_count,
    total_citations,
    project_count,
    advising_count,
    admin_task_count,
    ROUND(COALESCE(teaching_score, 0), 2) AS teaching_score,
    ROUND(COALESCE(research_score, 0), 2) AS research_score,
    ROUND(COALESCE(service_score, 0), 2) AS service_score,
    ROUND(
        (COALESCE(teaching_score, 0) * 0.30) +
        (COALESCE(research_score, 0) * 0.40) +
        (COALESCE(service_score, 0) * 0.20),
        2
    ) AS total_score
FROM yearly_data
ORDER BY report_year DESC, total_score DESC NULLS LAST;

-- 4. BÖLÜM ÖZETİ: Bölüm başkanı kendisinin görebileceği özet
CREATE OR REPLACE VIEW vw_department_summary AS
SELECT
    d.id AS department_id,
    d.name AS department_name,
    d.code AS department_code,
    COUNT(DISTINCT u.id) AS total_staff,
    COUNT(DISTINCT CASE WHEN u.is_active = TRUE THEN u.id END) AS active_staff,
    COUNT(DISTINCT CASE WHEN u.academic_rank = 'Profesör' THEN u.id END) AS professor_count,
    COUNT(DISTINCT CASE WHEN u.academic_rank = 'Doçent' THEN u.id END) AS associate_professor_count,
    COUNT(DISTINCT CASE WHEN u.academic_rank = 'Yardımcı Doçent' THEN u.id END) AS assistant_professor_count,
    COUNT(DISTINCT ca.id) AS total_course_assignments,
    COUNT(DISTINCT p.id) AS total_publications,
    COUNT(DISTINCT rp.id) AS total_projects,
    COALESCE(SUM(rp.project_budget), 0) AS total_project_budget,
    ROUND(AVG(COALESCE(pe.total_score, 0)), 2) AS avg_total_score
FROM departments d
LEFT JOIN users u ON u.department_id = d.id
LEFT JOIN course_assignments ca ON ca.user_id = u.id
LEFT JOIN publications p ON p.department_id = d.id
LEFT JOIN research_projects rp ON rp.department_id = d.id
LEFT JOIN performance_evaluations pe ON pe.user_id = u.id
GROUP BY d.id, d.name, d.code
ORDER BY avg_total_score DESC NULLS LAST;

-- 5. PERFORMANS KARŞILAŞTIRMA: Bölüm içinde akademik sıralama
CREATE OR REPLACE VIEW vw_performance_ranking AS
SELECT
    ROW_NUMBER() OVER (PARTITION BY d.id ORDER BY pe.total_score DESC NULLS LAST) AS rank_within_department,
    u.id AS user_id,
    u.full_name,
    u.academic_rank,
    d.id AS department_id,
    d.name AS department_name,
    at.id AS academic_term_id,
    at.name AS academic_term_name,
    ROUND(COALESCE(pe.teaching_score, 0), 2) AS teaching_score,
    ROUND(COALESCE(pe.research_score, 0), 2) AS research_score,
    ROUND(COALESCE(pe.service_score, 0), 2) AS service_score,
    ROUND(COALESCE(pe.admin_score, 0), 2) AS admin_score,
    ROUND(COALESCE(pe.total_score, 0), 2) AS total_score,
    CASE
        WHEN COALESCE(pe.total_score, 0) >= 85 THEN 'Excellent'
        WHEN COALESCE(pe.total_score, 0) >= 75 THEN 'Good'
        WHEN COALESCE(pe.total_score, 0) >= 65 THEN 'Satisfactory'
        ELSE 'Needs Improvement'
    END AS performance_rating
FROM users u
JOIN departments d ON d.id = u.department_id
LEFT JOIN performance_evaluations pe ON pe.user_id = u.id
LEFT JOIN academic_terms at ON at.id = pe.academic_term_id
WHERE u.is_active = TRUE
ORDER BY d.id, pe.total_score DESC NULLS LAST;

-- 6. ÖRNEK FILTRELI SORGU: Dekan dashboard (belirli bölüm ve yıl)
CREATE OR REPLACE FUNCTION get_department_performance(
    p_department_id BIGINT DEFAULT NULL,
    p_year INT DEFAULT NULL
)
RETURNS TABLE (
    user_id BIGINT,
    full_name VARCHAR,
    department_name VARCHAR,
    academic_rank VARCHAR,
    report_year INT,
    course_count BIGINT,
    publication_count BIGINT,
    teaching_score NUMERIC,
    research_score NUMERIC,
    service_score NUMERIC,
    total_score NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id,
        u.full_name,
        d.name,
        u.academic_rank,
        EXTRACT(YEAR FROM at.start_date)::int,
        COUNT(DISTINCT ca.id),
        COUNT(DISTINCT p.id),
        ROUND(COALESCE(pe.teaching_score, 0), 2),
        ROUND(COALESCE(pe.research_score, 0), 2),
        ROUND(COALESCE(pe.service_score, 0), 2),
        ROUND(COALESCE(pe.total_score, 0), 2)
    FROM users u
    JOIN departments d ON d.id = u.department_id
    LEFT JOIN course_assignments ca ON ca.user_id = u.id
    LEFT JOIN academic_terms at ON at.id = ca.academic_term_id
    LEFT JOIN publications p ON p.user_id = u.id AND EXTRACT(YEAR FROM p.publication_date) = EXTRACT(YEAR FROM at.start_date)
    LEFT JOIN performance_evaluations pe ON pe.user_id = u.id AND pe.academic_term_id = at.id
    WHERE
        u.is_active = TRUE
        AND (p_department_id IS NULL OR d.id = p_department_id)
        AND (p_year IS NULL OR EXTRACT(YEAR FROM at.start_date)::int = p_year)
    GROUP BY u.id, u.full_name, d.name, u.academic_rank, EXTRACT(YEAR FROM at.start_date)::int,
             pe.teaching_score, pe.research_score, pe.service_score, pe.total_score
    ORDER BY COALESCE(pe.total_score, 0) DESC;
END;
$$ LANGUAGE plpgsql;
