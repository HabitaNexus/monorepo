# Spike: Cruce de Datos HabitaNexus x AltruPets

**Fecha:** 2026-04-12
**Tipo:** Exploracion de sinergias entre productos
**Relevancia:** Valor agregado B2G + impacto social

---

## Contexto

HabitaNexus registra datos de contratos de arrendamiento que incluyen:
- Mascotas permitidas (tipo, cantidad, razas)
- Restricciones de mascotas (zonas comunes, peso maximo)
- Cohabitantes del inmueble
- Ubicacion georeferenciada del inmueble

AltruPets tiene un sistema de reportes de maltrato animal (spec: `abuse-reports`) que incluye:
- Reportes autenticados con GPS, fotos y seguimiento automatico
- Enrutamiento a jurisdiccion municipal correcta via PostGIS
- Panel municipal (J7) para gestion de casos
- Maquina de estados: FILED -> EN_REVISION -> INVESTIGADO -> RESUELTO

## Oportunidad de Cruce

### Deteccion proactiva de maltrato/negligencia

| Senal en HabitaNexus | Posible maltrato en AltruPets | Accion |
|---|---|---|
| Contrato dice "no mascotas" + reclamo del propietario por "mascotas no autorizadas" | Animal en situacion precaria (escondido, sin espacio adecuado) | Alerta a AltruPets para verificacion |
| Inmueble de 30m2 con 3+ perros grandes | Hacinamiento animal | Alerta al panel municipal |
| Terminacion anticipada por incumplimiento + propietario reporta "danos por animales" | Animal potencialmente abandonado en desalojo | Coordinacion con rescatistas de AltruPets |
| Inquilino con historial de multiples contratos cortos + reclamos por mascotas en todos | Patron de negligencia animal recurrente | Perfil de riesgo en AltruPets |
| Propiedad en zona rural sin acceso a veterinario + multiples mascotas | Riesgo de negligencia medica | Sugerir subsidio veterinario de AltruPets |

### Valor para el Panel Municipal (B2G)

Municipalidades que ya tienen ambas necesidades:
- **Heredia**: Tiene licencia de alquileres Y es una de las municipalidades target de AltruPets
- **San Jose**: Tiene portal ArcGIS completo Y obligaciones de bienestar animal (Ley 9458)
- **Escazu**: Tiene geoportal Y es canton con alta densidad de mascotas

El dashboard municipal podria integrar:
1. Mapa de calor de propiedades con mascotas (HabitaNexus)
2. Mapa de calor de reportes de maltrato (AltruPets)
3. Correlacion entre desalojos y abandonos animales
4. Zonas con alta densidad de mascotas pero sin acceso veterinario

### Arquitectura

Ambas plataformas generan eventos georeferenciados. El cruce se hace via:
- Shared event bus (NATS/RabbitMQ) con topicos por canton
- Feature Layer compartido en ArcGIS con dos capas: arrendamiento + bienestar animal
- API de consulta cruzada con consentimiento del usuario

### Consideraciones de Privacidad (Ley 8968)

- Los datos de contratos son privados. Solo se comparten con consentimiento explicito o por requerimiento judicial.
- Los reportes de maltrato son publicos por naturaleza (interes publico).
- El cruce debe ser agregado/anonimizado para el dashboard municipal, NO individual.
- Excepciones: sospecha fundada de maltrato permite compartir datos especificos al SENASA o municipalidad.

## Siguiente Paso

Definir protocolo de eventos compartidos entre HabitaNexus y AltruPets como OpenSpec compartido.
