-module(utils_p12).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([decode/1]).


decode(List) -> decode(List, []).

decode([], Acc) -> reverse(Acc);

decode([[Count, Item] | Rest], Acc) -> decode(Rest, multi(Item, Count, Acc));

decode([Item | Rest], Acc) -> decode(Rest, [Item | Acc]).

multi(_, 0, Acc) -> Acc;
multi(Item, Count, Acc) -> multi(Item, Count - 1, [Item | Acc]).
