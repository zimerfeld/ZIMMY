---
tipo: sistema
projeto: ZIMMY
lang: pt-BR
atualizado: 2026-07-04
tags: [sistema, moedas, cotacoes, automacoes, zimmy-pet]
---

# 💱 Sistema - Moedas (cotações)

> 🇺🇸 Read this page in English → [[💱 Sistema - Moedas (EN)]]
> 🇪🇸 Lee esta página en español → [[💱 Sistema - Moedas (ES)]]

Automações que buscam **cotações de moeda** e o Zimmy fala o valor. São scripts normais
da pasta `Automacoes/` que se agrupam num submenu próprio via `const MENU_GROUP := "moedas"`.
Caso especializado de [[⚙️ Sistema - Automações e Agendador]].

## 💱 Submenu 💱 Moedas
Todos os scripts com `MENU_GROUP = "moedas"` são coletados no submenu **💱 Moedas**
(`moedas_menu`), posicionado **no menu principal, logo abaixo de ⚙️ Automações /
⏱️ Temporizadores** (roteamento por grupo em zimmy.gd:1058-1104). Fica **desabilitado**
quando não há nenhuma cotação. Scripts: `cotacao_usd/eur/gbp/jpy/cny.gd`.

## 🚩 Ícones de bandeira — `ICON_FLAG`
Emojis de bandeira **não renderizam** em `PopupMenu` no Windows, então cada item usa uma
**textura de bandeira desenhada em pixel** a partir de `const ICON_FLAG` (`"us"`, `"eu"`,
`"gb"`, `"jp"`, `"cn"`), guardada em `automation_flags` (zimmy.gd:75) e desenhada como
ícone à esquerda do item.

## 🔄 Busca e formatação
Cada cotação usa `zimmy.http_get_json(url, cb)` (zimmy.gd:1633) e, no callback, fala o
resultado com **valores/datas localizados**: `fmt_money_brl(v, casas)` e
`fmt_quote_date("AAAA-MM-DD HH:MM:SS")` (vírgula/ponto e `DD/MM/AAAA` vs `MM/DD/YYYY`
conforme o idioma). As mensagens usam `notify()` (fila de ~5 s), então **várias cotações
disparadas juntas aparecem uma de cada vez** sem se sobreporem. Na *closure* referencie só
`zimmy` e locais (não `self`), para funcionar tanto no clique quanto no disparo agendado.

## ⏱️ Agendamento (opcional)
Uma cotação que também declarar `SCHEDULE`/`SCHEDULE_SECONDS` aparece **adicionalmente** em
**⏱️ Temporizadores** e pode ser atualizada sozinha — mecânica do
[[⚙️ Sistema - Automações e Agendador]].

Relacionado: [[💬 Sistema - Balão de Fala]], [[🚪 Entrada - Itens do Menu]], [[🏠 Home]].
