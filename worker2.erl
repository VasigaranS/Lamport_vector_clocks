%% @author vasigarans
%% @doc @todo Add description to worker.


-module(worker2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/6,stop/1,peers/2]).

start(Name,Logger,Seed,Sleep,Jitter,Nodes)->
	spawn_link(fun()->init(Name,Logger,Seed,Sleep,Jitter,Nodes) end).

stop(Worker)->
	Worker!stop.


init(Name,Log,Seed,Sleep,Jitter,Nodes)->
	random:seed(Seed,Seed,Seed),
	receive
		{peers,Peers}->
			Counter=vect:zero(Nodes),
			loop(Name,Log,Peers,Sleep,Jitter,Counter);
		stop->
			ok
	end.


peers(Wrk,Peers)->
	Wrk!{peers,Peers}.


loop(Name,Log,Peers,Sleep,Jitter,Counter)->
	
	Wait=random:uniform(Sleep),
	receive
		{msg,Time,Msg}->
			
			Temp=vect:inc(Name, vect:merge(Counter, Time)),
			Log!{log,Name,Temp,{received,Msg}},
			
			loop(Name,Log,Peers,Sleep,Jitter,Temp);
		stop->
			ok;
		Error->
			Log!{log,Name,time,{error,Error}}
	after Wait->
		Selected=select(Peers),
		Time=vect:inc(Name,Counter),
		Message={hello,random:uniform(100)},
		Selected!{msg,Time,Message},
		jitter(Jitter),
		Log!{log,Name,Time,{sending,Message}},
		loop(Name,Log,Peers,Sleep,Jitter,Time)
	end.


select(Peers)->
	lists:nth(random:uniform(length(Peers)),Peers).


jitter(0)-> ok;
jitter(Jitter)->timer:sleep(random:uniform(Jitter)).




	
	


%% ====================================================================
%% Internal functions
%% ====================================================================


