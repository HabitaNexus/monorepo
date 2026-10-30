# SOP — Adiciones para Internacionalización

> Disposiciones legales de Colombia y México que **no existen** en el SOP actual (basado en la Ley 7527 de Costa Rica) y que deberían agregarse si HabitaNexus se expande a estos mercados.

**Fecha:** 2026-04-12
**Leyes analizadas:**
- **Colombia:** Ley 820 de 2003 — Régimen de Arrendamiento de Vivienda Urbana
- **México:** Código Civil de la Ciudad de México (reformas 2024-2025), Código Civil Federal, LISR, CNPCF 2023

**Criterio de inclusión:** Solo se documentan disposiciones que requieren **cambios funcionales** al SOP. No se repiten temas que ya cubre la Ley 7527 (plazo mínimo, incremento por IPC, prohibición de subarriendo, obligaciones básicas del inquilino/propietario, causales de terminación, inspección, prórroga tácita).

---

## Resumen: 15 adiciones necesarias

| # | Adición | Colombia | México | Fase del SOP afectada |
|---|---------|:--------:|:------:|----------------------|
| 1 | Tope al canon inicial (% del valor del inmueble) | Art. 18 | — | Fase 1, 4 |
| 2 | Prohibición absoluta de depósitos | Art. 16 | — | Fase 4, 5 |
| 3 | Tope al depósito (máximo 1 mes) | — | Art. 2448-E CCCDMX | Fase 4, 5 |
| 4 | Sistema de aval / fiador / póliza jurídica | — | Práctica de mercado | Fase 4, 5 (nuevo) |
| 5 | Matrícula obligatoria de arrendadores | Arts. 28-31 | — | Fase 1 |
| 6 | Registro digital obligatorio del contrato | — | Art. 2448-F CCCDMX | Fase 5 |
| 7 | Notarización obligatoria (contratos >1 año) | — | Ley de Asentamientos CDMX | Fase 5 |
| 8 | Prohibición de discriminación por mascotas/menores | — | Art. 4 Ley de Vivienda CDMX | Fase 4 |
| 9 | Derecho del tanto (preferencia de compra) | — | Art. 2448-J CCCDMX | Fase 6 (nuevo) |
| 10 | Retención de ISR por inquilino persona moral | — | Art. 116 LISR | Fase 6.1 |
| 11 | Comprobante de pago con contenido mínimo obligatorio | Art. 11 | — | Fase 6.1 |
| 12 | Reglas de servicios públicos y transferencia | Art. 15 | — | Fase 5, 6 |
| 13 | Descuento de reparaciones del canon (hasta 30%) | Art. 27 | — | Fase 6.3 |
| 14 | Control administrativo municipal con sanciones | Arts. 32-34 | — | Fase 6.3 |
| 15 | Juicio oral de arrendamiento (2 meses de mora = desalojo) | — | Arts. 520-529 CNPCF | Fase 7 |

---

## Adición 1: Tope al canon inicial

**País:** Colombia
**Artículo:** Art. 18, Ley 820 de 2003

### Disposición

> "El precio mensual del arrendamiento será fijado por las partes en moneda legal pero no podrá exceder el uno por ciento (1%) del valor comercial del inmueble o de la parte de él que se dé en arriendo."

La estimación comercial no puede exceder **2 veces el avalúo catastral vigente**.

### Ejemplo

| Avalúo catastral | Valor comercial máximo computable | Canon máximo mensual |
|------------------|----------------------------------|---------------------|
| COP $100.000.000 | COP $200.000.000 | COP $2.000.000 |
| COP $250.000.000 | COP $500.000.000 | COP $5.000.000 |

### Diferencia con Costa Rica

La Ley 7527 no limita el canon inicial — solo regula los incrementos anuales (IPC). Colombia regula **tanto** el precio inicial como los incrementos.

### Cambio al SOP

- **Fase 1 (Listado):** El propietario debe ingresar el avalúo catastral del inmueble. La plataforma calcula automáticamente el canon máximo permitido y no permite publicar un precio superior.
- **Fase 4 (Negociación):** El rango de negociación de precio tiene un techo legal calculado.

---

## Adición 2: Prohibición absoluta de depósitos

**País:** Colombia
**Artículo:** Art. 16, Ley 820 de 2003

### Disposición

> "En los contratos de arrendamiento para vivienda urbana no se podrán exigir depósitos en dinero efectivo u otra clase de cauciones reales, para garantizar el cumplimiento de las obligaciones que conforme a la ley haya asumido el arrendatario."

La prohibición incluye:
- Depósitos directos o indirectos
- Depósitos por interpuesta persona
- Depósitos bajo denominaciones diferentes
- Depósitos en documentos distintos al contrato

### Única excepción (Art. 15)

Garantías para pago de **servicios públicos domiciliarios**, limitadas a **2 períodos consecutivos de facturación**, a favor de la empresa de servicios (no del arrendador).

### Diferencia con Costa Rica

En Costa Rica es legal y común exigir depósito (1+ meses). En Colombia está **expresamente prohibido**.

### Cambio al SOP

- **Fase 4 (Negociación):** Eliminar el campo "depósito de garantía" para Colombia.
- **Fase 5 (Contrato):** No incluir cláusula de depósito. Solo incluir garantía de servicios públicos (máx. 2 facturas).
- **Modelo de escrow:** El escrow de Trustless Worker **no aplica** en Colombia para depósitos. Se podría redirigir a la garantía de servicios públicos o a un modelo de póliza/seguro.

---

## Adición 3: Tope al depósito (máximo 1 mes)

**País:** México (CDMX)
**Artículo:** Art. 2448-E, Código Civil de la Ciudad de México

### Disposición

El depósito no puede exceder **un mes de renta**. Es un tope legal, no una práctica.

### Diferencia con Costa Rica

En Costa Rica es costumbre (no ley) pedir 1 mes. En CDMX es un límite legal. Otros estados de México pueden tener reglas diferentes.

### Cambio al SOP

- **Fase 4 (Negociación):** Validar que el depósito no exceda 1 mes de renta en CDMX. Para otros estados, verificar la legislación local.

---

## Adición 4: Sistema de aval / fiador / póliza jurídica

**País:** México
**Base legal:** Código Civil Federal (arts. 2794-2855, contrato de fianza)

### Disposición

Concepto que **no existe en Costa Rica ni Colombia**. El mercado mexicano opera con un sistema de garantías personales:

| Instrumento | Qué es | Quién paga | Costo aproximado |
|-------------|--------|-----------|-----------------|
| **Fiador/Aval** | Persona física que pone su propiedad como garantía. Debe ser propietario de inmueble libre de gravamen en la misma ciudad | Sin costo directo | Gratis (pero difícil de conseguir) |
| **Póliza jurídica** | Servicio que investiga al inquilino + cobertura legal + cobranza | Inquilino | ~$5,400 MXN por renta de $20,000/mes |
| **Fianza de afianzadora** | Producto regulado por la CNSF; cubre hasta 12 meses de impago | Inquilino | ~70% de 1 mes de renta |
| **Plataformas digitales** | Investigación + cobertura (ej. MoradaUno) | Inquilino | 25-30% de 1 mes de renta |

### Diferencia con Costa Rica

En Costa Rica la garantía es el depósito en escrow. En México el depósito es insuficiente — el mercado exige un **respaldo personal o institucional** adicional.

### Cambio al SOP

- **Fase 4 (Negociación):** Agregar campo "tipo de garantía" con opciones: fiador personal, póliza jurídica, fianza de afianzadora, o plataforma digital.
- **Fase 5 (Contrato):** Incluir datos del fiador o póliza contratada en el contrato.
- **Oportunidad de negocio:** HabitaNexus puede integrar póliza jurídica como servicio (fuente de ingreso por comisión de referencia al proveedor).

---

## Adición 5: Matrícula obligatoria de arrendadores

**País:** Colombia
**Artículos:** Arts. 28-31, Ley 820 de 2003

### Disposición

| Criterio | Obligación |
|----------|-----------|
| Persona dedicada **profesionalmente** al arrendamiento en municipios >15,000 hab. | Debe obtener matrícula |
| Propietario que celebre **más de 5 contratos** | Debe obtener matrícula |
| Quien arriende **10+ inmuebles** en un municipio | Se presume dedicado profesionalmente (presunción legal) |
| Plazo para registrarse | **10 días** desde inicio de operaciones |
| Para anunciarse | Obligatorio indicar **número de matrícula vigente** |

**Sanción por incumplimiento (Art. 34):** Multas de hasta **100 salarios mínimos mensuales legales vigentes** (~COP $130.000.000 en 2026).

### Diferencia con Costa Rica

La Ley 7527 no contempla registro de arrendadores.

### Cambio al SOP

- **Fase 1 (Listado):** Para propietarios profesionales (>5 contratos), solicitar número de matrícula vigente. La plataforma debe verificar la matrícula antes de activar el listado.

---

## Adición 6: Registro digital obligatorio del contrato

**País:** México (CDMX)
**Artículo:** Art. 2448-F reformado, Código Civil de la Ciudad de México (agosto 2024)

### Disposición

El arrendador debe registrar el contrato en un **Registro Digital del Gobierno de CDMX** en un plazo máximo de **30 días** desde la celebración. El registro es **confidencial** — solo accesible por resolución judicial.

### Diferencia con Costa Rica

No existe registro de contratos de arrendamiento en Costa Rica.

### Cambio al SOP

- **Fase 5 (Contrato):** Agregar paso post-firma: "Registrar contrato en el Registro Digital de CDMX dentro de los 30 días siguientes." La plataforma podría automatizar este registro vía API del gobierno.

---

## Adición 7: Notarización obligatoria (contratos >1 año)

**País:** México (CDMX)
**Base legal:** Ley de Asentamientos Humanos de CDMX

### Disposición

| Plazo del contrato | Requisito en CDMX |
|--------------------|--------------------|
| Menor a 1 año | Notarización **opcional** |
| Mayor a 1 año | Notarización **obligatoria** |
| Mayor a 6 años (federal) | Escritura pública para efectos contra terceros |

**Consecuencia:** Un contrato >1 año sin notarizar puede ser **anulado** y el inquilino queda libre de obligaciones.

### Diferencia con Costa Rica

En Costa Rica la protocolización es opcional (Cláusula DÉCIMA SÉTIMA del Contrato 2 de referencia).

### Cambio al SOP

- **Fase 5 (Contrato):** Para CDMX con contratos >1 año, la firma digital no es suficiente. Debe integrarse protocolización notarial como paso obligatorio. Puede ofrecerse como servicio premium.

---

## Adición 8: Prohibición de discriminación por mascotas/menores

**País:** México (CDMX)
**Artículo:** Art. 4, Ley de Vivienda de CDMX (reforma octubre 2025)

### Disposición

Es **ilegal** negar la renta por tener niños, niñas, adolescentes o mascotas. Cláusulas como "no se aceptan niños" o "no se permiten mascotas" son **nulas**. No se pueden exigir **depósitos adicionales** por mascotas. Denuncias ante el COPRED.

### Diferencia con Costa Rica

La Ley 7527 no regula discriminación en arrendamiento. "Mascotas" es un término negociable en el SOP actual.

### Cambio al SOP

- **Fase 4 (Negociación):** En CDMX, eliminar "mascotas" y "niños" como términos negociables. La plataforma debe bloquear estas condiciones y mostrar aviso legal citando la Ley de Vivienda.

---

## Adición 9: Derecho del tanto (preferencia de compra)

**País:** México
**Artículo:** Art. 2448-J, Código Civil de la Ciudad de México

### Disposición

Si el propietario decide **vender** el inmueble arrendado, el inquilino tiene **derecho preferente** para comprarlo.

| Regla | Detalle |
|-------|---------|
| Aplica desde | Firma del contrato (vivienda) |
| Plazo para ejercer | **30 días hábiles** desde la notificación |
| Notificación | Escrita con testigos o ante notario: precio, términos, condiciones |
| Si el propietario vende sin notificar | El inquilino puede **anular la venta** + daños y perjuicios |
| Múltiples inquilinos | Prioridad: (1) contrato más antiguo, (2) mayor renta, (3) mejoras útiles, (4) sorteo |

### Diferencia con Costa Rica

La Ley 7527 **no contempla** derecho de preferencia del inquilino para comprar.

### Cambio al SOP

- **Fase 6 (Convivencia):** Agregar sub-sección "6.5 Derecho del tanto". Si el propietario indica intención de venta, la plataforma debe notificar automáticamente al inquilino y abrir un plazo de 30 días hábiles.
- **Fase 5 (Contrato):** Incluir cláusula de derecho del tanto en contratos de México.
- **Oportunidad:** Facilitar la compra-venta dentro de la plataforma.

---

## Adición 10: Retención de ISR por inquilino persona moral

**País:** México
**Artículo:** Art. 116, Ley del Impuesto Sobre la Renta (LISR)

### Disposición

Cuando el **inquilino es persona moral** (empresa), debe retener **10% del monto de la renta** como pago provisional de ISR y enterarlo al SAT.

| Inquilino | Retención | Factura |
|-----------|----------|---------|
| Persona física → Persona física | No hay retención | No obligatoria (pero sí para deducir) |
| Persona física → **Persona moral** | **10% retenido** por la persona moral | CFDI obligatorio del arrendador |

El arrendador debe emitir **CFDI (factura electrónica)** por cada pago recibido.

### Diferencia con Costa Rica

En Costa Rica el inquilino paga la renta completa sin retención fiscal.

### Cambio al SOP

- **Fase 6.1 (Pagos):** Si el inquilino es persona moral, el flujo de pago debe calcular y documentar la retención del 10%. La plataforma debe integrarse con la generación de CFDI.

---

## Adición 11: Comprobante de pago con contenido mínimo obligatorio

**País:** Colombia
**Artículo:** Art. 11, Ley 820 de 2003

### Disposición

> "El arrendador estará obligado a expedir comprobante escrito en el que conste la fecha, la cuantía y el período al cual corresponde el pago."

Si el arrendador se **niega a recibir** el pago, el inquilino puede consignar en entidades autorizadas dentro de los **5 días hábiles** siguientes al vencimiento (Art. 10 — Pago por consignación extrajudicial).

### Diferencia con Costa Rica

La Ley 7527 no establece contenido mínimo obligatorio del recibo, ni mecanismo de consignación extrajudicial.

### Cambio al SOP

- **Fase 6.1 (Pagos):** Todo comprobante generado por la plataforma debe incluir: fecha, cuantía, período. En Colombia, agregar opción de consignación extrajudicial si el propietario no confirma recepción en 5 días hábiles.

---

## Adición 12: Reglas de servicios públicos y transferencia

**País:** Colombia
**Artículo:** Art. 15, Ley 820 de 2003

### Disposición

| Regla | Detalle |
|-------|---------|
| Garantía de servicios | Máximo **2 períodos consecutivos de facturación** (a favor de la empresa, no del arrendador) |
| Denuncia del contrato | El arrendador puede notificar a la empresa de servicios y queda **liberado de responsabilidad** |
| Terminación por falta de garantía | Si el inquilino no entrega la garantía de servicios en **15 días hábiles**, el arrendador puede terminar el contrato |
| Transferencia de responsabilidad | Una vez notificada la empresa, la deuda es **exclusivamente** del inquilino |

### Diferencia con Costa Rica

La Ley 7527 dice genéricamente que servicios van por cuenta del inquilino, pero no regula la transferencia formal ante la empresa.

### Cambio al SOP

- **Fase 5 (Contrato):** Agregar paso de transferencia formal de servicios públicos al inquilino con notificación a las empresas. Incluir plazo de 15 días hábiles para garantías.
- **Fase 7 (Terminación):** Verificar que los servicios estén al día antes de liberar garantías.

---

## Adición 13: Descuento de reparaciones del canon (hasta 30%)

**País:** Colombia
**Artículo:** Art. 27, Ley 820 de 2003

### Disposición

El inquilino puede descontar de la renta el costo de **reparaciones indispensables no locativas** (es decir, reparaciones que corresponden al propietario), sin exceder el **30% del canon mensual**. Los saldos se descuentan en períodos sucesivos hasta completar el monto.

### Diferencia con Costa Rica

En Costa Rica el inquilino no tiene derecho legal a descontar reparaciones de la renta. Debe reclamar y esperar.

### Cambio al SOP

- **Fase 6.3 (Reclamos):** Para Colombia, agregar estado "DESCUENTO_APLICADO" cuando un reclamo del inquilino es aceptado y el propietario no repara. La plataforma calcula automáticamente el descuento (máx. 30% del canon) y lo aplica al siguiente pago.

---

## Adición 14: Control administrativo municipal con sanciones

**País:** Colombia
**Artículos:** Arts. 32-34, Ley 820 de 2003

### Disposición

Las alcaldías municipales tienen funciones de **inspección, control y vigilancia** sobre arrendamientos. Pueden:
- Investigar y sancionar arrendadores
- Conocer controversias sobre depósitos ilegales, comprobantes, y mantenimiento
- Imponer multas de hasta **100 SMLMV** (~COP $130.000.000)
- Suspender o cancelar la matrícula del arrendador

### Diferencia con Costa Rica

En Costa Rica no existe rol administrativo municipal con potestad sancionatoria sobre arrendamientos.

### Cambio al SOP

- **Fase 6.3 (Reclamos):** Para Colombia, agregar escalamiento a la alcaldía municipal como alternativa a la mediación privada. La plataforma debe documentar reclamos en formato compatible con el proceso administrativo municipal.

---

## Adición 15: Juicio oral de arrendamiento (mora = desalojo acelerado)

**País:** México
**Artículos:** Arts. 520-529, Código Nacional de Procedimientos Civiles y Familiares (CNPCF 2023)

### Disposición

Procedimiento oral específico para disputas de arrendamiento (implementación gradual hasta abril 2027):

| Etapa | Plazo |
|-------|-------|
| Causa de desalojo | Falta de pago de **2 mensualidades** |
| Contestación de demanda | **15 días** |
| Desocupación voluntaria tras sentencia | **5 días hábiles** |
| Si hay resistencia | Desalojo con fuerza pública |
| Proceso completo estimado | 1-3 meses |

### Diferencia con Costa Rica

El proceso judicial costarricense de desahucio tiene plazos diferentes y no tiene esta estructura oral acelerada.

### Cambio al SOP

- **Fase 6.1 (Pagos):** Para México, la plataforma debe alertar al inquilino cuando acumula 2 meses de mora — citando que esto habilita el juicio oral de desalojo. Actualizar la tabla de escalamiento de mora:
  - Día 1 de atraso: notificación urgente
  - Día 30: notificación de 1 mes de mora
  - **Día 60: alerta de causal de desalojo (Art. 520 CNPCF)**

---

## Matriz de impacto por fase del SOP

| Fase | Adiciones Colombia | Adiciones México |
|------|-------------------|-----------------|
| **1. Listado** | Avalúo catastral + tope canon (1), matrícula de arrendador (5) | Constancia de predial |
| **2. Descubrimiento** | — | — |
| **3. Calendarización** | — | — |
| **4. Negociación** | Sin depósito (2), garantía de servicios (12) | Tope depósito 1 mes (3), aval/póliza (4), no discriminar mascotas/niños (8) |
| **5. Contrato** | Sin cláusula de depósito (2), transferencia servicios (12) | Registro digital 30 días (6), notarización >1 año (7), derecho del tanto (9) |
| **6. Convivencia** | Comprobante mínimo (11), descuento reparaciones 30% (13), escalamiento a alcaldía (14) | Retención ISR 10% persona moral (10), derecho del tanto si venta (9), mora 2 meses = desalojo (15) |
| **7. Terminación** | Verificar servicios al día (12) | Juicio oral acelerado (15) |

---

## Implicaciones para la arquitectura de HabitaNexus

Estas 15 adiciones sugieren que la plataforma necesita un **motor de reglas por jurisdicción**:

```
config/
├── jurisdictions/
│   ├── CR/          # Costa Rica — Ley 7527
│   │   ├── rules.yaml
│   │   └── contract-template.md
│   ├── CO/          # Colombia — Ley 820 de 2003
│   │   ├── rules.yaml
│   │   └── contract-template.md
│   └── MX-CDMX/    # México (Ciudad de México)
│       ├── rules.yaml
│       └── contract-template.md
```

Cada jurisdicción define:
- Campos obligatorios del listado
- Términos negociables vs. prohibidos
- Topes de depósito y canon
- Garantías requeridas (depósito / fiador / póliza / ninguno)
- Plantilla de contrato con cláusulas locales
- Reglas de incremento de renta
- Flujo de pagos (con/sin retención fiscal)
- Escalamiento de reclamos (mediación privada vs. alcaldía vs. PROFECO)
- Plazos procesales de desalojo
