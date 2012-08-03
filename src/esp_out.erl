%% Author: wave
%% Created: 2012-8-3
%% Description: TODO: Add description to esp_out
-module(esp_out).

-export([init/0,
		 write/1,
		 get_binary/0]).

init() ->
	put(esp_out_context,[]).


write(Context) ->
	Old = get(esp_out_context),
	put(esp_out_context,lists:concat([Old,Context])).


get_binary() ->
	Context = get(esp_out_context),
	list_to_binary(Context).