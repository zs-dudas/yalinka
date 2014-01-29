-module(yalinka_test).

-include_lib("eunit/include/eunit.hrl").

-export([start/0, realdata/0]).

-compile([export_all]).

-define(POINTS, [{0,  10.0, 10.0, 10.0},
                 {1,  10.0, 10.0,-10.0},
                 {2,  10.0,-10.0, 10.0},
                 {3,  10.0,-10.0,-10.0},
                 {4, -10.0, 10.0, 10.0},
                 {5, -10.0, 10.0,-10.0},
                 {6, -10.0,-10.0, 10.0},
                 {7, -10.0,-10.0,-10.0}]).


-define(ROOT, [{11, 10.0,10.0,10.0}, {12, -10.0,-10.0,-10.0}, {13, 1.0,1.0,1.0}]).

-define(WIKIPEDIA_TEST,
        [ {1, 2.0, 3.0}, {2, 5.0, 4.0}, {3, 9.0, 6.0},
          {4, 4.0, 7.0}, {5, 8.0, 1.0}, {6, 7.0, 2.0} ]).

-define(MAXDIM, 3).

start() ->
    not_implemented_yet.

size_test_() ->
    {ok, Tree} = yalinka:new(?POINTS),
    Size = yalinka:size(Tree),
    {ok, Tre1} = yalinka:new([{I, {X,Y,Z}}||{I, X,Y,Z}<-?POINTS]),
    Siz1 = yalinka:size(Tre1),
    {ok, Tre2} = yalinka:new([{I, [X,Y,Z]}||{I, X,Y,Z}<-?POINTS]),
    Siz2 = yalinka:size(Tre2),
    [
     ?_assertEqual(Size, {ok, length(?POINTS)}),
     ?_assertEqual(Siz1, {ok, length(?POINTS)}),
     ?_assertEqual(Siz2, {ok, length(?POINTS)})
    ].

clear_teest_() ->
    {ok, Tree} = yalinka:new(?POINTS),
    Clear = yalinka:clear(Tree),
    [?_assertEqual(Clear, ok)].

root_test_() ->
    {ok, Ref} = yalinka:new(?ROOT),
    {ok, Type2} = yalinka:new([{I, {X,Y,Z}}||{I,X,Y,Z}<-?ROOT]),
    {ok, Type3} = yalinka:new([{I, [X,Y,Z]}||{I,X,Y,Z}<-?ROOT]),
    [
     ?_assertEqual( {ok,13,{1.0,1.0,1.0}}, yalinka:root(Ref)   ),
     ?_assertEqual( {ok,13,{1.0,1.0,1.0}}, yalinka:root(Type2) ),
     ?_assertEqual( {ok,13,{1.0,1.0,1.0}}, yalinka:root(Type3) )
    ].

wikipedia_test_() ->
    {ok, Ref} = yalinka:new(?WIKIPEDIA_TEST),
    [
     ?_assert(
        begin
            {ok, [{5, Dist}]} = yalinka:search(Ref, {9.0, 2.0}, 1),
            Dist < 1.4143 andalso Dist > 1.4141
        end)
    ].

storing_test_() ->
    {ok, Tree} = yalinka:new(?POINTS),
    [
     ?_assertEqual( ok, yalinka:store(Tree, "testfile-storing") ),
     ?_assertEqual( begin
                        {ok, Ref} = yalinka:load("testfile-storing"),
                        yalinka:search(Ref, {10.0, 10.0, 11.0}, 1)
                    end,
                    yalinka:search(Tree, {10.0, 10.0, 11.0}, 1))
    ].

search2_test_() ->
    {ok, Tree} = yalinka:new(?POINTS),
    [
     ?_assertEqual( {ok, [{0, 0.0}]}, yalinka:search(Tree, {10.0, 10.0, 10.0}, 1)),
     ?_assertEqual( {ok, [{0, 1.0}]}, yalinka:search(Tree, {10.0, 10.0, 11.0}, 1)),
     ?_assertEqual( {ok, [{0, 1.4142135623730951}]},
                    yalinka:search(Tree, {10.0, 11.0, 11.0}, 1)),
     ?_assertEqual( {ok, [{0, 1.7320508075688772}]},
                    yalinka:search(Tree, {11.0, 11.0, 11.0}, 1)),
     ?_assertEqual( {ok, [{0, 2.449489742783178}]},
                    yalinka:search(Tree, {11.0, 11.0, 12.0}, 1))
    ].

search3_teest_() ->
    {ok, Tree} = yalinka:new(?POINTS),
    [
     ?_assertEqual( {ok, [{2, 200.0}, {0, 200.0}, {4, 200.0}, {6, 200.0}]},
                    yalinka:search(Tree, {0.0, 0.0, 10.0}, 4)),
     ?_assertEqual( {ok, [{0, 50.0}, {2, 250.0}, {4, 250.0}]},
                    yalinka:search(Tree, {5.0, 5.0, 10.0}, 3) )
    ].

gettree_test_() ->
    {ok, Tree} = yalinka:new(?POINTS),
    Normalized = lists:sort([ {Idx, {X,Y,Z}} || {Idx, X,Y,Z} <- ?POINTS ]),
    {ok, Tree2} = yalinka:new(Normalized),
    {ok, Export1} = yalinka:gettree(Tree),
    {ok, Export2} = yalinka:gettree(Tree2),
    [
     ?_assertEqual( Normalized, lists:sort(Export1) ),
     ?_assertEqual( Normalized, lists:sort(Export2) )
    ].

%% test yalinka:new/1 against random million points
%% beware of prng entropy exhaustion
-define(aggregs, 1000).
-define(million, 1000 * ?aggregs).
looong_test_() ->
    random:seed(erlang:now()),
    Dimension = 1+ random:uniform(2), %% dimension 2..3
    Point = fun() ->
                    [random:uniform() || _ <- lists:seq(1,Dimension)]
            end,
    Data = [
            {I, Point()}
            || I <- lists:seq(1, random:uniform(10000) +?million) ],
    {ok, Ref} = yalinka:new(Data),
    ok = yalinka:store(Ref, "testfile-million"),
    {ok, Tree} = yalinka:load("testfile-million"),
    RandomPoint = Point(),
    [
     ?_assertEqual( yalinka:size(Ref), {ok, length(Data)} ),
     ?_assertEqual( yalinka:dimension(Ref), {ok, Dimension} ),
     ?_assertEqual( yalinka:size(Ref), yalinka:size(Tree) ),
     ?_assertEqual( yalinka:dimension(Ref), yalinka:dimension(Tree) ),
     ?_assertEqual( yalinka:search(Ref, RandomPoint, 1),
                    yalinka:search(Tree, RandomPoint, 1)),

     %% effectivenes aggregated per thousand requests
     ?_assert( 50 * ?aggregs >
                   lists:foldl(
                     fun(_,A) ->
                             {ok, _, N} =
                                 yalinka:search(Ref, list_to_tuple(Point()), debug),
                             A + N
                     end,
                     0, lists:seq(1, ?aggregs))),
     ?_assert( 50 * ?aggregs >
                   lists:foldl(
                     fun(_,A) -> {ok, _, N} =
                                     yalinka:search(Tree, list_to_tuple(Point()), debug),
                                 A + N
                     end, 0, lists:seq(1, ?aggregs)))
    ].

addition_test_() ->
    random:seed(erlang:now()),
    Dimension = 1+ random:uniform(?MAXDIM -1),
    Point = fun() -> [random:uniform() || _<- lists:seq(1,Dimension)] end,
    RndData = [{I, Point()}||I<-lists:seq(1,random:uniform(1000))],
    {ok, Ref} = yalinka:new(RndData),
    AddData = [{I, list_to_tuple(Point())} || I<-lists:seq(1,random:uniform(1000))],
    ok = yalinka:add(Ref, AddData),
    [
     ?_assertEqual( yalinka:size(Ref), {ok, length(RndData) + length(AddData)} ),
     ?_assertEqual( yalinka:dimension(Ref), {ok, Dimension} ),
     ?_assertEqual( yalinka:search(Ref, list_to_tuple(Point())), {error, not_ready} ),
     ?_assert( begin
                  yalinka:index(Ref),
                  case yalinka:search(Ref, list_to_tuple(Point())) of
                      {ok, [{I, _Dist}]}
                        when is_integer(I) -> true;
                      _ -> false
                  end
              end)
    ].

addition2_test_() ->
    {ok, Ref} = yalinka:new(?POINTS),
    ok = yalinka:add(Ref, [{I, {X,Y,Z}}||{I, X,Y,Z}<-?ROOT]),
    yalinka:index(Ref),
    [ ?_assertEqual( yalinka:search(Ref, {0.0,0.0,0.0}),
                     {ok, [{13, 1.7320508075688772 }]}) ].

index_test_() ->
    {ok, R} = yalinka:new([{0, 0.0,0.0,0.0}]),
    [
     ?_assertEqual( yalinka:size(R), {ok, 1} ),
     ?_assertEqual( yalinka:add(R, [{1, {1.0,1.0,1.0}}]), ok ),
     ?_assertEqual( yalinka:size(R), {ok, 2} ),
     ?_assertEqual( yalinka:search(R, {2.0,2.0,2.0}), {error, not_ready} ),
     ?_assertEqual( yalinka:index(R), {ok, 2} ), %% now it fails
     ?_assertEqual( yalinka:search(R, {2.0,2.0,2.0}),
                    {ok, [{1, 1.7320508075688772 }]} )
    ].

realdata() ->
    io:format("1. file -> ETS...~n", []),
    {ok, IndexTableRef} = ets:file2tab("test/data/geonames.index"),
    io:format("2. ETS -> term...~n", []),
    RealData = [{Idx, X, Y, Z} || {Idx, {X, Y, Z}} <- ets:tab2list(IndexTableRef)],
    io:format("3. term -> yalinka:new/1...~n", []),
    {ok, Tree} = yalinka:new( RealData ),
    io:format("4. ok!~n", []),
    {ok, Size} = yalinka:size( Tree ),
    io:format("5. size is ~p~n", [Size]),
    ok.

reallyrandomfloat() ->
    <<F/float>> = crypto:rand_bytes(8),
    F.

reallyrandompoint() ->
    <<F1/float, F2/float, F3/float>> = crypto:rand_bytes(24),
    {F1, F2, F3}.

bump() ->
    code:load_file(yalinka),
    random:seed(now()),
    {ok, T} = yalinka:load("/tmp/random-million"),
    yalinka:search(T, reallyrandompoint()),
    T.
