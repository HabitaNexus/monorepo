# Spike: Inventario de ArcGIS en Municipalidades de Costa Rica

**Fecha:** 2026-04-12
**Tipo:** Investigacion tecnica
**Relevancia:** Viabilidad del Municipal Dashboard (B2G) + integracion GIS

---

## Resumen

| Metrica | Valor |
|---|---|
| Municipalidades con portal ArcGIS (cualquier nivel) | ~15 confirmadas |
| Municipalidades con GeoServer/GeoNode | ~5 confirmadas |
| Municipalidades con algun portal SIG/catastral digital | ~23-25 confirmadas |
| Municipalidades sin presencia GIS digital | ~57-59 (mayoria rurales) |
| Municipalidades nodo del SNIT | ~6 confirmadas |

## Nivel 1: ArcGIS Enterprise/Server Propio

| # | Municipalidad | Portal | Servicios REST |
|---|---|---|---|
| 1 | **San Jose** | mapas.msj.go.cr + [Hub](https://municipalidad-de-san-jose-msjcr.hub.arcgis.com/) | ~50+ (31 carpetas), FeatureServer + MapServer |
| 2 | **Alajuela** | mapas.munialajuela.go.cr | **120 servicios** REST |
| 3 | **Escazu** | gis.escazu.go.cr + [Hub](https://geoportal-municipalidad-de-escazu-escazu.hub.arcgis.com/) | ArcGIS Enterprise + Hub |
| 4 | **Heredia** | herediasig.maps.arcgis.com + [UBiCA](https://ubica-herediasig.opendata.arcgis.com/) | ArcGIS Online + Hub |

## Nivel 2: ArcGIS Online / Hub

| # | Municipalidad | Portal |
|---|---|---|
| 5 | Cartago | [municartago.maps.arcgis.com](https://municartago.maps.arcgis.com/home/index.html) |
| 6 | Montes de Oca | [Hub datos abiertos](https://datos-abiertos-municipalidad-de-montes-de-oca-munimontesdeoca.hub.arcgis.com/) |
| 7 | San Rafael de Heredia | [Hub geoportal](https://geoportal-san-rafael-1-msrh.hub.arcgis.com/) |
| 8 | Santo Domingo | [Hub geoportal](https://geoportal-santodomingo.hub.arcgis.com/) |
| 9 | Barva | [munibarva.maps.arcgis.com](https://munibarva.maps.arcgis.com/) |
| 10 | Belen | [OpenData](https://data1-munibelen.opendata.arcgis.com/) |
| 11 | Upala | [Hub](https://municipalidad-upala-muniupala.hub.arcgis.com/) |
| 12 | Liberia | [muniliberia.maps.arcgis.com](https://muniliberia.maps.arcgis.com/) |
| 13 | Garabito | [munigarabito.maps.arcgis.com](https://munigarabito.maps.arcgis.com/) |
| 14 | El Guarco | [muniguarco.maps.arcgis.com](https://muniguarco.maps.arcgis.com/) |
| 15 | Paraiso | [muniparaiso.maps.arcgis.com](https://muniparaiso.maps.arcgis.com/) |

## Nivel 3: GeoServer/GeoNode (Open Source, OGC)

| # | Municipalidad | Portal | Servicios |
|---|---|---|---|
| 16 | San Carlos | [IDESCA](https://idesca.munisc.go.cr/) | WMS, WFS, WCS, CSW |
| 17 | Santa Ana | [IDEOnion](https://ideonion.go.cr/) | WMS, WFS |
| 18 | Carrillo | Nodo SNIT | WMS (GeoServer) |
| 19 | Palmares | Nodo SNIT | WMS (GeoServer) |
| 20 | San Ramon | Nodo SNIT | GeoServer |

## APIs REST Consumibles (Verificadas, Acceso Publico)

### San Jose
```
Base: https://mapas.msj.go.cr/server/rest/services/
Catastro: /SIG_CATASTRO/SIG_SER_CATASTRO_MSJ/FeatureServer
Plan Regulador: /SIG_RDU2023/SIG_SER_RDU2023_08USO_TIERRA_POR_ZONAS/FeatureServer
Formatos: GeoJSON, Shapefile, CSV, SQLite
EPSG: 5367 (CRTM05)
Max records/query: 2000
```

### Alajuela
```
Base: https://mapas.munialajuela.go.cr/server/rest/services/
Catastro: /Catastro/FeatureServer
Predios: /Predios/FeatureServer
Plan Regulador: /PLAN_REGULADOR2004_MIL1/FeatureServer
```

### San Carlos (OGC)
```
WMS: https://idesca.munisc.go.cr/geoserver/wms
WFS: https://idesca.munisc.go.cr/geoserver/wfs
```

## Datos que Exponen

| Tipo de dato | San Jose | Alajuela | Heredia |
|---|---|---|---|
| Catastro | Si | Si | Si |
| Plan Regulador / Uso de suelo | Si (RDU 2023) | Si (2004) | Parcial |
| Bienes inmuebles | Si | Si | — |
| Gestion de riesgos | Si | Si | — |
| Patentes | Si (requiere token) | — | — |
| Acueductos/pluviales | — | Si | — |
| Asentamientos informales | — | Si | — |

## SNIT (Sistema Nacional de Informacion Territorial)

- **NO usa ArcGIS.** Es una red descentralizada de nodos.
- Protocolos: WMS, WFS, WMTS (estandares OGC).
- Solo ~6 municipalidades son nodos activos.
- No conecta municipalidades para fines tributarios o de gestion de alquileres.

## GeoExplora (MIVAH)

- [geoexplora-mivah.opendata.arcgis.com](https://geoexplora-mivah.opendata.arcgis.com/)
- Portal del Ministerio de Vivienda que agrega datos municipales: ordenamiento territorial, vivienda, asentamientos informales, transporte.
- SI usa ArcGIS.

## Oportunidad para HabitaNexus

La fragmentacion es la oportunidad:
- 57-59 municipalidades NO tienen portal GIS
- Las que si tienen usan tecnologias incompatibles (ArcGIS REST vs GeoServer OGC)
- No existe estandar unico de catastro municipal compartido
- HabitaNexus puede ser el primer sistema que cruza datos de arrendamiento con datos catastrales de multiples municipalidades
- Output: Feature Layer compatible con ArcGIS (para las 15 que lo usan) + WMS/WFS para GeoServer

## Dato Clave para Pitch B2G

San Jose ya expone el Plan Regulador con "uso de tierra por zonas" como FeatureServer publico. HabitaNexus puede superponer contratos de alquiler georeferenciados sobre esa capa para mostrar densidad de alquiler vs. zonificacion.

## Distribuidor Oficial

**Geotecnologias S.A.** es el distribuidor oficial de Esri para Costa Rica, Nicaragua y Guatemala. Canal de ventas principal de licencias ArcGIS para municipalidades. Organizan la "Reunion de Usuarios Esri" anual.
