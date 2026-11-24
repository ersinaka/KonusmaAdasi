# 🏝️ Konuşma Adası (Speech Island)

> **2–8 Yaş Çocuklar İçin 2D Türkçe Dil ve Konuşma Terapisi Destek Oyunu**  
> *Geliştirme Motoru: Godot 4.3 Stable (GDScript)*

---

## 🌟 Proje Vizyonu ve Pedagojik Yaklaşım

**Konuşma Adası**, 2–8 yaş arası çocukların dil, artikülasyon, heceleme, kelime dağarcığı ve hikâye anlatımı becerilerini desteklemek üzere tasarlanmış, pastel renk paletine sahip, sevimli bir 2D çizgi ada macerasıdır.

### Temel Tasarım ve Etik İlkeler:
1. **Çocuk Odaklı Güvenli Arayüz:**
   - Reklam, uygulama içi satın alma, hesap oluşturma veya analitik izleme **kesinlikle yoktur**.
   - Tamamen **çevrimdışı (offline-first)** çalışır.
   - Hata yapıldığında cezalandırıcı, utandırıcı ses veya kırmızı çarpılar bulunmaz. Çocuk her zaman nazikçe yeniden denemeye teşvik edilir.
2. **Klinik Değerlendirme ve Gizlilik Ayrımı:**
   - Çocuk arayüzünde **asla otomatik klinik puanlama, telaffuz notu veya tanı koyulmaz**. Çocuğun konuşma kaygısı yaşamaması esastır.
   - Çocukların ses kayıtları yalnızca yerel cihaz hafızasında (`user://recordings/`) aktivite kimliği ve zaman damgasıyla saklanır.
   - Dil ve Konuşma Terapistleri ile aileler, bu ses kayıtlarını çocuğun oyun akışının dışından bağımsız olarak dinleyip klinik değerlendirmelerini kendileri yaparlar.
   - Mikrofon bulunmayan veya izni verilmeyen cihazlarda oyun kesinlikle kilitlenmez; alternatif görsel ve işitsel akışla oynanabilir kalır.
3. **Yaş Grubu Farklılaşması:**
   - **🌱 2–4 Yaş (Kolay Mod):** Daha büyük dokunma hedefleri, 2 seçenekli kartlar, sadece görsel odaklı sunum, yavaş ve sakin tempo.
   - **🚀 5–8 Yaş (Gelişmiş Mod):** 3–4 seçenekli kartlar, yazılı kelime desteği, heceleme ve olay sıralama aktiviteleri.

---

## 🗺️ Oyun Dünyası ve 5 Mini Oyun

| Bölge / Maskot | Mini Oyun Adı | Gelişim Alanı ve Mekanik |
| :--- | :--- | :--- |
| **Ses Ormanı**<br>🐰 *Tavşan Mimi* | **Tavşana Yardım Et** | Hedef ses farkındalığı ve artikülasyon pratiği. Hedef kelimeye (araba, armut, balık vb.) karşılık gelen büyük kartı bulma. |
| **Kelime Köyü**<br>🦜 *Papağan Piko* | **Papağanı Konuştur** | Dinleme, tekrar ve ses kaydı. Piko hedef kelimeyi söyler; çocuk mikrofonla tekrar eder, kendi sesini dinleyebilir ve dilerse silebilir. |
| **Hece Denizi**<br>🐢 *Kaptan Toto* | **Kelime Treni** | Hece farkındalığı ve birleştirme. Karışık verilen hece vagonlarını (A-RA-BA, EL-MA vb.) doğru sıraya dizme. |
| **Kelime Köyü**<br>🦊 *Tilki Fino* | **Kayıp Eşyalar** | Kelime dağarcığı, renkler ve kategoriler. Verilen kategori veya renkteki nesneyi neşeli pazar tezgahında bulma. |
| **Hikâye Kalesi**<br>🦊 *Tilki Fino* | **Hikâyeyi Kurtar** | Olay sıralama (neden-sonuç) ve masal anlatımı. 3 aşamalı görsel kartları sıraya dizip isteğe bağlı kendi masalını sesli anlatma. |

---

## 🏗️ Proje Mimarisi

```
KonusmaAdasi/
├── project.godot                  # Godot 4.3 ana proje yapılandırması
├── default_bus_layout.tres        # Master ve AudioEffectRecord ses veriyolu
├── assets/
│   ├── backgrounds/               # Pastel ada ve bölge SVG arka planları
│   ├── characters/                # Fino, Mimi, Piko, Toto vektör SVG maskotları
│   ├── objects/                   # Nesne SVG çizimleri (araba, armut, balık, tren vb.)
│   ├── theme/                     # konusma_adasi_theme.tres (yuvarlak pastel buton & paneller)
│   ├── ui/                        # UI ikonları (home, back, speaker, mic, star, play vb.)
│   └── audio/
│       ├── sfx/                   # Prosedürel ve efekt sesleri
│       └── voice/                 # 35+ Türkçe seslendirme WAV dosyaları
├── data/
│   ├── words/                     # words_artikulasyon.json, words_hece.json, words_esya.json
│   └── activities/                # stories.json (sıralama masalları)
├── scenes/
│   ├── main/                      # main_menu.tscn
│   ├── world/                     # island_map.tscn
│   ├── games/                     # tavsana_yardim_et, papagani_konustur, kelime_treni,
│   │                              # kayip_esyalar, hikayeyi_kurtar sahneleri
│   └── ui/                        # nav_bar.tscn, picture_card.tscn, reward_dialog.tscn
├── scripts/
│   ├── managers/                  # GameManager, DataManager, AudioManager, RecordManager
│   ├── games/                     # Mini oyun lojik scriptleri
│   └── ui/                        # UI bileşen scriptleri
└── tests/
    ├── test_runner.tscn           # Otomatik test sahnesi
    └── run_tests.gd               # QA doğrulama testleri
```

---

## 🚀 Kurulum ve Çalıştırma

### 1. Gereksinimler
- **Godot 4.3+ Stable** (Linux x86_64 veya aarch64, Windows veya macOS)
- *İsteğe bağlı test araçları:* `xvfb-run` (ekransız sunucu testleri için), `ffmpeg`, `espeak-ng`.

### 2. Oyunu Başlatma
Proje dizininde Godot motorunu çalıştırın:
```bash
cd /home/ubuntu/Desktop/KonusmaAdasi
godot
```
Veya doğrudan belirli bir sahneyi test etmek için:
```bash
godot scenes/main/main_menu.tscn
```

### 3. Otomatik Testleri (QA Suite) Çalıştırma
Tüm yöneticileri, JSON veri tabanlarını, kayıt fonksiyonlarını ve 7 sahneyi doğrulamak için:
```bash
cd /home/ubuntu/Desktop/KonusmaAdasi
godot --headless tests/test_runner.tscn
```
*(X11 ortamı olmayan sunucularda `xvfb-run -a godot --headless tests/test_runner.tscn` kullanılabilir).*

---

## 🎙️ Gerçeğe Yakın ElevenLabs TTS Entegrasyonu

Oyun içerisinde mikrofon kaydı zorunluluğu kaldırılmış; çocukların net, canlı ve gerçeğe en yakın telaffuzları dinleyip öğrenmesi için **ElevenLabs Multilingual v2** ses motoru altyapısı kurulmuştur.

### 1. API Anahtarını Tanımlama
API anahtarınızı `.env` dosyasına kaydedebilirsiniz:
```bash
cd /home/ubuntu/Desktop/KonusmaAdasi
python3 scripts/elevenlabs_tts.py --set-key YOUR_ELEVENLABS_API_KEY
```
*(Veya doğrudan `KonusmaAdasi/.env` dosyasını açıp `ELEVENLABS_API_KEY=...` satırına yazabilirsiniz).*

### 2. Bağlantıyı ve Örnek Sesi Test Etme
```bash
python3 scripts/elevenlabs_tts.py --test
```

### 3. Tüm Oyun Seslerini Tek Komutla Doğal Sese Dönüştürme
Maskotların (Mimi, Fino, Piko, Toto) tüm yönergelerini, kelimeleri ve heceleri ElevenLabs ile yeniden üretmek için:
```bash
python3 scripts/elevenlabs_tts.py --generate-all
```

### 4. İstediğiniz Özel Cümleyi Seslendirme
```bash
python3 scripts/elevenlabs_tts.py --phrase "Aferin sana, harika gidiyorsun!" --voice mimi
```

---

## 📱 Dışa Aktarma (Export) ve Platformlar

Oyun responsive (1280x720 canvas_items, expand mod) tasarlandığı için farklı ekran oranlarına kusursuz uyum sağlar:
- **Masaüstü (Desktop):** Linux, Windows, macOS
- **Tablet & Mobil:** Android ve iPadOS için büyük dokunma hedefleri (minimum 56–80px) uygulanmıştır.

---

## 📄 Lisans
Eğitim ve terapi amaçlı açık kaynak kodlu olarak geliştirilmiştir.
