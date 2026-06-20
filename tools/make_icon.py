"""Gera o ícone do Zimmy (PNG + ICO) reproduzindo o desenho procedural de zimmy.gd.

Renderiza em alta resolucao com supersampling e exporta:
  - icon.png  (1024x1024, para o editor Godot)
  - zimmy.ico (multi-size, para o .exe do Windows)
"""
from PIL import Image, ImageDraw
import os

# Espaco logico original do pet e 200x200; aqui ampliamos e centralizamos.
SS = 2048                      # canvas de render (supersampling)
SCALE = 6.144                  # 5.12 * 1.2 (zoom para preencher o quadro)
OFFX = SS * (-102.0 / 1024.0) * 2  # nao usado diretamente; transform abaixo
# transform 200-space -> render-space
def T(x, y):
    return ((x * SCALE) - 102.0 * (SS / 1024.0), (y * SCALE) - 148.0 * (SS / 1024.0))

# como o offset acima foi calibrado para 1024, escalamos para SS:
K = SS / 1024.0
def t(x, y):
    return (x * SCALE * K - 102.0 * K, y * SCALE * K - 148.0 * K)

img = Image.new("RGBA", (SS, SS), (0, 0, 0, 0))
d = ImageDraw.Draw(img)

def hx(s):
    s = s.lstrip("#")
    return tuple(int(s[i:i+2], 16) for i in (0, 2, 4))

def ellipse(cx, cy, rx, ry, color):
    a = t(cx - rx, cy - ry)
    b = t(cx + rx, cy + ry)
    d.ellipse([a[0], a[1], b[0], b[1]], fill=color)

def circle(cx, cy, r, color):
    ellipse(cx, cy, r, r, color)

INK = hx("3a2418")

# Sombra suave no chao
sa = t(100 - 46, 174 - 8)
sb = t(100 + 46, 174 + 8)
d.ellipse([sa[0], sa[1], sb[0], sb[1]], fill=(0, 0, 0, 28))

# Orelhas (levemente acima do corpo para aparecerem no icone)
ellipse(66, 74, 14, 27, hx("d8703a"))
ellipse(134, 74, 14, 27, hx("d8703a"))

# Corpo + barriga
ellipse(100, 108, 58, 56, hx("e88a4d"))
ellipse(100, 118, 40, 34, hx("f2c9a8"))

# Bochechas
ellipse(70, 116, 9, 5, (242, 161, 161, 170))
ellipse(130, 116, 9, 5, (242, 161, 161, 170))

# Olhos (abertos, felizes) com pupilas e brilho
ellipse(82, 96, 10, 12, (255, 255, 255, 255))
ellipse(118, 96, 10, 12, (255, 255, 255, 255))
circle(84, 98, 5.5, INK)
circle(120, 98, 5.5, INK)
circle(86, 95, 1.8, (255, 255, 255, 255))
circle(122, 95, 1.8, (255, 255, 255, 255))

# Boca: sorriso feliz (arco inferior de uma elipse = U)
ma = t(100 - 13, 112 - 9)
mb = t(100 + 13, 112 + 11)
d.arc([ma[0], ma[1], mb[0], mb[1]], start=20, end=160,
      fill=INK, width=max(1, int(2.5 * SCALE * K * 0.45)))

# Downscale e exporta
os.makedirs(os.path.dirname(__file__), exist_ok=True)
proj = os.path.dirname(os.path.dirname(__file__))

png1024 = img.resize((1024, 1024), Image.LANCZOS)
png1024.save(os.path.join(proj, "icon.png"))

# ICO com multiplos tamanhos
sizes = [16, 24, 32, 48, 64, 128, 256]
png1024.save(os.path.join(proj, "zimmy.ico"),
             sizes=[(s, s) for s in sizes])

print("OK: icon.png + zimmy.ico gerados em", proj)
