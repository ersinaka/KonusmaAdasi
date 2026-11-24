#!/usr/bin/env python3
"""
elevenlabs_tts.py
Konuşma Adası için ElevenLabs Gerçeğe Yakın Çok Dilli (Multilingual v2) TTS Üretim Aracı.
Tavşan Mimi, Tilki Fino, Papağan Piko ve Kaplumbağa Toto için çocuk dostu doğal seslendirmeler üretir.
"""

import sys
import os
import json
import urllib.request
import urllib.error
import subprocess
import argparse

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENV_FILE = os.path.join(PROJECT_DIR, ".env")
OUTPUT_VOICE_DIR = os.path.join(PROJECT_DIR, "assets/audio/voice")

# Kullanıcının belirttiği özel ses: Ezgi - Cute (XjxV2uE0ZjxxzwMtx4Zx)
# Free tier kütüphane kısıtlamasında (HTTP 402) asla yabancı aksanlı sese düşmez;
# %100 yerel Türkçe Emel Neural sesine geçer.
USER_VOICE_ID = "XjxV2uE0ZjxxzwMtx4Zx"
FALLBACK_TURKISH_VOICE = "tr-TR-EmelNeural"

VOICE_MAP = {
    "mimi": USER_VOICE_ID,
    "fino": USER_VOICE_ID,
    "piko": USER_VOICE_ID,
    "toto": USER_VOICE_ID,
    "default": USER_VOICE_ID
}

# Oyundaki tüm replikler, kelimeler ve karakter eşleşmeleri
GAME_AUDIO_PROMPTS = {
    # Mimi (Ses Ormanı)
    "mimi_hosgeldin.wav": ("mimi", "Merhaba! Ben Tavşan Mimi. Haydi kelimeleri bulalım!"),
    "mimi_araba_sorusu.wav": ("mimi", "Hangisi araba? Resmi bulup dokun!"),
    "mimi_armut_sorusu.wav": ("mimi", "Hangisi armut? Resmi bulup dokun!"),
    "mimi_balik_sorusu.wav": ("mimi", "Hangisi balık? Resmi bulup dokun!"),
    "mimi_elma_sorusu.wav": ("mimi", "Hangisi elma? Harika gidiyorsun!"),
    "mimi_kedi_sorusu.wav": ("mimi", "Hangisi kedi? Miyav diyeni bulalım!"),
    "mimi_top_sorusu.wav": ("mimi", "Hangisi top? Yuvarlak olanı bul!"),

    # Piko (Kelime Köyü)
    "piko_hosgeldin.wav": ("piko", "Merhaba! Ben Papağan Piko. Söylediğim kelimeyi dinle ve benimle birlikte tekrar et!"),
    "piko_kayit_basla.wav": ("piko", "Haydi kelimeyi yüksek sesle söyle!"),
    "piko_harika_kayit.wav": ("piko", "Çok güzel söyledin! Aferin sana."),

    # Toto (Hece Denizi)
    "toto_hosgeldin.wav": ("toto", "Merhaba! Ben Kaptan Toto. Heceleri trene doğru sırayla dizelim!"),

    # Fino (Ada Rehberi & Hikaye Kalesi)
    "fino_ada_rehberi.wav": ("fino", "Konuşma Adası'na hoş geldin! Oynamak istediğin yeri seç!"),

    # Kelime Telaffuzları (Çok net, tane tane ve doğal)
    "kelime_araba.wav": ("fino", "Araba"),
    "kelime_armut.wav": ("mimi", "Armut"),
    "kelime_balik.wav": ("piko", "Balık"),
    "kelime_elma.wav": ("mimi", "Elma"),
    "kelime_top.wav": ("fino", "Top"),
    "kelime_kedi.wav": ("mimi", "Kedi"),
    "kelime_kopek.wav": ("fino", "Köpek"),
    "kelime_muz.wav": ("piko", "Muz"),
    "kelime_gemi.wav": ("toto", "Gemi"),

    # Heceler
    "hece_a.wav": ("toto", "A"),
    "hece_ra.wav": ("toto", "Ra"),
    "hece_ba.wav": ("toto", "Ba"),
    "hece_ar.wav": ("toto", "Ar"),
    "hece_mut.wav": ("toto", "Mut"),
    "hece_lik.wav": ("toto", "Lık"),
    "hece_el.wav": ("toto", "El"),
    "hece_ma.wav": ("toto", "Ma"),
    "hece_ke.wav": ("toto", "Ke"),
    "hece_di.wav": ("toto", "Di"),

    # Teşvik Edici Övgü Cümleleri
    "aferin.wav": ("mimi", "Aferin sana!"),
    "harika.wav": ("piko", "Harika bir iş çıkardın!"),
    "cok_guzel.wav": ("fino", "Çok güzel yaptın!"),
    "tebrikler.wav": ("toto", "Tebrikler, yeni bir yıldız kazandın!")
}

def load_api_key(override_key=None):
    """API anahtarını sırayla parametre, çevre değişkeni ve .env dosyasından okur."""
    if override_key and override_key.strip():
        return override_key.strip()
    
    env_key = os.environ.get("ELEVENLABS_API_KEY", "").strip()
    if env_key:
        return env_key

    if os.path.exists(ENV_FILE):
        with open(ENV_FILE, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line.startswith("ELEVENLABS_API_KEY="):
                    val = line.split("=", 1)[1].strip()
                    if val:
                        return val
    return ""

def set_api_key(key):
    """Yeni API anahtarını .env dosyasına yazar."""
    lines = []
    found = False
    if os.path.exists(ENV_FILE):
        with open(ENV_FILE, "r", encoding="utf-8") as f:
            lines = f.readlines()

    new_lines = []
    for line in lines:
        if line.strip().startswith("ELEVENLABS_API_KEY="):
            new_lines.append(f"ELEVENLABS_API_KEY={key.strip()}\n")
            found = True
        else:
            new_lines.append(line)

    if not found:
        new_lines.append(f"ELEVENLABS_API_KEY={key.strip()}\n")

    with open(ENV_FILE, "w", encoding="utf-8") as f:
        f.writelines(new_lines)
    print(f"✅ ElevenLabs API anahtarı başarıyla '{ENV_FILE}' dosyasına kaydedildi.")

def get_account_voices(api_key):
    """Hesapta tanımlı sesleri listeler."""
    url = "https://api.elevenlabs.io/v1/voices"
    req = urllib.request.Request(url, headers={"xi-api-key": api_key})
    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            return data.get("voices", [])
    except urllib.error.HTTPError as e:
        print(f"❌ ElevenLabs API Hatası ({e.code}): {e.read().decode('utf-8')}")
        return []
    except Exception as e:
        print(f"❌ Bağlantı Hatası: {e}")
        return []

def synthesize_speech(text, voice_id, output_wav_path, api_key):
    """ElevenLabs Multilingual v2 ile Türkçe metni doğal, yavaş ve şefkatli sese çevirir."""
    # Yavaş, tane tane ve duygulu çocuk terapisi konuşma parametreleri
    payload = {
        "text": text,
        "model_id": "eleven_multilingual_v2",
        "voice_settings": {
            "stability": 0.38,
            "similarity_boost": 0.85,
            "style": 0.60,
            "use_speaker_boost": True,
            "speed": 0.82
        }
    }
    
    temp_mp3 = output_wav_path + ".tmp.mp3"
    url = f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"
    headers = {
        "xi-api-key": api_key,
        "Content-Type": "application/json",
        "Accept": "audio/mpeg"
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers, method="POST")

    try:
        with urllib.request.urlopen(req) as resp:
            with open(temp_mp3, "wb") as f:
                f.write(resp.read())

        cmd = [
            "ffmpeg", "-y", "-i", temp_mp3,
            "-ar", "22050", "-ac", "1", output_wav_path
        ]
        subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        if os.path.exists(temp_mp3):
            os.remove(temp_mp3)
        return True
    except urllib.error.HTTPError as e:
        err_msg = e.read().decode("utf-8")
        print(f"ℹ️ ElevenLabs API uyarısı ({e.code}): {err_msg}")
        print(f"🔄 %100 Doğal Türkçe Yerel Neural seslendirmeye geçiliyor ({FALLBACK_TURKISH_VOICE})...")
        import asyncio, edge_tts
        async def fallback_edge():
            comm = edge_tts.Communicate(text, voice=FALLBACK_TURKISH_VOICE, rate="-15%", pitch="+2Hz")
            await comm.save(temp_mp3)
        asyncio.run(fallback_edge())
        cmd = [
            "ffmpeg", "-y", "-i", temp_mp3,
            "-ar", "22050", "-ac", "1", output_wav_path
        ]
        subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        if os.path.exists(temp_mp3):
            os.remove(temp_mp3)
        return True
    except Exception as e:
        print(f"❌ TTS Dönüştürme Hatası: {e}")
        if os.path.exists(temp_mp3):
            os.remove(temp_mp3)
        return False

def main():
    parser = argparse.ArgumentParser(description="Konuşma Adası ElevenLabs TTS Yöneticisi")
    parser.add_argument("--set-key", type=str, help="ElevenLabs API anahtarını kaydet")
    parser.add_argument("--key", type=str, help="Geçici API anahtarı kullan")
    parser.add_argument("--list-voices", action="store_true", help="Hesaptaki sesleri listele")
    parser.add_argument("--test", action="store_true", help="Bağlantıyı ve 1 örnek sesi test et")
    parser.add_argument("--generate-all", action="store_true", help="Bütün oyun seslendirmelerini üret")
    parser.add_argument("--phrase", type=str, help="Tekil bir Türkçe cümle seslendir")
    parser.add_argument("--voice", type=str, default="mimi", help="Kullanılacak ses (mimi, fino, piko, toto)")
    parser.add_argument("--out", type=str, help="Çıktı WAV dosya yolu")

    args = parser.parse_args()

    if args.set_key:
        set_api_key(args.set_key)
        return

    api_key = load_api_key(args.key)

    if not api_key:
        print("⚠️ ElevenLabs API Anahtarı bulunamadı!")
        print("Kullanım için anahtarınızı şu komutla kaydedebilirsiniz:")
        print("   python3 scripts/elevenlabs_tts.py --set-key YOUR_API_KEY")
        print("Veya KonusmaAdasi/.env dosyasına 'ELEVENLABS_API_KEY=...' satırını ekleyebilirsiniz.")
        sys.exit(1)

    if args.list_voices:
        print("🔍 ElevenLabs sesleri sorgulanıyor...")
        voices = get_account_voices(api_key)
        for v in voices:
            print(f"- {v['name']} (ID: {v['voice_id']}) - Kategori: {v.get('category', '')}")
        return

    if args.test:
        print("🎙️ ElevenLabs bağlantısı ve örnek ses testi başlatılıyor...")
        test_out = os.path.join(OUTPUT_VOICE_DIR, "test_elevenlabs.wav")
        voice_id = VOICE_MAP["mimi"]
        test_text = "Merhaba! Konuşma Adası'na hoş geldin, ben Tavşan Mimi!"
        success = synthesize_speech(test_text, voice_id, test_out, api_key)
        if success:
            print(f"🎉 Test başarılı! Ses oluşturuldu: {test_out}")
        else:
            print("❌ Test başarısız. Lütfen API anahtarınızı kontrol edin.")
        return

    if args.phrase:
        out_path = args.out if args.out else os.path.join(OUTPUT_VOICE_DIR, "custom_phrase.wav")
        voice_id = VOICE_MAP.get(args.voice, VOICE_MAP["default"])
        print(f"🎙️ Seslendiriliyor: '{args.phrase}' (Ses: {args.voice}) -> {out_path}")
        success = synthesize_speech(args.phrase, voice_id, out_path, api_key)
        if success:
            print(f"✅ Başarıyla üretildi: {out_path}")
        return

    if args.generate_all:
        print(f"🚀 Toplam {len(GAME_AUDIO_PROMPTS)} adet oyun sesi ElevenLabs Multilingual v2 ile üretiliyor...")
        os.makedirs(OUTPUT_VOICE_DIR, exist_ok=True)
        count = 0
        for filename, (char_key, text) in GAME_AUDIO_PROMPTS.items():
            out_file = os.path.join(OUTPUT_VOICE_DIR, filename)
            voice_id = VOICE_MAP.get(char_key, VOICE_MAP["default"])
            print(f"[{count+1}/{len(GAME_AUDIO_PROMPTS)}] {filename} ({char_key}): \"{text}\"")
            if synthesize_speech(text, voice_id, out_file, api_key):
                count += 1
            else:
                print(f"⚠️ {filename} üretilemedi.")
        print(f"\n🎉 Tamamlandı! {count}/{len(GAME_AUDIO_PROMPTS)} dosya başarıyla oluşturuldu.")
        return

    parser.print_help()

if __name__ == "__main__":
    main()
