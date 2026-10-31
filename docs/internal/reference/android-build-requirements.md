# Requisitos de máquina: build APK + emulator Android (interno)

> Clasificación: INTERNO. Guía de entorno para el equipo.

## Medido 2026-09-29 (Flutter 3.41, AGP 8.11.1, Gradle 8.14, Java 17)

El build `assembleDebug` falla con `Java heap space` (JetifyTransform) con
el default de 4G. Fijado en `apps/mobile/android/gradle.properties`:

```
org.gradle.jvmargs=-Xmx6G -XX:MaxMetaspaceSize=1G
org.gradle.workers.max=4
kotlin.daemon.jvmargs=-Xmx2G
```

## RAM recomendada

| Componente | Reserva |
|---|---|
| Gradle daemon + workers | 6G heap |
| Kotlin daemon | 2G |
| Android Emulator (AVD x86_64, Play Store) | 4G RAM + 512M heap |
| SO + IDE + Flutter tool | 4G |
| **Mínimo viable** | **16G** (apretado; cerrar IDE o usar dispositivo físico) |
| **Cómodo** | **32G** |

## AVD sugerido (E2E local)

- Pixel 7, API 34, x86_64, 4096M RAM, cold-boot snapshot activado.
- Alternativa sin costo de RAM: dispositivo físico por USB
  (`adb devices` → `make e2e-local-install`), como el E2E de PR #44.

## Referencia

Máquina QA donde se midió: 31G RAM / 16 cores — build APK debug ~2.5 min.
