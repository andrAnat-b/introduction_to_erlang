-module(utils_p02).
-author("vkykalo").
-export([penultimate_element/1]).

penultimate_element([X, _]) -> X;
penultimate_element([_ | T]) -> penultimate_element(T).
