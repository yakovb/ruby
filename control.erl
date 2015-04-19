-module(control).
-export([loop/0]).

%TODO: spawn/kill/restart converters and displays
%TODO: create temp list for testing including temps in/out of range for F and C
%TODO: create multiple converters and displays if possible
%TODO: have a system shutdown option
%TODO note if converter dies and restart it

loop() ->
	process_flag(trap_exit, true),
	receive
		new_converter ->
			io:format("Starting a new converter actor.~n"),
			register(converter, spawn_link(fun convert:loop/0)),
			loop();


		{'EXIT', DeadConverter, Reason} ->
			io:format("Converter ~p died with reason:  ~p.", [DeadConverter, Reason]),
			io:format("Launching another converter...~n"),
			self ! new_converter,
			loop()

		end.