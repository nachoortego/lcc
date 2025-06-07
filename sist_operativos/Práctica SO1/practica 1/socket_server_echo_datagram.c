#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include "socket_server_configuration.h"

/* Servidor Echo */

int main(){

  int sock_srv;
  struct sockaddr_un srv_name;
  struct sockaddr_un cli_name;
  socklen_t cli_size = sizeof(cli_name);

  ssize_t nbytes;
  char buff[MAXMSG+1];

  /* Creación del socket */
  sock_srv = socket(AF_UNIX, SOCK_DGRAM, 0);
  if(sock_srv < 0){
    perror("Falló la creación del socket ");
    exit(EXIT_FAILURE);
  }

  /* Creamos la estructura de la dirección del socket */
  srv_name.sun_family = AF_UNIX;
  strncpy(srv_name.sun_path, SRV_NOMBRE, sizeof(srv_name.sun_path));

  // remove socket address path if it is under usage (https://gavv.github.io/articles/unix-socket-reuse/)
  unlink(srv_name.sun_path);

  /* Asignación del nombre */
  if( (bind(sock_srv, (struct sockaddr*) & srv_name , sizeof(srv_name))) < 0 ) {
    perror("Falló la asignación de nombre");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] SOCKET: %s\n", SRV_NOMBRE);

  /* El servidor se queda a la espera de un mensaje por el socket */
  nbytes = recvfrom(sock_srv, buff, MAXMSG, 0, (struct sockaddr *) &cli_name, &cli_size);
  if(nbytes < 0) {
    perror("Falló el recvfrom");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] RECV: >%s<\n", buff);

  /* Responder el echo! */
  nbytes = sendto(sock_srv, buff, nbytes, 0, (struct sockaddr *) & cli_name, cli_size);
  if(nbytes < 0) {
    perror("Falló el sendto");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] SEND: OK\n");

  /*****************************************/
  close(sock_srv);
  remove(SRV_NOMBRE);

  return EXIT_SUCCESS;
}
