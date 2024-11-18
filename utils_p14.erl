-module(utils_p14).
-author("vkykalo").
-export([dupli/1]).

% * (dupli '(a b c c d))
% (A A B B C C C C D D)

dupli([]) -> [];
dupli([H | T]) -> [H, H] ++ dupli(T). %% нехвостова рекурсія
