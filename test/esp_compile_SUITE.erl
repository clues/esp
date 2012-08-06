%% Author: wave
%% Created: 2012-8-6
%% Description: TODO: Add description to esp_compile_SUITE
-module(esp_compile_SUITE).

-compile(export_all).

all() ->[
		 compile_src_list_test,
		 compile_test].


compile_src_list_test(_) ->
	Temp = "-module(test).\r\n-export([]).",
	OutDir = "srctmp01",
	case filelib:is_file("srctmp01/test.beam") of
		true ->
			ok = file:delete("srctmp01/test.beam");
		false ->
			ok
	end,
	ok = file:write_file("test.erl", list_to_binary(Temp)),
	file:make_dir(OutDir),
	L1 = esp_compile:compile_src_list([filename:absname("test.erl")],OutDir),
	1 = length(find_file(OutDir,".beam")),
	ok.




compile_test(_) ->
	Temp = "<html><body>pwd:<@=file:get_cwd()@></body></html>",
	OutDir = "srctmp01",
	file:make_dir(OutDir),
	file:delete(OutDir ++ "/test.beam"),
	file:delete("test.erl"),
	
	ok = file:write_file("test.esp", list_to_binary(Temp)),
	L = esp_compile:compile("./",OutDir),
	1 = length(find_file(OutDir,".beam")),
	ok.



find_file(Dir,Ext) ->
	{ok,List} =file:list_dir(Dir),
	lists:foldl(fun(X,AccIn) ->
						case filename:extension(X) of
							Ext ->
								[X|AccIn];
							_ ->
								AccIn
						end
				end, [], List).


