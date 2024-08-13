%Columbia Land Generation
%TechChariot
%24-07-26

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%% -- Mountain Slopes -- %%
f = {'5*exp(x/15)'};
sx = 8; sy = 15;

%[MTNLX,MTNLY] = function_to_points_V3([f; {[02 14]}; {+135}],[-50 50],[-2*sy sy],[sx sx; sy sy]);
%[MTNLX,MTNLY] = function_to_points_V3([f; {[02 14]}; {+135}],[-45 45],[-2*sy sy],[sx sx; sy sy]);
[MTNLX,MTNLY] = function_to_points_V3([f; {[02 04]}; {+135}],[-45 45],[-2*sy sy],[sx sx; sy sy]);
MTNL.X = MTNLX; MTNL.Y = MTNLY;
MTNR.X = 99 - MTNLY; MTNR.Y = 99 - MTNLX;
[nx,ny] = size(MTNLX);


for j = 1:ny
  for i = 1:nx

    if j == 1
      MTNL.BE(i,j) = (nx-i)/nx*6;
    elseif j == 2
      MTNL.BE(i,j) = (nx-i)/nx*12;
    elseif j == 4
      MTNL.BE(i,j) = (nx-i)/nx*9;
    else
      MTNL.BE(i,j) = (nx-i)/nx*6;
    end
    %
  end
end
%

MTNR.BE = MTNL.BE;

MTNL.NT = [220 300; 280 300]*1.4;
%MTNL.NT = 0;
MTNR.NT = MTNL.NT;
%MTNL.BS = [4 2; 4 2];
%MTNL.BS = [3 2; 3 2];
%MTNL.BS = [2 1; 2 1];
MTNL.BS = [1];

MTNR.BS = MTNL.BS;


SB = [22 32; 26 30]; %standard borders
MTNL.v.s1 = SB;
MTNL.v.s2 = SB;
MTNL.w.s1 = SB;
MTNL.w.s2 = SB;
MTNR.v.s1 = MTNL.v.s1;
MTNR.v.s2 = MTNL.v.s2;
MTNR.w.s1 = MTNL.w.s1;
MTNR.w.s2 = MTNL.w.s2;

MTNL.SS = 3;
MTNR.SS = MTNL.SS;

MTNL.CF = 25;
MTNR.CF = MTNL.CF;

MTNL.TT = {'MUD'};
MTNR.TT = MTNL.TT;

MTNL.OZA = [26:-1:4]';
%MTNL.OZA = [28:-1:5]';
MTNR.OZA = MTNL.OZA;

%%MTNL.OZA = [22:-1:5]';
%%MTNR.OZA = MTNL.OZA;

MTNL.Z = 1;
MTNR.Z = 3;

[LM_MTNL,MTNL] = LandScribeV6(MTNL,[1 1]);
[LM_MTNR,MTNR] = LandScribeV6(MTNR,[1 1]);


% -- Moraine -- %%
[SMILEX,SMILEY] = function_to_points_V3([{'-0.02*x.^2'}; {[18 82]}; {045}],[-18 18],[0 0],[2 2; 10 10]);
SMILE.X = SMILEX; SMILE.Y = SMILEY;

SMILE.Z   = 2;
SMILE.OZA = 4;

SMILE.NT = 40;
SMILE.BS = 3;
SMILE.SS = 3;
SMILE.TT = {'DLC_CRACKED'};
[LM_SMILE,SMILE] = LandScribeV6(SMILE,[1 1]);


%% -- Basin -- %%
BASIN.X = [34 44]; BASIN.Y = [56 66];
BB = 16;
BASIN.v = BB;
BASIN.w = BB;

BASIN.Z   = [1 3];
BASIN.OZA = 2;

BASIN.NT = 320;
BASIN.BS = 4;
BASIN.SS = 3;
BASIN.CF = 25;
BASIN.TT = {'DLC_DESERTGRAVEL'};

[LM_BASIN,BASIN] = LandScribeV6(BASIN,[1 1]);

%% -- Sea -- %%

SEA.X = [0]; SEA.Y = [99];

SEA.Z   = [4];
SEA.OZA = 1;

SEA.BS = 1;
SEA.SS = 3;
SEA.CF = 25;
SEA.TT = {'GRASS'};
%SEA.NT = 0;

[LM_SEA,SEA] = LandScribeV6(SEA,[1 1]);

%% -- Outcropping -- %%

OC.X = [99]; OC.Y = [0];

OC.Z   = [4];
OC.OZA = 6;

OC.BS = 2;
OC.NT = 60;
OC.SS = 3;
OC.CF = 25;
OC.BE = 8;
OC.TT = {'SNOW'};

OC.v = 8;
OC.w = 8;

[LM_OC,OC] = LandScribeV6(OC,[1 1]);

% -- Seed Elevation -- %

%SE.X = [70:-10:50]; SE.Y = 99 - SE.X;
%
%SE.Z.s1   = [1];
%SE.Z.s2   = [3];
%SE.OZA = 0;
%
%SE.BS = 0;
%SE.NT = 0;
%SE.SS = 0;
%SE.CF = 25;
%SE.BE = 4;
%SE.TT = {'NNGB'};
%
%[LM_SE,SE] = LandScribeV6(SE,[1 1]);
LM_SE = [];

%% -- Processor -- %%

[COMMAND] = [RMS_Processor_V6([LM_MTNL; LM_MTNR; LM_SMILE; LM_BASIN; LM_SEA; LM_OC; LM_SE])];

%[CPL] = RMS_CPL_V10([{[35]}; {[45]}; {[180]}; {[-45]}; {[0]}; {0}; {[80 80; 20 20]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]); %flip concavity
%[CPL] = RMS_CPL_V10([{[35]}; {[45]}; {[180]}; {[-45]}; {[0]}; {0}; {[90 70; 30 10]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]); %moved up
%[CPL] = RMS_CPL_V10([{[35]}; {[45]}; {[180]}; {[-45]}; {[0]}; {0}; {[100 70; 30 00]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]); %dragged centers out
%[CPL] = RMS_CPL_V10([{[35]}; {[45]}; {[160]}; {[-45]}; {[0]}; {0}; {[100 70; 30 00]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]); %angled downward
%[CPL] = RMS_CPL_V10([{[35]}; {[45]}; {[160]}; {[-45]}; {[0]}; {0}; {[95 75; 25 05]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]); %moved down slightly
%[CPL] = RMS_CPL_V10([{[45]}; {[45]}; {[160]}; {[-45]}; {[0]}; {0}; {[95 75; 25 05]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]); %expanded radius
%[CPL] = RMS_CPL_V10([{[45]}; {[45]}; {[160]}; {[-45]}; {[0.2]}; {0}; {[95 75; 25 05]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %increasing team bias factor
%[CPL] = RMS_CPL_V10([{[45]}; {[45]}; {[160]}; {[-45]}; {[0.2]}; {0}; {[105 75; 25 -05]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %dragged centers out
%[CPL] = RMS_CPL_V10([{[45]}; {[45]}; {[160]}; {[-45]}; {[0.2]}; {0}; {[100 80; 20 00]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %moved down slightly
%[CPL] = RMS_CPL_V10([{[45]}; {[45]}; {[160]}; {[-45]}; {[0.3]}; {0}; {[100 80; 20 00]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %more team bias
%[CPL] = RMS_CPL_V10([{[50]}; {[45]}; {[160]}; {[-45]}; {[0.3]}; {0}; {[100 80; 20 00]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %expanded radius
%[CPL] = RMS_CPL_V10([{[50]}; {[45]}; {[160]}; {[-45]}; {[0.3]}; {0}; {[105 80; 20 -05]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %dragged centers out
%[CPL] = RMS_CPL_V10([{[50]}; {[45]}; {[154]}; {[-45]}; {[0.3]}; {0}; {[105 80; 20 -05]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %angled downward
%[CPL] = RMS_CPL_V10([{[50]}; {[45]}; {[154]}; {[-45]}; {[0.34]}; {0}; {[105 80; 20 -05]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %more team bias
%[CPL] = RMS_CPL_V10([{[50]}; {[45]}; {[154]}; {[-45]}; {[0.34]}; {0}; {[110 80; 20 -10]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %dragged centers out
%[CPL] = RMS_CPL_V10([{[50]}; {[45]}; {[154]}; {[-45]}; {[0.34]}; {0}; {[108 82; 18 -08]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %moved downward
%[CPL] = RMS_CPL_V10([{[50]}; {[45]}; {[154]}; {[-45]}; {[0.36]}; {0}; {[108 82; 18 -08]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %more team bias
%[CPL] = RMS_CPL_V10([{[56]}; {[45]}; {[154]}; {[-45]}; {[0.36]}; {0}; {[108 82; 18 -08]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %larger radius
%[CPL] = RMS_CPL_V10([{[56]}; {[45]}; {[154]}; {[-45]}; {[0.44]}; {0}; {[108 82; 18 -08]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %more team bias
%[CPL] = RMS_CPL_V10([{[56]}; {[45]}; {[154]}; {[-45]}; {[0.44]}; {0}; {[115 82; 18 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %dragged centers out
%[CPL] = RMS_CPL_V10([{[56]}; {[45]}; {[154]}; {[-45]}; {[0.44]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %moved downward
%[CPL] = RMS_CPL_V10([{[62]}; {[45]}; {[154]}; {[-45]}; {[0.44]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %expanded radius
%[CPL] = RMS_CPL_V10([{[62]}; {[45]}; {[154]}; {[-45]}; {[0.50]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %more team bias
%[CPL] = RMS_CPL_V10([{[62]}; {[45]}; {[154]}; {[-45]}; {[0.50]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %end


%[CPL] = RMS_CPL_V10([{[58 62]}; {[42 52]}; {[152 156]}; {[-45]}; {[0.50 0.60]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]); %limits

%[CPL] = RMS_CPL_V10([{[58 59 60 61 62]}; {[42 44 46 48 50 52]}; {[152 153 154 155 156]}; {[-45]}; {[0.500 0.525 0.55 0.575 0.600]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %randomizer

%[CPL] = RMS_CPL_V10([{[58 59 60 61 62]}; {[42 44 46 48 50 52]}; {[162 163 164 165 166]}; {[-45]}; {[0.500 0.525 0.55 0.575 0.600]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %randomizer
%[CPL] = RMS_CPL_V10([{[57 58 59 60 61]}; {[42 44 46 48 50 52]}; {[162 163 164 165 166]}; {[-45]}; {[0.500 0.525 0.55 0.575 0.600]}; {0}; {[115 90; 10 -15]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %randomizer
[CPL] = RMS_CPL_V10([{[57 58 59 60 61]}; {[42 44 46 48 50 52]}; {[162 163 164 165 166]}; {[-45]}; {[0.500 0.525 0.55 0.575 0.600]}; {0}; {[118 90; 10 -18]}],[{3}; {0}; {0}; {[1 0; 3 0; 1 0; 3 0; 1 0; 3 0; 1 0; 3 0]}]);  %randomizer

CODE = [Preface; COMMAND; CPL]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV10('Columbia.ods')

