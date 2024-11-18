-module(utils_p03).
-author("vkykalo").
-export([element_at/2]).

element_at([H | _], 1) -> H;

element_at([_ | T], Index) -> element_at(T, Index - 1).