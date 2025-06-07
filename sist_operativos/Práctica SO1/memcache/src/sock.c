#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include "common.h"

int mk_tcp_sock(in_port_t port)
{
	int s, rc;
	struct sockaddr_in sa;
	int yes = 1;

	s = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
	if (s < 0)
		quit("socket");

	rc = setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes);
	if (rc != 0)
		quit("setsockopt");

	sa.sin_family = AF_INET;
	sa.sin_port = htons(port);
	sa.sin_addr.s_addr = htonl(INADDR_ANY);

	rc = bind(s, (void*)&sa, sizeof sa);
	if (rc < 0)
		quit("bind");

	rc = listen(s, 10);
	if (rc < 0)
		quit("listen");

	return s;
}
