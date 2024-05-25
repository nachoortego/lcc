typedef struct _DNodo {
    int dato;
    struct _DNodo *ant;
    struct _DNodo *sig;
} DNodo;

typedef DNodo* CDList;

typedef void (*FuncionVisitante) (int dato);

typedef enum {
DLIST_RECORRIDO_HACIA_ADELANTE,
DLIST_RECORRIDO_HACIA_ATRAS
} DListOrdenDeRecorrido;

CDList cdlist_crear();

void cdlist_destruir(CDList lista);

int cdlist_vacia(CDList lista);

CDList cdlist_agregar_final(CDList lista, int dato);

CDList cdlist_agregar_inicio(CDList lista, int dato);

void cdlist_recorrer(CDList lista, FuncionVisitante visit, DListOrdenDeRecorrido orden);