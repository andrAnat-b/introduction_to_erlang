-module(utils_p09).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([pack/1]).

% * (pack '(a a a a b c c a a d e e e e))
% ((A A A A) (B) (C C) (A A) (D) (E E E E))

pack(List) -> pack(List, [], []).


pack([], [], Acc) -> reverse(Acc);

pack([], CurrentAcc, Acc) -> reverse([CurrentAcc | Acc]);

pack([H | T], [H | _] = CurrentAcc, Acc) -> pack(T, [H | CurrentAcc], Acc);

pack([H | T], [], Acc) -> pack(T, [H], Acc); % [[],[1,1,1,1],[3,3],[4],[5],[6,6,6]] exclude empty list

pack([H | T], CurrentAcc, Acc) -> pack(T, [H], [CurrentAcc | Acc]).

%% подумайте як обійтись лише одним акумулятором