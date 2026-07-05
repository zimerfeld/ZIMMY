---
tipo: sistema
projeto: ZIMMY
lang: en-US
atualizado: 2026-07-04
tags: [sistema, moedas, cotacoes, automacoes, zimmy-pet]
---

# 💱 System - Currencies (quotes)

Automations that fetch **currency quotes** and have Zimmy speak the value. They are regular
scripts in the `Automacoes/` folder that group into their own submenu via
`const MENU_GROUP := "moedas"`. A specialized case of
[[⚙️ Sistema - Automações e Agendador (EN)]].

## 💱 Currencies submenu
All scripts with `MENU_GROUP = "moedas"` are collected in the **💱 Currencies** submenu
(`moedas_menu`), placed **in the main menu, right below ⚙️ Automations / ⏱️ Timers**
(group routing at zimmy.gd:1058-1104). It is **disabled** when there are no quotes.
Scripts: `cotacao_usd/eur/gbp/jpy/cny.gd`.

## 🚩 Flag icons — `ICON_FLAG`
Flag emoji **don't render** in `PopupMenu` on Windows, so each item uses a **pixel-drawn
flag texture** from `const ICON_FLAG` (`"us"`, `"eu"`, `"gb"`, `"jp"`, `"cn"`), stored in
`automation_flags` (zimmy.gd:75) and drawn as the item's left icon.

## 🔄 Fetch and formatting
Each quote uses `zimmy.http_get_json(url, cb)` (zimmy.gd:1633) and, in the callback, speaks
the result with **localized values/dates**: `fmt_money_brl(v, decimals)` and
`fmt_quote_date("YYYY-MM-DD HH:MM:SS")` (comma/dot and `DD/MM/YYYY` vs `MM/DD/YYYY` per
language). Messages use `notify()` (~5 s queue), so **several quotes fired together appear
one at a time** without overlapping. In the closure reference only `zimmy` and locals (not
`self`), so it works both on click and on scheduled firing.

## ⏱️ Scheduling (optional)
A quote that also declares `SCHEDULE`/`SCHEDULE_SECONDS` **additionally** shows up under
**⏱️ Timers** and can refresh by itself — mechanics of
[[⚙️ Sistema - Automações e Agendador (EN)]].

Related: [[💬 Sistema - Balão de Fala (EN)]], [[🚪 Entrada - Itens do Menu (EN)]], [[🏠 Home (EN)]].
