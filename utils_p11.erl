-module(utils_p11).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-import(utils_p10, [encode/1]).

-export([encode_modified/1]).

% * (encode-modified '(a a a a b c c a a d e e e e))
% ((4 A) B (2 C) (2 A) D (4 E))

encode_modified(List) ->
    EncodedList = encode(List),
    handle(EncodedList,  []).

handle([], Acc) -> reverse(Acc);
handle([[1, T] | Rest], Acc) -> handle(Rest, [T | Acc]);
handle([[N, T] | Rest], Acc) -> handle(Rest, [[N, T] | Acc]).
