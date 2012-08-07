%% Author: wave
%% Created: 2012-8-2
%% Description: TODO: Add description to esp_parse_SUITE
-module(esp_parse_SUITE).

-compile(export_all).

all() ->[
		 parse_test,
		 is_pre_keyword_test,
		 is_aft_keyword_test
		 ].
	
txt() ->
	<<"abc<@ D=12345@>serial:<@=D@>;author:<lino.chao@gmail.com>">>.

	

parse_test(_) ->
	{ok,Q} = esp_parse:loop_parse(txt()),
	{ok,";author:<lino.chao@gmail.com>=Dserial: D=12345abc"} = loop(Q,[]),
	ok.



is_pre_keyword_test(_) ->
	Temp1 = "end,\n\tlists:foreach(FILL,lists:seq(1,12))\n\t",
	Temp2 = "   end.",
	Temp3 = "  \r\n end ",
	Temp4 = "   end=end",
	true = esp_parse:is_pre_keyword(Temp1),
	true = esp_parse:is_pre_keyword(Temp2),
	true = esp_parse:is_pre_keyword(Temp3),
	false = esp_parse:is_pre_keyword(Temp4),
	ok.

is_aft_keyword_test(_) ->
	Temp1 = "   -> \r\n",
	Temp2 = "   ->",
	Temp3 = "-> \r\n",
	Temp4 = "  )-> ",
	Temp5 = "  )-> a",
	true = esp_parse:is_aft_keyword(Temp1),
	true = esp_parse:is_aft_keyword(Temp2),
	true = esp_parse:is_aft_keyword(Temp3),
	true = esp_parse:is_aft_keyword(Temp4),
	false = esp_parse:is_aft_keyword(Temp5),
	ok.	
							 
loop(Q,L) ->
	case queue:out(Q) of
		{empty,_} ->
			{ok,L};
		{{value,V},Q2} ->
			loop(Q2,lists:concat([V,L]))
	end.