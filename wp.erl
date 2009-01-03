%% Erlang implementation for http://ptrace.fefe.de/wp/
%% Placed into Public Domain

-module(wp).
-export([wp/1]).

wp([FileName]) ->
    {ok, F} = file:open(FileName, read),
    H = ets:new(wp, [set]),
    proc_file(F, H),
    L = ets:tab2list(H),    
    ets:delete(H),
    [ io:fwrite("~p ~s~n", [Count,  Word]) || {Word, Count} <- lists:reverse(lists:keysort(2, L))],
    init:stop().

proc_file(F, H) ->
    L = io:get_line(F, ''),
    case L of
	eof ->
	    ok;
	_ ->
	    [inc_word(H, list_to_binary(string:strip(W))) || W <- string:tokens(L, [32, 10, 9])],
	    proc_file(F, H)
    end.

inc_word(Hash, Word) ->
    case ets:member(Hash, Word) of
	false ->
	    ets:insert(Hash, {Word, 1});
	true ->
	    ets:update_counter(Hash, Word, 1)
    end.
