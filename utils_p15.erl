-module(utils_p15).
-author("vkykalo").
-export([repli/2]).

repli([], _) -> [];
repli([H | T], Count) -> multi(H, Count) ++ repli(T, Count).

multi(_, 0) -> [];
multi(H, T) -> [H | multi(H, T - 1)]. % не хвостова рекурсія