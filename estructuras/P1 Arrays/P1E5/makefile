# Makefile para el ejercicio de matrices (P1E5)
# ejecutar como make (por defecto se usa matriz_bi)
# o como make IMPL=matriz_uni

DEFAULTIMPL=matriz_bi

ifdef IMPL
programa: main.o $(IMPL).o
	$(CC) -o $@ $^
else
programa: main.o $(DEFAULTIMPL).o
	$(CC) -o $@ $^
endif

main.o: main.c matriz.h
	$(CC) -c $<

matriz_uni.o: matriz_uni.c matriz.h
	$(CC) -c $<

matriz_bi.o: matriz_bi.c matriz.h
	$(CC) -c $<

clean:
	-rm *.o

.PHONY = clean