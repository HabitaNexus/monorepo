---
marp: true
theme: gaia
size: 16:9
paginate: true
header: "HabitaNexus — Pitch Deck"
footer: "© 2026 HabitaNexus"
style: |
  :root {
    font-size: 15pt;
  }
  .highlight {
    color: #0066cc;
    font-weight: bold;
  }
  .evidence {
    background-color: #f8f8f8;
    border-left: 4px solid #0066cc;
    padding: 0.5em 1em;
    margin: 1em 0;
  }
  .urgent {
    color: #cc0000;
    font-weight: bold;
  }
---

# **HabitaNexus**

## Alquilar no debería tomar 2 meses

Andrés Peña Castillo · Fundador & CTO
2026

---

# **EL PROBLEMA**

## <span class="urgent">241.000 hogares alquilan en el GAM — ninguna plataforma gestiona el contrato</span>

**3 dolores que nadie resuelve:**

1. **Búsqueda fragmentada** — 25+ grupos de Facebook, foto por foto, sin filtro de presupuesto
2. **Negociación caótica** — Por WhatsApp, sin estándar, con invasión de privacidad
3. **Abusos post-contrato** — Mantenimiento trasladado al inquilino, depósito nunca devuelto

<div class="evidence">
📊 340.000 hogares en alquiler en CR (ENAHO 2024), creciendo 3-4%/año<br>
👤 Mery, 12 años alquilando: "Me emputé y me fui porque nunca me devolvieron el depósito"
</div>

---

# **LA SOLUCIÓN**

## HabitaNexus: de 2 meses a menos de 1 semana

- **Filtro de presupuesto exacto** (₡125.000 - ₡350.000)
- **Calendarizador de visitas** integrado
- **Negociación digital** estandarizada (no WhatsApp)
- **Contrato digital** con plantillas legales (Ley 7527) — sin abogado
- **Depósito protegido** en custodia (escrow) con Trustless Worker
- **Reclamos bidireccionales** con fotos — estilo Amazon

---

# **PROPUESTA DE VALOR 10X**

| Dimensión | HabitaNexus | Facebook + WhatsApp |
|-----------|-------------|---------------------|
| Tiempo de búsqueda | <1 semana | ~2 meses |
| Negociación | Digital estandarizada | Caótica por WhatsApp |
| Contrato | Digital, legal, sin abogado | Verbal o papel genérico |
| Depósito | Custodia neutral (escrow) | En manos del propietario |
| Post-contrato | Reclamos con evidencia | Discusiones sin registro |

---

# **TAMAÑO DE MERCADO**

| Nivel | Valor |
|-------|-------|
| **TAM** — Todos los alquileres en CR | **$2.450M/año** |
| **SAM** — Alquileres en el GAM | **$2.170M/año** |
| **SOM** — 5% penetración, 7% comisión | **$7.6M/año** |

Fuente: ENAHO 2024, INEC Costa Rica

---

# **COMPETENCIA**

| Funcionalidad | HabitaNexus | Encuentra24 | Facebook | Alien Realty |
|--------------|:-----------:|:-----------:|:--------:|:-----------:|
| Filtro presupuesto | ✅ | Parcial | ❌ | ❌ |
| Contrato digital | ✅ | ❌ | ❌ | ❌ |
| Custodia depósito | ✅ | ❌ | ❌ | ❌ |
| Reclamos bidireccionales | ✅ | ❌ | ❌ | ❌ |
| Calendarización visitas | ✅ | ❌ | ❌ | ❌ |
| Verificación propietario | ✅ | ❌ | ❌ | ❌ |

**Ventaja injusta**: Sistema de reclamos bidireccional + escrow + contrato Ley 7527

---

# **MODELO DE NEGOCIO**

**Modelo dual:**

| Flujo | Quién paga | Cuánto | Frecuencia |
|-------|-----------|--------|------------|
| Suscripción | Propietario | ₡10.000-₡30.000/mes | Recurrente |
| Comisión | Inquilino | ₡15.000-₡25.000 por contrato | Por transacción |
| Procesamiento (futuro) | Ambos | 1-2% del alquiler | Mensual |

**Punto de equilibrio**: ~35 propietarios suscritos (Mes 11)

---

# **PRODUCTO**

**Beta (8 semanas):**
- Búsqueda filtrada + listados verificados
- Calendarizador de visitas
- Chat de negociación digital
- Registro de propietarios con verificación

**v1.0 (Mes 5):**
- Contrato digital (Ley 7527)
- Custodia (escrow) con Trustless Worker
- Sistema de reclamos bidireccional

**Stack**: Flutter · NestJS · PostgreSQL + PostGIS · Azure AKS · ArgoCD

---

# **TRACCIÓN**

**Validación completada:**
- ✅ Problema validado con entrevista real (Mery, 12 años alquilando)
- ✅ Fuerzas del Cliente: balance +8 (mercado listo)
- ✅ Análisis competitivo: 15+ alternativas, ninguna con contrato digital
- ✅ Investigación de mercado: 340K hogares, TAM $2.45B

**Próximos hitos:**
- 🎯 10 propietarios B2B registrados (Mes 3)
- 🎯 Primer contrato firmado digitalmente (Mes 6)
- 🎯 Primer pago con custodia (escrow) (Mes 12)

---

# **PROYECCIONES FINANCIERAS**

| Métrica | Mes 6 | Mes 12 | Mes 18 |
|---------|-------|--------|--------|
| Propietarios suscritos | 17 | 42 | 82 |
| MRR | ₡250.000 | ₡620.000 | ₡1.250.000 |
| Contratos firmados (acum.) | 5 | 26 | 77 |

- **Bootstrapping** (autofinanciamiento con recursos propios)
- **Costos**: ~₡550.000/mes (cubiertos por Microsoft for Startups primeros 5 meses)
- **Break-even**: Mes 11 (~35 propietarios)

---

# **EQUIPO**

| | |
|---|---|
| **Andrés Peña Castillo** | **Fundador & CTO** |
| | +9 años SRE (IBM, Provectus/Model N, Roche) |
| | Emprendedor serial: Vertivo (pre-seed $9.5K), KeikoStart, AltruPets |
| | Flutter, NestJS, Kubernetes, arquitectura cloud |
| | **Víctima del problema**: no tiene tiempo de buscar apartamento |

**Asesores (por conformar):**
- Startup: Fundador/a con exit en proptech/marketplace
- Industria: Abogado/a de arrendamientos (candidato: Sfera Legal)
- Tecnología: CTO con experiencia en apps Flutter a escala

---

# **VISIÓN — AÑO 1 AL 3**

**Año 1**: Validar en el GAM de Costa Rica — 42 propietarios, 26 contratos
**Año 2**: Escalar al resto de Costa Rica — 200+ propietarios, 100+ contratos
**Año 3**: Expandir a Panamá y Guatemala — primer mercado multi-país

> *"Que alquilar vivienda digna en Latinoamérica sea tan fácil y seguro como pedir un Uber."*

---

# **GRACIAS**

<div style="text-align: center; margin-top: 4em;">
  <h2>¿Preguntas?</h2>
  <p style="margin-top: 2em;">
    Andrés Peña Castillo<br>
    lapc506.me · github.com/lapc506/habitanexus<br>
    LinkedIn: linkedin.com/in/lapc506
  </p>
</div>
