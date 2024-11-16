%Mars Land Generation
%TechChariot
%02.19.2024

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

G = [{[28 29 30 31]}; {[42 45 48]}; {[172 176 180 184 188]}; {[-45 45]}; {[0.05 0.075]}];
C = [{2}; {2}];

[PL] = RMS_CPL_V10(G,C);


%% -- Section on Space -- %%

SPC.TT = {'NNB'};   %terrain type
SPC.BE = 0;         %base elevation
SPC.BS = 0;
%SPC.Z = 1; SPC.OZA = 0;
SPC.X = [1 99; 1 99]; SPC.Y = [1 1; 99 99];
[LM_SPC,SPC] = LandScribeV6(SPC,[1 1]);

%% -- Section on General Mountain -- %%

MTN.TT = {'GRASS2'};  %terrain type
MTN.BE = 2;         %base elevation
MTN.BS = 0;
MTN.X = [35 65; 35 65]; MTN.Y = [35 35; 65 65];
[LM_MTN,MTN] = LandScribeV6(MTN,[1 1]);


%% -- Section on Peak -- %%

PK.TT = {'GRASS2'};  %terrain type
PK.BE = 15;         %base elevation
PK.BS = 9;
PK.NT = 600;
PK.SS = 3;
PK.CF = 25;
PK.X = [50]; PK.Y = [50];
[LM_PK,PK] = LandScribeV6(PK,[1 1]);



%% -- Section on Border -- %%
R = [41:-8:25];
nR = length(R);
%elev = linspace(2,6,nR);
s = ones(1,nR);
k = 0;
for i = 1:length(R)

  if k == 0
    s(i) = 0;
    k = 1;
  else
    k = 0;
  end

end
%

spacing = 11*s+1;
tilecount = 35*s;

K = 1;
for i1 = 1:1
  for i2 = 1:1
    for j = 1:length(R)

      BORDER.TT = {'MARTIAN_BORDER_TER'};  %terrain type
      BORDER.BE = 2;         %base elevation

      BORDER.NT = tilecount(j);
      BORDER.BS = 1;
      BORDER.SS = 2;
      BORDER.CF = 0;

      BORDER_X = []; BORDER_Y = [];
      for i = 1:spacing(j):360
        BORDER_X = [BORDER_X; R(j)*cosd(i)+50]; BORDER_Y = [BORDER_Y; R(j)*sind(i)+50];
      end
      %
      BORDER.X = BORDER_X; BORDER.Y = BORDER_Y;
      [LM_BORDER,~] = LandScribeV6(BORDER,[1 1]);
      if j == 1
        [COMMAND(K).XY] = [RMS_Processor_V6([LM_BORDER])];
      else
        [COMMAND(K).XY] = [COMMAND(K).XY; RMS_Processor_V6([LM_BORDER])];
      end
      %
      clear BORDER
    end
    %
    clear LM_BORDER
    K += 1;
  end

end
%
Neutral_Dynamic_List = RMS_RS_V2(1,1,{'C'},COMMAND);
clear COMMAND

K = 1; d = 9;
V = [1:2];
for i1 = V

  MOON.TT = {'NNB'}; MOON.BE = 1; BORDER.CF = 25;

  MOON.NT = 50;
  MOON.BS = 2;
  MOON.SS = 3;
%  MOON.Z = 1;
%  MOON.OZA = 0;
  MOON.w = [93]; MOON.v = [93];

  if   i1 == 1
    MOON.XB = [d 100-d];
    MOON.YB = [d 100-d];
    CLK = 45
  else i1 == 2
    MOON.XB = [d 100-d];
    MOON.YB = [100-d d];
    CLK = -45;
  end
  %
  MOON.XG = 50; MOON.YG = 50;

  [LM_MOON,~] = LandScribeV6(MOON,[1 1]);

  [COMMAND(K).XY] = [RMS_Processor_V6([LM_MOON])];
  clear MOON LM_MOON
  K += 1;

end
%
Moon_Dynamic_List = RMS_RS_V2(V,{'D'},COMMAND);
clear COMMAND


Static_List  = RMS_Processor_V6([LM_SPC; LM_MTN; LM_PK]);

CODE = [Preface; PL; Neutral_Dynamic_List; Moon_Dynamic_List; Static_List]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV9('HVN_10_Mars.ods')
