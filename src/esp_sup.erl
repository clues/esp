
-module(esp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
	error_logger:info_msg("esp_supervisor start ~p~n",[node()]),
	EspSup = {esp_server, 
			  {esp_server, start_link,[]}, 
			  permanent, infinity,supervisor,[esp_server]},	
    {ok, { {one_for_one, 5, 10}, [EspSup]} }.

