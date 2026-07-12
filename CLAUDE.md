# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Publicação / Deploy (gitflow)

- **NÃO pedir para criar nem aprovar Pull Requests.** O processo de publicação já
  está estabelecido: baseado em **gitflow com GitHub Actions** que publicam a branch
  `main` em produção — pelo próprio GitHub ou via **wrangler** pelo terminal.
- Fluxo esperado: desenvolver na branch designada, **commitar e fazer push**. Não
  propor, não abrir e não aprovar PR como etapa de aprovação — a publicação acontece
  automaticamente a partir da `main` (Actions/wrangler).
