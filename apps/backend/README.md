# HabitaNexus Backend

API del marketplace de alquiler (NestJS 11 + Clean Architecture, TypeScript).

## Estructura

```
src/
  main.ts                  # bootstrap
  app.module.ts            # módulo raíz
  modules/
    property/              # feature rental-flow (fase 1: Listado)
      property.module.ts   # registro NestJS del feature
      domain/
        entities/          # Property, Listing, RoomSpace, catalog-types (sin deps NestJS)
        repositories/      # puertos (interfaces) — los implementa infrastructure
      index.ts             # barrel
test/
  property/                # specs de serialización del dominio
```

Reglas:

- `domain/` no importa `@nestjs/*` ni nada de `infrastructure`.
- Contrato JSON en snake_case, compartido con `apps/mobile`.
- Entidades inmutables: `create()` + `copy()` + `toJSON()`/`fromJSON()` + `equals()`.

## Comandos

```bash
npm install
npm run build
npm run start:dev
npm test
```
