#define _GNU_SOURCE /* strchrnul */

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "common.h"
#include "kv.h"
#include "stats.h"

static int text_put(int klen, char *k, int vlen, char *v)
{
	char *kk, *vv;

	kk = memdup(k, klen);
	if (!kk)
		return -1;

	vv = memdup(v, vlen);
	if (!vv) {
		free(kk);
		return -1;
	}

	return kv_add(klen, kk, vlen, vv);
}

static char * text_stats(struct eventloop_data *evd)
{
	char buf[500];

#define AGG(field)	({						\
		long r = 0;						\
		for (int i = 0; i < evd->n_proc; i++)			\
			r += _STATS[i].field;				\
		r; })

	sprintf(buf, "GETS=%li PUTS=%li DELS=%li REQ=%li NEV=%li KEYS=%li",
			AGG(n_get), AGG(n_put), AGG(n_del),
			AGG(n_req), AGG(n_ev), kv_keys());

	return strdup(buf);
}

/* La parte más horrible... el parseo */
void text_handle1(struct eventloop_data *evd, struct cinfo *ci, char *buf, int len)
{
	char *toks[10];
	int lens[10];
	int ntok;

	log(3, "handle1(%s)", buf);

	/* Separar tokens */
	{
		char *p = buf;
		ntok = 0;
		toks[ntok++] = p;
		while (ntok < 10 && (p = strchrnul(p, ' ')) && *p) {
			/* Longitud token anterior */
			lens[ntok-1] = p - toks[ntok-1];

			*p++ = 0;

			/* Comienzo nueva token */
			toks[ntok++] = p;
		}
		lens[ntok-1] = p - toks[ntok-1];
	}

	log(3, "checking '%s', ntok = %i", toks[0], ntok);

	if (!strcmp(toks[0], "PUT") && ntok == 3) {
		_STATS[evd->id].n_put++;
		_STATS[evd->id].n_req++;
		int rc = text_put(lens[1], toks[1], lens[2], toks[2]);
		if (rc < 0)
			cwrite(ci, "EUNK\n", 5);
		else
			cwrite(ci, "OK\n", 3);
	} else if (!strcmp(toks[0], "GET") && ntok == 2) {
		_STATS[evd->id].n_get++;
		_STATS[evd->id].n_req++;
		log(3, "lookup (%s)", toks[1]);
		struct kv *kv = kv_lookup(lens[1], toks[1]);
		if (kv) {
			log(3, "found");
			cwrite(ci, "OK ", 3);
			cwrite(ci, kv->v, kv->vlen);
			cwrite(ci, "\n", 1);
			kv_release(kv);
		
		} else {
			log(3, "NOT found");
			//TODO:reemplazar por error_str
			cwrite(ci, "ENOTFOUND\n", 10);
		}
	}  else if (!strcmp(toks[0], "DEL") && ntok == 2) {
		_STATS[evd->id].n_del++;
		_STATS[evd->id].n_req++;
		log(3, "del(%s)", toks[1]);
		int rc = kv_remove(lens[1], toks[1]);
		if (rc)
			cwrite(ci, "OK\n", 3);
		else
			cwrite(ci, "ENOTFOUND\n", 10);
	} else if (!strcmp(toks[0], "CLEAR") && ntok == 1) {
		kv_clear_all();
		cwrite(ci, "OK\n", 3);
	} else if (!strcmp(toks[0], "STATS") && ntok == 1) {
		char * reply = text_stats(evd);
		if (!reply) {
			cwrite(ci, "EOOM\n", 5);
		} else {
			cwrite(ci, "OK ", 3);
			cwrite(ci, reply, strlen(reply));
			cwrite(ci, "\n", 1);
			free(reply);
		}
	} else if (!strcmp(toks[0], "OFF") && ntok == 1) {
		kv_finish();
		exit(0);
	} else {
		cwrite(ci, "EINVAL\n", 7);
	}
}

static inline void cwritecode(struct cinfo *ci, int code)
{
	cwrite(ci, &code, 1);
}

static void cwritevar(struct cinfo *ci, int len, void *arg)
{
	int l = htonl(len);
	cwrite(ci, &l, 4);
	cwrite(ci, arg, len);
}


