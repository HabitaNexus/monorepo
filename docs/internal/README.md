# Documentación interna (Diátaxis, no publicable)

Este árbol replica los cuadrantes Diátaxis para uso **interno** del equipo:

```
docs/internal/
  tutorials/     # aprendizaje guiado (operación del repo, onboarding técnico)
  how-to/        # guías de resolución (runbooks, accesos, gates de QA)
  reference/     # información (inventarios, credenciales por entorno, ADRs internos)
  explanation/   # comprensión (RCAs, postmortems, decisiones de arquitectura)
```

Reglas:

1. **Nada de este árbol entra al `nav` de `docs/site/mkdocs.yml`**
   (el sitio público se buildea a GitHub Pages sin autenticación).
2. El árbol público espejo vive en `docs/site/content/docs/` con los mismos
   cuatro cuadrantes; lo interno **nunca** se mueve ahí sin sanitizar
   (sin credenciales, IPs internas, rutas de máquinas ni secretos).
3. Los secretos reales viven fuera del repo (ver `.env.example` por servicio).
