% Ej. 8 (Servidor de Turnos). Reimplemente el servidor de tickets de la Practica 2 en Erlang. Puede usar el siguiente esqueleto para manejar conexiones TCP en Erlang. El mismo acepta conexiones TCP en modo activo, haciendo que el proceso que realizar el accept de una conexion reciba mensajes con los datos recibidos por la misma. Tambien puede usar el modo pasivo si ası lo desea, cambiando las opciones pasadas a listen. Asegurese tambien de que el servidor es robusto: debe manejar correctamente conexiones cerradas por el cliente y tambien tener en cuenta que los pedidos pueden llegar fragmentados o “pegados” (TCP no tiene concepto de mensaje ni de “borde”), entre otras cosas.

-module(turnos). 
-export([server/0]).

server() ->
    {ok, ListenSocket} = gen_tcp:listen(8080, [{reuseaddr, true}]),
    CounterPid = spawn(fun() -> handle_count(0) end),
    register(count, CounterPid),
    wait_connect(ListenSocket, 0).

handle_count(N) ->
    receive
        {ok, Pid} -> Pid ! {ok, N}
    end,
    handle_count(N+1).

wait_connect(ListenSocket, N) ->
    {ok, _S} = gen_tcp:accept(ListenSocket),
    spawn (fun () -> wait_connect (ListenSocket, N+1) end),
    get_request().

get_request() ->
    io:fwrite("Esperando mensajes...~n", []),
    receive
        {tcp, _S, "NUEVO\n"} -> 
            count ! {ok, self()},
            receive
                {ok, Num} -> io:fwrite("~p~n", [Num])
            end,
            get_request();
            
        {tcp, _S, "CHAU\n"} -> 
            io:fwrite("Conexion terminada~n", []);

        X -> 
            io:fwrite("Invalid request: ~p~n", [X]),
            get_request()
    end.
