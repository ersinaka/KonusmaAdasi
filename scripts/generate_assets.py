#!/usr/bin/env python3
"""
generate_assets.py
Konuşma Adası için SVG vektör çizimleri ve Türkçe seslendirme WAV dosyalarını üretir.
"""

import os
import subprocess

PROJECT_DIR = "/home/ubuntu/Desktop/KonusmaAdasi"
CHAR_DIR = os.path.join(PROJECT_DIR, "assets/characters")
OBJ_DIR = os.path.join(PROJECT_DIR, "assets/objects")
BG_DIR = os.path.join(PROJECT_DIR, "assets/backgrounds")
UI_DIR = os.path.join(PROJECT_DIR, "assets/ui")
AUDIO_VOICE_DIR = os.path.join(PROJECT_DIR, "assets/audio/voice")
AUDIO_SFX_DIR = os.path.join(PROJECT_DIR, "assets/audio/sfx")

os.makedirs(CHAR_DIR, exist_ok=True)
os.makedirs(OBJ_DIR, exist_ok=True)
os.makedirs(BG_DIR, exist_ok=True)
os.makedirs(UI_DIR, exist_ok=True)
os.makedirs(AUDIO_VOICE_DIR, exist_ok=True)
os.makedirs(AUDIO_SFX_DIR, exist_ok=True)

# ----------------- SVG DRAWINGS -----------------

svg_files = {}

# 1. Tilki Fino (Main Mascot)
svg_files[f"{CHAR_DIR}/fino.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 360" width="300" height="360">
  <defs>
    <filter id="shadow" x="-10%" y="-10%" width="120%" height="120%">
      <feDropShadow dx="0" dy="6" stdDeviation="6" flood-color="#f27d52" flood-opacity="0.25"/>
    </filter>
  </defs>
  <!-- Kuyruk -->
  <path d="M 200 230 C 260 210, 290 280, 250 320 C 220 340, 180 320, 180 290 Z" fill="#FF8A50" filter="url(#shadow)"/>
  <path d="M 235 300 C 260 270, 275 300, 250 320 Z" fill="#FFF3E0"/>
  <!-- Vücut -->
  <ellipse cx="150" cy="260" rx="75" ry="85" fill="#FF8A50" filter="url(#shadow)"/>
  <!-- Göbek (Krem) -->
  <ellipse cx="150" cy="275" rx="48" ry="60" fill="#FFF8E1"/>
  <!-- Kulaklar -->
  <polygon points="90,130 50,40 120,90" fill="#FF8A50"/>
  <polygon points="85,120 60,55 110,95" fill="#FFAB91"/>
  <polygon points="210,130 250,40 180,90" fill="#FF8A50"/>
  <polygon points="215,120 240,55 190,95" fill="#FFAB91"/>
  <!-- Kafa -->
  <ellipse cx="150" cy="150" rx="80" ry="65" fill="#FF8A50" filter="url(#shadow)"/>
  <!-- Beyaz Yanaklar -->
  <path d="M 70 160 C 70 195, 120 205, 150 180 C 180 205, 230 195, 230 160 C 210 130, 90 130, 70 160 Z" fill="#FFF8E1"/>
  <!-- Sevimli Gözler -->
  <ellipse cx="115" cy="140" rx="9" ry="12" fill="#2E3440"/>
  <circle cx="118" cy="136" r="4" fill="#FFFFFF"/>
  <ellipse cx="185" cy="140" rx="9" ry="12" fill="#2E3440"/>
  <circle cx="188" cy="136" r="4" fill="#FFFFFF"/>
  <!-- Pembe Yanak Allığı -->
  <ellipse cx="95" cy="165" rx="14" ry="8" fill="#FFAB91" opacity="0.6"/>
  <ellipse cx="205" cy="165" rx="14" ry="8" fill="#FFAB91" opacity="0.6"/>
  <!-- Burun -->
  <ellipse cx="150" cy="165" rx="8" ry="6" fill="#37474F"/>
  <!-- Gülümseme -->
  <path d="M 142 173 Q 150 180 158 173" stroke="#37474F" stroke-width="3.5" fill="none" stroke-linecap="round"/>
  <!-- Kollar -->
  <path d="M 85 240 Q 65 270 95 285" stroke="#FF8A50" stroke-width="22" stroke-linecap="round" fill="none"/>
  <path d="M 215 240 Q 235 270 205 285" stroke="#FF8A50" stroke-width="22" stroke-linecap="round" fill="none"/>
</svg>"""

svg_files[f"{CHAR_DIR}/fino_avatar.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <circle cx="80" cy="80" r="75" fill="#FFE0B2" stroke="#FFB74D" stroke-width="4"/>
  <polygon points="45,70 25,25 65,50" fill="#FF8A50"/>
  <polygon points="43,65 30,35 58,52" fill="#FFAB91"/>
  <polygon points="115,70 135,25 95,50" fill="#FF8A50"/>
  <polygon points="117,65 130,35 102,52" fill="#FFAB91"/>
  <ellipse cx="80" cy="85" rx="55" ry="45" fill="#FF8A50"/>
  <path d="M 30 92 C 30 115, 60 122, 80 105 C 100 122, 130 115, 130 92 C 115 72, 45 72, 30 92 Z" fill="#FFF8E1"/>
  <ellipse cx="60" cy="82" rx="6" ry="8" fill="#2E3440"/>
  <circle cx="62" cy="79" r="2.5" fill="#FFFFFF"/>
  <ellipse cx="100" cy="82" rx="6" ry="8" fill="#2E3440"/>
  <circle cx="102" cy="79" r="2.5" fill="#FFFFFF"/>
  <ellipse cx="48" cy="98" rx="8" ry="5" fill="#FFAB91" opacity="0.6"/>
  <ellipse cx="112" cy="98" rx="8" ry="5" fill="#FFAB91" opacity="0.6"/>
  <ellipse cx="80" cy="98" rx="5" ry="4" fill="#37474F"/>
  <path d="M 75 103 Q 80 108 85 103" stroke="#37474F" stroke-width="2.5" fill="none" stroke-linecap="round"/>
</svg>"""

# 2. Mimi the Bunny (Ses Ormanı Rehberi)
svg_files[f"{CHAR_DIR}/mimi.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 360" width="300" height="360">
  <!-- Kulaklar -->
  <ellipse cx="110" cy="70" rx="22" ry="65" fill="#F8BBD0" transform="rotate(-8 110 70)"/>
  <ellipse cx="110" cy="70" rx="12" ry="45" fill="#F48FB1" transform="rotate(-8 110 70)"/>
  <ellipse cx="190" cy="70" rx="22" ry="65" fill="#F8BBD0" transform="rotate(8 190 70)"/>
  <ellipse cx="190" cy="70" rx="12" ry="45" fill="#F48FB1" transform="rotate(8 190 70)"/>
  <!-- Vücut -->
  <ellipse cx="150" cy="270" rx="72" ry="80" fill="#F8BBD0"/>
  <ellipse cx="150" cy="280" rx="46" ry="55" fill="#FFFFFF"/>
  <!-- Kafa -->
  <ellipse cx="150" cy="170" rx="75" ry="65" fill="#F8BBD0"/>
  <ellipse cx="150" cy="180" rx="50" ry="45" fill="#FFFFFF"/>
  <!-- Gözler -->
  <ellipse cx="120" cy="160" rx="8" ry="11" fill="#4A148C"/>
  <circle cx="122" cy="156" r="3.5" fill="#FFFFFF"/>
  <ellipse cx="180" cy="160" rx="8" ry="11" fill="#4A148C"/>
  <circle cx="182" cy="156" r="3.5" fill="#FFFFFF"/>
  <!-- Yanaklar -->
  <circle cx="102" cy="182" r="12" fill="#FF80AB" opacity="0.45"/>
  <circle cx="198" cy="182" r="12" fill="#FF80AB" opacity="0.45"/>
  <!-- Sevimli Burun ve Ağız -->
  <polygon points="146,178 154,178 150,183" fill="#EC407A"/>
  <path d="M 144 186 Q 150 192 156 186" stroke="#4A148C" stroke-width="3" fill="none" stroke-linecap="round"/>
  <!-- Sevimli Çiçek Tokası -->
  <circle cx="95" cy="120" r="10" fill="#FFF59D"/>
  <circle cx="95" cy="120" r="5" fill="#FFB74D"/>
  <!-- Kollar & Havuç -->
  <path d="M 90 250 Q 75 285 110 290" stroke="#F8BBD0" stroke-width="20" stroke-linecap="round" fill="none"/>
  <path d="M 210 250 Q 225 285 190 290" stroke="#F8BBD0" stroke-width="20" stroke-linecap="round" fill="none"/>
  <!-- Minik Havuç -->
  <polygon points="150,265 165,305 140,295" fill="#FF7043"/>
  <path d="M 148 266 Q 140 250 135 255 M 150 265 Q 152 248 156 250" stroke="#66BB6A" stroke-width="4" stroke-linecap="round"/>
</svg>"""

svg_files[f"{CHAR_DIR}/mimi_avatar.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <circle cx="80" cy="80" r="75" fill="#FCE4EC" stroke="#F48FB1" stroke-width="4"/>
  <ellipse cx="58" cy="40" rx="12" ry="32" fill="#F8BBD0" transform="rotate(-8 58 40)"/>
  <ellipse cx="58" cy="40" rx="6" ry="22" fill="#F48FB1" transform="rotate(-8 58 40)"/>
  <ellipse cx="102" cy="40" rx="12" ry="32" fill="#F8BBD0" transform="rotate(8 102 40)"/>
  <ellipse cx="102" cy="40" rx="6" ry="22" fill="#F48FB1" transform="rotate(8 102 40)"/>
  <ellipse cx="80" cy="95" rx="50" ry="44" fill="#F8BBD0"/>
  <ellipse cx="80" cy="102" rx="34" ry="30" fill="#FFFFFF"/>
  <ellipse cx="62" cy="90" rx="6" ry="8" fill="#4A148C"/>
  <circle cx="64" cy="87" r="2.5" fill="#FFFFFF"/>
  <ellipse cx="98" cy="90" rx="6" ry="8" fill="#4A148C"/>
  <circle cx="100" cy="87" r="2.5" fill="#FFFFFF"/>
  <circle cx="50" cy="104" r="8" fill="#FF80AB" opacity="0.45"/>
  <circle cx="110" cy="104" r="8" fill="#FF80AB" opacity="0.45"/>
  <polygon points="77,100 83,100 80,104" fill="#EC407A"/>
  <path d="M 76 106 Q 80 110 84 106" stroke="#4A148C" stroke-width="2" fill="none" stroke-linecap="round"/>
</svg>"""

# 3. Piko the Parrot (Papağanı Konuştur Rehberi)
svg_files[f"{CHAR_DIR}/piko.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 360" width="300" height="360">
  <!-- Kanat -->
  <path d="M 80 200 C 60 250, 90 320, 150 320 C 130 280, 110 240, 110 200 Z" fill="#26A69A"/>
  <!-- Vücut -->
  <ellipse cx="160" cy="230" rx="70" ry="90" fill="#4DB6AC"/>
  <ellipse cx="170" cy="245" rx="42" ry="65" fill="#FFF176"/>
  <!-- Kafa ve İbik -->
  <ellipse cx="160" cy="130" rx="60" ry="60" fill="#4DB6AC"/>
  <path d="M 150 75 Q 160 30 180 50 Q 170 75 160 75" fill="#FF7043"/>
  <path d="M 135 80 Q 140 45 155 60 Q 145 80 135 80" fill="#FFCA28"/>
  <!-- Göz Çevresi Beyaz Halka -->
  <circle cx="135" cy="120" r="22" fill="#FFFFFF"/>
  <circle cx="135" cy="120" r="9" fill="#263238"/>
  <circle cx="138" cy="116" r="3.5" fill="#FFFFFF"/>
  <!-- Gaga -->
  <path d="M 175 105 C 225 115, 230 155, 175 160 C 185 145, 185 125, 175 105 Z" fill="#FFA726"/>
  <path d="M 175 135 C 205 135, 210 160, 175 155 Z" fill="#FB8C00"/>
  <!-- Ayaklar -->
  <path d="M 140 320 L 135 345 M 140 320 L 145 345" stroke="#FFA726" stroke-width="6" stroke-linecap="round"/>
  <path d="M 180 320 L 175 345 M 180 320 L 185 345" stroke="#FFA726" stroke-width="6" stroke-linecap="round"/>
</svg>"""

svg_files[f"{CHAR_DIR}/piko_avatar.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <circle cx="80" cy="80" r="75" fill="#E0F2F1" stroke="#4DB6AC" stroke-width="4"/>
  <path d="M 75 35 Q 82 10 95 22 Q 88 35 75 35" fill="#FF7043"/>
  <path d="M 65 38 Q 70 18 80 27 Q 73 38 65 38" fill="#FFCA28"/>
  <ellipse cx="75" cy="88" rx="46" ry="48" fill="#4DB6AC"/>
  <circle cx="60" cy="80" r="18" fill="#FFFFFF"/>
  <circle cx="60" cy="80" r="7.5" fill="#263238"/>
  <circle cx="63" cy="77" r="3" fill="#FFFFFF"/>
  <path d="M 90 68 C 130 75, 135 108, 90 112 C 98 100, 98 85, 90 68 Z" fill="#FFA726"/>
  <path d="M 90 92 C 115 92, 120 112, 90 108 Z" fill="#FB8C00"/>
</svg>"""

# 4. Toto the Turtle (Hece Denizi / Tren Rehberi)
svg_files[f"{CHAR_DIR}/toto.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 360" width="300" height="360">
  <!-- Kabuk (Arka) -->
  <ellipse cx="150" cy="220" rx="95" ry="90" fill="#81C784"/>
  <ellipse cx="150" cy="220" rx="80" ry="75" fill="#66BB6A"/>
  <!-- Kabuk Desenleri -->
  <polygon points="150,170 180,195 180,235 150,260 120,235 120,195" fill="#A5D6A7"/>
  <polygon points="150,150 180,170 120,170" fill="#C8E6C9"/>
  <!-- Ayaklar -->
  <ellipse cx="70" cy="270" rx="28" ry="18" fill="#81C784"/>
  <ellipse cx="230" cy="270" rx="28" ry="18" fill="#81C784"/>
  <!-- Kafa ve Sevimli Denizci Şapkası -->
  <ellipse cx="150" cy="115" rx="48" ry="42" fill="#A5D6A7"/>
  <!-- Denizci Şapkası -->
  <ellipse cx="150" cy="82" rx="36" ry="12" fill="#FFFFFF"/>
  <path d="M 125 82 C 125 60, 175 60, 175 82 Z" fill="#42A5F5"/>
  <circle cx="150" cy="62" r="5" fill="#EF5350"/>
  <!-- Gözler -->
  <ellipse cx="132" cy="110" rx="6" ry="9" fill="#2E3440"/>
  <circle cx="134" cy="107" r="2.5" fill="#FFFFFF"/>
  <ellipse cx="168" cy="110" rx="6" ry="9" fill="#2E3440"/>
  <circle cx="170" cy="107" r="2.5" fill="#FFFFFF"/>
  <!-- Yanaklar ve Bilge Gülümseme -->
  <ellipse cx="118" cy="125" rx="8" ry="5" fill="#EF9A9A" opacity="0.5"/>
  <ellipse cx="182" cy="125" rx="8" ry="5" fill="#EF9A9A" opacity="0.5"/>
  <path d="M 140 128 Q 150 136 160 128" stroke="#2E3440" stroke-width="3" fill="none" stroke-linecap="round"/>
</svg>"""

svg_files[f"{CHAR_DIR}/toto_avatar.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <circle cx="80" cy="80" r="75" fill="#E8F5E9" stroke="#81C784" stroke-width="4"/>
  <ellipse cx="80" cy="98" rx="46" ry="38" fill="#66BB6A"/>
  <ellipse cx="80" cy="72" rx="34" ry="28" fill="#A5D6A7"/>
  <ellipse cx="80" cy="50" rx="26" ry="9" fill="#FFFFFF"/>
  <path d="M 62 50 C 62 34, 98 34, 98 50 Z" fill="#42A5F5"/>
  <circle cx="80" cy="36" r="3.5" fill="#EF5350"/>
  <ellipse cx="68" cy="68" rx="5" ry="7" fill="#2E3440"/>
  <circle cx="70" cy="66" r="2" fill="#FFFFFF"/>
  <ellipse cx="92" cy="68" rx="5" ry="7" fill="#2E3440"/>
  <circle cx="94" cy="66" r="2" fill="#FFFFFF"/>
  <circle cx="58" cy="78" r="6" fill="#EF9A9A" opacity="0.5"/>
  <circle cx="102" cy="78" r="6" fill="#EF9A9A" opacity="0.5"/>
  <path d="M 74 80 Q 80 86 86 80" stroke="#2E3440" stroke-width="2" fill="none" stroke-linecap="round"/>
</svg>"""

# ----------------- OBJECTS (WORDS / ITEMS) -----------------

# 1. Araba (Car)
svg_files[f"{OBJ_DIR}/araba.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 160" width="200" height="160">
  <rect x="25" y="65" width="150" height="50" rx="18" fill="#EF5350"/>
  <path d="M 50 65 L 75 25 L 130 25 L 155 65 Z" fill="#FF7043"/>
  <!-- Pencereler -->
  <polygon points="80,32 100,32 100,60 62,60" fill="#E0F7FA"/>
  <polygon points="106,32 126,32 144,60 106,60" fill="#E0F7FA"/>
  <!-- Farlar -->
  <ellipse cx="170" cy="80" rx="6" ry="8" fill="#FFEE58"/>
  <ellipse cx="30" cy="80" rx="4" ry="7" fill="#FFA726"/>
  <!-- Tekerlekler -->
  <circle cx="60" cy="115" r="22" fill="#37474F"/>
  <circle cx="60" cy="115" r="10" fill="#ECEFF1"/>
  <circle cx="140" cy="115" r="22" fill="#37474F"/>
  <circle cx="140" cy="115" r="10" fill="#ECEFF1"/>
</svg>"""

# 2. Armut (Pear)
svg_files[f"{OBJ_DIR}/armut.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 200" width="160" height="200">
  <!-- Sap ve Yaprak -->
  <path d="M 80 45 Q 90 20 105 15" stroke="#795548" stroke-width="6" fill="none" stroke-linecap="round"/>
  <ellipse cx="98" cy="25" rx="14" ry="7" fill="#66BB6A" transform="rotate(-30 98 25)"/>
  <!-- Armut Gövdesi -->
  <path d="M 80 45 C 55 45, 50 85, 40 120 C 25 170, 65 190, 80 190 C 95 190, 135 170, 120 120 C 110 85, 105 45, 80 45 Z" fill="#D4E157"/>
  <!-- Parlaklık -->
  <ellipse cx="65" cy="120" rx="10" ry="25" fill="#EEFF41" opacity="0.6" transform="rotate(-15 65 120)"/>
</svg>"""

# 3. Balık (Fish)
svg_files[f"{OBJ_DIR}/balik.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 160" width="200" height="160">
  <!-- Kuyruk -->
  <polygon points="50,80 15,40 25,80 15,120" fill="#FF7043"/>
  <!-- Yüzgeçler -->
  <path d="M 100 45 Q 120 20 140 45 Z" fill="#FF8A65"/>
  <path d="M 110 115 Q 120 135 135 115 Z" fill="#FF8A65"/>
  <!-- Gövde -->
  <ellipse cx="115" cy="80" rx="65" ry="42" fill="#FFA726"/>
  <!-- Beyaz Palyaço Çizgileri -->
  <path d="M 100 45 Q 110 80 100 115 Q 92 80 100 45 Z" fill="#FFFFFF"/>
  <path d="M 135 48 Q 142 80 135 112 Q 128 80 135 48 Z" fill="#FFFFFF"/>
  <!-- Göz -->
  <circle cx="155" cy="72" r="9" fill="#FFFFFF"/>
  <circle cx="157" cy="72" r="4.5" fill="#2E3440"/>
  <!-- Ağız -->
  <path d="M 175 85 Q 168 88 175 92" stroke="#E65100" stroke-width="3" fill="none" stroke-linecap="round"/>
</svg>"""

# 4. Elma (Apple)
svg_files[f"{OBJ_DIR}/elma.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <path d="M 80 35 Q 90 12 102 10" stroke="#6D4C41" stroke-width="5" fill="none" stroke-linecap="round"/>
  <ellipse cx="94" cy="20" rx="12" ry="6" fill="#81C784" transform="rotate(-25 94 20)"/>
  <path d="M 80 40 C 45 25, 20 60, 25 100 C 30 140, 70 150, 80 142 C 90 150, 130 140, 135 100 C 140 60, 115 25, 80 40 Z" fill="#E53935"/>
  <ellipse cx="55" cy="75" rx="8" ry="18" fill="#FF8A80" opacity="0.6" transform="rotate(-20 55 75)"/>
</svg>"""

# 5. Top (Ball)
svg_files[f"{OBJ_DIR}/top.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <circle cx="80" cy="80" r="68" fill="#42A5F5"/>
  <path d="M 80 12 C 45 35, 45 125, 80 148 C 55 125, 55 35, 80 12 Z" fill="#FFEE58"/>
  <path d="M 80 12 C 115 35, 115 125, 80 148 C 105 125, 105 35, 80 12 Z" fill="#EF5350"/>
  <circle cx="80" cy="80" r="16" fill="#FFFFFF"/>
</svg>"""

# 6. Kedi (Cat)
svg_files[f"{OBJ_DIR}/kedi.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 180" width="180" height="180">
  <!-- Kulaklar -->
  <polygon points="50,70 35,25 80,45" fill="#FFA726"/>
  <polygon points="48,65 40,35 72,50" fill="#FFCCBC"/>
  <polygon points="130,70 145,25 100,45" fill="#FFA726"/>
  <polygon points="132,65 140,35 108,50" fill="#FFCCBC"/>
  <!-- Kafa -->
  <ellipse cx="90" cy="95" rx="58" ry="50" fill="#FFA726"/>
  <ellipse cx="90" cy="115" rx="35" ry="25" fill="#FFF3E0"/>
  <!-- Gözler -->
  <ellipse cx="70" cy="90" rx="7" ry="10" fill="#2E7D32"/>
  <ellipse cx="70" cy="90" rx="3" ry="8" fill="#1B5E20"/>
  <ellipse cx="110" cy="90" rx="7" ry="10" fill="#2E7D32"/>
  <ellipse cx="110" cy="90" rx="3" ry="8" fill="#1B5E20"/>
  <!-- Burun & Bıyıklar -->
  <polygon points="86,108 94,108 90,113" fill="#E91E63"/>
  <path d="M 50 108 L 25 105 M 50 115 L 28 120" stroke="#5D4037" stroke-width="2.5" stroke-linecap="round"/>
  <path d="M 130 108 L 155 105 M 130 115 L 152 120" stroke="#5D4037" stroke-width="2.5" stroke-linecap="round"/>
</svg>"""

# 7. Köpek (Dog)
svg_files[f"{OBJ_DIR}/kopek.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 180" width="180" height="180">
  <!-- Kulaklar -->
  <ellipse cx="38" cy="85" rx="16" ry="32" fill="#8D6E63" transform="rotate(15 38 85)"/>
  <ellipse cx="142" cy="85" rx="16" ry="32" fill="#8D6E63" transform="rotate(-15 142 85)"/>
  <!-- Kafa -->
  <ellipse cx="90" cy="95" rx="55" ry="50" fill="#D7CCC8"/>
  <ellipse cx="90" cy="115" rx="36" ry="26" fill="#FFFFFF"/>
  <!-- Gözler -->
  <ellipse cx="72" cy="88" rx="6" ry="9" fill="#3E2723"/>
  <circle cx="74" cy="85" r="2.5" fill="#FFFFFF"/>
  <ellipse cx="108" cy="88" rx="6" ry="9" fill="#3E2723"/>
  <circle cx="110" cy="85" r="2.5" fill="#FFFFFF"/>
  <!-- Burun & Dil -->
  <ellipse cx="90" cy="112" rx="9" ry="7" fill="#3E2723"/>
  <path d="M 90 120 Q 95 135 90 138 Q 85 135 90 120" fill="#FF8A80"/>
</svg>"""

# 8. Muz (Banana)
svg_files[f"{OBJ_DIR}/muz.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 180" width="180" height="180">
  <path d="M 35 45 C 50 110, 110 155, 155 125 C 130 150, 65 125, 45 55 Z" fill="#FDD835"/>
  <path d="M 33 45 L 26 40 L 30 35 L 37 40 Z" fill="#5D4037"/>
  <path d="M 155 125 L 160 128 L 157 132 L 152 129 Z" fill="#5D4037"/>
</svg>"""

# 9. Gemi (Ship / Boat)
svg_files[f"{OBJ_DIR}/gemi.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 160" width="180" height="160">
  <!-- Gövde -->
  <path d="M 25 110 L 45 145 L 135 145 L 160 110 Z" fill="#EF5350"/>
  <rect x="23" y="105" width="138" height="8" rx="4" fill="#FFFFFF"/>
  <!-- Direk -->
  <rect x="86" y="25" width="8" height="85" fill="#795548"/>
  <!-- Yelkenler -->
  <polygon points="98,30 148,88 98,88" fill="#42A5F5"/>
  <polygon points="82,40 40,88 82,88" fill="#90CAF9"/>
  <!-- Bayrak -->
  <polygon points="94,25 112,18 94,12" fill="#FFD54F"/>
</svg>"""

# 10. Çiçek (Flower)
svg_files[f"{OBJ_DIR}/cicek.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <path d="M 80 90 L 80 150" stroke="#4CAF50" stroke-width="8" stroke-linecap="round"/>
  <ellipse cx="60" cy="125" rx="14" ry="7" fill="#81C784" transform="rotate(-30 60 125)"/>
  <!-- Yapraklar -->
  <circle cx="80" cy="50" r="18" fill="#FF80AB"/>
  <circle cx="105" cy="65" r="18" fill="#FF80AB"/>
  <circle cx="105" cy="95" r="18" fill="#FF80AB"/>
  <circle cx="80" cy="110" r="18" fill="#FF80AB"/>
  <circle cx="55" cy="95" r="18" fill="#FF80AB"/>
  <circle cx="55" cy="65" r="18" fill="#FF80AB"/>
  <circle cx="80" cy="80" r="18" fill="#FFEE58"/>
</svg>"""

# 11. Güneş (Sun)
svg_files[f"{OBJ_DIR}/gunes.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 160" width="160" height="160">
  <!-- Işınlar -->
  <g stroke="#FFA726" stroke-width="6" stroke-linecap="round">
    <line x1="80" y1="15" x2="80" y2="30"/>
    <line x1="80" y1="130" x2="80" y2="145"/>
    <line x1="15" y1="80" x2="30" y2="80"/>
    <line x1="130" y1="80" x2="145" y2="80"/>
    <line x1="34" y1="34" x2="45" y2="45"/>
    <line x1="115" y1="115" x2="126" y2="126"/>
    <line x1="34" y1="126" x2="45" y2="115"/>
    <line x1="115" y1="45" x2="126" y2="34"/>
  </g>
  <!-- Daire -->
  <circle cx="80" cy="80" r="42" fill="#FFCA28"/>
  <!-- Sevimli Yüz -->
  <ellipse cx="68" cy="74" rx="4" ry="6" fill="#5D4037"/>
  <ellipse cx="92" cy="74" rx="4" ry="6" fill="#5D4037"/>
  <path d="M 72 88 Q 80 96 88 88" stroke="#5D4037" stroke-width="3" fill="none" stroke-linecap="round"/>
</svg>"""

# 12. Lokomotif & Vagon (Kelime Treni)
svg_files[f"{OBJ_DIR}/tren_lokomotif.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 220 160" width="220" height="160">
  <!-- Baca -->
  <rect x="155" y="30" width="22" height="40" fill="#EF5350" rx="4"/>
  <path d="M 150 30 L 182 30 L 175 42 L 157 42 Z" fill="#D32F2F"/>
  <!-- Kabin & Gövde -->
  <rect x="30" y="40" width="75" height="75" rx="8" fill="#42A5F5"/>
  <rect x="42" y="52" width="50" height="30" rx="6" fill="#E1F5FE"/>
  <rect x="100" y="65" width="85" height="50" rx="8" fill="#29B6F6"/>
  <!-- Burun Farı -->
  <polygon points="185,80 198,75 198,105 185,100" fill="#FFEE58"/>
  <!-- Tekerlekler -->
  <circle cx="65" cy="125" r="24" fill="#37474F"/>
  <circle cx="65" cy="125" r="10" fill="#ECEFF1"/>
  <circle cx="125" cy="130" r="18" fill="#37474F"/>
  <circle cx="125" cy="130" r="8" fill="#ECEFF1"/>
  <circle cx="165" cy="130" r="18" fill="#37474F"/>
  <circle cx="165" cy="130" r="8" fill="#ECEFF1"/>
</svg>"""

svg_files[f"{OBJ_DIR}/tren_vagon.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 160" width="200" height="160">
  <!-- Vagon Gövdesi -->
  <rect x="20" y="55" width="160" height="65" rx="14" fill="#66BB6A"/>
  <rect x="30" y="65" width="140" height="45" rx="8" fill="#C8E6C9" opacity="0.6"/>
  <!-- Bağlantı Demiri -->
  <rect x="0" y="95" width="25" height="10" rx="4" fill="#78909C"/>
  <rect x="175" y="95" width="25" height="10" rx="4" fill="#78909C"/>
  <!-- Tekerlekler -->
  <circle cx="60" cy="128" r="18" fill="#37474F"/>
  <circle cx="60" cy="128" r="8" fill="#ECEFF1"/>
  <circle cx="140" cy="128" r="18" fill="#37474F"/>
  <circle cx="140" cy="128" r="8" fill="#ECEFF1"/>
</svg>"""

# ----------------- UI ICONS & ASSETS -----------------

svg_files[f"{UI_DIR}/icon_home.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#FFB74D"/>
  <polygon points="50,22 24,44 32,44 32,74 68,74 68,44 76,44" fill="#FFFFFF"/>
  <rect x="44" y="54" width="12" height="20" rx="2" fill="#FFB74D"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_back.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#81D4FA"/>
  <path d="M 62 28 L 38 50 L 62 72" stroke="#FFFFFF" stroke-width="12" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_speaker.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#81C784"/>
  <!-- Hoparlör Gövdesi -->
  <polygon points="28,38 42,38 58,24 58,76 42,62 28,62" fill="#FFFFFF"/>
  <!-- Ses Dalgaları -->
  <path d="M 66 38 Q 74 50 66 62" stroke="#FFFFFF" stroke-width="6" stroke-linecap="round" fill="none"/>
  <path d="M 74 28 Q 86 50 74 72" stroke="#FFFFFF" stroke-width="6" stroke-linecap="round" fill="none"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_mic.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#EF5350"/>
  <!-- Mikrofon -->
  <rect x="42" y="24" width="16" height="30" rx="8" fill="#FFFFFF"/>
  <path d="M 34 44 C 34 60, 66 60, 66 44" stroke="#FFFFFF" stroke-width="6" stroke-linecap="round" fill="none"/>
  <line x1="50" y1="62" x2="50" y2="76" stroke="#FFFFFF" stroke-width="6" stroke-linecap="round"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_play.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#4CAF50"/>
  <polygon points="40,28 72,50 40,72" fill="#FFFFFF"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_stop.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#E53935"/>
  <rect x="34" y="34" width="32" height="32" rx="6" fill="#FFFFFF"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_trash.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#B0BEC5"/>
  <path d="M 32 38 L 68 38 M 42 38 L 42 30 L 58 30 L 58 38 M 36 38 L 40 74 L 60 74 L 64 38" stroke="#FFFFFF" stroke-width="6" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_star.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <polygon points="50,10 62,36 90,38 68,58 75,86 50,71 25,86 32,58 10,38 38,36" fill="#FFCA28" stroke="#FFA000" stroke-width="4"/>
  <circle cx="43" cy="46" r="3" fill="#5D4037"/>
  <circle cx="57" cy="46" r="3" fill="#5D4037"/>
  <path d="M 45 54 Q 50 58 55 54" stroke="#5D4037" stroke-width="2.5" fill="none" stroke-linecap="round"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_check.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#66BB6A"/>
  <path d="M 28 50 L 44 66 L 74 34" stroke="#FFFFFF" stroke-width="10" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
</svg>"""

svg_files[f"{UI_DIR}/icon_replay.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <circle cx="50" cy="50" r="46" fill="#AB47BC"/>
  <path d="M 50 25 A 25 25 0 1 1 27 55" stroke="#FFFFFF" stroke-width="8" stroke-linecap="round" fill="none"/>
  <polygon points="20,25 35,25 28,40" fill="#FFFFFF"/>
</svg>"""

# ----------------- BACKGROUNDS -----------------

svg_files[f"{BG_DIR}/bg_main_menu.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 720" width="1280" height="720">
  <defs>
    <linearGradient id="skyGrad" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#E1F5FE"/>
      <stop offset="100%" stop-color="#FFF9C4"/>
    </linearGradient>
    <linearGradient id="hillGrad1" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#A5D6A7"/>
      <stop offset="100%" stop-color="#81C784"/>
    </linearGradient>
    <linearGradient id="hillGrad2" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#C8E6C9"/>
      <stop offset="100%" stop-color="#A5D6A7"/>
    </linearGradient>
  </defs>
  <!-- Gökyüzü -->
  <rect width="1280" height="720" fill="url(#skyGrad)"/>
  <!-- Güneş & Işıltılar -->
  <circle cx="180" cy="140" r="60" fill="#FFF176" opacity="0.8"/>
  <circle cx="180" cy="140" r="85" fill="#FFF59D" opacity="0.3"/>
  <!-- Yumuşak Bulutlar -->
  <path d="M 850 120 Q 880 90 920 110 Q 960 90 990 120 Q 1020 130 990 160 Q 940 170 880 160 Q 840 150 850 120 Z" fill="#FFFFFF" opacity="0.9"/>
  <path d="M 320 180 Q 350 155 380 170 Q 420 150 450 180 Q 470 200 440 220 L 330 220 Z" fill="#FFFFFF" opacity="0.75"/>
  <!-- Uzak Tepeler -->
  <path d="M -50 480 Q 250 360 550 450 Q 850 540 1350 400 L 1350 720 L -50 720 Z" fill="url(#hillGrad2)"/>
  <!-- Ön Yeşil Tepe -->
  <path d="M -50 560 Q 300 460 700 540 Q 1100 620 1350 510 L 1350 720 L -50 720 Z" fill="url(#hillGrad1)"/>
  <!-- Pastel Çiçekler -->
  <circle cx="220" cy="620" r="8" fill="#FF80AB"/>
  <circle cx="280" cy="650" r="10" fill="#FFEE58"/>
  <circle cx="950" cy="610" r="9" fill="#FF80AB"/>
  <circle cx="1060" cy="640" r="11" fill="#BA68C8"/>
  <circle cx="620" cy="660" r="9" fill="#FFB74D"/>
</svg>"""

svg_files[f"{BG_DIR}/bg_island_map.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 720" width="1280" height="720">
  <defs>
    <linearGradient id="seaGrad" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#81D4FA"/>
      <stop offset="100%" stop-color="#4FC3F7"/>
    </linearGradient>
    <linearGradient id="islandGrad" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#C8E6C9"/>
      <stop offset="100%" stop-color="#A5D6A7"/>
    </linearGradient>
    <linearGradient id="beachGrad" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#FFE082"/>
      <stop offset="100%" stop-color="#FFD54F"/>
    </linearGradient>
  </defs>
  <!-- Deniz -->
  <rect width="1280" height="720" fill="url(#seaGrad)"/>
  <!-- Dalga Detayları -->
  <path d="M 100 120 Q 130 110 160 120" stroke="#E1F5FE" stroke-width="4" fill="none" stroke-linecap="round"/>
  <path d="M 1100 200 Q 1130 190 1160 200" stroke="#E1F5FE" stroke-width="4" fill="none" stroke-linecap="round"/>
  <path d="M 200 600 Q 230 590 260 600" stroke="#E1F5FE" stroke-width="4" fill="none" stroke-linecap="round"/>
  <!-- Kumsal Sahil -->
  <ellipse cx="640" cy="380" rx="550" ry="290" fill="url(#beachGrad)"/>
  <!-- Ana Ada Yeşilliği -->
  <ellipse cx="640" cy="380" rx="500" ry="250" fill="url(#islandGrad)"/>
  <!-- Patika Yollar (Bölgeleri bağlayan kıvrımlı yumuşak yollar) -->
  <path d="M 320 280 Q 480 340 640 370 Q 800 400 960 280" stroke="#FFE082" stroke-width="18" fill="none" stroke-linecap="round" stroke-dasharray="10 15"/>
  <path d="M 360 480 Q 520 420 640 370 Q 760 320 920 480" stroke="#FFE082" stroke-width="18" fill="none" stroke-linecap="round" stroke-dasharray="10 15"/>
</svg>"""

# Bölgeler için arka planlar
svg_files[f"{BG_DIR}/bg_ses_ormani.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 720" width="1280" height="720">
  <rect width="1280" height="720" fill="#E8F5E9"/>
  <!-- Ağaçlar -->
  <path d="M -20 720 L -20 450 Q 150 380 320 450 L 320 720 Z" fill="#C8E6C9"/>
  <path d="M 280 720 L 280 430 Q 480 360 680 430 L 680 720 Z" fill="#A5D6A7"/>
  <path d="M 640 720 L 640 460 Q 820 390 1000 460 L 1000 720 Z" fill="#C8E6C9"/>
  <path d="M 950 720 L 950 420 Q 1120 350 1300 420 L 1300 720 Z" fill="#81C784"/>
  <!-- Zemin Çimliği -->
  <path d="M 0 540 Q 640 500 1280 540 L 1280 720 L 0 720 Z" fill="#81C784"/>
</svg>"""

svg_files[f"{BG_DIR}/bg_kelime_koyu.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 720" width="1280" height="720">
  <rect width="1280" height="720" fill="#FFF8E1"/>
  <path d="M 0 560 Q 640 510 1280 560 L 1280 720 L 0 720 Z" fill="#AED581"/>
  <!-- Sevimli Evler -->
  <polygon points="180,440 250,370 320,440" fill="#FF8A65"/>
  <rect x="200" y="440" width="100" height="90" fill="#FFE082" rx="4"/>
  <rect x="235" y="470" width="30" height="60" fill="#8D6E63" rx="4"/>
  <polygon points="980,450 1040,390 1100,450" fill="#BA68C8"/>
  <rect x="1000" y="450" width="80" height="80" fill="#FFF59D" rx="4"/>
  <rect x="1025" y="480" width="30" height="50" fill="#8D6E63" rx="4"/>
</svg>"""

svg_files[f"{BG_DIR}/bg_hece_denizi.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 720" width="1280" height="720">
  <rect width="1280" height="720" fill="#E1F5FE"/>
  <path d="M 0 460 Q 320 430 640 460 T 1280 460 L 1280 720 L 0 720 Z" fill="#4FC3F7"/>
  <path d="M 0 530 Q 320 500 640 530 T 1280 530 L 1280 720 L 0 720 Z" fill="#29B6F6"/>
  <!-- Kumsal -->
  <path d="M 0 620 Q 640 570 1280 620 L 1280 720 L 0 720 Z" fill="#FFE082"/>
</svg>"""

svg_files[f"{BG_DIR}/bg_hikaye_kalesi.svg"] = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 720" width="1280" height="720">
  <rect width="1280" height="720" fill="#EDE7F6"/>
  <path d="M 0 540 Q 640 500 1280 540 L 1280 720 L 0 720 Z" fill="#B39DDB"/>
  <!-- Kale Silüeti -->
  <rect x="520" y="380" width="240" height="150" fill="#D1C4E9" rx="8"/>
  <polygon points="510,380 550,300 590,380" fill="#7E57C2"/>
  <polygon points="690,380 730,300 770,380" fill="#7E57C2"/>
  <rect x="610" y="440" width="60" height="90" rx="30" fill="#5E35B1"/>
</svg>"""

# SVG dosyalarını diske yaz
for path, content in svg_files.items():
    with open(path, "w", encoding="utf-8") as f:
        f.write(content.strip())

print(f"Toplam {len(svg_files)} adet SVG dosyası başarıyla üretildi.")

# ----------------- TÜRKÇE SES DOSYALARI (espeak-ng) -----------------
voice_prompts = {
    "mimi_hosgeldin.wav": "Merhaba! Ben Tavşan Mimi. Haydi kelimeleri bulalım!",
    "mimi_araba_sorusu.wav": "Hangisi araba? Resmi bulup dokun!",
    "mimi_armut_sorusu.wav": "Hangisi armut? Resmi bulup dokun!",
    "mimi_balik_sorusu.wav": "Hangisi balık? Resmi bulup dokun!",
    "mimi_elma_sorusu.wav": "Hangisi elma? Harika gidiyorsun!",
    "mimi_kedi_sorusu.wav": "Hangisi kedi? Miyav diyeni bulalım!",
    "mimi_top_sorusu.wav": "Hangisi top? Yuvarlak olanı bul!",
    "piko_hosgeldin.wav": "Merhaba! Ben Papağan Piko. Söylediğim kelimeyi dinle ve tekrarla!",
    "piko_kayit_basla.wav": "Kırmızı düğmeye bas ve kelimeyi söyle!",
    "piko_harika_kayit.wav": "Çok güzel söyledin! Şimdi dinleyebilirsin.",
    "toto_hosgeldin.wav": "Merhaba! Ben Toto. Heceleri trene doğru sırayla dizelim!",
    "fino_ada_rehberi.wav": "Konuşma Adası'na hoş geldin! Oynamak istediğin yeri seç!",
    # Kelimeler
    "kelime_araba.wav": "Araba",
    "kelime_armut.wav": "Armut",
    "kelime_balik.wav": "Balık",
    "kelime_elma.wav": "Elma",
    "kelime_top.wav": "Top",
    "kelime_kedi.wav": "Kedi",
    "kelime_kopek.wav": "Köpek",
    "kelime_muz.wav": "Muz",
    "kelime_gemi.wav": "Gemi",
    # Heceler
    "hece_a.wav": "A",
    "hece_ra.wav": "Ra",
    "hece_ba.wav": "Ba",
    "hece_ar.wav": "Ar",
    "hece_mut.wav": "Mut",
    "hece_lik.wav": "Lık",
    "hece_el.wav": "El",
    "hece_ma.wav": "Ma",
    "hece_ke.wav": "Ke",
    "hece_di.wav": "Di",
    # Teşvik edici geri bildirimler
    "aferin.wav": "Aferin sana!",
    "harika.wav": "Harika bir iş çıkardın!",
    "cok_guzel.wav": "Çok güzel yaptın!",
    "tebrikler.wav": "Tebrikler, yıldız kazandın!"
}

for filename, text in voice_prompts.items():
    out_path = os.path.join(AUDIO_VOICE_DIR, filename)
    # espeak-ng ile tatlı/dost canlısı Türkçe ses sentezle (-v tr -p 65 -s 135)
    cmd = ["espeak-ng", "-v", "tr", "-p", "65", "-s", "135", text, "-w", out_path]
    subprocess.run(cmd, check=True)

print(f"Toplam {len(voice_prompts)} adet Türkçe seslendirme WAV dosyası üretildi.")
