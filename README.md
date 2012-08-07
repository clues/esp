esp
===

erlang server page

sample:

<table border="1">
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>"
  <@
  FILL = fun(X) ->
  	@><TR>
  		<TD>month_<@=X@></TD>
  		<TD><@=X*100@></TD>
  	  </TR>
	<@end,
	lists:foreach(FILL,lists:seq(1,12))
	@>"
</table>





style like jsp
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
  
 