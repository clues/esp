%% Author: wave
%% Created: 2012-8-7
%% Description: TODO: Add description to esp_server_SUITE
-module(esp_server_SUITE).

-compile(export_all).


all() ->
	[
	 test_unesp_file,
	 test_noexist_file,
	 test_normal].





test_unesp_file(_) ->
	application:start(esp),
	esp_server:start_link(),
	{error,unesp} = esp_server:request("/service/page.html"),
	ok.



test_noexist_file(_) ->
	application:start(esp),
	esp_server:start_link(),
	{error,noexist} = esp_server:request("/service/page.esp"),
	ok.


test_normal(_) ->
	application:start(esp),
	Temp = "<html><body>pwd:<@=file:get_cwd()@></body></html>",
	TestFile = "example.esp",
	file:delete(TestFile),
	file:write_file(TestFile, list_to_binary(Temp)),
	
	esp_server:start_link(),
	{ok,example_esp} = esp_server:request("/"++TestFile),
	ok.