esp
===

erlang server page


style like jsp(./example/my.esp)

1 code

	<@ I = 3,
	   3 = I,
	   %%this is comment
	   erlang:now()@>
	
	<@= I @>
	<@=(I*3-5)@>


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
  
 