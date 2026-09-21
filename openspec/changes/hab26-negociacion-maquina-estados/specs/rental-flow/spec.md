# Spec Delta

## ADDED Requirements

### Requirement: Máquina de estados completa de Negotiation

La entidad `Negotiation` SHALL gobernar el ciclo de negociación entre inquilino y propietario con la máquina de estados: `PROPUESTA_ENVIADA → CONTRAPROPUESTA → [iteración] → ACUERDO_ALCANZADO → PENDIENTE_FIRMA`, con salidas a `RECHAZADA` (rechazo explícito con motivo) y a `EXPIRADA` (timeout de 72 horas sin respuesta o cierre forzado al alcanzar 5 rondas). Al alcanzar `ACUERDO_ALCANZADO`, la plataforma SHALL generar un resumen de términos pactados; cuando ambas partes lo confirman, la negociación SHALL pasar a `PENDIENTE_FIRMA`, frontera con la Fase 5 (contrato + firma). Toda transición SHALL quedar registrada en un audit trail append-only (actor, timestamp, de→a, ronda).

#### Scenario: Ciclo completo hasta firma

- **WHEN** una negociación recorre propuesta, contrapropuestas, acuerdo bilateralmente confirmado
- **THEN** el estado final es `PENDIENTE_FIRMA` y la Fase 5 puede generar el contrato sobre los términos pactados

#### Scenario: Cierre sin acuerdo

- **WHEN** una parte rechaza, expira el timeout de 72h o se alcanzan 5 rondas
- **THEN** la negociación termina en `RECHAZADA` o `EXPIRADA` con motivo visible y auditado
