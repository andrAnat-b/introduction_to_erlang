-module(utils_p14).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([dupli/1]).

% * (dupli '(a b c c d))
% (A A B B C C C C D D)

dupli(List) -> dupli(List, []).

dupli([], Acc) -> reverse(Acc);
dupli([H | T], Acc) -> dupli(T, [H, H | Acc]).
