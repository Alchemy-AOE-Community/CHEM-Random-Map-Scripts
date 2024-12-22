%Stacked_Hourglass
%Land Generation by TechChariot & AceLeviathan
%2024-12-22

clear all
close all
clc


tic

disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
PATH = filestruc.folder; fi = strfind(PATH,'\'); PATH  = PATH(1:fi(end-2));
addpath(genpath(PATH)) %Adding functions in main folder to the path

filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

MLP = [];

%% -- Player Land Construction -- %%
BE = 1; BS = 3; NT = 14400; ZA = 0; delta = 0;
C = [{BE}; {BS}; {NT}; {ZA}; {delta}];

##off = [43 44 45 46 47];
##adc = [175 177 179 181 183 185];
##b  = [0.07 0.08 0.09 0.1];
##
##ecc = [0]; %Adaptive Eccentricity
##plr = [a 1.08*a];  %Adaptive Player Radius

G = [{24}; {45}; {180}; {90}; {0}; {0};{[08 50; 92 50]}];

[cpl] = RMS_CPL_V10(G,C); %Player Land Declaration


%% -- Section on Something -- %%
f1 = @(x) 0.015*(x-50).^2 + 70;
f2 = @(x) 0.025*(x-50).^2 + 70;
##[HRX,HRY] = function_to_points_V3(f,[-50 50],[-50 50]);
nx = 100; HRX1 = linspace(0,100,nx)';

for i = 1:2

  if i == 1
    HRY1 = f1(HRX1);
  elseif i == 2
    HRY1 = f2(HRX1);
  end
  %

  [HRX2,HRY2] = SimpleRotate(HRX1,HRY1,180,[50 50]);

  HR.X = [HRX1 HRX2];
  HR.Y = [HRY1 HRY2];
  HR.NT = [0];
  HR.BS = [2];
  HR.TT = [{'BORDER_TER'}];
  ##L.BE = [1 1 1 0];
  ##L.SS = [3 3 3 3];
  ##L.CF = [35];
  ##L.TT = [{'RT4'} {'RT3'} {'RT2'} {'RT1'}];

  [LM_HR,HR] = LandScribeV6(HR,[1 1]);

  [COMMAND(i).XY] = [RMS_Processor_V6([LM_HR])];

  clear LM_RM HR

end
%

[DynamicList] = RMS_RS_V2([1 1],{'C'},COMMAND);
##DynamicList = [];

##StaticList = [RMS_Processor_V6([LM_MT1; LM_MT2; LM_MT3; LM_MT4])];
StaticList = [];

##MLA = {['L { terrain_type PT base_elevation 1 base_size 1 land_percent 100 land_position 1 50 assign_to AT_COLOR 1 0 0 }']};
MLA = [];
%

CODE = [Preface; MLP; StaticList; DynamicList; MLA; cpl]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('Stacked_Hourglass.ods')
