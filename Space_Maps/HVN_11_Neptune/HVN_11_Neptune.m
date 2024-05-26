%Neptune Land Generation
%BPDrej
%2.24.2024

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

b = 20;
b1 = 34;
b2 = 46;
for i=1:360
x(i,1) = b*cosd(i);
y(i,1) = b*sind(i);
x1(i,1) = b1*cosd(i);
y1(i,1) = b1*sind(i);
x2(i,1) = b2*cosd(i);
y2(i,1) = b2*sind(i);
end
%
M = [x y]; CC = [50 50];
M1 = [x1 y1]; CC = [50 50];
M2 = [x2 y2]; CC = [50 50];

R = LandScribeV5([{'WATER'}],[{0}],{CC},{45},{M},{1});
R1 = LandScribeV5([{'DLC_WATER5'}],[{0}],{CC},{45},{M1},{1});
R2 = LandScribeV5([{'DLC_WATER5'}],[{0}],{CC},{45},{M2},{1});

COMMAND = [RMS_Processor_V4([R; R1; R2],LPM_exp); ];

MLA = [{'create_player_lands { terrain_type DLC_MANGROVESHALLOW 0 base_size 9 land_percent 100 if TINY_MAP circle_radius 40 0 elseif SMALL_MAP circle_radius 40 0 elseif MEDIUM_MAP circle_radius 40 0 elseif LARGE_MAP circle_radius 40 0 elseif HUGE_MAP circle_radius 40 0 else circle_radius 40 0 endif }'}];
MLA2 = [{'L { terrain_type WATER land_position 50 50 base_elevation 1 number_of_tiles 100000 } L { terrain_type DLC_MANGROVESHALLOW land_position 1 1 number_of_tiles 100000 } L { terrain_type DLC_MANGROVESHALLOW land_position 30 30 number_of_tiles 100000 } '}];

%ObjectAutoscribeV8('ObjectDatabase.ods')
CODE = [Preface; MLA; MLA2; COMMAND]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

