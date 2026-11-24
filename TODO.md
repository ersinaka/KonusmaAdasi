# Konuşma Adası - Yapılacaklar Listesi (TODO)

## 1. Proje Yapısı ve Altyapı
- [x] Godot 4.3 kurulumu ve doğrulaması
- [x] Klasör mimarisinin kurulması (`scenes`, `scripts`, `assets`, `data`, `exports`, `tests`)
- [x] `project.godot` ve ses veriyolu (`default_bus_layout.tres`) yapılandırması
- [x] `DEVELOPMENT_LOG.md` ve `TODO.md` oluşturulması

## 2. Tekil Yöneticiler (Autoloads)
- [x] `game_manager.gd`: Yaş seçimi (2-4 / 5-8), yıldızlar, navigasyon
- [x] `audio_manager.gd`: BGM, SFX havuzu, seslendirme yürütücüsü ve prosedürel tonlar
- [x] `data_manager.gd`: JSON verilerini önbelleğe alma, güvenli kaydetme (`user://konusma_adasi_save.json`)
- [x] `record_manager.gd`: Mikrofon algılama, yerel WAV kaydı, oynatma, silme (`user://recordings/`)

## 3. Veri Setleri (Data-Driven JSON)
- [x] `data/words/words_artikulasyon.json`: Ses Ormanı hedef kelimeleri (araba, armut, balık, elma, kedi, top)
- [x] `data/words/words_hece.json`: Hece Treni heceleme verileri
- [x] `data/words/words_esya.json`: Kayıp Eşyalar kategori/renk verileri
- [x] `data/activities/stories.json`: Hikâye Kalesi sıralama kartları

## 4. Tasarım Sistemi ve Görsel Varlıklar (Pastel Cartoon)
- [x] Maskotlar: Tilki Fino (Rehber), Papağan Piko, Tavşan Mimi, Kaplumbağa Toto (37 SVG çizimi)
- [x] UI Bileşenleri: Büyük butonlar, kart çerçeveleri, yıldızlar, ses ikonları, mikrofon göstergesi
- [x] Arka Planlar: Ana menü, Ada haritası, Ses Ormanı, Kelime Köyü, Hece Denizi, Hikâye Kalesi
- [x] Nesne Çizimleri: Araba, armut, balık, elma, top, kedi, köpek, muz, gemi, çiçek, güneş, tren
- [x] Tema Dosyası: `konusma_adasi_theme.tres` (yuvarlak köşeler, yumuşak gölgeler)

## 5. Ses Dosyaları (Türkçe Prompts ve Efektler)
- [x] Teşvik edici SFX (alkış jingle, yıldız tınısı, buton tık, başarı çanları)
- [x] 35+ Türkçe seslendirme WAV dosyası (Mimi, Piko, Toto, Fino yönlendirmeleri, kelimeler, heceler)

## 6. Ana Menü ve Ada Haritası
- [x] `main_menu.tscn`: Pastel karşılama, büyük "Oyna" butonu, yaş modu seçici (2-4 / 5-8), ebeveyn/terapist bilgi paneli
- [x] `island_map.tscn`: Beş bölge kartı, sevimli animasyonlu karakterler, yıldız sayacı

## 7. Reusable UI Bileşenleri
- [x] `nav_bar.tscn`: Ana sayfa, başlık, yıldız sayacı, ses tekrar butonu
- [x] `picture_card.tscn`: Büyük dokunma hedefi, yaylanma ve hafif iki yana sallanma animasyonları
- [x] `reward_dialog.tscn`: 3 yıldızlı kutlama ekranı, pozitif Türkçe seslendirme

## 8. Mini Oyunlar (Eğitsel & Terapötik)
- [x] **Mini Oyun 1: Tavşana Yardım Et** (Mimi ile hedef ses/kelime bulma)
- [x] **Mini Oyun 2: Papağanı Konuştur** (Piko ile dinle, tekrarla, ses kaydet, dinle ve sil)
- [x] **Mini Oyun 3: Kelime Treni** (Heceleri vagonlara doğru sırayla dizme)
- [x] **Mini Oyun 4: Kayıp Eşyalar** (Kelime Köyü renk ve kategori eşleme)
- [x] **Mini Oyun 5: Hikâyeyi Kurtar** (Hikâye Kalesi olay sıralama ve masal anlatımı kaydı)

## 9. Test ve Kalite Güvencesi (QA)
- [x] Otomatik test suite (`tests/run_tests.gd` ve `tests/test_runner.tscn`)
- [x] 4/4 testin başarıyla geçmesi
- [x] Mikrofon hatasında akışı bozmayan güvenli fallback mimarisi
- [x] Kapsamlı Türkçe `README.md`
