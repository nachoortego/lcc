#include <assert.h>
#include <stdlib.h>
#include "ll.h"

void list_init(struct list *head)
{
	head->next = head->prev = head;
}

void list_add_head(struct list *head, struct list *node)
{
	node->next = head->next;
	node->prev = head;
	assert(head->next->prev == head);
	head->next->prev = node;
	head->next = node;
}

void list_add_tail(struct list *head, struct list *node)
{
	node->next = head;
	node->prev = head->prev;
	assert(head->prev->next == head);
	head->prev->next = node;
	head->prev = node;
}

void list_unlink(struct list *node)
{
	struct list *p, *n;
	n = node->next;
	p = node->prev;
	assert(n);
	assert(p);

	n->prev = p;
	p->next = n;

	/* Sólo con algún flag? */
	node->prev = NULL;
	node->next = NULL;
}
