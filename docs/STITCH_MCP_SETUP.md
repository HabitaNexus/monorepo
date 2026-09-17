# Configuración de Stitch MCP

## Visión General

Stitch es un servidor de Model Context Protocol (MCP) remoto que permite que herramientas de IA como Cursor, Antigravity, o Gemini CLI interactúen directamente con tus proyectos de Stitch para generar y editar UI.

## Pasos de Configuración

### 1. Obtener API Key de Stitch

1. Accede a [https://stitch.withgoogle.com/settings](https://stitch.withgoogle.com/settings)
2. Desplázate hasta la sección **API Keys**
3. Haz clic en **"Create API Key"**
4. Copia la API Key generada y guárdala en un lugar seguro

⚠️ **Seguridad**: Nunca commits tu API Key a un repositorio público.

### 2. Configurar el archivo mcp.json

Ya hemos creado un archivo `mcp.json` en la raíz del proyecto. Necesitas reemplazar `YOUR-API-KEY` con tu API Key real:

```json
{
  "mcpServers": {
    "stitch": {
      "url": "https://stitch.googleapis.com/mcp",
      "type": "http",
      "headers": {
        "Accept": "application/json",
        "X-Goog-Api-Key": "tu-api-key-aqui"
      }
    }
  }
}
```

### 3. Configuración por Cliente

#### **VSCode / GitHub Copilot**

1. Abre la Command Palette (`Cmd+Shift+P`)
2. Escribe "MCP: Add Server"
3. El servidor Stitch debería aparecer automáticamente

#### **Cursor**

Crea un archivo `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "stitch": {
      "url": "https://stitch.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "YOUR-API-KEY"
      }
    }
  }
}
```

#### **Antigravity**

1. En el Agent Panel, haz clic en los tres puntos (arriba a la derecha)
2. Selecciona **MCP Servers**
3. Haz clic en **Manage MCP Servers**
4. Selecciona "View raw config" y añade:

```json
{
  "mcpServers": {
    "stitch": {
      "serverUrl": "https://stitch.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "YOUR-API-KEY"
      }
    }
  }
}
```

#### **Gemini CLI**

Instala la extensión de Stitch:

```bash
gemini extensions install https://github.com/gemini-cli-extensions/stitch
```

### 4. Almacenar la API Key de Forma Segura

#### Opción A: Variables de Entorno (Recomendado)

```bash
export STITCH_API_KEY="tu-api-key-aqui"
```

Luego en el archivo `mcp.json`, referencia la variable:

```json
{
  "mcpServers": {
    "stitch": {
      "url": "https://stitch.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "${STITCH_API_KEY}"
      }
    }
  }
}
```

#### Opción B: Archivo .env Local (No comittear)

Crea un archivo `.env.local`:

```
STITCH_API_KEY=tu-api-key-aqui
```

Añade `.env.local` a tu `.gitignore`:

```bash
echo ".env.local" >> .gitignore
```

### 5. Casos de Uso: API Key vs OAuth

| Escenario | API Key | OAuth |
|-----------|---------|-------|
| **Máquina personal** | ✅ Recomendado | Para flujos web |
| **Ambiente efímero** | ❌ Inseguro | ✅ Recomendado |
| **Zero-Trust** | ❌ Inseguro | ✅ Recomendado |
| **Herramientas CLI** | ✅ Recomendado | No soporta |
| **Control de sesión** | Manual | Automático |

## Verificación

Para verificar que Stitch MCP está configurado correctamente:

1. Abre tu IDE (VSCode, Cursor, etc.)
2. En la paleta de comandos, busca "MCP"
3. Verifica que "stitch" aparezca en la lista de servidores
4. Debería mostrar estado: `Connected`

## Resolución de Problemas

**Error 401 Unauthorized**
- Verifica que tu API Key es correcta
- Genera una nueva API Key en https://stitch.withgoogle.com/settings
- Asegúrate de que el header es `X-Goog-Api-Key` (con guión)

**No se conecta**
- Verifica la conectividad a internet
- Prueba la URL: https://stitch.googleapis.com/mcp
- Reinicia tu IDE

**API Key no se encuentra**
- Usa rutas absolutas o variables de entorno
- No uses comillas extra en el valor

## Recursos

- [Documentación Oficial Stitch MCP](https://stitch.withgoogle.com/docs/mcp/setup/)
- [Stitch Settings](https://stitch.withgoogle.com/settings)
- [GitHub - Stitch Gemini CLI Extension](https://github.com/gemini-cli-extensions/stitch)

---

**Última actualización**: 2026-09-11
