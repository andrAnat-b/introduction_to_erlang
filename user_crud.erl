-module(user_crud).
-export([start/0, stop/0, create_user/2, read_user/1, update_user/3, delete_user/1, read_users/0, save/1, load/1]).

start() ->
    stop(),
    
    ets:new(user, [named_table, {keypos, 1}, public]),
    ets:new(view_counter, [named_table, {keypos, 1}, public]),
    ets:new(id_counter, [named_table, {keypos, 1}, public]),
    
    ets:insert(id_counter, {user_id, 1}).

stop() ->
    ets:delete(user),
    ets:delete(view_counter),
    ets:delete(id_counter).

save(FileName) ->
    Data = #{
        user => ets:tab2list(user),
        view_counter => ets:tab2list(view_counter),
        id_counter => ets:tab2list(id_counter)
    },
    file:write_file(FileName, term_to_binary(Data)).

load(FileName) ->
    case file:read_file(FileName) of
        {ok, Binary} ->
            Data = binary_to_term(Binary),
            
            stop(),
            
            ets:new(user, [named_table, {keypos, 1}, public]),
            ets:new(view_counter, [named_table, {keypos, 1}, public]),
            ets:new(id_counter, [named_table, {keypos, 1}, public]),
            
            lists:foreach(fun({K, V}) -> ets:insert(user, {K, V}) end, maps:get(user, Data)),
            lists:foreach(fun({K, V}) -> ets:insert(view_counter, {K, V}) end, maps:get(view_counter, Data)),
            lists:foreach(fun({K, V}) -> ets:insert(id_counter, {K, V}) end, maps:get(id_counter, Data)),
            
            ok;
        {error, Reason} ->
            {error, Reason}
    end.

create_user(Name, Phone) ->
    Id = next_user_id(),
    
    ets:insert(user, {Id, Name, Phone}),
    ets:insert(view_counter, {Id, 0}),
    
    {Id, Name, Phone, 0}.

read_user(Id) ->
    case ets:lookup(user, Id) of
        [{Id, Name, Phone}] ->
            case ets:lookup(view_counter, Id) of
                [{Id, ViewedTimes}] ->
                    UpdatedViewedTimes = ViewedTimes + 1,
                    ets:insert(view_counter, {Id, UpdatedViewedTimes}),
                    {Id, Name, Phone, UpdatedViewedTimes};
                [] ->
                    {error, view_counter_not_found}
            end;
        [] ->
            {error, not_found}
    end.

read_users() ->
    Users = ets:tab2list(user),
    [{Id, Name, Phone, UpdatedViewedTimes} || 
        {Id, Name, Phone} <- Users,
        UpdatedViewedTimes = next_view_counter(Id)].

update_user(Id, Name, Phone) ->
    case ets:lookup(user, Id) of
        [{Id, _, _}] ->
            
            ets:insert(user, {Id, Name, Phone}),
            ets:insert(view_counter, {Id, 0}),
            
            {Id, Name, Phone, 0};
        [] ->
            {error, not_found}
    end.

delete_user(Id) ->
    case ets:lookup(user, Id) of
        [{Id, Name, Phone}] ->
            ets:delete(user, Id),
            ets:delete(view_counter, Id),
            {Id, Name, Phone, 0};
        [] ->
            {error, not_found}
    end.

next_view_counter(Id) ->
    case ets:lookup(view_counter, Id) of
        [{Id, ViewedTimes}] ->
            UpdatedViewedTimes = ViewedTimes + 1,
            ets:insert(view_counter, {Id, UpdatedViewedTimes}),
            UpdatedViewedTimes;
        [] ->
            ets:insert(view_counter, {Id, 1}),
            1
    end.

next_user_id() ->
    case ets:lookup(id_counter, user_id) of
        [{user_id, CurrentId}] ->
            NewId = CurrentId + 1,
            ets:insert(id_counter, {user_id, NewId}),
            CurrentId;
        [] ->
            ets:insert(id_counter, {user_id, 2}),
            1
    end.