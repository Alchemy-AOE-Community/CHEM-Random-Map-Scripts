%Isolated_Lakes Land Generation
%TechChariot
%7.12.22

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');
[Preface,LPM_exp,~] = RMS_Manual_Land(filename);


MLP                   = [('create_player_lands'); ...
                        {'{'}; ...
                        {'terrain_type DLC_WETROCKBEACH'}; ...
                        {'circle_radius 40 0'}; ...
                        {'base_elevation 1'}; ...
                        {'other_zone_avoidance_distance 10'}; ...
                        {'clumping_factor 30'}; ...
                        {'if TINY_MAP'}; ...
                        {'base_size 6'}; ...
                        {'land_percent 4'}; ...
                        {'elseif SMALL_MAP'}; ...
                        {'base_size 7'}; ...
                        {'land_percent 8'}; ...
                        {'elseif MEDIUM_MAP'}; ...
                        {'base_size 9'}; ...
                        {'land_percent 8'}; ...
                        {'elseif LARGE_MAP'}; ...
                        {'base_size 9'}; ...
                        {'land_percent 10'}; ...
                        {'elseif HUGE_MAP'}; ...
                        {'base_size 10'}; ...
                        {'land_percent 11'}; ...
                        {'elseif GIGANTIC_MAP'}; ...
                        {'base_size 10'}; ...
                        {'land_percent 11'}; ...
                        {'else'}; ...
                        {'endif'}; ...
                        {'}'}];


MLA = [('create_land'); ...
       {'{'}; ...
       {'terrain_type GB'}; ...
       {'land_position 50 50'}; ...
       {'base_elevation 0'}; ...
       {'clumping_factor 30'}; ...
       {'land_percent 100'}; ...
       {'}'}];


Config = [{1}];

Ro = 18;
Ao = 2*Ro;

Ri = Ro-2;
Ai = 2*Ri;

Rs = Ri-2;
As = 2*Rs;

Y = 1;
NF = 16;

k = 1;
for i = 1:length(Config)
%[cpl] = RMS_CPL_V6({0},{16},{1},[44 44.5 45 45.5 46],[178 179 180 181 182],[0 15 30 60 75 90],[-0.11],[40],0.7); %creating player lands

PC = [Rounded_Rectangle({As},{Y},{Rs},[{'GB'}],{0},{0})];
%[nxPC,~] = size(PC); IOI = round([1:nxPC/NF:nxPC]);
%LPM_FP = LPM_exp;
%for j = IOI
%PC(j,3) = {{'DLC_WATER5'}};
%LPM_FP = [LPM_FP; PC{j,1} PC{j,2}];
%end
%%
%
%LPM_FP_exp = LPM_Shadow(LPM_FP,2*ones(length(IOI),1)); LPM_FP_exp = setdiff(LPM_FP_exp,LPM_FP,"rows");
DFM = []
for j = 1:6
DFM = [DFM; LandScribeV5([{'DLC_WATER5'}],[{0}],{00 00},{60*(j-1)},{'0*x'},{1},{0},[-10 -9])];
end


[COMMAND(k).XY] = [RMS_Processor_Random_Coord([Rounded_Rectangle({Ao},{Y},{Ro},[{'GB'}],{0},{0})],LPM_exp,2); ...
                    RMS_Processor_Random_Coord([Rounded_Rectangle({Ai},{Y},{Ri},[{'GB'}],{0},{0})],LPM_exp,1); ...
                    RMS_Processor_V4([DFM; PC],LPM_exp)];


k = k + 1;
end
%

[List] = RMS_RS_V2(Config,{'C'},COMMAND);

CODE = [Preface; MLP; List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV8('Isolated_Lakes.ods')
