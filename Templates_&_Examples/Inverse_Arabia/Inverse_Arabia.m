%Inverse Arabia
%TechChariot
%2024-11-09

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

%% -- Section on Something -- %%
##L.NT = [0 48 32 10000];
##L.BS = [4 2 1 1];
##L.BE = [1 1 1 0];
##L.SS = [3 3 3 3];
##L.CF = [35];
##L.TT = [{'RT4'} {'RT3'} {'RT2'} {'RT1'}];


%% -- Player Land Construction -- %%
C = [{0}; {12}; {0}];


##C = [{BE}; {BS}; {NT}; {ZA}; {delta}];

##R    = [38 42];
R    = [40];
##off  = [41 49];
off  = [45];
##adc  = [160 200];
adc  = [180];
##b    = [0.3 0.4];
b    = [0.35];

sep  = 50;

SA   = [0 45];
##SA   = [45];

for i = 1:length(SA)

  RM = [cosd(SA(i)) -sind(SA(i)); sind(SA(i)) cosd(SA(i))];

  cent1 = [0 +sep]';
  cent2 = [0 -sep]';

  cent1n = RM*cent1;
  cent2n = RM*cent2;

  centn(:,:,i) = [cent1n'; cent2n']+50;

  G = [{R}; {off}; {adc}; {SA}; {b}; {[0]}; {centn(:,:,i)}];
  [cpl] = RMS_CPL_V10(G,C,{['S' mat2str(i) '_']}); %Player Land Declaration

  [COMMAND(i).XY] = [cpl];
  clear cent1 cent2 cent1n cent2n G cpl
end
%
[DynamicList] = RMS_RS_V2(SA,{'C'},COMMAND);





##[OA1X,OA1Y] = function_to_points_V3([OA1f; {[50-sp/2*sind(Angle{i1}) 50+sp/2*cosd(Angle{i1})]}; Angle(i1)],[-a a],[-sp 0],[0.1 2; 7 7],[10 00],[{'edge'} {'left'}],4);
##[OA2X,OA2Y] = SimpleRotate(OA1X,OA1Y,180,[50 50]);
##[LM_SUR,SUR] = LandScribeV6(SUR,[1 1]);
##[COMMAND(j).XY] = [RMS_Processor_V6([LM_OA1; LM_OA2; LM_SUR]); cpl];
##



##StaticList = [RMS_Processor_V6([LM_MT1; LM_MT2; LM_MT3; LM_MT4])];
StaticList = [];

##MLA = {['create_player_lands { base_size 12 terrain_type DIRT land_percent 0 circle_radius 30 0 }']};

MLA = [];

CODE = [Preface; MLP; StaticList; DynamicList; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc
