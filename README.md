esp
===

erlang server page


style like jsp(./example/my.esp)
1 code

	<@Erlang code@>
	<@ I = 3,
	   3 = I,
	   erlang:now()@>
	
	<@= I @>
	<@=(I*3-5)@>


1.1 support comment 	

	<@
		%%this is comment
		Pwd = file:get_cwd()
	@>


2 not support define unanonymous function,
  you can use anonymous replace
 
	<@
		Fun1 = fun(X,AccIn) ->
							case filename:extension(X) of
								Ext ->
									[X|AccIn];
								_ ->
									AccIn
							end
					end	
	
		{ok,List} =file:list_dir(Dir),
		lists:foldl(Fun1, [], List)
	@>  
  
 