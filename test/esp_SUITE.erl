%% Author: wave
%% Created: 2012-7-26
%% Description: TODO: Add description to esp_SUITE
-module(esp_SUITE).

-compile(export_all).

all() ->
	[fliter_test].

mytest(_) ->
	ok.


fliter_test(_) ->
	{ok,["my.esp"]} = esp:fliter(["my.esp","hello.erl","hitle.tt"],[]),
	ok.