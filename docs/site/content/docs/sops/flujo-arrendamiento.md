# SOP — Flujo de Arrendamiento en HabitaNexus

> Procedimiento Operativo Estándar para el ciclo completo de arrendamiento de vivienda a largo plazo, desde el listado de la propiedad hasta la devolución del depósito.

**Versión:** 1.0

**Fecha:** 2026-04-12

**Marco legal:** Ley 7527 — Ley General de Arrendamientos Urbanos y Suburbanos de Costa Rica

**Proveedores de pago:** Trustless Worker (escrow de depósitos) + Kindo (SINPE Interbancaria para pagos recurrentes)

**Referencias:**
- Contratos de arrendamiento reales escaneados (Heredia, Alajuela)
- [Cadena de Valor](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/11-cadena-de-valor.md)
- [Solución Ideal](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/02-solucion-ideal.md)
- [Fuentes de Ingresos](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/08-fuentes-de-ingresos.md)
- [Relaciones con los Clientes](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/14-relaciones-con-los-clientes.md)
- [Problemática](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/01-problematica.md)

---

## Roles

| Rol | Descripción | Acciones principales |
|-----|-------------|---------------------|
| **Propietario** | Persona física o jurídica dueña del inmueble | Lista propiedad, configura rangos de negociación, aprueba términos, firma contrato |
| **Arrendador/Gestor** | Persona autorizada para administrar la propiedad en nombre del propietario | Gestiona publicaciones, responde propuestas, coordina visitas, media reclamos |
| **Inquilino** | Persona interesada en arrendar el inmueble | Busca, negocia, firma, paga, reporta |
| **HabitaNexus (plataforma)** | Sistema que orquesta el flujo | Custodia depósito (escrow), genera contratos, procesa pagos, escala reclamos |

---

## Flujo General

```
LISTADO → DESCUBRIMIENTO → VIDEO TOUR → VISITA PRESENCIAL → NEGOCIACIÓN → CONTRATO → CONVIVENCIA → FIN DE CONTRATO
```

---

## Modelo de Ingresos en el Flujo

HabitaNexus genera ingresos en tres momentos del ciclo de arrendamiento:

| Momento | Quién paga | Monto | Frecuencia |
|---------|-----------|-------|------------|
| **Suscripción del propietario** (Fase 1) | Propietario/Administrador | ₡10,000-₡75,000/mes según plan | Mensual |
| **Comisión por contrato firmado** (Fase 5) | Inquilino | ~₡15,000-₡25,000 (~5-10% del primer mes) | Una vez por contrato |
| **Comisión por procesamiento de pago** (Fase 6) | Ambas partes (split) | 1-2% del monto del alquiler | Mensual (futuro) |

### Planes de Suscripción para Propietarios

| Plan | Precio | Propiedades | Incluye |
|------|--------|-------------|---------|
| **Básico** | ₡10,000/mes | 1-3 | Listado, contrato digital, chat |
| **Profesional** | ₡30,000/mes | 4-20 | + Reclamos bidireccionales, reportes, prioridad en búsquedas |
| **Empresarial** | ₡75,000/mes | Ilimitado | + API, marca blanca, multi-usuario |

---

## Fase 1: Listado de la Propiedad

> **Problema que resuelve:** "Revisar manualmente 25+ grupos de Facebook foto por foto, sin filtro de presupuesto, mezclando alquileres de ₡100K con ventas de $1M" — [Problemática #1](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/01-problematica.md)

### Objetivo
El propietario o arrendador publica el inmueble con la información suficiente para que un inquilino tome una decisión informada.

### Datos obligatorios del inmueble

| Campo | Ejemplo (Contrato 1) | Ejemplo (Contrato 2) |
|-------|----------------------|----------------------|
| Ubicación | Heredia, La Aurora, del super mercado El Pali 75m oeste | Alajuela, Turrúcares, Banco Nacional 800m Este y 400m Sur |
| Tipo de inmueble | Casa | Apartamento No. 3 |
| Dormitorios (cantidad + dimensiones) | No especificada | 3 dormitorios |
| Dormitorio — dimensiones mínimas por unidad (obligatorio) | No especificadas | Ej: D1: 3.5m × 4m (14 m²), D2: 3m × 3m (9 m²), D3: 2.5m × 3m (7.5 m²) |
| Dormitorio — capacidad real | No especificada | Ej: D1: cama matrimonial + clóset, D2: cama individual + escritorio, D3: solo cama individual |
| Baños (cantidad) | No especificado | 1 |
| Baño — tipo por unidad | No especificado | Completo (inodoro, lavamanos, ducha) |
| Baño — tipo de ducha | No especificado | Agua caliente |
| Baño — sistema de agua caliente (si aplica) | No especificado | Termo ducha |
| Baño — tina o jacuzzi | No especificado | No especificado |
| Baño — dimensiones | No especificado | No especificadas |
| Sala — dimensiones | No especificada | Sí (sala-comedor integrado) |
| Comedor — dimensiones | No especificado | Sí (sala-comedor integrado) |
| Cocina — dimensiones | No especificada | Sí (con fregadero y mueble) |
| Cuarto de pilas / lavandería — dimensiones | No especificado | Sí |
| Patio — dimensiones | No especificado | No especificado |
| Jardín — dimensiones | No especificado | No especificado |
| Terraza / balcón — dimensiones | No especificado | No especificado |
| Cochera (cantidad de vehículos) | No especificada | Sí (2 vehículos, bajo techo) |
| Bodega / cuarto de almacenamiento — dimensiones | No especificado | No especificado |
| Área total del inmueble (m²) | No especificada | No especificada |
| Áreas comunes compartidas | No especificadas | Sí (portón de hierro compartido con otros apartamentos) |
| Restricciones especiales de ruido | No especificadas | No especificadas (ej: vecinos con horario nocturno, zona hospitalaria, condominio con reglamento propio) |
| Estado del inmueble | Perfecto estado para el uso que se destina | Buen estado de pintura, pisos, vidrios, instalaciones eléctricas y sanitarias |
| Uso permitido | Vivienda exclusiva del arrendatario y su núcleo familiar | Vivienda única y exclusiva |
| Actividad comercial menor en el inmueble | No especificado | No especificado |
| Precio mensual | ₡350,000 | ₡280,000 |
| Depósito de garantía | ₡300,000 | ₡280,000 (equivalente a 1 mes de renta) |
| Duración propuesta | 1 año (Art. 70: legalmente se entiende como 3 años) | 3 años |
| Servicio: agua — tipo de medidor | No especificado | No especificado |
| Servicio: agua — pago | Por cuenta del inquilino | Por cuenta del inquilino |
| Servicio: electricidad — tipo de medidor | No especificado | No especificado |
| Servicio: electricidad — pago | Por cuenta del inquilino | Por cuenta del inquilino |
| Servicio: internet (fibra óptica / ADSL) | Por cuenta del inquilino | Por cuenta del inquilino |
| Servicio: cable TV | Por cuenta del inquilino | Por cuenta del inquilino |
| Servicio: teléfono fijo | Por cuenta del inquilino | Por cuenta del inquilino |
| Servicio: gas | No aplica | No aplica |
| Servicio: recolección de basura | Por cuenta del inquilino | Por cuenta del propietario (Cláusula DÉCIMA) |
| Paquete combinado (internet + cable + teléfono) | No especificado | No especificado |
| Mascotas: perros | No especificado | No especificado (cantidad, razas permitidas/restringidas) |
| Mascotas: gatos | No especificado | No especificado |
| Mascotas: otras (aves, peces, reptiles, etc.) | No especificado | No especificado |
| Restricciones de mascotas | No especificado | Responsabilidad en zonas comunes |
| Cohabitantes máximos | No especificado | No especificado |
| Bebés (0-2 años) | No especificado | No especificado |
| Niños (3-12 años) | No especificado | No especificado |
| Adolescentes (13-17 años) | No especificado | No especificado |
| Huéspedes temporales | No especificado (Contrato 1 prohíbe "alojar huéspedes sin permiso escrito") | No especificado |
| Subarriendo de cochera | No especificado | No especificado (Contrato 2: cochera para 2 vehículos incluida) |
| Subarriendo parcial de habitaciones | No (Cláusula CUARTA: no consignar, ceder, realquilar) | No (contrato personalísimo) |
| Cesión total del contrato a tercero | No (Cláusula CUARTA) | No (Cláusula QUINTA: no traspasar ni ceder en forma alguna) |

### Datos del propietario (verificación obligatoria)

- Nombre completo
- Cédula de identidad (validada contra SINPE)
- Prueba de dominio del inmueble: certificación digital de propiedad emitida por [RNP Digital](https://www.rnpdigital.com/shopping/login.jspx) (costo ~₡1,500; confirma titularidad, número de finca, y gravámenes)
- Cuenta bancaria para recibir pagos (IBAN o SINPE)
- Teléfono de contacto

### Datos del arrendador/gestor (si aplica, cuando no es el propietario directo)

- Nombre completo
- Cédula de identidad (validada contra SINPE)
- Poder de administración otorgado por el propietario (documento legal que lo autoriza a gestionar el inmueble)
- Alcance del poder (puede firmar contratos / solo gestionar visitas y negociación / administración completa)
- Teléfono de contacto

### Pasos

1. Propietario crea cuenta y verifica identidad
2. Propietario registra el inmueble con fotos, distribución, y ubicación
3. Propietario define **rangos de negociación**:
   - Precio mínimo aceptable / precio publicado
   - Duración mínima / máxima del contrato
   - Condiciones no negociables (mascotas, subarriendo, modificaciones)
   - Monto del depósito de garantía
4. Propietario selecciona plan de suscripción (Básico / Profesional / Empresarial)
5. Plataforma valida la información y activa el listado
6. Propiedad aparece en resultados de búsqueda

### Criterios de validación

- [ ] Mínimo 5 fotos del inmueble
- [ ] Video tour grabado (mín. 2 min, todos los espacios) o tour en vivo disponible
- [ ] Dimensiones de cada dormitorio en metros (obligatorio) — largo × ancho en metros, con capacidad real (qué muebles caben)
- [ ] Dimensiones del resto de espacios (recomendado)
- [ ] Área total del inmueble en m²
- [ ] Dirección verificable
- [ ] Precio dentro del rango de mercado de la zona
- [ ] Identidad del propietario verificada

---

## Fase 2: Descubrimiento

> **Problema que resuelve:** Búsqueda fragmentada en 25+ grupos de Facebook, Encuentra24, Marketplace — sin filtros reales de presupuesto. "De 2 meses a <1 semana de búsqueda" — [Propuesta de Valor](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/04-propuesta-unica-de-valor.md)

### Objetivo
El inquilino encuentra propiedades que se ajustan a su presupuesto, zona, y necesidades.

### Pasos

1. Inquilino crea cuenta y verifica identidad
2. Inquilino configura filtros:
   - Rango de presupuesto (ej: ₡200,000 - ₡350,000)
   - Zona geográfica (provincia, cantón, distrito)
   - Número de habitaciones
   - Mascotas (sí/no)
   - Estacionamiento
3. Plataforma muestra resultados filtrados y ordenados por relevancia
4. Inquilino guarda favoritos y compara opciones

---

## Fase 3: Video Tour y Visita Presencial

### 3.1 Video Tour (pre-filtro remoto)

#### Objetivo
Permitir al inquilino evaluar el inmueble remotamente antes de invertir tiempo en una visita presencial.

#### Requisitos del propietario al listar (obligatorio)

El propietario debe subir **al menos uno** de los siguientes al momento de publicar (Fase 1):

| Formato | Requisitos mínimos |
|---------|-------------------|
| **Video tour grabado** | Recorrido continuo de todos los espacios (sin cortes que oculten áreas), mínimo 2 minutos, máximo 10 minutos, resolución mínima 720p, audio ambiente (sin música superpuesta) |
| **Tour en vivo programado** | Videollamada dentro de la app donde el propietario muestra el inmueble en tiempo real; el inquilino puede pedir que enfoque áreas específicas |

#### Pasos

1. Inquilino revisa las fotos del listado y solicita ver el video tour
2. Si es video grabado: disponible inmediatamente en el listado
3. Si es tour en vivo: inquilino agenda horario dentro de la app
4. Inquilino evalúa el video tour y decide:
   - **Interesado** → solicita visita presencial (pasa a 3.2)
   - **Descartado** → marca como "no interesado" con motivo (feedback para el propietario)

#### Reglas

- El video tour es **obligatorio** para que el listado se active — no se puede publicar sin al menos un video o tour en vivo disponible
- El video debe mostrar **todos** los espacios declarados en la distribución (Fase 1); si la distribución dice "patio" y el video no lo muestra, la plataforma alerta al propietario
- El propietario puede actualizar el video en cualquier momento

### 3.2 Visita Presencial

#### Objetivo
El inquilino verifica en persona el estado real del inmueble después de haber aprobado el video tour.

#### Pasos

1. Inquilino solicita visita presencial (solo habilitado después del video tour)
2. Plataforma muestra horarios disponibles del propietario/arrendador
3. Inquilino elige horario y confirma
4. Plataforma notifica al propietario/arrendador
5. Ambas partes reciben recordatorio 24h y 1h antes de la visita
6. Visita presencial se realiza
7. Post-visita: inquilino marca la propiedad como "visitada" (habilita la negociación)

#### Reglas

- Solo se puede iniciar negociación DESPUÉS de marcar la visita presencial como realizada
- Máximo 3 visitas presenciales activas simultáneas por inquilino (prevenir acaparamiento)
- No-show del inquilino sin cancelación previa (24h): alerta al propietario + registro en el perfil del inquilino

---

## Fase 4: Negociación

> **Problema que resuelve:** "Cada propietario inventa su propio proceso por WhatsApp, hace preguntas invasivas, discrimina a freelancers/solteras/personas con mascotas" — [Problemática #2](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/01-problematica.md). La negociación estandarizada elimina discriminación y da transparencia total.

### Objetivo
Inquilino y propietario negocian los términos del contrato dentro de la plataforma mediante propuestas y contrapropuestas estructuradas.

### Catálogo de opciones de la plataforma

Valores predefinidos que la plataforma ofrece para cada campo. El propietario selecciona al publicar (Fase 1) y el inquilino los ve antes de negociar.

| Campo | Opciones disponibles |
|-------|---------------------|
| **Tipo de inmueble** | Casa independiente / Apartamento en edificio / Apartamento en condominio / Townhouse / Casa en condominio / Estudio (monoambiente) / Cuarto en casa compartida |
| **Tipo de piso** | Cerámica / Porcelanato / Madera / Laminado / Concreto pulido / Terrazo / Vinilo |
| **Tipo de cielo raso** | Concreto / Gypsum / Madera / Tablilla / Lámina / Sin cielo raso |
| **Estado de pintura** | Pintura reciente / Buen estado / Requiere retoque / Sin pintar |
| **Tipo de cocina** | Sin amueblar / Con muebles de cocina / Con muebles y electrodomésticos básicos (cocina, refrigeradora) / Totalmente equipada |
| **Proveedor de agua** | AyA / ASADA / Pozo propio / Otro |
| **Tipo de medidor (agua)** | Individual / Compartido |
| **Tipo de medidor (electricidad)** | Individual / Compartido |
| **Método de división de medidor compartido** | División equitativa (total ÷ unidades) / División por consumo (sub-medidores o lectura periódica) / Monto fijo mensual acordado / Incluido en la renta |
| **Tipo de conexión a internet disponible** | Fibra óptica (FTTH) / Cable coaxial (HFC) / ADSL (línea telefónica) / Internet inalámbrico fijo (WiMAX/LTE) / Satelital / Sin cobertura de internet fijo / No verificado |
| **Proveedor de internet preinstalado** | Kolbi (ICE) / Tigo / Claro / Liberty / Cabletica / Otro / Ninguno (inquilino contrata) |
| **Velocidad de internet preinstalado** | Especificar Mbps de descarga (ej: 10, 50, 100, 300) / No aplica |
| **Pago de servicio (internet, cable, teléfono, gas, basura)** | Incluido en renta / Por cuenta del inquilino / No deseado por el inquilino / No aplica |
| **Paquete combinado preinstalado** | Inquilino asume todo el paquete / Inquilino asume solo los servicios que desea (propietario cubre o cancela el resto) / Propietario cancela el paquete (inquilino contrata aparte) / Propietario mantiene el paquete a su costo (inquilino contrata servicio adicional propio) |
| **Sistema de agua caliente** | Agua fría solamente / Calentador eléctrico 110V / Calentador eléctrico 220V / Termo ducha / Tanque central eléctrico / Tanque central a gas / Panel solar térmico / Caldera centralizada del edificio |
| **Tipo de estacionamiento** | Techado exclusivo / Descubierto exclusivo / Compartido techado / Compartido descubierto / En calle (sin garantía) / No disponible |
| **Seguridad del inmueble** | Verjas en ventanas / Portón con candado / Portón eléctrico / Cámaras de seguridad / Sistema de alarma / Vigilancia 24h (condominio) / Ninguna |
| **Mascotas: perros** | No permitidos / Sí, razas pequeñas (hasta 10 kg) / Sí, razas medianas (10-25 kg) / Sí, cualquier raza / Sí, con restricciones específicas (detallar) |
| **Mascotas: gatos** | No permitidos / Sí, solo interior / Sí, interior y exterior |
| **Mascotas: otras** | No permitidas / Aves / Peces / Reptiles / Roedores (hámster, conejo) / Otro (especificar) |
| **Huéspedes temporales** | No permitidos / Permitidos con aviso previo / Permitidos sin restricción / Permitidos con duración máxima (especificar días) |
| **Restricciones de ruido** | Solo límites legales del Ministerio de Salud (día 65 dB, noche 40 dB) / Restricciones adicionales pactadas (especificar horarios y condiciones) |
| **Modificaciones al inmueble** | No permitidas / Solo leves con aviso previo / Leves y moderadas con autorización escrita / Todas con autorización escrita |
| **Actividad comercial menor** | No permitida / Permitida con restricciones (especificar tipo, horario, afluencia) |
| **Subarriendo de cochera** | No permitido / Permitido con autorización / Permitido libremente |
| **Subarriendo parcial de habitaciones** | No permitido / Permitido con autorización y límite de habitaciones |
| **Cesión total del contrato** | No permitida / Permitida con autorización escrita |

### Términos negociables

| Término | Referencia legal | Comportamiento en la negociación |
|---------|-----------------|-------------------------------|
| **Precio mensual** | Cláusula SEGUNDA (Contrato 1) / TERCERA (Contrato 2) | Propuesta dentro del rango publicado |
| **Depósito de garantía** | Cláusula TERCERA (Contrato 1) / DÉCIMA SEGUNDA (Contrato 2) | Mínimo legal: 1 mes de renta |
| **Duración del contrato** | Cláusula PRIMERA (Contrato 1) / CUARTA (Contrato 2) | Libre acuerdo de las partes; si es menor a 3 años, la plataforma muestra aviso legal (ver nota abajo) |
| **Fecha de inicio** | Derivada de la firma | Propuesta por el inquilino |
| **Día de pago mensual** | "los días 30" (Contrato 1) / "los quince" (Contrato 2) | Acuerdo de ambas partes |
| **Mascotas: perros** | No regulado por ley | Sí/No + cantidad máxima + razas restringidas |
| **Mascotas: gatos** | No regulado por ley | Sí/No + cantidad máxima |
| **Mascotas: otras** | No regulado por ley | Sí/No + tipo (aves, peces, reptiles) + cantidad |
| **Restricciones de mascotas** | No regulado por ley | Condiciones especiales (zonas comunes, tamaño, peso máximo) |
| **Cohabitantes máximos** | No regulado por ley | Número máximo de personas que habitarán el inmueble |
| **Bebés (0-2 años)** | No regulado por ley | Sí/No + cantidad |
| **Niños (3-12 años)** | No regulado por ley | Sí/No + cantidad |
| **Adolescentes (13-17 años)** | No regulado por ley | Sí/No + cantidad |
| **Huéspedes temporales** | No regulado por ley; Contrato 1 prohíbe alojar huéspedes sin permiso escrito | Sí/No + duración máxima + requiere aviso previo (Sí/No) |
| **Subarriendo de cochera** | Art. 78 Ley 7527 | Sí/No + condiciones (vecinos del complejo, monto compartido, horario) |
| **Subarriendo parcial de habitaciones** | Art. 78 Ley 7527 | Sí/No + cantidad máxima de habitaciones |
| **Cesión total del contrato** | Art. 78 Ley 7527 | Sí/No (generalmente No) |
| **Actividad comercial menor** | Art. 12 Ley 7527 (destino doble) | Sí/No + tipo de actividad + restricciones de horario y afluencia |
| **Modificaciones leves** | Cláusula QUINTA (C1) / OCTAVA (C2) | Sí/No + aviso previo (Sí/No) + restaurar al entregar (Sí/No) |
| **Modificaciones moderadas** | Cláusula QUINTA (C1) / OCTAVA (C2) | Sí/No + autorización escrita + supervisión del propietario (Sí/No) |
| **Modificaciones estructurales** | Art. 49 Ley 7527 / Cláusula OCTAVA (C2) | Siempre requiere autorización escrita; mejoras quedan a favor del inmueble (Art. 37) |
| **Sistema de agua caliente** | No regulado por ley | Inquilino acepta el actual / Propietario mejora antes del ingreso / Inquilino instala a su costo con autorización |
| **Restricciones de ruido** | Reglamento Control de Ruido (Min. Salud, 2024) | Solo límites legales / Restricciones adicionales pactadas |
| **Servicio: agua** | Cláusula SERVICIOS (C1) / DÉCIMA PRIMERA (C2) | Según tipo de medidor y método de división (ver catálogo) |
| **Servicio: electricidad** | Cláusula SERVICIOS (C1) / DÉCIMA PRIMERA (C2) | Según tipo de medidor y método de división (ver catálogo) |
| **Servicio: internet** | No regulado por ley | Según opciones de pago (ver catálogo) |
| **Servicio: cable TV** | No regulado por ley | Según opciones de pago (ver catálogo) |
| **Servicio: teléfono fijo** | No regulado por ley | Según opciones de pago (ver catálogo) |
| **Servicio: gas** | No regulado por ley | Según opciones de pago (ver catálogo) |
| **Servicio: recolección de basura** | Cláusula DÉCIMA (C2) | Según opciones de pago (ver catálogo) |
| **Paquete combinado preinstalado** | No regulado por ley | Según escenarios de paquete (ver catálogo) |
| **Incremento anual** | Art. 67 Ley 7527 | Máximo = IPC anual del INEC; se puede pactar menor pero NUNCA mayor (Art. 68, nulo de pleno derecho); si renta en moneda extranjera, no hay reajuste |
| **Condiciones especiales** | Texto libre | Ambas partes proponen |

### Términos no negociables (fijados por ley o plataforma)

| Término | Base legal | Valor fijo |
|---------|-----------|------------|
| Uso principal como vivienda | Art. 4 y 12 Ley 7527 | Siempre; se permite destino doble (vivienda + comercio menor) si el uso principal sigue siendo vivienda |
| Prohibición de subarriendo sin autorización | Art. 78 Ley 7527 / Cláusulas CUARTA y QUINTA de contratos ref. | Siempre |
| Conservación del inmueble | Art. 44 inc. c) Ley 7527 | Obligación del inquilino |
| Devolución en mismo estado | Art. 44 inc. d) Ley 7527 | Obligación del inquilino |
| Depósito en custodia (escrow) | Política HabitaNexus | Siempre vía plataforma |
| Inspección periódica | Cláusula NOVENA (Contrato 2) | Según acuerdo |

### Máquina de estados de la negociación

```
PROPUESTA_ENVIADA → CONTRAPROPUESTA → [iteración] → ACUERDO_ALCANZADO → PENDIENTE_FIRMA
                                                   → RECHAZADA
                                    → EXPIRADA (timeout 72h sin respuesta)
```

### Pasos

1. Inquilino envía propuesta inicial con valores para cada término negociable
2. Propietario recibe notificación con la propuesta detallada
3. Propietario puede:
   - **Aceptar**: flujo pasa a Fase 5 (Contrato)
   - **Contraproponer**: modifica uno o más términos y envía de vuelta
   - **Rechazar**: termina la negociación con motivo
   - **No responder**: timeout de 72 horas, la propuesta expira
4. Inquilino recibe contrapropuesta y tiene las mismas opciones
5. Máximo 5 rondas de negociación antes de cierre forzado
6. Al alcanzar acuerdo, plataforma genera resumen de términos pactados
7. Ambas partes confirman el resumen → estado PENDIENTE_FIRMA

### Reglas de negocio

- El precio propuesto debe estar dentro del rango publicado por el propietario
- El depósito no puede ser menor a 1 mes de renta
- **Duración del contrato**: las partes pueden pactar libremente la duración. Sin embargo, si la duración pactada es menor a 3 años, la plataforma debe mostrar el siguiente aviso legal antes de confirmar:

  > **Aviso legal (Art. 70 y 71, Ley 7527):** La Ley General de Arrendamientos establece un plazo mínimo de 3 años. Los contratos con plazo inferior se entienden legalmente como contratos de 3 años. Si el propietario no notifica su voluntad de no renovar con al menos 3 meses de anticipación, el contrato se renueva automáticamente por 3 años más. Ambas partes aceptan conocer esta disposición.

- Todas las propuestas y contrapropuestas quedan registradas como historial auditable
- Calculadora en tiempo real muestra el costo total: (renta × duración) + depósito + servicios

---

## Fase 5: Contrato y Firma Digital

### Objetivo
Generar el contrato de arrendamiento legal basado en los términos negociados, firmarlo digitalmente, y procesar el depósito de garantía.

### Estructura del contrato generado

El contrato sigue la estructura de la Ley 7527 e incorpora las cláusulas observadas en los contratos de referencia:

| # | Cláusula | Contenido | Fuente |
|---|----------|-----------|--------|
| 1 | **Objeto del contrato** | Descripción del inmueble, ubicación, uso exclusivo como vivienda | Art. 4 Ley 7527 / Cláusula PRIMERA Contrato 2 |
| 2 | **Descripción del inmueble** | Distribución, estado, inventario de accesorios | Cláusula SEGUNDA Contrato 2 |
| 3 | **Precio de alquiler** | Monto mensual, día de pago, cuenta bancaria del propietario, métodos aceptados (SINPE, transferencia) | Cláusula SEGUNDA Contrato 1 / TERCERA Contrato 2 |
| 4 | **Depósito de garantía** | Monto, condiciones de retención y devolución, custodia vía escrow HabitaNexus | Cláusula TERCERA Contrato 1 / DÉCIMA SEGUNDA Contrato 2 |
| 5 | **Duración del contrato** | Fecha inicio, fecha fin según acuerdo de las partes, aviso legal si plazo < 3 años (Art. 70), condiciones de prórroga tácita (3 años, Art. 71), aviso de no renovación (3 meses antes) | Cláusula PRIMERA Contrato 1 / CUARTA Contrato 2 |
| 6 | **Uso del inmueble** | Vivienda exclusiva, prohibición de subarriendo, no modificaciones sin autorización | Cláusula CUARTA Contrato 1 / PRIMERA y QUINTA Contrato 2 |
| 7 | **Conservación** | Inquilino recibe y devuelve en mismo estado, salvo desgaste normal | Cláusula QUINTA Contrato 1 / SEXTA Contrato 2 |
| 8 | **Riesgos y daños** | Obligación de notificar daños inmediatamente | Cláusula SÉTIMA Contrato 2 |
| 9 | **Cambios y mejoras** | Prohibido sin consentimiento escrito; mejoras quedan a favor del inmueble | Cláusula QUINTA Contrato 1 / OCTAVA Contrato 2 |
| 10 | **Inspección** | Derecho del propietario a inspeccionar, frecuencia pactada, plazo para corregir hallazgos | Cláusula NOVENA Contrato 2 |
| 11 | **Pago de impuestos** | Impuestos municipales y mantenimiento de áreas comunes por cuenta del propietario | Cláusula DÉCIMA Contrato 2 |
| 12 | **Pago de servicios** | Servicios públicos (electricidad, agua, internet, cable) por cuenta del inquilino, salvo lo pactado | Cláusula SERVICIOS Contrato 1 / DÉCIMA PRIMERA Contrato 2 |
| 13 | **Deberes del inquilino** | Mantener limpio, no subarrendar, orden público, no sustancias peligrosas | Cláusula SEXTA Contrato 1 / DÉCIMA TERCERA Contrato 2 |
| 14 | **Deberes del propietario** | Reparaciones estructurales, tuberías, filtraciones (excepto si causadas por inquilino) | DÉCIMA CUARTA Contrato 2 |
| 15 | **Terminación anticipada** | Condiciones para terminación unilateral, penalidades, devolución del depósito | Cláusula SÉPTIMA Contrato 1 / DÉCIMA QUINTA Contrato 2 |
| 16 | **Incremento de renta** | Fórmula de incremento anual según Art. 67 Ley 7527 | Cláusula TERCERA Contrato 2 |
| 17 | **Notificaciones** | Medios válidos: notificación vía plataforma, correo certificado, teléfono | DÉCIMA OCTAVA Contrato 2 |
| 18 | **Cláusula penal** | Entrega de llaves, acta de inspección final, firma de ambas partes | DÉCIMA QUINTA Contrato 2 |
| 19 | **Responsabilidad civil** | Propietario no responsable por accidentes, robos, o fenómenos naturales | DÉCIMA SEXTA Contrato 2 |
| 20 | **Sistema de reclamos HabitaNexus** | Reclamos bidireccionales con fotos, plazos de respuesta, escalamiento automático | Política HabitaNexus |
| 21 | **Protocolización** | Opción de protocolizar ante notario; valor fiscal estimado | DÉCIMA SÉTIMA Contrato 2 |

### Pasos

1. Plataforma genera borrador del contrato con los términos del acuerdo de Fase 4
2. Ambas partes revisan el borrador completo dentro de la app
3. Si alguna parte solicita cambios al borrador:
   - Cambios menores (redacción) → se ajustan sin volver a negociación
   - Cambios sustanciales (precio, duración) → se reabre negociación (volver a Fase 4)
4. Ambas partes confirman el borrador final
5. **Firma digital**:
   - Inquilino firma primero
   - Propietario firma después
   - Plataforma registra timestamp, IP, y hash del documento
6. **Comisión por contrato firmado**:
   - Plataforma cobra al inquilino la comisión por transacción (~₡15,000-₡25,000, ~5-10% del primer mes)
   - El cobro se realiza como parte del proceso de firma, antes del depósito
7. **Depósito de garantía**:
   - Inquilino transfiere el depósito a cuenta escrow de HabitaNexus (procesado por Trustless Worker)
   - Plataforma confirma recepción y notifica a ambas partes
   - Depósito queda en custodia neutral hasta fin del contrato — **ni el propietario ni el inquilino lo tienen**
7. Contrato queda vigente; ambas partes reciben copia digital en PDF

### Reglas de negocio

- El contrato no se activa hasta que el depósito esté confirmado en escrow
- El contrato se genera conforme a la Ley 7527
- Cada contrato tiene un número único de referencia
- El documento firmado es inmodificable (hash SHA-256)

---

## Fase 6: Convivencia

> **Problema que resuelve:** "Propietarios trasladan costos de mantenimiento (goteras, electricidad, pintura), no devuelven depósito de garantía, prohíben visitas familiares en emergencias" — [Problemática #3](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/01-problematica.md). El sistema de reclamos bidireccional es la funcionalidad que convierte a HabitaNexus de un marketplace en una **plataforma de gestión de la relación arrendador-inquilino**.

### Objetivo
Gestionar la relación arrendador-inquilino durante la vigencia del contrato: pagos, inspecciones, reclamos, y comunicación.

### 6.1 Pagos de Alquiler

| Concepto | Detalle |
|----------|---------|
| Frecuencia | Mensual |
| Día de pago | Según lo pactado en contrato (ej: día 15 o día 30) |
| Método | Red SINPE interbancaria vía Kindo (sin límite de monto, supera restricción de ₡100,000 de SINPE Móvil) |
| Cobro | Por "mes habitado" (no por adelantado, salvo el primer pago según contrato) |
| Incremento anual | Según IPC del INEC (Art. 67 Ley 7527); cualquier reajuste superior es nulo de pleno derecho (Art. 68) |

**Flujo de pago mensual:**

1. Plataforma envía recordatorio 5 días antes del vencimiento
2. Inquilino autoriza el pago dentro de la app
3. Pago se procesa vía red SINPE interbancaria
4. Plataforma retiene comisión y transfiere el neto al propietario
5. Ambas partes reciben comprobante digital
6. Si el pago no se realiza en la fecha:
   - Día 1 de atraso: notificación urgente al inquilino
   - Día 5: notificación al propietario
   - Día 15: habilitación de causal de terminación (Art. 114 inc. a, Ley 7527)

### 6.2 Inspecciones

Basado en el Art. 51 Ley 7527 y la Cláusula NOVENA del Contrato 2:

1. **Frecuencia legal**: 1 vez al mes o cuando las circunstancias lo ameriten (Art. 51 inc. a)
2. Propietario agenda inspección vía plataforma (en horas del día)
3. Inspección se realiza en presencia del inquilino o, en su defecto, de persona mayor de edad presente
4. Propietario puede hacerse acompañar por ingeniero civil, arquitecto u otro técnico (Art. 51 inc. b)
5. Durante la inspección: se pueden tomar fotos, trazar planos, y anotar daños/deterioros
6. Post-inspección: propietario registra hallazgos con fotos en la plataforma
7. Si hay hallazgos que requieren corrección:
   - Inquilino tiene 30 días para corregir (Cláusula NOVENA Contrato 2)
   - Si no corrige → causal de terminación por incumplimiento (Art. 114 inc. b)
8. Si el inquilino **no permite** la inspección tras 2 requerimientos formales → causal de resolución del contrato (Art. 51 inc. c)

### 6.3 Sistema de Reclamos Bidireccional

Cualquiera de las partes puede abrir un reclamo:

**Reclamos del inquilino → propietario** (base: Cláusula DÉCIMA CUARTA Contrato 2):
- Fugas de agua / reventaduras en tuberías
- Fallas en instalación eléctrica / caja de breakers
- Pintura deteriorada por humedad o defectos de construcción
- Problemas en cerámica o pisos
- Plagas o problemas sanitarios
- Filtraciones en techos o paredes
- Cualquier reparación estructural que corresponda al propietario

**Reclamos del propietario → inquilino** (base: Cláusula DÉCIMA TERCERA Contrato 2):
- Ruido excesivo o molestias a vecinos
- Falta de limpieza o mantenimiento básico
- Daños a la propiedad (paredes, pisos, accesorios)
- Mascotas no autorizadas en el contrato
- Subarriendo no autorizado
- Almacenamiento de sustancias peligrosas (Cláusula SEXTA Contrato 1)
- Incumplimiento de condiciones pactadas

**Máquina de estados:**

```
CREADO (con fotos + descripción)
  → EN_REVISIÓN (contraparte notificada, 5 días para responder)
    → ACEPTADO (contraparte reconoce responsabilidad)
      → RESUELTO (reparación/corrección con evidencia fotográfica)
    → DISPUTADO (contraparte rechaza)
      → MEDIACIÓN (mediador neutral asignado)
        → RESUELTO
        → ESCALADO (mediación no exitosa)
    → ESCALADO (timeout sin respuesta)
      → CALIFICACIÓN_NEGATIVA (automática)
```

### 6.4 Comunicación

- Todo canal de comunicación queda dentro de la plataforma
- Historial completo de mensajes asociado al contrato
- Notificaciones vía push y correo electrónico
- Medios válidos de notificación legal: vía plataforma, correo certificado, teléfono registrado (Cláusula DÉCIMA OCTAVA Contrato 2)

---

## Fase 7: Renovación o Terminación

### 7.1 Renovación

Basado en la Cláusula CUARTA del Contrato 2:

1. 4 meses antes del vencimiento: plataforma notifica a ambas partes del vencimiento próximo
2. 3 meses antes (plazo legal): el arrendador debe notificar si **no** desea renovar (Art. 71 Ley 7527 — "Prórroga tácita")
   - **Renovar explícitamente**: se abre mini-negociación para nuevos términos (precio con reajuste IPC, duración)
   - **No renovar**: se inicia flujo de terminación (prevención de desalojamiento, Art. 101)
3. Si el arrendador **no notifica** la voluntad de no renovar con 3 meses de anticipación → contrato se prorroga automáticamente por **3 años** (Art. 71 Ley 7527)
4. Nuevos términos se formalizan como adenda al contrato original

### 7.2 Terminación Ordinaria (Fin de Plazo)

Basado en las Cláusulas SÉPTIMA (Contrato 1) y DÉCIMA QUINTA (Contrato 2):

1. Inquilino notifica fecha de desocupación
2. Se agenda **inspección final** del inmueble:
   - Propietario e inquilino presentes
   - Registro fotográfico del estado de entrega
   - Se levanta **acta de entrega** firmada por ambas partes
   - Se compara estado actual vs. estado documentado al inicio del contrato
3. Inquilino entrega llaves (primer día hábil después de la terminación)
4. **Liquidación del depósito**:
   - Si no hay daños ni deudas pendientes: depósito se libera completo al inquilino en máximo 30 días
   - Si hay daños: propietario presenta reclamo con evidencia fotográfica → se descuenta del depósito
   - Si hay servicios pendientes (agua, electricidad, internet): se descuentan del depósito
   - Si deudas superan el depósito: inquilino debe cubrir la diferencia
5. Plataforma ejecuta la liberación del escrow según la liquidación
6. Ambas partes se califican mutuamente (1-5 estrellas + comentario)

### 7.3 Terminación Anticipada

| Escenario | Iniciador | Consecuencia del depósito | Base legal |
|-----------|-----------|--------------------------|-----------|
| Inquilino desea salir antes del plazo | Inquilino | Depósito no reembolsable (penalidad) | Cláusula SÉPTIMA Contrato 1 |
| Propietario necesita el inmueble para uso propio | Propietario | Depósito devuelto completo + preaviso 3 meses | Art. 100-101 Ley 7527 / DÉCIMA NOVENA Contrato 2 |
| Incumplimiento del inquilino (no pago, daños) | Propietario | Depósito retenido para cubrir daños/deudas; intimación previa 30 días (Art. 116) | Art. 114 Ley 7527 |
| Incumplimiento del propietario (no repara, perturba) | Inquilino | Depósito devuelto completo | Art. 115 Ley 7527 |
| Acuerdo mutuo | Ambos | Según acuerdo firmado por ambas partes | Libre voluntad |

### Pasos para terminación anticipada

1. Parte iniciadora notifica vía plataforma con motivo documentado
2. Plataforma clasifica el tipo de terminación
3. Se aplican las reglas de depósito según tabla
4. Se agenda inspección final (mismos pasos que terminación ordinaria)
5. Liquidación y liberación de escrow
6. Calificaciones mutuas

---

## Resumen de Tiempos

| Fase | Duración estimada | SLA |
|------|-------------------|-----|
| Listado | 1-2 días | Validación en máximo 48h |
| Descubrimiento | Variable (inquilino) | — |
| Video tour | 0-1 días | Video disponible al publicar; tour en vivo en máximo 48h |
| Visita presencial | 1-3 días | Visita en máximo 7 días desde solicitud |
| Negociación | 3-5 días | Máximo 5 rondas, timeout 72h por ronda |
| Contrato y firma | 1-2 días | Depósito confirmado en máximo 24h |
| Convivencia | Duración del contrato | Pagos: día pactado; Reclamos: 5 días para respuesta |
| Terminación | 15-30 días | Liberación de depósito en máximo 30 días |

**Tiempo total de búsqueda a firma: 5-12 días** (vs. 30-60 días del proceso tradicional)

---

## Apéndice A: Checklist de Documentos por Fase

### Propietario debe proveer:
- [ ] Cédula de identidad
- [ ] Prueba de propiedad del inmueble
- [ ] Fotos del inmueble (mínimo 5)
- [ ] Video tour grabado o tour en vivo disponible
- [ ] Cuenta bancaria verificada (IBAN)
- [ ] Términos de negociación (rangos de precio, duración, condiciones)

### Inquilino debe proveer:
- [ ] Cédula de identidad
- [ ] Comprobante de ingresos (empleo, freelance, o alternativo)
- [ ] Referencias (opcional, mejora perfil)

### Generados por la plataforma:
- [ ] Contrato de arrendamiento digital (PDF con hash SHA-256)
- [ ] Acta de entrega del inmueble (inicio)
- [ ] Comprobantes de pago mensuales
- [ ] Historial de reclamos y resoluciones
- [ ] Acta de inspección final (terminación)
- [ ] Liquidación del depósito

---

## Apéndice B: Artículos Clave de la Ley 7527

| Artículo | Tema | Aplicación en HabitaNexus |
|----------|------|--------------------------|
| Art. 2 | Imperatividad | Ley es de orden público; cláusulas contrarias son nulas |
| Art. 4 | Ámbito de aplicación | Rige todo contrato de arrendamiento de inmuebles para vivienda |
| Art. 44 | Obligaciones del arrendatario | Pagar renta, conservar bien, restituir al final, usar para destino convenido |
| Art. 51 | Inspección del bien | 1 vez/mes, con fotos; 2 negativas = causal de resolución |
| Art. 67 | Reajuste del precio para vivienda | Anual, según IPC del INEC; reajuste superior es nulo (Art. 68) |
| Art. 70 | Plazo mínimo | 3 años por ley; la plataforma permite pactar menos pero muestra aviso legal |
| Art. 71 | Prórroga tácita | 3 años automáticos si el arrendador no notifica 3 meses antes |
| Art. 78 | Prohibición de subarriendo | No ceder, subarrendar ni dar en uso sin autorización escrita |
| Art. 100-101 | Necesidad del inmueble por el propietario | Solo para uso propio o familiares; preaviso 3 meses |
| Art. 113 | Causas de extinción del contrato | Nulidad, rescisión, pérdida, expiración, expropiación, etc. |
| Art. 114 | Resolución por incumplimiento del inquilino | Falta de pago, no conservar, cambio destino, no permitir inspección, daños |
| Art. 115 | Resolución por incumplimiento del arrendador | No entregar en buen estado, no reparar, perturbaciones, no pagar servicios |
| Art. 116 | Intimación | Antes de demandar, intimar al incumplidor con 30 días para cumplir |
