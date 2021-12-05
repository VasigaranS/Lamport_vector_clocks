%% @author vasigarans
%% @doc @todo Add description to time.


-module(time).

%% ====================================================================
%% API functions
%% ====================================================================
-export([zero/0,inc/2,leq/2,merge/2,clock/1,update/3,safe/2]).

zero()->
	0.

inc(Name,T)->
	T+1.


merge(Ti, Tj) when Ti > Tj ->
    Ti;
merge(Ti, Tj) when Ti =< Tj->
    Tj.

leq(Ti, Tj) when Ti =< Tj ->
    true;
leq(Ti, Tj) when Ti > Tj ->
    false.


clock(Nodes)->
	lists:foldl(fun(Node, Acc) -> [{Node, zero()} | Acc] end, [], Nodes).

update(Node, Time, Clock) ->
  L=lists:keyreplace(Node, 1, Clock, {Node, Time}),
  lists:keysort(2, L).






safe(Time,Clock)->
     Sorted_clock=lists:keysort(2, Clock),
	 
	
	[{Node,Time_val}|T]=Sorted_clock,
	% io:format(" clock ~w ~w~n",[Time,Time_val]),
	leq(Time,Time_val).
	



%% ====================================================================
%% Internal functions
%% ====================================================================


