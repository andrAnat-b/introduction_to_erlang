-module(utils_p01).
-author("vkykalo").
-export([get_last_element/1]).

get_last_element([H]) -> H;
get_last_element([_ | H]) -> get_last_element(H).