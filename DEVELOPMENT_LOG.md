# Konuşma Adası - Geliştirme Günlüğü (Development Log)

## [2026-11-24] - Başlangıç ve Temel Altyapı
- **Ortam Kurulumu**: Sistem mimarisi `aarch64` olarak tespit edildi, resmi Godot 4.3 Stable arm64 kuruldu ve `godot --version` ile doğrulandı.
- **Ses Altyapısı**: Türkçe konuşma sentezi ve doğrulama için `espeak-ng` ve `ffmpeg` hazırlandı.
- **Proje Mimarisi**: `KonusmaAdasi/` dizininde modüler klasör şeması oluşturuldu:
  - `scenes/main`, `scenes/world`, `scenes/games`, `scenes/ui`
  - `scripts/managers`, `scripts/games`, `scripts/ui`
  - `assets/characters`, `assets/backgrounds`, `assets/objects`, `assets/audio`, `assets/theme`
  - `data/words`, `data/activities`, `tests`
- **Konfigürasyon**: 1280x720 esnek canvas_items ölçeklendirmesi, gl_compatibility renderlama, mikrofon ses girişi ve `Record` ses veriyolu yapılandırıldı.

## [2026-11-24] - Yöneticiler ve Veri Tabanı
- **Autoload Tekil Yöneticileri**:
  - `GameManager`: Seviye geçişleri, yaş grubu modu (2-4 yaş / 5-8 yaş), ödül ve yıldız takipçisi.
  - `AudioManager`: Müzik, SFX havuzu ve Türkçe seslendirme yürütücüsü. Dosya eksikliğinde devreye giren prosedürel tatlı melodik çan/ton jeneratörü.
  - `DataManager`: JSON tabanlı kelime ve etkinlik veri tabanı yükleyici ve yerel ilerleme saklayıcı (`user://konusma_adasi_save.json`).
  - `RecordManager`: Mikrofon algılama, yerel WAV kaydı, oynatma ve güvenli silme yönetimi (`user://recordings/`).
- **Veri Setleri**:
  - `words_artikulasyon.json`: Hedef sesler, kelimeler, soru kalıpları ve çeldiriciler.
  - `words_hece.json`: Heceleme ve tren vagonu sıralama verileri.
  - `words_esya.json`: Renk, kategori ve isim eşleme nesneleri.
  - `stories.json`: Neden-sonuç sıralama masalları.

## [2026-11-24] - Vektör Varlıklar, Sesler ve UI Sistemi
- **Vektör SVG Çizimleri**:
  - Maskotlar: Tilki Fino, Tavşan Mimi, Papağan Piko, Kaplumbağa Toto (tam boy ve avatar çizimleri).
  - Nesneler: Araba, armut, balık, elma, top, kedi, köpek, muz, gemi, çiçek, güneş, lokomotif, vagon.
  - Arka Planlar: Ana menü, ada haritası, ses ormanı, kelime köyü, hece denizi, hikaye kalesi.
  - İkonlar: Ev, geri, hoparlör, mikrofon, oynat, durdur, sil, yıldız, onay, tekrar.
- **Ses Dosyaları**: 35+ adet Türkçe yönerge, kelime ve hece telaffuzu üretildi.
- **Tasarım Sistemi**: `konusma_adasi_theme.tres` oluşturularak yumuşak pastel tonlar, 20-24px yuvarlatılmış köşeler ve dostça buton hissi sağlandı.
- **Yeniden Kullanılabilir UI Bileşenleri**:
  - `NavBar`: Tutarlı gezinme, başlık, yıldız sayacı, ses tekrar butonu.
  - `PictureCard`: Büyük dokunma hedefleri, yaylanma ve hafif iki yana sallanma animasyonları.
  - `RewardDialog`: 3 yıldızlı teşvik edici ödül modalı.

## [2026-11-24] - 5 Mini Oyunun Tamamlanması
- **1. Tavşana Yardım Et**: Mimi ile hedef ses/kelime bulma. Yaş grubuna göre 2 veya 3 kart seçeneği. Doğru cevapta sevinçli zıplama ve yıldız; yanlışta yumuşak salınım ve yönlendirme.
- **2. Papağanı Konuştur**: Piko ile dinle, tekrarla ve yerel WAV kaydı. Otomatik klinik not verme yok. Güvenli kaydetme, dinleme ve silme. Mikrofon yoksa bile oyunu sürdüren zarif fallback mekanizması.
- **3. Kelime Treni**: Toto ile heceleri vagonlara sırayla dizme. Tüm vagonlar tamamlandığında trenin hareket animasyonu ve hecelerin sırayla seslendirilmesi.
- **4. Kayıp Eşyalar**: Piko ve Fino ile renk/kategori eşleme. Tıklanan nesnenin adını söyleyen zenginleştirilmiş kelime öğrenme akışı.
- **5. Hikâyeyi Kurtar**: 3 adımlı olay sıralama ve çocuğun kendi masalını sesli olarak kaydedebileceği anlatım bölümü.

## [2026-11-24] - QA Testleri ve Doğrulama
- `tests/test_runner.tscn` ve `tests/run_tests.gd` ile otomatik test çalıştırıldı.
- 4/4 test başarıyla geçti.

## [2026-11-24] - ElevenLabs TTS Altyapısı ve Kayıtsız Saf Dinleme Modu
- **Mikrofon Kaydının Kaldırılması**: Kullanıcı isteği doğrultusunda oyun içi ses kaydı, mikrofon izinleri ve dosya yazma akışları tamamen devre dışı bırakıldı (`audio/driver/enable_input = false`).
- **Oyun Akışı İyileştirmesi**:
  - `Papağanı Konuştur`: Piko'nun net ve doğal telaffuzunu dinleyip birlikte yüksek sesle tekrar etme mekaniğine dönüştürüldü.
  - `Hikâyeyi Kurtar`: Kartlar doğru sıralandıktan sonra masalın sesli anlatımını dinleme akışına uyarlandı.
- **ElevenLabs Multilingual v2 Entegrasyonu**:
  - `scripts/elevenlabs_tts.py` geliştirildi.
  - `.env` ve `.env.example` oluşturuldu.
  - Maskot ses profilleri tanımlandı: Mimi (nazik/eğitici kadın sesi), Fino (genç/enerjik erkek sesi), Piko (canlı/animatif ses), Toto (sakin/bilge ses).
  - Tek komutla anahtar kaydetme (`--set-key`), bağlantı testi (`--test`) ve 35+ repliğin tamamını doğal sese dönüştürme (`--generate-all`) yetenekleri sağlandı.
- **QA Doğrulaması**: Güncellenen test paketiyle 4/4 testin başarıyla geçtiği yeniden teyit edildi.
