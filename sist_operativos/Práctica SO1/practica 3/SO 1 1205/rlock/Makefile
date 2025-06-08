CFLAGS += -pthread -O99

ALL_SOURCES = $(wildcard *.c)
EXCLUDE = rwlock.c
MAINS = $(filter-out $(EXCLUDE), $(ALL_SOURCES))
PROGS = $(patsubst %.c,%,$(MAINS))

all: lect-esc-rpref 

lect-esc-rpref: lect-esc.c rwlock-rpref.c
	$(CC) $(CFLAGS) $^ -o $@


