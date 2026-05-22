# Álgebra Relacional

Intérprete de álgebra relacional con soporte para consultas, vistas, optimización automática y carga de datos desde CSV.

## Requisitos

- [Stack](https://docs.haskellstack.org/) (recomendado) o [GHC](https://www.haskell.org/ghc/) + [Cabal](https://cabal.readthedocs.io/)
- Haskell 9.x

## Instalación

### Con Stack (recomendado)

```bash
# Clonar o descargar el repositorio
cd algebra-relacional

# Compilar el proyecto
stack build

# Ejecutar
stack run
```

### Con Cabal

```bash
cd algebra-relacional
cabal build
cabal run algebra-relacional
```

## Uso

Al iniciar, el programa carga automáticamente los archivos CSV de la carpeta `data/`. Cada archivo `.csv` se convierte en una tabla (el nombre es el del archivo sin extensión).

### Comandos

| Comando       | Descripción                          |
|---------------|--------------------------------------|
| `help`, `h`   | Muestra el manual de operaciones    |
| `tablas`      | Lista todas las tablas y vistas     |
| `refresh`, `r`| Recarga los CSV desde `data/`       |
| `exit`        | Sale del programa                   |

### Operaciones unarias

| Operación | Sintaxis                   | Ejemplo                          |
|-----------|----------------------------|----------------------------------|
| Proyección| `PROY[col1, col2](R)`      | `PROY[nombre](AlumnosA)`         |
| Selección | `SEL[condición](R)`        | `SEL[id == 1](AlumnosA)`         |
| Renombre  | `REN[viejo -> nuevo](R)`   | `REN[nombre -> alumno](AlumnosA)`|

### Operaciones binarias

| Operación         | Sintaxis     | Ejemplo                 |
|-------------------|--------------|-------------------------|
| Unión             | `R1 UNION R2`| `AlumnosA UNION AlumnosB`|
| Diferencia        | `R1 DIFF R2` | `AlumnosA DIFF AlumnosB` |
| Intersección      | `R1 INTER R2`| `AlumnosA INTER AlumnosB`|
| Join natural      | `R1 JOIN R2` | `Inscripciones JOIN AlumnosA` |
| Producto cartesiano| `R1 PROD R2`| `Materias PROD Obligatorias` |
| División          | `R1 DIV R2`  | `Inscripciones DIV Obligatorias` |

### Condiciones en selección

- Operadores: `==`, `!=`, `>`, `<`, `>=`, `<=`
- Conectores: `&&` (y), `||` (o), `!` (no)
- Ejemplo: `SEL[id > 2 && nombre != "Ana"](AlumnosA)`

### Vistas

Crear una vista reutilizable:

```
VIEW NombreVista AS (expresión)
```

Ejemplo: `VIEW TodosAlumnos AS (AlumnosA UNION AlumnosB)`

### Ejemplo de sesión

```
RA> tablas

RA> PROY[nombre](SEL[id >= 3](AlumnosA))

RA> AlumnosA UNION AlumnosB

RA> VIEW InscritosObligatoria AS (Inscripciones JOIN Obligatorias)

RA> InscritosObligatoria
```

## Estructura de datos

Los archivos CSV en `data/` deben tener la primera fila como encabezado (nombres de columnas). Los valores numéricos se interpretan como enteros; el resto como texto.

## Licencia

BSD-3-Clause
