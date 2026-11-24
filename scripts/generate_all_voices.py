#!/usr/bin/env python3
"""
generate_all_voices.py
Konuşma Adası için %100 Yerel Türkçe Doğal Neural TTS Üretim Aracı.
Çocuk terapisi standartlarına uygun olarak yavaş, tane tane ve 0 aksanlı Türkçe seslendirme üretir.

- Mimi: tr-TR-EmelNeural (Tatlı, sevecen, yavaş)
- Piko: tr-TR-EmelNeural (Neşeli, teşvik edici)
- Toto: tr-TR-AhmetNeural (Sakin, bilge, yavaş kaplumbağa)
- Fino: tr-TR-EmelNeural (Ada rehberi, net ve sıcak)
- Kelimeler & Heceler: Çok tane tane, net telaffuz (rate: -18% / -20%)
"""

import os
import sys
import asyncio
import subprocess
import edge_tts

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_VOICE_DIR = os.path.join(PROJECT_DIR, "assets/audio/voice")

VOICE_CONFIGS = {
    # Karakterler: (voice_name, rate, pitch)
    "mimi": ("tr-TR-EmelNeural", "-14%", "+2Hz"),
    "fino": ("tr-TR-EmelNeural", "-12%", "+0Hz"),
    "piko": ("tr-TR-EmelNeural", "-10%", "+4Hz"),
    "toto": ("tr-TR-AhmetNeural", "-16%", "-2Hz"),
    "word": ("tr-TR-EmelNeural", "-16%", "+1Hz"),
    "syllable": ("tr-TR-EmelNeural", "-20%", "+0Hz"),
    "reward": ("tr-TR-EmelNeural", "-10%", "+3Hz"),
}

PROMPTS = {
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

    # Fino (Ada Rehberi)
    "fino_ada_rehberi.wav": ("fino", "Konuşma Adası'na hoş geldin! Oynamak istediğin yeri seç!"),

    # Kelime Telaffuzları (Çok net, tane tane ve doğal)
    "kelime_araba.wav": ("word", "Araba"),
    "kelime_armut.wav": ("word", "Armut"),
    "kelime_balik.wav": ("word", "Balık"),
    "kelime_elma.wav": ("word", "Elma"),
    "kelime_top.wav": ("word", "Top"),
    "kelime_kedi.wav": ("word", "Kedi"),
    "kelime_kopek.wav": ("word", "Köpek"),
    "kelime_muz.wav": ("word", "Muz"),
    "kelime_gemi.wav": ("word", "Gemi"),

    # Heceler
    "hece_a.wav": ("syllable", "A"),
    "hece_ra.wav": ("syllable", "Ra"),
    "hece_ba.wav": ("syllable", "Ba"),
    "hece_ar.wav": ("syllable", "Ar"),
    "hece_mut.wav": ("syllable", "Mut"),
    "hece_lik.wav": ("syllable", "Lık"),
    "hece_el.wav": ("syllable", "El"),
    "hece_ma.wav": ("syllable", "Ma"),
    "hece_ke.wav": ("syllable", "Ke"),
    "hece_di.wav": ("syllable", "Di"),

    # Teşvik Edici Övgü Cümleleri
    "aferin.wav": ("reward", "Aferin sana!"),
    "harika.wav": ("reward", "Harika bir iş çıkardın!"),
    "cok_guzel.wav": ("reward", "Çok güzel yaptın!"),
    "tebrikler.wav": ("reward", "Tebrikler, yeni bir yıldız kazandın!"),
    "test_elevenlabs.wav": ("mimi", "Konuşma Adası ses testi. Sesler harika çalışıyor!")
}

async def generate_voice_file(filename, config_key, text):
    voice_name, rate, pitch = VOICE_CONFIGS[config_key]
    out_path = os.path.join(OUTPUT_VOICE_DIR, filename)
    temp_mp3 = out_path + ".tmp.mp3"

    try:
        comm = edge_tts.Communicate(text, voice=voice_name, rate=rate, pitch=pitch)
        await comm.save(temp_mp3)

        # Godot 4 uyumlu 22050Hz 16-bit Mono WAV formatına dönüştür
        cmd = [
            "ffmpeg", "-y", "-i", temp_mp3,
            "-ar", "22050", "-ac", "1", out_path
        ]
        subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        if os.path.exists(temp_mp3):
            os.remove(temp_mp3)
        print(f"  ✓ {filename} [{voice_name}, {rate}]: \"{text}\"")
        return True
    except Exception as e:
        print(f"  ✗ Hata ({filename}): {e}")
        if os.path.exists(temp_mp3):
            os.remove(temp_mp3)
        return False

async def main():
    os.makedirs(OUTPUT_VOICE_DIR, exist_ok=True)
    print(f"🔊 Yerel Türkçe Doğal TTS üretimi başlıyor ({len(PROMPTS)} dosya)...")
    success_count = 0
    for filename, (config_key, text) in PROMPTS.items():
        ok = await generate_voice_file(filename, config_key, text)
        if ok:
            success_count += 1
    print(f"\n🎉 Tamamlandı: {success_count}/{len(PROMPTS)} ses dosyası başarıyla üretildi.")

if __name__ == "__main__":
    asyncio.run(main())
