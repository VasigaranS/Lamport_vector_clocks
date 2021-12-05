%% @author vasigarans
%% @doc @todo Add description to vect.


-module(vect).

%% ====================================================================
%% API functions
%% ====================================================================
-export([zero/1, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).

zero(Nodes) ->
   lists:foldl(fun(Node, Acc) -> [{Node, 0} | Acc] end, [], Nodes).

inc(Name, Time) ->
  case lists:keyfind(Name, 1, Time) of
    {Name, NodeTime} ->
      lists:keyreplace(Name, 1, Time, {Name, NodeTime+1});
    false ->
      [{Name, 0} | Time]
  end.


%% ====================================================================
%% Internal functions
%% ====================================================================


merge([], Time) ->
    Time;
merge([{Name, Ti}|Rest], Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, Tj} ->
            [{Name,erlang:max(Ti,Tj)} |merge(Rest, lists:keydelete(Name, 1, Time))];
        false ->
            [{Name,Ti} |merge(Rest, Time)]
end.


clock(_) ->
  [].


update(From, Time, Clock) ->
	{Name,Tj}=lists:keyfind(From,1,Time),

    case lists:keyfind(From, 1, Clock) of
        {From, _} ->
            lists:keyreplace(From, 1, Clock,{From,Tj});
        false ->
             [{From,Tj}| Clock]
end.



leq([], _) ->
    true;
leq([{Name, Ti}|Rest],Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, Tj} ->
            if
                Ti =< Tj ->
					leq(Rest,Time);
					
				true->
					false
				end; 
		
		false ->
			false
			end.

safe(Time,Clock)->
	leq(Time,Clock).


