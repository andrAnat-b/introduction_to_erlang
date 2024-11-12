-module(utils_p03).
-author("vkykalo").
-export([element_at/2]).

element_at(List, Index) -> element_at(List, Index, 1).

element_at([H | _], Index, Index) -> H;
element_at([_ | T], Index, Acc) -> element_at(T, Index, Acc + 1).