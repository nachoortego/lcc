#ifndef __COMMON_H
#define __COMMON_H 1

#include <netinet/ip.h>
#include <stdio.h>
#include <stdlib.h>
#include "log.h"

enum code {
	PUT = 11,
	DEL = 12,
	GET = 13,
	TAKE = 14,

	STATS = 21,

	OK = 101,
	EINVALID = 111,
	ENOTFOUND = 112,
	EBIG = 114,
	EUNK = 115,
	EOOM = 116,
};

int valid_rq(int code);

struct eventloop_data {
	int epfd;
	int id;
	int n_proc;
};

enum etype {
	LSOCK,
	CLIENT,
};

struct cinfo {
	enum etype typ; /* si == LSOCK, sólo importa fd y binary */
	int fd;
	char buf[2048];
	int blen;

	/* Buffer de salida */
	char obuf[2048];
	int olen;
};

int cwrite(struct cinfo *ci, void *buf, size_t len);
void cflush(struct cinfo *ci);

struct mc_config {
	int maxmem;		/* Memoria máxima en megabytes */
	int nthread;		/* Número de threads, 0 = automático */
	int tablesz;		/* Dimensión de tabla hash */
};

extern struct mc_config defopts;

static const in_port_t mc_lport_text = 8888;


static inline void quit(char *s)
{
	perror(s);
	exit(1);
}

#define STATIC_ASSERT(p)			\
	int _ass_ ## __LINE__ [(!!(p)) - 1];

const char * error_str(enum code e);

#endif
