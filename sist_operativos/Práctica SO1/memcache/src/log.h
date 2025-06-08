#ifndef __LOG_H
#define __LOG_H

extern int __loglevel;

void log_f(char *file, int line, char* fstr, ...);

#ifndef NOLOG
 #define log(l, ...)							\
	do {								\
		int __ll = (l);						\
		if (__loglevel > __ll)					\
			log_f(__FILE__, __LINE__, __VA_ARGS__);		\
	} while (0)
#else
 #define log(l, ...)
#endif

#endif
