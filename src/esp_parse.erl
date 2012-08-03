%% Author: wave
%% Created: 2012-7-26
%% Description: TODO: Add description to esp_parse
-module(esp_parse).


-compile(export_all).
-include("esp.hrl").

loop_parse(Bin) ->
	Q = queue:new(),
	loop_parse(Bin,{static,[]},Q).

loop_parse(<<>>,{_,L},Q) ->
	Q2 = queue:in(lists:reverse(L),Q),
	{ok,Q2};

loop_parse(<<H1:8,H2:8,Bin/binary>>,{static,L},Q) when H1 == $< ,H2 == $@->
	Q2 = queue:in(lists:reverse(L),Q),
	loop_parse(Bin,{dynamic,[]},Q2);
loop_parse(<<H1:8,H2:8,Bin/binary>>,{dynamic,L},Q) when H1 == $@ ,H2 == $>->
	Q2 = queue:in(lists:reverse(L),Q),
	loop_parse(Bin,{static,[]},Q2);

%% ;author:<lino.chao@gmail.com>
loop_parse(<<H1:8,H2:8,Bin/binary>>,{_Flag,L},Q) when H1 == $< ,H2 =/= $@->
	loop_parse(Bin,{_Flag,[H2,H1|L]},Q);
loop_parse(<<H1:8,H2:8,Bin/binary>>,{_Flag,L},Q) when H1 == $@ ,H2 =/= $>->
	loop_parse(Bin,{_Flag,[H2,H1|L]},Q);


loop_parse(<<H1:8,Bin/binary>>,{dynamic,L},Q) ->
	loop_parse(Bin,{dynamic,[H1|L]},Q);
loop_parse(<<H1:8,Bin/binary>>,{static,L},Q) when H1 == $"->
	loop_parse(Bin,{static,[H1,$\\|L]},Q);
loop_parse(<<H1:8,Bin/binary>>,{static,L},Q) ->
	loop_parse(Bin,{static,[H1|L]},Q).

is_pre_keyword(V) ->
	case re:run(V,"[\s|\r\n]*end[\s|,|\.]",[]) of
		{match,[{0,_}]} ->
			true;
		_ ->
			false
	end.

is_aft_keyword(V) ->
	Len = length(V),
	case re:run(V,"[^s]*->[\s|\r\n]*",[]) of
		{match,[{0,_}]} ->
			true;
		_ ->
			false
	end.

write_header(FileName) ->
	BaseName = filename:basename(FileName, ".esp"),
	Mod = BaseName ++ "_esp",
	L = lists:concat(["-module(", Mod , ")." ,
				   ?ESP_DOUBLE_CRLF_L,
			 	   "-export([main/0]).",
                   ?ESP_DOUBLE_CRLF_L,
			       "main() ->",
                   ?ESP_DOUBLE_CRLF_L,
				   "esp_out:init(),"]),
	{ok,Mod,L}.
   

write_body({empty,_},_,Context) ->
	{ok,Context++?ESP_DOUBLE_CRLF_L++"esp_out:get_binary()."};	
write_body({{value,V},Q},IsOdd,Context) when IsOdd->
	L = lists:concat([Context,?ESP_DOUBLE_CRLF_L,"esp_out:write(\"",V,"\"),"]),
	write_body(queue:out(Q),not IsOdd,L);

write_body({{value,[$=|T]},Q},IsOdd,Context)  ->
	L = lists:concat([Context,?ESP_DOUBLE_CRLF_L,"esp_out:write(",T,"),"]),
	write_body(queue:out(Q),not IsOdd,L);

write_body({{value,V},Q},IsOdd,Context) ->
	NewComtent = case is_pre_keyword(V) of
		true ->
			lists:sublist(Context, length(Context)-1);
		false ->
			Context
		end,
	Nif = case is_aft_keyword(V) of
		true ->
			"";
		false ->
			","
		end,
	L = lists:concat([NewComtent,?ESP_DOUBLE_CRLF_L,V,Nif]),
	write_body(queue:out(Q),not IsOdd,L).		
	
write_temp(Q,FileName) ->
	{ok,Mod,L} = write_header(FileName),
	{ok,C} = write_body(queue:out(Q),true,[]),
	ErlFile = filename:dirname(FileName) ++ "/" ++ Mod ++ ".erl",
	file:write_file(ErlFile, list_to_binary(L++lists:sublist(C, 2, 99999)), [binary]),
	{ok,ErlFile}.


	


