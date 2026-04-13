# Flujo de Arrendamiento Digital — Especificacion Completa

**Dominio**: `rental-flow`
**Prioridad**: Alta (MVP)
**Servicios afectados**: Contract Service, Payment Service, Notification Service, User Service
**SOP de referencia**: [docs/sop-flujo-arrendamiento.md](../../../docs/sop-flujo-arrendamiento.md)

---

## Vision General

El flujo de arrendamiento digital es el core de HabitaNexus: 7 fases que llevan una propiedad desde el listado hasta la devolucion del deposito. Reemplaza el proceso informal de WhatsApp + contratos en papel con un flujo guiado, legalmente conforme a la Ley 7527, con escrow para depositos y sistema de reclamos bidireccional.

### Fases

1. **Listado** — Propietario publica con datos obligatorios, video tour, dimensiones, catalogo de opciones
2. **Descubrimiento** — Inquilino busca con filtros de presupuesto, zona, habitaciones, mascotas
3. **Video Tour + Visita Presencial** — Pre-filtro remoto obligatorio antes de agendar visita
4. **Negociacion** — Propuestas/contrapropuestas estructuradas con 34 terminos negociables
5. **Contrato + Firma Digital** — Generacion automatica conforme a Ley 7527 (21 clausulas) + escrow via Trustless Worker
6. **Convivencia** — Pagos via Kindo SINPE + inspecciones + reclamos bidireccionales
7. **Renovacion o Terminacion** — Prorroga tacita (Art. 71), inspeccion final, liquidacion de escrow

### Entidades Principales

- `Property` — Inmueble con distribucion desglosada, catalogo de opciones, video tour
- `Listing` — Publicacion activa con rangos de negociacion y precio
- `Visit` — Video tour (3.1) o visita presencial (3.2) con estados
- `Negotiation` — Maquina de estados: PROPUESTA -> CONTRAPROPUESTA -> ACUERDO -> PENDIENTE_FIRMA
- `Contract` — Contrato digital generado (PDF + hash SHA-256) con 21 clausulas
- `Escrow` — Deposito en custodia via Trustless Worker
- `Payment` — Pago mensual via Kindo SINPE
- `Claim` — Reclamo bidireccional con maquina de estados
- `Inspection` — Inspeccion periodica con fotos (Art. 51)
- `Rating` — Calificacion mutua post-contrato

### Catalogo de Opciones (34 campos)

Ver seccion "Catalogo de opciones de la plataforma" en el SOP para la lista completa. Incluye:
- Tipo de inmueble, piso, cielo raso, pintura, cocina
- Sistema de agua caliente (8 opciones)
- Medidores de agua/electricidad (individual/compartido + 4 metodos de division)
- Internet (7 tipos de conexion + proveedor + velocidad)
- Mascotas (perros por peso/raza, gatos interior/exterior, otras)
- Huespedes, ruido, modificaciones, actividad comercial, subarriendo

### Marco Legal

- Ley 7527 — Ley General de Arrendamientos Urbanos y Suburbanos
- Reglamento para el Control de la Contaminacion por Ruido (Min. Salud, 2024)
- Ley 9458 — Bienestar animal (cruce con AltruPets)
- Ley 8968 — Proteccion de datos personales

### Verificacion de Propiedad

- Certificacion digital de RNP Digital (~C1,500)
- No existe API publica del Registro Nacional
- Opcion futura: convenio institucional para acceso programatico
