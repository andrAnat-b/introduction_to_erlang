-module(utils_p13).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([encode_direct/1]).

encode_direct([]) -> [];
encode_direct([H | T]) -> encode_direct(T, H, 1, []).
encode_direct([], CurrentItem, Repead, Acc) -> reverse(create_result(CurrentItem, Repead, Acc));

encode_direct([H | T], H, CountRepead, Acc) -> encode_direct(T, H, CountRepead + 1, Acc);
encode_direct([H | T], CurrentItem, Repead, Acc) -> encode_direct(T, H, 1, create_result(CurrentItem, Repead, Acc)).

create_result(Item, 1, Acc) -> [Item | Acc];
create_result(Item, Repead, Acc) -> [[Repead, Item] | Acc].
