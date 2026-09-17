---
title: Trazabilidad QA — cuatro capas (QT4L)
owner: Platform Team
status: review
diataxis_type: reference
last_review: 2026-09-08
review_cadence: quarterly
audience: internal
source_of_truth: docs/process/qa-traceability.md
---

# QA Traceability — four layers (QT4L)

> Adaptado del estándar `qa-traceability-four-layers.md` (Seacrets.Online) y de la
> doctrina HITL del monorepo HabitaNexus. Define el **contrato de trazabilidad**:
> cómo todo cambio que altera comportamiento mapea requisitos normativos a pruebas
> automatizadas, QA manual de stage y rondas HITL — sin Gherkin/Behat/cucumber como
> SSOT de ejecución.

## Cuándo es obligatorio

| Tipo de cambio | Sección QA en `tasks.md` | Tabla scenario → verificación |
| --- | --- | --- |
| Delta de living spec (`skip_specs: false`) | **Obligatoria** | **Obligatoria** — una fila por `#### Scenario:` |
| Decision record / infra / docs-only (`skip_specs: true`) | Puntero opcional | No requerida |
| Hotfix sin cambio de spec | N/A | Usar SOP de dominio + tests existentes |

Todo cambio nuevo bajo `openspec/changes/` con delta de living spec **debe**
incluir la sección siguiente en `tasks.md` desde el momento de **propose**, no
solo al archivar.

## Cuatro capas (veredicto)

| Capa | Rol | SSOT | Ejecutor |
| --- | --- | --- | --- |
| **1 — AC normativos** | SHALL / WHEN / THEN | `specs/<capability>/spec.md` | Review de ingeniería; `openspec validate` |
| **2 — QA manual de stage** | Checklist reproducible en stage | SOP de dominio (§7) + herramienta de casos | QA Lead (asignado) |
| **3 — Automatizada** | Regresión en CI | `tests/` del satélite → JUnit/XML → runner CI | CI del release/smoke |
| **4 — Ronda HITL** | Verificación ingeniería 0→main con evidencia | `docs/qa/rounds/<domain>-<date>/round.md` | Ronda HITL |

**No es una quinta capa:** `compliance/gherkin/*.feature` — export opcional
human-readable para compliance, **nunca** cableado a Behat/cucumber ni a la
ronda HITL.

## Sección `tasks.md` (copiar en todo cambio de comportamiento)

Colocar tras las tareas de implementación, antes del handoff.

```markdown
## QA traceability (four layers)

SSOT: `reference/process/qa-traceability-four-layers.md`

| Capa | Artifacto |
| --- | --- |
| 1 — AC normativos | `specs/<capability>/spec.md` (este cambio) |
| 2 — QA manual de stage | `<path-al-sop-de-dominio>` §… |
| 3 — Automatizada | `<satélite>/tests/…` (tabla abajo) |
| 4 — Ronda HITL | `docs/qa/rounds/<domain>-<date>/round.md` |

### Mapeo scenario → verificación

| Scenario de OpenSpec | Test automatizado | Manual (SOP / Kiwi) | Caso HITL ID | Storybook (solo UI) |
| --- | --- | --- | --- | --- |
| `<Scenario del spec.md>` | `Class::method` o `(pending N)` | SOP §… bullet | `<DOM>-…` | `Story/name` o — |

Reglas:

- Una fila por `#### Scenario:` del delta de spec (renombrar el scenario al
  título exacto del spec).
- **Automated:** Unit para servicios de dominio; Feature/integration para
  contratos HTTP; Browser/WebDriver solo cuando la UI no puede probarse de otra
  forma.
- **Storybook:** solo estados visuales — no tests funcionales.
- **Caso HITL ID:** id estable usado en `round.md` (prefijo de dominio + número);
  copiar esta tabla en la sección **Traceability** de la ronda.
- **Pending:** permitido hasta que la tarea vinculada entregue; marcar `[x]` al
  completar.

### Handoff

- [ ] Casos manuales desde SOP
- [ ] Ronda HITL con `round.md` traceability pegada de esta tabla
```

## Checklist del agente (propose + apply)

- [ ] Cambio de comportamiento tiene delta `specs/` con bloques `#### Scenario:`
- [ ] `tasks.md` incluye **QA traceability (four layers)** y la tabla de mapeo
- [ ] SOP de dominio actualizado o ticket abierto para checklist §7 si es user-facing
- [ ] Tests nombrados en la tabla aterrizan en el PR de la app (o `(pending)` con id de tarea)
- [ ] Sin `compliance/gherkin/*.feature` nuevos salvo export explícito de compliance (no CI); sin Behat/cucumber runners

Referencia completa de los estándares: [`engineering-standards.md`](engineering-standards.md).