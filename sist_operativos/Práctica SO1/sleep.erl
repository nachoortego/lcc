-module(sleep).
-export([sleep/1]).

sleep(N) ->
    receive
        %
    after
        N -> ok
    end.