#include <sys/socket.h> /* socketpair */
#include <stdio.h>  /* Prints */
#include <assert.h> /* assert */
#include <stdlib.h> /* exit status */
#include <unistd.h> /* write/read/fork + stuff */


#define MSGP "HOLAA!"
#define MSGC1 "HOLAA! UNO"
#define MSGC2 "HOLAA! DOS"
#define BUFFER 1024

/*
 * TODO SACAR LOS TERMINADORES DE STRING (AL MENOS UNO, PA JUGA)
 */

int main(){
  int socket_vector[2];
  char buffer[BUFFER];


  /* Creación de sockets conectados */
  assert (! socketpair( AF_UNIX /* Conexión local */
            , SOCK_DGRAM/* Tipo de socket orientado a datagramas */
            , 0 /* Protocolo por default */
            , socket_vector /* File descriptors para usar en la TX de datos */
         ));

  /*
   * Protocolo de Comunicación:
   Parent -> Child ;
   Child -> Parent x 2
   */
  
  switch( fork() ){
  case -1:
    perror("Hay un error en la habitación");
    exit(EXIT_FAILURE);

  case 0: /* Child: I/O en socket_vector[0] */
    printf("Child: Hi!\n");
    /* Cerramos el endpoint de Parent */
    close(socket_vector[1]);
    /**********************/

    /* Esperamos que Parent nos salude*/
    assert( 0 < read( socket_vector[0], buffer, BUFFER)); // read() al trabajar con sockets lee de a datagramas/mensajes (y no a nivel de bytes).
    printf("Child: Parent says >%s<\n", buffer);

    for(int i = 10; i > 0; i--){
      sleep(1);
      printf("%d\n", i);
      fflush(stdout);
    }

    /* Escribimos :*/
    assert(0 < write(socket_vector[0], MSGC1, sizeof(MSGC1)));
    assert(0 < write(socket_vector[0], MSGC2, sizeof(MSGC2)));


    /* Termina todo bien :D! */
    printf("Child: Bye!\n");
    close(socket_vector[0]);
    exit(EXIT_SUCCESS);

    /* A ; B | j = printf("Asignando a J") , 25 ; */

  default: /* Parent: I/O en socket_vector[1] */
    printf("Parent: Hi!\n");
    /* Cerramos el endpoint de Child */
    close(socket_vector[0]);
    /**********************/

    /* Parent escribe */
    assert( 0 < write( socket_vector[1] , MSGP , sizeof(MSGP)));

    /* Lectura 1 */
    assert(0 < read(socket_vector[1], buffer, BUFFER));
    printf("Parent: Child says >%s<\n", buffer);

    /* Lectura 2 */
    assert(0 < read(socket_vector[1], buffer, BUFFER));
    printf("Parent: Child says >%s<\n", buffer);

    /* Termina todo bien :D! */
    printf("Parent: Bye!\n");
    close(socket_vector[1]);
    exit(EXIT_SUCCESS);
  }

  /* Código Muerto */
  return (EXIT_FAILURE);
}
