# Analisis de 7 Puntos de NN/g — Storyboard de Jose Penaranda

**Fecha:** 2026-04-12
**Storyboard:** Jose Penaranda — Propietario que adopta HabitaNexus
**Framework:** Nielsen Norman Group — 7 puntos para evaluacion de storyboards

---

## 1. Expectativas no cumplidas

**Escena 3 (Busqueda)** es donde la experiencia contradice lo esperado. Jose espera encontrar una app para propietarios y la mayoria son para inquilinos. El mercado de apps inmobiliarias en CR esta disenado para quien busca, no para quien ofrece.

**Hallazgo de diseno:** El onboarding de HabitaNexus debe preguntar "Soy propietario" vs "Soy inquilino" como primera pantalla — no asumir que el usuario es inquilino como hacen las demas apps.

## 2. Escenas innecesarias

**No hay escenas innecesarias.** Las 6 escenas cubren un arco completo sin relleno:
- Escenas 1-2: Problema (setup + agravante)
- Escena 3: Transicion (busqueda)
- Escena 4: Punto de inflexion (descubrimiento)
- Escenas 5-6: Resolucion (solucion + resultado)

La distribucion 2-1-1-2 es equilibrada. Si hubiera que recortar, la escena 2 (hermano llama) podria fusionarse con la 1, pero el detalle del hermano confirmando que el problema es sistemico agrega profundidad narrativa que justifica su existencia.

## 3. Puntos bajos / friccion

Las escenas con emocion 1-2 (escenas 1, 2, 3) estan bien representadas:

- **Escena 2 (nivel 1)** es el fondo emocional correcto — abrumado, esposa enferma, hermano confirma que no hay solucion.
- **Escena 1 y 3 (nivel 2)** son ligeramente superiores porque Jose todavia tiene algo de control.

**Hallazgo:** El storyboard captura un pain point que el SOP no aborda directamente — la **salud del propietario**. El estres de los inquilinos problematicos tiene consecuencias fisicas para la esposa de Jose (hipertension). Angulo de marketing potencial: "HabitaNexus: tranquilidad para su familia."

## 4. Transiciones de escena

| Transicion | Flujo temporal | Evaluacion |
|---|---|---|
| Escena 1 -> 2 | Sabado 5pm -> Domingo manana | Fluida |
| Escena 2 -> 3 | Domingo manana -> Domingo tarde | Fluida |
| Escena 3 -> 4 | Domingo tarde -> Lunes manana | Fluida |
| Escena 4 -> 5 | Lunes -> 3 meses despues | **Salto grande** |
| Escena 5 -> 6 | Firma -> 1 mes despues | Moderado, aceptable |

**Hallazgo:** El salto de la escena 4 a la 5 (3 meses) es el mas abrupto. El storyboard omite que pasa durante esos 3 meses: Jose convive con el inquilino problematico, repara la propiedad, y publica en HabitaNexus.

**Recomendacion:** No agregar mas escenas, pero si se usa para pitch deck, considerar una tarjeta de transicion "3 meses despues..." entre escenas 4 y 5.

## 5. Evaluacion de ritmo

| Segmento | Escenas | Proporcion |
|---|---|---|
| Problema (conflicto) | 1, 2 | 33% |
| Transicion (busqueda) | 3 | 17% |
| Solucion (resolucion) | 4, 5, 6 | 50% |

El ritmo es saludable. La solucion ocupa 50% — correcto para un storyboard aspiracional.

## 6. Momento de verdad

**Escena 4 (Descubrimiento)** — cuando Jose entiende que el acta de entrega con fotos es inmutable:

> "Si yo hubiera tenido esto hace dos anos, ese mae no me sale con que 'ya estaba asi'."

El insight es emocional, no funcional. Jose no se convence por las features, sino por entender que la evidencia lo protege.

**Hallazgo de diseno:** El onboarding de propietarios debe llegar a este momento lo mas rapido posible. La primera cosa que un propietario debe ver: "Tus fotos quedan protegidas con fecha y firma digital. Nadie puede decir que 'ya estaba asi'."

## 7. Punto alto

**Escena 6 (Resultado, nivel 5)** cierra el arco correctamente:
- No es un "todo es perfecto" artificial — Jose sabe que si hay un problema, "ahora si queda todo registrado"
- El referido al hermano por WhatsApp valida el canal de adquisicion organico
- Mery ofreciendole cafe humaniza la relacion propietario-inquilino

**Hallazgo:** El canal de adquisicion mas fuerte para propietarios no es marketing digital sino **referido familiar por WhatsApp**. Esto alinea con el modelo de negocio: canales B2C = Facebook groups + referidos.

---

## Resumen de hallazgos de diseno

| # | Hallazgo | Impacto en HabitaNexus |
|---|----------|----------------------|
| 1 | Onboarding dual: "Soy propietario" vs "Soy inquilino" | Primera pantalla de la app |
| 2 | Salud del propietario como angulo de marketing | Copy y messaging |
| 3 | Salto temporal de 3 meses necesita transicion visual | Pitch deck |
| 4 | Evidencia inmutable es el momento de verdad | Onboarding del propietario — mostrar primero |
| 5 | Referido por WhatsApp es el canal organico principal | Growth strategy |

## Siguiente mapa recomendado

**Customer Journey Map** para el flujo de listado de propiedad del propietario en HabitaNexus — touchpoints especificos, pantallas, acciones, y fricciones de UX de cada paso dentro de la app. Alimenta directamente el diseno de features del Sprint 1 (HAB-13 a HAB-18).
