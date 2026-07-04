---
tipo: negocio
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [referencia, distribuicao, growth, estrategia, investimento, zimmy-pet]
---

# 🚀 Distribution and Growth

Analysis with an **investor lens** (potential × feasibility × return × risk) to expand
Zimmy Pet's adoption. Today the only channel is **GitHub** (repo + release). Current metric in
[[📈 Adoção e Métricas (EN)|Adoption & Metrics]]; ready copy in
[[📣 Divulgação — Posts (EN)|Promo Posts]].

## 🎯 Thesis
Zimmy has a **low marginal distribution cost** (a single Windows binary, ~100 MB, no server)
and a **viral hook** (it's visually cute and stays on screen all day). The product has already
moved from "toy" to "light assistant" (scheduler, quotes, Gmail, alarm), which **widens the
target audience** from "people who like virtual pets" to "people who want cute productivity".
The return is not direct revenue (it's free/open source) but rather **portfolio + donations +
top of funnel** for the other Zimerfeld products.

## 📦 P2-2 · Distribution channels (effort × return)
| Channel | Effort | Expected return | Risk | Verdict |
|---|---|---|---|---|
| **itch.io** | Low (upload the `.exe` + page + 2 GIFs) | **High** — own SEO, indie/desktop-toy audience, devlog community | Low | ✅ **Do first** |
| **Microsoft Store** | High (package MSIX, paid dev account, review) | Medium (native Windows reach) | Medium (bureaucracy) | ⏳ Later, if itch.io validates |
| **Reddit** (r/godot, r/DesktopPets, r/windows) | Low | Medium-High (traffic spikes) | Low (self-promo rules) | ✅ Alongside launch |
| **Product Hunt** | Medium (single day, needs initial traction) | Medium | Low | ⏳ Save for a milestone (v1.0) |
| **Short video** (YouTube Shorts/TikTok) | Medium (record + edit 20-40 s) | High (format favors "cute thing on screen") | Low | ✅ High ROI if producible |

### Recommendation (order)
1. **itch.io** — highest immediate ROI; use the feature GIFs and the copy from [[📣 Divulgação — Posts (EN)|Promo Posts]].
2. **Reddit + micro-posts** on the same day (leverage the itch.io link).
3. **Video short** showing the pet speaking a quote / ringing an alarm.
4. Microsoft Store and Product Hunt only after validating traction.

> **Definition of done for P2-2:** itch.io page published with the latest `.exe`
> ([[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]]), 2+ GIFs and the bilingual
> description; link added to the README.

## 💡 P2-3 · Product ideas (validate before coding)
Sorted by **appeal × effort** (bang-for-buck at the top):
1. ✅ **Weather** — **implemented on 2026-07-01** (`Automacoes/clima.gd`): current weather via
   Open-Meteo (free/no key), IP geolocation with fallback (ipapi.co → ip-api.com) or fixed
   `LAT`/`LON`; speaks emoji + bilingual description + localized temperature. See
   [[⚙️ Sistema - Automações e Agendador (EN)|Automations & Scheduler system]].
2. ✅ **Custom recurring reminders** — **implemented on 2026-07-02**: **⏰ Reminders** submenu
   with a dialog (message + frequency dropdown + time), persisted in `user://reminders.json`,
   without editing `.gd`. See [[⏰ Sistema - Lembretes (EN)|Reminders system]].
3. **Ambient sounds/mood** — small optional sounds and time-of-day reactions. *Medium/low.*
4. **Seasonal pet themes** (Christmas, Halloween…) — a recurrence and promo hook. *Low.*
5. **Agenda/Calendar** (Google Calendar) — warns about the next event. *High appeal, high effort*
   (OAuth); evaluate after Gmail is consolidated.
6. **Multi-pet on screen** at once. *Medium; scope/perf risk.*

> Before implementing any of them: record the decision here (why / estimated effort) and,
> if it's a behavior change, update the README + this vault.

Related: [[📣 Divulgação — Posts (EN)|Promo Posts]], [[📈 Adoção e Métricas (EN)|Adoption & Metrics]],
[[🚀 Export e Publicação (Prod) (EN)|Export and Publishing]], [[🏠 Home (EN)|Home]].
