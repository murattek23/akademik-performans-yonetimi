# Kurulum ve Deployment Guide

## Gereksinimler

### Geliştirme Ortamı
- PostgreSQL 12+
- Node.js 16+
- npm veya yarn
- Git
- Docker (opsiyonel)

### Üretim Ortamı
- PostgreSQL 14+ (managed service tercih edilir)
- Node.js 18 LTS
- Reverse proxy (Nginx veya Apache)
- SSL/TLS sertifikası
- Docker + Docker Compose veya Kubernetes

---

## 1. Veritabanı Kurulumu

### 1.1 PostgreSQL Kurulumu (Linux/Ubuntu)

```bash
# PostgreSQL repository ekle
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Güncelle ve kur
sudo apt-get update
sudo apt-get install -y postgresql-14 postgresql-contrib-14

# PostgreSQL servisini başlat
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 1.2 Veritabanı ve Kullanıcı Oluştur

```bash
# PostgreSQL'e giriş yap
sudo -u postgres psql

# Veritabanı oluştur
CREATE DATABASE akademik_performans;

# Kullanıcı oluştur
CREATE USER akademik_user WITH PASSWORD 'secure_password_here';

# Yetkilendirme ver
ALTER ROLE akademik_user SET client_encoding TO 'utf8';
ALTER ROLE akademik_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE akademik_user SET default_transaction_deferrable TO on;
ALTER ROLE akademik_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE akademik_performans TO akademik_user;

# Çık
\q
```

### 1.3 Şema Yükle

```bash
# Repository'yi klona
git clone https://github.com/murattek23/akademik-performans-yonetimi.git
cd akademik-performans-yonetimi

# Şemayı yükle
psql -U akademik_user -d akademik_performans -f sql/academic_performance_schema.sql

# Dashboard view'lerini yükle
psql -U akademik_user -d akademik_performans -f sql/dashboard_queries.sql

# Mock veriler yükle (geliştirme için)
psql -U akademik_user -d akademik_performans -f sql/seed_data.sql
```

### 1.4 Bağlantı Kontrolü

```bash
# Bağlantı testi
psql -U akademik_user -d akademik_performans -c "SELECT version();"
```

---

## 2. Uygulama Kurulumu

### 2.1 Repository'yi Klona ve Bağımlılıklar

```bash
# Repo klona (yapılmamışsa)
git clone https://github.com/murattek23/akademik-performans-yonetimi.git
cd akademik-performans-yonetimi

# Backend klasörü
cd backend
npm install

# Frontend klasörü (varsa)
cd ../frontend
npm install
```

### 2.2 Environment Variables

Kök dizinde `.env` dosyası oluştur:

```env
# Database
DATABASE_URL=postgresql://akademik_user:secure_password_here@localhost:5432/akademik_performans

# JWT Secret
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRATION=24h

# Application
NODE_ENV=development
PORT=3000
API_URL=http://localhost:3000/api/v1

# Email Service (isteğe bağlı)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Logging
LOG_LEVEL=debug
```

### 2.3 Backend Başlat

```bash
# Geliştirme modu
npm run dev

# Veya production build
npm run build
npm run start

# Sunucu http://localhost:3000 adresinde çalışır
```

### 2.4 Frontend Başlat (React/Next.js)

```bash
cd ../frontend

# Geliştirme modu
npm run dev

# Sunucu http://localhost:3001 adresinde çalışır
```

---

## 3. Docker ile Kurulum

### 3.1 Docker Compose

`docker-compose.yml` dosyası oluştur:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:14-alpine
    container_name: akademik_postgres
    environment:
      POSTGRES_USER: akademik_user
      POSTGRES_PASSWORD: secure_password_here
      POSTGRES_DB: akademik_performans
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./sql/academic_performance_schema.sql:/docker-entrypoint-initdb.d/01-schema.sql
      - ./sql/dashboard_queries.sql:/docker-entrypoint-initdb.d/02-views.sql
      - ./sql/seed_data.sql:/docker-entrypoint-initdb.d/03-seed.sql
    networks:
      - akademik_network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U akademik_user"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: akademik_backend
    environment:
      DATABASE_URL: postgresql://akademik_user:secure_password_here@postgres:5432/akademik_performans
      NODE_ENV: production
      JWT_SECRET: your-super-secret-jwt-key
    ports:
      - "3000:3000"
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - akademik_network
    restart: unless-stopped

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: akademik_frontend
    ports:
      - "3001:3000"
    depends_on:
      - backend
    networks:
      - akademik_network
    restart: unless-stopped

volumes:
  postgres_data:

networks:
  akademik_network:
    driver: bridge
```

### 3.2 Başlat

```bash
# Tüm servisleri başlat
docker-compose up -d

# Logları kontrol et
docker-compose logs -f backend
docker-compose logs -f postgres

# Durdurmak için
docker-compose down
```

---

## 4. Nginx Reverse Proxy Ayarı (Üretim)

`/etc/nginx/sites-available/akademik` dosyası oluştur:

```nginx
upstream backend {
    server localhost:3000;
}

upstream frontend {
    server localhost:3001;
}

server {
    listen 80;
    server_name api.akademik.university.edu;

    # HTTP'den HTTPS'ye yönlendir
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.akademik.university.edu;

    ssl_certificate /etc/letsencrypt/live/api.akademik.university.edu/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.akademik.university.edu/privkey.pem;

    # API endpoint'leri
    location /api/ {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # CORS headers
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization' always;
        
        if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain; charset=utf-8';
            add_header 'Content-Length' 0;
            return 204;
        }
    }

    # Frontend
    location / {
        proxy_pass http://frontend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Logging
    access_log /var/log/nginx/akademik_access.log combined;
    error_log /var/log/nginx/akademik_error.log;
}
```

Etkinleştir ve yeniden başlat:

```bash
sudo ln -s /etc/nginx/sites-available/akademik /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 5. SSL/TLS Sertifikası (Let's Encrypt)

```bash
# Certbot kur
sudo apt-get install -y certbot python3-certbot-nginx

# Sertifika al
sudo certbot certonly --nginx -d api.akademik.university.edu

# Otomatik yenileme
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

---

## 6. Kontrol ve Monitoring

### 6.1 Sağlık Kontrolleri

```bash
# Backend health check
curl http://localhost:3000/api/v1/health

# Database bağlantısı
psql -U akademik_user -d akademik_performans -c "SELECT COUNT(*) FROM users;"

# Nginx status
curl http://localhost/nginx_status
```

### 6.2 Log Monitoring

```bash
# Backend logları
tail -f /var/log/akademik/backend.log

# Nginx logları
tail -f /var/log/nginx/akademik_access.log
tail -f /var/log/nginx/akademik_error.log

# PostgreSQL logları
tail -f /var/log/postgresql/postgresql-14-main.log
```

### 6.3 Performance Monitoring

```bash
# PostgreSQL slow queries
psql -U akademik_user -d akademik_performans -c "
  ALTER SYSTEM SET log_min_duration_statement = 1000;
  SELECT pg_reload_conf();
"

# Node.js memory/CPU
pm2 monit
```

---

## 7. Backup ve Recovery

### 7.1 Database Backup

```bash
# Full backup (SQL format)
pg_dump -U akademik_user -d akademik_performans > akademik_backup_$(date +%Y%m%d_%H%M%S).sql

# Custom format (daha etkili)
pg_dump -U akademik_user -d akademik_performans -Fc > akademik_backup.dump

# Scheduled backup (cron job)
0 2 * * * pg_dump -U akademik_user -d akademik_performans -Fc > /backups/akademik_$(date +\%Y\%m\%d).dump
```

### 7.2 Database Restore

```bash
# SQL format'tan restore
psql -U akademik_user -d akademik_performans < akademik_backup.sql

# Custom format'tan restore
pg_restore -U akademik_user -d akademik_performans -Fc akademik_backup.dump
```

---

## 8. Troubleshooting

### 8.1 PostgreSQL Bağlantı Hatası

```bash
# PostgreSQL servisi kontrol et
sudo systemctl status postgresql

# Bağlantı string'ini doğrula
psql postgresql://akademik_user:password@localhost:5432/akademik_performans

# Port kontrol et
sudo netstat -tlnp | grep postgres
```

### 8.2 API Başlamıyor

```bash
# Environment variable'ları kontrol et
env | grep DATABASE_URL

# Node servisi logları
npm run dev 2>&1 | head -20

# Port çakışması
sudo lsof -i :3000
```

### 8.3 CORS Hatası

`.env` dosyasına ekle:

```env
CORS_ORIGIN=https://akademik.university.edu
```

Backend'de (Express):

```javascript
const cors = require('cors');
app.use(cors({
  origin: process.env.CORS_ORIGIN,
  credentials: true
}));
```

---

## 9. İlk Çalıştırma Checklist

- [ ] PostgreSQL kuruldu ve çalışıyor
- [ ] Şema ve view'ler yüklendi
- [ ] Mock veriler importu başarılı
- [ ] Backend başladı ve health check geçti
- [ ] Frontend başladı
- [ ] API endpoint'leri cevap veriyor
- [ ] Dashboard görünümleri çalışıyor
- [ ] SSL sertifikası kuruldu (üretim)
- [ ] Backup stratejisi ayarlandı
- [ ] Monitoring konfigüre edildi

---

## 10. Production Deployment Checklist

- [ ] `.env` dosyası güvenli şekilde ayarlandı
- [ ] JWT_SECRET güçlü bir değer
- [ ] Database credentials şifre yöneticisinde
- [ ] CORS ayarları kısıtlandı
- [ ] Rate limiting konfigüre edildi
- [ ] Logging konfigürasyonu
- [ ] Backup automation aktif
- [ ] SSL/TLS sertifikaları kuruldu
- [ ] Firewall kuralları ayarlandı
- [ ] Monitoring ve alerting aktif
- [ ] Health check endpoints yapılandırıldı
- [ ] Load balancing (varsa) ayarlandı
