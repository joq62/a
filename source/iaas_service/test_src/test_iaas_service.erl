%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_iaas_service).
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------
-define(W1,'worker_1@asus').
-define(W2,'worker_2@asus').
%% External exports

-export([]).


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:init 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
init_test()->
  %  glurk=nodes_config:init("nodes.config"),
    {ok,_Pid}=iaas_service:start(),
    ok.

nodes_config_zone_test()->
    {ok,L}=iaas_service:zone(),
    true=lists:member({"board_w3@asus","sthlm.flat.balcony"},L),
    {ok,"varmdoe.guesthouse.room1"}=iaas_service:zone('board_w2@asus'),
    {error,[no_zones,nodes_config,_Line]}=iaas_service:zone('glurk@asus'),
    ok.    

nodes_config_ip_addr_test()->
    {ok,[{"localhost",20030}]}=iaas_service:ip_addr("board_w3@asus"),
    {ok,["board_w3@asus"]}=iaas_service:ip_addr("localhost",20030),
    {error,[eexist,"glurk@asus",nodes_config,_]}=iaas_service:ip_addr("glurk@asus"),
    {error,[eexists,"localhost",202230,nodes_config,_]}=iaas_service:ip_addr("localhost",202230),
    ok.

nodes_config_capa_test()->
    {ok,[{"board_m1@asus",tellstick}]}=iaas_service:capability(tellstick),
    {ok,[{"board_w3@asus",disk},{"board_m1@asus",disk}]}=iaas_service:capability(disk),
    {ok,[]}=iaas_service:capability(glurk),
    ok.

check_availible_nodes_test()->
    {ok,NodesConf}=iaas_service:get_all_nodes(),
    PingResult=[{net_adm:ping(list_to_atom(NodeId)),NodeId,Status}||{NodeId,Status}<-NodesConf],
    []=[{error,NodeId,Status}||{pang,NodeId,Status}<-PingResult],
    ok.

    
stop_test()->
    iaas_service:stop(),
    do_kill().
do_kill()->
    init:stop().
