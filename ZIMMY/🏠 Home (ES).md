---
tipo: moc
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-06
tags: [moc, home, zimmy-pet]
---

# 🏠 ZIMMY — Cofre de Neuronas

> 🇧🇷 Lee esta página en portugués → [[🏠 Home]]
> 🇺🇸 Read this page in English → [[🏠 Home (EN)]]

> [!abstract] 🧠 Qué es este cofre
> Memoria persistente de Claude para el proyecto **ZIMMY (Zimmy Pet)**. Una *mascota de escritorio*
> procedural en Godot 4 que además se convirtió en un asistente ligero. Este cofre lo mantiene
> Claude y **refleja el README** (fuente de la verdad); al cambiar el comportamiento, se actualiza
> la nota afectada y el README a la vez.
> Está en `C:\GODOT\ZIMMY\ZIMMY` — la carpeta del cofre se renombró de `OBSIDIAN/` al
> nombre del proyecto (`ZIMMY/`). Ver [[🧭 Como usar este cofre (ES)]].

## ⚡ Resumen ejecutivo
- **Qué es:** mascota de escritorio gratuita y **de código abierto** para Windows — ventana overlay
  transparente, sin bordes, siempre encima; todo **dibujado en código** (`_draw()` procedural,
  sin sprites), así que cada mascota es única.
- **Problema que resuelve:** compañía adorable en la pantalla + pequeñas utilidades del día a día sin
  abrir apps pesadas.
- **Diferenciales:** asistente ligero integrado — agendador visual, cotizaciones, clima, Gmail,
  alarma/recordatorios; **extensible** (suelta un `.gd` en `Automacoes/`); **bilingüe** (PT/EN).
- **Stack:** Godot **4.6.2** stable, GDScript; toda la app en [[📄 zimmy.gd (ES)]] adjuntada a
  [[📄 main.tscn (ES)]]. Sin dependencias externas más allá de la API de Godot.
- **Estado actual:** rama `develop`; último lote entregado — **reacciones al ratón** (hover →
  expresión; clic en el ojo → se cierra hasta que salgas; sacudir el ratón → mareo/náusea/susto),
  **sonidos por grupo** (variaciones aleatorias en Alimentar/Cariño/Jugar), **fuegos
  artificiales** en la celebración de la hora en punto, y la **cola de habla** unificada (reacciones
  inmediatas + notificaciones de 10 s con adelantamiento de cola por acción del usuario y descarte tras 60 s).
  Eliminada la automatización de auto-alimentar (20 s). Release `.exe` (~100 MB) exportable
  ([[🚀 Export e Publicação (Prod) (ES)]]).
- **Público:** entusiastas de mascotas virtuales + quienes quieren "productividad adorable" en el escritorio.
- **Ángulo de negocio:** gratis/OSS → retorno indirecto (portafolio + parte alta del embudo +
  donaciones/patrocinio). Ver [[💜 Financiamento e Patrocínio (ES)]] y [[🚀 Distribuição e Crescimento (ES)]].

## 🧭 Navegación por prioridad

### 1️⃣ 🔑 Impacto — Archivos Clave
> Archivos que, si se manipulan, tienen gran impacto en el sistema.
- [[📄 zimmy.gd (ES)]] — la app entera (~908 líneas útiles, `_draw()` procedural); tocar aquí cambia todo.
- [[📄 project.godot (ES)]] — config del overlay (transparencia, borderless, always-on-top, renderer OpenGL).
- [[📄 main.tscn (ES)]] — escena raíz que instancia el `zimmy.gd`.
- [[📄 export_presets.cfg (ES)]] — preset del `.exe` (Windows Desktop, `embed_pck`, icono, excluye `tools/*`).
- [[📄 tools - make_icon.py (ES)]] — genera `icon.png` + `zimmy.ico`.
- [[📄 Arquivo - README (ES)]] — documentación y **fuente de la verdad** de los hechos del proyecto.

### 2️⃣ 🧩 Reutilización — Sistemas
> Subsistemas reutilizados por varias partes del proyecto.
- [[🪟 Sistema - Janela Overlay (ES)]] — la ventana transparente/sin bordes/always-on-top y el `_relayout`.
- [[🎨 Sistema - Render (_draw) (ES)]] — dibujo procedural de la mascota (sin sprites).
- [[✨ Sistema - Animação (ES)]] — respiración, parpadeo, salto, seguir el cursor.
- [[🐾 Sistema - Pets (ES)]] — config predeterminada/aleatoria de cada mascota.
- [[🎀 Sistema - Acessórios (ES)]] — accesorios sobre la mascota.
- [[😶‍🌫️ Sistema - Expressões Faciais (ES)]] — rostros/expresiones.
- [[😤 Sistema - Interação e Mau Humor (ES)]] — reacción al toque, humor.
- [[📊 Sistema - Necessidades (ES)]] — hambre/humor a lo largo del tiempo.
- [[💬 Sistema - Balão de Fala (ES)]] — globo dinámico de habla.
- [[🧭 Sistema - Menu de Contexto (ES)]] — el menú de clic derecho y sus submenús.
- [[⚙️ Sistema - Automações e Agendador (ES)]] — `Automacoes/`, ⚙️ Automatizaciones + ⏱️ Temporizadores.
- [[⏰ Sistema - Lembretes (ES)]] — submenú ⏰ Recordatorios recurrentes del usuario.
- [[💱 Sistema - Moedas (ES)]] — cotizaciones USD/EUR/GBP/JPY/CNY.
- [[📧 Sistema - E-mails (ES)]] — Gmail (contador de no leídos + sonido).
- [[💾 Sistema - Persistência (ES)]] — grabación/lectura de estado en `user://`.

### 3️⃣ 🔀 Uso — Flujos
> Flujos de uso paso a paso.
- [[🟢 Fluxo - Inicialização (ES)]] — `_ready`, refuerzo de las flags del overlay.
- [[🔁 Fluxo - Loop (_process) (ES)]] — el bucle por frame.
- [[🖱️ Fluxo - Arrastar e Posição (ES)]] — arrastrar la mascota y calcular la posición.
- [[😼 Fluxo - Interação e Limites (ES)]] — tocar y límites de pantalla.
- [[💾 Fluxo - Salvar e Carregar (ES)]] — persistir y restaurar.
- [[🎲 Fluxo - Geração Aleatória (ES)]] — mascota/config aleatorios.

## 🚀 Operación
- [[💻 Rodar no Editor (Dev) (ES)]] — abrir/ejecutar en el editor de Godot (F5) durante el desarrollo.
- [[🚀 Export e Publicação (Prod) (ES)]] — export headless del `build/ZimmyPet.exe` + publicar.

## 🚪 Puntos de Entrada
> Como esto es un overlay de escritorio (no un servidor web), la superficie de interacción son
> los eventos de input, los ítems de menú y las funciones de acción.
- [[🚪 Entrada - Eventos de Input (ES)]] — ratón/teclado.
- [[🚪 Entrada - Itens do Menu (ES)]] — las entradas del menú de contexto.
- [[🚪 Entrada - Funções de Ação (ES)]] — funciones públicas accionadas por el menú.

## 📚 Conocimiento
- [[📚 Repositório e Branches (ES)]] — repo, ramas y flujo GitFlow.
- [[🗂️ Glossário de Configs (ES)]] — glosario de las claves de configuración.

## 💼 Negocio
- [[🚀 Distribuição e Crescimento (ES)]] — canales e ideas de producto (con visión de inversor).
- [[💜 Financiamento e Patrocínio (ES)]] — GitHub Sponsors `zimerfeld` + Ko-fi `C0D621FCGD` + badges.
- [[📈 Adoção e Métricas (ES)]] — recuento de clones/descargas.
- [[🎮 itch.io — Página (ES)]] — página lista para pegar (metadatos + descripción bilingüe).
- [[📣 Divulgação — Posts (ES)]] — copy bilingüe listo para publicar.

## 🧭 Meta
- [[🧭 Como usar este cofre (ES)]] — convenciones, estructura y mantenimiento del cofre.

## 📌 Retomar
- [[📌 Backlog (ES)]] — **empieza por aquí** al retomar el proyecto en otra sesión.

## ⚖️ Licencia
- **CC BY-NC-ND 4.0** (Creative Commons Atribución-NoComercial-SinDerivadas 4.0 Internacional) · © 2026 Renato Zimerfeld — compartición no comercial con atribución; **sin uso comercial** y **sin derivadas**. Fuente de la verdad: `LICENSE.md` en la raíz; nombrada en los READMEs (`README.md`, `README.en-US.md`, `README.pt-BR.md`). Nota histórica: el commit `1013cf8` eliminó el LICENSE, que fue **readañadido** — el estado actual es CC BY-NC-ND 4.0.
</content>
</invoke>
