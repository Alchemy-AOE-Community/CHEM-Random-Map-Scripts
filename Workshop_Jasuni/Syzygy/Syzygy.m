%Syzygy Land Generation
%BPDrej
%11.16.23

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);


r1 = [0:22]; nr1 = length(r1);
r2 = [0:22]; nr2 = length(r2);
r3 = [0:22]; nr3 = length(r3);
r4 = [0:22]; nr4 = length(r4);

for i=1:360
for j = 1:nr1
x1(i,j) = r1(j)*cosd(i);
y1(i,j) = r1(j)*sind(i);
end
%
for j=1:nr2
x2(i,j) = r2(j)*cosd(i);
y2(i,j) = r2(j)*sind(i);
end
%
for j=1:nr3
x3(i,j) = r3(j)*cosd(i);
y3(i,j) = r3(j)*sind(i);
end
%
for j=1:nr4
x4(i,j) = r4(j)*cosd(i);
y4(i,j) = r4(j)*sind(i);
end
%
end
%
x1 = reshape(x1,360*nr1,1);
y1 = reshape(y1,360*nr1,1);
x2 = reshape(x2,360*nr2,1);
y2 = reshape(y2,360*nr2,1);
x3 = reshape(x3,360*nr3,1);
y3 = reshape(y3,360*nr3,1);
x4 = reshape(x4,360*nr4,1);
y4 = reshape(y4,360*nr4,1);

M1 = [x1 y1]; CC1 = [70 30];
M2 = [x2 y2]; CC2 = [55 45];
M3 = [x3 y3]; CC3 = [45 55];
M4 = [x4 y4]; CC4 = [30 70];

R1 = LandScribeV5([{'PN1'}],[{2}],{CC1},{0},{M1},{1});
R2 = LandScribeV5([{'PN2'}],[{2}],{CC2},{0},{M2},{1});
R3 = LandScribeV5([{'PN3'}],[{2}],{CC3},{0},{M3},{1});
R4 = LandScribeV5([{'PN4'}],[{2}],{CC4},{0},{M4},{1});
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

G = [{[20 24]}; {45}; {180}; {45}; {[0.15]}; {0.6}; {[CC1; CC1]}];
C = [{1}; {0}; {14400}; {0}; {0}; {[0 0 0 0]}];
[create_player_lands] = RMS_CPL_V9(G,C);

off1 = -14; off2 = 1;  off3 = 18;
xr1  =  22; xr2 =  21; xr3 =  15;

L1 = [LandScribeV5({'PN1'},{0},{[0 off1]},{45},{'0*x'},{1},{0},[-75 -xr1]); ...
      LandScribeV5({'PN1'},{0},{[0 off1]},{45},{'0*x'},{1},{0},[xr1 75])];
L2 = [LandScribeV5({'PN2'},{0},{[0 off2]},{45},{'0*x'},{1},{0},[-75 -xr2]); ...
      LandScribeV5({'PN2'},{0},{[0 off2]},{45},{'0*x'},{1},{0},[xr2 75])];
L3 = [LandScribeV5({'PN3'},{0},{[0 off3]},{45},{'0*x'},{1},{0},[-75 -xr3]); ...
      LandScribeV5({'PN3'},{0},{[0 off3]},{45},{'0*x'},{1},{0},[xr3 75])];

COMMAND = [RMS_Processor_V4([L1; L2; L3; R4; R3; R2; R1],LPM_exp);];

MLA = [{'L { terrain_type PN1 land_position 99 1 base_size 0 land_percent 100 }'}; ...
       {'L { terrain_type PN2 land_position 15 4 base_size 0 land_percent 100 }'}; ...
       {'L { terrain_type PN2 land_position 99 95 base_size 0 land_percent 100 }'}; ...
       {'L { terrain_type PN3 land_position 1 5 base_size 0 land_percent 100 }'}; ...
       {'L { terrain_type PN3 land_position 85 96 base_size 0 land_percent 100 }'}; ...
       {'L { terrain_type PN4 land_position  1 99 base_size 0 land_percent 100 }'}];


##%ObjectAutoscribeV8('Comet_V2.ods')
CODE = [Preface; COMMAND; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

