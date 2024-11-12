-module(utils_p04).
-author("vkykalo").
-export([length_of/1]).

length_of(List) -> length_of(List, 0).

length_of([], Acc) -> Acc;
length_of([_ | T], Acc) -> length_of(T, Acc + 1).