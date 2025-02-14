%Shorts Land Generation
%TechChariot & Zetnus
%2025-02-14

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

p1 = [0 0]'; %Offset from center of map
p2 = [0 -40]'; %Perpendicular offset from other team focal point

%% -- Rotation-Dependent Sections -- %%
O  = linspace(0,180,11); %Seed Angle [deg]
##O  = 0; %Seed Angle [deg]

for i = 1:length(O)
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
  %      {[Zones (1-8), Avoidances (#-#)]}; ...
  %      {Linear Slop};
  %      {[left right top bottom] border avoidances}]  (characteristic inputs)

  TM1 = [cosd(O(i)) -sind(O(i)); sind(O(i)) cosd(O(i))];
  TM2 = [cosd(90+O(i)) -sind(90+O(i)); sind(90+O(i)) cosd(90+O(i))];
  pt1 = TM1*p1; pt2 = TM2*p2;
  C = 50 + [pt1'; pt1'] + [+pt2'; -pt2'];

  [PL] = RMS_CPL_V10([{[24 25]}; {[44 45 46]}; {[175 180 185]}; {O(i)-90}; {0.25}; {0.6}; {C}],[{1}; {12}; {14400}]);

  %% -- Mountain Slopes -- %%
  nM = 5; %Number of Neutral Lands
  MTNX = 50*ones(nM,1);        %X Land Position
  MTNY = linspace(-5,35,nM)';  %Y Land Position
  MTN.TT = {'MT'}; %Terrain Type
  Emax = 12;   MTN.BE = [Emax:-1:(Emax-nM+1)]'; %Base Elevation
  Bmax = 5;    MTN.BS = [Bmax:-1:(Bmax-nM+1)]'; %Base Size
  MTN.NT = [250; 200; 150; 100; 50]; %Mountain Number of Tiles
  MTN.CF = [25];            %Mountain Clumping Factor
  MTN.SS = [3];             %Mountain Size Scaling Behavior (both)
  MTN.v  = [25 20 15 10 5]; %Mountain Growth Window X
  MTN.w  = [25 20 15 10 5]; %Mountain Growth Window Y

  [MTNX,MTNY] = SimpleRotate(MTNX,MTNY,O(i)); %Neutral Land Simple Rotate Function

  MTN.X = MTNX; MTN.Y = MTNY;

  %% -- Oceanic Lands -- %%
  OL.TT = {'OL'};
  OL.BE = [0];
  OL.NT = [80];
  OL.BS = [2];
  OL.SS = [3];

  nOL = 21;
  OLX = linspace(-10,110,nOL); OLX = [1; 1; 1; 1]*OLX;
  OLY = [92; 96; 100; 104]; OLY = OLY*ones(1,nOL);

  [OLX,OLY] = SimpleRotate(OLX,OLY,O(i)); %Neutral Land Simple Rotate Function

  OL.X = OLX; OL.Y = OLY;

  %% -- Adding Land Compilations -- %%
  [LM_MTN,MTN] = LandScribeV6(MTN,[1 1]);
  [LM_OL,OL]   = LandScribeV6(OL,[1 1]);

  clear MTN MTNX MTNY OL OLX OLY

  COMMAND(i).XY = [PL; RMS_Processor_V6([LM_MTN; LM_OL])];

end
%

SCRIPT = RMS_RS_V2(O,{'C'},COMMAND);

MLP = [{[]}];

CODE = [Preface; MLP; SCRIPT; PL]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('Heidelberg.ods')


