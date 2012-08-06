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
		 start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {src_root,dest_root,request_path=""}).



start_link() ->
	start_link({"./","./"}).
start_link({SrcPath,DestPath}) ->
	gen_server:start_link({local,?MODULE},?MODULE, [{SrcPath,DestPath}], []).

request(ReqPath) ->
	gen_server:call(?MODULE, {request,ReqPath}).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([{SrcPath,DestPath}]) ->
    {ok, #state{src_root=SrcPath,dest_root=DestPath}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_call({request,ReqPath}, From, #state{src_root=SR,dest_root=DR} =State) ->
	SrcPath = filename:absname(ReqPath, SR),
	{ok,FileName} = case filelib:is_dir(SrcPath) of
		true ->
			{ok,filename:join(SrcPath, "index.esp")};
		false ->
			{ok,SrcPath}
	end,

	case filelib:is_file(FileName) of
		true ->
			case filename:extension(FileName) of
				".esp" ->
					{FileName,filename:join(DR, filename:basename(FileName)++"_esp.beam")};
				_ ->
					{ok,FileName}
			end;
		false ->
			{error,noexist}
	end,	
	
    Reply = ok,
    {reply, Reply, State};

handle_call(Request, From, State) ->
    Reply = ok,
    {reply, Reply, State};

handle_call(Request, From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(OldVsn, State, Extra) ->
    {ok, State}.


compile({ok,SrcFile},#state{src_root=SR,dest_root=DR} =State) ->
	case filelib:is_file(SrcFile) of
		true ->
			case filename:extension(SrcFile) of
				".esp" ->
					{SrcFile,filename:absname( a,DR)};
				_ ->
					{ok,SrcFile}
			end;
		false ->
			{error,noexist}
	end,
	ok.


recompile(SrcFile,BeamFile) ->
	case filelib:is_file(BeamFile) of
		false ->
			a;
		true ->
			#file_info{mtime=Mtime} = file:read_file_info(SrcFile),
			#file_info{ctime=Ctime} = file:read_file_info(BeamFile),
			if
				Mtime =/= Ctime ->
					a;
				true ->
					{ok,BeamFile}
			end
	end.



