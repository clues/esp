%% Author: wave
%% Created: 2012-8-3
%% Description: TODO: Add description to esp
-module(esp).


-compile(export_all).


request(SrcDir,DestDir) ->
	put(src_dir,SrcDir),
	put(dest_dir,DestDir),
	{ok,Files} = file:list_dir(get(src_dir)),
	{ok,EspFiles} = fliter(Files,[]),
	compile(EspFiles).

compile([]) ->
	ok;

compile([Esp|T]) ->
	File = filename:join(get(src_dir), Esp),
	{ok,Bin} = file:read_file(File),
	{ok,Q} = esp_parse:loop_parse(Bin),
	{ok,ErlFile} = esp_parse:write_temp(Q,File),
	{ok,Mod} = c:c(ErlFile),
	gen_html_file(ErlFile,Mod),
	compile(T).

fliter([],R) ->
	{ok,R};

fliter([H|Files],R) ->
	File = filename:extension(H),
	case File of
		".esp" ->
			fliter(Files,[H|R]);
		_ ->
			fliter(Files,R)		
	end.


gen_html_file(ErlFile,Mod) ->
	Bin = Mod:main(),
	Dir = filename:dirname(ErlFile),
	HtmlFile = filename:join(Dir, filename:basename(ErlFile, ".erl")++".html"),
	file:write_file(HtmlFile, Bin),
	{ok,HtmlFile}.


