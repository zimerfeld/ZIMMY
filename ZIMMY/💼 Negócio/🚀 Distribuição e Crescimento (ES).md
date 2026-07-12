---
tipo: negocio
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [referencia, distribuicao, growth, estrategia, investimento, zimmy-pet]
---

# 🚀 Distribución y Crecimiento

> 🇧🇷 Lee esta página en portugués → [[🚀 Distribuição e Crescimento]]
> 🇺🇸 Read this page in English → [[🚀 Distribuição e Crescimento (EN)]]

Análisis con **sesgo de inversor** (potencial × viabilidad × retorno × riesgo) para ampliar la
adopción de Zimmy Pet. Hoy el único canal es **GitHub** (repo + release). Métrica actual en
[[📈 Adoção e Métricas (ES)]]; copy lista en [[📣 Divulgação — Posts (ES)]].

## 🎯 Tesis
Zimmy tiene un **bajo coste marginal de distribución** (binario único de Windows, ~100 MB, sin
servidor) y un **gancho viral** (es visualmente adorable y está en la pantalla todo el día). El producto ya
pasó de «juguete» a «asistente ligero» (programador, cotizaciones, Gmail, alarma), lo que
**amplía el público objetivo** de «a quien le gustan las mascotas virtuales» a «quien quiere productividad
adorable». El retorno no es ingreso directo (es gratis/open source) sino **portafolio + donaciones + parte alta del
embudo** para los demás productos Zimerfeld.

## 📦 P2-2 · Canales de distribución (esfuerzo × retorno)
| Canal | Esfuerzo | Retorno esperado | Riesgo | Veredicto |
|---|---|---|---|---|
| **itch.io** | Bajo (subir el `.exe` + página + 2 GIFs) | **Alto** — SEO propio, público de indie/desktop toys, comunidad de devlogs | Bajo | ✅ **Hacer primero** |
| **Microsoft Store** | Alto (empaquetar MSIX, cuenta de dev de pago, revisión) | Medio (alcance Windows nativo) | Medio (burocracia) | ⏳ Después, si itch.io valida |
| **Reddit** (r/godot, r/DesktopPets, r/windows) | Bajo | Medio-Alto (picos de tráfico) | Bajo (reglas de autopromoción) | ✅ Junto con el lanzamiento |
| **Product Hunt** | Medio (día único, necesita tracción inicial) | Medio | Bajo | ⏳ Guardar p/ un hito (v1.0) |
| **Vídeo corto** (YouTube Shorts/TikTok) | Medio (grabar + editar 20-40 s) | Alto (el formato favorece «cosa adorable en pantalla») | Bajo | ✅ Alto ROI si se puede producir |

### Recomendación (orden)
1. **itch.io** — mayor ROI inmediato; usar los GIFs de las funciones y la copy de [[📣 Divulgação — Posts (ES)]].
2. **Reddit + micro-posts** el mismo día (aprovechar el enlace de itch.io).
3. **Short en vídeo** mostrando al pet diciendo una cotización / sonando la alarma.
4. Microsoft Store y Product Hunt solo después de validar la tracción.

> **Definition of done del P2-2:** página en itch.io publicada con el `.exe` más reciente
> ([[🚀 Export e Publicação (Prod) (ES)]]), 2+ GIFs y la descripción bilingüe; enlace añadido al README.

## 💡 P2-3 · Ideas de producto (validar antes de programar)
Ordenadas por **atractivo × esfuerzo** (mejor relación calidad-precio arriba):
1. ✅ **Clima/tiempo** — **implementado el 2026-07-01** (`Automacoes/clima.gd`): tiempo actual vía
   Open-Meteo (gratis/sin clave), geolocalización por IP con fallback (ipapi.co → ip-api.com) o
   `LAT`/`LON` fijos; dice emoji + descripción bilingüe + temperatura localizada. Ver
   [[⚙️ Sistema - Automações e Agendador (ES)]].
2. ✅ **Recordatorios recurrentes personalizados** — **implementado el 2026-07-02**: submenú
   **⏰ Recordatorios** con diálogo (mensaje + desplegable de frecuencia + hora), persistido en
   `user://reminders.json`, sin editar `.gd`. Ver [[⏰ Sistema - Lembretes (ES)]].
3. **Sonidos/ambiente de humor** — pequeños sonidos opcionales y reacciones por horario. *Medio/bajo.*
4. **Temas estacionales de pet** (Navidad, Halloween…) — gancho de recurrencia y difusión. *Bajo.*
5. **Agenda/Calendario** (Google Calendar) — avisa del próximo evento. *Alto atractivo, alto esfuerzo*
   (OAuth); evaluar después de que Gmail esté consolidado.
6. **Multi-pet en pantalla** al mismo tiempo. *Medio; riesgo de alcance/rendimiento.*

> Antes de implementar cualquiera: registrar aquí la decisión (por qué / esfuerzo estimado) y,
> si es un cambio de comportamiento, actualizar README + este cofre.

Relacionado: [[📣 Divulgação — Posts (ES)]], [[📈 Adoção e Métricas (ES)]], [[🚀 Export e Publicação (Prod) (ES)]], [[🏠 Home (ES)]].
