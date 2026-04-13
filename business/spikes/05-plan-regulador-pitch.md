# Spike: Pitch B2G — Datos Vivos para el Plan Regulador

**Fecha:** 2026-04-12
**Tipo:** Propuesta de valor B2G
**Relevancia:** Monetizacion del Municipal Dashboard

---

## El Problema del Plan Regulador

Los planes reguladores de las municipalidades de Costa Rica:
- Se basan en **datos estaticos y censos** (actualizacion cada 10-20 anios)
- No saben cuantas propiedades estan en alquiler por zona
- No conocen los precios reales de arrendamiento (solo precios de listado)
- No detectan sobreoferta ni escasez habitacional en tiempo real
- No distinguen entre inquilinos y propietarios por barrio

### Ejemplos reales:
- [Plan Regulador Urbano Alajuela 2004](https://www.munialajuela.go.cr/Documentos/OtherFiles/Plan_Regulador_Urbano_Alajuela_2004_26-06-2019_10_57_16.pdf) — datos del 2004, 22 anios de antiguedad
- [Plan de Ordenamiento Territorial Heredia](https://www.heredia.go.cr/es/bienestar-social/plan-de-ordenamiento-territorial)

## Lo que HabitaNexus Genera

| Dato | Fuente en la plataforma | Frecuencia |
|---|---|---|
| Cantidad de propiedades en alquiler por distrito | Contratos firmados | Tiempo real |
| Precios reales de arrendamiento por zona | Precios pactados (no listados) | Mensual |
| Tasa de ocupacion (listadas vs. contratadas) | Metricas de conversion | Semanal |
| Perfil demografico de inquilinos | Registro de usuarios | Acumulativo |
| Uso mixto (vivienda + comercio menor) | Campo "actividad comercial menor" del contrato | Tiempo real |
| Duracion promedio de contratos por zona | Historial de contratos | Trimestral |
| Rotacion de inquilinos por zona | Terminaciones + nuevos contratos | Mensual |

## Producto: Municipal Dashboard

### Componentes

1. **Mapa de calor de arrendamiento** — Densidad de contratos por distrito, superpuesto sobre el Plan Regulador (ArcGIS FeatureServer o WMS/WFS)
2. **Indice de precios por distrito** — Actualizacion mensual con precios transaccionales reales (dato que NO existe hoy en CR)
3. **Alertas de propiedades sin patente** — Cruce de contratos firmados vs. licencias de alquiler emitidas
4. **Reporte trimestral para Plan Regulador** — PDF/dashboard con tendencias, recomendaciones de zonificacion
5. **Export GIS** — GeoJSON para ArcGIS, WMS para GeoServer

### Formatos de entrega por tipo de municipalidad

| Tipo | Municipalidades | Formato |
|---|---|---|
| ArcGIS Enterprise | San Jose, Alajuela, Escazu, Heredia | Feature Layer REST + Hub integration |
| ArcGIS Online/Hub | Cartago, Montes de Oca, Belen, +8 mas | ArcGIS Online item + OpenData |
| GeoServer/GeoNode | San Carlos, Santa Ana, Carrillo | WMS/WFS + GeoJSON |
| Sin GIS | ~57 municipalidades | PDF + CSV + mapa web basico embebido |

### Pricing B2G Propuesto

| Municipalidad | Plan | Precio sugerido |
|---|---|---|
| San Jose, Alajuela (>100k habitantes) | Enterprise | $500/mes |
| Heredia, Cartago, Escazu (50-100k) | Professional | $300/mes |
| Municipalidades medianas (20-50k) | Standard | $150/mes |
| Municipalidades pequenias (<20k) | Basic (PDF only) | $50/mes |

### Valor Cuantificable

- Si HabitaNexus captura el 5% de los ~340,000 hogares en alquiler en CR = ~17,000 contratos
- 17,000 contratos georeferenciados = dataset mas grande de arrendamiento real en la historia de CR
- Precio promedio de alquiler: ~C250,000/mes
- Patente no cobrada por municipalidad (estimado 2% de ingresos brutos): ~C5,000/mes por propiedad
- 17,000 propiedades x C5,000 = **C85 millones/mes en patente potencial no cobrada** (~$155,000 USD/mes)

## Pitch de 1 Minuto

> "Senora alcaldesa, su Plan Regulador se basa en datos del censo de hace 10 anios. No sabe cuantas propiedades de su canton estan en alquiler, a que precios, ni cuantas pagan patente. HabitaNexus le da esos datos en tiempo real — con un mapa que se superpone directamente sobre su portal ArcGIS. Y le mostramos cuanto recaudaria en patente si fiscaliza. El dashboard se paga solo en el primer mes."
