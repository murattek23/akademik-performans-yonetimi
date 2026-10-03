# Akademik Performans Yönetimi

15–20 kişilik akademik kadronun performansını izlemek için tasarlanmış bir veri modeli ve örnek uygulama altyapısıdır. Sistem, akademik personelin:

- ders yükünü
- araştırma faaliyetlerini
- yayın ve proje katkılarını
- danışmanlık ve akademik hizmetlerini
- idari görev ve yönetim katkılarını
- dönemsel ve yıllık performans skorlarını

tek bir yapıda izlemeyi hedefler.

## Amaç

Bu proje aşağıdaki amaçlara hizmet eder:

- Akademik personelin performansını objektif şekilde izlemek
- Dönem ve yıl bazlı değerlendirme yapmak
- Bölüm başkanı ve dekan için dashboard görünümü sağlamak
- Akademik hedefleri takip etmek ve raporlamak
- Görev, yayın ve araştırma dağılımını dengeli yönetmek

## İçerik

- PostgreSQL veri modeli
- Akademik performans skor hesaplama SQL’i
- Yıllık performans raporu SQL’i
- Bölüm başkanı ve dekan için filtreli dashboard sorguları
- Mock veri örnekleri
- ER diagram ve teknik dokümantasyon
- Kurulum ve deployment rehberi

## Veri Modeli ve Dokümantasyon

- [docs/index.md](docs/index.md)
- [docs/01-ER_DIAGRAM.md](docs/01-ER_DIAGRAM.md)
- [docs/02-API_SPECIFICATION.yaml](docs/02-API_SPECIFICATION.yaml)
- [docs/03-INSTALLATION_DEPLOYMENT.md](docs/03-INSTALLATION_DEPLOYMENT.md)
- [docs/04-SQL_QUERY_OPTIMIZATION.md](docs/04-SQL_QUERY_OPTIMIZATION.md)
- [docs/05-DATA_DICTIONARY.md](docs/05-DATA_DICTIONARY.md)
- [docs/06-USE_CASES_AND_USER_FLOWS.md](docs/06-USE_CASES_AND_USER_FLOWS.md)

## SQL Şeması

- [sql/academic_performance_schema.sql](sql/academic_performance_schema.sql)
- [sql/dashboard_queries.sql](sql/dashboard_queries.sql)

## Kullanım

1. Veritabanını oluşturun.
2. `sql/academic_performance_schema.sql` dosyasını çalıştırın.
3. `sql/dashboard_queries.sql` dosyasını çalıştırın.
4. İsterseniz mock verileri ekleyerek dashboard sorgularını deneyin.
5. Dönem ve bölüm bazlı rapor oluşturun.

## Notlar

Bu proje örnek ve eğitim amaçlı bir başlangıç altyapısıdır. Gerçek kurumsal kullanım için şunlar eklenmelidir:

- kullanıcı kimlik doğrulama
- rol tabanlı erişim kontrolü
- API katmanı
- güvenlik ve audit politikaları
- frontend dashboard
- production deployment yapısı

## Repository

https://github.com/murattek23/akademik-performans-yonetimi
