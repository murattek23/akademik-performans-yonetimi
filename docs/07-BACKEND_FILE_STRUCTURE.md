# Backend File Structure - NestJS

Bu dokümant, akademik performans yönetimi sistemi için NestJS tabanlı backend mimarisini tanımlar.

## Klasör Yapısı

```
backend/
├── src/
│   ├── app.module.ts
│   ├── main.ts
│   ├── config/
│   │   ├── database.config.ts
│   │   ├── jwt.config.ts
│   │   └── env.validation.ts
│   ├── common/
│   │   ├── decorators/
│   │   │   ├── roles.decorator.ts
│   │   │   └── current-user.decorator.ts
│   │   ├── guards/
│   │   │   ├── jwt.guard.ts
│   │   │   └── roles.guard.ts
│   │   ├── interceptors/
│   │   │   ├── logging.interceptor.ts
│   │   │   ├── transform.interceptor.ts
│   │   │   └── error.interceptor.ts
│   │   ├── filters/
│   │   │   └── http-exception.filter.ts
│   │   ├── pipes/
│   │   │   └── validation.pipe.ts
│   │   └── dto/
│   │       ├── paginated.dto.ts
│   │       └── api-response.dto.ts
│   ├── modules/
│   │   ├── auth/
│   │   │   ├── auth.module.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── auth.controller.ts
│   │   │   ├── strategies/
│   │   │   │   └── jwt.strategy.ts
│   │   │   └── dto/
│   │   │       ├── login.dto.ts
│   │   │       └── auth-response.dto.ts
│   │   ├── users/
│   │   │   ├── users.module.ts
│   │   │   ├── users.service.ts
│   │   │   ├── users.controller.ts
│   │   │   ├── entities/
│   │   │   │   └── user.entity.ts
│   │   │   └── dto/
│   │   │       ├── create-user.dto.ts
│   │   │       ├── update-user.dto.ts
│   │   │       ├── user.dto.ts
│   │   │       └── user-filter.dto.ts
│   │   ├── departments/
│   │   │   ├── departments.module.ts
│   │   │   ├── departments.service.ts
│   │   │   ├── departments.controller.ts
│   │   │   ├── entities/
│   │   │   │   └── department.entity.ts
│   │   │   └── dto/
│   │   │       └── department.dto.ts
│   │   ├── academic-terms/
│   │   │   ├── academic-terms.module.ts
│   │   │   ├── academic-terms.service.ts
│   │   │   ├── academic-terms.controller.ts
│   │   │   ├── entities/
│   │   │   │   └── academic-term.entity.ts
│   │   │   └── dto/
│   │   │       └── academic-term.dto.ts
│   │   ├── courses/
│   │   │   ├── courses.module.ts
│   │   │   ├── courses.service.ts
│   │   │   ├── courses.controller.ts
│   │   │   ├── entities/
│   │   │   │   └── course.entity.ts
│   │   │   └── dto/
│   │   │       ├── create-course.dto.ts
│   │   │       └── course.dto.ts
│   │   ├── course-assignments/
│   │   │   ├── course-assignments.module.ts
│   │   │   ├── course-assignments.service.ts
│   │   │   ├── course-assignments.controller.ts
│   │   │   ├── entities/
│   │   │   │   └── course-assignment.entity.ts
│   │   │   └── dto/
│   │   │       ├── create-course-assignment.dto.ts
│   │   │       └── course-assignment.dto.ts
│   │   ├── performance/
│   │   │   ├── performance.module.ts
│   │   │   ├── performance.service.ts
│   │   │   ├── performance.controller.ts
│   │   │   ├── entities/
│   │   │   │   ├── performance-evaluation.entity.ts
│   │   │   │   ├── performance-goal.entity.ts
│   │   │   │   └── evaluation-criteria.entity.ts
│   │   │   └── dto/
│   │   │       ├── performance-evaluation.dto.ts
│   │   │       ├── performance-goal.dto.ts
│   │   │       └── create-evaluation.dto.ts
│   │   ├── dashboard/
│   │   │   ├── dashboard.module.ts
│   │   │   ├── dashboard.service.ts
│   │   │   ├── dashboard.controller.ts
│   │   │   └── dto/
│   │   │       ├── department-head-dashboard.dto.ts
│   │   │       └── dean-dashboard.dto.ts
│   │   ├── research/
│   │   │   ├── research.module.ts
│   │   │   ├── research.service.ts
│   │   │   ├── research.controller.ts
│   │   │   ├── entities/
│   │   │   │   ├── research-project.entity.ts
│   │   │   │   └── publication.entity.ts
│   │   │   └── dto/
│   │   │       ├── publication.dto.ts
│   │   │       └── research-project.dto.ts
│   │   ├── reports/
│   │   │   ├── reports.module.ts
│   │   │   ├── reports.service.ts
│   │   │   ├── reports.controller.ts
│   │   │   ├── entities/
│   │   │   │   └── report.entity.ts
│   │   │   ├── dto/
│   │   │   │   ├── generate-report.dto.ts
│   │   │   │   └── report.dto.ts
│   │   │   └── exporters/
│   │   │       ├── pdf.exporter.ts
│   │   │       ├── excel.exporter.ts
│   │   │       └── json.exporter.ts
│   │   ├── notifications/
│   │   │   ├── notifications.module.ts
│   │   │   ├── notifications.service.ts
│   │   │   ├── notifications.controller.ts
│   │   │   ├── entities/
│   │   │   │   └── notification.entity.ts
│   │   │   └── dto/
│   │   │       └── notification.dto.ts
│   │   └── audit/
│   │       ├── audit.module.ts
│   │       ├── audit.service.ts
│   │       ├── audit.controller.ts
│   │       ├── entities/
│   │       │   └── audit-log.entity.ts
│   │       └── dto/
│   │           └── audit-log.dto.ts
│   ├── database/
│   │   ├── migrations/
│   │   │   └── 001-initial-schema.ts
│   │   ├── seeds/
│   │   │   ├── seed.module.ts
│   │   │   ├── seed.service.ts
│   │   │   ├── seeders/
│   │   │   │   ├── roles.seeder.ts
│   │   │   │   ├── departments.seeder.ts
│   │   │   │   ├── users.seeder.ts
│   │   │   │   ├── academic-terms.seeder.ts
│   │   │   │   └── mock-data.seeder.ts
│   │   └── datasource.ts
│   ├── services/
│   │   ├── performance-calculator.service.ts
│   │   ├── report-generator.service.ts
│   │   └── email.service.ts
│   └── utils/
│       ├── decorators/
│       ├── helpers/
│       └── constants.ts
├── test/
│   ├── app.e2e-spec.ts
│   ├── auth.e2e-spec.ts
│   ├── dashboard.e2e-spec.ts
│   ├── performance.e2e-spec.ts
│   └── reports.e2e-spec.ts
├── .env.example
├── .env.local
├── .env.production
├── package.json
├── tsconfig.json
├── nest-cli.json
└── Dockerfile
```

---

## Modül Açıklamaları

### 1. Auth Module
Kimlik doğrulama ve JWT token yönetimi.

**Dosyalar:**
- `auth.service.ts` — login, token generation, validation
- `auth.controller.ts` — POST /auth/login, POST /auth/logout
- `jwt.strategy.ts` — Passport JWT strategy
- `login.dto.ts` — login request validation

**Sorumluluğu:**
- kullanıcı doğrulaması
- token üretimi ve refresh
- logout işlemleri

### 2. Users Module
Kullanıcı yönetimi ve profil.

**Dosyalar:**
- `users.service.ts` — CRUD operations, user lookup
- `users.controller.ts` — GET /users, GET /users/:id
- `user.entity.ts` — User model
- `user-filter.dto.ts` — filtering parameters

**Sorumluluğu:**
- kullanıcı listeleme
- kullanıcı detayları
- profil bilgileri

### 3. Departments Module
Bölüm yönetimi.

**Dosyalar:**
- `departments.service.ts` — department lookup, hierarchy
- `departments.controller.ts` — GET /departments
- `department.entity.ts` — Department model

**Sorumluluğu:**
- bölüm listesi
- bölüm hierarşisi

### 4. Academic Terms Module
Akademik dönem yönetimi.

**Dosyalar:**
- `academic-terms.service.ts` — term lookup, current term
- `academic-terms.controller.ts` — GET /academic-terms
- `academic-term.entity.ts` — Academic Term model

**Sorumluluğu:**
- dönem listesi
- mevcut dönem bilgisi

### 5. Courses Module
Ders yönetimi.

**Dosyalar:**
- `courses.service.ts` — course lookup, filtering
- `courses.controller.ts` — GET /courses
- `course.entity.ts` — Course model

**Sorumluluğu:**
- ders listesi
- ders filtreleme

### 6. Course Assignments Module
Ders atama yönetimi.

**Dosyalar:**
- `course-assignments.service.ts` — assignment creation, lookup
- `course-assignments.controller.ts` — GET, POST /course-assignments
- `course-assignment.entity.ts` — CourseAssignment model

**Sorumluluğu:**
- ders atamaları
- ders yükü hesaplama

### 7. Performance Module
Performans değerlendirmesi ve hedefler.

**Dosyalar:**
- `performance.service.ts` — evaluation creation, scoring logic
- `performance.controller.ts` — GET/POST /performance-evaluations, /performance-goals
- `performance-evaluation.entity.ts` — Performance Evaluation model
- `performance-goal.entity.ts` — Performance Goal model

**Sorumluluğu:**
- değerlendirme oluşturma
- skor hesaplama
- hedef takibi

### 8. Dashboard Module
Dashboard verisi sağlama.

**Dosyalar:**
- `dashboard.service.ts` — department head and dean data aggregation
- `dashboard.controller.ts` — GET /dashboard/department-head, /dashboard/dean
- `department-head-dashboard.dto.ts` — Department head dashboard response
- `dean-dashboard.dto.ts` — Dean dashboard response

**Sorumluluğu:**
- bölüm başkanı dashboard verisi
- dekan dashboard verisi
- aggregated performance data

### 9. Research Module
Araştırma ve yayın yönetimi.

**Dosyalar:**
- `research.service.ts` — project and publication management
- `research.controller.ts` — GET/POST /research-projects, /publications
- `research-project.entity.ts` — ResearchProject model
- `publication.entity.ts` — Publication model

**Sorumluluğu:**
- proje yönetimi
- yayın listesi
- atıf metrikleri

### 10. Reports Module
Rapor üretimi ve export.

**Dosyalar:**
- `reports.service.ts` — report generation, file handling
- `reports.controller.ts` — POST /reports/generate
- `report.entity.ts` — Report model
- `pdf.exporter.ts` — PDF export logic
- `excel.exporter.ts` — Excel export logic
- `json.exporter.ts` — JSON export logic

**Sorumluluğu:**
- rapor oluşturma
- dosya export
- rapor arşivi

### 11. Notifications Module
Bildirim yönetimi.

**Dosyalar:**
- `notifications.service.ts` — notification creation and management
- `notifications.controller.ts` — GET /notifications
- `notification.entity.ts` — Notification model

**Sorumluluğu:**
- bildirim gönderme
- bildirim listesi

### 12. Audit Module
Audit log yönetimi.

**Dosyalar:**
- `audit.service.ts` — log recording, retrieval
- `audit.controller.ts` — GET /audit-logs (admin only)
- `audit-log.entity.ts` — AuditLog model

**Sorumluluğu:**
- sistem etkinlikleri kayıt
- erişim kontrol ve izlenebilirlik

---

## Common Klasörü

### Decorators
- `@Roles(Role.DEPARTMENT_HEAD)` — role-based method protection
- `@CurrentUser()` — logged-in user injection

### Guards
- `JwtAuthGuard` — JWT token validation
- `RolesGuard` — role-based authorization

### Interceptors
- `LoggingInterceptor` — request/response logging
- `TransformInterceptor` — standardized response format
- `ErrorInterceptor` — global error handling

### Filters
- `HttpExceptionFilter` — exception handling and formatting

### Pipes
- `ValidationPipe` — DTO validation and transformation

---

## Database Klasörü

### Migrations
TypeORM migration'ları (eğer kullanılıyorsa).

### Seeds
Test ve geliştirme için örnek veri.

**Seeders:**
- `roles.seeder.ts` — Role nesneleri
- `departments.seeder.ts` — Department nesneleri
- `users.seeder.ts` — User nesneleri
- `academic-terms.seeder.ts` — AcademicTerm nesneleri
- `mock-data.seeder.ts` — Tüm örnek veri

---

## Services Klasörü

### Performance Calculator Service
Performans skor hesaplama mantığı.

```typescript
// performans-calculator.service.ts
calculateTotalScore(
  teachingScore: number,
  researchScore: number,
  serviceScore: number,
  adminScore: number
): number {
  // %30, %40, %20, %10 ağırlıklandırması
  return (teachingScore * 0.30) + 
         (researchScore * 0.40) + 
         (serviceScore * 0.20) + 
         (adminScore * 0.10);
}
```

### Report Generator Service
Rapor üretimi ve export.

```typescript
// report-generator.service.ts
async generateReport(
  reportType: string,
  filters: ReportFilters
): Promise<Buffer> {
  // rapor verisi topla
  // format'a dönüştür (PDF/Excel/JSON)
  // dosya oluştur
}
```

### Email Service
Email bildirimleri (opsiyonel).

```typescript
// email.service.ts
async sendEvaluation(
  to: string,
  userName: string,
  totalScore: number
): Promise<void> {
  // email şablonu
  // gönder
}
```

---

## Package.json Örneği

```json
{
  "name": "akademik-performans-backend",
  "version": "1.0.0",
  "description": "Academic performance management system backend",
  "author": "Your Name",
  "license": "MIT",
  "scripts": {
    "prebuild": "rimraf dist",
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\"",
    "lint:fix": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json",
    "migration:create": "npm run typeorm migration:create",
    "migration:run": "npm run typeorm migration:run",
    "migration:revert": "npm run typeorm migration:revert",
    "seed": "nest start -- --entryFile=database/seed"
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/jwt": "^11.0.0",
    "@nestjs/passport": "^9.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/typeorm": "^9.0.1",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.0",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.1",
    "pg": "^8.8.0",
    "typeorm": "^0.3.16",
    "bcrypt": "^5.1.0",
    "pdfkit": "^0.13.0",
    "xlsx": "^0.18.5",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/express": "^4.17.17",
    "@types/jest": "^29.5.2",
    "@types/node": "^20.3.1",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.42.0",
    "jest": "^29.5.0",
    "prettier": "^3.0.0",
    "ts-jest": "^29.1.0",
    "ts-loader": "^9.4.3",
    "ts-node": "^10.9.1",
    "tsconfig-paths": "^4.2.0",
    "typescript": "^5.1.3"
  }
}
```

---

## Kurulum adımları

1. NestJS CLI yükle
```bash
npm i -g @nestjs/cli
```

2. Yeni proje oluştur
```bash
nest new akademik-backend
cd akademik-backend
```

3. Gerekli kütüphaneleri ekle
```bash
npm install @nestjs/typeorm typeorm pg bcrypt class-validator class-transformer @nestjs/jwt @nestjs/passport passport passport-jwt
```

4. Yukarıdaki klasör yapısını oluştur

5. `.env` dosyasını hazırla
```env
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=akademik_user
DATABASE_PASSWORD=secure_password
DATABASE_NAME=akademik_performans
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRATION=24h
NODE_ENV=development
```

6. Sunucuyu başlat
```bash
npm run start:dev
```

---

## Notlar

- Her module, kendi entity, service, controller, DTO'larını içerir.
- Common klasörü, tüm modüller tarafından kullanılan decorator, guard, interceptor vb. barındırır.
- Database klasörü, migration ve seed dosyalarını yönetir.
- Services klasörü, cross-cutting concerns (performans hesaplama, rapor generation) içerir.
- Test klasörü, e2e testleri barındırır.

Bu yapı, NestJS best practices'e uygun olup, ölçeklenebilir ve sürdürülebilir bir backend yapısıdır.
