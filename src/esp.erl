%% Author: wave
%% Created: 2012-8-3
%% Description: TODO: Add description to esp
-module(esp).


-compile(export_all).


gen_html_file(ErlFile,Mod) ->
	Bin = Mod:main(),
	Dir = filename:dirname(ErlFile),
	HtmlFile = filename:join(Dir, filename:basename(ErlFile, ".erl")++".html"),
	file:write_file(HtmlFile, Bin),
	{ok,HtmlFile}.


