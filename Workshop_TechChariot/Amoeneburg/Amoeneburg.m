%Amoeneburg Land Generation
%TechChariot
%2024-12-15

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%% -- Section on Outland -- %%

nO = 10;
O = 45+ linspace(0,360,nO)';
hdO = (O(2)-O(1))/2;

R = [38 50];
k = 3;

for i = 1:nO
  for j = 1:length(R)

    x(i,j) = R(j)*sind(O(i)+hdO*j)+50;
    y(i,j) = R(j)*cosd(O(i)+hdO*j)+50;


  end
  z(i,1) = k;
  k += 1;
end
%

LAND.X = x; LAND.Y = y;

LAND.TT = {'GRASS'};
LAND.NT = 14400;
##LAND.NT = 0;
LAND.v = [26 60];
LAND.w = [26 60];
LAND.BE = 1;
LAND.BS = 4;
LAND.CF = 25;
LAND.OZA = 5;
LAND.Z = z;
[LM_LAND,LAND] = LandScribeV6(LAND,[1 1]);



%% -- Section on Outland -- %%
CITY.X = 50; CITY.Y = 50;

CITY.TT = {'GRASS3'};
CITY.v = 34;
CITY.w = 34;
CITY.NT = 14400;
##CITY.NT = 0;
CITY.BS = 2;
CITY.BE = 1;
CITY.SS = 1;
##LAND.CF = 25;


[LM_CITY,CITY] = LandScribeV6(CITY,[1 1]);

%% -- -- %%

[COMMAND] = [RMS_Processor_V6([LM_LAND; LM_CITY])];


MLP = [{['create_player_lands { terrain_type BT base_elevation 7 base_size 5 number_of_tiles 0 circle_radius 17 0 }']}];

CODE = [Preface; MLP; COMMAND]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('Amoeneburg.ods')


