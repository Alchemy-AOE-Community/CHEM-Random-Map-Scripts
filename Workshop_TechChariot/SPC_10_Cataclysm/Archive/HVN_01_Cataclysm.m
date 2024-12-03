%Cataclysm Land Generation
%BPDrej
%11.11.23

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

##b = 32
##b1 = 18;
##ecc = 0.30;
##for i=1:360
##r(i,1) = b/sqrt(1-(ecc*cosd(i))^2);
##x(i,1) = r(i,1)*cosd(i);
##y(i,1) = r(i,1)*sind(i);
##r1(i,1) = b1/sqrt(1-(ecc*cosd(i))^2);
##x1(i,1) = r1(i,1)*cosd(i);
##y1(i,1) = r1(i,1)*sind(i);
##end
##
##%
##M = [x y]; CC = [60 40];
##M1 = [x1 y1]; CC1 = [30 70];
##
##R = LandScribeV5([{'GRASS'}],[{0}],{CC},{45},{M},{1});
##R1 = LandScribeV5([{'WG'}],[{0}],{CC1},{45},{M1},{1});
##tag = [{'if P2'};{'elseif P4'};{'elseif P6'};{'elseif P8'};{'endif'}];

%% -- CPL_V9 INPUT FORMAT -- %%
% G = [{Vector of Radii}; ...
%      {Vector of Angular Offsets Between Flank and Pocket}; ...
%      {Vector of Angular Distance to Centroid of Teams}; ...
%      {Vector of Clocking "Seed Angles"}; ...
%      {Vector of Team Biases}; ...
%      {Vector of Eccentricities}; ...
%      {Matrix of Team Centers}] (geometric inputs)

% C = [{Base Elevation}; ...
%      {Base Size}; ...
%      {Number of Tiles}; ...
%      {Zone Avoidance}; ...
%      {Linear Slop};
%      {[left right top bottom] border avoidances}]  (characteristic inputs)
CC1 = [25 25];
CC2 = [75 75];
G = [{[19 20 21]}; {45}; {180}; {-45}; {[0.4 .45]}; {[.5 .525 .55 .575 .6]}; {[CC1; CC2]}];
C = [{0}; {3}; {100}; {0}; {0}; {[0 0 0 0]}];


[create_player_lands] = RMS_CPL_V9(G,C);


##COMMAND = [RMS_Processor_V4([R; R1],LPM_exp);];

##MLA = [{'L { terrain_type GRASS land_position 1 1 base_size 0 number_of_tiles 12000 }'}];


##%ObjectAutoscribeV8('Comet_V2.ods')
##CODE = [Preface; COMMAND]; %Adding Preface, Definitions, Random Statement to beginning of CODE
CODE = [Preface; create_player_lands]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

