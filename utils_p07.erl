-module(utils_p07).
-author("vkykalo").
-export([flatten/1]).

flatten([]) -> [];
flatten([[H | T1] | T2]) -> flatten([H | T1] ++ flatten(T2));
flatten([H | T]) -> [H | flatten(T)].

%% перепишіть через хвостову рекурсію.