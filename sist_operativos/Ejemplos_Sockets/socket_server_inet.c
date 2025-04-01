// Server side C/C++ program to demonstrate Socket
// programming
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#define PORT 8080
int main(int argc, char const* argv[])
{
  int sock_srv, sock_cli, valread;
  struct sockaddr_in srv_name;
  int opt = 1;
  int addrlen = sizeof(srv_name);
  char buffer[1024] = { 0 };
  char* hello = "Hello from server";

  // Creating socket file descriptor
  if ((sock_srv = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
    perror("socket failed");
    exit(EXIT_FAILURE);
  }

  // Forcefully attaching socket to the port 8080 (to check socket options see man 7 socket)
  if (setsockopt(sock_srv, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
    perror("setsockopt");
    exit(EXIT_FAILURE);
  }
  
  srv_name.sin_family = AF_INET;
  srv_name.sin_addr.s_addr = INADDR_ANY;
  srv_name.sin_port = htons(PORT);

  // Forcefully attaching socket to the port 8080
  if (bind(sock_srv, (struct sockaddr*)&srv_name, sizeof(srv_name)) < 0) {
    perror("bind failed");
    exit(EXIT_FAILURE);
  }
  if (listen(sock_srv, 3) < 0) {
    perror("listen");
    exit(EXIT_FAILURE);
  }
  if ((sock_cli = accept(sock_srv, (struct sockaddr*)&srv_name, (socklen_t*)&addrlen)) < 0) {
    perror("accept");
    exit(EXIT_FAILURE);
  }
  valread = read(sock_cli, buffer, 1024);
  printf("%s\n", buffer);
  send(sock_cli, hello, strlen(hello), 0);
  printf("Hello message sent\n");
  return 0;
}
