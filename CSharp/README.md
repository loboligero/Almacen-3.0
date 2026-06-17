# Almacén 3.0 - Versión C#

## Descripción
Migración del proyecto Almacén 3.0 de Delphi a C# (.NET 7.0)

### Características
- ✅ Gestión de albaranes
- ✅ Control de bultos y pesos
- ✅ Generación de etiquetas
- ✅ Reportes PDF con iText7
- ✅ Conexión a SQL Server
- ✅ Interfaz WinForms

## Requisitos
- .NET 7.0 o superior
- SQL Server 2019 o superior (Express, Developer)
- Microsoft ODBC Driver 17 for SQL Server
- Visual Studio 2022 (recomendado)

## Instalación

### 1. Clonar el repositorio
```bash
git clone https://github.com/loboligero/Almacen-3.0.git
cd Almacen-3.0/CSharp
```

### 2. Restaurar dependencias
```bash
dotnet restore
```

### 3. Configurar conexión a BD
Editar `config.ini` con tus credenciales:
```ini
[SQL]
Usuario=tu_usuario
Password=tu_contraseña
BaseDatos=AlmacenDB
```

### 4. Compilar y ejecutar
```bash
dotnet run
```

## Estructura del proyecto
```
CSharp/
├── Config/          # Configuración
├── Data/            # Acceso a datos
├── Forms/           # Formularios WinForms
├── Helpers/         # Clases auxiliares
├── Models/          # Modelos de datos
├── Reports/         # Generación de reportes
└── Almacen.CSharp.csproj
```

## Dependencias
- System.Data.SqlClient (acceso a BD)
- itext7 (generación PDF)
- itext7.bouncy-castle-adapter (soporte PDF)

## Notas de migración
- ✅ Convertido desde Delphi (Pascal)
- ✅ Usa ODBC Driver 17 para SQL Server
- ✅ Reportes: FastReport → iText7 (gratuito)
- ✅ UI: VCL → WinForms
- 🔄 En desarrollo: Más formularios y reportes

## Contacto
loboligero
