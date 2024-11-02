%Shimmerpool Land Generation
%TechChariot
%11.06.2023

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
##G = []; C = [];
##off = [43 44 45 46 47];
##adc = [175 177 179 181 183 185];
##b  = [0.07 0.08 0.09 0.1];
##
##ecc = [0.83 0.79]; %Adaptive Eccentricity
##plr = [a 1.08*a];  %Adaptive Player Radius
##
##BE = 1; BS = 3; NT = 0; ZA = 0; delta = 0;
##C = [{BE}; {BS}; {NT}; {ZA}; {delta}];


##[cpl] = RMS_CPL_V9(G,C); %Player Land Declaration
##[OA1X,OA1Y] = function_to_points_V3([OA1f; {[50-sp/2*sind(Angle{i1}) 50+sp/2*cosd(Angle{i1})]}; Angle(i1)],[-a a],[-sp 0],[0.1 2; 7 7],[10 00],[{'edge'} {'left'}],4);
##[OA2X,OA2Y] = SimpleRotate(OA1X,OA1Y,180,[50 50]);
##[LM_SUR,SUR] = LandScribeV6(SUR,[1 1]);
##[COMMAND(j).XY] = [RMS_Processor_V6([LM_OA1; LM_OA2; LM_SUR]); cpl];
##

##[DynamicList] = RMS_RS_V2(Angle,r,{'C'},COMMAND);
DynamicList = [];

##StaticList = [RMS_Processor_V6([LM_MT1; LM_MT2; LM_MT3; LM_MT4])];
StaticList = [];

##MLA = [];
k = 0;
for j = 0:10:100
  for i = 0:10:100
    k += 1;
    MLA(k,:) = {['L { terrain_type DIRT base_elevation 0 base_size 1 land_percent 1 ' ...
                 'zone ' num2str(k) ' other_zone_avoidance_distance 2 ' ...
                 ' land_position ' num2str(i) ' ' num2str(j) ' }']};
  end
end
%

CODE = [Preface; MLP; StaticList; DynamicList; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('_Example_Script.ods')
