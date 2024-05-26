%Return of the Rising Eagle Cup Arabia Land Generation
%TechChariot
%3.04.23

clear all
close all
clc

pkg load image

tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%load 'Eagle_Points_M14'
%load 'Eagle_Points_M15'
%load 'Eagle_Points_M16'
load 'Eagle_Points_M18'

C = [55 45]; MLA = [{['L { terrain_type DLC_BLACK base_size 0 land_position ' num2str(C(1)) ' ' num2str(C(2)) ' } ']}];
B = LandScribeV5([{'GRASS'}],[{0}],{C},{0},{M},{0});
COMMAND = RMS_Processor_V4(B,LPM_exp);

% G = [{Vector of Radii}; ...
%      {Vector of Angular Offsets Between Flank and Pocket}; ...
%      {Vector of Angular Distance to Centroid of Teams}; ...
%      {Vector of Clocking "Seed Angles"}; ...
%      {Vector of Team Biases}; ...
%      {Vector of Eccentricities}]; (geometric inputs)
%
% C = [{Base Elevation}; ...
%      {Base Size}; ...
%      {Land Percent}; ...
%      {Zone Avoidance}; ...
%      {Linear Slop}];  (characteristic inputs)

[PL] = RMS_CPL_V7([{[28 30 32]}; {[43 45 47]}; {[170 175 180 185 190]}; {[-45 -30 -15 0 15 30 45]}; {[0 0.05]}; {[1]}],[{0}; {0}; {0}; {0}; {0}]);
%[PL] = RMS_CPL_V7([{[28 30 32]}; {[43 45 47]}; {[170 180 190]}; {[0]}; {[0 0.05]}; {[1]}],[{0}; {0}; {0}; {0}; {0}]);


%for j = 1:length(O)
%Boundary_Rand1(j).XY  = [LandScribeV5({'K'},{0},{0 +06},O(j),{['150*sin(2*pi*x/25)./x']},{2},{4},[-80 80])];
%
%Combined(j).XY     = [Upland];
%end
%%
%
%RMS_RS_V3(O,{'C'},COMMAND)



%
%ObjectAutoscribeV8('RREC_Arabia.ods')
%CODE = [Preface; Size_List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

CODE = [Preface; PL; COMMAND; MLA;];
RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc
