# Spec Delta

## Purpose

Producir el contrato de arrendamiento de vivienda en Costa Rica a partir del acuerdo ya confirmado: 21 cláusulas, referencia estable y un hash del documento, sin firmarlo y sin mover la negociación.

## ADDED Requirements

### Requirement: Generación de las 21 cláusulas
El sistema SHALL producir un documento cuyo cuerpo contiene las cláusulas 1 a 21 del SOP de Fase 5, en ese orden, rellenadas con el resumen confirmado del acuerdo.

#### Scenario: Acuerdo de ejemplo produce las 21 cláusulas en orden
- **WHEN** se genera el documento de una negociación en `PENDIENTE_FIRMA` con resumen confirmado y los datos del Art. 11
- **THEN** el documento contiene las cláusulas 1 a 21 en ese orden
- **AND** cada cláusula muestra el valor pactado de los términos que la alimentan

### Requirement: Contenido mínimo del Art. 11
El sistema SHALL incluir en el documento las partes, el inmueble, el destino, el precio y la forma de pago, el plazo, los domicilios y la fecha del contrato.

#### Scenario: El documento enuncia el contenido mínimo
- **WHEN** la generación termina con documento
- **THEN** el documento enuncia nombre, calidades y personería de ambas partes, la cita de inscripción o el documento fehaciente y la ubicación del inmueble, el destino, el monto y la forma de pago, el plazo, los domicilios de ambas partes y la fecha del contrato

#### Scenario: Falta un dato mínimo
- **WHEN** falta alguno de esos datos mínimos
- **THEN** no se producen bytes de documento

### Requirement: Depósito de al menos un mes
El sistema SHALL rechazar la generación cuando el depósito es menor a un mes de renta, y SHALL escribir en la cláusula 4 un depósito igual o mayor.

#### Scenario: Depósito inferior a un mes
- **WHEN** el depósito de garantía es menor que la renta mensual
- **THEN** no se producen bytes de documento

#### Scenario: Depósito de un mes
- **WHEN** el depósito de garantía es igual a la renta mensual
- **THEN** la cláusula 4 enuncia ese monto

#### Scenario: Depósito mayor a un mes
- **WHEN** el depósito de garantía es mayor que la renta mensual
- **THEN** la cláusula 4 enuncia ese monto

### Requirement: Aviso de plazo y prórroga tácita
El sistema SHALL escribir en la cláusula 5 la prórroga tácita de tres años, y SHALL añadir el aviso del SOP cuando el plazo pactado es menor a 36 meses.

#### Scenario: Plazo menor a 36 meses
- **WHEN** el plazo pactado es menor a 36 meses
- **THEN** la cláusula 5 incluye el aviso legal del SOP sobre el plazo mínimo de tres años y la prórroga tácita de tres años

#### Scenario: Plazo de 36 meses o más
- **WHEN** el plazo pactado es de 36 meses o más
- **THEN** la cláusula 5 incluye la prórroga tácita de tres años y no incluye el aviso de plazo inferior

#### Scenario: Renovación automática en falso
- **WHEN** el acuerdo marca la renovación automática como falsa
- **THEN** la cláusula 5 igual enuncia la prórroga tácita de tres años

### Requirement: Preaviso de no renovación
El sistema SHALL enunciar en la cláusula 5 un aviso de no renovación de al menos tres meses, y SHALL NOT presentar como eficaz un preaviso más corto.

#### Scenario: Preaviso inferior a tres meses
- **WHEN** el preaviso pactado es menor a 90 días
- **THEN** la cláusula 5 enuncia el aviso legal de tres meses y no enuncia ese preaviso como plazo eficaz

#### Scenario: Preaviso de tres meses o más
- **WHEN** el preaviso pactado es de 90 días o más
- **THEN** la cláusula 5 enuncia ese preaviso junto con el mínimo legal de tres meses

#### Scenario: Sin preaviso pactado
- **WHEN** el acuerdo no trae preaviso
- **THEN** la cláusula 5 enuncia el aviso legal de tres meses

### Requirement: Techo de incremento
El sistema SHALL NOT escribir como pacto válido un incremento anual mayor al tope recibido. En moneda extranjera SHALL escribir que la renta no se reajusta.

#### Scenario: Incremento mayor al tope
- **WHEN** la moneda es colones y el incremento anual pactado supera el tope recibido
- **THEN** no se producen bytes de documento

#### Scenario: Incremento dentro del tope
- **WHEN** la moneda es colones y el incremento anual pactado es menor o igual al tope recibido
- **THEN** la cláusula 16 enuncia ese incremento

#### Scenario: Sin porcentaje pactado
- **WHEN** la moneda es colones y el acuerdo no trae un porcentaje de incremento
- **THEN** la cláusula 16 enuncia la fórmula legal de reajuste y no enuncia una tasa numérica

#### Scenario: Moneda extranjera
- **WHEN** la moneda no es colones
- **THEN** la cláusula 16 enuncia que la renta no se reajusta y no aplica el incremento pactado

### Requirement: Referencia estable
El sistema SHALL asignar una referencia derivada de la entrada canónica. La misma entrada produce la misma referencia. Otra negociación produce otra.

#### Scenario: Misma entrada, misma referencia
- **WHEN** la misma entrada se genera dos veces
- **THEN** ambos documentos llevan la misma referencia

#### Scenario: Otra negociación, otra referencia
- **WHEN** dos generaciones difieren solo en el identificador de la negociación
- **THEN** sus referencias son distintas

### Requirement: Hash del documento
El sistema SHALL guardar, junto a los bytes finales del documento, el SHA-256 de esos bytes. La misma entrada SHALL producir los mismos bytes.

#### Scenario: El hash coincide con los bytes
- **WHEN** se guarda un documento
- **THEN** el digest guardado es el SHA-256 de esos bytes

#### Scenario: Segunda generación idéntica
- **WHEN** la misma entrada se genera de nuevo
- **THEN** los bytes de la segunda generación son idénticos a los de la primera
- **AND** el digest es el mismo

### Requirement: Disparo sin cambiar la negociación
El sistema SHALL generar el documento solo con la negociación en `PENDIENTE_FIRMA` y SHALL dejar ese estado sin cambios.

#### Scenario: PENDIENTE_FIRMA genera
- **WHEN** la negociación está en `PENDIENTE_FIRMA` y la entrada es válida
- **THEN** se produce el documento
- **AND** la negociación sigue en `PENDIENTE_FIRMA`

#### Scenario: ACUERDO_ALCANZADO no genera
- **WHEN** la negociación está en `ACUERDO_ALCANZADO`
- **THEN** no se producen bytes de documento
- **AND** la negociación sigue en `ACUERDO_ALCANZADO`

#### Scenario: No pasa a firmado
- **WHEN** la generación produce un documento
- **THEN** la negociación no queda en un estado de firma concluida
