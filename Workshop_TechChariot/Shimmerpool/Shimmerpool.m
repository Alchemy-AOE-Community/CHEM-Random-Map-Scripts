%Shimmerpool Land Generation
%TechChariot
%11.06.2023

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

MLP = [];

%% -- Section on Oasis -- %%
OA.NT = [0 48 32 10000];
OA.BS = [4 2 1 1];
OA.BE = [1 1 1 0];
OA.SS = [3 3 3 3];
OA.CF = [35];
OA.TT = [{'RT4'} {'RT3'} {'RT2'} {'RT1'}];

%Angular Orientation of Various Shapes
Angle = [{0}; {90}];

%Oasis Basic Parameters
r  = [{0.25}; {0.35}];     %Aspect Ratio of the Oasis

OA1 = OA; OA2 = OA; clear OA

%Surrounding Area Basic Parameters
SUR.TT = {'BT'};
SUR.BE = 1;

j = 1; a = 28; sp = 21;


%% -- Player Land Construction -- %%
G = []; C = [];

off = [43 44 45 46 47];
adc = [175 177 179 181 183 185];
b  = [0.07 0.08 0.09 0.1];

ecc = [0.83 0.79]; %Adaptive Eccentricity
plr = [a 1.08*a];  %Adaptive Player Radius

BE = 1; BS = 3; NT = 0; ZA = 0; delta = 0;
C = [{BE}; {BS}; {NT}; {ZA}; {delta}];

for i2 = 1:length(r)
for i1 = 1:length(Angle)

G = [{plr(i2)}; {off}; {adc}; {Angle{i1}}; {b}; {ecc(i2)}];

[cpl] = RMS_CPL_V9(G,C); %Player Land Declaration

OA1f = [{['-' mat2str(r{i2}) '*sqrt(' mat2str(a) '^2 - x.^2)']}];

[OA1X,OA1Y] = function_to_points_V3([OA1f; {[50-sp/2*sind(Angle{i1}) 50+sp/2*cosd(Angle{i1})]}; Angle(i1)],[-a a],[-sp 0],[0.1 2; 7 7],[10 00],[{'edge'} {'left'}],4);

[OA2X,OA2Y] = SimpleRotate(OA1X,OA1Y,180,[50 50]);


OA1.XB = OA1X; OA1.YB = OA1Y;
OA2.XB = OA2X; OA2.YB = OA2Y;
[LM_OA1,OA1] = LandScribeV6(OA1,[1 1]);
[LM_OA2,OA2] = LandScribeV6(OA2,[1 1]);

SUR.XB = [50-45*sind(Angle{i1}) 50+45*sind(Angle{i1})];
SUR.YB = [50-45*cosd(Angle{i1}) 50+45*cosd(Angle{i1})];
SUR.ID = [1 2];
[LM_SUR,SUR] = LandScribeV6(SUR,[1 1]);

[COMMAND(j).XY] = [RMS_Processor_V6([LM_OA1; LM_OA2; LM_SUR]); cpl];

j = j + 1;
end
end
%

[DynamicList] = RMS_RS_V2(Angle,r,{'C'},COMMAND);


%Generating Mountain Data
MT.TT = [{'MTSH'} {'MTSH'} {'MTOL'}];
MT.NT = [10000 10000 0];
MT.BS = [1];
MT.SS = [3];
MT.BE = [{5} {5} {8}];


MT1 = MT; MT2 = MT; MT3 = MT; MT4 = MT;

[MT1X,MT1Y] = function_to_points_V3([[{'-0.02*x.^2'}]; {[3 3]}; {-45}],[-30 30],[-6 6],[1; 6]);
MT1.X = MT1X; MT1.Y = MT1Y;
[MT2X,MT2Y] = SimpleRotate(MT1X,MT1Y,090,[50 50]);
MT2.X = MT2X; MT2.Y = MT2Y;
[MT3X,MT3Y] = SimpleRotate(MT1X,MT1Y,180,[50 50]);
MT3.X = MT3X; MT3.Y = MT3Y;
[MT4X,MT4Y] = SimpleRotate(MT1X,MT1Y,270,[50 50]);
MT4.X = MT4X; MT4.Y = MT4Y;

[LM_MT1,MT1] = LandScribeV6(MT1,[1 1]); [LM_MT2,MT2] = LandScribeV6(MT2,[1 1]);
[LM_MT3,MT3] = LandScribeV6(MT3,[1 1]); [LM_MT4,MT4] = LandScribeV6(MT4,[1 1]);

StaticList = [RMS_Processor_V6([LM_MT1; LM_MT2; LM_MT3; LM_MT4])];

MLA = [];

CODE = [Preface; MLP; StaticList; DynamicList; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);
RMS_ForgeV4([filename(1:end-4) '_Nomad.rms'],CODE); %Creation of Nomad Variant

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV10('Shimmerpool.ods')
%ObjectAutoscribeV10('Shimmerpool_Nomad.ods')
