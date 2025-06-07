CC = clang
CFLAGS += -Wall -O3
LDFLAGS += -pthread

all: memcached 



memcached: memcached.o sock.o ll.o hash.o kv.o common.o log.o stats.o proto.o

clean:
	rm -f memcached  *.o

re: clean all

run: all
	./memcached

.deps.mk:
	$(CC) -MM *.c > .deps.mk



.PHONY: all clean re run

include .deps.mk
