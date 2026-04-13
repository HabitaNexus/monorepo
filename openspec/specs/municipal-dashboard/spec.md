# Municipal Dashboard — Especificacion Completa

**Dominio**: `municipal-dashboard`
**Prioridad**: Media (post-traccion, ~500+ contratos)
**Servicios afectados**: GIS Service, Analytics Service, Contract Service
**Referencia de implementacion**: AltruPets B2G (`apps/web/b2g/`)
**Spikes**: [03-inventario-arcgis](../../../business/spikes/03-inventario-arcgis-municipalidades.md), [05-plan-regulador](../../../business/spikes/05-plan-regulador-pitch.md)

---

## Vision General

Dashboard web para municipalidades de Costa Rica que muestra datos de arrendamiento en tiempo real, superpuestos sobre capas catastrales y de Plan Regulador. Permite a los gobiernos locales fiscalizar patentes de alquiler, planificar servicios publicos, y actualizar el Plan Regulador con datos vivos.

### Referencia Arquitectural: AltruPets B2G

La estructura de features de `apps/web/b2g/` de AltruPets se reutiliza:

```
apps/web/b2g/lib/
├── features/
│   ├── complaints/        → HabitaNexus: rental-compliance/
│   │   ├── widgets/       │   ├── widgets/
│   │   ├── models/        │   ├── models/
│   │   └── *_page.dart    │   └── compliance_page.dart
│   ├── disbursements/     → HabitaNexus: tax-collection/
│   ├── campaigns/         → HabitaNexus: rental-trends/
│   ├── emergencies/       → HabitaNexus: housing-alerts/
│   ├── castrations/       → (no aplica)
│   └── settings/          → HabitaNexus: settings/
├── shared/
│   ├── layout/app_shell.dart    ← reutilizar patron
│   └── theme/                   ← theme HabitaNexus B2G
```

### Features del Dashboard

| Feature | Equivalente AltruPets | Descripcion |
|---|---|---|
| **Mapa de calor de arrendamiento** | (nuevo) | Densidad de contratos por distrito sobre capa catastral/Plan Regulador |
| **Compliance de patentes** | complaints/ | Propiedades con contrato pero sin licencia de alquileres |
| **Indice de precios** | (nuevo) | Precios transaccionales reales por distrito (actualizacion mensual) |
| **Tendencias de alquiler** | campaigns/ | Ocupacion, rotacion, duracion promedio por zona |
| **Alertas habitacionales** | emergencies/ | Deficit/sobreoferta, desalojos masivos, zonas criticas |
| **Recaudacion potencial** | disbursements/ | Patente no cobrada vs. cobrada, proyeccion de ingresos |
| **Configuracion** | settings/ | Reglas de aprobacion, umbrales de alerta, jurisdiccion |

### Integracion GIS

Dos protocolos segun la municipalidad:

| Protocolo | Municipalidades target | Formato de output |
|---|---|---|
| **ArcGIS REST** (FeatureServer) | San Jose, Alajuela, Escazu, Heredia, +11 mas | Feature Layer con geometria de punto (ubicacion del inmueble) |
| **OGC** (WMS/WFS) | San Carlos, Santa Ana, Carrillo, Palmares | GeoJSON via WFS |

APIs confirmadas para superponer datos:
- San Jose: `mapas.msj.go.cr/server/rest/services/SIG_RDU2023/SIG_SER_RDU2023_08USO_TIERRA_POR_ZONAS/FeatureServer`
- Alajuela: `mapas.munialajuela.go.cr/server/rest/services/PLAN_REGULADOR2004_MIL1/FeatureServer`
- Proyeccion comun: CRTM05 (EPSG:5367)

### Cruce con AltruPets (Spike 04)

El dashboard puede integrar una capa adicional de AltruPets:
- Reportes de maltrato animal georeferenciados
- Correlacion entre desalojos y abandonos animales
- Zonas con alta densidad de mascotas sin acceso veterinario

### Pricing B2G

| Tamano de municipalidad | Plan | Precio |
|---|---|---|
| >100k habitantes (San Jose, Alajuela) | Enterprise | $500/mes |
| 50-100k (Heredia, Cartago, Escazu) | Professional | $300/mes |
| 20-50k | Standard | $150/mes |
| <20k | Basic (PDF) | $50/mes |

### Prerequisito

Masa critica de ~500+ contratos en la plataforma para que los datos tengan valor estadistico. Este spec se implementa DESPUES del rental-flow core.
