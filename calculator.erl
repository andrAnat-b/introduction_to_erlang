-module(calculator).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([init/0, calculate/3]).

calculate(Operator, X, Y) ->
    Result = operation(Operator, X, Y),
    history ! {store, {Operator, X, Y, Result}, self()},

    receive
        {history, UpdatedHistory} -> {Result, UpdatedHistory}
    end.

run() -> loop([]).

loop(History) ->
    receive
        {store, Entry, Owner} ->
            
            NewHistory = [Entry | History],
            TrimmedHistory = lists:sublist(NewHistory, 10),
            Owner ! {history, reverse(TrimmedHistory)},
            loop(TrimmedHistory)
    end.

init() ->
    Pid = spawn(fun run/0),
    register(history, Pid).

operation(plus, X, Y) -> X + Y;
operation(minus, X, Y) -> X - Y;
operation(mul, X, Y) -> X * Y;
operation(divide, X, Y) when Y =/= 0 -> X div Y;
operation(divide, _, 0) -> error;
operation(_, _, _) -> error.
%% another operation can be.