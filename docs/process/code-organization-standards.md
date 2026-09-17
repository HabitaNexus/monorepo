---
title: Estándares de organización de código (DSMS, IFS, CPS)
owner: Platform Team
status: review
diataxis_type: reference
last_review: 2026-09-07
review_cadence: quarterly
audience: internal
source_of_truth: docs/process/code-organization-standards.md
---

# Estándares de organización de código (DSMS, IFS, CPS)

Tres buenas prácticas interconectadas para cómo se organiza y se lee el código de
HabitaNexus. **Nombran y hacen exigibles convenciones ya en uso** (feature-first en
Flutter, módulos por dominio en NestJS, Atomic Design en el paquete de UI) — no son
un framework greenfield.

| Sigla | Nombre completo | Alcance |
| --- | --- | --- |
| **DSMS** | Domain-Sliced Module Structure | Dónde viven los archivos (carpetas / módulos) |
| **IFS** | Intra-File Structure | Cómo se lee un archivo de arriba a abajo |
| **CPS** | Categorized Public Surface | Cómo exportan los barrels / entrypoints públicos |

```text
DSMS  (dónde vive el módulo/archivo)     ← base
  ├─ IFS  (cómo se lee por dentro)       ← ortogonal; aplica a cada archivo
  └─ CPS  (cómo se publica afuera)       ← depende de DSMS
```

**Orden de adopción:** documentar y revisar DSMS → IFS → CPS. **Prioridad del día a
día:** IFS (mismo ritmo de lectura en cada fuente).

### Política de adopción

- **Solo incremental** — aplicar DSMS/IFS/CPS al añadir o editar materialmente código
  de esa área. **No** refactorizar árboles legacy o archivos no relacionados por cumplir.
- **Repos satélite** — `AGENTS.md` del monorepo enlaza a esta página; no duplicar el
  texto completo en paquetes ni apps.
- **No es una licencia de refactor** — fusionar este doc no autoriza reordenaciones
  masivas, movimientos de carpetas ni reescrituras de barrels fuera del alcance del
  ticket actual.

---

## 1. Domain-Sliced Module Structure (DSMS)

**Definición:** organizar carpetas y módulos por dominio/capacidad primero, y luego por
capa técnica — no al revés.

### Cuándo aplica

- Apps Flutter: `apps/mobile/lib/features/{feature}/{presentation|domain|data}/`
- Backend NestJS: `apps/backend/apps/{contexto}/` (bounded contexts del monolito
  modular, ver [`docs/bounded-contexts.md`](../bounded-contexts.md))
- Paquetes Dart compartidos: `packages/{paquete}/`
- Librerías de UI (design system): `{feature}/{atoms|molecules|organisms|templates}/`

**No aplica a:** librerías técnicas puras sin cortes de dominio; scripts de un solo uso;
retrofit forzado de árboles legacy sin plan de migración.

### Reglas

1. **Path feature-first:** después de `lib/` / `apps/{app}/` el siguiente segmento DEBE
   ser un id de dominio/feature (`coworking`, `visits`, `contract`, …), no una capa
   técnica pelada (`widgets/`, `services/` en la raíz).
2. **Anidamiento de capa técnica:** las capas (data/domain/presentation) van **debajo**
   de la feature.
3. **Raíces de feature planas** salvo que la complejidad del dominio exija anidar.
4. **Kit compartido:** primitivas cross-feature viven bajo `core/` o `shared/`
   reservados, no dispersas.
5. **UI repos / design system:** las capas de Atomic Design son la capa técnica bajo
   cada feature.
6. **Tipos de feature:** tipos cross-capa PUEDEN vivir en `{feature}/types.dart`.
7. **Sin árboles paralelos:** no mantener a la vez `lib/widgets/` plano y
   `lib/features/{feature}/presentation/widgets/`.

### Anti-patrones

- Layer-first (`lib/widgets/Button.dart` sin feature)
- Anidamiento innecesario profundo (`coworking/dashboard/widgets/renderers/…`)
- Árboles legacy planos + domain-sliced mezclados en el mismo PR sin plan de corte

### PR checklist

- [ ] Módulos nuevos siguen `{feature}/{layer}/`
- [ ] Sin carpetas nuevas solo técnicas en el top-level
- [ ] Primitivas compartidas bajo `core/` o `shared/`
- [ ] Tipos de feature no duplicados por capa sin razón

### Instancias HabitaNexus

- Mobile: `apps/mobile/lib/features/{feature}/{presentation|domain|data}/`
  (ej. `features/coworking/`)
- Backend: `apps/backend/apps/{bounded-context}/` (contract-core, payments, tax, iam…)
- UI: `packages/{design-system}/lib/src/{feature}/{atoms|molecules|…}/`

---

## 2. Intra-File Structure (IFS)

**Definición:** orden canónico y secciones etiquetadas **dentro de un único archivo
fuente**, para que cada archivo se lea igual.

### Procedencia (no inventado)

IFS es la marca de HabitaNexus para práctica establecida:

- Clean Code cap. 5 — metáfora del periódico / formato vertical / orden vertical
- "API pública arriba, helpers debajo"
- `directives_ordering` y lint rule `sort_pub_directives` (Dart), orden de miembros
  en PHP/Python linters
- Convención de imports Dart: `dart:` → `package:` → relativos

HabitaNexus añade: **secciones con banner obligatorio** que indiquen **qué** + **por
qué**, y un checklist compartido para Dart y TypeScript.

### Cuándo aplica

- Widgets / módulos / repos Flutter (`.dart`)
- Servicios y módulos NestJS (`.ts`)
- Archivos de test más allá de un caso trivial
- Barrels **con lógica local** (los barrels de re-export puro → solo CPS)

**No aplica a:** config JSON/YAML; stubs generados; archivos diminutos de export único
donde los banners añaden ruido.

### Orden canónico de secciones

**Dart / Flutter**

1. Imports (`dart:` → `package:` → relativos)
2. `part` / `part of` (si aplica, justo después de imports)
3. Tipos & interfaces (interfaces/entidades, luego tipos internos)
4. Constantes & config
5. Clase principal / API pública
6. Métodos privados / helpers (misma banda de abstracción; menor detalle más abajo)
7. Exports (barrel: `show`/`hide` al final si aplica)

**TypeScript / NestJS**

1. Imports (framework → vendor → proyecto)
2. Tipos & interfaces (props primeras)
3. Constantes & config
4. Clase principal / controller / service / API pública
5. Helpers privados
6. Exports (default al final cuando se usa)

**Tests**

1. Imports (framework → SUT → fixtures)
2. Setup / teardown
3. Casos agrupados por escenario (no dump alfabético)

### Convención de bloques de comentario (crítico)

Cada **sección mayor** con banner debe indicar **qué** contiene y **por qué** existe
(o cómo se relaciona con el rol del archivo).

**Dart**

```dart
// ---------------------------------------------------------------------------
// Types — formas de props y estado interno del widget
// ---------------------------------------------------------------------------
```

**TypeScript**

```ts
// ---------------------------------------------------------------------------
// Types — props y estado del componente
// ---------------------------------------------------------------------------
```

- Secciones mayores: banner `// ---` (~79 chars)
- Preludio de archivo (raro): `// ===` solo si el path DSMS es ambiguo
- Comentario inline `//` para el *why* local de edge cases — nunca "incrementa el contador"
- Evitar `/* … */` en Dart/TS (pelea con formatters)

| Estilo | Cuándo usar |
| --- | --- |
| Banner `// ---` (Dart/TS) | Límite de sección mayor |
| Comentario de una línea `//` | *Why* local no obvio |
| Doc comments (`///`) | API pública |

### Anti-patrones

1. **Archivo largo** (>~500 líneas) sin extraer a hermanos DSMS
2. **Niveles de abstracción mezclados** (lógica de dominio junto a parsers de string)
3. **Misterio** — bloques de 5+ líneas sin etiqueta
4. **Comentarios obsoletos u obvios**
5. **Caos de exports** — exports dispersos a mitad de archivo

### PR checklist

- [ ] Orden canónico para el tipo de archivo (Dart / TS / test)
- [ ] Secciones mayores con banners de **what** + **why**
- [ ] Sin bloques misteriosos sin etiqueta
- [ ] Imports agrupados
- [ ] Niveles de abstracción agrupados (alto → bajo hacia abajo en el archivo)
- [ ] Comentarios explican *why*, no *what*

---

## 3. Categorized Public Surface (CPS)

**Definición:** barrels públicos y entrypoints de paquetes agrupan exports por **slice
de dominio**, luego por **tipo** (runtime → type-only → deprecated), con banners de
sección indicando qué y por qué.

### Cuándo aplica

- Entrypoints de paquete (`lib/{paquete}.dart` para `packages/*`)
- Barrels de feature (`features/{feature}/{feature}.dart`)
- Facade/barrels con muchos re-exports

**No aplica a:** módulos internos sin barrel público; paquetes diminutos con pocos exports.

### Reglas

1. Agrupar por **feature DSMS** primero (`coworking`, `contract`, `shared`, …).
2. Dentro de una feature: **runtime** → **`export type` / `show` de tipos** →
   **deprecated**.
3. **Banners de sección obligatorios** (qué + por qué).
4. Sin zonas de dump sin etiquetar en barrels grandes.
5. UI repos: mantener marcadores Atomic en top-level (`// Atoms`, …) y anidar banners
   de feature debajo cuando los bloques crezcan.
6. Siempre `export type { … }` para símbolos solo-tipo (TS) / separar exports de tipos.
7. No inventar exports públicos sin consumidor.

### Anti-patrones

- Pares `export` / `export type` intercalados sin agrupar por tipo
- Espagueti de features en una lista sin etiquetar
- `export` pelado de tipos
- Exports especulativos sin uso

### PR checklist

- [ ] Exports nuevos bajo la sección de feature correcta
- [ ] Runtime antes que type-only
- [ ] Banner para feature nueva / subgrupo grande
- [ ] Tipos exportados como tales
- [ ] Existe consumidor (o llega en el mismo PR)

### Instancias HabitaNexus

- Barrels de feature: `apps/mobile/lib/features/{feature}/{feature}.dart`
- Paquetes: entrypoint `packages/{paquete}/lib/{paquete}.dart`
- UI: barrel de design system (agrupar por feature + capa Atomic)

---

## Referencia rápida

| Pregunta | Práctica |
| --- | --- |
| ¿Va en `{feature}/` o `core/`? | DSMS |
| ¿Es widget privado de la feature? | DSMS |
| ¿Orden imports → types → main → helpers? | IFS |
| ¿Banner `// ---`? | IFS (archivo) / CPS (barrel) |
| ¿Sale en el barrel del package? | CPS |
| ¿`export` runtime o `export type`? | CPS |

---

## Notas de adopción

- **SSOT:** esta página (`docs/process/code-organization-standards.md`).
- **Satélites:** puntero en `AGENTS.md` del monorepo; una línea por repo hijo.
- **Relacionados:** [`pull-request-description-and-scope.md`](pull-request-description-and-scope.md)
  (PRDS) y [`docs/bounded-contexts.md`](../bounded-contexts.md).
- **Enforcement:** empezar con los PR checklists; lint rules (orden de directives,
  orden de miembros) son follow-up — no necesarios para adoptar el vocabulario.