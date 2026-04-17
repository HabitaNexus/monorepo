# SOP — Referidos a Fixii desde HabitaNexus

> Procedimiento Operativo Estandar para derivar propietarios y arrendadores de HabitaNexus hacia profesionales de reparacion en Fixii cuando se detectan necesidades de mantenimiento o reparacion en sus inmuebles.

**Version:** 1.0

**Fecha:** 2026-04-12

**App de Fixii:** [Google Play Store](https://play.google.com/store/apps/details?id=app.fixii.android)

**Referencias internas:**
- [SOP — Flujo de Arrendamiento](flujo-arrendamiento.md) (secciones 6.2 Inspecciones y 6.3 Reclamos)
- [Perfil de Jose Penaranda](../usuarios/propietario-jose-penaranda.md) — propietario que necesita fontaneros, electricistas y albaniles
- [Journey Map — Jose lista propiedad](../ux-research/journey-jose-listado-propiedad/map.json) — oportunidad identificada: "Referido a Fixii si durante la inspeccion se detectan reparaciones que Jose no puede hacer solo"
- [Fuentes de Ingresos](https://github.com/HabitaNexus/monorepo/blob/main/business/02-solucion-validacion/08-fuentes-de-ingresos.md)

---

## 1. Proposito

Jose Penaranda tiene 65 anos, es ebanista retirado y puede reparar muebles y puertas por su cuenta. Pero cuando un inquilino le taponea las tuberias del desague, revienta un llavin, o deja una fuga en el bano, Jose necesita un fontanero, un electricista o un albanil — y un sabado a las 5pm no hay como conseguir uno.

Este SOP define como HabitaNexus conecta a propietarios como Jose con profesionales de reparacion a traves de Fixii, cerrando el ciclo entre la deteccion de un problema (inspeccion o reclamo) y su resolucion documentada.

---

## 2. Momentos de Activacion del Referido

El referido a Fixii se activa en tres contextos dentro del flujo de arrendamiento:

### 2.1 Durante una inspeccion (Fase 6.2 del SOP de Arrendamiento)

| Paso del flujo de inspeccion | Accion de referido |
|------------------------------|-------------------|
| Propietario registra hallazgos con fotos en la plataforma | Si el hallazgo requiere reparacion profesional, la plataforma muestra el boton **"Buscar profesional en Fixii"** junto al hallazgo |
| Hallazgo clasificado como reparacion que corresponde al propietario (fontaneria, electricidad, albanileria, cerrajeria) | Se pre-selecciona la categoria de profesional en Fixii segun el tipo de hallazgo |
| Hallazgo clasificado como reparacion que corresponde al inquilino (dano por mal uso) | Se muestra el boton al inquilino en su vista del hallazgo |

**Ejemplo concreto:** Jose hace la inspeccion mensual. Detecta una fuga en el bano (tuberia reventada por presion, no por mal uso del inquilino). Registra el hallazgo con foto. La plataforma le sugiere: "Este tipo de reparacion requiere un fontanero. Buscar profesional en Fixii." Jose toca el boton y la app lo redirige a Fixii con la categoria "Fontaneria" pre-seleccionada.

### 2.2 Desde un reclamo bidireccional (Fase 6.3 del SOP de Arrendamiento)

| Estado del reclamo | Accion de referido |
|-------------------|-------------------|
| `CREADO` — inquilino abre reclamo por fuga de agua, falla electrica, o reparacion estructural | Se muestra el boton al propietario junto con la notificacion del reclamo |
| `ACEPTADO` — propietario acepta responsabilidad | La plataforma sugiere: "Buscar profesional en Fixii para resolver este reclamo" |
| `RESUELTO` — se sube evidencia fotografica de la reparacion | Se registra si la reparacion fue realizada via Fixii (para metricas de conversion) |

**Ejemplo concreto:** Mery (inquilina) abre un reclamo: "Falla en caja de breakers, se dispara al conectar la lavadora." Jose recibe la notificacion, acepta responsabilidad, y ve el boton: "Buscar electricista en Fixii." Contrata al profesional, sube la foto de la reparacion terminada, y el reclamo pasa a `RESUELTO`.

### 2.3 Reparaciones pre-listado (Fase 1 del SOP de Arrendamiento)

| Momento | Accion de referido |
|---------|-------------------|
| Propietario registra la propiedad por primera vez | Al subir fotos, si el propietario marca un espacio como "requiere reparacion antes de alquilar", se muestra el boton de Fixii |
| Re-listado despues de que un inquilino se va | Misma logica — los hallazgos de la inspeccion final (Fase 7.2) se pueden vincular con un referido a Fixii antes de publicar de nuevo |

**Ejemplo concreto:** El inquilino problematico de Jose se fue. La inspeccion final revela: tuberias taponeadas, llavin forzado, bano con fuga. Jose repara las puertas el mismo (ebanista), pero para la fontaneria y la cerrajeria toca el boton de Fixii.

---

## 3. Categorias de Reparacion y Mapeo a Fixii

### 3.1 Categorias que el propietario NO puede resolver solo

Basado en el perfil de Jose Penaranda y en los reclamos tipicos de la Fase 6.3:

| Categoria HabitaNexus | Tipo de profesional en Fixii | Ejemplos de hallazgos / reclamos |
|----------------------|-----------------------------|---------------------------------|
| **Fontaneria** | Fontanero / Plomero | Fuga en bano, tuberia taponeada, sanitario danado, calentador de agua |
| **Electricidad** | Electricista | Caja de breakers, cortocircuito, cableado expuesto, apagones parciales |
| **Albanileria** | Albanil | Pared agrietada, ceramica rota, humedad en paredes, filtracion en techo |
| **Cerrajeria** | Cerrajero | Llavin forzado, cerradura danada, cambio de chapa |
| **Pintura** | Pintor | Pintura deteriorada por humedad, paredes manchadas, repintado general |
| **Plagas** | Fumigador | Cucarachas, termitas, roedores, problemas sanitarios |

### 3.2 Categorias que el propietario tipo Jose puede resolver solo

| Categoria | Nota |
|-----------|------|
| **Ebanisteria / muebles** | Jose es ebanista — repara puertas, marcos, closets. No se activa el referido. |
| **Limpieza general** | Responsabilidad del inquilino segun contrato. No se activa el referido. |

### 3.3 Logica de clasificacion automatica

Cuando el propietario o inquilino registra un hallazgo o reclamo, la plataforma sugiere la categoria basandose en:

1. **Palabras clave en la descripcion**: "fuga", "tuberia", "sanitario" -> Fontaneria; "breaker", "cortocircuito", "enchufe" -> Electricidad; "llavin", "cerradura", "chapa" -> Cerrajeria
2. **Espacio del inmueble afectado**: Bano -> alta probabilidad de Fontaneria; Cocina -> Fontaneria o Electricidad; Puertas -> Cerrajeria o Ebanisteria
3. **Historial del propietario**: Si Jose ya resolvio hallazgos de puertas solo, la plataforma aprende a no sugerir Fixii para esa categoria

El propietario siempre puede cambiar la categoria sugerida o descartar el referido.

---

## 4. Flujo de Usuario en HabitaNexus

### 4.1 Ubicacion del boton de referido

```
HALLAZGO / RECLAMO REGISTRADO
  |
  v
+-----------------------------------------------------------+
|  Hallazgo #47 — Fuga en bano principal                    |
|  Categoria: Fontaneria                                    |
|  Fotos: [foto1.jpg] [foto2.jpg]                          |
|  Estado: Pendiente de reparacion                          |
|                                                           |
|  [  Buscar profesional en Fixii  ]  <-- boton principal  |
|  [  Ya tengo mi profesional      ]  <-- alternativa      |
|  [  Lo reparo yo mismo           ]  <-- descarta referido|
+-----------------------------------------------------------+
```

### 4.2 Flujo paso a paso

```
1. DETECCION
   Propietario registra hallazgo con fotos durante inspeccion
   — o —
   Inquilino abre reclamo con fotos

2. CLASIFICACION
   Plataforma sugiere categoria de reparacion
   Propietario confirma o ajusta la categoria

3. DECISION
   Propietario elige una de tres opciones:
   a) "Buscar profesional en Fixii"  --> paso 4
   b) "Ya tengo mi profesional"      --> paso 7
   c) "Lo reparo yo mismo"           --> paso 7

4. REDIRECCION A FIXII
   Se abre Fixii (deep link o Play Store si no esta instalada)
   Parametros enviados via URL:
   - Categoria pre-seleccionada (ej: fontaneria)
   - Ubicacion del inmueble (provincia, canton)
   - ID de referido HabitaNexus (para tracking)

5. CONTRATACION EN FIXII
   Propietario busca, contacta y contrata al profesional
   (este paso ocurre enteramente dentro de Fixii)

6. REPARACION COMPLETADA
   Propietario regresa a HabitaNexus
   Sube foto de la reparacion terminada

7. CIERRE DEL HALLAZGO / RECLAMO
   Hallazgo pasa a estado "Resuelto" con evidencia fotografica
   Se registra si la reparacion fue via Fixii, profesional propio, o reparacion propia
   Queda vinculado al expediente del contrato
```

### 4.3 Notificaciones

| Evento | Destinatario | Canal | Mensaje |
|--------|-------------|-------|---------|
| Hallazgo de inspeccion requiere reparacion profesional | Propietario | Push + in-app | "La inspeccion del [fecha] tiene hallazgos que requieren reparacion. Buscar profesional en Fixii." |
| Reclamo aceptado por el propietario | Propietario | Push + in-app | "Aceptaste responsabilidad por [descripcion]. Buscar profesional en Fixii para resolverlo." |
| Recordatorio: hallazgo sin resolver por 15 dias | Propietario | Push | "El hallazgo [#ID] lleva 15 dias sin reparar. El plazo de correccion son 30 dias. Buscar profesional." |
| Reclamo con timeout proximo (dia 4 de 5) | Propietario | Push urgente | "Manana vence el plazo para responder el reclamo [#ID]. Si necesitas un profesional, busca en Fixii." |

---

## 5. Modelo de Alianza con Fixii

### 5.1 Opciones de integracion

| Nivel | Mecanismo | Esfuerzo tecnico | Ingreso para HabitaNexus | Fase de implementacion |
|-------|-----------|-----------------|--------------------------|----------------------|
| **Nivel 1: Link de afiliado** | URL con parametro `?ref=habitanexus` que redirige al Play Store o al deep link de Fixii | Bajo (solo URL) | Comision por instalacion o por primer servicio contratado | MVP / Mes 1-3 |
| **Nivel 2: Deep link con contexto** | URL tipo `fixii://search?category=fontaneria&location=heredia&ref=habitanexus-{contrato_id}` | Medio (requiere acuerdo con Fixii para aceptar parametros) | Comision por servicio contratado via referido | Mes 3-6 |
| **Nivel 3: Integracion API** | API bidireccional: HabitaNexus envia solicitud de servicio, Fixii retorna estado del trabajo | Alto (requiere API publica de Fixii + desarrollo backend) | Comision + datos de conversion en tiempo real | Mes 6-12 |

### 5.2 Modelo de comision recomendado

| Concepto | Detalle |
|----------|---------|
| **Tipo** | Comision por referido exitoso (CPA — Cost Per Acquisition) |
| **Definicion de "exitoso"** | El propietario instala Fixii y contrata al menos un servicio a traves de la plataforma |
| **Monto sugerido** | 5-10% del costo del servicio contratado, o tarifa fija por referido (a negociar con Fixii) |
| **Quien paga la comision** | Fixii le paga a HabitaNexus (el propietario no paga extra) |
| **Frecuencia de liquidacion** | Mensual, basado en reporte de conversiones |

### 5.3 Propuesta de valor para Fixii

| Beneficio para Fixii | Detalle |
|---------------------|---------|
| **Leads calificados** | Los propietarios de HabitaNexus tienen una necesidad de reparacion real y documentada (foto + descripcion del hallazgo) — no es trafico generico |
| **Contexto del trabajo** | Fixii recibe la categoria, la ubicacion y la urgencia del trabajo antes de que el propietario busque — reduce friccion de busqueda |
| **Recurrencia** | Propietarios con contratos activos generan inspecciones mensuales — cada inspeccion es una oportunidad de referido |
| **Segmento desatendido** | Propietarios mayores como Jose (65 anos) no buscan profesionales en apps por cuenta propia — HabitaNexus les facilita el primer contacto con Fixii |

---

## 6. Tracking de Conversiones

### 6.1 Eventos a registrar

| Evento | Codigo | Datos capturados |
|--------|--------|-----------------|
| Boton de Fixii mostrado al usuario | `FIXII_CTA_SHOWN` | hallazgo_id, contrato_id, categoria, contexto (inspeccion / reclamo / pre-listado) |
| Boton de Fixii tocado por el usuario | `FIXII_CTA_CLICKED` | hallazgo_id, contrato_id, categoria, timestamp |
| Usuario elige "Ya tengo mi profesional" | `FIXII_CTA_DISMISSED_OWN` | hallazgo_id, contrato_id, categoria |
| Usuario elige "Lo reparo yo mismo" | `FIXII_CTA_DISMISSED_SELF` | hallazgo_id, contrato_id, categoria |
| Reparacion marcada como resuelta via Fixii | `FIXII_REPAIR_COMPLETED` | hallazgo_id, contrato_id, categoria, dias_hasta_resolucion |
| Reparacion marcada como resuelta sin Fixii | `NON_FIXII_REPAIR_COMPLETED` | hallazgo_id, contrato_id, categoria, metodo (profesional propio / reparacion propia) |

### 6.2 Metricas clave

| Metrica | Formula | Objetivo inicial |
|---------|---------|-----------------|
| **Tasa de impresion** | `FIXII_CTA_SHOWN / total_hallazgos_reparacion` | >80% (que el boton aparezca en la mayoria de hallazgos que requieren profesional) |
| **CTR del boton** | `FIXII_CTA_CLICKED / FIXII_CTA_SHOWN` | >25% |
| **Tasa de conversion** | `FIXII_REPAIR_COMPLETED / FIXII_CTA_CLICKED` | >15% |
| **Tiempo de resolucion** | Dias entre hallazgo creado y `FIXII_REPAIR_COMPLETED` | <15 dias |
| **Preferencia por Fixii vs. propio** | `FIXII_REPAIR_COMPLETED / (FIXII_REPAIR_COMPLETED + NON_FIXII_REPAIR_COMPLETED)` | >30% en Mes 6 |

### 6.3 Atribucion sin integracion API

Si Fixii no tiene API ni programa de afiliados formal (Nivel 1), se puede medir la conversion con un flujo manual:

1. Al tocar "Buscar profesional en Fixii", se registra `FIXII_CTA_CLICKED`
2. Cuando el propietario vuelve a HabitaNexus para cerrar el hallazgo, la plataforma pregunta: "Encontraste tu profesional en Fixii?" (Si / No)
3. Si responde "Si", se registra `FIXII_REPAIR_COMPLETED`
4. Esta respuesta se usa para el reporte mensual de conversiones a Fixii

---

## 7. Vinculacion con el Expediente del Contrato

### 7.1 Estructura del expediente

Cada contrato en HabitaNexus tiene un expediente digital inmutable (ver Fase 5 del SOP de Arrendamiento). Las reparaciones referidas a Fixii se integran asi:

```
EXPEDIENTE DEL CONTRATO #1234
  |
  +-- Contrato original (firmado digitalmente)
  +-- Acta de entrega inicial (fotos inmutables)
  +-- Inspecciones mensuales
  |     +-- Inspeccion 2026-05-15
  |     |     +-- Hallazgo #47: Fuga en bano
  |     |     |     +-- Fotos del hallazgo
  |     |     |     +-- Categoria: Fontaneria
  |     |     |     +-- Referido a Fixii: Si (2026-05-15)
  |     |     |     +-- Reparacion completada: 2026-05-22
  |     |     |     +-- Fotos de reparacion
  |     |     |     +-- Profesional: Via Fixii
  |     |     +-- Hallazgo #48: Puerta desalineada
  |     |           +-- Reparacion propia (propietario ebanista)
  |     +-- Inspeccion 2026-06-15
  |           +-- Sin hallazgos
  +-- Reclamos
  |     +-- Reclamo #12: Falla en breakers
  |           +-- Estado: RESUELTO
  |           +-- Referido a Fixii: Si
  |           +-- Fotos de reparacion
  +-- Adendas
  +-- Inspeccion final (al terminar contrato)
```

### 7.2 Trazabilidad de la reparacion

Cada hallazgo o reclamo que genera un referido a Fixii registra:

| Campo | Valor de ejemplo |
|-------|-----------------|
| `hallazgo_id` | #47 |
| `contrato_id` | #1234 |
| `propiedad_id` | Heredia-SanRafael-001 |
| `tipo_origen` | inspeccion / reclamo / pre-listado |
| `categoria_reparacion` | fontaneria |
| `responsable_reparacion` | propietario / inquilino |
| `metodo_reparacion` | fixii / profesional_propio / reparacion_propia |
| `fecha_deteccion` | 2026-05-15 |
| `fecha_referido_fixii` | 2026-05-15 |
| `fecha_reparacion_completada` | 2026-05-22 |
| `dias_resolucion` | 7 |
| `fotos_antes` | [foto1.jpg, foto2.jpg] |
| `fotos_despues` | [foto3.jpg, foto4.jpg] |

### 7.3 Impacto en la liquidacion del deposito

Al final del contrato (Fase 7.2 del SOP de Arrendamiento), el expediente muestra el historial completo de reparaciones:

- **Reparaciones que corresponden al propietario** (fontaneria estructural, electricidad, filtraciones): no se descuentan del deposito del inquilino. El referido a Fixii acelera la resolucion.
- **Reparaciones por dano del inquilino** (llavin forzado, sanitario roto por mal uso): se descuentan del deposito. Si el inquilino uso Fixii para reparar antes de la inspeccion final, el hallazgo queda como `RESUELTO` y no se descuenta.
- **Comparacion visual**: la inspeccion final compara fotos actuales vs. fotos del acta de entrega inicial. Las reparaciones documentadas via Fixii demuestran que el dano fue atendido.

---

## 8. Consideraciones para Jose Penaranda

El perfil de Jose define restricciones de diseno para este flujo:

| Restriccion de Jose | Implicacion para el diseno del referido |
|---------------------|----------------------------------------|
| 65 anos, letra del celular muy pequena | Boton de Fixii debe ser grande, con texto legible. No usar iconos sin texto. |
| No usa correo electronico casi | Notificaciones de reparacion pendiente via push, no por email. |
| Su esposa lo ayuda con el celular | El flujo debe funcionar si la esposa es quien toca el boton (no pedir re-autenticacion). |
| Ebanista: repara puertas y muebles solo | No mostrar referido a Fixii para categorias de ebanisteria/carpinteria. |
| "Contratar fontanero un sabado a las 5pm es imposible" | Si el hallazgo se registra fuera de horario laboral, el boton de Fixii debe indicar disponibilidad: "Buscar profesional (disponible ahora)" o "Buscar profesional (programar para manana)". |
| Desconfianza: "eso no sera una estafa?" | Mostrar que Fixii es una app verificada en Google Play con calificaciones reales. Incluir texto: "Fixii es una app costarricense de profesionales verificados." |
| Usa pickup para ir a las propiedades | La ubicacion del inmueble (ya registrada en HabitaNexus) se envia automaticamente a Fixii — Jose no tiene que escribir la direccion de nuevo. |

---

## 9. Implementacion por Fases

| Fase | Alcance | Plazo |
|------|---------|-------|
| **Fase 1 — Link basico** | Boton que abre el Play Store de Fixii con parametro `?referrer=habitanexus`. Se muestra en hallazgos de inspeccion y reclamos aceptados. Tracking manual (pregunta al cerrar hallazgo). | Mes 1-3 |
| **Fase 2 — Deep link con categoria** | Acuerdo con Fixii para aceptar deep links con categoria y ubicacion. Tracking automatico del clic. Metricas en dashboard del propietario. | Mes 3-6 |
| **Fase 3 — Integracion API** | API bidireccional: HabitaNexus envia solicitud, Fixii retorna estado. Comision automatica por referido exitoso. Comparacion visual automatica (antes/despues). | Mes 6-12 |

---

## 10. Metricas de Exito del Programa

| Metrica | Objetivo Mes 3 | Objetivo Mes 6 | Objetivo Mes 12 |
|---------|----------------|----------------|-----------------|
| Propietarios que ven el boton de Fixii al menos 1 vez | 50% de propietarios con contrato activo | 80% | 90% |
| Propietarios que tocan el boton al menos 1 vez | 10% | 25% | 40% |
| Hallazgos resueltos via Fixii | 5% del total | 15% | 30% |
| Tiempo promedio de resolucion (hallazgos con Fixii vs. sin Fixii) | Medir baseline | Fixii 20% mas rapido | Fixii 30% mas rapido |
| Ingreso por comisiones de referido (si aplica) | Medir baseline | ₡50.000/mes | ₡200.000/mes |
