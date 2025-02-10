%Isolated_Lakes_V2 Land Generation
%TechChariot
%2025-02-08

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);


MLP                   = [('create_player_lands'); ...
                        {'{'}; ...
                        {'terrain_type DLC_WETROCKBEACH'}; ...
                        {'base_elevation 1'}; ...
                        {'other_zone_avoidance_distance 6'}; ...
                        {'clumping_factor 25'}; ...
                        {'base_size 7'}; ...
                        {'number_of_tiles 360'}; ...
                        {'left_border 3'}; ...
                        {'right_border 3'}; ...
                        {'top_border 3'}; ...
                        {'bottom_border 3'}; ...
                        {'border_fuzziness 100'}; ...
                        {'if TINY_MAP'}; ...
                        {'circle_radius 37 0'}; ...
                        {'elseif SMALL_MAP'}; ...
                        {'circle_radius 36 0'}; ...
                        {'elseif MEDIUM_MAP'}; ...
                        {'circle_radius 34 0'}; ...
                        {'elseif LARGE_MAP'}; ...
                        {'circle_radius 32 0'}; ...
                        {'elseif HUGE_MAP'}; ...
                        {'circle_radius 30 0'}; ...
                        {'elseif GIGANTIC_MAP'}; ...
                        {'circle_radius 30 0'}; ...
                        {'else'}; ...
                        {'endif'}; ...
                        {'}'}];

##MLA                   = [('L'); ...
##                        {'{'}; ...
##                        {'land_position 50 50'}; ...
##                        {'terrain_type GB'}; ...
##                        {'base_elevation 0'}; ...
##                        {'base_size 7'}; ...
##                        {'}'}];
MLA = [];

%% -- Lake Border -- %%
bsv = [1 1 1]; t = length(bsv);
ntv = [12 5 14400];

LB.NT = ntv; %Number of Tiles
LB.BS = bsv;  %Base Size
LB.SS = [3]; %Size Scaling
LB.BE = [0]; %Base Elevation
LB.TT = [{'GB'}]; %Terrain Type
LB.CF = [25]; %Clumping Factor
LB.OZA = [6]; %Other Zone Avoidance Distance

Ro = 17;
rr = Ro*linspace(1,(1-0.05*t),t);

nO = 61;
O = linspace(0,360,nO);
Ohd = (O(2) - O(1))/2; %Theta Half-Difference

%% -- Lake Rim Coordinate Crunch -- %%

for i = 1:nO
  LBX(i,:) = rr(1,:).*cosd(O(i)+Ohd*[1:t])+50;
  LBY(i,:) = rr(1,:).*sind(O(i)+Ohd*[1:t])+50;
end
  %

LB.X = LBX; LB.Y = LBY;
[LM_LB,LB] = LandScribeV6(LB,[1 1]);

##%% -- Random Lakes -- %%
##nRL = 12;
##RL.NT = 80; %Number of Tiles
##RL.BS = 3;  %Base Size
##RL.SS = [0]; %Size Scaling
##RL.BE = [1]; %Base Elevation
##RL.TT = [{'DLC_WETROCKBEACH'}]; %Terrain Type
##RL.CF = [25]; %Clumping Factor
##RL.OZA = 12; %other_zone_avoidance_distance
##RL.MPD = 12; %min_placement_distance
##RL.AS = 3;
##RL.Z = [1:1:nRL];
##[LM_RL,RL] = LandScribeV6(RL,[1 1]);
##

LM_RL = [];

Static_List = RMS_Processor_V6([LM_LB; LM_RL]);

k = 1;

for j2 = 1:2

  if j2 == 1
    no = 5;
  else
    no = 6;
  end
  %

  for j1 = 1:2
    %% -- Lake Deep Pools -- %%
    DP.NT = 16; %Number of Tiles
    DP.BS = 1;  %Base Size
    DP.SS = [0]; %Size Scaling
    DP.BE = [0]; %Base Elevation
    DP.TT = [{'DLC_WATER5'}]; %Terrain Type
    DP.CF = [25]; %Clumping Factor
    DP.OZA = 4; %Other Zone Avoidance Distance
    Ri = Ro - 10;


    o = linspace(0,360,no); o(end) = [];
    ohd = (o(2) - o(1))/2;

    %% -- Deep Pool Coordinate Crunch -- %%

    for i = 1:(no-1)
      DPX(i,:) = Ri*cosd(o(i)+ohd*(j1-1))+50;
      DPY(i,:) = Ri*sind(o(i)+ohd*(j1-1))+50;
    end
      %

    DP.X = DPX; DP.Y = DPY;

    [LM_DP,DP] = LandScribeV6(DP,[1 1]);

    [Random_List(k).XY] = [RMS_Processor_V6([LM_DP])];
    k += 1;
    clear LM_DP DP
  end
  %
end
%

[Total_List] = [Static_List; RMS_RS_V3([1 1],[1 1],{'C'},Random_List)];



##CODE = [Preface; MLP; List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE
CODE = [Preface; MLP; Total_List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV10('Isolated_Lakes_V2.ods')
