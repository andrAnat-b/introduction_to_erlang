-module(utils_p15).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([repli/2]).

repli(List, Count) -> repli(List, Count, []).

repli([], _, Acc) -> reverse(Acc);

repli([H | T], Count, Acc) -> repli(T, Count, multi(H, Count, Acc)).

multi(_, 0, Acc) -> Acc;
multi(H, Count, Acc) -> multi(H, Count - 1, [H | Acc]).