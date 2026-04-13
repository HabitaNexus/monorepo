# Spike: Oportunidad B2G — Municipalidades + TRIBU-CR

**Fecha:** 2026-04-12
**Tipo:** Investigacion de mercado B2G
**Relevancia:** Linea de negocio potencial post-traccion

---

## La Brecha Fiscal

| Dato | Valor | Fuente |
|---|---|---|
| Hogares en alquiler en CR | ~340,000 | ENAHO/INEC |
| Contribuyentes que declaran renta de alquiler | 36,110 | Direccion General de Tributacion, 2023 |
| Relaciones de alquiler ocultas al fisco | ~300,000 | Diferencia |
| Impuesto: renta de capital inmobiliario | 15% sobre 85% del ingreso bruto | Ley del ISR |
| IVA sobre alquileres >C693,300/mes | 13% | Ley del IVA |
| Sistema de declaracion actual | TRIBU-CR (reemplazo la D-125 del viejo ATV) | Ministerio de Hacienda |

## Estado Actual de las Municipalidades

### Acceso al Registro Nacional
- **No hay API publica del Registro Nacional.**
- SIRI (Sistema de Informacion del Registro Inmobiliario) es consulta, no API bidireccional.
- RNP Digital tiene convenios con 52 municipalidades para consultas manuales.
- Ley 7509: municipalidades transfieren al menos 3% del IBI al Registro Nacional a cambio de datos catastrales actualizados.

### Deteccion de Propiedades en Alquiler
- **Las municipalidades casi no saben que propiedades estan en alquiler.**
- Declaracion quinquenal (Ley 7509) NO incluye uso actual (alquiler/desocupada/propia).
- No existe mecanismo automatico de reporte.
- Algunas municipalidades (ej: Heredia) exigen licencia de alquileres con patente sobre ingresos brutos.
- Brecha de cumplimiento masiva: la mayoria de relaciones de alquiler son invisibles al fisco.

### Silos Institucionales
- Registro Nacional, municipalidades y Hacienda NO comparten datos sobre propiedades en alquiler.
- No hay cruce automatico entre D-125/TRIBU-CR y patente municipal.
- Cada institucion opera independientemente.

## Cambio de Uso de Suelo
- Alquiler residencial a largo plazo **NO es cambio de uso de suelo** (sigue siendo "residencial").
- SI requiere cambio: Airbnb, local comercial, uso mixto (consentimiento de vecinos en 50m, Concejo Municipal).
- Pero varias municipalidades SI exigen patente/licencia para la actividad economica de arrendar (obligacion tributaria, no urbanistica).

## Impuestos Aplicables

| Impuesto | Quien cobra | Monto | Diferencia alquiler vs. propio |
|---|---|---|---|
| IBI (Bienes Inmuebles) | Municipalidad | 0.25% anual del valor fiscal | **Ninguna** (mismo monto) |
| Patente de alquileres | Municipalidad (si aplica) | Sobre ingresos brutos | **Adicional** al IBI |
| Renta capital inmobiliario | Hacienda (TRIBU-CR) | 15% sobre 85% ingreso | Solo si alquila |
| IVA | Hacienda | 13% si alquiler >C693,300/mes | Solo si alquila y supera umbral |
| Factura electronica | Hacienda | Obligatoria | Solo si alquila |

## Producto B2G Propuesto: "HabitaNexus Compliance"

| Servicio | Beneficiario | Valor |
|---|---|---|
| Notificacion automatica al firmar contrato | Municipalidad del canton | Cobrar patente/licencia proactivamente |
| Reporte de ingresos por alquiler | Ministerio de Hacienda (TRIBU-CR) | Cruce automatico para detectar evasion |
| Dashboard cantonal de propiedades en alquiler | Municipalidades | Planificacion urbana con datos reales para Plan Regulador |
| Certificacion de cumplimiento para propietarios | Propietarios (indirecto B2G) | Reduccion de fiscalizacion |
| Export ArcGIS-compatible (GeoJSON/Feature Layer) | Municipalidades con portal GIS | Superposicion con Plan Regulador y catastro |

## Arquitectura Tecnica

Reutilizar el patron Port/Adapter de aduanext con hacienda-cr SDK:
- `TaxReportingPort` (dominio) -> `TribuRentalIncomeAdapter` (adaptador)
- Mismo sidecar gRPC de hacienda-cr para autenticacion OIDC
- TRIBU-CR ya esta modelado en aduanext como sistema externo

## Recomendacion Estrategica

Fase post-traccion (~500+ contratos en la plataforma). Primero acumular masa critica para que los datos tengan valor estadistico. Luego ofrecer compliance como diferenciador competitivo.

## Fuentes

- [Licencia de Alquileres — Municipalidad de Heredia](https://www.heredia.go.cr/es/tramites/servicios-tributarios/solicitud-de-licencia-de-alquileres)
- [Cuantas personas tributan por alquileres — Actualidad Tributaria](https://actualidadtributaria.com/?action=news-view&id=1160)
- [Patente comercial para alquiler — Lang Abogados](https://www.langcr.com/content/127/)
- [API Ministerio de Hacienda](https://api.hacienda.go.cr/docs/)
- [SNIT](https://www.snitcr.go.cr/snit_que_es)
- [Impuesto sobre renta de alquileres — Domus Verum](https://www.domusverum.com/impuesto-sobre-renta-de-alquileres-costa-rica/)
- [TRIBU-CR — Charla Hacienda](https://www.facebook.com/ministeriodehaciendacr/videos/1594884601883682/)
