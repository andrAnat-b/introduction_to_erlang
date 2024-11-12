-module(utils_p08).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([compress/1]).

% * (compress '(a a a a b c c a a d e e e e))
% (A B C A D E)

compress(List) -> compress(List, []).

compress([], Acc) -> reverse(Acc);
compress([H | T], [H | _] = Acc) -> compress(T, Acc);
compress([H | T], Acc) -> compress(T, [H | Acc]).