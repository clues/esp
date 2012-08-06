%% Author: wave
%% Created: 2012-8-6
%% Description: TODO: Add description to esp_compile
-module(esp_compile).

-ifdef(TEST).
-compile(export_all).
-endif.

-export([compile/0,
		 compile/1,
		 compile/2,
		 
		 compile_src_list/1,
		 compile_src_list/2
		 ]).

%% compile *.esp to *.beam files from SrcDir to DestDir
%% if not fill SrcDir and DestDir will be current path
%% note all temp *.erl will be delete after compile
compile() ->
	compile("./","./").
compile(DestDir) ->
	compile("./",DestDir).
compile(SrcDir,DestDir) ->
	{ok,FileList} = file:list_dir(SrcDir),
	Fun = fun(X,AccIn) ->
				  case filename:extension(X) of
					  ".esp" ->
						  [X|AccIn];
					  _ ->
						  AccIn
				  end
		  end,
	EspFiles = lists:foldl(Fun, [], FileList),
	ErlFiles = proplists:get_all_values(ok,lists:foldl(fun(X,AccIn) ->
						[esp_parse:parse(X)|AccIn] end, [], EspFiles)),
	L = compile_src_list(ErlFiles,DestDir),
	lists:foreach(fun(X) ->
						  file:delete(X) end, ErlFiles),
	L.



%% compile erl source files out to DestDir
%% DestDir default is current path
compile_src_list(List) ->
	compile_src_list(List,"./").
compile_src_list(List,DestDir) ->
	Fun = fun(X,AccIn) ->
				  case  c:c(X, [{outdir,filename:absname(DestDir)}]) of
					  {ok,Mod} ->
						  [{ok,Mod}|AccIn];
					  _ ->
						  AccIn
				  end
		  end,
	lists:foldl(Fun, [], List).

