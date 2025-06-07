#ifndef __LL_H
#define __LL_H 1

#include <stddef.h> /* offsetof */

struct list {
	struct list *next, *prev;
};

#define LIST_INIT(n) { .next = &(n), .prev = &(n) }

#define list_for_each(pos, head)					\
	for (pos = (head)->next; pos != (head); pos = pos->next)

#define list_for_each_safe(pos, swap, head)				\
	for (pos = (head)->next; pos != (head) && ({ swap = pos->next; 1; }); pos = swap)

#define list_for_each_back(pos, head)					\
	for (pos = (head)->prev; pos != (head); pos = pos->prev)

#define list_for_each_back_safe(pos, swap, head)			\
	for (pos = (head)->prev; pos != (head) && ({ swap = pos->prev; 1; }); pos = swap)

#define list_entry(ptr, type, member)	({				\
		void *__mptr = (ptr);					\
		((type *)(__mptr - offsetof(type, member)));		\
	})

void list_init(struct list *head);
void list_add_head(struct list *head, struct list *node);
void list_add_tail(struct list *head, struct list *node);
void list_unlink(struct list *node);

#endif
