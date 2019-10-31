%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test_master_service).
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------
-define(W1,'worker_1@asus').
-define(W2,'worker_2@asus').
-define(TEST_APP_SPEC,"test_app.spec").
-define(TEST_2_APP_SPEC,"test_2_app.spec").
-define(LIB_SERVICE_SPEC,"lib_service.spec").
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
     {ok,_Pid}=master_service:start(),
    ok.

spec_1_test()->
    {ok,test_app,
     [{specification,test_app},
      {type,application},
      {description,"Specification file for application template"},
      {vsn,"1.0.0"},
      {instances,1},
      {localization,any},
      {service_def,[{"lib_service","lib_service.spec"}]}]}=spec:read(?TEST_APP_SPEC),
   {ok,lib_service,
    [{specification,lib_service},
     {type,service},
     {description,"Specification file for service"},
     {vsn,"1.0.0"},
     {exported_services,{"lib_service",any}},
     {needed_capabilities,[]},
     {dependencies,[]}]}=spec:read(?LIB_SERVICE_SPEC),
    
    ok.
 
spec_2_test()->   
    test_app=spec:read(specification,?TEST_APP_SPEC),
    application=spec:read(type,?TEST_APP_SPEC),
    "Specification file for application template"=spec:read(description,?TEST_APP_SPEC),
    "1.0.0"=spec:read(vsn,?TEST_APP_SPEC),
    1=spec:read(instances,?TEST_APP_SPEC),
    any=spec:read(localization,?TEST_APP_SPEC),
    [{"lib_service","lib_service.spec"}]=spec:read(service_def,?TEST_APP_SPEC),  
    ok.
    
spec_3_test()->
    lib_service=spec:read(specification,?LIB_SERVICE_SPEC),
    service=spec:read(type,?LIB_SERVICE_SPEC),
    "Specification file for service"=spec:read(description,?LIB_SERVICE_SPEC),
    "1.0.0"=spec:read(vsn,?LIB_SERVICE_SPEC),
    {"lib_service",any}=spec:read(exported_services,?LIB_SERVICE_SPEC),
    []=spec:read(needed_capabilities,?LIB_SERVICE_SPEC),
    []=spec:read(dependencies,?LIB_SERVICE_SPEC),
    ok.

apps_to_start_and_stop_1_test()->
    WantedApps=[?TEST_APP_SPEC,?TEST_2_APP_SPEC],
    ActiveApps=[{spec:read(specification,?TEST_APP_SPEC),
		 ?TEST_APP_SPEC,
		 [{lib_service,node_1}]},
		{app_glurk,
		 "glurk_app.spec",
		 [{another_service,node_1}]}],

    % 1) check if need to start a new application 
    AppsToStart=[AppSpec||AppSpec<-WantedApps,
			  false==lists:keymember(spec:read(specification,AppSpec),
						 1,ActiveApps)],
    ["test_2_app.spec"]=AppsToStart,

    % 2) Check if need to stop a existing application
    AppsToStop=[{AppSpec,ServiceInfo}||{_AppsId,AppSpec,ServiceInfo}<-ActiveApps,
			  false==lists:member(AppSpec,WantedApps)],
    [{"glurk_app.spec",[{another_service,node_1}]}]=AppsToStop,
    ok.
    
start_app_test()->
    WantedApps=[?TEST_APP_SPEC],
    ActiveApps=[],
    AppsToStart=[AppSpec||AppSpec<-WantedApps,
			  false==lists:keymember(spec:read(specification,AppSpec),
						 1,ActiveApps)],
    []=[{AppSpec,ServiceInfo}||{_AppsId,AppSpec,ServiceInfo}<-ActiveApps,
				       false==lists:member(AppSpec,WantedApps)],
    AppsToStart,
    % In app spec need to specify service vsn 
    % Use github tag for versioning otherwise need store different versions ..
    % 
    ok.
    

stop_test()->
    master_service:stop(),
    do_kill().
do_kill()->
    init:stop().
