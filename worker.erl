%% @author vasigarans
%% @doc @todo Add description to worker.


-module(worker).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/5,stop/1,peers/2]).

start(Name,Logger,Seed,Sleep,Jitter)->
	spawn_link(fun()->init(Name,Logger,Seed,Sleep,Jitter) end).

stop(Worker)->
	Worker!stop.


init(Name,Log,Seed,Sleep,Jitter)->
	rand:seed(exsss,{Seed,Seed,Seed}),
	receive
		{peers,Peers}->
			Counter=time:zero(),
			loop(Name,Log,Peers,Sleep,Jitter,Counter);
		stop->
			ok
	end.


peers(Wrk,Peers)->
	Wrk!{peers,Peers}.


loop(Name,Log,Peers,Sleep,Jitter,Counter)->
	
	Wait=rand:uniform(Sleep),
	receive
		{msg,Time,Msg}->
			
			Temp=time:merge(Counter,Time),
			Inc_time=time:inc(Name, Temp),
			Log!{log,Name,Temp,{received,Msg}},
			
			loop(Name,Log,Peers,Sleep,Jitter,Inc_time);
		stop->
			ok;
		Error->
			Log!{log,Name,time,{error,Error}}
	after Wait->
		Selected=select(Peers),
		Time=time:inc(Name,Counter),
		Message={hello,rand:uniform(100)},
		Selected!{msg,Time,Message},
		jitter(Jitter),
		Log!{log,Name,Time,{sending,Message}},
		loop(Name,Log,Peers,Sleep,Jitter,Time)
	end.


select(Peers)->
	lists:nth(rand:uniform(length(Peers)),Peers).


jitter(0)-> ok;
jitter(Jitter)->timer:sleep(rand:uniform(Jitter)).




	
	


%% ====================================================================
%% Internal functions
%% ====================================================================


