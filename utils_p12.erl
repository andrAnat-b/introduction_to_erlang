-module(utils_p12).
-author("vkykalo").

-export([decode/1]).

decode([]) -> [];
decode([[H, T] | Rest]) -> multi(T, H) ++ decode(Rest);  % pair %% нехвостова рекурсія
decode([H | Rest]) -> [H | decode(Rest)].  % single %% нехвостова рекурсія

multi(_, 0) -> [];
multi(H, T) -> [H | multi(H, T - 1)]. %% нехвостова рекурсія
