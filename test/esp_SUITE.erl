%% Author: wave
%% Created: 2012-7-26
%% Description: TODO: Add description to esp_SUITE
-module(esp_SUITE).

-include_lib("kernel/include/file.hrl").
-compile(export_all).

all() ->
	[mytest].

mytest(_) ->
	ok.


