# HabitaNexus

**Marketplace de alquiler de viviendas a largo plazo con negociación digital de contratos**

---

## North Star

> "Un inquilino encuentra una vivienda, negocia precio, plazo y condiciones especiales directamente en la app, firma el contrato y deposita la garantía en escrow — todo sin reuniones presenciales ni intercambios de WhatsApp."

A diferencia de Facebook Marketplace o Encuentra24, HabitaNexus permite negociar los términos del arrendamiento (precio, duración, condiciones especiales, servicios incluidos) a través de un flujo guiado tipo customer journey.

---

## Documentación

| Sección | Descripción |
|---------|-------------|
| [SOPs](docs/sops/index.md) | Procedimientos operativos: flujo de arrendamiento, escrow, referidos |
| [Investigación](docs/investigacion/index.md) | Hallazgos de contratos informales + plantillas de entrevista |
| [Usuarios](docs/usuarios/index.md) | Perfiles y expectativas de inquilinos y propietarios reales |
| [UX Research](docs/ux-research/index.md) | Journey maps y storyboards interactivos |
| [Normativa](docs/normativa/index.md) | Marco legal costarricense (Ley 7527) |
| [Planes](docs/planes/index.md) | Spikes y planes de implementación técnica |

---

## Propuesta de valor

**Negociación digital de contratos** — los dos lados del mercado (inquilino + propietario) recorren un flujo de pantallas que convierte la conversación tradicional de WhatsApp en un contrato estructurado con:

- Precio acordado por ambas partes
- Plazo del arrendamiento
- Condiciones especiales (mascotas, modificaciones, servicios incluidos)
- Depósito de garantía custodiado en **escrow** (Stellar + Trustless Work)

## Stack técnico

| Componente | Tecnología |
|-----------|-----------|
| App móvil | Flutter (Android primero) |
| Backend | NestJS + PostgreSQL |
| Escrow | Trustless Work Dart SDK sobre Stellar Soroban |
| Identidad | Costa Rica: cédula + firma digital BCCR (roadmap) |

## Estructura legal

Delaware LLC (primaria) + CR SRL (OpCo local) — **"Delaware Tostada"**.

---

!!! info "Estado del proyecto"
    HabitaNexus está en fase de **validación de problema** + **spike técnico** de escrow.
    Ver [Hallazgos de contratos informales](docs/investigacion/hallazgos-contratos-informales.md) y [Trustless Work Spike](docs/planes/trustless-work-dart-spike.md).
