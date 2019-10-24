%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%%
%%% Created : 10 dec 2012
% {specification, calculator}.
% {type,application}.
% {description, "Simple calculator for test purpose" }.
% {vsn, "1.0.0" }.
% {exported_services,["adder_service"]}.
% {service_def,[{"adder_service",[{josca,"adder_service.josca"},
%			     {num_instances,1},
%			     {num_processes,1},
%			     {nodes,any}]
%	       }]}.
%%%  

%%% -------------------------------------------------------------------
-module(app_spec).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
-define(CONFIG_FILE,"node.config").
%% External exports
-record(app_info,{application,
		  vsn,
		  exported_services,
		  service_defs
		 }.

-export([init_app_info/2
	]).


%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
init_app_info(AppName,AppJoscaFile)->
    Result= case file:consult(AppJoscaFile) of
		{ok,Info}->
		    {specification, AppName_1}=lists:keyfind(specification,1,Info),
		    case AppName==AppName_2 of
			false->
			    {error,[not_valid_josca_file,AppName,AppName_1,?MODULE,?LINE]};
			true->
			    {vsn,Vsn}=lists:keyfind(vsn,1,Info),
			    {exported_services,ExportedeServices}=lists:keyfind(exported_services,1,Info),
			    {service_def,ServiceDefs}=lists:keyfind(exported_services,1,Info),
			    AppInfo=#app_info{application=AppName,vsn=Vsn,exported_services=ExportedeServices,
					      service_defs=ServiceDefs},
			    ets:
			    {ok,AppInfo}
		    end;
		{error,Err}->
		    {error,[e_file_consult,"joscafile = "++AppJoscaFile,?MODULE,?LINE]}
	    end,
    Result.
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
