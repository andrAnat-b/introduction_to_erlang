-module(utils_p11).
-author("vkykalo").
-import(utils_p10, [encode/1]).

-export([encode_modified/1]).

% * (encode-modified '(a a a a b c c a a d e e e e))
% ((4 A) B (2 C) (2 A) D (4 E))

encode_modified(List) ->
    EncodedList = encode(List),
    modify_encoded(EncodedList).

modify_encoded([]) -> [];

modify_encoded([[1, T] | Rest]) -> [T | modify_encoded(Rest)];
modify_encoded([[H, T] | Rest]) -> [[H, T] | modify_encoded(Rest)].
