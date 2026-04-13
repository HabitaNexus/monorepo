# Hallazgos de Irregularidades en Contratos Informales de Arrendamiento

> Análisis comparativo de contratos reales de arrendamiento contra la Ley 7527 — Ley General de Arrendamientos Urbanos y Suburbanos de Costa Rica.

**Fecha de análisis:** 2026-04-12
**Contratos analizados:**
- **Contrato 1** — Casa en Heredia, La Aurora. Arrendador: María del Carmen Villegas Villegas → Arrendatario: Guillermo Varela Da Silva. Fecha: 30 de mayo de 2023.
- **Contrato 2** — Apartamento No. 3, Apartamentos Las Palmas, Alajuela, Turrúcares. Arrendante: Eida Teresa Morales Arguedas → Arrendatario: Guillermo Varela Da Silva. Fecha: 9 de enero de 2024.

**Fuente legal:** [Ley 7527](references/Ley_7527.md) (131 artículos, convertida a Markdown desde el texto oficial de la PGR)

---

## Resumen Ejecutivo

| Métrica | Contrato 1 | Contrato 2 |
|---------|-----------|-----------|
| Cláusulas totales | 8 | 19 |
| Irregularidades detectadas | 4 | 2 |
| Severidad máxima | Alta (cláusula nula de pleno derecho) | Media (omisiones) |
| Cita la Ley 7527 | No | Sí (en el encabezado) |

---

## Hallazgo 1: Plazo inferior al mínimo legal

**Contrato afectado:** Contrato 1
**Severidad:** Alta — la cláusula es válida pero opera diferente a lo que dice

### Lo que dice el contrato

> **Cláusula PRIMERA — VIGENCIA:** "El presente contrato tendrá una duración de UN AÑO, voluntario para ambas partes, contando a partir de que se firme el presente contrato."

### Lo que dice la ley

> **Art. 70 — Plazo del arrendamiento:** "La duración del arrendamiento no podrá ser inferior a tres años. Se entenderán convenidos por el plazo de tres años, los arrendamientos para los que se haya estipulado una duración inferior o no se haya fijado el plazo de duración."

### Irregularidad

El contrato dice 1 año, pero legalmente opera como si dijera 3 años. María del Carmen no puede desalojar a Guillermo al cumplirse el año — tendría que esperar 3 años y notificar con 3 meses de anticipación (Art. 101).

### Riesgo para las partes

- **Para el propietario:** Puede creer que al año el inquilino debe irse, intentar un desalojo, y perder el caso judicialmente.
- **Para el inquilino:** Puede no saber que tiene derecho a quedarse 3 años y desocupar innecesariamente.

### Cómo lo resuelve HabitaNexus

La plataforma permite pactar cualquier duración, pero si es menor a 3 años, muestra un aviso legal explícito citando Art. 70 y 71 antes de la firma. Ambas partes confirman que entienden la disposición legal.

---

## Hallazgo 2: Prórroga sin respetar el plazo legal de aviso

**Contrato afectado:** Contrato 2
**Severidad:** Media — omisión que podría beneficiar al inquilino

### Lo que dice el contrato

> **Cláusula CUARTA — DURACIÓN:** "...Siendo dicho plazo prorrogable por períodos de un año, si al vencimiento del plazo fijo o de alguna de las prórrogas, una de las partes no ha notificado a la otra por escrito y con no menos de **treinta días** de anticipación, su voluntad de no continuar el arrendamiento."

### Lo que dice la ley

> **Art. 71 — Prórroga tácita:** "Habrá prórroga tácita del arrendamiento cuando el arrendador no haya notificado al arrendatario, la voluntad de no renovar el contrato, por lo menos **tres meses** antes de la expiración del plazo original o el prorrogado anteriormente. La prórroga tácita será por un nuevo período de **tres años**, cualquiera que sea el plazo inicial del contrato."

### Irregularidad

Dos discrepancias:
1. **Plazo de aviso:** El contrato dice 30 días; la ley exige 3 meses. Si el propietario notifica con 30 días de anticipación creyendo que es suficiente, la prórroga tácita ya operó.
2. **Período de prórroga:** El contrato dice "períodos de un año"; la ley dice 3 años. Incluso si el contrato dice 1 año de prórroga, legalmente la prórroga es de 3 años.

### Riesgo para las partes

- **Para el propietario:** Si notifica la no renovación con 45 días de anticipación (entre los 30 del contrato y los 90 de la ley), el contrato ya se prorrogó por 3 años. El propietario pierde el control.
- **Para el inquilino:** Si desconoce la ley, puede creer que solo tiene 30 días de gracia y desocupar prematuramente.

### Cómo lo resuelve HabitaNexus

La plataforma envía notificaciones automáticas 4 meses antes del vencimiento. El flujo de renovación usa el plazo legal de 3 meses, no el del contrato. Las notificaciones quedan registradas con timestamp como evidencia.

---

## Hallazgo 3: Depósito sin custodia neutral

**Contratos afectados:** Contrato 1 y Contrato 2
**Severidad:** Alta — origen del 3er problema más reportado por inquilinos

### Lo que dicen los contratos

**Contrato 1:**
> **Cláusula TERCERA — DEPÓSITO EN GARANTÍA:** "El depósito es de ₡300.000, dicho monto se estableció por mutuo acuerdo de esta manera pagos para el día 19 de Mayo de 2023 en su totalidad."

**Contrato 2:**
> **Cláusula DÉCIMA SEGUNDA — DEPÓSITO DE GARANTÍA:** "El monto del depósito de garantía es la suma de doscientos ochenta mil colones exactos los cuales se cancelan en un solo tracto."

### Lo que NO dice la ley (pero tampoco lo prohíbe)

La Ley 7527 **no regula explícitamente** la custodia del depósito. No dice quién lo guarda ni cómo se devuelve. El depósito va directamente al propietario.

### Irregularidad (de práctica, no de ley)

En ambos contratos, el depósito queda en manos del propietario sin mecanismo de devolución garantizado. Esto es la raíz del problema #3 identificado en la [problemática de HabitaNexus](../business/02-solucion-validacion/01-problematica.md):

> "Propietarios [...] no devuelven depósito de garantía"

**Datos del Contrato 1** que empeoran el riesgo:
> **Cláusula SÉPTIMA — TERMINACIÓN ANTICIPADA:** "...el depósito no es reembolsable, estando la casa en perfectas condiciones, esto debido al incumplimiento del plazo establecido."

Es decir, si el inquilino se va antes del año (que legalmente son 3 años), pierde el depósito **aunque la casa esté perfecta**. Esta es una penalidad por terminación anticipada que la ley no contempla explícitamente.

### Riesgo para las partes

- **Para el inquilino:** El depósito queda 100% en poder del propietario. No hay tercero neutral, no hay mecanismo de reclamación, no hay plazo legal de devolución.
- **Para el propietario:** Sin acta de entrega formal al inicio, no puede probar daños al final para justificar la retención.

### Cómo lo resuelve HabitaNexus

El depósito se procesa vía Trustless Worker (escrow). Ni el propietario ni el inquilino lo tienen — lo tiene un tercero neutral. Se libera según las condiciones pactadas en el contrato digital, con acta de inspección final como evidencia.

---

## Hallazgo 4: Reajuste de renta sin límite legal explícito

**Contrato afectado:** Contrato 2
**Severidad:** Media — el contrato es vago donde la ley es precisa

### Lo que dice el contrato

> **Cláusula TERCERA — PRECIO DE ALQUILER:** "En caso de prórroga, posterior al primer año de arrendamiento, el precio se incrementará en un acuerdo a lo indicado en la ley anualmente sobre el último alquiler devengado."

### Lo que dice la ley

> **Art. 67 — Reajuste del precio para vivienda:** "...el precio convenido se actualizará al final de cada año del contrato. Salvo acuerdo más favorable para el inquilino, el reajuste se regirá por [el IPC del INEC]..."

> **Art. 68 — Nulidad del reajuste:** "...es nulo de pleno derecho todo convenio en el cual se establezcan reajustes a la renta superiores a los mencionados en el artículo anterior, sean fijos o porcentuales..."

> **Art. 67 (moneda extranjera):** "Cuando el precio del arrendamiento de una vivienda sea en moneda extranjera, se mantendrá la suma convenida por todo el plazo del contrato, sin derecho a reajuste."

### Irregularidad

El contrato dice "de acuerdo a lo indicado en la ley" — lo cual es correcto en espíritu pero vago en práctica. No especifica:
- Que el máximo es el IPC del INEC (no un porcentaje arbitrario)
- Que cualquier reajuste superior es **nulo de pleno derecho**
- Que el arrendador debe notificar el reajuste con **certificación del INEC**
- Que el arrendatario puede depositar judicialmente el precio anterior si no está conforme

### Riesgo para las partes

- **Para el inquilino:** Sin conocer el IPC exacto, podría aceptar un incremento del 15% cuando el IPC es del 3%. Ese acuerdo es nulo pero el inquilino no lo sabe.
- **Para el propietario:** Podría imponer un incremento excesivo de buena fe (porque "todo está caro") y enfrentar una demanda de nulidad.

### Cómo lo resuelve HabitaNexus

La plataforma calcula automáticamente el reajuste máximo permitido usando datos del INEC. Bloquea cualquier incremento superior al IPC. Si el contrato es en dólares, no permite reajuste.

---

## Hallazgo 5: Ausencia de acta de estado inicial del inmueble

**Contrato afectado:** Contrato 1
**Severidad:** Alta — impide resolver disputas de depósito al final del contrato

### Lo que dice el contrato

> **Cláusula QUINTA — INMUEBLE:** "El arrendatario, quien previamente ha procedido al examen exhaustivo de la vivienda y sus accesorios, declara recibir todo lo que es objeto del arriendo en perfecto estado para el uso a que se destina..."

### Lo que NO dice el contrato

No hay inventario del estado del inmueble. No hay fotos. No hay lista de accesorios. No hay descripción de la distribución siquiera — a diferencia del Contrato 2 que al menos lista "3 dormitorios, sala-comedor, cocina, baño completo...".

La declaración genérica de "perfecto estado" es inútil en un conflicto porque ambas partes la interpretan diferente.

### Contraste con Contrato 2

El Contrato 2 sí tiene una descripción del estado:

> **Cláusula SEXTA — CONSERVACIÓN:** "El ARRENDATARIO declara recibir el inmueble, en muy buen estado de pintura, pisos, vidrios, mueble de cocina, banco de madera, pila, fregadero, instalaciones eléctricas, loza sanitaria, lavatorio, termo ducha y demás construcciones inherentes al mismo..."

Esto es mejor pero sigue sin incluir **fotos como evidencia** del estado en la fecha de entrega.

### Riesgo para las partes

- **Para el inquilino:** Al final del contrato, el propietario puede atribuirle daños preexistentes para justificar la retención del depósito.
- **Para el propietario:** No puede probar que el inmueble estaba en buen estado al entregarlo, lo que debilita cualquier reclamo por daños.

### Cómo lo resuelve HabitaNexus

La plataforma genera un **acta de entrega digital** al inicio del contrato con:
- Registro fotográfico del estado de cada espacio
- Inventario de accesorios y estado de instalaciones
- Firma digital de ambas partes con timestamp
- Hash SHA-256 del documento para garantizar inmutabilidad

Al final del contrato, se compara el estado actual vs. el acta inicial para resolver la liquidación del depósito objetivamente.

---

## Hallazgo 6: Inspección sin protocolo formal

**Contrato afectado:** Contrato 2
**Severidad:** Baja — el contrato tiene la cláusula pero le faltan detalles legales

### Lo que dice el contrato

> **Cláusula NOVENA — INSPECCIÓN:** "...dicha inspección se llevara a cabo los primeros cinco días del mes. Con el fin de verificar que todo esté de acuerdo a lo establecido. De no encontrar la inspección satisfactoria se solicitará al ARRENDATARIO que corrija de inmediato en los siguientes 30 días."

### Lo que dice la ley

> **Art. 51 — Inspección del bien:** "a) El arrendador podrá visitar el bien, **una vez por mes** o cuando las circunstancias lo ameriten, **en horas del día**... b) El arrendador podrá hacerse acompañar por un **ingeniero civil o un arquitecto**... podrán trazarse planos, tomarse **fotografías** y anotarse los daños. c) Cuando el arrendatario **no permita** inspeccionar el bien, después de ser requerido en **dos ocasiones** mediante notificación, el arrendador podrá invocar la **resolución del contrato**."

### Irregularidad

El contrato dice "los primeros cinco días" — lo cual es más restrictivo que la ley (que permite "una vez al mes"). No es una irregularidad per se, pero el contrato omite tres elementos importantes del Art. 51:

1. **Derecho a fotografiar** durante la inspección (Art. 51 inc. b)
2. **Derecho a llevar técnicos** — ingeniero, arquitecto (Art. 51 inc. b)
3. **2 negativas = causal de resolución** (Art. 51 inc. c)

### Riesgo para las partes

- **Para el propietario:** Si el inquilino se niega a una inspección, el propietario no sabe que con 2 negativas formales puede resolver el contrato. Pierde una herramienta legal poderosa.
- **Para el inquilino:** Puede negarse a inspecciones sin saber que está acumulando causales de desalojo.

### Cómo lo resuelve HabitaNexus

La plataforma registra cada inspección agendada, cada negativa, y alerta automáticamente cuando se cumplen las 2 negativas formales. Las fotos de la inspección quedan archivadas en el historial del contrato.

---

## Hallazgo 7: Terminación anticipada con penalidad unilateral

**Contrato afectado:** Contrato 1
**Severidad:** Media — la cláusula puede ser cuestionada

### Lo que dice el contrato

> **Cláusula SÉPTIMA — TERMINACIÓN ANTICIPADA:** "En caso de que el Arrendador pretenda dar por concluido el presente Contrato antes del vencimiento de su plazo (UN AÑO) cualquiera que sea la causa, el depósito no es reembolsable, estando la casa en perfectas condiciones, esto debido al incumplimiento del plazo establecido."

### Análisis

Esta cláusula tiene una ambigüedad severa. Dice "el Arrendador pretenda dar por concluido" pero la penalidad (pérdida de depósito) parece dirigida al arrendatario. Si es el **arrendador** quien termina anticipadamente:

- Según Art. 100-101, solo puede hacerlo para uso propio o familiar con 3 meses de aviso
- Debería **devolver** el depósito, no retenerlo

Si es el **arrendatario** quien termina anticipadamente:
- La pérdida total del depósito es desproporcionada si no hay daños ("estando la casa en perfectas condiciones")
- La ley no establece penalidades específicas por terminación anticipada del inquilino

### Riesgo para las partes

- **Para el inquilino:** Pierde ₡300,000 aunque devuelva la casa en perfecto estado, solo por irse antes del plazo.
- **Para el propietario:** La cláusula confusa podría ser cuestionada judicialmente.

### Cómo lo resuelve HabitaNexus

La plataforma separa claramente los escenarios de terminación anticipada con reglas diferenciadas por tipo (quién inicia, motivo, estado del inmueble). El depósito en escrow se liquida con base en evidencia fotográfica y acta de inspección, no con cláusulas ambiguas.

---

## Resumen de Irregularidades por Contrato

### Contrato 1 (Casa Heredia — formato informal)

| # | Irregularidad | Artículo violado | Severidad |
|---|--------------|-----------------|-----------|
| 1 | Plazo de 1 año (legalmente son 3) | Art. 70 | Alta |
| 3 | Depósito sin custodia neutral | Práctica (sin regulación específica) | Alta |
| 5 | Sin acta de estado inicial | Buena práctica / Art. 51 | Alta |
| 7 | Terminación anticipada ambigua | Art. 100-101 | Media |

### Contrato 2 (Apartamentos Las Palmas — formato profesional)

| # | Irregularidad | Artículo violado | Severidad |
|---|--------------|-----------------|-----------|
| 2 | Prórroga con 30 días de aviso (ley exige 3 meses) | Art. 71 | Media |
| 3 | Depósito sin custodia neutral | Práctica (sin regulación específica) | Alta |
| 4 | Reajuste de renta vago | Art. 67-68 | Media |
| 6 | Inspección sin protocolo completo | Art. 51 | Baja |

---

## Conclusión

Los contratos informales en Costa Rica — incluso los más profesionales como el Contrato 2 que cita la Ley 7527 — contienen irregularidades que perjudican a ambas partes por desconocimiento. Las tres más críticas son:

1. **Plazos incorrectos** que generan falsas expectativas de cuándo se puede terminar el contrato
2. **Depósitos sin custodia** que son la causa #1 de conflictos post-contrato
3. **Falta de evidencia fotográfica** al inicio que impide resolver disputas de daños objetivamente

HabitaNexus resuelve las tres mediante contratos digitales generados conforme a la ley, escrow neutral para depósitos, y actas de entrega con registro fotográfico inmutable.
