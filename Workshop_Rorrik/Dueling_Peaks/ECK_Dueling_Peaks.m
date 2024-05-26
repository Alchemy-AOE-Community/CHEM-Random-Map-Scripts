%ECK_Dueling_Peaks Player Land Generation
%TechChariot
%4.01.23

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

CODE = Preface;

%% -- INPUT FORMAT -- %%
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

size_prefix = [{'if P12'} {'elseif P34'} {'elseif P56'} {'elseif P78'} {'endif'}];

for i = 1:5
CODE = [CODE; size_prefix(i)];
if i == 1
[PLB] = RMS_CPL_V9([{[20]}; {[45]}; {[170 180 190]}; {[0 45 90]}],[{0}; {0}; {0}; {8}; {0}]); %Player-Land-Base (Town Center)
[PLP] = RMS_CVL_V2([{[07]}; {[45]}; {[170 180 190]}; {[0 45 90]}],[{7}; {0}; {0}; {0}; {0}]); %Circular Variable Land (Castle)
elseif i == 2
[PLB] = RMS_CPL_V9([{[19]}; {[45]}; {[180]}; {[0 45]}],[{0}; {0}; {0}; {8}; {0}]); %Player-Land-Base (Town Center)
[PLP] = RMS_CVL_V2([{[08]}; {[45]}; {[180]}; {[0 45]}],[{7}; {0}; {0}; {0}; {0}]); %Circular Variable Land (Castle)
elseif i == 3
[PLB] = RMS_CPL_V9([{[18]}; {[45]}; {[180]}; {[0 45 90]}],[{0}; {0}; {0}; {8}; {0}]); %Player-Land-Base (Town Center)
[PLP] = RMS_CVL_V2([{[09]}; {[45]}; {[180]}; {[0 45 90]}],[{7}; {0}; {0}; {0}; {0}]); %Circular Variable Land (Castle)
elseif i == 4
[PLB] = RMS_CPL_V9([{[18]}; {[45]}; {[180]}; {[0 45 90]}],[{0}; {0}; {0}; {8}; {0}]); %Player-Land-Base (Town Center)
[PLP] = RMS_CVL_V2([{[11]}; {[45]}; {[180]}; {[0 45 90]}],[{7}; {0}; {0}; {0}; {0}]); %Circular Variable Land (Castle)
elseif i == 5
PLB = []; PLP = [];
else
end
%
CODE = [CODE; PLB; PLP];
end
%

RMS_ForgeV4(filename,CODE);
%ObjectAutoscribeV8('RREC_Arabia.ods')
disp(["Run Completed " datestr(clock) "..."])
toc
