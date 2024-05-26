%Astral_V3 Land Generation
%TechChariot
%4.21.23

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');
[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

MLP = []; MLA = [];

CODE = [Preface]; %Adding Preface and Player Lands to beginning of CODE

f = [{'0*x'}];
%Setting Outer Ring Parameters
EO.TT   = [{'EOT'}]; %Establishing Terrain Types
EO.BS   = [3];                                                        %Establishing Base Size
EO.BE   = [0];                                                        %Establishing Base Elevation
EO.NT   = [0];                                                        %Establshing Number of Tiles
EO.Z = 5;

d_O = 27; S_O = 31;

[EO1X,EO1Y] = function_to_points([f; {[000+d_O 000+d_O]}; {-45}],[{[-S_O S_O]}]);
[EO2X,EO2Y] = function_to_points([f; {[100-d_O 000+d_O]}; {+45}],[{[-S_O S_O]}]);
[EO3X,EO3Y] = function_to_points([f; {[000+d_O 100-d_O]}; {+45}],[{[-S_O S_O]}]);
[EO4X,EO4Y] = function_to_points([f; {[100-d_O 100-d_O]}; {-45}],[{[-S_O S_O]}]);

EO.X = [EO1X; EO2X; EO3X; EO4X]; EO.Y = [EO1Y; EO2Y; EO3Y; EO4Y]; %Parameters for Edge Outer

%Setting Inner Ring Parameters
EI.TT   = [{'WPT2'}; {'WPT1'}; {'WPT1'}; {'WPT3'};  ...
           {'WPT2'}; {'WPT4'}; {'WPT4'}; {'WPT3'}];           %Establishing Terrain Types
EI.BS   = [2];                                                        %Establishing Base Size
EI.NT   = [0];                                                        %Establshing Number of Tiles

d_I = 34; S_I = 22;

[EI1X,EI1Y] = function_to_points([f; {[000+d_I 000+d_I]}; {-45}],[{[-S_I S_I]}]);
[EI2X,EI2Y] = function_to_points([f; {[100-d_I 000+d_I]}; {+45}],[{[-S_I S_I]}]);
[EI3X,EI3Y] = function_to_points([f; {[000+d_I 100-d_I]}; {+45}],[{[-S_I S_I]}]);
[EI4X,EI4Y] = function_to_points([f; {[100-d_I 100-d_I]}; {-45}],[{[-S_I S_I]}]);

EI.X = [EI1X; EI2X; EI3X; EI4X]; EI.Y = [EI1Y; EI2Y; EI3Y; EI4Y]; %Parameters for Edge Inner

%Setting Cross-Brace Parameters
CB.TT.s1   = [{'CBT_1A'}; {'CBT_2A'}; {'CBT_3A'}; {'CBT_4A'}]; %Establishing Terrain Types
CB.TT.s2   = [{'CBT_1B'}; {'CBT_2B'}; {'CBT_3B'}; {'CBT_4B'}]; %Establishing Terrain Types
CB.BE = [1];
CB.BS   = [2];                                                        %Establishing Base Size
CB.NT   = [0];                                                        %Establshing Number of Tiles

L = 22;

[CB1X,CB1Y] = function_to_points([f; {[50 50]}; {+45}],[{[-L L]}]);
[CB2X,CB2Y] = function_to_points([f; {[50 50]}; {-45}],[{[-L L]}]);

CB.X = [CB1X; CB2X]; CB.Y = [CB1Y; CB2Y];

%Setting Window-Panes
WP.TT = [{'WPT1'} {'WPT2'}; {'WPT3'} {'WPT4'}];
WP.BS = 2;
WP.BE = 1;
WP.PC   = [1 4; 3 2];                                                     %Setting Player Color Assignment
s = 13;
[WP.X,WP.Y] = function_to_points([f; {[50 50]}; {+45}],[{s*[-1 1]}; {2}],[{s*[-1 1]}; {2}]);


%Setting Outlying Islands
OI.TT  = [{'OI1'} {'OI2'}; {'OI3'} {'OI4'}];
OI.BS  = 2;
OI.BE  = 1;
OI.OZA = 7;
OI.PC  = [5 8; 7 6];                                                     %Setting Player Color Assignment
OI.Z   = [1];
OI.NT = 1000;
OI.SS = 2;
OI.CF = 30;
S = 36;
[OI.X,OI.Y] = function_to_points([f; {[50 50]}; {+00}],[{S*[-1 1]}; {2}],[{S*[-1 1]}; {2}]);
OI.XG = [50];
OI.YG = [50];
OI.v = 88;
OI.w = 88;





LM_WP = LandScribeV6(WP,[1 1]); LM_OI = LandScribeV6(OI,[1 1]);
LM_CB = LandScribeV6(CB,[1 1]); LM_EO = LandScribeV6(EO,[1 1]); LM_EI = LandScribeV6(EI,[1 1]);
COMMAND = RMS_Processor_V6([LM_EI; LM_CB; LM_EO; LM_WP; LM_OI]); CODE = [CODE; COMMAND];

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV9('Astral_V2.ods')
