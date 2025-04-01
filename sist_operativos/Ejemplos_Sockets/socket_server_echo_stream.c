#include <sys/socket.h>
#include <sys/un.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "socket_server_configuration.h"

#define BLOG 1

/* Servidor Echo con Sockets de tipo Stream */

int main(){
  
  int sock_srv, sock_cli;
  struct sockaddr_un srv_name, cli_name;
  socklen_t cli_size;

  ssize_t nbytes;
  char buff[MAXMSG+1];

  /* Creación de Socket Servidor */
  sock_srv = socket(AF_UNIX, SOCK_STREAM, 0);
  if(sock_srv < 0)
  {
    perror("Falló la creación del socket");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] SOCKET Ok :D\n");

  /* Asignamos la dirección del servidor */
  srv_name.sun_family = AF_UNIX;
  strncpy(srv_name.sun_path, SRV_NOMBRE, sizeof(srv_name.sun_path));

  // remove socket address path if it is under usage (https://gavv.github.io/articles/unix-socket-reuse/)
  unlink(srv_name.sun_path);

  if(bind(sock_srv, (struct sockaddr *) &srv_name, sizeof(srv_name)))
  {
    perror("Falló la asignación del nombre del servidor");
    exit(EXIT_FAILURE);
  }
  printf("[DIAG] BIND Ok :D\n");

  /* El servidor se pone a la espera de conexiones */
  if(listen(sock_srv, BLOG) < 0)
  {
    perror("Falló el listen");
    exit(EXIT_FAILURE);
  }
  printf("[DIAG] Listen Ok :D\n");

  /* Apareció una conexión :D! */
  sock_cli = accept(sock_srv, (struct sockaddr *) &cli_name, &cli_size);
  if(sock_cli < 0)
  {
    perror("Falló el 'accept' ");
    exit(EXIT_FAILURE);
  }

  if (cli_size > sizeof(sa_family_t))
  {
    printf("[DIAG] Acc >%s<:D\n", cli_name.sun_path);  // para que este printf funcione tenemos que hacer bind() en el client
  }

  /* Recibimos un mensaje */
  nbytes = recv(sock_cli, buff, MAXMSG, 0);
  printf("[DIAG] Llegó >%s<\n", buff);

  /* Enviamos el echo */
  nbytes = send(sock_cli, buff, nbytes, 0);
  if(nbytes < 0 ){
    perror("Falló el envío del echo");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] Nos vemos en Disney\n");
  close(sock_cli);
  /*******/

  /* Servidor cerrándose */
  close(sock_srv);
  remove(SRV_NOMBRE);
}
