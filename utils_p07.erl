-module(utils_p07).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([flatten/1]).

flatten(List) -> flatten(List, []).

flatten([], Acc) -> reverse(Acc);

flatten([[H | T1] | T2], Acc) -> flatten([H | T1] ++ T2, Acc);

flatten([H | T], Acc) -> flatten(T, [H | Acc]).