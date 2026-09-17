---
title: Estándares de ingeniería (índice — 6 prácticas)
owner: Platform Team
status: review
diataxis_type: reference
last_review: 2026-09-08
review_cadence: quarterly
audience: internal
source_of_truth: docs/process/engineering-standards.md
---

# Estándares de ingeniería — 6 prácticas

Índice local de las prácticas de ingeniería de HabitaNexus. Cada fila enlaza a la
referencia vendida en este repo (SSOT local). Las copias completas de protocolo
viven en `docs/process/`; los satellites no duplican este texto.

| Sigla | Nombre | Alcance | SSOT local |
| --- | --- | --- | --- |
| **DSMS** | Domain-Sliced Module Structure | Dónde viven los archivos | [`code-organization-standards.md`](code-organization-standards.md) §1 |
| **IFS** | Intra-File Structure | Cómo un archivo se lee de arriba a abajo | [`code-organization-standards.md`](code-organization-standards.md) §2 |
| **CPS** | Categorized Public Surface | Cómo exportan los barrels públicos | [`code-organization-standards.md`](code-organization-standards.md) §3 |
| **PRDS** | Pull Request Description Standards | Cuerpo del PR + tamaño revisable | [`pull-request-description-and-scope.md`](pull-request-description-and-scope.md) |
| **BrS** | Branching Strategy | Ramas, nombres, protección | [`branching.md`](../branching.md) |
| **QT4L** | QA Traceability (four layers) | Req → test automatizado → QA manual → HITL | [`qa-traceability.md`](qa-traceability.md) |

El **clean code quartet** es DSMS + IFS + CPS + PRDS. BrS y QT4L completan la
familia de seis prácticas para branching y trazabilidad QA.

**Orden de adopción:** DSMS → IFS → CPS → PRDS → BrS → QT4L.

**Prioridad día a día:** IFS, PRDS y QT4L (ritmo de lectura, ritmo de review,
trazabilidad req→test).

## Política de adopción

- **Incremental solo** — aplicar al añadir o editar materialmente código en esa
  área. Sin refactors masivos de legacy por cumplimiento.
- **Satellite repos** — el `AGENTS.md` de cada satellite enlaza aquí; no duplicar
  el texto completo en apps/packages.
- **No es licencia de refactor** — adoptar estándares no autoriza mover carpetas
  o reescribir barrels fuera de scope.

## Obligatorio antes de abrir un PR

1. Leer `AGENTS.md` (bloque *Estándares de Ingeniería*).
2. Seguir PRDS para la descripción del PR.
3. Si el cambio altera comportamiento (delta de living spec OpenSpec), incluir la
   sección **QA traceability (four layers)** en `tasks.md` — ver
   [`qa-traceability.md`](qa-traceability.md).