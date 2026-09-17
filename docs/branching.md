# Estrategia de Ramas — GitFlow 3 ramas

Este monorepo usa **GitFlow con tres ramas de larga vida**:

| Rama | Propósito | Protección | Despliegue (ArgoCD) |
|------|-----------|------------|---------------------|
| `main` | Producción. Solo recibe releases desde `staging`. | ✅ PR obligatorio, sin push directo/force/delete | Entorno **prod** (`k8s/overlays/prod`) |
| `staging` | Pre-producción / candidata a release. Puerto de salida a `main`. | ✅ PR obligatorio, sin push directo | Entorno **staging** (`k8s/overlays/staging`) |
| `develop` | Integración del trabajo diario. **Rama default.** | Abierta (push directo permitido durante desarrollo activo) | Entorno **dev** (`k8s/overlays/dev`) |

## Flujo de trabajo

```
feature/HAB-XXX-descripcion ──┐
                              ├─► develop ──(promoción)──► staging ──(release/x.y.z)──► main ──(tag vX.Y.Z)──► prod
hotfix/HAB-XXX-descripcion ───┘                        ▲
                                                        └── back-merge hotfix ────────────┘
```

- **Features:** salen de `develop` → `feature/{issue}-{slug}` → PR de vuelta a `develop`.
  Linear autogenera el `gitBranchName` por issue (ver `linear-setup.json` → `branchPattern`).
- **Promoción a staging:** `develop` → PR a `staging`. ArgoCD despliega el overlay `staging` automáticamente.
- **Releases:** `release/x.y.z` desde `staging` → PR a `main`. Al mergear se etiqueta `vX.Y.Z`.
  **`main` solo recibe cambios vía release desde `staging`** — nunca push directo ni PR desde feature.
- **Hotfixes:** `hotfix/{issue}-{slug}` desde `main` → PR a `main` + back-merge a `develop`.

## Mapeo a entornos Kubernetes (ArgoCD GitOps)

Cada `Application` de ArgoCD apunta a un overlay Kustomize con su `targetRevision` (rama):

| Rama / evento | Overlay Kustomize | ArgoCD `targetRevision` | Entorno |
|---------------|-------------------|-------------------------|---------|
| `feature/*` (opcional, efímero) | `k8s/overlays/dev` | la rama feature | dev / preview |
| `develop` | `k8s/overlays/dev` | `develop` | **dev** |
| `staging` | `k8s/overlays/staging` | `staging` | **staging** |
| `main` + tag `vX.Y.Z` | `k8s/overlays/prod` | tag/`main` | **producción** |

Al mergear a `develop`, ArgoCD sincroniza `overlays/dev`; al mergear a `staging`
sincroniza `overlays/staging`; la promoción a producción es por release a `main` + tag.

La IaC del cluster vive en `infrastructure/terraform/{environments,modules}` y los charts en
`infrastructure/helm-charts/`. Manifiestos ArgoCD: `k8s/argocd/{applications,projects}`.

## Notas

- La rama default del repo es `develop`: los PR apuntan ahí salvo promociones/releases/hotfix.
- `main` y `staging` requieren PR; `develop` permite push directo en desarrollo activo.