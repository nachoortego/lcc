
/*
Ej. 6. Considere el problema del jard´ın ornamental en un sistema con un ´unico procesador.
    a) ¿Sigue habiendo un problema? Justifique.
    
    b) Si implementa el algoritmo de Peterson, ¿son necesarias las barreras de memoria?
    
    c) Si el incremento se hace con la instrucci´on incl de x86, ¿hay problema? Puede aprovechar la
        siguiente funci´on:
            static inline void incl(int *p) {
            asm("incl %0" : "+m"(*p) : : "memory");
        }
    
    d) ¿Qu´e pasa con la implementaci´on con incl al tener m´as de un procesador?
    
    e) Repita el experimento con esta versi´on de incl:
    static inline void incl(int *p) {
    asm("lock; incl %0" : "+m"(*p) : : "memory");
    }
*/


//a) sigue habiendo race condition porque el problema no depende de la cantidad de procesardores sino de los threads corriendo al mismo tiempo

//b) con un solo procesador no son necesarias las barreras de memoria porque el mismo procesador tiene acceso a la misma memoria cache, el 1 proesador te garantiza la rquitectura que no va a haber reorganizcion de las ordenes, se ejecutan en el mismo orden que stán escritas, no hay problema de inconsistencia con sigo misma

//los threads no son los hilos del porcesador, son cosa de software, podemos hacer mil millones si queremos

//c) no hay problema porque incl 

//d) al tener mas de un procesador deja de funcionar porque

//e) con lock no tenemos problemas ya que se vuelve atomica la suma de visitantes sin permitir la race condition y llevando al cuenta en orden.




