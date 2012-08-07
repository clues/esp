%%% -------------------------------------------------------------------
%%% Author  : wave
%%% Description :
%%%
%%% Created : 2012-8-2
%%% -------------------------------------------------------------------
-module(esp_server).

-include_lib("kernel/include/file.hrl").
-behaviour(gen_server).

-ifdef(TEST).
-compile(export_all).
-endif.

-export([start_link/0,
		 start_link/1,
		 get_state/0,
		 request/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {src_root,dest_root}).



start_link() ->
	{ok,SrcPath} = application:get_env(esp, src_path),
	{ok,DestPath} = application:get_env(esp, dest_path),
	start_link({SrcPath,DestPath}).
start_link({SrcPath,DestPath}) ->
	gen_server:start_link({local,?MODULE},?MODULE, [{SrcPath,DestPath}], []).

get_state() ->
	gen_server:call(?MODULE, get_state).

%% "/sc/service/example.esp"
%% "sc/service/example.esp"
request([H|ReqEsp]) when H == $/->
	request(ReqEsp);
request(ReqEsp) ->
	{ok,#state{src_root=SR,dest_root=DR}} = get_state(),
	EspRealPath = filename:absname(ReqEsp, SR),
	case filename:extension(EspRealPath) of
		".esp" ->
			gen_server:call(?MODULE, {request,ReqEsp});
		_ ->
			error_logger:error_msg("~p -- request:~p not esp file!",[?MODULE,ReqEsp]),
			{error,unesp}
	end.


init([{SrcPath,DestPath}]) ->
	error_logger:info_msg("~p -- init esp set srcpath:~p,destpath:~p ",[?MODULE,SrcPath,DestPath]),
    {ok, #state{src_root=SrcPath,dest_root=DestPath}}.


handle_call(get_state, From, State) ->
    {reply, {ok,State}, State};

handle_call({request,ReqEsp}, From, #state{src_root=SR,dest_root=DR} =State) ->
	EspRealPath = filename:absname(ReqEsp, SR),
	
	BeamRealPath = case filename:dirname(ReqEsp) of
					   "." ->
						   filename:absname(filename:basename(ReqEsp,".esp") ++
										"_esp.beam",DR);
					   _ ->
						   filename:absname(filename:dirname(ReqEsp) ++ 
												filename:basename(ReqEsp,".esp") ++
										"_esp.beam",DR)
				   end,
	Reply = case filelib:is_file(EspRealPath) of
		false ->
			error_logger:error_msg("~p -- request:~p not exist!",[?MODULE,ReqEsp]),
			{error,noexist};
		true ->
			recompile(EspRealPath,BeamRealPath)
	end,
    {reply, Reply, State};

handle_call(Request, From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(Msg, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    {noreply, State}.


terminate(Reason, State) ->
    ok.


code_change(OldVsn, State, Extra) ->
    {ok, State}.



recompile(SrcFile,BeamFile) ->
	case filelib:is_file(BeamFile) of
		false ->
			esp_compile:compile_esp(SrcFile, filename:dirname(BeamFile));
		true ->
			#file_info{mtime=Mtime} = file:read_file_info(SrcFile),
			#file_info{ctime=Ctime} = file:read_file_info(BeamFile),
			if
				Mtime > Ctime ->
					esp_compile:compile_esp(SrcFile, filename:dirname(BeamFile));
				true ->
					{ok,list_to_atom(filename:basename(BeamFile, ".beam"))}
			end
	end.



