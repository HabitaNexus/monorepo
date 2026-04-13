# TRIBU-CR Adapter — Especificacion Completa

**Dominio**: `tribu-cr-adapter`
**Prioridad**: Alta (B2G)
**Servicios afectados**: Tax Reporting Service, Contract Service, Payment Service
**Arquitectura de referencia**: aduanext (Hexagonal / Ports & Adapters)

---

## Vision General

Integrar HabitaNexus con TRIBU-CR (el sistema tributario que reemplazo al viejo ATV y la D-125) para reportar automaticamente ingresos por alquiler al Ministerio de Hacienda. Esto habilita la linea B2G y posiciona a HabitaNexus como plataforma de compliance tributario.

### Reutilizacion de aduanext

El patron se toma directamente de la arquitectura de aduanext:

```
libs/domain/ports/TaxReportingPort          # Interfaz pura (sin I/O)
libs/adapters/tribu-cr/TribuRentalAdapter   # Implementacion concreta
apps/hacienda-sidecar/                      # Mismo sidecar gRPC (@dojocoding/hacienda-cr)
```

**Dependencia clave**: `@dojocoding/hacienda-cr` como npm dependency (NUNCA forked, misma regla que aduanext).

### Flujo

1. Contrato firmado en HabitaNexus -> evento `ContractSigned`
2. Cada pago mensual procesado -> evento `RentPaymentProcessed`
3. Tax Reporting Service consume eventos y genera declaracion
4. Declaracion se envia a TRIBU-CR via hacienda-cr sidecar (autenticacion OIDC)
5. Propietario recibe notificacion de declaracion enviada

### Impuestos que Aplican

| Impuesto | Monto | Declaracion | Sistema |
|---|---|---|---|
| Renta capital inmobiliario | 15% sobre 85% ingreso bruto | Mensual (antes del 15 del mes siguiente) | TRIBU-CR |
| IVA | 13% si alquiler >C693,300/mes | Mensual | TRIBU-CR |
| Factura electronica | Obligatoria por cada pago recibido | Por transaccion | TRIBU-CR |

### Gateways (Outbound Ports)

```dart
abstract class TaxReportingPort {
  Future<TaxDeclaration> reportRentalIncome(RentalIncomeEvent event);
  Future<Invoice> generateElectronicInvoice(PaymentEvent event);
  Future<TaxStatus> checkComplianceStatus(String ownerId);
}
```

### Consideraciones

- TRIBU-CR reemplazo a la D-125 del sistema ATV. NO usar referencias al sistema viejo.
- La API de Hacienda existe: https://api.hacienda.go.cr/docs/ (contribuyentes, tipos de cambio, CABYS)
- El sidecar gRPC de hacienda-cr ya maneja: OIDC auth, XAdES signing, proxy ATENA
- Para TRIBU-CR se necesita extender el sidecar con servicio `TribuTaxReporter`

### Fuentes

- [API Hacienda](https://api.hacienda.go.cr/docs/)
- [TRIBU-CR — Charla Hacienda](https://www.facebook.com/ministeriodehaciendacr/videos/1594884601883682/)
- [hacienda-cr SDK](https://github.com/DojoCodingLabs/hacienda-cr)
- aduanext: `libs/proto/hacienda.proto` (4 gRPC services)
