# ER Diagram - Akademik Performans Yönetimi

```mermaid
erDiagram
    ROLES ||--o{ USERS : assigns
    DEPARTMENTS ||--o{ USERS : employs
    DEPARTMENTS ||--o{ COURSES : offers
    DEPARTMENTS ||--o{ RESEARCH_PROJECTS : manages
    DEPARTMENTS ||--o{ PUBLICATIONS : hosts
    DEPARTMENTS ||--o{ ADMINISTRATIVE_TASKS : assigns
    
    USERS ||--o{ COURSE_ASSIGNMENTS : teaches
    USERS ||--o{ RESEARCH_PROJECTS : leads
    USERS ||--o{ PROJECT_MEMBERS : participates
    USERS ||--o{ PUBLICATIONS : writes
    USERS ||--o{ ADVISING_RECORDS : advises
    USERS ||--o{ ADMINISTRATIVE_TASKS : performs
    USERS ||--o{ PERFORMANCE_GOALS : sets
    USERS ||--o{ PERFORMANCE_EVALUATIONS : evaluates
    USERS ||--o{ PERFORMANCE_EVALUATIONS : receives
    USERS ||--o{ REPORTS : generates
    USERS ||--o{ NOTIFICATIONS : receives
    USERS ||--o{ AUDIT_LOGS : performs
    
    ACADEMIC_TERMS ||--o{ COURSE_ASSIGNMENTS : defines
    ACADEMIC_TERMS ||--o{ ADVISING_RECORDS : groups
    ACADEMIC_TERMS ||--o{ PERFORMANCE_GOALS : defines
    ACADEMIC_TERMS ||--o{ PERFORMANCE_EVALUATIONS : evaluates
    
    COURSES ||--o{ COURSE_ASSIGNMENTS : assigned
    
    RESEARCH_PROJECTS ||--o{ PROJECT_MEMBERS : includes
    RESEARCH_PROJECTS ||--o{ PUBLICATIONS : produces
    
    PUBLICATIONS ||--o{ PUBLICATION_METRICS : tracks
    
    PERFORMANCE_EVALUATIONS ||--o{ EVALUATION_CRITERION_SCORES : scores
    EVALUATION_CRITERIA ||--o{ EVALUATION_CRITERION_SCORES : defines
    
    ACADEMIC_TERMS ||--o{ REPORTS : generates
    DEPARTMENTS ||--o{ REPORTS : generates

    ROLES : int id PK
    ROLES : string name
    ROLES : text description

    DEPARTMENTS : int id PK
    DEPARTMENTS : string name
    DEPARTMENTS : string code
    DEPARTMENTS : int parent_department_id FK

    USERS : int id PK
    USERS : string full_name
    USERS : string email
    USERS : string academic_rank
    USERS : int department_id FK
    USERS : int role_id FK
    USERS : boolean is_active

    ACADEMIC_TERMS : int id PK
    ACADEMIC_TERMS : string name
    ACADEMIC_TERMS : date start_date
    ACADEMIC_TERMS : date end_date
    ACADEMIC_TERMS : boolean is_current

    COURSES : int id PK
    COURSES : string code
    COURSES : string name
    COURSES : int department_id FK
    COURSES : int credit_hours

    COURSE_ASSIGNMENTS : int id PK
    COURSE_ASSIGNMENTS : int user_id FK
    COURSE_ASSIGNMENTS : int course_id FK
    COURSE_ASSIGNMENTS : int academic_term_id FK
    COURSE_ASSIGNMENTS : int student_count
    COURSE_ASSIGNMENTS : numeric hours_per_week

    RESEARCH_PROJECTS : int id PK
    RESEARCH_PROJECTS : string title
    RESEARCH_PROJECTS : int principal_investigator_id FK
    RESEARCH_PROJECTS : int department_id FK
    RESEARCH_PROJECTS : date start_date
    RESEARCH_PROJECTS : date end_date
    RESEARCH_PROJECTS : string status

    PROJECT_MEMBERS : int id PK
    PROJECT_MEMBERS : int project_id FK
    PROJECT_MEMBERS : int user_id FK
    PROJECT_MEMBERS : numeric contribution_percentage

    PUBLICATIONS : int id PK
    PUBLICATIONS : int user_id FK
    PUBLICATIONS : int department_id FK
    PUBLICATIONS : string title
    PUBLICATIONS : string publication_type
    PUBLICATIONS : date publication_date
    PUBLICATIONS : string doi

    PUBLICATION_METRICS : int id PK
    PUBLICATION_METRICS : int publication_id FK
    PUBLICATION_METRICS : int citation_count
    PUBLICATION_METRICS : numeric h_index_impact

    ADVISING_RECORDS : int id PK
    ADVISING_RECORDS : int user_id FK
    ADVISING_RECORDS : string student_name
    ADVISING_RECORDS : int academic_term_id FK
    ADVISING_RECORDS : string adviser_type

    ADMINISTRATIVE_TASKS : int id PK
    ADMINISTRATIVE_TASKS : int user_id FK
    ADMINISTRATIVE_TASKS : int department_id FK
    ADMINISTRATIVE_TASKS : string task_name
    ADMINISTRATIVE_TASKS : string task_type
    ADMINISTRATIVE_TASKS : date start_date
    ADMINISTRATIVE_TASKS : date end_date

    PERFORMANCE_GOALS : int id PK
    PERFORMANCE_GOALS : int user_id FK
    PERFORMANCE_GOALS : int academic_term_id FK
    PERFORMANCE_GOALS : string goal_type
    PERFORMANCE_GOALS : string title
    PERFORMANCE_GOALS : numeric target_value
    PERFORMANCE_GOALS : numeric actual_value

    PERFORMANCE_EVALUATIONS : int id PK
    PERFORMANCE_EVALUATIONS : int user_id FK
    PERFORMANCE_EVALUATIONS : int evaluator_id FK
    PERFORMANCE_EVALUATIONS : int academic_term_id FK
    PERFORMANCE_EVALUATIONS : numeric teaching_score
    PERFORMANCE_EVALUATIONS : numeric research_score
    PERFORMANCE_EVALUATIONS : numeric service_score
    PERFORMANCE_EVALUATIONS : numeric admin_score
    PERFORMANCE_EVALUATIONS : numeric total_score

    EVALUATION_CRITERIA : int id PK
    EVALUATION_CRITERIA : string name
    EVALUATION_CRITERIA : string category
    EVALUATION_CRITERIA : numeric weight

    EVALUATION_CRITERION_SCORES : int id PK
    EVALUATION_CRITERION_SCORES : int evaluation_id FK
    EVALUATION_CRITERION_SCORES : int criterion_id FK
    EVALUATION_CRITERION_SCORES : numeric score

    REPORTS : int id PK
    REPORTS : int generated_by_user_id FK
    REPORTS : string report_type
    REPORTS : int academic_term_id FK
    REPORTS : int department_id FK
    REPORTS : text file_url

    NOTIFICATIONS : int id PK
    NOTIFICATIONS : int user_id FK
    NOTIFICATIONS : text message
    NOTIFICATIONS : string notification_type
    NOTIFICATIONS : boolean is_read

    AUDIT_LOGS : int id PK
    AUDIT_LOGS : int user_id FK
    AUDIT_LOGS : string action_type
    AUDIT_LOGS : string entity_type
    AUDIT_LOGS : int entity_id
```

## Varlık İlişkileri Özeti

### Ana Varlıklar
- **Roles**: Kullanıcı rolleri (Akademik Personel, Bölüm Başkanı, Dekan, Admin)
- **Departments**: Bölümler (Bilgisayar Mühendisliği, Makine, vb.)
- **Users**: Akademik personel ve sistem kullanıcıları
- **Academic Terms**: Dönemler (Güz, Bahar, Yaz Okulu)

### Eğitim Yönetimi
- **Courses**: Dersler
- **Course Assignments**: Öğretim üyelerinin ders atamaları

### Araştırma Yönetimi
- **Research Projects**: Araştırma projeleri
- **Project Members**: Proje katılımcıları
- **Publications**: Yayınlar (makale, bildiri, kitap vb.)
- **Publication Metrics**: Yayın metrikleri (atıf, h-index vb.)

### Akademik Hizmet
- **Advising Records**: Danışmanlık kayıtları
- **Administrative Tasks**: İdari görevler ve komisyonlar

### Performans Yönetimi
- **Performance Goals**: Yarıyıl/yıllık hedefler
- **Performance Evaluations**: Performans değerlendirmeleri
- **Evaluation Criteria**: Değerlendirme kriterleri
- **Evaluation Criterion Scores**: Kriter bazlı puanlar

### Sistem Yönetimi
- **Reports**: Oluşturulan raporlar
- **Notifications**: Bildirimler
- **Audit Logs**: Denetim kayıtları

## İlişki Türleri
- **1:N** (Bire Çok): Departments → Users, Academic Terms → Course Assignments
- **M:N** (Çoka Çok): Research Projects ↔ Users (Project Members aracılığıyla)
- **Recursive**: Departments → Departments (alt bölümler)
