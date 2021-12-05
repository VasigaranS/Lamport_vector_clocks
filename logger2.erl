%% @author vasigarans
%% @doc @todo Add description to logger2.


-module(logger2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1,stop/1,loop_through/3]).

start(Nodes)->
	spawn_link(fun()->init(Nodes) end).

stop(Logger)->
	Logger!stop.


init(Nodes)->
	Clock=time:clock(Nodes),
	loop(Clock,[]).


loop_through([],_,Temp_queue)->
	Temp_queue;

loop_through([{X,Y,Z}|T],New_Clock,Temp_queue)->
	%io:format(" 28 ~w ~w ~w",[X,Y,Z]),
%Temp_queue2=[],

	
	
	case time:safe(Y,New_Clock) of
          true ->
            log(X, Y, Z),
			
		loop_through(T,New_Clock,Temp_queue);
          false->
      			loop_through(T,New_Clock,[{X,Y,Z}|Temp_queue])

			 % Temp_queue2=[{X,Y,Z}|Temp_queue]
			%_=lists:append([{X,Y,Z}],Temp_queue),
			%io:format("~w ~n",[Temp_queue])
        end.
%	lists:keysort(2, Temp_queue),
	
%	loop_through(T,New_Clock,Temp_queue).
	
	


loop(Clock,HQ)->
	%io:format("44 ~w ~n",[Clock]),
	receive
		{log,From,Time,Msg}->
			
			New_Clock=time:update(From,Time,Clock),
			NHQ=[{From, Time, Msg} | HQ],
			Sorted_NHQ=lists:keysort(2, NHQ),
			
			Temp_queue=loop_through(Sorted_NHQ,New_Clock,[]),
			
			
		
			
			%io:format(" queue ~w ~n",[Temp_queue]),
			
			loop(New_Clock, lists:keysort(2,Temp_queue));

			stop->
				ok
			end.

log(From,Time,Msg)->
	io:format("log: ~w ~w ~p ~n",[Time,From,Msg]).




%% ====================================================================
%% Internal functions
%% ====================================================================


