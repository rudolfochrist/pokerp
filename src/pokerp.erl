-module(pokerp).
-behaviour(gen_server).

-export([start_link/0, participate/4, close_round/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%
%% API

start_link() ->
    gen_server:start_link(?MODULE, [], []).

participate(Pid, ClientPid, Name, Points) ->
    gen_server:call(Pid, {participate, ClientPid, Name, Points}).

close_round(Pid) ->
    gen_server:call(Pid, close_round).

%%
%% Callbacks

init(_) ->
    {ok, {[], []}}.

handle_call({participate, ClientPid, Name, Points}, _From, {ClientPids, State}) ->
    {reply, ok, {[ClientPid | ClientPids], [{Name, Points} | State]}};

handle_call(close_round, _From, {ClientPids, State}) ->
    lists:foreach(fun (ClientPid) -> ClientPid ! State end, ClientPids),
    {reply, ok, {[], []}}.

%%
%% default callbacks

handle_cast(_, State) ->
    {reply, ok, State}.

handle_info(_Info, State) ->
    {reply, ok, State}.

terminate(normal, _State) ->
    ok.

code_change(_, State, _) ->
    {ok, State}.
