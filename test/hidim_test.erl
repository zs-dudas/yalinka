%%%-------------------------------------------------------------------
%%% @author Serge A. Ribalchenko <fisher@heim.in.ua>
%%% @copyright (C) 2014, Serge A. Ribalchenko
%%% @doc
%%%
%%% @end
%%% Created : 30 Apr 2014 by Serge A. Ribalchenko <fisher@heim.in.ua>
%%%-------------------------------------------------------------------
-module(hidim_test).

-include_lib("eunit/include/eunit.hrl").

%% API
-export([start/0]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
start() ->
    eunit:test([{module, ?MODULE}], [verbose]).


%%%===================================================================
%%% Eunit test functions
%%%===================================================================

first_test_() ->
    [
     ?_assert( true )
    ].

direct_load_test_() ->
    [
     ?_assertMatch( {module, _M}, code:load_file(yalinka))
    ].

pure_crash_test_() ->
    [
     ?_assertMatch( {ok, _Ref}, yalinka:new(
                                  [
                                   {2, 11.1,22.2,33.3,44.4},
                                   {3, 21.1,32.2,54.3,53.4}
                                  ])),
     ?_assertMatch( {ok, _Ref}, yalinka:new(
                                  [
                                   {2, 11.1,22.2,33.3,44.4},
                                   {3, 21.1,32.2,54.3,53.4}
                                  ]))
    ].

ok_new_3d_test_() ->
    [
     ?_assertMatch( {ok, _Ref}, yalinka:new([{1, 1.1,2.2,3.3},{2, 11.0,22.0,33.0}])),
     ?_assertMatch( {ok, _Ref}, yalinka:new([{1, [1.1,2.2,3.3]},{2, [11.0,22.0,33.0]}])),
     ?_assertMatch( {ok, _Ref}, yalinka:new([{2, 3.2,5.2,6.7},{3, 23.1,5.2,56.20}])),
     ?_assertMatch( {ok, _Ref}, yalinka:new([{1, {1.1,2.2,3.3}},{2, {11.0,22.0,33.0}}]))
    ].

ok_new_kd_test_() ->
    [
     ?_assertMatch( {ok, _Ref}, yalinka:new([{1, 1.1,2.2,3.3,4.4},{2, 11.0,22.0,33.0,44.0}])),
     ?_assertMatch( {ok, _Ref}, yalinka:new([{1, [1.1,2.2,3.3,4.4]},{2, [11.0,22.0,33.0,44.0]}])),
     ?_assertMatch( {ok, _Ref}, yalinka:new([{1, {1.1,2.2,3.3,4.4}},{2, {11.0,22.0,33.0,44.0}}]))
    ].

just_one_7d_test_() ->
    [ ?_assertMatch(
         {ok, _Ref},
         yalinka:new([ {1, 1.1,2.1,3.1,4.1,5.1,6.1,7.1}])) ].

long_5d_test_() ->
    [
     ?_assertMatch(
        {ok, _Ref},
        yalinka:new([
                     {1, 1.1,2.2,3.3,4.4,5.5},
                     {2, 11.0,22.0,33.0,44.0,55.0},
                     {3, 12.0,22.0,32.0,42.0,52.0},
                     {4, 10.0,20.0,30.0,40.0,50.0},
                     {5, 11.1,22.2,33.3,44.4,55.5},
                     {6, 100.0,200.0,300.0,400.0,500.0},
                     {7, 101.0,202.0,303.0,404.0,505.0}
                    ]))
    ].
