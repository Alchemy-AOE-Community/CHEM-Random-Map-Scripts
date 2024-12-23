%Jupiter Land Generation
%TechChariot
%01.30.2024

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);


%% -- Section on Player Lands -- %%

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

G = [{[28 29 30 31]}; {[40 45 50]}; {[170 175 180 185 190]}; {-45}; {[0 0.05]}];
C = [{2}; {10}];

[PL] = RMS_CPL_V9(G,C);


%% -- Section on Border -- %%
R = 40;
BORDER.TT = {'JOVIAN_BORDER_TER'};  %terrain type
BORDER.BE = 1;         %base elevation

BORDER.NT = 0;
BORDER.BS = 2;
BORDER.SS = 0;

BORDER_X = []; BORDER_Y = [];

for i = 1:360
  BORDER_X = [BORDER_X; (R+1)*cosd(i)+50]; BORDER_Y = [BORDER_Y; (R+1)*sind(i)+50];
end
%
BORDER.X = BORDER_X; BORDER.Y = BORDER_Y;
[LM_BORDER,BORDER] = LandScribeV6(BORDER,[1 1]);


%% -- Section on Satellite Boundary -- %%
SAT_BOUND.TT = {'SATELLITE_TER'};  %terrain type
SAT_BOUND.BE = 1;         %base elevation

SAT_BOUND.NT = 0;
SAT_BOUND.BS = 2;
SAT_BOUND.SS = 1;

SAT_BOUND_X = []; SAT_BOUND_Y = [];
S = 14; %Radius of Satellite
CRN = [1 99];
for k = 1:2
  for j = 1:2
    for i = 1:360
      SAT_BOUND_X = [SAT_BOUND_X; S*cosd(i)+CRN(k)]; SAT_BOUND_Y = [SAT_BOUND_Y; S*sind(i)+CRN(j)];
    end
  end
end
%

SAT_BOUND.X = SAT_BOUND_X; SAT_BOUND.Y = SAT_BOUND_Y;
[LM_SAT_BOUND,SAT_BOUND] = LandScribeV6(SAT_BOUND,[1 1]);

%% -- Section on Satellite Core -- %%
SAT_CORE.TT = {'SATELLITE_TER'};  %terrain type
SAT_CORE.BE = 1;         %base elevation

SAT_CORE.BS = 2;
SAT_CORE.SS = 1;
SAT_CORE.X = [1 99 1 99]; SAT_CORE.Y = [1 1 99 99];

[LM_SAT_CORE,SAT_CORE] = LandScribeV6(SAT_CORE,[1 1]);


%% -- Section on Void -- %%
VOID.TT = {'VOID_TER'};  %terrain type
VOID.BE = 0;             %base elevation
VOID.BS = 0;
VOID.SS = 2;
VOID.X = [50 1 100 50]; VOID.Y = [1 50 50 100];

[LM_VOID,VOID] = LandScribeV6(VOID,[1 1]);


%% -- Section on Stripes and Storm -- %%


xR = R; xS = 10; yR = R; yS = 0.5;
nx = 2*xR/xS + 1; ny = 2*yR/yS + 1;

r = [0:1:5];
STORM_X = []; STORM_Y = [];
for j = 1:length(r)
  for i = 1:360
    STORM_X = [STORM_X; r(j)*cosd(i)]; STORM_Y = [STORM_Y; r(j)*sind(i)];
  end
end
%
O = [-35 -45 -55];
STORM_C = [35 65; 65 35];

K = 1; [nxSTRM,~] = size(STORM_C);
for i1 = 1:nxSTRM

  STORM.TT = {'STORM_TER'};  %terrain type
  STORM.BE = 1;        %base elevation
  STORM.NT = 0;
  STORM.BS = 1;
  STORM.SS = 0;

  STORM.X = STORM_X+STORM_C(i1,1); STORM.Y = STORM_Y+STORM_C(i1,2);
  [LM_STORM(i1).XY,STORM] = LandScribeV6(STORM,[1 1]);


  for i2 = 1:length(O);

    STRIPES.TT = {'STRIPES_TER'};  %terrain type
    STRIPES.BE = 2;         %base elevation

    STRIPES.NT = 0;
    STRIPES.BS = 2;
    STRIPES.SS = 1;

    STRIPES_X = [-xR:xS:xR]'*ones(1,ny)+50; %Reinitializing Stripes
    STRIPES_Y = ones(nx,1)*[-yR:yS:yR]+50;  %Reinitializing Stripes

    [STRIPES_X,STRIPES_Y] = SimpleRotate([STRIPES_X],[STRIPES_Y],[O(i2)]); %Rotating Stripes
    STRIPES.X = STRIPES_X; STRIPES.Y = STRIPES_Y;

    [LM_STRIPES,STRIPES] = LandScribeV6(STRIPES,[1 1]);

    STRIPES_XB = (cell2mat(LM_STRIPES(:,2)) + cell2mat(LM_STRIPES(:,3)))/2; STRIPES_YB =  (cell2mat(LM_STRIPES(:,4)) + cell2mat(LM_STRIPES(:,5)))/2;

    k = 1;
    for i = 1:length(LM_STRIPES(:,1))
      D(i,1) = sqrt((STRIPES_XB(i,1)-50)^2+(STRIPES_YB(i,1)-50)^2);
      d(i,1) = sqrt((STRIPES_XB(i,1)-STORM_C(i1,1))^2+(STRIPES_YB(i,1)-STORM_C(i1,2))^2);
      if D(i,1) > R || d(i,1) < (max(r)+5)
      else
        LM_STRIPES_ROUND(i2).XY(k,:) = LM_STRIPES(i,:);
        k += 1;
      end
      %
    end
    %

    [COMMAND(K).XY] = [RMS_Processor_V6([LM_STORM(i1).XY; LM_STRIPES_ROUND(i2).XY])];
    K += 1;
    clear STRIPES
  end
  clear STORM
end
%
Dynamic_List = RMS_RS_V2(STORM_C(:,1),O,{'C'},COMMAND);
Static_List  = RMS_Processor_V6([LM_BORDER; LM_SAT_BOUND; LM_SAT_CORE; LM_VOID]);

CODE = [Preface; PL; Dynamic_List; Static_List]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV9('HVN_05_Jupiter.ods')
