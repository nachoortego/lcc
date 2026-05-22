# Consultas de prueba - Álgebra Relacional

Consultas para ejercitar todas las operaciones del sistema usando las tablas precargadas: `AlumnosA`, `AlumnosB`, `Materias`, `Inscripciones`, `Obligatorias`.

---

## 1. Proyección (PROY)

Selecciona un subconjunto de columnas.

```
PROY[nombre](AlumnosA)
```

```
PROY[materia](Inscripciones)
```

```
PROY[id,materia](Inscripciones)
```

---

## 2. Selección (SEL)

Filtra filas que cumplen una condición.

**Por igualdad:**
```
SEL[id == 1](AlumnosA)
```

**Por texto:**
```
SEL[nombre == "Ana"](AlumnosA)
```

**Comparaciones numéricas:**
```
SEL[id >= 4](AlumnosA)
```

```
SEL[id > 2 && id < 6](AlumnosB)
```

**Negación:**
```
SEL[!(nombre == "Juan")](AlumnosA)
```

**Condición compleja (OR):**
```
SEL[nombre == "Ana" || nombre == "Carlos"](AlumnosB)
```

**Sobre materia:**
```
SEL[materia == "Base de Datos"](Inscripciones)
```

---

## 3. Renombre (REN)

Cambia el nombre de un atributo (útil para JOIN y composiciones).

```
REN[nombre -> alumno](AlumnosA)
```

```
REN[materia -> asignatura](Materias)
```

---

## 4. Unión (UNION)

Combina filas de dos relaciones con el mismo esquema (elimina duplicados).

```
AlumnosA UNION AlumnosB
```

```
PROY[materia](Inscripciones) UNION Obligatorias
```

---

## 5. Diferencia (DIFF)

Filas que están en la primera relación pero no en la segunda.

```
AlumnosA DIFF AlumnosB
```

```
AlumnosB DIFF AlumnosA
```

```
PROY[materia](Inscripciones) DIFF Obligatorias
```

---

## 6. Intersección (INTER)

Filas que están en ambas relaciones.

```
AlumnosA INTER AlumnosB
```

```
PROY[materia](Inscripciones) INTER Obligatorias
```

---

## 7. Join natural (JOIN)

Combina filas donde los atributos con el mismo nombre coinciden.

**Alumnos con sus inscripciones (join por id):**

*Primero crear vista de todos los alumnos:*
```
VIEW TodosAlumnos AS (AlumnosA UNION AlumnosB)
```

*Luego:*
```
Inscripciones JOIN TodosAlumnos
```

**Inscripciones en materias obligatorias (join por materia):**
```
Inscripciones JOIN Obligatorias
```

---

## 8. Producto cartesiano (PROD)

Todas las combinaciones de filas entre dos relaciones.

```
Materias PROD Obligatorias
```

```
PROY[materia](Materias) PROD PROY[materia](Obligatorias)
```

---

## 9. División (DIV)

Alumnos que cursan **todas** las materias obligatorias.

```
PROY[id,materia](Inscripciones) DIV Obligatorias
```

*Nota: La división R ÷ S devuelve los valores de R (atributos que no están en S) que aparecen combinados con todas las tuplas de S.*

---

## 10. Composiciones y optimizador

Consultas que combinan varias operaciones. El optimizador simplifica y reordena automáticamente.

**Selección sobre unión:**
```
SEL[id > 3](AlumnosA UNION AlumnosB)
```

**Proyección sobre selección:**
```
PROY[nombre](SEL[id >= 2](AlumnosA))
```

**Cascada de selecciones (el optimizador las fusiona):**
```
SEL[id > 1](SEL[id < 5](SEL[nombre != "Pedro"](AlumnosB)))
```

**Selección sobre producto (el optimizador intenta bajar la selección):**
```
SEL[materia == "AyGA II"](Materias PROD Obligatorias)
```

**Proyección sobre join:**
```
PROY[id,nombre,materia](Inscripciones JOIN TodosAlumnos)
```

*Obsérvese en la salida la diferencia entre "Consulta parseada" y "Consulta optimizada".*

---

## 11. Vistas

Definir vistas reutilizables y usarlas en consultas posteriores.

**Vista: todos los alumnos**
```
VIEW TodosAlumnos AS (AlumnosA UNION AlumnosB)
```

```
TodosAlumnos
```

**Vista: alumnos inscritos en obligatorias**
```
VIEW InscritosObligatoria AS (Inscripciones JOIN Obligatorias)
```

```
PROY[id](InscritosObligatoria)
```

**Vista: materias no obligatorias**
```
VIEW Optativas AS (Materias DIFF Obligatorias)
```

```
Optativas
```

**Vista compuesta usando otra vista**
```
VIEW AlumnosEnOptativas AS (Inscripciones JOIN Optativas)
```

```
AlumnosEnOptativas
```

**Composición: alumnos que cursan todas las obligatorias**
```
VIEW CursanTodasOblig AS (PROY[id,materia](Inscripciones) DIV Obligatorias)
```

```
CursanTodasOblig
```

---

## 12. Casos de uso completos

### Alumnos únicos (sin duplicados por estar en A y B)
```
AlumnosA UNION AlumnosB
```

### Solo alumnos de A que no están en B
```
AlumnosA DIFF AlumnosB
```

### Alumnos que están en ambos grupos
```
AlumnosA INTER AlumnosB
```

### Inscripciones con nombre del alumno
*Requiere vista TodosAlumnos creada antes.*
```
Inscripciones JOIN TodosAlumnos
```

### Alumnos que cursan AyGA II
```
PROY[id,nombre](SEL[materia == "AyGA II"](Inscripciones) JOIN TodosAlumnos)
```

### Materias que alguien cursa
```
PROY[materia](Inscripciones)
```

### Alumnos que aprobaron todas las obligatorias (división)
```
PROY[id,materia](Inscripciones) DIV Obligatorias
```
