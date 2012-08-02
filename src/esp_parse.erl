%% Author: wave
%% Created: 2012-7-26
%% Description: TODO: Add description to esp_parse
-module(esp_parse).

-ifdef(TEST).
-compile(export_all).
-endif.
-include("esp.hrl").

load(FilePath) ->
	case file:read_file(FilePath) of
		{ok,Bin} ->
			ok;
		{error,E} ->
			error_logger:error_msg("~p -- read file:~p error with reason:~p",[?MODULE,
																			  FilePath,
																			  E])
	end.

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

loop_parse(<<H1:8,H2:8,Bin/binary>>,{_Flag,L},Q) when H1 == $< ,H2 =/= $@->
	loop_parse(Bin,{_Flag,[H2,H1,L]},Q);
loop_parse(<<H1:8,H2:8,Bin/binary>>,{_Flag,L},Q) when H1 == $@ ,H2 =/= $>->
	loop_parse(Bin,{_Flag,[H2,H1,L]},Q);


loop_parse(<<H1:8,Bin/binary>>,{dynamic,L},Q) ->
	loop_parse(Bin,{dynamic,[H1|L]},Q);
loop_parse(<<H1:8,Bin/binary>>,{static,L},Q) ->
	loop_parse(Bin,{static,[H1|L]},Q).


write_header(FileName) ->
	BaseName = filename:basename(FileName, ".esp"),
	Mod = BaseName ++ "_esp",
	Header = "-module(" ++ Mod ++ ")." ++ ?ESP_DOUBLE_CRLF_L
			 ++ "-export(["main/0])." ++ ?ESP_DOUBLE_CRLF_L
			 ++ "main() ->" ++ ?ESP_DOUBLE_CRLF_L,
   
	
write_body(Q,IsOdd,Context) when IsOdd->
	case queue:out(Q) of
		{empty,_} ->
			ok;
		{{value,V},Q1} ->
			L = lists:concat([Context,"\t","lists:concat([",V,?ESP_DOUBLE_CRLF_L,"]),"]),
			write_body(Q1,!IsOdd,L)
	end;	

write_body(Q,IsOdd,C) when IsOdd->
	case queue:out(Q) of
		{empty,_} ->
			ok;
		{{value,V},Q1} ->
			L = lists:concat(["\t","lists:concat([",V,?ESP_DOUBLE_CRLF_L,"]),"]),
			write_body(Q1,!IsOdd,L)
	end;	
	
write_temp(Q,FileName) ->
	case queue:out(Q) of
		{empty,_} ->
			ok;
		{{value,V},Q1} ->
			case file:write_file(FileName,list_to_binary(V),[append,binary]) of
				ok ->
					write_temp(Q1,FileName);
				{error,R} ->
					error_logger:info_msg(">>>>>>>line:~p,:~p", [?LINE,R])
			end
	end.
	

	


