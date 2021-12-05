%% @author vasigarans
%% @doc @todo Add description to test.


-module(test2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([run/2]).


run(Sleep,Jitter)->
	Log=logger3:start([john,paul,ringo,george]),
	A=worker2:start(john, Log, 99, Sleep, Jitter,[john,paul,ringo,george]),
	B=worker2:start(paul, Log, 34, Sleep, Jitter,[john,paul,ringo,george]),
	C=worker2:start(ringo,Log,45,Sleep,Jitter,[john,paul,ringo,george]),
	D=worker2:start(george,Log,94,Sleep,Jitter,[john,paul,ringo,george]),
	worker2:peers(A, [B,C,D]),
	worker2:peers(B,[A,C,D]),
	worker2:peers(C, [A,B,D]),
	worker2:peers(D,[A,B,C]),
	timer:sleep(5000),
	worker2:stop(Log),
	worker2:stop(A),
	worker2:stop(B),
	worker2:stop(C),
	worker2:stop(D).





%% ====================================================================
%% Internal functions
%% ====================================================================


