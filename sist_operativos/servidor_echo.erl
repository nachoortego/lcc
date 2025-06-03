-module(servidor_echo).
-define(Puerto, 4322).

-export([start/0, receptor/1, echo/1]).

start() -> 
    {ok, Socket} = gen_tcp:listen(?Puerto, [binary, {active, false}]),
    spawn(?MODULE, receptor, [Socket]).

receptor(Socket) -> 
    case gen_tcp:accept(Socket) of
        {ok, CSocket} -> spawn(?MODULE, echo, [CSocket]);
        {error, _} -> error
    end,
    receptor(Socket).

echo(Socket) -> 
    case gen_tcp:recv(Socket, 0) of
        {ok, Paquete} -> io:format("Servidor recibe ~p, ~n", [Paquete]),
            gen_tcp:send(Socket, Paquete),
            echo(Socket);
        {error, closed} -> io:format("El cliente cerro la conexion ~n")
    end.
