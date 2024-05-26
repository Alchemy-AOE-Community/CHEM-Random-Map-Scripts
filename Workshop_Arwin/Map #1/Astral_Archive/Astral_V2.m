%Astral_V2 Land Generation
%TechChariot
%4.19.23

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

d_O = 27; S_O = 31;

[EO1X,EO1Y] = function_to_points([f; {[000+d_O 000+d_O]}; {-45}],[{[-S_O S_O]}]);
[EO2X,EO2Y] = function_to_points([f; {[100-d_O 000+d_O]}; {+45}],[{[-S_O S_O]}]);
[EO3X,EO3Y] = function_to_points([f; {[000+d_O 100-d_O]}; {+45}],[{[-S_O S_O]}]);
[EO4X,EO4Y] = function_to_points([f; {[100-d_O 100-d_O]}; {-45}],[{[-S_O S_O]}]);

EO.X = [EO1X; EO2X; EO3X; EO4X]; EO.Y = [EO1Y; EO2Y; EO3Y; EO4Y]; %Parameters for Edge Outer

%Setting Inner Ring Parameters
EI.TT   = [{'EIT'}]; %Establishing Terrain Types
EI.BS   = [2];                                                        %Establishing Base Size
EI.NT   = [0];                                                        %Establshing Number of Tiles

d_I = 33; S_I = 23;

[EI1X,EI1Y] = function_to_points([f; {[000+d_I 000+d_I]}; {-45}],[{[-S_I S_I]}]);
[EI2X,EI2Y] = function_to_points([f; {[100-d_I 000+d_I]}; {+45}],[{[-S_I S_I]}]);
[EI3X,EI3Y] = function_to_points([f; {[000+d_I 100-d_I]}; {+45}],[{[-S_I S_I]}]);
[EI4X,EI4Y] = function_to_points([f; {[100-d_I 100-d_I]}; {-45}],[{[-S_I S_I]}]);

EI.X = [EI1X; EI2X; EI3X; EI4X]; EI.Y = [EI1Y; EI2Y; EI3Y; EI4Y]; %Parameters for Edge Inner

%Setting Cross-Brace Parameters
CB.TT   = [{'CBT'}]; %Establishing Terrain Types
%CB.SS   = [1];
CB.BS   = [2];                                                        %Establishing Base Size
CB.NT   = [0];                                                        %Establshing Number of Tiles

L = 22;

[CB1X,CB1Y] = function_to_points([f; {[50 50]}; {+45}],[{[-L L]}]);
[CB2X,CB2Y] = function_to_points([f; {[50 50]}; {-45}],[{[-L L]}]);

CB.X = [CB1X; CB2X]; CB.Y = [CB1Y; CB2Y];

%Setting Window-Panes
WP.TT = [{'WPT1'} {'WPT2'}; {'WPT3'} {'WPT4'}];
WP.BS = 4;
%WP.NT = 0;

S = 10;
[WP.X,WP.Y] = function_to_points([f; {[50 50]}; {+45}],[{S*[-1 1]}; {2}],[{S*[-1 1]}; {2}]);









LM_WP = LandScribeV6(WP,[1 1]); LM_CB = LandScribeV6(CB,[1 1]); LM_EO = LandScribeV6(EO,[1 1]); LM_EI = LandScribeV6(EI,[1 1]);
COMMAND = RMS_Processor_V6([LM_CB; LM_EI; LM_EO; LM_WP]); CODE = [CODE; COMMAND];

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV9('Astral_V2.ods')
