%% Author: wave
%% Created: 2012-8-6
%% Description: TODO: Add description to esp_compile
-module(esp_compile).

-ifdef(TEST).
-compile(export_all).
-endif.

-export([compile_esp_dir/0,
		 compile_esp_dir/1,
		 compile_esp_dir/2,
		 
		 compile_esp/1,
		 compile_esp/2,
		 
		 compile_src/1,
		 compile_src/2
		 ]).

%% compile *.esp to *.beam files from SrcDir to DestDir
%% if not fill SrcDir and DestDir will be current path
%% note all temp *.erl will be delete after compile
compile_esp_dir() ->
	compile_esp_dir("./","./").
compile_esp_dir(DestDir) ->
	compile_esp_dir("./",DestDir).
compile_esp_dir(SrcDir,DestDir) ->
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
	lists:foldl(fun(X,AccIn) ->
						[compile_esp(X,DestDir)|AccIn] end, [], EspFiles).

%% compile one esp file to DestDir
compile_esp(EspFile) ->
	compile_esp(EspFile,"./").
compile_esp(EspFile,DestDir) ->
	{ok,ErlFile} = esp_parse:parse(EspFile),
	R = compile_src(ErlFile,DestDir),
	error_logger:info_msg("~p -- compile esp file:~p to outdir:~p", [?MODULE,EspFile,DestDir]),
	file:delete(ErlFile),
	R.

%% compile erl source file out to DestDir
%% DestDir default is current path
compile_src(ErlFile) ->
	compile_src(ErlFile,"./").
compile_src(ErlFile,DestDir) ->
	c:c(ErlFile, [{outdir,filename:absname(DestDir)}]).
