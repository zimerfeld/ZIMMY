---
tipo: meta
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [meta, zimmy-pet]
---

# 🧭 Como usar este cofre

> 🇧🇷 Lee esta página en portugués → [[🧭 Como usar este cofre]]
> 🇺🇸 Read this page in English → [[🧭 Como usar este cofre (EN)]]

> Para **retomar el trabajo**, ver [[📌 Backlog (ES)]] (prioridades P0/P1/P2).

Este cofre Obsidian es la **memoria técnica** del proyecto Zimmy Pet, creada y mantenida
por Claude. Está en `C:\GODOT\ZIMMY\ZIMMY`.

## 📐 Convenciones
- **Una idea por nota**, con frontmatter estándar (`tipo`, `projeto`, `lang`, `atualizado`, `tags`).
- Las notas empiezan con **emoji + prefijo de categoría**: `🐾 Sistema - …`,
  `🎲 Fluxo - …`, `🚪 Entrada - …`, `📄 Arquivo - …`.
- **Iconos (emoji) por todas partes:** cada nota lleva el mismo emoji temático en **tres
  lugares** — en el **nombre del archivo** (aparece en el árbol), en el **título `#`** y en **cada
  subtítulo `##`** (este último elegido según el contenido de la sección). Las **carpetas** también
  tienen emoji-prefijo; el orden en el panel lo define el `sortspec.md` en la raíz (plugin
  **custom-sort**), por **prioridad**: `🔑 Arquivos-Chave` (impacto) → `🧩 Sistemas`
  (reutilización) → `🔀 Fluxos` (uso) → `🚀 Operação` → `🚪 Pontos de Entrada` →
  `📚 Conhecimento` → `💼 Negócio` → `🧭 Meta`.
- **Par bilingüe:** cada nota PT `<emoji> Nome.md` tiene un par `<emoji> Nome (EN).md`
  (traducción completa al inglés-US). Las notas PT enlazan nombres PT; las notas EN enlazan los pares `(EN)`.
- **Enlazar con generosidad** con `[[wikilinks]]`. El hub es [[🏠 Home (ES)]]. Los `[[links]]` usan
  el **nombre-base** (con el emoji); mover la nota entre carpetas no rompe el enlace, pero
  **renombrar el archivo sí** — al renombrar, actualiza los wikilinks a la vez (PT y EN).
- Las referencias a código usan `archivo:línea` (ej.: `zimmy.gd:546`) — las líneas pueden
  cambiar; confirma antes de fiarte.
- Idioma-base del cofre en **portugués** (preferencia del autor, Renato Zimerfeld), con
  espejo íntegro en inglés en los pares `(EN)`.

## 🏠 Qué vive aquí
- **🔑 Arquivos-Chave**: una nota por archivo importante del repo (gran impacto si se manipula).
- **🧩 Sistemas**: subsistemas lógicos de la app (el qué y el porqué), reutilizados por varias partes.
- **🔀 Fluxos**: secuencias de ejecución (`_ready`, `_process`, guardar/cargar…).
- **🚀 Operação**: runbooks — ejecutar en el editor (Dev) y exportar/publicar el `.exe` (Prod).
- **🚪 Pontos de Entrada**: la superficie de interacción de la app — como esto es
  un overlay de escritorio (no un servidor web), los "endpoints" son los **eventos de
  input**, los **ítems de menú** y las **funciones de acción** públicas.
- **📚 Conhecimento**: repositorio/ramas y glosario de configs.
- **💼 Negócio**: adopción/métricas, divulgación, distribución, itch.io, financiación.
- **🧭 Meta**: esta nota (cómo usar el cofre).

## 🧹 Mantenimiento
Al cambiar el comportamiento de la app, actualizar la nota de sistema/flujo afectada **y** el
[[📄 Arquivo - README (ES)]] correspondiente (el README es la fuente de la verdad; el cofre lo
refleja). Convertir fechas relativas en absolutas. Mantener el par `(EN)` sincronizado.

> Origen: cofre solicitado el 2026-06-20, poblado a partir del estado actual de
> [[📄 zimmy.gd (ES)]] (rama `feature/aleatorios`). Reestructurado al patrón
> "Cofre de Neuronas v2" el 2026-07-04.
</content>
