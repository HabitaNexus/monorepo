# Spec Delta

## Purpose

El motor de estados de negociación gobierna el ciclo propuesta-contrapropuesta-acuerdo entre inquilino y propietario con reglas aplicadas en el servidor, de forma auditable y con límites de tiempo y rondas.

## ADDED Requirements

### Requirement: Estados de negociación

El sistema SHALL modelar una negociación con los estados `PROPUESTA_ENVIADA`, `CONTRAPROPUESTA`, `ACUERDO_ALCANZADO`, `PENDIENTE_FIRMA`, `RECHAZADA` y `EXPIRADA`.

#### Scenario: Propuesta inicial crea negociación

- **WHEN** el inquilino envía una propuesta inicial sobre un listing
- **THEN** se crea una negociación en estado `PROPUESTA_ENVIADA` en ronda 1 con deadline de 72 horas

#### Scenario: Iteración por contrapropuesta

- **WHEN** la parte que tiene el turno envía una contrapropuesta con uno o más términos modificados
- **THEN** la negociación pasa a `CONTRAPROPUESTA`, la ronda se incrementa y el deadline se reinicia a 72 horas

### Requirement: Transiciones válidas e inválidas

El sistema SHALL permitir únicamente las transiciones `PROPUESTA_ENVIADA → CONTRAPROPUESTA | ACUERDO_ALCANZADO | RECHAZADA | EXPIRADA`, `CONTRAPROPUESTA → CONTRAPROPUESTA | ACUERDO_ALCANZADO | RECHAZADA | EXPIRADA`, `ACUERDO_ALCANZADO → PENDIENTE_FIRMA` y SHALL rechazar cualquier otra con un error estructurado sin corromper el estado.

#### Scenario: Aceptación directa de propuesta

- **WHEN** el propietario acepta la propuesta inicial sin modificar términos
- **THEN** la negociación pasa a `ACUERDO_ALCANZADO` y la plataforma genera el resumen de términos pactados

#### Scenario: Transición inválida

- **WHEN** se intenta una transición fuera del diagrama (por ejemplo aceptar desde `RECHAZADA`)
- **THEN** el sistema retorna un error estructurado de transición inválida y el estado permanece intacto

### Requirement: Timeout de 72 horas por ronda

El sistema SHALL transicionar a `EXPIRADA` una ronda sin respuesta dentro de 72 horas, mediante un mecanismo que opera aunque ningún usuario abra la aplicación.

#### Scenario: Expiración por silencio

- **WHEN** pasan 72 horas desde el inicio de la ronda sin acción de la parte en turno
- **THEN** la negociación pasa a `EXPIRADA` y ambas partes pueden ver el motivo de cierre

### Requirement: Máximo de 5 rondas

El sistema SHALL ejecutar el cierre forzado al alcanzar 5 rondas sin acuerdo, registrando la negociación como `EXPIRADA`.

#### Scenario: Quinta ronda sin acuerdo

- **WHEN** se completa la ronda 5 sin que ninguna parte acepte
- **THEN** la negociación se cierra como `EXPIRADA` y las partes solo pueden iniciar una negociación nueva

### Requirement: Confirmación bilateral del acuerdo

El sistema SHALL requerir la confirmación de ambas partes sobre el resumen de términos pactados antes de transicionar de `ACUERDO_ALCANZADO` a `PENDIENTE_FIRMA`.

#### Scenario: Acuerdo confirmado por ambas partes

- **WHEN** inquilino y propietario confirman el resumen de términos
- **THEN** la negociación pasa a `PENDIENTE_FIRMA`, frontera con la generación del contrato

#### Scenario: Acuerdo con una sola confirmación

- **WHEN** solo una parte confirmó el resumen
- **THEN** la negociación permanece en `ACUERDO_ALCANZADO` a la espera de la segunda confirmación

### Requirement: Audit trail de transiciones

El sistema SHALL registrar cada transición en un historial append-only con actor, timestamp, estado origen, estado destino y número de ronda.

#### Scenario: Historial auditable

- **WHEN** ocurre cualquier transición de estado
- **THEN** se agrega una entrada inmutable al historial consultable por ambas partes
