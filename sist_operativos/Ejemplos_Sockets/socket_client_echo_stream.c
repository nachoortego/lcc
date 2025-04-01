#include <sys/socket.h>
#include <sys/un.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "socket_server_configuration.h"

#define CLI_NOMBRE "./CLIENTE"
#define MSG "JAIME!"

int main(){

  int sock_cli;
  struct sockaddr_un srv_name, cli_name;
  socklen_t srv_size;
  
  ssize_t nbytes;
  char buff[MAXMSG+1];

  sock_cli = socket(AF_UNIX, SOCK_STREAM, 0);
  if(sock_cli < 0){
    perror("Falló la creación del socket");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] Se creó el socket :D\n");

  // Para conexiones de tipo stream, el bind() en el cliente es opcional.
  // Hacer el bind() permite que el servidor conozca el nombre del cliente

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

  /* Asignamos la dirección del servidor */
  srv_name.sun_family = AF_UNIX;
  strncpy(srv_name.sun_path, SRV_NOMBRE,sizeof(srv_name.sun_path));
  srv_size = sizeof(struct sockaddr_un);
  /******************************************/

  if((connect(sock_cli, (struct sockaddr *) &srv_name, srv_size))< 0){
    perror("Falló el intento de conexión con el servidor");
    exit(EXIT_FAILURE);
  }

  printf("[DIAG] Conexión con %s OK!\n", SRV_NOMBRE);

  /* Enviamos un mensaje al Servidor */
  nbytes = send(sock_cli, MSG, sizeof(MSG), 0);
  if(nbytes < 0 ){
    perror("Falló el envío del mensaje");
    exit(EXIT_FAILURE);
  }

  /* Esperamos la respuesta */
  nbytes = recv(sock_cli, buff, MAXMSG, 0);
  if(nbytes < 0){
    perror("Falló la recepción de un mensaje");
    exit(EXIT_FAILURE);
  }
  buff[nbytes] = '\0';
  printf("[DIAG] Llegó >%s<\n", buff);

  close(sock_cli);
  return(EXIT_SUCCESS);
}
