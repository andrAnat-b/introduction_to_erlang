-module(user_crud).
-export([start/0, stop/0, create_user/2, read_user/1, update_user/3, delete_user/1]).

start() ->
    ets:new(user_table, [named_table, {keypos, 1}, public]),
    ets:new(view_counter, [named_table, {keypos, 1}, public]).

stop() ->
    ets:delete(user_table),
    ets:delete(view_counter).

create_user(Name, Phone) ->
    NewId = next_id(user_table),
    ets:insert(user_table, {NewId, Name, Phone}),
    ets:insert(view_counter, {NewId, 0}),
    {NewId, Name, Phone, 0}.

read_user(Id) ->
    case ets:lookup(user_table, Id) of
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

update_user(Id, Name, Phone) ->
    case ets:lookup(user_table, Id) of
        [{Id, _, _}] ->
            ets:insert(user_table, {Id, Name, Phone}),
            ets:insert(view_counter, {Id, 0}),
            {Id, Name, Phone, 0};
        [] ->
            {error, not_found}
    end.

delete_user(Id) ->
    case ets:lookup(user_table, Id) of
        [{Id, Name, Phone}] ->
            ets:delete(user_table, Id),
            ets:delete(view_counter, Id),
            {Id, Name, Phone, 0};
        [] ->
            {error, not_found}
    end.

next_id(Table) ->
    Ids = [Id || {Id, _} <- ets:tab2list(Table)],
    case Ids of
        [] -> 1;
        _ -> lists:max(Ids) + 1
    end.