-module(utils_p10).
-author("vkykalo").
-import(utils_p09, [pack/1]).
-import(utils_p04, [length_of/1]).
-export([encode/1]).

% * (encode '(a a a a b c c a a d e e e e))
% ((4 A) (1 B) (2 C) (2 A) (1 D)(4 E))

encode(List) ->
    Packed = pack(List),
    encode_bulk(Packed).

encode_bulk([]) -> [];

encode_bulk([[H | T] | Rest]) ->
    N = length_of([H | T]),
    [[N, H] | encode_bulk(Rest)].
