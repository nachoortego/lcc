#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/epoll.h>
#include <sys/resource.h>
#include <assert.h>
#include <signal.h>
#include <pthread.h>
#include <errno.h>
#include "sock.h"
#include "common.h"
#include "kv.h"
#include "stats.h"
#include "proto.h"

/* Macro interna */
#define READ(fd, buf, n) ({						\
	int rc = read(fd, buf, n);					\
	if (rc < 0 && (errno == EAGAIN || errno == EWOULDBLOCK))	\
		return 0;						\
	if (rc <= 0)							\
		return -1;						\
	rc; })

//tenemos que verificar cuanto leimos

/* 0: todo ok, continua. -1 errores */
int text_consume(struct eventloop_data *evd, struct cinfo *ci)
{
	while (1) {
		int rem = sizeof ci->buf - ci->blen;
		assert (rem >= 0);

		/* Buffer lleno, no hay comandos, matar */
		if (rem == 0)
			return -1;

		int nread = READ(ci->fd, ci->buf + ci->blen, rem);

		log(3, "Read %i bytes from fd %i", nread, ci->fd);
		ci->blen += nread;

		char *p, *p0 = ci->buf;
		int nlen = ci->blen;

		/* Para cada \n, procesar, y avanzar punteros */
		while ((p = memchr(p0, '\n', nlen)) != NULL) {
			/* Mensaje completo */
			int len = p - p0;
			*p++ = 0;
			log(3, "full command: <%s>", p0);
			text_handle1(evd, ci, p0, len);
			nlen -= len + 1;
			p0 = p;
		}

		/* Si consumimos algo, mover */
		if (p0 != ci->buf) {
			memmove(ci->buf, p0, nlen);
			ci->blen = nlen;
		}
	}

	return 0;
}


/*
 * Aceptar nueva conexión, alocar un cinfo
 * y meterla al epoll set.
 */
int accept1(struct eventloop_data *evd, int lsock)
{
	int rc;

	int clifd = accept4(lsock, NULL, NULL, SOCK_NONBLOCK);
	if (clifd < 0) {
		if (errno == EAGAIN)
			log(0, "spurious!");
		log(0, "accept4 falló?");
		return -1;
	}

	struct cinfo *ci = galloc(sizeof *ci);
	if (!ci) {
		log(1, "OOM! No puedo aceptar cliente en fd %i", clifd);
		write(clifd, "EOOM\n", 5);
		close(clifd);
		return -1;
	}

	ci->typ = CLIENT;
	ci->fd = clifd;
	ci->blen = 0;
	

	struct epoll_event cliev;
	cliev.data.ptr = ci;
	cliev.events = EPOLLIN | EPOLLONESHOT | EPOLLRDHUP;

	log(2, "aceptando conexión fd %i", ci->fd);
	rc = epoll_ctl(evd->epfd, EPOLL_CTL_ADD, clifd, &cliev);
	if (rc < 0) {
		log(0, "epoll_ctl falló en accept1");
		close(ci->fd);
		free(ci);
		return -1;
	}

	return 0;
}

int handle_cli_ev(struct eventloop_data *evd, struct epoll_event *ev, struct cinfo *ci)
{
	int rc;
	assert(ci->typ == CLIENT);
	if (ev->events & EPOLLERR) {
		log(0, "ERROR para fd %i", ci->fd);
		rc = epoll_ctl(evd->epfd, EPOLL_CTL_DEL, ci->fd, NULL);
		if (rc < 0)
			log(1, "epoll_delete hangup??");

		close(ci->fd);
		free(ci);
		return 0;
	} else if (ev->events & (EPOLLRDHUP | EPOLLHUP)) {
		log(2, "remote hangup para fd %i", ci->fd);
		rc = epoll_ctl(evd->epfd, EPOLL_CTL_DEL, ci->fd, NULL);
		if (rc < 0)
			log(1, "epoll_delete remote hangup??");

		close(ci->fd);
		free(ci);
		return 0;
	} else if (ev->events & EPOLLIN) {
		struct cinfo *ci = ev->data.ptr;
		log(3, "epoll: evento en cliente p=%p", ci);
		log(3, "epoll: evento en cliente fd %i", ci->fd);
		//para printear en el archivo log depdende el numero lo que hay mayor al numero no se imprime

		int rc;
	
		rc = text_consume(evd, ci);

		/* Flushear el buffer de salida */
		cflush(ci);

		if (rc == 0) {
			/* Rearmar fd */
			struct epoll_event cliev = {0};
			cliev.data.ptr = ci;
			cliev.events = EPOLLIN | EPOLLONESHOT | EPOLLRDHUP;
			log(3, "rearm fd %i", ci->fd);
			rc = epoll_ctl(evd->epfd, EPOLL_CTL_MOD, ci->fd, &cliev);

			if (rc < 0)
				quit("epoll_ctl rearm");
		} else if (rc < 0) {
			/* Algún error? logear y chau */
			log(2, "Error en fd %i, errno=%i (%s)", ci->fd, errno, strerror(errno));

			/* Conexión cerrada, chau. Esto lo remueve del epoll también. */
			close(ci->fd);

			free(ci);
			return -1;
		}

		return 0;
	} else {
		log(0, "eventos desconocido para cliente fd=%i, %lx", ci->fd, ev->events);
		return -1;
	}
}

int handle_ev(struct eventloop_data *evd, struct epoll_event *ev)
{
	int rc;
	struct cinfo *ci = ev->data.ptr;

	if (!ci) {
		log(0, "ci == NULL???");
		return -1;
	}

	if (ci->typ == LSOCK) {
		int lsock = ci->fd;
		log(3, "epoll: event en socket");

		rc = accept1(evd, lsock);
		if (rc < 0)
			log(0, "accept1 failed?");

		/* Rearmar lsock fd */
		log(3, "rearm lsock fd %i", lsock);
		struct epoll_event lsockev;
		lsockev.data.ptr = ci;
		lsockev.events = EPOLLIN | EPOLLONESHOT;
		rc = epoll_ctl(evd->epfd, EPOLL_CTL_MOD, lsock, &lsockev);
		if (rc < 0)
			quit("epoll_ctl rearm lsock");

		return 0;
	} else if (ci->typ == CLIENT) {
		rc = handle_cli_ev(evd, ev, ci);
		return rc;
	} else {
		log(0, "ci->typ desconocido %i,%lx", ci->typ, ev->events);
		return -1;
	}
}

void * event_loop(void *arg)
{
	struct eventloop_data *evd = arg;
	int epfd = evd->epfd;
	int id = evd->id;
	int rc;

	while (1) {
#define NEV 16
		struct epoll_event ev[NEV];
		int nev;
		int i;

wait_again:	nev = epoll_wait(epfd, ev, NEV, -1);
		if (nev < 0) {
			if (errno == EINTR) {
				log(2, "eintr en epoll_wait!");
				goto wait_again;
			}
			quit("epoll_wait");
		}

		_STATS[id].n_ev += nev;

		if (nev == 0) {
			log(2, "no events?");
			continue;
		}
		/* log(0, "hay %i eventos", nev); */

		for (i = 0; i < nev; i++) {
			struct cinfo *ci = ev[i].data.ptr;
			log(3, "evento para fd %i", ci->fd);
			rc = handle_ev(evd, &ev[i]);
			if (rc)
				log(2, "error en handle_ev");
		}
#undef NEV
	}

	return NULL;
}

void server(int text_sock)
{
	int epfd;
	int rc;

	epfd = epoll_create(1);
	if (epfd < 0)
		quit("epoll_create");//recordar chequear errores

	{
		struct cinfo *text_ci = malloc(sizeof *text_ci);
		struct epoll_event ev;

		if (!text_ci)
			quit("oom server malloc");

		text_ci->typ = LSOCK;
		text_ci->fd = text_sock;
		ev.events = EPOLLIN | EPOLLONESHOT;
		ev.data.ptr = text_ci;
		rc = epoll_ctl(epfd, EPOLL_CTL_ADD, text_sock, &ev);
		if (rc < 0)
			quit("epoll_ctl.text_sock");
	}


#if 0
	struct eventloop_data *evdata_i = malloc(sizeof *evdata_i);
	if (!evdata_i)
		quit("oom evdata");
	evdata_i->epfd = epfd;
	evdata_i->id = 0;
	evdata_i->n_proc = 1;
	_STATS = calloc(1, sizeof _STATS[0]);
	event_loop(evdata_i);
#else
	int nproc = defopts.nthread == 0 ?
			sysconf(_SC_NPROCESSORS_ONLN) :
			defopts.nthread;

	pthread_t th[nproc];
	_STATS = calloc(nproc, sizeof _STATS[0]);

	for (int i = 0; i < nproc; i++) {
		struct eventloop_data *evdata_i = malloc(sizeof *evdata_i);
		if (!evdata_i)
			quit("oom evdata");

		evdata_i->epfd = epfd;
		evdata_i->id = i;
		evdata_i->n_proc = nproc;

		int rc = pthread_create(&th[i], NULL, event_loop, evdata_i);
		if (rc)
			quit("pthread_create");
	}

	for (int i = 0; i < nproc; i++)
		pthread_join(th[i], NULL);
#endif
}

void handle_signals()
{
	int rc;
	struct sigaction sigact = {
		.sa_handler = SIG_IGN,
	};

	rc = sigaction(SIGPIPE, &sigact, NULL);
	if (rc < 0)
		quit("sigaction");
}

void limit_mem()
{
	struct rlimit lim;
	int rc;

	rc = getrlimit(RLIMIT_DATA, &lim);
	if (rc < 0)
		quit("getrlimit");

	lim.rlim_cur = defopts.maxmem << 20;

	rc = setrlimit(RLIMIT_DATA, &lim);
	if (rc < 0)
		quit("setrlimit");
}

int main(int argc, char **argv)
{
	int text_sock;

	__loglevel = 2;

	handle_signals();

	limit_mem();

	text_sock = mk_tcp_sock(mc_lport_text);
	if (text_sock < 0)
		quit("mk_tcp_sock.text");


	kv_init(defopts.tablesz);

	server(text_sock);

	return 0;
}
