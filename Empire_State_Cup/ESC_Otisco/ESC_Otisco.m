%Otisco Land Generation
%ThorsChariot
%3.28.21

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms'); 

mes = [120 144 168 200 220 240]; %map edge sizes
d = (0.51 + 0.15*sqrt(2))*mes; %approximate distance (in percent of map edge) travelled to reach water
idt = 75; %desired TC idle time difference (sec)
ox_rate = d/idt; %necessary rate (tiles per second)

manual_land_appendix = [('L'); ...
                        {'{'}; ...
                        {'terrain_type G'}; ...
                        {'land_percent 100'}; ...
                        {'land_position 0 0'}; ...
                        {'base_elevation 3'}; ...
                        {'}'}; ...
                        ('L'); ...
                        {'{'}; ...
                        {'terrain_type G'}; ...
                        {'land_percent 100'}; ...
                        {'land_position 0 99'}; ...
                        {'base_elevation 3'}; ...
                        {'}'}];
%manual_land_appendix = [];

%Terrain Painting --
Cent_river = [{[0 0]};];
Cent_lake = [{[0 -34]}];
Cent_island = [{[0 -48]}];
Cent_ridge = [{[0 50]}];
Angle = [{0}];

friver = [{'4*sin(2*pi*x/40)'} {'-4*sin(2*pi*x/40)'}];
flake = [{'-0.03*x.^2'}];

RG = [-5 -3; 3 6];

[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename);

%SigMath = [{270} {0.27} {0.71} {[14 50]}]; %Signature Mathematical Parameters (necessary for any signature type) [Angular Orientation,Scale,Thickness,[x_center,y_center]]
%SigScpt = [{'SHALLOW'} {0}];               %Signature Map Parameters (necessary for positive space signature) [Terrain Type, Base Elevation]
%[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename,SigMath,SigScpt);

[Lake]  = LandScribeV5({'NNGB'},{2},Cent_lake(1,:),{Angle{1}+90},flake,{1},{44},[-50 50]);

RidgeLeft  = LandScribeV5([{'G3'}],[{11}],{[ 50 -20]},{Angle{1}+90},{'0.08*x.^2'},{6},{6},[ 00 50]); 
RidgeRight = LandScribeV5([{'G3'}],[{11}],{[-50 -20]},{Angle{1}+90},{'0.08*x.^2'},{6},{6},[-50 00]); 

Ridge = [RidgeLeft;RidgeRight];

[LPM_ridge_exp] = LPM_Shadow([cell2mat(Ridge(:,1:2))],3*ones(length(Ridge)));
LPM_ridge_exp = setdiff(LPM_exp,cell2mat([Ridge(:,1:2)]),'rows','stable'); %Removing any data that conflicts with directly specified points
LPM_exp = [LPM_exp; LPM_ridge_exp];

Farmland = LandScribeV5([{'R2'} {'DLC_DIRT4'}],[{2} {1}],{[0 15]},{Angle{1}+90},{'0*x'},{1},{78},[-15 15; -30 30]); 
Farmland = [Farmland; LandScribeV5([{'R2'}],[{2}],{[0 +45]},{Angle{1}-135},{'0*x'},{1},{60},[-20 20])];
Farmland = [Farmland; LandScribeV5([{'R2'}],[{2}],{[0 -45]},{Angle{1}+135},{'0*x'},{1},{60},[-20 20])];
Farmland = [LandScribeV5([{'R2'}],[{2}],{[0 -15]},{Angle{1}-150},{'0*x'},{1},{36},[-1 1; -20 20]); Farmland];
Farmland = [LandScribeV5([{'R2'}],[{2}],{[0 +15]},{Angle{1}+150},{'0*x'},{1},{36},[-20 20; -1 1]); Farmland];
     
k = 0;
for i1 = 1:length(friver)
[River] = [LandScribeV5({'NNGB'},{0},Cent_river(1,:),Angle,friver(i1),{1},{4},[-50 50]); ...
           LandScribeV5({'NNGB'},{0},Cent_river(1,:),Angle,friver(i1),{2},{4},[-50 50])];

TL = LandScribeV5({'ROAD2'},{1},[{[0 -50]}],{Angle{1}-90},{'0*x'},{1},{1},RG(i1,:));           
SP = LandScribeV5({'NNGB'},{2},[{[0 12]}],{Angle{1}-90},{'0*x'},{1},{1},RG(i1,:));
           
RawLand = [Lake; River; TL; Farmland];

Combined = [RawLand]; %Combined = [SigComb; RawLand]; 

[LPM_river_exp] = LPM_Shadow(cell2mat(River(:,1:2)),3*ones(length(River),1)); LPM_exp = [LPM_exp; LPM_river_exp]; %expanding land position manual around the river
LPM_exp = setdiff(LPM_exp,[cell2mat([River(:,1:2); Lake(:,1:2)])],'rows','stable'); %Removing any data that conflicts with directly specified points

k = k + 1;
COMMAND(k).XY = [RMS_Processor_V4(Combined,LPM_exp); RMS_Processor_V4(Ridge,LPM_exp); RMS_Processor_V4(SP,LPM_exp)];
end
%

[List] = RMS_RS_V2(friver,{'C'},COMMAND);

CODE = [Preface; List; manual_land_appendix]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

%ObjectAutoscribeV8('ObjectDatabase.ods')

disp(["Run Completed " datestr(clock) "..."])
toc