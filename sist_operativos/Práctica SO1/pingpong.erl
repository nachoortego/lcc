% Ping
-module(pingpong).
-export([play/0,pong/0,ping/0,ping_aux/1,pong_aux/0]).

pong_aux() ->
    process_flag(trap_exit, true),
    pong().


pong() ->
    receive 
        {0 , PidPing } ->
            io: fwrite("Final pong! ~n"),
            PidPing ! {fin, self()},
            pongok;
        {N, PidPing} -> 
            io:fwrite("Pong! Recv: ~p ~n", [N]),
            PidPing ! {(N-1), self()}, 
            pong();
        {'EXIT', _From, _Reason} -> PidPing = spawn(pingpong, ping_aux, [self()]),
                                    PidPing ! {10, self() },
                                    pong()
    end.

ping_aux(PidPong) ->
    link(PidPong),
    ping().

% Ping
ping() ->
    receive 
        {fin , _PidPong } ->
        io: fwrite("Final ping! ~n"),
        pingok;
        {3, _PidPong} -> error(lala);
        {N, PidPong} -> 
            io: fwrite("Ping!"),
            PidPong ! {N, self()}, %self() returns the pid of the calling processes
            ping()
    end.


play() ->
    PidPong = spawn(pingpong, pong_aux, []),
    io:format("Pid de Pong: ~p ~n",[PidPong]),
    PidPing = spawn(pingpong, ping_aux, [PidPong]),
    PidPong ! {10, PidPing },
    playok.