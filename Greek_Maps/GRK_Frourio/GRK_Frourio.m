%Frourio (Greek Fortress) Land Generation
%TechChariot
%9.20.22

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');
[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

MLP = []; MLA = [];

MLI =[{'create_player_lands'}; ...
      {'{'}; ...
      {'terrain_type Y'}; ...
      {'base_elevation 0'}; ...
      {'land_percent 0'}; ...
      {'base_size 23'}; ...
      {'if TINY_MAP'}; ...
      {'circle_radius 30 0'}; ...
      {'elseif SMALL_MAP'}; ...
      {'circle_radius 31 0'}; ...
      {'elseif MEDIUM_MAP'}; ...
      {'circle_radius 33 0'}; ...
      {'elseif LARGE_MAP'}; ...
      {'circle_radius 36 0'}; ...
      {'elseif HUGE_MAP'}; ...
      {'circle_radius 39 0'}; ...
      {'elseif GIGANTIC_MAP'}; ...
      {'circle_radius 39 0'}; ...
      {'else'}; ...
      {'endif'}; ...
%      {'if LOW_RESOURCES'}; ...
%      {'base_size 0'}; ...
%      {'land_percent 0'}; ...
%      {'else'}; ...
%      {'land_percent 100'}; ...
%      {'endif'}; ...
      {'}'}];

MLA =  [MLA; ...
       {'L { terrain_type K base_elevation 1 K land_percent 100 land_position  1  1 }'}; ...
       {'L { terrain_type K base_elevation 1 land_percent 100 land_position  1 99 }'}; ...
       {'L { terrain_type K base_elevation 1 land_percent 100 land_position 99  1 }'}; ...
       {'L { terrain_type K base_elevation 1 land_percent 100 land_position 99 99 }'}; ...
       {'L { terrain_type ROAD2 land_percent 100 land_position 50 50 }'}];

 k = 1;
Config = [{1}];

rmin = 22*ones(1,6); f = [120 144 168 200 220 240]; Rmin = round(100*(f/2-rmin)./f); COMMAND2(k).XY =  [];
for i = 1:6
R = [];
if i == 1
conditional_prefix = {'if TINY_MAP'};
elseif i == 2
conditional_prefix = {'elseif SMALL_MAP'};
elseif i == 3
conditional_prefix = {'elseif MEDIUM_MAP'};
elseif i == 4
conditional_prefix = {'elseif LARGE_MAP'};
elseif i == 5
conditional_prefix = {'elseif HUGE_MAP'};
elseif i == 6
conditional_prefix = {'elseif GIGANTIC_MAP'};
end
%

for j = 1:360
R = [R; LandScribeV5([{'R2'}],[{0}],{00 00},{j-1},{'0*x'},{1},{0},[Rmin Rmin+2])]; %Field Circle Generation
end
%

[COMMAND2(k).XY] = [COMMAND2(k).XY; conditional_prefix; RMS_Processor_V4([R],LPM_exp)];

if i == 6
COMMAND2(k).XY = [COMMAND2(k).XY; {'endif'}];
end
%
end
%

[List2] = RMS_RS_V2(Config,{'C'},COMMAND2);


[COMMAND1(k).XY] = RMS_Processor_V4([Rounded_Rectangle({100},{1},{30},{'K'},{0},{0})],LPM_exp); [List1] = RMS_RS_V2(Config,{'C'},COMMAND1); %Configuring the Outside Boundary


CODE = [Preface; MLP; List2; MLI; List1; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV8('Frourio.ods')
