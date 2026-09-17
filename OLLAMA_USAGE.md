# Uso de Ollama con la integración de Claude Code

Comando original consultado:
`ollama launch claude --model nemotron-3-super:cloud --resume 82f4cc14-b094-4f8f-9722-bb895acc3e5b --dangerously-skip-permissions`

## Desglose del comando basado en la ayuda oficial de `ollama launch`

Según la salida de `ollama launch --help`, la sintaxis correcta es:
```
ollama launch [INTEGRATION] [-- [EXTRA_ARGS...]] [flags]
```

Donde:
- `[INTEGRATION]` es el nombre de la integración (en este caso, `claude`)
- `[flags]` son banderas específicas del comando `ollama launch`
- `[EXTRA_ARGS...]` son argumentos que se pasan directamente a la integración después del separador `--`

### Banderas válidas para `ollama launch` (basadas en la ayuda):
- `--model string`: Modelo a usar (ej: nemotron-3-super:cloud)
- `--config`: Configurar sin lanzar
- `--restore`: Restaurar una integración a su perfil predeterminado
- `-y, --yes`: Responder automáticamente sí a las solicitudes de confirmación
- `-h, --help`: Mostrar ayuda

### Ejemplos de la ayuda oficial:
- `ollama launch claude --model <model>`
- `ollama launch codex -- -p myprofile` (pasa `-p myprofile` a codex)
- `ollama launch codex -- --sandbox workspace-write` (pasa `--sandbox workspace-write` a codex)

## Interpretación del comando original

El comando que proporcionaste parece intentar:
1. Lanzar la integración de Claude Code
2. Usar el modelo `nemotron-3-super:cloud`
3. Resumir una sesión con ID `82f4cc14-b094-4f8f-9722-bb895acc3e5b`
4. Saltarse los permisos de seguridad (peligroso)

### Posible sintaxis correcta:
Si `--resume` y `--dangerously-skip-permissions` son argumentos de la integración de Claude Code (no de `ollama launch` propiamente dicha), entonces el comando debería estructurarse así:

```bash
ollama launch claude --model nemotron-3-super:cloud -- --resume 82f4cc14-b094-4f8f-9722-bb895acc3e5b --dangerously-skip-permissions
```

**Nota importante:** El doble guión `--` separa las banderas de `ollama launch` de los argumentos que se pasan a la integración.

## Consideraciones de seguridad

⚠️ **Advertencia:** La bandera `--dangerously-skip-permissions` omite los controles de seguridad. Esto puede exponer tu sistema a riesgos significativos, incluyendo:
- Ejecución de código no verificado
- Acceso no autorizado a recursos del sistema
- Vulnerabilidades de inyección

Se recomienda encarecidamente evitar esta bandera a menos que estés en un entorno completamente aislado y confiado.

## Pasos para verificar y usar correctamente

1. **Verificar que el modelo esté disponible:**
   ```bash
   ollama list
   ```
   Si no aparece `nemotron-3-super:cloud`, necesitas descargarlo primero:
   ```bash
   ollama pull nemotron-3-super:cloud
   ```

2. **Probar el lanzamiento básico:**
   ```bash
   ollama launch claude --model nemotron-3-super:cloud
   ```

3. **Si necesitas pasar argumentos específicos a Claude Code:**
   ```bash
   ollama launch claude --model nemotron-3-super:cloud -- [tus-argumentos-aquí]
   ```

## Preguntas frecuentes

**¿Cómo encuentro el ID de una sesión para resumir?**
Ollama no muestra explícitamente una bandera `--resume` en su ayuda estándar. Esta funcionalidad podría ser específica de ciertas integraciones o versiones. Te sugiero:
- Revisar la documentación específica de la integración Claude Code para Ollama
- Ejecutar `ollama launch claude --help` para ver si hay ayuda específica de la integración
- Consultar los registros de Ollama para ver IDs de sesión

**¿Qué hace exactamente `--dangerously-skip-permissions`?**
Esta bandera probablemente le indica a la integración Claude Code que omita las verificaciones de permisos normales, permitiendo que acceda a más recursos del sistema sin restricciones. Su uso exacto depende de cómo esté implementada la integración.

## Recomendación final

Antes de usar banderas que omitan seguridad, considera:
1. Ejecutar primero sin `--dangerously-skip-permissions` para ver si funciona
2. Limitar los permisos mediante otros medios (containers, usuarios restringidos, etc.)
3. Mantener tu sistema actualizado y monitorizado