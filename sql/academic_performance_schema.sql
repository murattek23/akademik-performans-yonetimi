-- PostgreSQL DDL for academic performance management system

CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE departments (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    parent_department_id BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_departments_parent
        FOREIGN KEY (parent_department_id)
        REFERENCES departments(id)
        ON DELETE SET NULL
);

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    title VARCHAR(100),
    academic_rank VARCHAR(100),
    department_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_users_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON DELETE RESTRICT
);

CREATE TABLE academic_terms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_current BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (end_date >= start_date)
);

CREATE TABLE courses (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    department_id BIGINT NOT NULL,
    credit_hours INTEGER NOT NULL CHECK (credit_hours > 0),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT
);

CREATE TABLE course_assignments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    academic_term_id BIGINT NOT NULL,
    section_name VARCHAR(100),
    student_count INTEGER NOT NULL DEFAULT 0 CHECK (student_count >= 0),
    hours_per_week NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (hours_per_week >= 0),
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_course_assignments_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_course_assignments_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_course_assignments_term
        FOREIGN KEY (academic_term_id)
        REFERENCES academic_terms(id)
        ON DELETE RESTRICT,
    UNIQUE (user_id, course_id, academic_term_id, section_name)
);

CREATE TABLE research_projects (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    principal_investigator_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    funding_source VARCHAR(200),
    project_budget NUMERIC(18,2) DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_research_projects_pi
        FOREIGN KEY (principal_investigator_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_research_projects_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT,
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE project_members (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role_in_project VARCHAR(100) NOT NULL,
    contribution_percentage NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (contribution_percentage >= 0 AND contribution_percentage <= 100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_project_members_project
        FOREIGN KEY (project_id)
        REFERENCES research_projects(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_project_members_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    UNIQUE (project_id, user_id)
);

CREATE TABLE publications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,
    title VARCHAR(400) NOT NULL,
    publication_type VARCHAR(100) NOT NULL,
    venue VARCHAR(250),
    publication_date DATE,
    doi VARCHAR(255),
    authors TEXT,
    abstract TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'draft',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_publications_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_publications_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT
);

CREATE TABLE publication_metrics (
    id BIGSERIAL PRIMARY KEY,
    publication_id BIGINT NOT NULL UNIQUE,
    citation_count INTEGER NOT NULL DEFAULT 0 CHECK (citation_count >= 0),
    h_index_impact NUMERIC(6,2) DEFAULT 0,
    altmetric_score NUMERIC(8,2) DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_publication_metrics_publication
        FOREIGN KEY (publication_id)
        REFERENCES publications(id)
        ON DELETE CASCADE
);

CREATE TABLE advising_records (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    student_name VARCHAR(200) NOT NULL,
    student_id VARCHAR(100),
    adviser_type VARCHAR(100) NOT NULL,
    academic_term_id BIGINT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_advising_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_advising_term
        FOREIGN KEY (academic_term_id)
        REFERENCES academic_terms(id)
        ON DELETE RESTRICT
);

CREATE TABLE administrative_tasks (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    task_name VARCHAR(200) NOT NULL,
    task_type VARCHAR(100) NOT NULL,
    description TEXT,
    department_id BIGINT NOT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_admin_tasks_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_admin_tasks_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE RESTRICT,
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE performance_goals (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    academic_term_id BIGINT NOT NULL,
    goal_type VARCHAR(100) NOT NULL,
    title VARCHAR(250) NOT NULL,
    description TEXT,
    target_value NUMERIC(12,2) NOT NULL DEFAULT 0,
    actual_value NUMERIC(12,2) NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_goals_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_goals_term
        FOREIGN KEY (academic_term_id)
        REFERENCES academic_terms(id)
        ON DELETE RESTRICT
);

CREATE TABLE performance_evaluations (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    evaluator_id BIGINT NOT NULL,
    academic_term_id BIGINT NOT NULL,
    teaching_score NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (teaching_score >= 0 AND teaching_score <= 100),
    research_score NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (research_score >= 0 AND research_score <= 100),
    service_score NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (service_score >= 0 AND service_score <= 100),
    admin_score NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (admin_score >= 0 AND admin_score <= 100),
    total_score NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (total_score >= 0 AND total_score <= 100),
    comments TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_eval_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_eval_evaluator
        FOREIGN KEY (evaluator_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_eval_term
        FOREIGN KEY (academic_term_id)
        REFERENCES academic_terms(id)
        ON DELETE RESTRICT
);

CREATE TABLE evaluation_criteria (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    category VARCHAR(100) NOT NULL,
    weight NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (weight >= 0 AND weight <= 100),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE evaluation_criterion_scores (
    id BIGSERIAL PRIMARY KEY,
    evaluation_id BIGINT NOT NULL,
    criterion_id BIGINT NOT NULL,
    score NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (score >= 0 AND score <= 100),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_eval_score_eval
        FOREIGN KEY (evaluation_id)
        REFERENCES performance_evaluations(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_eval_score_criterion
        FOREIGN KEY (criterion_id)
        REFERENCES evaluation_criteria(id)
        ON DELETE RESTRICT,
    UNIQUE (evaluation_id, criterion_id)
);

CREATE TABLE reports (
    id BIGSERIAL PRIMARY KEY,
    generated_by_user_id BIGINT NOT NULL,
    report_type VARCHAR(100) NOT NULL,
    academic_term_id BIGINT,
    department_id BIGINT,
    file_url TEXT,
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_reports_generator
        FOREIGN KEY (generated_by_user_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_reports_term
        FOREIGN KEY (academic_term_id)
        REFERENCES academic_terms(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_reports_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE SET NULL
);

CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(100) NOT NULL DEFAULT 'info',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_notifications_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    action_type VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_audit_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE SET NULL
);

-- Indexes for common lookups
CREATE INDEX idx_users_department_id ON users(department_id);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_course_assignments_user_id ON course_assignments(user_id);
CREATE INDEX idx_course_assignments_term_id ON course_assignments(academic_term_id);
CREATE INDEX idx_research_projects_pi_id ON research_projects(principal_investigator_id);
CREATE INDEX idx_publications_user_id ON publications(user_id);
CREATE INDEX idx_publications_department_id ON publications(department_id);
CREATE INDEX idx_advising_user_id ON advising_records(user_id);
CREATE INDEX idx_admin_tasks_user_id ON administrative_tasks(user_id);
CREATE INDEX idx_goals_user_term ON performance_goals(user_id, academic_term_id);
CREATE INDEX idx_evaluations_user_term ON performance_evaluations(user_id, academic_term_id);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);

-- Optional trigger to update updated_at automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_roles_updated_at
BEFORE UPDATE ON roles
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_departments_updated_at
BEFORE UPDATE ON departments
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_academic_terms_updated_at
BEFORE UPDATE ON academic_terms
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_courses_updated_at
BEFORE UPDATE ON courses
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_course_assignments_updated_at
BEFORE UPDATE ON course_assignments
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_research_projects_updated_at
BEFORE UPDATE ON research_projects
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_publications_updated_at
BEFORE UPDATE ON publications
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_publication_metrics_updated_at
BEFORE UPDATE ON publication_metrics
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_advising_records_updated_at
BEFORE UPDATE ON advising_records
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_admin_tasks_updated_at
BEFORE UPDATE ON administrative_tasks
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_performance_goals_updated_at
BEFORE UPDATE ON performance_goals
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_performance_evaluations_updated_at
BEFORE UPDATE ON performance_evaluations
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_evaluation_criteria_updated_at
BEFORE UPDATE ON evaluation_criteria
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_eval_scores_updated_at
BEFORE UPDATE ON evaluation_criterion_scores
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();