%Saturn Land Generation
%BPDrej
%3.28.23

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

b = 25;
b1 = 35;
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

R = LandScribeV5([{'DESERT'}],[{0}],{CC},{45},{M},{1});
R1 = LandScribeV5([{'DESERT'}],[{0}],{CC},{45},{M1},{3});
R2 = LandScribeV5([{'DESERT'}],[{0}],{CC},{45},{M2},{3});

COMMAND = [RMS_Processor_V4([R; R1; R2],LPM_exp); ];

MLA = [{'create_player_lands { terrain_type DIRT 0 base_size 6 base_elevation 1 land_percent 100 clumping_factor 15 zone 1 other_zone_avoidance_distance 0 if TINY_MAP circle_radius 15 0 elseif SMALL_MAP circle_radius 18 0 elseif MEDIUM_MAP circle_radius 18 0 elseif LARGE_MAP circle_radius 19 0 elseif HUGE_MAP circle_radius 20 0 else circle_radius 20 0 endif }'}];


%ObjectAutoscribeV8('ObjectDatabase.ods')
CODE = [Preface; MLA; COMMAND]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

