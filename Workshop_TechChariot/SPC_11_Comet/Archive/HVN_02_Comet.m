%Comet Land Generation
%BPDrej
%1.31.23

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

b = 32;
ecc = 0.30;
for i=1:360
r(i,1) = b/sqrt(1-(ecc*cosd(i))^2);
x(i,1) = r(i,1)*cosd(i);
y(i,1) = r(i,1)*sind(i);
end
%
M = [x y]; CC = [62 62];
tail1 = LandScribeV5([{'GRASS'}],[{0}],{[0 -20]},{45},{'0*x'},{1},{1},[-60 -9]);
tail2 = LandScribeV5([{'GRASS'}],[{0}],{[0 20]},{45},{'0*x'},{1},{1},[-60 -9]);
TL = LandScribeV5([{'DIRT'}],[{0}],{CC},{45},{M},{1});
tag = [{'if P2'};{'elseif P4'};{'elseif P6'};{'elseif P8'};{'endif'}];

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

G = [{[20 22]}; {45}; {[170 180 190]}; {45}; {[0.15]}; {0.6}; {[CC; CC]}];
C = [{1}; {0}; {14400}; {0}; {0}; {[0 0 0 0]}];

[create_player_lands] = RMS_CPL_V9(G,C);


COMMAND = [RMS_Processor_V4([TL; tail1; tail2],LPM_exp); create_player_lands];

MLA = [{'L { terrain_type GRASS land_position 1 1 base_size 0 number_of_tiles 12000 }'}];


##%ObjectAutoscribeV8('Comet.ods')
CODE = [Preface; COMMAND; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

