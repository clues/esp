%% Author: wave
%% Created: 2012-8-2
%% Description: TODO: Add description to esp_parse_SUITE
-module(esp_parse_SUITE).

-compile(export_all).

all() ->[parse_test].
	
txt() ->
	<<"<@=a@>abc<@ D=lists:seq(1, 5)@>txt4<5,lino.chao@gmail.com>">>.



atculy() ->
	[49,44,113,40,115,101,115,58,115,116,108,105,68,61,64,32,99,60,97,98,53,32].	

parse_test(_) ->
	{ok,Q} = esp_parse:loop_parse(txt()),
	esp_parse:write_temp(Q,"/tmp/mmm.erl"),
%% 	loop(Q),
	ok.


							 
loop(Q) ->
	case queue:out(Q) of
		{empty,_} ->
			ok;
		{{value,V},Q2} ->
			error_logger:info_msg("mmmmm:~p~n", [V]),
			loop(Q2)
	end.