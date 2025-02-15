%Confluence Land Generation
%TechChariot & Jasuni
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

p1 = [0 16]'; %Offset from center of map
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
  PZA = 14; %player zone avoidance
  [PL] = RMS_CPL_V10([{[24 25]}; {[44 45 46]}; {[175 180 185]}; {O(i)-90}; {0.25}; {0.6}; {C}],[{1}; {4}; {14400}; [1 PZA; 2 PZA; 1 PZA; 2 PZA; 1 PZA; 2 PZA; 1 PZA; 2 PZA]]);

  %% -- Mountain Slopes -- %%
  nM = 5; %Number of Neutral Lands
  MTNX = 50*ones(nM,1);        %X Land Position
  MTNY = linspace(-5,25,nM)';  %Y Land Position
  MTN.TT = {'MT'}; %Terrain Type
  MTN.BE = 1; %Base Elevation
  Bmax = 11;    MTN.BS = [Bmax:-2:(Bmax-nM+1)]'; %Base Size
  MTN.NT = 5*[400; 200; 100; 50; 25]; %Mountain Number of Tiles
  MTN.CF = [25];            %Mountain Clumping Factor
  MTN.SS = [3];             %Mountain Size Scaling Behavior (both)
  MTN.Z = 3;                %Mountain Zone
  MTN.OZA = 8;              %Mountain Other Zone Avoidance

  [MTNX,MTNY] = SimpleRotate(MTNX,MTNY,O(i)); %Neutral Land Simple Rotate Function

  MTN.X = MTNX; MTN.Y = MTNY;

  %% -- Adding Land Compilations -- %%
  [LM_MTN,MTN] = LandScribeV6(MTN,[1 1]);


  clear MTN MTNX MTNY

  COMMAND(i).XY = [PL; RMS_Processor_V6([LM_MTN])];

end
%

SCRIPT = RMS_RS_V2(O,{'C'},COMMAND);

MLP = [{[]}];

CODE = [Preface; MLP; SCRIPT; PL]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('Heidelberg.ods')


