#ifndef __STATS_H
#define __STATS_H 1

struct stats {
	long n_get;
	long n_put;
	long n_del;
	long n_take;
	long n_req;
	long n_ev;
};

extern struct stats *_STATS;

#endif
