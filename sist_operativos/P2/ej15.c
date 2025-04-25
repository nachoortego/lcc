#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/epoll.h>
#include <errno.h>
#define MAX_EVENTS 10

/*
* Para probar, usar netcat. Ej:
*
* $ nc localhost 4040
* NUEVO
* 0
* NUEVO
* 1
* CHAU
*/

pthread_mutex_t mutex_handler = PTHREAD_MUTEX_INITIALIZER;
int lsock;

void quit(char *s) {
  perror(s);
  abort();
}

int U = 0;

int fd_readline(int fd, char *buf) {
  int rc;
  int i = 0;

  /*
  * Leemos de a un caracter (no muy eficiente...) hasta
  * completar una línea.
  */
  while ((rc = read(fd, buf + i, 1)) > 0) {
    if (buf[i] == '\n')
      break;
    i++;
  }

  if (rc < 0)
    return rc;

  buf[i] = 0;
  return i;
}

void handle_conn(int csock) {
  char buf[200];
  int rc;

  while (1) {
    /* Atendemos pedidos, uno por linea */
    rc = fd_readline(csock, buf);
    if (rc < 0)
      quit("read... raro");

    if (rc == 0) {
      /* linea vacia, se cerró la conexión */
      close(csock);
      return;
    }

    if (!strcmp(buf, "NUEVO")) {
      char reply[20];
      sprintf(reply, "%d\n", U);
      U++;
      write(csock, reply, strlen(reply));
    } else if (!strcmp(buf, "CHAU")) {
      close(csock);
      return;
    }
  }
}

void* thread_handler(void* args) {
  int epollfd = *((int*)args);
  struct epoll_event ev, events[MAX_EVENTS];
  int csock, nfds;
  struct sockaddr addr;
  socklen_t addrlen;

  for (;;) {
    nfds = epoll_wait(epollfd, events, MAX_EVENTS, -1);
    if (nfds == -1) {
      perror("epoll_wait");
      exit(EXIT_FAILURE);
    }

    for (int n = 0; n < nfds; n++) {
      if (events[n].data.fd == lsock) {
        csock = accept(lsock, (struct sockaddr *) &addr, &addrlen);
        if (csock == -1) {
          perror("accept");
          exit(EXIT_FAILURE);
        }
        ev.events = EPOLLIN | EPOLLONESHOT;
        ev.data.fd = csock;
        if (epoll_ctl(epollfd, EPOLL_CTL_ADD, csock, &ev) == -1) {
          perror("epoll_ctl: csock");
          exit(EXIT_FAILURE);
        }
      } else {
        handle_conn(events[n].data.fd);
        ev.events = EPOLLIN | EPOLLONESHOT;
        ev.data.fd = events[n].data.fd;
        if (epoll_ctl(epollfd, EPOLL_CTL_MOD, events[n].data.fd, &ev) == -1) {
          perror("epoll_ctl: events[n].data.fd");
          exit(EXIT_FAILURE);
        }
      }
    }
  }
  return NULL;
}

void wait_for_clients(int lsock) {
  struct epoll_event ev;
  int csock, epollfd, n_threads = 5;

  epollfd = epoll_create1(0);
  if (epollfd == -1) {
    perror("epoll_create1");
    exit(EXIT_FAILURE);
  }

  ev.events = EPOLLIN;
  ev.data.fd = lsock;
  if (epoll_ctl(epollfd, EPOLL_CTL_ADD, lsock, &ev) == -1) {
    perror("epoll_ctl: lsock");
    exit(EXIT_FAILURE);
  }

  pthread_t t1, t2, t3, t4, t5;
  pthread_t threads[] = { t1, t2, t3, t4, t5 };

  for (int i = 0; i < n_threads; i++)
    pthread_create(&threads[i], NULL, thread_handler, (void*)&epollfd);

  for (int i = 0; i < n_threads; i++)
    pthread_join(threads[i], NULL);
}

/* Crea un socket de escucha en puerto 4040 TCP */
int mk_lsock() {
  struct sockaddr_in sa;
  int lsock;
  int rc;
  int yes = 1;

  /* Crear socket */
  lsock = socket(AF_INET, SOCK_STREAM, 0);
  if (lsock < 0)
    quit("socket");

  /* Setear opción reuseaddr... normalmente no es necesario */
  if (setsockopt(lsock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes) == 1)
    quit("setsockopt");

  sa.sin_family = AF_INET;
  sa.sin_port = htons(4040);
  sa.sin_addr.s_addr = htonl(INADDR_ANY);

  /* Bindear al puerto 4040 TCP, en todas las direcciones disponibles */
  rc = bind(lsock, (struct sockaddr *)&sa, sizeof sa);
  if (rc < 0)
    quit("bind");

  /* Setear en modo escucha */
  rc = listen(lsock, 10);
  if (rc < 0)
    quit("listen");

  return lsock;
}

int main() {
  lsock = mk_lsock();
  wait_for_clients(lsock);

  pthread_mutex_destroy(&mutex_handler);
}
