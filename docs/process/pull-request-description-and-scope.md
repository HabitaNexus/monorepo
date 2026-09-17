---
title: Estándares de descripción y alcance de Pull Requests (PRDS)
owner: Platform Team
status: review
diataxis_type: reference
last_review: 2026-09-07
review_cadence: quarterly
audience: internal
source_of_truth: docs/process/pull-request-description-and-scope.md
---

# Pull Request Description Standards (PRDS)

> **PRDS** — *Pull Request Description Standards*. Referencia sobre **qué** va en la
> descripción de un PR de HabitaNexus y **qué tan grande** debe ser un PR para que un
> revisor humano lo apruebe con confianza. Complementa a los
> [estándares de organización de código (DSMS, IFS, CPS)](code-organization-standards.md)
> y forma la cuarta buena práctica junto a ellos.

## PRDS — Propósito

Los PRs de HabitaNexus son **human-in-the-loop (HITL)**. Un revisor debe entender el
cambio, confiar en el plan de pruebas y detectar scope creep sin releer cada línea de
un diff gigante.

| Rol | Default |
| --- | --- |
| Assignee | `lapc506` (Andrés Peña) en cada PR |
| Reviewer | El owner del área del cambio cuando el autor no es Andrés |
| Merge | Solo tras aprobación de un revisor humano — los agentes nunca usan `gh pr merge --admin` sin que se lo pidan |

**Agentes y subagentes** deben facilitar la revisión: diffs acotados, descripciones
explícitas, evidencia para UI/ops, y enlaces al issue Linear dueño. La descripción
del PR es parte del entregable — no una ocurrencia tardía.

---

## PRDS — Template de descripción

Copia este bloque en el cuerpo de cada PR de HabitaNexus (o usa el
`.github/PULL_REQUEST_TEMPLATE.md` del repo que lo refleja). Llena cada sección; usa
`N/A` solo cuando una sección realmente no aplica.

```markdown
## Resumen

- Qué cambia (resultado, no lista de archivos)
- Por qué ahora (problema, ticket o enlace a spec)
- Cómo (1–2 frases del enfoque — solo cuando el diff no es obvio)
- (opcional) 4º bullet para rollout, flags o follow-ups

## Linear

Fixes HAB-N

- Issue: https://linear.app/habitanexus/issue/HAB-N/…
- OpenSpec (si aplica): `openspec/changes/YYYY-MM-DD-HAB-N-slug/`
- PRs relacionados del monorepo (si aplica): enlazar aquí

## Plan de pruebas

- [ ] …
- [ ] …

## Límites de alcance (fuera de scope)

- Listar explícitamente qué NO cambia este PR (sin refactors de paso, sin fixes no
  relacionados, sin ediciones "ya que estaba aquí")

## Riesgo / rollout

- Migraciones, digest de GitOps, feature flags, API breaking o config solo-prod —
  o `N/A`

## Screenshots / evidencia

- UI: antes/después o captura de Widgetbook
- Ops: `kubectl`, resumen de `terraform plan`, enlace de CI o snippet de logs — o `N/A`
```

### Notas de sección

| Sección | Requerida cuando |
| --- | --- |
| **Resumen** | Siempre — 2–4 bullets; liderar con **qué** y **por qué**, no solo el ticket |
| **Linear** | Siempre — `Fixes HAB-N` (o `Closes` / `Resolves`) para linkear GitHub ↔ Linear |
| **Plan de pruebas** | Siembre — checkboxes que el revisor pueda marcar; nombrar comandos o entornos |
| **Límites de alcance** | Siempre — evita archivos "sorpresa" en el diff |
| **Riesgo / rollout** | Cuando cambie deploy, schema, infra o comportamiento visible al usuario |
| **Screenshots / evidencia** | Cambios de UI, design system, o backend/infra difícil de verificar |

**Título:** incluir `HAB-N` y un resultado específico, ej.
`feat(mobile): coworking finder (HAB-73)` — no `Fix bug` ni `WIP updates`.

**Rama:** `*/HAB-N-*` (id en minúsculas). Preferir el `gitBranchName` de Linear.

---

## PRDS — Límites de tamaño y alcance

Estos límites mantienen una pasada de revisión humana en ~**15–30 minutos**. Si se
espera más, **partir el PR** antes de abrirlo.

| Regla | Guía |
| --- | --- |
| Un issue Linear primario | Un PR por issue hijo cuando sea posible (`HAB-N` 1:1) |
| Soft cap de tamaño | ~**400 líneas cambiadas** (adiciones + borrados) — partir si es mayor |
| Tiempo de revisión meta | ~15–30 min del revisor sobre un diff acotado |
| Sin refactors de paso | Formato, renombres o "limpieza" van en su propio PR |
| Un intención por PR | Responsabilidad única — una feature, fix o slice de doc |
| Epics cross-repo | **Un PR por repo**; enlazar PRs hermanos en cada descripción |
| Split de capas (orden por defecto) | specs → docs → gitops/infra → app |
| Vertical slice | Preferir slice end-to-end sobre dump horizontal de "todos los controllers" |

### Cuándo partir

- Diff supera ~400 líneas **o** toca dominios no relacionados (ej. Marketplace + Fiscal).
- Se mezclan **decisión** (OpenSpec) e **implementación** — publicar el PR de spec
  primero salvo que el cambio sea trivial y `skip_specs: true`.
- Adopción **DSMS/IFS/CPS**: no mezclar una reorg grande de carpetas con feature work
  sin un plan de corte documentado
  ([organización de código](code-organization-standards.md)).
- El revisor necesitaría una reunión guiada para entender el PR — partir o añadir un
  link a design doc en lugar de un mega-diff.

### Excepciones permitidas

- Codegen mecánico, solo-lockfile o movimientos de imports **si** la descripción lo
  declara y el plan de pruebas es "CI verde únicamente".
- PRs de seguimiento marcados explícitamente **parte 1 de N** con el mismo `HAB-N`
  solo cuando los criterios de aceptación del issue estén desfasados intencionalmente
  (anotarlo en Linear).

---

## PRDS — Flujo de trabajo con PR draft

El trabajo revisable aterriza en el **repo dueño** como PR **draft** de GitHub — no
solo en `/tmp` ni pegado en el chat.

| Paso | Práctica |
| --- | --- |
| 1 | **Worktree** de git aislado por issue/agente (`.claude/worktrees/hab-N-…`) |
| 2 | `gh pr create --draft` en cuanto exista un primer corte coherente |
| 3 | **Commits progresivos** — pushear commits incrementales a la rama del PR; no acaparar toda la sesión en local |
| 4 | `--assignee lapc506`; `--reviewer` solo cuando el autor ≠ Andrés |
| 5 | Undraft / ready-for-review **solo tras OK humano** (o petición explícita) |
| 6 | Pinger de PR-ready en el canal `#dev-*` correspondiente |

Convenciones espejadas en cada repo `AGENTS.md` → **Entregables de agente — draft PR primero**.

---

## PRDS — Checklist del agente

Antes de `gh pr create --draft`:

- [ ] Rama cumple `*/HAB-[0-9]+-*`; título y cuerpo incluyen **HAB-N**
- [ ] Cuerpo usa el [template de descripción](#prds--template-de-descripción) (todas las secciones)
- [ ] `Fixes HAB-N` (o equivalente) para auto-link de Linear
- [ ] Plan de pruebas lista pasos concretos; PR de UI incluye screenshots/evidencia
- [ ] **Límites de alcance** listan qué queda fuera intencionalmente
- [ ] Diff revisable (~≤400 líneas, una intención, sin refactors de paso)
- [ ] Trabajo cross-repo: solo este repo; PRs hermanos enlazados en el cuerpo
- [ ] Commits pusheados desde el **worktree**; no solo trabajo local sin commitear
- [ ] `--assignee lapc506`; flag de reviewer solo si el autor no es Andrés
- [ ] Checklist DSMS/IFS/CPS satisfechos al tocar estructura/barrels
      ([organización de código](code-organization-standards.md)); PRDS al abrir o
      refrescar la descripción del PR

---

## SSOT relacionado

| Doc | Tema |
| --- | --- |
| [Estándares de organización de código (DSMS, IFS, CPS)](code-organization-standards.md) | PR checklists de carpetas/barrels |
| Este doc (**PRDS**) | Template de descripción, límites de tamaño, flujo draft |
| [Estrategia de ramas (GitFlow)](../branching.md) | `main` vs `develop` vs `staging` |
| [Bounded contexts](../bounded-contexts.md) | Límites de dominio del monolito modular |