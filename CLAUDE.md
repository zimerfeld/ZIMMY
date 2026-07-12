# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Idioma da conversa

- **Responder sempre no chat em português (Brasil).** Todas as respostas ao
  usuário devem ser em pt-BR, independentemente do idioma do pedido ou do código.

## Paridade de idiomas (PT / EN / ES)

- **Manter sempre a paridade entre os três idiomas — Português (pt-BR), Inglês
  (en-US) e Espanhol (es-ES).** Ao criar ou alterar qualquer texto localizável,
  **criar/atualizar a tradução nos três idiomas na mesma mudança**, sem deixar
  nenhum idioma para trás. Isso vale para: textos de UI e falas (`STRINGS` /
  `STRING_LISTS` em `zimmy.gd`), automações (`AUTOMATION_NAME[_EN|_ES]` e o 3º
  argumento `es` de `lang_text`), os `README.*` e as notas do cofre Obsidian
  (versões base PT, `(EN)` e `(ES)`, com os links de troca de idioma).

## Seletor / pílula de idioma (UI)

- **A pílula (toggle) de idioma deve sempre exibir as opções `AUTO`, `PT`, `EN` e
  `ES`, nessa ordem, com `AUTO` pré-selecionado por padrão.** `AUTO` detecta o idioma
  automaticamente (idioma do navegador/sistema); `PT` / `EN` / `ES` fixam o idioma
  escolhido. Vale para a landing (`index.html`) e para qualquer seletor de idioma da UI.

## Publicação / Deploy (gitflow)

- **NÃO pedir para criar nem aprovar Pull Requests.** O processo de publicação já
  está estabelecido: baseado em **gitflow com GitHub Actions** que publicam a branch
  `main` em produção — pelo próprio GitHub ou via **wrangler** pelo terminal.
- Fluxo esperado: desenvolver na branch designada, **commitar e fazer push**. Não
  propor, não abrir e não aprovar PR como etapa de aprovação — a publicação acontece
  automaticamente a partir da `main` (Actions/wrangler).

## Sincronização de branches (gitflow)

- **Após publicar na `main`, sincronizar a `develop` com a `main`** (fast-forward)
  para que as duas **não divirjam**.
- **Iniciar cada nova demanda em uma feature branch criada a partir da `develop`**,
  com **nome sugestivo** à demanda (ex.: `feature/<descricao-curta>`).
