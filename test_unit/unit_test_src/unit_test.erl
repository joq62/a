%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(unit_test). 
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------

%% External exports

-export([start/0]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:init 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
-define(TEST_OBJ_ERROR,[{adder_service,unit_test_adder_service},
			{glurk,test_glurk}]).
-define(TEST_OBJ,[ {lib_service,unit_test_lib_service},
		   {adder_service,unit_test_adder_service},
		   {test_nodes,unit_test_nodes}
		 ]).

-ifdef(error_test).
-define(TEST_CALL,[{test_case,Service,rpc:call(node(),UnitTestCode,test,[],5000)}
				   ||{Service,UnitTestCode}<-?TEST_OBJ_ERROR]).
-else.
-define(TEST_CALL,[{test_case,Service,rpc:call(node(),UnitTestCode,test,[],5000)}
				   ||{Service,UnitTestCode}<-?TEST_OBJ]).
-endif.

start()->

    R=?TEST_CALL,
    Error=[{test_case,Service,Result}||{test_case,Service,Result}<-R,Result/=ok],
    io:format("***************************    Unit test result     ***********************~n~n"),
    case Error of
	[]->
	    io:format("OK Unit test Passed ~n~n");
	Error->
	    io:format("ERROR Unit test failed = ~p~n~n",[Error])
    end,
    init:stop(),
    ok.
