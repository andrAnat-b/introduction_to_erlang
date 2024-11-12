-module(utils_p01).
-author("vkykalo").
-export([last_element/1]).

last_element([H]) -> H;
last_element([_ | T]) -> last_element(T).