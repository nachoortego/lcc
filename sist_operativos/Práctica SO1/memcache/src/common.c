#include <assert.h>
#include <string.h>
#include <unistd.h>
#include "common.h"

struct mc_config defopts = {
	.maxmem      = 192,
	.nthread     = 0,
	.tablesz     = 1<<20, /* 1 millón de entradas */
};

const char * code_str(enum code e)
{
	switch (e) {
	case PUT:	return "PUT";
	case GET:	return "GET";
	case DEL:	return "DEL";
	case STATS:	return "STATS";

	case OK:	return "OK";
	case EINVALID:	return "EINVALID";
	case ENOTFOUND:	return "ENOTFOUND";
	case EBIG:	return "EBIG";
	case EUNK:	return "EUNK";

	default:
		assert(0);
		return "";
	}
}

int valid_rq(int code)
{
	switch (code) {
	case PUT:
	case GET:
	case DEL:
	case STATS:
		return 1;

	default:
		return 0;
	}
}

void cflush(struct cinfo *ci)
{
	if (ci->olen) {
		write(ci->fd, ci->obuf, ci->olen);
		ci->olen = 0;
	}
}

int cwrite(struct cinfo *ci, void *buf, size_t len)
{
	/* Mejor caso: entra en el buffer, copiar y chau */
	if (ci->olen + len <= sizeof ci->obuf) {
		memcpy(ci->obuf + ci->olen, buf, len);
		ci->olen += len;
		return 0;
	}

	/* Hacer lugar */
	cflush(ci);

	/* Entra? Copiar. */
	if (len <= sizeof ci->obuf) {
		memcpy(ci->obuf, buf, len);
		ci->olen = len;
	} else {
		/* Si no, bueno, escribimos derecho */
		write(ci->fd, ci->obuf, ci->olen);
	}

	return 0;
}
