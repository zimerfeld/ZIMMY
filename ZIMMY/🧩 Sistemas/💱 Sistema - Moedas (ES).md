---
tipo: sistema
projeto: ZIMMY
lang: es-ES
atualizado: 2026-07-04
tags: [sistema, moedas, cotacoes, automacoes, zimmy-pet]
---

# 💱 Sistema - Monedas (cotizaciones)

> 🇧🇷 Lee esta página en portugués → [[💱 Sistema - Moedas]]
> 🇺🇸 Read this page in English → [[💱 Sistema - Moedas (EN)]]

Automatizaciones que buscan **cotizaciones de moneda** y hacen que Zimmy diga el valor. Son
scripts normales de la carpeta `Automacoes/` que se agrupan en un submenú propio vía
`const MENU_GROUP := "moedas"`. Caso especializado de
[[⚙️ Sistema - Automações e Agendador (ES)]].

## 💱 Submenú 💱 Monedas
Todos los scripts con `MENU_GROUP = "moedas"` se recogen en el submenú **💱 Monedas**
(`moedas_menu`), situado **en el menú principal, justo debajo de ⚙️ Automatizaciones /
⏱️ Temporizadores** (enrutamiento por grupo en zimmy.gd:1058-1104). Queda **deshabilitado**
cuando no hay ninguna cotización. Scripts: `cotacao_usd/eur/gbp/jpy/cny.gd`.

## 🚩 Iconos de bandera — `ICON_FLAG`
Los emojis de bandera **no se renderizan** en `PopupMenu` en Windows, así que cada elemento
usa una **textura de bandera dibujada en píxeles** a partir de `const ICON_FLAG` (`"us"`,
`"eu"`, `"gb"`, `"jp"`, `"cn"`), guardada en `automation_flags` (zimmy.gd:75) y dibujada como
icono a la izquierda del elemento.

## 🔄 Búsqueda y formato
Cada cotización usa `zimmy.http_get_json(url, cb)` (zimmy.gd:1633) y, en el callback, dice el
resultado con **valores/fechas localizados**: `fmt_money_brl(v, decimales)` y
`fmt_quote_date("AAAA-MM-DD HH:MM:SS")` (coma/punto y `DD/MM/AAAA` vs `MM/DD/YYYY`
según el idioma). Los mensajes usan `notify()` (cola de ~5 s), así que **varias cotizaciones
disparadas juntas aparecen una a una** sin solaparse. En la *closure* referencia solo
`zimmy` y locales (no `self`), para que funcione tanto en el clic como en el disparo programado.

## ⏱️ Programación (opcional)
Una cotización que además declare `SCHEDULE`/`SCHEDULE_SECONDS` aparece **adicionalmente** en
**⏱️ Temporizadores** y puede actualizarse sola — mecánica del
[[⚙️ Sistema - Automações e Agendador (ES)]].

Relacionado: [[💬 Sistema - Balão de Fala (ES)]], [[🚪 Entrada - Itens do Menu (ES)]], [[🏠 Home (ES)]].
