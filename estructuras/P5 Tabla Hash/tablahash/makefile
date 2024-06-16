# Makefile para compilar el proyecto

# Compilador
CC = gcc
# Opciones de compilación
CFLAGS = -Wall -Wextra -g
# Archivos fuente
SRCDIR = .
# Directorio de objetos
OBJDIR = obj
# Directorio de includes
INCDIR = .
# Nombre del ejecutable
TARGET = programa

# Lista de archivos fuente
SRCS = $(wildcard $(SRCDIR)/*.c)
# Lista de objetos generados
OBJS = $(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
# Dependencias de objetos
DEPS = $(wildcard $(INCDIR)/*.h)

# Regla principal, compilación del ejecutable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Regla para los objetos
$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPS)
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $< -I$(INCDIR)

# Regla para limpiar los archivos compilados
clean:
	rm -f $(OBJDIR)/*.o $(TARGET)

# Indicar que 'clean' no es un archivo
.PHONY: clean
