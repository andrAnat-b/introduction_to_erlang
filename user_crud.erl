-module(user_crud).
-export([start/0, stop/0, create_user/2, read_user/1, update_user/3, delete_user/1, read_all/0, save/1, load/1]).

start() ->
    ets:new(user_entity, [named_table, {keypos, 1}, public]),
    ets:new(id_counter, [named_table, {keypos, 1}, public]),
    
    ets:insert(id_counter, {user_id, 1}).

stop() ->
    ets:delete(user_entity),
    ets:delete(id_counter).

create_user(Name, Phone) ->
    NewId = next_user_id(),
    ets:insert(user_entity, {NewId, Name, Phone, 0}),
    {NewId, Name, Phone, 0}.

next_user_id() ->
    case ets:lookup(id_counter, user_id) of
        [{user_id, CurrentId}] ->
            NewId = CurrentId + 1,
            ets:insert(id_counter, {user_id, NewId}),
            NewId;
        [] ->
            ets:insert(id_counter, {user_id, 2}),
            1
    end.

read_user(Id) ->
    case ets:lookup(user_entity, Id) of
        [{Id, Name, Phone, ViewedTimes}] ->
            UpdatedViewedTimes = ViewedTimes + 1,
            ets:insert(user_entity, {Id, Name, Phone, UpdatedViewedTimes}),
            {Id, Name, Phone, UpdatedViewedTimes};
        [] ->
            {error, not_found}
    end.

read_all() ->
    Users = ets:tab2list(user_entity),
    [{Id, Name, Phone, UpdatedViewedTimes} || {Id, Name, Phone, _} <- Users, UpdatedViewedTimes = next_id_counter(Id)].

next_id_counter(Id) ->
    case ets:lookup(user_entity, Id) of
        [{Id, Name, Phone, ViewedTimes}] ->
            NewViewedTimes = ViewedTimes + 1,
            ets:insert(user_entity, {Id, Name, Phone, NewViewedTimes}),
            NewViewedTimes;
        [] ->
            0
    end.

update_user(Id, Name, Phone) ->
    case ets:lookup(user_entity, Id) of
        [{Id, _, _, _}] ->
            ets:insert(user_entity, {Id, Name, Phone, 0}),
            {Id, Name, Phone, 0};
        [] ->
            {error, not_found}
    end.

delete_user(Id) ->
    case ets:lookup(user_entity, Id) of
        [{Id, Name, Phone, ViewedTimes}] ->
            ets:delete(user_entity, Id),
            {Id, Name, Phone, ViewedTimes};
        [] ->
            {error, not_found}
    end.

save(Filename) ->
    Data = #{user_entity => ets:tab2list(user_entity), id_counter => ets:tab2list(id_counter)},
    file:write_file(Filename, term_to_binary(Data)).

load(Filename) ->
    case file:read_file(Filename) of
        {ok, Binary} ->
            Data = binary_to_term(Binary),
            
            stop(),
            start(),
            
            lists:foreach(fun({K, V}) -> ets:insert(user_entity, {K, V}) end, maps:get(user_entity, Data)),
            lists:foreach(fun({K, V}) -> ets:insert(id_counter, {K, V}) end, maps:get(id_counter, Data)),
            
            ok;
        {error, Reason} ->
            {error, Reason}
    end.
