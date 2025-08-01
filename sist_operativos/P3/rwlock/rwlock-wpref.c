#include <semaphore.h>
#include <stdlib.h>

struct rwlock {
  int readers;
  int writers_waiting;
  sem_t mutex;
  sem_t room_empty;     // Exclusión entre lectores y escritores
  sem_t read_try;       // Control de nuevos lectores cuando hay escritores esperando
};

struct rwlock *rwlock_init() {
  struct rwlock *rwl = malloc(sizeof(*rwl));
  rwl->readers = 0;
  rwl->writers_waiting = 0;
  sem_init(&rwl->mutex, 0, 1);
  sem_init(&rwl->room_empty, 0, 1);
  sem_init(&rwl->read_try, 0, 1);
  return rwl;
}

void rwlock_destroy(struct rwlock *rwl) {
  sem_destroy(&rwl->mutex);
  sem_destroy(&rwl->room_empty);
  sem_destroy(&rwl->read_try);
  free(rwl);
}

void lock_r(struct rwlock *rwl) {
  sem_wait(&rwl->read_try);          // Esperar si hay escritores queriendo entrar
  sem_wait(&rwl->mutex);
  rwl->readers++;
  if (rwl->readers == 1)
    sem_wait(&rwl->room_empty);      // Primer lector bloquea a escritores
  sem_post(&rwl->mutex);
  sem_post(&rwl->read_try);          // Dejo pasar a otros lectores
}

void unlock_r(struct rwlock *rwl) {
  sem_wait(&rwl->mutex);
  rwl->readers--;
  if (rwl->readers == 0)
    sem_post(&rwl->room_empty);      // Último lector libera la sala
  sem_post(&rwl->mutex);
}

void lock_w(struct rwlock *rwl) {
  sem_wait(&rwl->mutex);
  rwl->writers_waiting++;
  if (rwl->writers_waiting == 1)
    sem_wait(&rwl->read_try);        // Bloqueo a lectores nuevos
  sem_post(&rwl->mutex);

  sem_wait(&rwl->room_empty);        // Espero hasta que no haya nadie
}

void unlock_w(struct rwlock *rwl) {
  sem_post(&rwl->room_empty);

  sem_wait(&rwl->mutex);
  rwl->writers_waiting--;
  if (rwl->writers_waiting == 0)
    sem_post(&rwl->read_try);        // Permitir lectores nuevos
  sem_post(&rwl->mutex);
}
