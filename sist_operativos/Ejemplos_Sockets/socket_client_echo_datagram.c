#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include "socket_server_configuration.h"

#define CLI_NOMBRE "./CLIENTE"
#define MSG "JAIME!"

/* Cliente Echo */

int main(){
  
  ssize_t nbytes;
  char buff[MAXMSG+1];

  int sock_cli;
  struct sockaddr_un cli_name;
  struct sockaddr_un srv_name;
  socklen_t srv_size = sizeof(srv_name);



  /* Creación del socket */
  sock_cli = socket(AF_UNIX, SOCK_DGRAM, 0);
  if(sock_cli < 0){
    perror("Falló la creación del socket ");
    exit(EXIT_FAILURE);
  }

  /* Creamos la estructura de la dirección del socket */
  cli_name.sun_family = AF_UNIX;
  strncpy(cli_name.sun_path, CLI_NOMBRE, sizeof(cli_name.sun_path));

  // remove socket address path if it is under usage (https://gavv.github.io/articles/unix-socket-reuse/)
  unlink(cli_name.sun_path);

  /* Asignación del nombre */
  if( (bind(sock_cli, (struct sockaddr*) & cli_name , sizeof(cli_name))) < 0 ){
    perror("Falló la asignación de nombre");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] SOCKET: %s\n", CLI_NOMBRE);

  /* Nombre/Dirección del servidor */
  srv_name.sun_family = AF_UNIX;
  strncpy(srv_name.sun_path, SRV_NOMBRE, sizeof( srv_name.sun_path ));

  /* Llenamos el buffer */
  strcpy(buff, MSG);

  /* Enviar 'buff' al servidor! */
  nbytes = sendto(sock_cli, buff, strlen(buff), 0, (struct sockaddr *) &srv_name, srv_size);
  if(nbytes < 0) {
    perror("Falló el sendto");
    exit(EXIT_FAILURE);
  }
  printf("[DIAG] SEND: OK\n");

  /* Nos quedamos entonces a la espera de la respuesta del servidor */
  nbytes = recvfrom(sock_cli, buff, MAXMSG, 0, (struct sockaddr *) &srv_name, &srv_size);
  if(nbytes < 0) {
    perror("Falló el recvfrom");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] RECV: >%s<\n", buff);

  /*****************************************/
  close(sock_cli);
  remove(CLI_NOMBRE);

  return EXIT_SUCCESS;
}
