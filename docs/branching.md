# Estrategia de Ramas — GitFlow

Este monorepo usa **GitFlow** con dos ramas de larga vida:

| Rama | Propósito | Protección | Despliegue (futuro) |
|------|-----------|------------|---------------------|
| `main` | Producción. Solo recibe releases. | ✅ PR obligatorio, sin push directo/force/delete | Entorno **prod** |
| `develop` | Integración del trabajo diario. **Rama default.** | Abierta (push directo permitido durante desarrollo activo) | Entorno **staging** |

## Flujo de trabajo

```
feature/HAB-XXX-descripcion   ─┐
                                ├─► develop ──(release/x.y.z)──► main ──(tag vX.Y.Z)──► prod
hotfix/HAB-XXX-descripcion ─────┘ (desde main, se mergea a main + develop)
```

- **Features:** salen de `develop` → `feature/{issue}-{slug}` → PR de vuelta a `develop`.
  Linear autogenera el `gitBranchName` por issue (ver `linear-setup.json` → `branchPattern`).
- **Releases:** `release/x.y.z` desde `develop` → PR a `main` (con squash merge, ver `linear-setup.json`).
  Al mergear se etiqueta `vX.Y.Z` y se promueve a producción.
- **Hotfixes:** `hotfix/{issue}-{slug}` desde `main` → PR a `main` y back-merge a `develop`.

## Mapeo a entornos Kubernetes (propuesto — pendiente de cablear)

> ⚠️ El pipeline de despliegue todavía **no está implementado**. La estructura GitOps existe como
> scaffolding (`k8s/argocd/{applications,projects}` y `k8s/overlays/{dev,qa,staging,prod}` con Kustomize),
> pero las `Application` de ArgoCD están vacías y **falta elegir el proveedor de Kubernetes**
> (OVHcloud Managed Kubernetes / GCP GKE / AWS EKS). Este mapeo se activa cuando se decida y se cablee.

| Rama / evento | Overlay Kustomize | ArgoCD `targetRevision` | Entorno |
|---------------|-------------------|-------------------------|---------|
| `feature/*` (opcional, efímero) | `k8s/overlays/dev` | la rama feature | dev / preview |
| `release/*` | `k8s/overlays/qa` | `release/*` | QA / candidata |
| `develop` | `k8s/overlays/staging` | `develop` | **staging** |
| `main` + tag `vX.Y.Z` | `k8s/overlays/prod` | tag/`main` | **producción** |

Modelo recomendado: **GitOps con ArgoCD** — cada `Application` apunta a un overlay con su `targetRevision`
(rama). Al mergear a `develop`, ArgoCD sincroniza el overlay `staging` automáticamente. Producción se
promueve por release a `main` + tag, nunca por push directo (de ahí la protección de `main`).

La IaC del cluster vive en `infrastructure/terraform/{environments,modules}` y los charts en
`infrastructure/helm-charts/`.

## Notas

- La rama default del repo es `develop`: los PR apuntan ahí salvo releases/hotfix (que van a `main`).
- `main` requiere PR (0 aprobaciones configuradas para equipo chico; subir el umbral cuando crezca el equipo).
