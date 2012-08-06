%% Author: wave
%% Created: 2012-8-6
%% Description: TODO: Add description to esp_util
-module(esp_util).

-ifdef(TEST).
-compile(export_all).
-endif.

-export([timestamp/0,
		 datetime_to_timestamp/1,
		 timestamp_to_datetime/1
		 ]).

%%format current time to timestamp (ms) 
timestamp() ->
    {Mega, Sec, Micro} = now(),
    ((Mega * 1000000) + Sec)*1000 + Micro div 1000+ 8*60*60*1000.

%%format current DateTime::datetime()::{date(),time()} to timestamp (ms) 
datetime_to_timestamp(DateTime) ->
	Seconds1 = calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}}),
	Seconds2 = calendar:datetime_to_gregorian_seconds(DateTime),
	(Seconds2 - Seconds1)*1000.

%%format Timestamp(ms) to datetime()::{date(),time()}
timestamp_to_datetime(Timestamp) ->
	Seconds1 = calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}}),
    Seconds2 = Timestamp div 1000 + Seconds1,
    calendar:gregorian_seconds_to_datetime(Seconds2).