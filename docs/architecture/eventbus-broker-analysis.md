# Decisiones de Arquitectura del Bus de Eventos: Análisis de Implicaciones

**Fecha:** 2026-04-20
**Contexto:** Cuestionario de decisiones arquitectónicas para el bus de eventos que une a los cuatro servicios internos (marketplace-core, payments-core, invoice-core, compliance-core), más las integraciones con pasarelas de pago y con las aplicaciones Dart de los tres productos.

**Preguntas que responde este documento:**
1. ¿Qué intermediario (broker) usa el bus de eventos para la comunicación entre servicios?
2. ¿Qué formato tienen los eventos y quién es la autoridad de los esquemas?
3. ¿Cómo recibe `payments-core` las notificaciones entrantes de las pasarelas de pago?
4. ¿Cómo consumen las tres aplicaciones Dart los servicios de los cores?

**Alcance:** Análisis técnico profundo de cada opción, contrapartidas ocultas, matrices comparativas, recomendación contextualizada y señales para revisitar cada decisión en el futuro. Una sección final muestra cómo las cuatro decisiones están acopladas entre sí y qué combinaciones son incoherentes.

---

## Glosario rápido (para leer antes del resto)

Este glosario sirve como referencia para los términos técnicos que aparecen repetidamente. La idea es introducir cada concepto una sola vez en español y no volver a usar su equivalente en inglés en el cuerpo del documento.

| Término en español | Definición corta | Inglés (referencia) |
|---|---|---|
| Bus de eventos | Canal compartido donde los servicios publican y consumen eventos del dominio. | event bus |
| Intermediario / broker | Componente central que almacena y entrega los mensajes del bus. | broker |
| Publicador | Servicio que emite un evento al bus. | publisher |
| Suscriptor / consumidor | Servicio que lee y procesa eventos del bus. | subscriber / consumer |
| Entrega al menos una vez | Garantía de que el mensaje llega sí o sí, posiblemente duplicado. | at-least-once |
| Entrega como máximo una vez | Garantía de que el mensaje no se duplica, pero podría perderse. | at-most-once |
| Entrega exactamente una vez | Garantía de que el mensaje llega sin duplicados ni pérdidas. | exactly-once |
| Rebobinado | Re-consumir eventos viejos para reconstruir estado o reprocesar. | replay |
| Contrapresión | Mecanismo para que un consumidor lento no sature al publicador rápido. | back-pressure |
| Orden per-llave | Garantía de que los eventos con la misma llave llegan en el orden emitido. | per-key ordering |
| Registro de esquemas | Servicio central que guarda la definición formal de cada tipo de evento. | schema registry |
| Cambio incompatible | Modificación del esquema que rompe a los consumidores que siguen la versión anterior. | breaking change |
| Autoalojado | Operado por el propio equipo, no por un proveedor externo. | self-hosted |
| Dependencia encadenada | Costo alto y difícil de revertir al migrar fuera de una tecnología. | lock-in |
| Fuente única de verdad | El lugar canónico donde vive la definición correcta de un contrato. | source of truth |
| Cola de mensajes muertos | Depósito para mensajes que no pudieron procesarse tras varios reintentos. | Dead Letter Queue (DLQ) |
| Carga útil | Los datos del evento (lo que el consumidor va a procesar). | payload |
| Formato de transmisión | Cómo se codifican los bytes del evento para viajar por la red. | wire format |
| Notificación HTTP entrante | Llamada HTTP que un sistema externo (Stripe, etc.) hace al nuestro para avisar de un evento. | webhook |
| Firma criptográfica | Hash que valida que la notificación viene del emisor legítimo. | webhook signature |
| Idempotencia | Propiedad que permite ejecutar la misma operación varias veces con el mismo efecto. | idempotency |
| Reintento con retroceso exponencial | Estrategia de reintentos con intervalos crecientes (1s, 4s, 16s, …). | exponential backoff retry |
| Destino compartido | Situación en la que la latencia o caída de un servicio arrastra a otro. | fate-sharing |
| Tormenta de reintentos | Amplificación de carga cuando un fallo hace que todos los clientes reintenten a la vez. | retry storm |
| Generación de código | Producir clases de un lenguaje a partir de un archivo de esquema. | code generation |
| Seguridad de tipos de punta a punta | Garantía de que el compilador detecta inconsistencias desde el servidor hasta el cliente. | end-to-end type safety |
| Tubería de compilación | Secuencia automatizada de pasos para construir y publicar el código. | build pipeline |
| Procurador / intermediario HTTP | Componente que reenvía o traduce llamadas entre cliente y servidor. | proxy |
| Evolución del esquema | Cambios al contrato del evento a lo largo del tiempo sin romper a los consumidores existentes. | schema evolution |

Acrónimos que aparecen en el documento:

- **DLQ** — Cola de mensajes muertos (Dead Letter Queue)
- **TTL** — Tiempo de vida (Time To Live)
- **SLA** — Acuerdo de nivel de servicio (Service Level Agreement)
- **CI** — Integración continua (Continuous Integration)
- **ACK** — Acuse de recibo (acknowledgement)
- **ISR** — Réplicas en sincronía (In-Sync Replicas, concepto específico de Kafka)
- **MVP** — Producto mínimo viable (Minimum Viable Product)
- **OSS** — Software de código abierto (Open Source Software)
- **JVM** — Máquina virtual de Java (Java Virtual Machine)
- **RPC** — Llamada a procedimiento remoto (Remote Procedure Call)
- **AMQP** — Protocolo Avanzado de Encolado de Mensajes (Advanced Message Queuing Protocol, usado por RabbitMQ)
- **IDL** — Lenguaje de definición de interfaces (Interface Definition Language, usado por Avro y Protobuf)
- **gRPC** — Framework de llamadas remotas sobre HTTP/2 (sigla recursiva; nombre propio del framework de Google)
- **HTTP/2** — Versión binaria del protocolo HTTP que soporta multiplexación de conexiones

---

## Tabla de contenidos

**Parte I — Decisión 1: Intermediario del bus de eventos**
1. [Resumen ejecutivo y recomendación para el caso concreto](#parte-i--decisión-1-intermediario-del-bus-de-eventos)
2. [Marco de evaluación](#marco-de-evaluación)
3. [Opción 1.A — NATS JetStream](#opción-1a--nats-jetstream)
4. [Opción 1.B — Kafka (Confluent Cloud o Redpanda)](#opción-1b--kafka-confluent-cloud-o-redpanda)
5. [Opción 1.C — RabbitMQ](#opción-1c--rabbitmq)
6. [Opción 1.D — Postgres con LISTEN/NOTIFY](#opción-1d--postgres-con-listennotify)
7. [Matriz comparativa de la decisión 1](#matriz-comparativa-de-la-decisión-1)
8. [Señales para revisitar la decisión 1](#señales-para-revisitar-la-decisión-1)

**Parte II — Decisión 2: Formato de eventos y autoridad de esquemas**

9. [Marco de evaluación de la decisión 2](#marco-de-evaluación-de-la-decisión-2)
10. [Opción 2.A — Protobuf con buf.build](#opción-2a--protobuf-con-bufbuild)
11. [Opción 2.B — JSON con JSON Schema y Zod en un repositorio compartido](#opción-2b--json-con-json-schema-y-zod-en-un-repositorio-compartido)
12. [Opción 2.C — CloudEvents con carga útil JSON](#opción-2c--cloudevents-con-carga-útil-json)
13. [Opción 2.D — Avro con Confluent Schema Registry](#opción-2d--avro-con-confluent-schema-registry)
14. [Matriz comparativa de la decisión 2](#matriz-comparativa-de-la-decisión-2)
15. [Señales para revisitar la decisión 2](#señales-para-revisitar-la-decisión-2)

**Parte III — Decisión 3: Notificaciones entrantes de pasarelas de pago**

16. [Marco de evaluación de la decisión 3](#marco-de-evaluación-de-la-decisión-3)
17. [Opción 3.A — Procesamiento asíncrono con cola de reintentos](#opción-3a--procesamiento-asíncrono-con-cola-de-reintentos)
18. [Opción 3.B — Procesamiento síncrono bloqueante](#opción-3b--procesamiento-síncrono-bloqueante)
19. [Opción 3.C — Modelo híbrido (síncrono para eventos críticos, asíncrono para los demás)](#opción-3c--modelo-híbrido-síncrono-para-eventos-críticos-asíncrono-para-los-demás)
20. [Matriz comparativa de la decisión 3](#matriz-comparativa-de-la-decisión-3)
21. [Señales para revisitar la decisión 3](#señales-para-revisitar-la-decisión-3)

**Parte IV — Decisión 4: Consumo de los cores desde las aplicaciones Dart**

22. [Marco de evaluación de la decisión 4](#marco-de-evaluación-de-la-decisión-4)
23. [Opción 4.A — gRPC Dart nativo con compilación de esquemas](#opción-4a--grpc-dart-nativo-con-compilación-de-esquemas)
24. [Opción 4.B — Procurador HTTP intermedio por aplicación](#opción-4b--procurador-http-intermedio-por-aplicación)
25. [Opción 4.C — Puerta de enlace en Serverpod](#opción-4c--puerta-de-enlace-en-serverpod)
26. [Matriz comparativa de la decisión 4](#matriz-comparativa-de-la-decisión-4)
27. [Señales para revisitar la decisión 4](#señales-para-revisitar-la-decisión-4)

**Parte V — Acoplamiento entre decisiones**

28. [Cómo interactúan las cuatro decisiones](#cómo-interactúan-las-cuatro-decisiones)
29. [Combinaciones incoherentes (señales de alarma)](#combinaciones-incoherentes-señales-de-alarma)
30. [Recomendación combinada](#recomendación-combinada)

**Apéndice**

31. [Lista de verificación inicial (común a cualquier opción)](#apéndice-lista-de-verificación-inicial-común-a-cualquier-opción)
32. [Referencias oficiales y lecturas recomendadas](#referencias-oficiales-y-lecturas-recomendadas)

---

## Parte I — Decisión 1: Intermediario del bus de eventos

### Resumen ejecutivo

Dado el contexto (cuatro servicios internos, un equipo pequeño, las aplicaciones Dart como consumidoras, la estética minimalista del proyecto), las dos opciones viables son:

| Situación | Recomendación |
|---|---|
| Ya se decidió que hace falta un intermediario dedicado | **NATS JetStream**. Es la opción recomendada en el cuestionario y la respaldo. |
| Todavía estamos antes de la fase de crecimiento y los cuatro servicios comparten la misma base Postgres | **Postgres con LISTEN/NOTIFY más el patrón de bandeja de salida (outbox pattern)**. No es deuda técnica, es dimensionar correctamente al tamaño actual. |
| Existe certeza de querer hacer *event sourcing* (reconstruir estado desde el log completo de eventos) o alimentar analítica pesada | **Kafka**, pero asumiendo su costo operacional y su dependencia encadenada. |
| Cualquier otro caso | Descartar RabbitMQ: su modelo mental (colas de tareas) no encaja con eventos del dominio entre servicios. |

> **💡 Idea central:** Elegir el intermediario no es solo "dónde viven los mensajes". Define el modelo de consistencia entre servicios, el radio de impacto cuando algo falla, y cuánta complejidad operacional hereda el equipo **para siempre**.

### Marco de evaluación

Estas son las siete dimensiones que la mayoría de comparaciones públicas ignoran y que terminan doliendo en producción:

1. **Semántica de entrega** — ¿el intermediario garantiza entrega al menos una vez, como máximo una vez, o exactamente una vez?
2. **Garantías de orden** — ¿el orden se preserva por llave, por partición, globalmente, o no se preserva?
3. **Ventana de persistencia** — ¿cuánto tiempo vive un evento no consumido antes de borrarse?
4. **Capacidad de rebobinado** — ¿se pueden recorrer eventos históricos desde una fecha o posición? ¿a qué costo?
5. **Comportamiento bajo contrapresión** — ¿qué pasa cuando un consumidor es más lento que el publicador?
6. **Modo de falla** — cuando el intermediario cae, ¿qué se pierde? ¿en qué estado quedan los publicadores?
7. **Aislamiento entre inquilinos** — si un servicio satura el bus, ¿cómo aislamos a los demás?

> **💡 Idea metodológica:** Throughput (rendimiento) y precio son lo que la gente compara en internet. Las siete dimensiones anteriores son lo que predice si la elección va a doler. Que todas sean aburridas no las hace irrelevantes.

---

### Opción 1.A — NATS JetStream

**Arquitectura interna**
- El núcleo NATS es un protocolo de publicación y suscripción sin persistencia (disparar y olvidar).
- JetStream es la capa superior que agrega *flujos persistentes* (registros solo de adición) más consumidores con acuses de recibo (ACK) por mensaje.
- Los flujos se replican con el algoritmo de consenso Raft, en grupos de 1, 3 o 5 réplicas.

**Implicaciones técnicas**
- **Semántica de entrega:** por defecto, al menos una vez. Exactamente una vez es posible con doble ACK y ventana de deduplicación, pero agrega latencia aproximadamente al doble.
- **Orden:** se preserva por "asunto" (subject). Si `payments-core` publica `payment.completed.{id_pedido}`, todos los eventos de ese pedido llegan en orden. Entre asuntos distintos, **no hay orden global**.
- **Persistencia:** configurable por flujo (tiempo, tamaño, cantidad de mensajes). Ejemplo típico: "siete días o diez gigabytes, lo primero que ocurra".
- **Rebobinado:** trivial y barato. Cada consumidor mantiene un cursor. Se puede crear un consumidor nuevo que reproduzca "desde ayer" en treinta segundos.
- **Contrapresión:** tiene control de flujo nativo más un límite de "mensajes pendientes de ACK". Si un servicio procesa lento, solo su consumidor acumula retraso; los demás siguen normales.
- **Modo de falla:** con tres réplicas y consenso Raft, tolera la caída de un nodo sin pérdida. Si se pierde el quórum, los publicadores fallan con error explícito (no hay escrituras fantasma).
- **Aislamiento:** tiene "cuentas" nativas más separación por jerarquía de asuntos (`marketplace.>`, `payments.>`). Permite asignar cuotas y permisos por servicio.

**Contrapartidas ocultas**
- **No tiene registro de esquemas nativo.** Hay que rodarlo por separado o usar cabeceras con campo de versión. Kafka gana en este punto.
- **La madurez de los clientes es asimétrica.** Go y NATS.js son excelentes. Python (paquete `nats-py`) y Dart son funcionales pero con menos facilidades listas para usar — por ejemplo, el cliente Dart actualmente no tiene soporte completo para el almacén clave-valor de JetStream.
- **Observabilidad:** hay un exportador oficial para Prometheus, pero los tableros y alertas prearmados de la comunidad son menos maduros que los de Kafka.
- **"Ligero" tiene asterisco.** El binario único es cierto, pero tres réplicas para Raft son tres nodos con sus discos y su planificación de almacenamiento.

**Cuándo es la elección correcta**
- Comunicación entre servicios internos por eventos del dominio (este caso).
- Volumen medio (hasta unos 100 000 mensajes por segundo sin esfuerzo).
- Equipo pequeño sin un ingeniero de operaciones dedicado.
- Retención corta a media (horas o días, no meses).

---

### Opción 1.B — Kafka (Confluent Cloud o Redpanda)

**Arquitectura interna**
- Kafka clásico: intermediarios más ZooKeeper (reemplazado desde la versión 3 por KRaft), temas divididos en particiones, factor de replicación.
- Redpanda: reescritura en C++ de la interfaz de Kafka, sin ZooKeeper, sin JVM, binario único. Compatible con los clientes Kafka.
- Confluent Cloud: Kafka gestionado como servicio, con complementos (registro de esquemas, ksqlDB, Connect).

**Implicaciones técnicas**
- **Semántica de entrega:** al menos una vez por defecto. Exactamente una vez real con productores idempotentes y transacciones (Kafka es el único de los cuatro que implementa esto correctamente de punta a punta).
- **Orden:** por partición. La llave de particionado determina qué eventos viajan juntos. Si se elige mal la llave, se pierde orden en casos sutiles.
- **Persistencia:** el disco es la cola. La retención puede ser infinita (con almacenamiento por niveles en Confluent o Redpanda, se pueden conservar meses o años a costo de almacenamiento en la nube). Esto cambia la filosofía: el tema es el **registro histórico**, no solo un amortiguador.
- **Rebobinado:** es el centro del diseño. Los consumidores eligen su posición: desde el principio, desde la última, por fecha, por número de secuencia. Esto habilita patrones como *event sourcing* y reprocesamiento masivo.
- **Contrapresión:** los consumidores extraen (no reciben empujados). El intermediario no se ahoga con consumidores lentos; simplemente acumulan retraso.
- **Modo de falla:** con réplicas en sincronía configuradas correctamente, cero pérdida con una o dos caídas. Pero el ajuste fino (`acks=all`, `min.insync.replicas`, prohibir elección de líder sucia) es delicado.
- **Aislamiento:** listas de control de acceso granulares más cuotas por cliente. Confluent tiene aislamiento nativo. La versión autoalojada requiere operación cuidadosa.

**Contrapartidas ocultas**
- **El particionado es permanente.** Aumentar el número de particiones rompe el orden histórico por llave. Decisión irreversible.
- **El rebalanceo de consumidores introduce pausas globales** cuando alguien entra o sale del grupo (segundos). Los rebalanceos adhesivos y cooperativos mitigan pero no eliminan el problema.
- **El registro de esquemas es casi obligatorio.** Sin él, la evolución del esquema se vuelve una pesadilla. Costo operacional adicional.
- **El modelo de precios de Confluent Cloud engaña.** "Un dólar por gigabyte producido" suena barato, pero con factor de replicación tres más consumo más egreso, facturas de cinco a diez mil dólares mensuales son rutina en startups medianas.
- **Redpanda en versión gratuita:** muchas características (almacenamiento por niveles, transformaciones, multi-región) son solo para la edición Enterprise. La versión abierta es menos completa de lo que parece.

**Cuándo es la elección correcta**
- Event sourcing real (los eventos son la fuente única de verdad histórica).
- Canal de datos hacia almacenes analíticos (Kafka Connect brilla aquí).
- Volumen alto sostenido (más de 100 000 mensajes por segundo) con retención larga.
- Equipo con experiencia o con presupuesto para Confluent.

---

### Opción 1.C — RabbitMQ

**Arquitectura interna**
- Orientado a colas, no a registros. El intermediario está escrito en Erlang sobre la plataforma OTP (muy robusta, pero ecosistema raro para operaciones).
- Protocolo AMQP 0.9.1 con intercambios (directos, por difusión, por tópico, por cabeceras) que enrutan mensajes a colas.
- La característica "Streams" (desde la versión 3.9) agrega algo parecido a los registros estilo Kafka, pero el ecosistema y el pensamiento del producto siguen centrados en colas.

**Implicaciones técnicas**
- **Semántica de entrega:** al menos una vez con ACK manuales. No hay exactamente una vez real.
- **Orden:** primero-en-entrar-primero-en-salir por cola si hay un solo consumidor. Con varios consumidores compitiendo, el orden se pierde. Los "Streams" preservan el orden pero cambian el modelo de consumo.
- **Persistencia:** los mensajes persistentes se escriben a disco, pero el modelo asume "consume y borra". Los mensajes viejos no se guardan históricamente salvo que se usen Streams.
- **Rebobinado:** **no es nativo en colas clásicas**. Una vez confirmado el mensaje, se va. Con Streams sí, pero entonces se está usando RabbitMQ como un Kafka mediocre.
- **Contrapresión:** conteo de prefetch por consumidor más control de flujo del intermediario. Si una cola crece demasiado, el intermediario puede bloquear a los publicadores (peligroso si los publicadores no manejan bien este caso).
- **Modo de falla:** colas espejo (obsoletas) o colas de quórum (nuevas, basadas en Raft). Las colas de quórum son correctas pero más lentas que JetStream o Kafka.
- **Aislamiento:** hosts virtuales más permisos. Útil, pero el costo por host virtual es real.

**Contrapartidas ocultas**
- **Modelo mental equivocado para el caso.** RabbitMQ piensa en colas de trabajo (distribución de tareas, llamadas remotas). Para eventos del dominio puros se siente torcido.
- **Operación Erlang:** cuando algo sale mal, depurar el agrupamiento de nodos Erlang es una habilidad rara en equipos típicos.
- **Panel de administración:** la mejor interfaz gráfica de los cuatro. Tablero detallado listo para usar.
- **Clientes:** ubicuos y maduros en todos los lenguajes, incluido Dart. Mejor cobertura que NATS.

**Cuándo es la elección correcta**
- Mensajería estilo petición-respuesta (llamadas remotas).
- Colas de tareas (cargas tipo Celery).
- Equipos con experiencia previa en AMQP.
- **No es la elección correcta para este caso** (eventos del dominio entre servicios).

---

### Opción 1.D — Postgres con LISTEN/NOTIFY

**Arquitectura interna**
- `NOTIFY canal, 'contenido'` dispara un evento transitorio dentro de la base.
- `LISTEN canal` en una conexión abierta recibe las notificaciones.
- Todo vive dentro de Postgres, sin tablas ni índices adicionales (aunque lo habitual es combinarlo con una tabla "bandeja de salida").

**Implicaciones técnicas**
- **Semántica de entrega:** **como máximo una vez, sin persistencia**. Si el suscriptor está desconectado en el momento de la notificación, el evento se pierde para siempre. Con el patrón de bandeja de salida (tabla más LISTEN) se obtiene al menos una vez, pero ya no es "cero infraestructura".
- **Orden:** garantizado por el orden de las transacciones dentro del mismo canal.
- **Persistencia:** **ninguna por defecto**. Las notificaciones son efímeras. La bandeja de salida lo resuelve, pero implica consulta periódica y marcado de procesados.
- **Rebobinado:** imposible sin tabla de bandeja de salida. Con bandeja, trivial (es SQL).
- **Contrapresión:** el contenido máximo es 8 kilobytes por defecto. El rendimiento está limitado por Postgres: pierde frente a intermediarios dedicados por un factor de diez a cien.
- **Modo de falla:** si la conexión LISTEN se corta, los eventos entre la desconexión y la reconexión se pierden. Hay que combinar con consulta periódica de la bandeja para tener garantías.
- **Aislamiento:** inexistente. Todos los canales comparten la misma base Postgres. Un servicio con pico alto afecta las consultas del resto.

**Contrapartidas ocultas**
- **"Cero infraestructura" es verdad solo el día uno.** El día que se necesite rebobinar, cola de mensajes muertos, o escalar, hay que migrar a otra cosa. La migración cuesta más que haber elegido bien desde el inicio.
- **Conexiones persistentes:** cada suscriptor consume una conexión de Postgres. Si hay un pgBouncer en modo de transacción, LISTEN/NOTIFY **no funciona** (requiere modo de sesión).
- **El patrón de bandeja de salida transaccional** es el correcto si se elige esta opción: se inserta el evento y el estado del negocio en la misma transacción, garantizando atomicidad. Un trabajador aparte lee la bandeja y publica. Es más simple de lo que suena y es la mejor opción para un producto mínimo viable real.
- **Tamaño de la carga útil:** 8 kilobytes es restrictivo. Los eventos con contexto completo (por ejemplo, una factura con todas sus líneas) suelen no entrar, obligando al patrón "evento es solo el identificador, el consumidor lee la base", que acopla al consumidor con el esquema del publicador.

**Cuándo es la elección correcta**
- Producto mínimo viable con menos de mil eventos por segundo y todos los servicios compartiendo la misma Postgres.
- Cuando el costo de introducir un intermediario nuevo (operacional y cognitivo) supera el beneficio actual.
- Con plan explícito de migrar cuando crezca (no "quizás después").

---

### Matriz comparativa de la decisión 1

| Dimensión | NATS JetStream | Kafka | RabbitMQ | Postgres LISTEN/NOTIFY |
|---|---|---|---|---|
| Semántica de entrega | Al menos una vez (exactamente una vez opcional) | Exactamente una vez real | Al menos una vez | Como máximo una vez (al menos una vez con bandeja de salida) |
| Rebobinado | Trivial, barato | Central al diseño | No nativo (o con Streams) | Solo con bandeja de salida |
| Orden preservado | Por asunto | Por partición | Por cola con un solo consumidor | Por canal |
| Complejidad operacional | Baja a media | Alta | Media | Cero (ya existe) |
| Cliente Dart | Funcional | Funcional | Excelente | Trivial (usa el controlador Postgres) |
| Evolución del esquema | Manual | Con registro de esquemas | Manual | Manual |
| Costo a escala | Bajo (autoalojado) | Alto (gestionado) | Medio | Marginal |
| Costo de migrar a otro | Medio | Bajo (dependencia encadenada fuerte) | Medio | Alto (la bandeja es portable) |
| Radio de impacto ante falla | Contenido por flujo | Contenido por tema | Contenido por host virtual | Compartido con la base del negocio |
| Curva de aprendizaje | Baja (asuntos y flujos son intuitivos) | Alta (particiones, posiciones, rebalanceo, réplicas en sincronía) | Media (modelo AMQP) | Cero para quien ya sabe SQL |

---

### Señales para revisitar la decisión 1

**Si se eligió Postgres con bandeja de salida, migrar a un intermediario dedicado cuando:**

- [ ] El volumen sostenido supera los 5 000 eventos por segundo durante más de dos semanas.
- [ ] Más de dos servicios corren en infraestructura separada (no comparten Postgres).
- [ ] Aparecen requisitos de retención superior a 30 días (cumplimiento, auditoría, reprocesamiento masivo).
- [ ] Un servicio saturando el bus afecta la latencia de consultas de negocio de otro servicio.
- [ ] Hace falta cola de mensajes muertos nativa con políticas de reintento diferenciadas por tipo de evento.
- [ ] La carga útil promedio de los eventos supera consistentemente los 4 kilobytes.

**Si se eligió NATS JetStream, revisitar cuando:**

- [ ] Hace falta un registro de esquemas con verificación de compatibilidad automática (Kafka es superior aquí).
- [ ] Se requiere canal de datos pesado hacia un almacén analítico (Kafka Connect es superior).
- [ ] El volumen sostenido supera los 500 000 eventos por segundo con retención de más de tres meses.
- [ ] La garantía de entrega exactamente una vez de punta a punta se vuelve requisito estricto.

**Si se eligió Kafka, revisitar cuando:**

- [ ] El costo de Confluent Cloud supera el 5-10 % del presupuesto de infraestructura.
- [ ] La complejidad operacional bloquea entregas más de lo que el producto habilita.
- [ ] Se descubre que se está usando menos del 20 % de las capacidades que justifican Kafka.

**Señales transversales de que el intermediario actual ya no sirve:**

- [ ] Cada despliegue de un nuevo suscriptor requiere intervención manual.
- [ ] La monitorización del retraso de los consumidores es improvisada, no una herramienta de primera clase.
- [ ] Los incidentes tipo "perdimos un evento" ocurren más de una vez por trimestre.
- [ ] Integrar a una persona nueva al patrón toma más de una semana.

---

## Parte II — Decisión 2: Formato de eventos y autoridad de esquemas

> **💡 Idea central:** El formato de codificación y la autoridad del esquema es la decisión que más se *olvida* revisar y la que más se paga después. Los equipos que eligen "JSON porque es simple" descubren dieciocho meses después que están manteniendo tres copias del mismo contrato sin darse cuenta, y que la desviación silenciosa entre servicios causa errores que ningún verificador de tipos puede atrapar.

### Marco de evaluación de la decisión 2

Siete dimensiones relevantes:

1. **Formato de transmisión** — ¿binario o texto?, ¿cuánto ocupa?, ¿cuánto cuesta analizarlo?
2. **Lenguaje del esquema** — ¿cuán expresivo?, ¿soporta uniones, recursión, diccionarios?
3. **Autoridad del esquema** — dónde vive la fuente única de verdad del contrato.
4. **Detección de cambios incompatibles** — ¿existe una herramienta de línea de comandos que la integración continua pueda ejecutar en cada revisión?
5. **Generación de código entre lenguajes** — ¿tiene buena calidad en TypeScript, Python y Dart por igual?
6. **Validación en tiempo de ejecución** — ¿los mensajes inválidos se rechazan al decodificar, o pasan como basura?
7. **Evolución hacia adelante y hacia atrás** — ¿se pueden agregar campos hoy sin romper a los consumidores de mañana?

### Opción 2.A — Protobuf con buf.build

**Arquitectura**
- Archivos `.proto` como **fuente única de verdad**. Vivir en `payments-core` o en un repositorio dedicado `shared-protos`.
- Herramienta `buf` más registro en [buf.build](https://buf.build): publicación, navegación visual, detección de cambios incompatibles, verificación de estilo.
- Generación de código con `protoc` más extensiones: `protoc-gen-dart` (oficial), `ts-proto` o `bufbuild/protobuf-es` (TypeScript), `betterproto` (Python moderno).

**Implicaciones técnicas**
- **Formato de transmisión:** binario compacto. Los mensajes típicamente ocupan del 30 al 50 % del tamaño del JSON equivalente. Relevante a escala.
- **Costo de análisis:** muy bajo en entornos con implementación nativa (Go, Java, C++). Aceptable en Dart, JavaScript y Python gracias al código generado.
- **Evolución del esquema:** los campos reservados y los números de campo son contratos **inmutables**. Si se sigue la convención (nunca renumerar, nunca reutilizar un número reservado), la evolución hacia adelante y hacia atrás es fuerte.
- **Detección de cambios incompatibles:** el comando `buf breaking` compara dos revisiones y reporta. Es integrable en la integración continua como verificación obligatoria antes de fusionar.
- **Generación de código:** maduro en TypeScript, Python, Dart y Go. Dart tiene `protoc-gen-dart` oficial mantenido en conjunto por el equipo Dart y el equipo Protobuf.
- **Autoridad del registro:** buf.build tiene planes gratuitos para proyectos abiertos y de pago para módulos privados. Alternativas: autoalojar la herramienta `buf`, usar Apicurio, o usar el registro de esquemas abierto.
- **Paridad con gRPC:** si ya se usa gRPC como transporte (supuesto del caso), los mismos archivos `.proto` definen tanto las llamadas remotas como los eventos. Cero duplicación de contrato.

**Contrapartidas ocultas**
- **Depuración en registros de bitácora:** la carga útil binaria es ilegible a simple vista. Hay que invertir en herramientas auxiliares (`buf curl`, `protoc --decode`, interceptores que formateen los mensajes a texto). Inversión inicial.
- **Código generado en Dart:** tiene funciones accesorias, chequeos de presencia, patrones de mutación propios de Protobuf. No son clases Dart idiomáticas limpias. Aceptable pero requiere entrenamiento del equipo.
- **Dependencia encadenada moderada:** migrar fuera de Protobuf implica regenerar todo. Compensación aceptable dado el valor que aporta.
- **Precios de buf.build:** gratuito para repositorios abiertos, de pago para módulos privados. Autoalojar la herramienta `buf` más los esquemas en Git es alternativa gratuita (se pierde solo la interfaz de navegación visual).

**Cuándo es la elección correcta**
- Ya se usa gRPC para llamadas remotas: los eventos heredan gratis el ecosistema.
- El equipo tiene integración continua disciplinada (la detección de cambios incompatibles en la verificación previa a fusionar es requisito).
- Varios lenguajes consumen eventos (TypeScript, Python, Dart, Go).

---

### Opción 2.B — JSON con JSON Schema y Zod en un repositorio compartido

**Arquitectura**
- Repositorio `shared-schemas` con JSON Schema canónico más envoltorios Zod para validación en tiempo de ejecución en TypeScript.
- Dart y Python consumen el JSON Schema directamente con generadores de código (`quicktype`, `json_schema_to_dart`, `datamodel-code-generator`).
- Cargas útiles codificadas como JSON UTF-8 en el bus.

**Implicaciones técnicas**
- **Formato de transmisión:** JSON texto. Ocupa dos a tres veces el tamaño de Protobuf. Lectura humana directa en registros.
- **Costo de análisis:** rápido en JavaScript y TypeScript (nativo en V8), decente en Dart (`dart:convert`), decente en Python (`orjson` para mayor velocidad).
- **Evolución del esquema:** JSON Schema permite propiedades adicionales, campos obligatorios, campos opcionales, uniones. Es expresivo. Pero la disciplina queda manual: no hay equivalente a los "números de campo reservados" que prevengan colisiones al renombrar.
- **Detección de cambios incompatibles:** no hay estándar maduro equivalente a `buf breaking`. Herramientas como `json-schema-diff` u `openapi-diff` existen pero son menos completas.
- **Zod solo sirve para TypeScript:** Dart y Python pierden la parte más atractiva (validación en tiempo de ejecución con estrechamiento de tipos).
- **Autoridad del registro:** un repositorio Git es suficiente. No hay análogo a buf.build.

**Contrapartidas ocultas**
- **Duplicación con Protobuf:** si ya existen archivos `.proto` para gRPC, ahora hay que mantener dos contratos: Protobuf para las llamadas remotas y JSON Schema para los eventos. **Probabilidad de desviación entre ambos cercana al 100 % en doce meses.**
- **Zod exclusivo de TypeScript:** el centro de gravedad de la validación queda en TypeScript. Los consumidores Dart y Python validan manualmente o no validan.
- **Alta facilidad de depuración:** `grep`, `jq`, cualquier visor de registros lo entiende. Es el mayor atractivo real de esta opción.
- **Esquemas versionados en repositorio compartido:** requiere estrategia de ramas más control de versiones semántico del repositorio de esquemas. Carga operacional de la que poca gente habla.

**Cuándo es la elección correcta**
- No hay archivos Protobuf ya establecidos (no es este caso).
- Las herramientas internas son mayoritariamente TypeScript.
- Se prioriza la facilidad de depuración sobre la eficiencia en cable.

---

### Opción 2.C — CloudEvents con carga útil JSON

**Arquitectura**
- Sobre estándar de CloudEvents (proyecto de la Cloud Native Computing Foundation) con campos fijos: identificador, origen, tipo, tipo de contenido, fecha, sujeto.
- La carga útil (campo `data`) es agnóstica: puede ser JSON, Protobuf o Avro.
- Ecosistema: OpenTelemetry, Knative, Dapr, AWS EventBridge.

**Implicaciones técnicas**
- **Estandarización del sobre:** interoperabilidad real con sistemas externos que hablan CloudEvents nativamente (EventBridge, Dapr, disparadores Knative).
- **Sobrecarga del sobre:** unos 200 bytes por evento. No significativo en la mayoría de los casos.
- **Esquema de la carga útil:** sigue haciendo falta JSON Schema o Protobuf para definir los datos. CloudEvents no resuelve eso.
- **Herramientas:** clientes oficiales en Go, Java, JavaScript y Python. **Dart: no hay cliente oficial**, solo paquetes de terceros de madurez variable.

**Contrapartidas ocultas**
- **Doble mantenimiento de esquema:** sobre CloudEvents (fijo, no se toca) más esquema de la carga útil (propio). No suena mal, pero muchos equipos terminan no usando los campos del sobre en la práctica, con lo cual el envoltorio se vuelve puro costo adicional.
- **El valor real emerge cuando hay integración externa** con sistemas que hablan CloudEvents. Para eventos puramente internos entre servicios del mismo equipo, el retorno de la inversión es dudoso.
- **Soporte débil en Dart:** habría que implementar la codificación y decodificación del sobre manualmente o aceptar un paquete de terceros sin garantías.

**Cuándo es la elección correcta**
- Se va a integrar con EventBridge, Knative, Dapr u otros consumidores nativos de CloudEvents.
- Hace falta un sobre estándar para enrutamiento y filtrado entre equipos u organizaciones.

---

### Opción 2.D — Avro con Confluent Schema Registry

**Arquitectura**
- Archivos Avro con su lenguaje de definición de interfaces. Los esquemas compilados se convierten en `.avsc`. El formato en cable es binario con un identificador de esquema en la cabecera del mensaje.
- Confluent Schema Registry (o Apicurio como alternativa abierta) resuelve el identificador de esquema al momento de decodificar.
- Los consumidores almacenan en memoria los esquemas ya conocidos y consultan al registro cuando encuentran uno nuevo.

**Implicaciones técnicas**
- **Formato de transmisión:** binario super compacto, incluso más que Protobuf en algunos casos (no hay números de etiqueta repetidos en cada campo).
- **Evolución del esquema:** excelente. Avro fue diseñado alrededor de esto; el Schema Registry hace cumplir las reglas de compatibilidad (hacia adelante, hacia atrás, total) al momento de publicar.
- **Consulta al registro en tiempo de ejecución:** cada decodificación puede requerir resolver el identificador si no está en caché. Agrega latencia y un nuevo modo de falla (si el registro cae, no se puede decodificar).
- **Dependencia fuerte de Kafka:** el patrón "identificador de esquema en la cabecera más consulta al registro" es idiomático de Kafka. Fuera de ese ecosistema es complicado y poco natural.

**Contrapartidas ocultas**
- **Fuera de Kafka, Avro es peso muerto:** agrega la dependencia operacional del registro sin el valor que lo justifica.
- **Clientes Dart:** poco maduros. Java, Go y Python están bien; Dart queda huérfano.
- **Modo de falla en la resolución del esquema:** si el registro está caído, los consumidores que encuentran un identificador no conocido fallan. Requiere estrategia de caché más plan de respaldo.

**Cuándo es la elección correcta**
- **El intermediario es Kafka.** Literal — Avro pierde todo su valor fuera de ese ecosistema.

---

### Matriz comparativa de la decisión 2

| Dimensión | Protobuf + buf | JSON + Zod | CloudEvents + JSON | Avro + Confluent |
|---|---|---|---|---|
| Tamaño del mensaje (vs. JSON como referencia) | 30-50 % | 100 % (referencia) | ~110 % (sobre) | 20-40 % |
| Depuración en registros | Requiere herramientas auxiliares | Trivial (jq, grep) | Trivial | Requiere herramientas auxiliares |
| Evolución del esquema | Fuerte (campos reservados y números de campo) | Manual, disciplina humana | Depende de la carga útil | Fuerte (registro hace cumplir) |
| Detección de cambios incompatibles | `buf breaking`, excelente | Herramientas inmaduras | Depende de la carga útil | El registro valida al publicar |
| Generación de código TypeScript | Excelente (ts-proto, protobuf-es) | Manual más Zod | Manual | Aceptable (ecosistema kafkajs) |
| Generación de código Dart | Oficial, madura | De terceros (quicktype) | De terceros, no oficial | Inmadura |
| Generación de código Python | Excelente (betterproto) | Manual más pydantic | Manual | Aceptable (confluent-kafka-python) |
| Validación en tiempo de ejecución | Embebida en código generado | Zod solo en TypeScript | Depende de la carga útil | Vía registro más código generado |
| Reutilización con archivos `.proto` ya existentes | Total | Duplicación | Duplicación | No aplica |
| Costo operacional | buf.build gratuito/de pago o autoalojado | Cero | Cero extra | Operación del registro |
| Madurez del cliente Dart | Alta | Media | Baja | Baja |
| Severidad de la dependencia encadenada | Moderada | Baja | Baja | Alta (acoplamiento con Kafka) |

---

### Señales para revisitar la decisión 2

**Protobuf con buf.build** es la elección correcta dado que:
1. Ya existe `events.v1` en `payments-core` (supuesto del cuestionario).
2. El transporte gRPC paralelo permite cero duplicación de contrato.
3. `protoc-gen-dart` oficial es maduro.
4. `buf breaking` en la integración continua da confianza real en la evolución.

**Alternativa si no hubiera Protobuf ya establecido:** JSON más JSON Schema en el repositorio `shared-schemas`. Zod solo para ayudantes internos de TypeScript; Dart y Python consumen JSON Schema directamente con `quicktype` o `datamodel-code-generator`.

**Descartar:**
- **CloudEvents:** doble esquema sin retorno interno (reevaluar si después se integra EventBridge).
- **Avro:** acoplamiento con Kafka sin Kafka. Solo válido si la decisión 1 es Kafka.

**Revisitar la decisión 2 si:**

- [ ] Se integra con tres o más sistemas externos nativos de CloudEvents → considerar envolver la carga útil Protobuf con el sobre CloudEvents (híbrido válido).
- [ ] El costo de ancho de banda de los eventos supera el 20 % de la factura de infraestructura → revisar si JSON fue la elección.
- [ ] Se detecta desviación entre el `.proto` (llamadas remotas) y el JSON Schema (eventos) que causa más de dos incidentes por trimestre → consolidar en Protobuf.
- [ ] La decisión 1 migra a Kafka → evaluar Avro como segundo actor (Protobuf y Avro pueden convivir para temas distintos).

---

## Parte III — Decisión 3: Notificaciones entrantes de pasarelas de pago

> **💡 Idea central:** La decisión entre asíncrono y síncrono no es sobre "qué es más simple", es sobre **quién asume el riesgo de las fallas de los servicios internos**. El modo síncrono delega el problema a la pasarela externa; el asíncrono lo mantiene en nuestra infraestructura con visibilidad y control. El primero se siente simple; el segundo es correcto.

### Marco de evaluación de la decisión 3

Dimensiones relevantes:

1. **Política de reintentos de la pasarela** — Stripe reintenta con retroceso exponencial durante tres días. OnvoPay y Tilopay están menos documentadas. Expiración típica de la respuesta: 20 segundos.
2. **Garantías de idempotencia** — las notificaciones duplicadas son la norma, no la excepción. ¿Cómo se detectan y descartan?
3. **Momento de verificar la firma criptográfica** — con qué secreto compartido, en qué paso, qué hacer si falla.
4. **Aislamiento ante fallas** — si el bus de eventos o la base de datos están caídos, ¿qué se responde a la pasarela?
5. **Objetivo de tiempo de respuesta** — menos de dos segundos es ideal; menos de veinte segundos es el límite duro típico.
6. **Observabilidad** — ¿se puede trazar una notificación desde la recepción hasta su efecto final en la base y en el bus?
7. **Capacidad de reprocesamiento** — cuando se detecta un error, ¿se pueden reprocesar notificaciones históricas sin contactar a la pasarela?

### Opción 3.A — Procesamiento asíncrono con cola de reintentos

**Flujo de la arquitectura**
1. La pasarela hace POST al punto de acceso de notificaciones de `payments-core`.
2. `payments-core` verifica la firma criptográfica con el secreto compartido de la pasarela.
3. Se verifica idempotencia: consulta en Redis (tiempo de vida de 24 horas) o en una tabla `webhook_events_received` por la llave `(proveedor, identificador_del_evento)`.
4. ACK inmediato `200 OK` a la pasarela.
5. Se encola un trabajo de procesamiento en la cola.
6. Un trabajador asíncrono toma el trabajo, procesa (escribe en la base más publica en el bus), con reintentos de retroceso exponencial (máximo cinco intentos: 1 s, 4 s, 16 s, 64 s, 256 s → unos cinco minutos totales).
7. Si todos los reintentos fallan → cola de mensajes muertos más alerta.

**Implicaciones técnicas**
- **Latencia hacia la pasarela:** 50 a 200 milisegundos (firma más idempotencia más encolado). Muy por debajo del límite.
- **Aislamiento ante fallas:** bus de eventos caído o base caída no rechazan la notificación. El trabajador acumula retraso y procesa cuando los servicios internos vuelven.
- **Idempotencia en dos niveles:** (1) tabla de notificaciones recibidas con restricción de unicidad sobre `(proveedor, identificador_del_evento)`; (2) deduplicación en el trabajador por un identificador de trabajo derivado.
- **Reprocesamiento:** la tabla de notificaciones es la fuente única de verdad. Reprocesar equivale a re-encolar trabajos desde la tabla.
- **Observabilidad:** un identificador de traza desde la fila de la notificación recibida → trabajo encolado → evento publicado → suscriptores, propagable si se modelan bien las cabeceras de traza.

**Contrapartidas ocultas**
- **Desacoplamiento real:** la recepción de la notificación y su procesamiento tienen objetivos de tiempo distintos. El acuerdo de nivel de servicio frente a la pasarela es estricto (responder rápido). El acuerdo de procesamiento es relajado (eventualmente). Esto es una ventaja, no un problema.
- **La cola de mensajes muertos necesita alertas:** sin alertas, se vuelve un cementerio silencioso. Hay que integrar con PagerDuty, Slack o correo al insertar en ella.
- **Consideración de orden:** notificaciones del mismo cliente pueden procesarse fuera de orden si el trabajador es concurrente. Mitigación: fragmentar al trabajador por identificador de cliente con enrutamiento consistente.
- **Pruebas de punta a punta más caras:** hace falta un arnés que cubra entrada → cola → trabajador → efectos secundarios. Vale la pena, pero es inversión inicial.

**Cuándo es la elección correcta**
- Casi siempre. Es el patrón industrial estándar.
- Especialmente cuando: hay varias pasarelas con acuerdos de nivel distintos; el volumen supera diez notificaciones por segundo; los servicios internos tienen dependencias que pueden fallar independientemente.

---

### Opción 3.B — Procesamiento síncrono bloqueante

**Flujo de la arquitectura**
1. La pasarela hace POST al punto de acceso.
2. `payments-core` verifica la firma.
3. Procesa la escritura en base más publicación en el bus **dentro del mismo request HTTP**.
4. Responde `200 OK` si todo está bien; `5xx` si algo falla.
5. La pasarela reintenta en caso de `5xx` según su política.

**Implicaciones técnicas**
- **Latencia hacia la pasarela:** suma de toda la cadena de procesamiento. Fácilmente más de un segundo si el bus está lento.
- **Aislamiento ante fallas: ninguno.** Si el bus cae, todas las notificaciones devuelven `5xx` y la pasarela entra en tormenta de reintentos.
- **Idempotencia:** sigue siendo necesaria (la pasarela reintenta). Pero el ciclo de reintentos bajo carga amplifica la sobrecarga en el peor momento posible.
- **Reprocesamiento:** limitado. Si se procesó una notificación y luego se detecta un error, hay que reconstruir el estado manualmente.
- **Observabilidad:** más simple, una sola traza por request.

**Contrapartidas ocultas**
- **Destino compartido:** el acuerdo de nivel frente a la pasarela queda acoplado al acuerdo de la base y el bus. Una consulta lenta durante Black Friday → reintentos de la pasarela → amplificación de carga en el peor momento.
- **Política de reintentos de Stripe:** "si devuelves algo distinto de 2xx, reintentamos con retroceso exponencial hasta tres días". Bajo carga normal es una ventaja; bajo un error que hace fallar a todas las notificaciones, se acumulan tres días de carga esperando a que se arregle.
- **Apariencia engañosa de simplicidad:** el código parece simple pero el comportamiento bajo fallas es complejo.

**Cuándo es la elección correcta**
- Producto mínimo viable con volumen muy bajo (menos de una notificación por segundo) y una sola pasarela.
- **Casi nunca en producción seria.**

---

### Opción 3.C — Modelo híbrido (síncrono para eventos críticos, asíncrono para los demás)

**Flujo de la arquitectura**
- Enrutamiento al inicio del manejador según el tipo de evento.
- Eventos críticos (PaymentSucceeded, RefundIssued) → ruta síncrona.
- Eventos analíticos (actualizaciones de metadatos, desglose de comisiones) → cola asíncrona.

**Implicaciones técnicas**
- **Rutas de código mixtas:** doble superficie para pruebas, depuración, documentación, integración de personal nuevo.
- **Los eventos críticos siguen con destino compartido:** exactamente el mismo problema que la opción 3.B, solo que restringido al subconjunto "crítico".
- **Los eventos analíticos quedan bien aislados:** el beneficio real está aquí, pero es el subconjunto menos urgente.
- **"Crítico" es una categoría fluida:** la lista de tipos de evento críticos cambia conforme evoluciona el producto. Cada cambio requiere revisar el enrutamiento.

**Contrapartidas ocultas**
- **La razón para lo híbrido suele ser una ilusión:** "los eventos críticos necesitan respuesta síncrona para la experiencia del usuario". Pero el estado visible al usuario (redirección después del pago, confirmación en la interfaz) **no depende de la notificación** — depende de la devolución de llamada del kit de desarrollo de la pasarela o de la consulta periódica al objeto del pago. La notificación es para sincronizar el estado del lado servidor, que es naturalmente asíncrono.
- **Complejidad sin ventaja clara:** el beneficio de aislar lo analítico en asíncrono se logra con "todo asíncrono" sin el costo de mantener dos rutas.
- **Análisis posterior al incidente típico:** "debimos haber usado asíncrono siempre".

**Cuándo es la elección correcta**
- Raro. Requiere restricciones muy específicas (por ejemplo, requisito regulatorio de "procesar síncronamente" en verticales financieros regulados).
- Stripe, OnvoPay y Tilopay no imponen tal restricción → no aplica aquí.

---

### Matriz comparativa de la decisión 3

| Dimensión | Asíncrono con cola | Síncrono bloqueante | Híbrido |
|---|---|---|---|
| Latencia de respuesta a la pasarela | Menos de 200 ms | 500 ms a 2 s o más | Mixta según la ruta |
| Aislamiento ante fallas | Alto | Ninguno | Parcial |
| Riesgo de tormenta de reintentos bajo carga | Bajo (la pasarela ve 200 OK) | Alto | Medio |
| Idempotencia necesaria | Sí (explícita, en dos niveles) | Sí (por los reintentos de la pasarela) | Sí |
| Capacidad de reprocesamiento | Trivial (re-encolar desde la tabla) | Limitada | Mixta |
| Observabilidad | Requiere propagación de traza | Traza simple por request | Requiere ambas estrategias |
| Complejidad operacional | Media (cola más trabajador más cola de muertos) | Baja | Alta |
| Modo de falla bajo carga | Retraso del trabajador (alertable) | Tormenta de reintentos más amplificación | Mixto |
| Esfuerzo de pruebas | Mayor (arnés de punta a punta) | Menor (prueba unitaria del manejador) | Mayor (cubre ambas rutas) |
| Modelo mental | Un solo patrón consistente | Un solo patrón simple | Dos patrones simultáneos |

---

### Señales para revisitar la decisión 3

**Asíncrono con cola de reintentos** es la elección correcta. Es el patrón industrial por buenas razones. Variables a definir en la implementación:

1. **Almacén de la cola:** si la decisión 1 es NATS JetStream → flujo dedicado `webhooks.inbound.{proveedor}`. Si la decisión 1 es Postgres con LISTEN/NOTIFY → tabla `webhook_jobs` con trabajador que consulta periódicamente.
2. **Almacén de idempotencia:** Redis con tiempo de vida de 24 horas **o** tabla `webhook_events_received` con restricción de unicidad en `(proveedor, identificador_del_evento)`. Redis es más rápido; la tabla es más simple y reutilizable para reprocesamiento.
3. **Política de reintentos:** retroceso exponencial 1 s, 4 s, 16 s, 64 s, 256 s. Después → cola de mensajes muertos más alerta obligatoria.
4. **Verificación de firma antes del ACK:** nunca responder `200 OK` a una notificación sin haber verificado la firma. Si falla → `401`, no `200`.
5. **Fragmentación del trabajador:** por identificador de cliente si el orden por cliente importa.

**Revisitar la decisión 3 si:**

- [ ] Se detecta una razón de negocio *real* para sincronía en algún tipo de evento (no percibida).
- [ ] El retraso del trabajador supera un minuto en el percentil 99 bajo carga normal → fragmentar trabajadores por proveedor o cliente.
- [ ] Una pasarela cambia su política de reintentos (por ejemplo, reduce la expiración de 20 a 5 segundos) → validar que el margen de latencia sigue siendo cómodo.
- [ ] La tasa de mensajes muertos supera el 0.1 % sostenido → investigar la causa raíz antes de considerar cambios arquitectónicos.

---

## Parte IV — Decisión 4: Consumo de los cores desde las aplicaciones Dart

> **💡 Idea central:** La pregunta real no es "¿gRPC o REST?", es "¿quién paga el costo de la seguridad de tipos de punta a punta?". gRPC nativo lo paga en la tubería de compilación (paso de generación de código, versionado del código generado). El intermediario HTTP lo paga en operación (tres servidores adicionales). La puerta de enlace Serverpod lo paga en fragmentación arquitectónica (dos patrones para tres aplicaciones). No hay opción gratis.

### Marco de evaluación de la decisión 4

Dimensiones:

1. **Seguridad de tipos de punta a punta** — ¿el contrato del servidor llega sin pérdida al cliente Dart?
2. **Eficiencia del transporte** — HTTP/2 binario contra HTTP/1.1 con JSON.
3. **Complejidad de la tubería de compilación** — ¿cuánto agrega a la integración continua de cada aplicación?
4. **Compatibilidad con Flutter Web** — ¿funciona en navegador o solo en móviles?
5. **Soporte de transmisión continua** — ¿se soportan flujos desde el servidor nativamente?
6. **Autenticación e intermediarios** — ¿cómo se propagan tokens, observabilidad, reintentos?
7. **Impacto en el tamaño del paquete de la aplicación** — ¿cuánto agrega al archivo final?
8. **Comportamiento en redes móviles** — HTTP/2 en redes móviles inestables.

### Opción 4.A — gRPC Dart nativo con compilación de esquemas

**Arquitectura**
- `package:grpc` (oficial, mantenido por el equipo Dart) en `pubspec.yaml`.
- Archivos `.proto` generados a clases Dart con `protoc --dart_out=generated/`.
- Paso en la integración continua: `buf generate` o invocación de `protoc` antes de `flutter build`.
- Cliente típico: `final client = MarketplaceServiceClient(channel); final resp = await client.listListings(req);`

**Implicaciones técnicas**
- **Seguridad de tipos:** total. Protobuf es la fuente única de verdad; servidor y cliente son isomorfos.
- **Transporte:** HTTP/2 con tramas binarias. Eficiente en ancho de banda y latencia.
- **Tubería de compilación:** agrega `protoc-gen-dart` más (opcionalmente) `buf` como dependencias de desarrollo. Un paso previo a la compilación en la integración continua.
- **Advertencia importante sobre Flutter Web:** gRPC directo **no funciona** en navegadores — los navegadores no exponen los "tráileres" de HTTP/2 ni el control de tramas de bajo nivel. Hay que usar **gRPC-Web** con un intermediario (Envoy o `grpcwebproxy`) entre Flutter Web y el servidor. Flutter móvil (iOS y Android) funciona directo sin intermediario.
- **Transmisión continua:** transmisión desde el servidor y bidireccional soportadas en `package:grpc`.
- **Autenticación:** `package:grpc` soporta interceptores. Propagar el token en los metadatos es el patrón estándar.
- **Tamaño del paquete:** `package:grpc` más el código generado agregan unos 200 a 400 kilobytes al paquete final (varía según cuántos servicios se consuman).
- **Redes móviles:** la multiplexación de HTTP/2 ayuda, pero la recuperación tras pérdida de conexión requiere manejo explícito (reconexión con retroceso).

**Contrapartidas ocultas**
- **gRPC-Web obligatorio si hay Flutter Web en el alcance:** hay que desplegar Envoy o `grpcwebproxy`. Complejidad operacional adicional nada trivial.
- **Fragilidad del paso de generación en la integración continua:** los fallos de `protoc` o `buf` pueden bloquear los despliegues. Mitigación: versionar el código generado (comprometerlo al repositorio) a costo de riesgo de desviación entre el `.proto` y el `.dart`.
- **Paridad con Serverpod:** si `marketplace-core` y `payments-core` usan Serverpod, el archivo `.proto` probablemente ya lo genera Serverpod. Reutilizar ese archivo directamente — no regenerarlo.
- **Depuración:** `grpcurl` es la herramienta principal. Los registros del cliente son binarios → hay que configurar un interceptor que formatee los mensajes a texto para poder leerlos.
- **Modelo de errores:** los códigos de estado de gRPC (`UNAVAILABLE`, `DEADLINE_EXCEEDED`, etc.) son distintos de los códigos HTTP. Mapearlos a errores Dart idiomáticos requiere un interceptor y una convención.

**Cuándo es la elección correcta**
- Primario móvil (iOS y Android como objetivos principales). Sin salvedades.
- El servidor ya expone gRPC nativo (estilo Serverpod o servidor gRPC directo).
- Se prioriza la seguridad de tipos y el rendimiento sobre la simplicidad operacional.

---

### Opción 4.B — Procurador HTTP intermedio por aplicación

**Arquitectura**
- Cada aplicación Dart tiene su propio servidor intermediario (TypeScript con NestJS, o Python con FastAPI) que traduce REST a gRPC.
- El cliente Dart habla REST con JSON al servidor propio.
- El servidor propio habla gRPC a los cores.
- Tres aplicaciones Dart → tres servidores intermediarios.

**Implicaciones técnicas**
- **Seguridad de tipos:** se rompe en la frontera REST. Hay que redefinir los tipos en Dart (manualmente o con generación desde OpenAPI).
- **Eficiencia del transporte:** se pierde HTTP/2 entre Dart y el servidor intermediario (es REST con JSON). Se mantiene HTTP/2 entre el servidor intermediario y los cores.
- **Tubería de compilación:** un servidor más que mantener por aplicación Dart. Tres aplicaciones son tres servidores con sus despliegues, pruebas y monitorización.
- **Flutter Web:** funciona trivialmente. No hay que configurar gRPC-Web.
- **Transmisión continua:** los flujos desde el servidor sobre REST son incómodos — eventos enviados por el servidor (SSE), consulta periódica larga, o WebSockets. Cada uno con sus propias compensaciones.
- **Autenticación:** estándar, token portador en la cabecera `Authorization`.
- **Tamaño del paquete:** menor que gRPC (solo cliente HTTP más análisis JSON).

**Contrapartidas ocultas**
- **Tres servidores intermediarios significan tres veces la carga operacional:** despliegues, monitorización, escalamiento, parches de seguridad, costo. Si son procuradores sin lógica propia, son puro costo.
- **Riesgo alto de desviación:** cuando el `.proto` cambia en los cores, hay que actualizar los tres servidores en sincronía. Mayor superficie para olvidarse de alguno.
- **Latencia adicional:** un salto más → 30 a 100 milisegundos extra según la región. Relevante para respuestas que el usuario ve.
- **La ventaja real emerge solo si los servidores intermediarios agregan valor** (memoria intermedia, agregación, limitación de permisos, patrón de servidor para frontend). Si son solo procuradores, son desperdicio.

**Cuándo es la elección correcta**
- Aplicación primariamente web (se evita configurar gRPC-Web a cambio de tres servidores — compensación discutible).
- Los servidores intermediarios tienen lógica propia (memoria intermedia, agregación, patrón de servidor para frontend).
- El equipo prefiere mantener una pila homogénea (un solo lenguaje en el servidor intermediario, antes que aprender los patrones de `protoc`).

---

### Opción 4.C — Puerta de enlace en Serverpod

**Arquitectura**
- Un módulo Serverpod en los servidores que ya usan Serverpod (vertivolatam, aduanext).
- El módulo habla gRPC a los cores internamente y expone puntos de acceso Serverpod a los clientes Dart.
- habitanexus **no usa Serverpod** → no aplica; requiere una solución distinta.

**Implicaciones técnicas**
- **Asimetría entre aplicaciones:** dos aplicaciones usan la puerta Serverpod, una (habitanexus) usa otra solución. Resultado: dos patrones conviviendo.
- **Seguridad de tipos:** a través de los tipos generados por Serverpod. Calidad similar a gRPC nativo si el mapeo está bien hecho.
- **Transporte:** protocolo propio de Serverpod (binario sobre WebSocket o HTTP). No es gRPC estándar.
- **habitanexus queda excluido:** requiere opción 4.A o 4.B en paralelo → fragmentación.

**Contrapartidas ocultas**
- **Fragmentación arquitectónica:** mantener dos patrones (puerta Serverpod más algo distinto para habitanexus) duplica la carga mental del equipo. Cada característica que toque clientes Dart requiere decidir "¿cuál aplicación?" antes de decidir "¿cómo?".
- **Dependencia encadenada más profunda con Serverpod:** cada integración nueva con los cores requiere reimplementación vía puntos de acceso Serverpod.
- **Si el valor de Serverpod es su experiencia nativa Dart**, migrar a gRPC directo la pierde parcialmente → la opción mezclada nunca es óptima en ninguna dimensión.

**Cuándo es la elección correcta**
- **Todas** las aplicaciones Dart usan Serverpod.
- **No aplica aquí** (habitanexus no lo usa).

---

### Matriz comparativa de la decisión 4

| Dimensión | gRPC Dart nativo | Procurador HTTP | Puerta Serverpod |
|---|---|---|---|
| Seguridad de tipos de punta a punta | Total | Rota en la frontera REST | Vía tipos de Serverpod |
| Flutter móvil (iOS y Android) | Trivial | Trivial | Trivial |
| Flutter Web | Requiere intermediario gRPC-Web | Trivial | Trivial |
| Complejidad de compilación en la aplicación | Media (paso protoc en la integración continua) | Baja | Media (generación Serverpod) |
| Carga operacional adicional | Un Envoy o grpcwebproxy (si hay web) | Tres servidores intermediarios | Dos módulos Serverpod más plan B |
| Soporte de transmisión continua | Nativo (servidor y bidireccional) | Incómodo (SSE o WebSocket) | Vía flujos Serverpod |
| Impacto en el tamaño del paquete | +200 a +400 KB | +50 KB (cliente HTTP) | +cliente Serverpod |
| Reutilización del `.proto` de los cores | Directa | Duplicación en tres servidores | Envoltura parcial |
| Riesgo de desviación al cambiar el `.proto` | Bajo (una sola fuente regenerada) | Alto (tres servidores sincronizados) | Medio |
| Compatibilidad con habitanexus | Sí | Sí | **No** (requiere plan B separado) |
| Latencia adicional frente a gRPC directo | ~0 (gRPC directo) | +30 a +100 ms (un salto) | ~0 (Serverpod directo) |

---

### Señales para revisitar la decisión 4

**gRPC Dart nativo con compilación de esquemas** es la elección correcta siempre que:

1. Las tres aplicaciones son primariamente móviles (iOS y Android como objetivo principal). Flutter Web es secundario o no necesario.
2. Se está dispuesto a configurar Envoy o `grpcwebproxy` si Flutter Web se vuelve objetivo serio.
3. Se acepta el paso de `protoc` en la integración continua (versionar el código generado mitiga la fragilidad).

Si Flutter Web es crítico para al menos una de las tres aplicaciones, la compensación real es:
- **Configuración de gRPC-Web:** un intermediario, mantiene la seguridad de tipos.
- **Procurador HTTP:** tres servidores, se pierde la seguridad de tipos, más carga operacional.

La pregunta: ¿operar un intermediario especializado o tres servidores procuradores? Generalmente uno es mejor.

**Revisitar la decisión 4 si:**

- [ ] Flutter Web se vuelve objetivo principal para al menos una de las tres aplicaciones.
- [ ] Configurar Envoy con gRPC-Web genera más incidentes que los tres servidores procuradores habrían generado.
- [ ] Llega una nueva aplicación Dart sin Serverpod → reconsiderar uniformidad.
- [ ] El tamaño del paquete supera un megabyte y la atribución a `package:grpc` más el código generado es más del 30 % del incremento → evaluar reducción por análisis de uso muerto o envoltura parcial.

---

## Parte V — Acoplamiento entre decisiones

### Cómo interactúan las cuatro decisiones

| Si la decisión 1 es... | La decisión 2 debería ser... | La cola de la decisión 3 vive en... | La decisión 4... |
|---|---|---|---|
| NATS JetStream | **Protobuf** (paridad con gRPC). Avro: no. | Flujo dedicado `webhooks.inbound.{proveedor}` en JetStream | gRPC nativo (Protobuf reutilizado) |
| Kafka | **Avro** tiene sentido (el registro hace cumplir). Protobuf también es válido. | Tema `webhooks.inbound` particionado por proveedor | gRPC nativo (Protobuf reutilizado) |
| RabbitMQ | **Protobuf o JSON** (Avro no tiene sentido) | Cola `webhooks.inbound` con cola de mensajes muertos | gRPC nativo (Protobuf reutilizado) |
| Postgres con LISTEN/NOTIFY | **JSON** (el límite de 8 KB y la ilegibilidad de binario en SQL descartan Protobuf) | Tabla `webhook_jobs` consultada periódicamente por un trabajador | gRPC nativo (independiente del intermediario) |

### Combinaciones incoherentes (señales de alarma)

- 🚩 **Postgres con LISTEN/NOTIFY más Protobuf binario** → el límite de 8 KB de la carga útil más la ilegibilidad en SQL durante depuración hacen incompatible la combinación.
- 🚩 **Avro más cualquier intermediario que no sea Kafka** → decisión incoherente. Avro agrega complejidad sin el ecosistema que la justifica.
- 🚩 **Notificaciones síncronas (opción 3.B) más cualquier intermediario** → el intermediario no soluciona el problema de latencia extrema de la pasarela. La elección asíncrona es ortogonal al intermediario elegido.
- 🚩 **Puerta Serverpod (opción 4.C) con habitanexus en el alcance** → incompatible por definición (habitanexus no usa Serverpod).
- 🚩 **Procuradores HTTP (opción 4.B) más codificación Protobuf de eventos (opción 2.A)** → los tres servidores intermediarios tendrán que analizar Protobuf y reemitir JSON, duplicando el contrato que la decisión 2 pretendía consolidar.

### Recomendación combinada

Para el caso concreto (cuatro servicios internos, tres aplicaciones Dart, pasarelas Stripe, OnvoPay, Tilopay, primario móvil):

| Decisión | Elección |
|---|---|
| 1 — Intermediario | **NATS JetStream** |
| 2 — Codificación | **Protobuf con buf.build** |
| 3 — Notificaciones entrantes | **Asíncrono con cola de reintentos** sobre flujo JetStream `webhooks.inbound.*` |
| 4 — Consumo desde Dart | **gRPC nativo con compilación de esquemas** (más Envoy si Flutter Web entra en el alcance) |

Esta combinación maximiza:
- Reutilización de los archivos `.proto` entre llamadas remotas, eventos y notificaciones entrantes.
- Aislamiento ante fallas entre pasarelas, bus y base.
- Seguridad de tipos de punta a punta entre lenguajes.
- Simplicidad operacional (un intermediario, una autoridad de esquemas, un intermediario HTTP solo si hace falta web).

Y minimiza:
- Duplicación de contratos (Protobuf como fuente única de verdad).
- Superficie operacional (NATS es simple de operar; Envoy solo si la situación lo exige).
- Desviación entre componentes.

---

## Parte VI — Estado actual del ecosistema y gaps de implementación

> **Fecha del estudio:** 2026-04-20. Basado en auditoría read-only sobre ocho repositorios: `infraestructura-backend`, `habitanexus`, `vertivolatam`, `altrupets`, `aduanext`, `marketplace-core`, `agentic-core`, `dojocoding/dojo-os`.
>
> **Propósito:** las Partes I–V exponen el marco teórico de las cuatro decisiones. Esta parte contrasta ese marco con la **realidad actual** del ecosistema y documenta las decisiones implícitas ya tomadas que deberían sesgar la elección "limpia" hacia la opción que hereda menos infra nueva.

### 6.1 Inventario por repositorio

| Repositorio | Namespace K8s | Intermediario / mensajería actual | Transporte entre sidecares | Definición de esquemas / emisor de eventos |
|---|---|---|---|---|
| `infraestructura-backend` | compartido (no exclusivo) | Redis + Postgres (únicamente caché y sesiones; sin LISTEN/NOTIFY activo) | — | — |
| `habitanexus` | ninguno (aplicación Dart/Flutter pura, sin backend todavía) | Horizon SSE de Stellar para eventos on-chain; Kindo HTTP; `trustless_work_dart` | HTTP directo + consulta periódica on-chain | Siete tipos de `EscrowEvent` generados desde el contrato Soroban |
| `vertivolatam` | `vertivo-dev` | **EMQX MQTT 5.8.6** en Kubernetes (bloqueado al dominio IoT) | MQTT 1883 TCP / 8083 WebSocket | Tópicos de telemetría de invernaderos, sin eventos de dominio de negocio |
| `altrupets` | Helm + Terraform (manifiestos no hallados en la auditoría) | Redis (solo caché vía `cache-manager-redis-yet`) | GraphQL + REST entre servicios | **Ningún emisor de eventos entre los diez microservicios NestJS** |
| `aduanext` | `aduanext` (Pod singleton con tres sidecares) | Redis + `pgvector:pg16` (dev) | **gRPC loopback `127.0.0.1`** entre los tres sidecares del mismo Pod | Serverpod → `hacienda-sidecar` → `agentic-core` vía llamadas gRPC directas |
| `marketplace-core` | (librería, no despliega por sí sola) | Puerto `EventBus` declarado en el dominio, **sin adaptador concreto** | gRPC `@grpc/grpc-js` puerto 50051 | `proto/marketplace_core.proto` (seis servicios) + diez eventos en `src/shared-kernel/events.ts` |
| `agentic-core` | (librería, despliegue como sidecar) | Redis + Postgres + FalkorDB (memoria de agentes, no bus) | gRPC `grpc-aio` puerto 50051 | `proto/agentic_core.proto` (cinco servicios). **No publica eventos hoy** |

**Observación transversal:** no existe un intermediario común del ecosistema. Cada repositorio eligió según su dominio: EMQX MQTT para IoT (Vertivolatam), Redis para caché (tres repos), y varias formas de no-elegir-nada (habitanexus, marketplace-core, altrupets entre servicios internos).

---

### 6.2 Sidecares y contratos proto existentes

Los tres `-core` que se despliegan como sidecares tienen madurez asimétrica en los patrones operacionales:

| Sidecar | Lenguaje / runtime gRPC | Archivo proto | Puerto gRPC | Revisión de salud | Observabilidad |
|---|---|---|---|---|---|
| `agentic-core` | Python `grpc-aio` | `proto/agentic_core.proto` (5 servicios) | 50051 (env `GRPC_PORT`) | RPC personalizado `HealthCheck()` (no estándar) | Registro con `logging` estándar de Python; sin OpenTelemetry |
| `marketplace-core` | Node `@grpc/grpc-js` | `proto/marketplace_core.proto` (6 servicios, 50+ métodos) | 50051 | **Ausente** (no expone servicio de salud) | Sin registro estructurado detectado |
| `payments-core` | Node `@grpc/grpc-js` | `proto/lapc506/payments_core/v1/payments_core.proto` + `events/v1/*` (14 RPC + 14 mensajes de evento) | 50051 | **`grpc.health.v1.Health` completo** (estándar del RFC) | **Pino** (registros JSON estructurados, nivel configurable) |

**Todos** los sidecares se despliegan hoy como contenedores Docker autónomos (no hay patrón K8s sidecar init-container ni malla de servicios). Todos usan el puerto **50051** por defecto. La compatibilidad cross-lenguaje está verificada (Python ↔ TypeScript vía `proto3` + código generado).

**Brecha crítica para observabilidad transversal:** `agentic-core` y `marketplace-core` deben migrar a `grpc.health.v1.Health` + registro estructurado (Pino en Node, `structlog` en Python) + exportador OpenTelemetry. Sin esto, un problema en el flujo de eventos cross-core no se puede correlacionar entre sidecares.

---

### 6.3 AduaNext como patrón de referencia multi-sidecar

AduaNext es hoy el **único repositorio** del ecosistema que corre tres sidecares en un mismo Pod de Kubernetes:

```
Pod: aduanext (namespace: aduanext)
├── Serverpod (backend Dart)         — puerto 8080
├── hacienda-sidecar (TS, gRPC)      — puerto 50051 (loopback)
└── agentic-core (Python, gRPC)      — puerto 50052 (loopback)
```

La comunicación entre sidecares viaja por `127.0.0.1:5005x`, eliminando latencia de red y evitando exponer puertos al exterior del Pod. **Este es el patrón de referencia** para cuando los demás repositorios integren `marketplace-core` + `payments-core` (y eventualmente `invoice-core` + `compliance-core`) como sidecares.

**Implicación directa para la Decisión 1 (intermediario):** cuando los sidecares viven en el mismo Pod, un bus de eventos externo **no es estrictamente necesario**. Los eventos pueden viajar por gRPC loopback (llamada directa). El intermediario externo (NATS, Postgres, Kafka) se justifica solo cuando:

- Los sidecares viven en Pods distintos (por escalado, por aislamiento, por límites de recursos).
- Se requiere rebobinado o persistencia que sobreviva a reinicios del Pod.
- Hay consumidores fuera del Pod (analítica, tableros, auditoría externa).

Si se adopta el patrón AduaNext, la Decisión 1 se puede **posponer hasta que aparezca alguno de los tres disparadores**, y mientras tanto cada startup adopta el mismo patrón loopback.

---

### 6.4 Eventos de dominio emitidos hoy (verdad-en-tierra)

| Repositorio | Eventos que emite hoy | Infraestructura de entrega | Observación |
|---|---|---|---|
| `habitanexus` | `EscrowInitialized`, `EscrowFunded`, `EscrowMilestoneStatusChanged`, `EscrowMilestoneApproved`, `EscrowReleased`, `EscrowDisputeStarted`, `EscrowDisputeResolved` | Horizon SSE de Stellar (on-chain) | No viajan por un bus interno; provienen directamente del contrato Soroban. Son consumibles por `payments-core` solo si se implementa un adaptador Stellar. |
| `vertivolatam` | Telemetría IoT (ingesta de sensores) y eventos agronómicos (cosecha, fitopatología) | MQTT EMQX | El transporte está amarrado al namespace `vertivo-dev`. Para eventos de dominio cross-core (por ejemplo, `ProductoSolicitado` de Caja Vertivo), **no** conviene usar MQTT: es un canal IoT, no un bus de dominio. |
| `altrupets` | (ninguno entre servicios internos) | N/A | Brecha crítica. Diez microservicios NestJS sin `EventEmitter` compartido. `DonationReceived`, `AdoptionMatched`, `SubsidyApproved` todavía no existen como eventos. |
| `aduanext` | Transiciones de estado de la DUA (draft → validated → signed → presented → levante) y respuestas de ATENA | gRPC loopback entre los tres sidecares del mismo Pod | Los eventos de dominio fluyen Serverpod ↔ `hacienda-sidecar` ↔ `agentic-core` por gRPC directo. Sin intermediario externo. Funciona porque todos los consumidores viven en el mismo Pod. |
| `payments-core` | Webhooks entrantes de Stripe, OnvoPay, Tilopay (pendientes de wire end-to-end) | Manejadores HTTP + verificador compartido `_shared/webhook-verifier.ts` | Patrón: verificación HMAC, idempotencia vía tabla `stripe_events`, reintentos 3x con retroceso exponencial. Es la implementación concreta de la opción 3.A. |

**Lectura combinada:** hoy el único flujo de eventos de dominio en producción dentro del ecosistema `-core` es el de la DUA en AduaNext vía gRPC loopback. Para notificaciones entrantes, `payments-core` ya ha extraído el patrón asíncrono con idempotencia y reintentos (opción 3.A) a un módulo compartido reutilizable.

---

### 6.5 Decisiones implícitas ya tomadas

Antes de adoptar una opción "limpia" en cada decisión, es honesto reconocer las decisiones **ya tomadas en producción** que actúan como restricciones o como atajos:

**1. EMQX MQTT es verdad-en-tierra en Vertivolatam.** Está bloqueado a la versión 5.8.6 del operador y vive en el namespace `vertivo-dev`. Agregar un segundo intermediario (NATS, Kafka, RabbitMQ) al mismo cluster introduce doble-infraestructura con dos SLOs, dos estrategias de respaldo y dos cuadros de observabilidad. No es prohibitivo, pero es una obligación operacional que debe reconocerse.

**2. `payments-core/events/v1/*.proto` ya existe con catorce mensajes de evento definidos** (fusionado en PR #16). Rechazar Protobuf (opción 2.A) requiere duplicar el contrato en otro formato y mantener ambos sincronizados. La probabilidad de desviación es alta, el beneficio marginal.

**3. AduaNext ya ejecuta Dart ↔ gRPC loopback en producción** (Serverpod invoca `hacienda-sidecar` en `127.0.0.1:50051`). La opción 4.A (gRPC Dart nativo con compilación de esquemas) está probada y funciona. Las demás alternativas (procurador HTTP, puerta de enlace Serverpod) introducen capas nuevas que nadie ha validado en este ecosistema.

**4. El verificador compartido `payments-core/_shared/payments-core/webhook-verifier.ts` implementa notificaciones entrantes asíncronas con idempotencia y reintentos 3x**, usando una tabla `stripe_events` en Postgres. Es la opción 3.A en implementación real, lista para que los sidecares la adopten. Las opciones 3.B (síncrono) y 3.C (híbrido) no tienen implementación existente en el ecosistema.

**Lectura cruzada:** tres de las cuatro decisiones tienen una opción que ya está respaldada por código probado en el ecosistema. Adoptar esa opción significa heredar un patrón existente en vez de introducir infraestructura nueva. La decisión 1 (intermediario) es la única realmente abierta; su opción 1.A (EMQX) tiene presencia parcial pero está bloqueada al dominio IoT de Vertivolatam.

---

### 6.6 Brechas por decisión

Cada decisión del marco (Partes I–IV) choca con brechas específicas en la implementación actual. Las tablas a continuación son el puente entre "lo teórico" y "lo que hay que implementar".

#### Decisión 1 — Intermediario del bus

| Brecha | Repositorio(s) afectado(s) | Acción requerida |
|---|---|---|
| `marketplace-core` tiene `EventBus` como interfaz sin adaptador concreto | `marketplace-core` | Implementar adaptador del intermediario elegido (p. ej. `NatsEventBusAdapter` o `PostgresOutboxEventBusAdapter`) |
| `altrupets` no emite ningún evento entre sus diez microservicios NestJS | `altrupets` | Agregar `EventEmitter` global de NestJS (nativo) + manejadores por servicio antes de integrarse al bus del ecosistema |
| `habitanexus` no tiene bus interno (solo eventos on-chain vía Horizon SSE) | `habitanexus` | Levantar backend NestJS o Serverpod + integración con el intermediario elegido |
| No hay registro de esquemas ni cola de mensajes muertos en ningún repositorio | todos | Implementar como parte de la capa del intermediario elegido |

#### Decisión 2 — Codificación y autoridad de esquemas

| Brecha | Repositorio(s) | Acción |
|---|---|---|
| `payments-core/events/v1/*.proto` no está publicado todavía en el registro buf.build | `payments-core` | Publicar el módulo a `buf.build/lapc506/payments-core` con `buf push` en una tubería de CI |
| `marketplace-core` define eventos en `src/shared-kernel/events.ts` (TypeScript puro), no en `.proto` | `marketplace-core` | Si se elige Protobuf: migrar a `.proto` y re-generar. Alternativa: generar `.proto` automáticamente desde TypeScript con una herramienta puente (menos deseable) |
| `agentic-core` no emite eventos hoy | `agentic-core` | Definir qué eventos emite cuando implemente `AgenticCheckoutPort` (parte del trabajo ya planeado cross-repo) |

#### Decisión 3 — Notificaciones entrantes de pasarelas

| Brecha | Repositorio(s) | Acción |
|---|---|---|
| `payments-core` delega el reintento a la pasarela (sin cola propia) | `payments-core` | Decidir: mantener delegación (simpler) o agregar cola con trabajador interno para reintento controlado |
| El verificador compartido asume Postgres + tabla `stripe_events` (una implementación de idempotencia) | `payments-core` | Confirmar si se mantiene Postgres como backend de idempotencia o se migra al flujo JetStream `webhooks.inbound.*` cuando se adopte NATS |

#### Decisión 4 — Consumo desde aplicaciones Dart

| Brecha | Repositorio(s) | Acción |
|---|---|---|
| `vertivolatam` no tiene cliente gRPC Dart configurado | `vertivolatam` | Agregar `package:grpc` a `pubspec.yaml` + compilación proto con `protoc-gen-dart` + paso en la tubería de CI |
| `habitanexus` Flutter no tiene backend intermedio; la decisión entre procurador HTTP y gRPC nativo es bloqueante | `habitanexus` | Decidir explícitamente (el patrón AduaNext indica gRPC nativo) |
| `aduanext` ya tiene el patrón validado (Serverpod → loopback gRPC) | `aduanext` | Replicar el patrón para consumir `marketplace-core` + `payments-core` externos si llegan a desplegarse fuera del Pod |

---

### 6.7 Secuencia recomendada de implementación

Respetando las decisiones implícitas de §6.5 y las brechas de §6.6, la secuencia mínimamente disruptiva es:

1. **Alinear sidecares existentes al estándar de `payments-core`**: agregar `grpc.health.v1.Health` + registro estructurado (Pino en Node, `structlog` en Python) + exportador OpenTelemetry en `agentic-core` y `marketplace-core`. Sin este paso, la observabilidad cross-sidecar no existe.
2. **Resolver la Decisión 1** con el sesgo de §6.5: elegir **NATS JetStream** para el medio plazo y mientras tanto usar **el patrón de bandeja de salida sobre Postgres** para el MVP inmediato (el patrón AduaNext hace que esto sea aceptable incluso sin bus externo dedicado).
3. **Resolver la Decisión 2** adoptando Protobuf con buf.build (opción 2.A). Es prácticamente imposible rechazarla sin duplicar el contrato existente en `payments-core/events/v1/`.
4. **Resolver la Decisión 4** replicando el patrón de AduaNext (opción 4.A, gRPC Dart nativo con `protoc-gen-dart`). Ya está validado.
5. **Resolver la Decisión 3** adoptando el verificador compartido que ya existe en `payments-core/_shared/payments-core/webhook-verifier.ts` (opción 3.A, asíncrono con idempotencia y reintentos). Ya está implementado.
6. **Implementar el adaptador del intermediario en `marketplace-core`** según la decisión 1. Si el intermediario es Postgres + bandeja de salida, la implementación es trivial; si es NATS JetStream, implica agregar `nats.js` como dependencia.
7. **Agregar `EventEmitter` global a `altrupets`** para desbloquear eventos entre los diez microservicios antes de conectarlos al bus del ecosistema.
8. **Levantar backend NestJS (o Serverpod) en `habitanexus`** para poder participar del bus. Mientras tanto, los eventos on-chain de Stellar se ingestan vía un adaptador dedicado en `payments-core`.
9. **Agregar clientes gRPC Dart** en `vertivolatam` y `habitanexus` usando el patrón de AduaNext.
10. **Validar de punta a punta en `aduanext`** (el entorno con más sidecares en producción) antes de replicar a los demás programas. Cualquier brecha que aparezca en AduaNext primero es barata de corregir antes de que se manifieste en los otros cuatro.

**Regla de oro:** cuando una opción ya está probada en al menos un repositorio del ecosistema, adoptarla tiene costo marginal. Introducir una opción nueva tiene costo de integración, de operación y de entrenamiento del equipo. Las Partes I–V del documento ayudan a elegir la mejor opción en términos técnicos; esta parte VI ayuda a ponderar ese "mejor" contra el costo real del cambio.

---

## Apéndice: Lista de verificación inicial (común a cualquier opción)

Independientemente de las elecciones específicas, antes de poner el bus en producción conviene resolver:

- [ ] Convención de nombres de eventos (por ejemplo, `{servicio}.{entidad}.{acción}` — `payments.invoice.paid`).
- [ ] Estrategia de versionado del esquema (cabeceras, sufijo de nombre de archivo, registro de esquemas).
- [ ] Política explícita de retención por tipo de evento.
- [ ] Documentación de propiedad: qué servicio publica qué evento, quién puede consumirlo.
- [ ] Configuración de cola de mensajes muertos o equivalente para eventos no procesables.
- [ ] Monitorización del retraso de los consumidores más alertas.
- [ ] Estrategia de reprocesamiento para recuperación (manual operativo documentado).
- [ ] Prueba de carga sintética con el volumen esperado multiplicado por tres.

---

## Referencias oficiales y lecturas recomendadas

> **URLs y IDs verificados el 2026-04-20 contra Context7 MCP.** Los identificadores con formato `/org/project` se pueden consumir directamente desde el servidor MCP `context7` (`mcp__context7__query-docs`) para obtener ejemplos de código y documentación actualizados sin salir del editor.

**NATS JetStream**
- Documentación oficial: https://docs.nats.io/nats-concepts/jetstream
- Repositorio fuente de la documentación: https://github.com/nats-io/nats.docs
- Context7 MCP ID: `/nats-io/nats.docs` (1 071 fragmentos, benchmark 86.82)
- Patrones de despliegue y agrupamiento: https://docs.nats.io/running-a-nats-service/configuration/clustering/jetstream_clustering
- Comparación de clientes por lenguaje: https://docs.nats.io/using-nats/developer/connecting
- Clientes oficiales (IDs Context7):
  - JavaScript / TypeScript (Deno, Node, Bun): `/nats-io/nats.js`
  - Python (async / await): `/nats-io/nats.py`
  - Rust: `/nats-io/nats.rs`

**Kafka**
- Documentación Apache Kafka: https://kafka.apache.org/documentation/
- Context7 MCP ID: `/apache/kafka` (1 497 fragmentos)
- Clientes Java de referencia: `/websites/javadoc_io_doc_org_apache_kafka_kafka-clients_4_2_0`
- Cliente Python: `/dpkp/kafka-python`
- Precios de Confluent Cloud: https://www.confluent.io/confluent-cloud/pricing/
- Documentación de Redpanda: https://docs.redpanda.com/

**RabbitMQ**
- Documentación oficial (sitio actual): https://www.rabbitmq.com/
- Colas de quórum (reemplazo de colas espejadas): https://www.rabbitmq.com/docs/quorum-queues
- Streams: https://www.rabbitmq.com/docs/streams
- Context7 MCP IDs:
  - Sitio web oficial: `/rabbitmq/rabbitmq-website` (2 988 fragmentos, benchmark 86.3)
  - Servidor y protocolos: `/rabbitmq/rabbitmq-server` (4 184 fragmentos, benchmark 81.9)

**Postgres LISTEN/NOTIFY**
- Documentación oficial: https://www.postgresql.org/docs/current/sql-notify.html
- Patrón de bandeja de salida transaccional (microservices.io): https://microservices.io/patterns/data/transactional-outbox.html

**Protobuf y buf.build**
- Documentación Protobuf: https://protobuf.dev/
- Context7 MCP ID: `/protocolbuffers/protocolbuffers.github.io` (13 166 fragmentos, benchmark 74)
- Guía de proto3 (reservas y evolución): https://protobuf.dev/programming-guides/proto3/
- Mejores prácticas (reservar números de tag, no reutilizar): https://protobuf.dev/best-practices/dos-donts/
- buf CLI y Schema Registry: https://buf.build/docs/cli
- Detección de cambios incompatibles (guía rápida): https://buf.build/docs/breaking/quickstart
- Integración en CI/CD: https://buf.build/docs/bsr/ci-cd/setup
- Context7 MCP IDs:
  - Sitio y BSR: `/websites/buf_build` (5 695 fragmentos, benchmark 79.95)
  - CLI en GitHub: `/bufbuild/buf`

**CloudEvents**
- Especificación oficial: https://cloudevents.io/
- Proyecto CNCF: https://github.com/cloudevents/spec
- Context7 MCP ID: `/cloudevents/spec` (322 fragmentos)
- SDKs oficiales (IDs Context7):
  - Go: `/cloudevents/sdk-go`
  - JavaScript: `/cloudevents/sdk-javascript`
  - Python: `/cloudevents/sdk-python`
  - C#: `/cloudevents/sdk-csharp`

**Avro y Schema Registry**
- Documentación Avro: https://avro.apache.org/docs/
- Context7 MCP ID: `/apache/avro` (801 fragmentos)
- Confluent Schema Registry: https://docs.confluent.io/platform/current/schema-registry/index.html

**gRPC en Dart**
- Paquete oficial en pub.dev: https://pub.dev/packages/grpc
- Tutorial oficial: https://grpc.io/docs/languages/dart/quickstart/
- Context7 MCP ID: `/grpc/grpc-dart` (31 fragmentos, fuente oficial)
- Plugin de generación de código (protoc_plugin): https://pub.dev/packages/protoc_plugin
  - Activación: `dart pub global activate protoc_plugin`
  - Uso típico: `protoc --dart_out=grpc:lib/src/generated -Iprotos protos/<archivo>.proto`
- gRPC-Web (si Flutter Web entra en el alcance): https://github.com/grpc/grpc-web

**Lecturas cruzadas recomendadas**
- Martin Kleppmann, *Designing Data-Intensive Applications* — capítulos 11 (procesamiento de flujos) y 12 (futuro de los sistemas de datos).
- Gregor Hohpe, *Enterprise Integration Patterns* — el modelo mental de cola contra registro.
- Tyler Treat, "The SMART Way to Think About Messaging" — criterios para elegir semántica de entrega (https://bravenewgeek.com/).

---

*Este documento se escribió para revisión sin conexión y para conversaciones entre quienes toman la decisión. Si alguna de las cuatro decisiones cambia en el futuro, vuelve a la sección correspondiente de "Señales para revisitar" y anota el motivo real del cambio. Eso alimenta la próxima decisión arquitectónica del ecosistema con aprendizaje real, no con especulación.*
