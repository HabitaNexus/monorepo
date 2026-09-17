# Stitch MCP Skill

## Overview

Stitch es un servidor Model Context Protocol (MCP) remoto que permite generar y editar interfaces de usuario (UI) de forma visual usando IA. Integra tus herramientas de desarrollo favoritas (VSCode, Cursor, Gemini CLI, etc.) directamente con Stitch.

## Cuándo Usar Este Skill

- 🎨 Necesitas generar UI wireframes o prototipos
- 🤖 Quieres que IA ayude a diseñar componentes visuales
- 🔗 Deseas integrar generación de UI en tu flujo de desarrollo
- 🚀 Desarrollas aplicaciones Flutter/React/Web con énfasis en UI
- 📱 Necesitas prototipar rápidamente interfaces

## Requisitos Previos

- Cuenta en [Stitch by Google](https://stitch.withgoogle.com)
- API Key generada en [Stitch Settings](https://stitch.withgoogle.com/settings)
- IDE compatible (VSCode, Cursor, Antigravity, etc.)
- Python 3.8+ para algunas integraciones

## Configuración Inicial

### 1. Generar API Key

```bash
# Accede a: https://stitch.withgoogle.com/settings
# Sección: API Keys
# Acción: Click "Create API Key"
```

### 2. Actualizar mcp.json

```json
{
  "mcpServers": {
    "stitch": {
      "url": "https://stitch.googleapis.com/mcp",
      "type": "http",
      "headers": {
        "X-Goog-Api-Key": "YOUR-API-KEY-HERE"
      }
    }
  }
}
```

### 3. Verificar Conexión

En VSCode:
- Abre Command Palette: `Cmd+Shift+P`
- Escribe: `MCP: Show Status`
- Verifica que `stitch` muestre: `Connected ✓`

## Casos de Uso

### Caso 1: Generar UI desde Descripción de Features

**Request:**
```
Crea un formulario de login con:
- Email input
- Password input
- Remember me checkbox
- Login button
- Forgot password link
```

**Stitch genera:**
- Wireframe visual del formulario
- Assets reutilizables
- Código base (Flutter/React)

### Caso 2: Mejorar Diseño Existente

```
Refactoriza este dashboard:
- Añade animaciones suaves
- Implementa dark mode
- Mejora espaciado y tipografía
```

### Caso 3: Generar Componentes Reutilizables

```
Crea un componente Card que:
- Muestre imagen, título, descripción
- Tenga estados: normal, hover, pressed
- Sea responsive
```

## Integración con tu Flujo

### Generación de UI en Flutter

```dart
// Stitch genera estos componentes automáticamente
import 'package:flutter/material.dart';
import 'features/auth/presentation/widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: LoginFormWidget(), // Generado por Stitch
    );
  }
}
```

### Flujo de Trabajo Recomendado

1. **Planificación**: Define requirements en Linear
2. **Generación**: Usa Stitch MCP para generar UI
3. **Integración**: Adapta el código generado en Flutter
4. **Iteración**: Solicita mejoras a través del chat
5. **Testing**: Verifica con Flutter driver/widget tests

## Capacidades Principales

### ✅ Soportado

- Generación de wireframes desde descripción
- Exportación de assets (SVG, PNG, PDF)
- Componentes reutilizables
- Diseño responsivo
- Temas y paletas de color
- Animaciones básicas
- Guías de estilo

### ⚠️ Limitaciones

- No soporta lógica de backend directamente
- Genera UI, no comportamiento
- Requiere refinamiento manual
- No acceso a datos en tiempo real

## Autenticación

### Opción A: API Key (Recomendado para desarrollo local)

```json
{
  "headers": {
    "X-Goog-Api-Key": "sk-abc123..."
  }
}
```

✅ **Ventajas**: Rápido de configurar, ideal para desarrollo
❌ **Riesgos**: No guardes en repositorios públicos

### Opción B: OAuth (Para ambientes compartidos)

Implementa flujo OAuth para ambientes empresariales:

1. Configura OAuth en Stitch Settings
2. VSCode manejará el login automáticamente
3. Sesión se revoca automáticamente tras logout

## Ejemplos

### Ejemplo 1: Generar Dashboard

```
@stitch generate-ui
Crea un dashboard de HabitaNexus con:
- Cards de hábitos diarios
- Gráfico de progreso semanal
- Bottom navigation con 4 tabs
- Tema Material Design 3
```

**Output:**
- Diseño visual completo
- Componentes reutilizables
- Flutter code scaffold

### Ejemplo 2: Mejorar Formulario

```
@stitch refine
El formulario de registro actual tiene:
- Campos: email, password, name, age
- Problema: No es mobile-friendly
- Solicitud: Hazlo responsive y agrega validación visual
```

### Ejemplo 3: Generar Paleta de Colores

```
@stitch colors
Crea una paleta de colores para HabitaNexus que:
- Sea accesible (WCAG AA mínimo)
- Tenga vibrante pero profesional
- Incluya dark mode automático
```

## Mejores Prácticas

### 1. Describe con Claridad

❌ Malo: "Haz una pantalla bonita"
✅ Bueno: "Crea una pantalla con lista de tareas con: checkbox, nombre, fecha vencimiento, prioridad (rojo/amarillo/verde)"

### 2. Proporciona Contexto

```
Para la aplicación HabitaNexus (gestión de hábitos):
- Audiencia: Jóvenes adultos (18-35)
- Dispositivos: Principalmente móvil
- Tema: Productividad y bienestar
- Paleta: Blues, greens, con acentos energéticos
```

### 3. Itera Gradualmente

```
Iteración 1: Estructura base
Iteración 2: Refinamiento visual
Iteración 3: Microinteracciones
Iteración 4: Exportación final
```

### 4. Integra con CI/CD

```yaml
# En tu GitHub Actions
- name: Generate UI with Stitch
  run: |
    export STITCH_API_KEY=${{ secrets.STITCH_API_KEY }}
    stitch generate --config stitch.config.yaml
```

## Resolución de Problemas

### "401 Unauthorized"

```bash
# Verifica API Key
curl -H "X-Goog-Api-Key: YOUR-KEY" \
  https://stitch.googleapis.com/mcp/health

# Si falla, regenera en:
# https://stitch.withgoogle.com/settings
```

### "Connection refused"

```bash
# Verifica conectividad
ping stitch.googleapis.com

# Verifica firewall
netstat -an | grep 443
```

### "Rate limit exceeded"

```
Espera 60 segundos y reintenta.
Usa caching local para resultados recientes.
Suscríbete a plan premium si necesitas más llamadas.
```

## Integración con Flutter

### Setup en pubspec.yaml

```yaml
dev_dependencies:
  stitch_generator: ^1.0.0
```

### Usar assets generados

```dart
// stitch_assets.dart (generado automáticamente)
import 'package:flutter/material.dart';

class StitchAssets {
  static const loginFormDesign = 'assets/stitch/login_form.svg';
  static const dashboardLayout = 'assets/stitch/dashboard.svg';
  
  static const Colors appColors = Colors(
    primary: Color(0xFF6366F1),
    secondary: Color(0xFF10B981),
  );
}
```

## Variables de Entorno

```bash
# .env.local (NO COMMITTEAR)
STITCH_API_KEY=sk-abc123...
STITCH_PROJECT_ID=proj_xyz789

# .env (Safe para públicos)
STITCH_ENVIRONMENT=production
STITCH_ENDPOINT=https://stitch.googleapis.com/mcp
```

## Referencias

- [Documentación Oficial Stitch](https://stitch.withgoogle.com/docs/)
- [MCP Setup Guide](https://stitch.withgoogle.com/docs/mcp/setup/)
- [Stitch Settings](https://stitch.withgoogle.com/settings)
- [API Reference](https://stitch.withgoogle.com/docs/api/reference/)

## Soporte

- 📧 Email: support@stitch.withgoogle.com
- 🐛 Issues: https://github.com/GoogleCloudPlatform/stitch-issues
- 💬 Community: Discord de Stitch

---

**Keywords**: stitch, ui-generation, mcp, figma, design, flutter, prototyping

**Última actualización**: 2026-09-11
