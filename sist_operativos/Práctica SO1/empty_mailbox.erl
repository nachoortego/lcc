-module(empty_mailbox).
-export([empty_mailbox/0]).

empty_mailbox() ->
    receive
        _Msg -> empty_mailbox()
    after
        0 -> ok
    end.