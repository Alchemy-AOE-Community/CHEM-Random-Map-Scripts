%SpaceColony Land Generation
%TechChariot
%01.19.2023

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

% -- Central Area Permeter -- %
CAP.TT = {'FRM'}; %Terrain Type for Central Area Perimeter
CAP.BS = {2}; %Base Size
CAP.NT = {0}; %Number of Tiles
CAP_R = 15; %Central Area Perimeter Radius
for i = 1:360
M(i,:) = CAP_R*[cosd(i) sind(i)] + 50;
end
%
CAP.X = M(:,1); CAP.Y = M(:,2); %Extracting X and Y Coordinates
[LM_CAP,CAP] = LandScribeV6(CAP,[1 1]);

% -- Central Area Fill -- %
CAF.TT = CAP.TT; %Terrain Type for Central Area Perimeter
CAF.BS = {0}; %Base Size
CAF.X = {50}; CAF.Y = {50}; %Coordinates
[LM_CAF,CAF] = LandScribeV6(CAF,[1 1]);




% -- Outer Ring -- %
OR.TT = {'INFRAS'}; %Terrain Type for Central Area Perimeter
OR.BS = {4}; %Base Size
OR.NT = {0}; %Number of Tiles
OR_R = 35; %Outer Ring Radius
for i = 1:360
N(i,:) = OR_R*[cosd(i) sind(i)] + 50;
end
%
OR.X = N(:,1); OR.Y = N(:,2); %Extracting X and Y Coordinates
[LM_OR,OR] = LandScribeV6(OR,[1 1]);




% -- Manual Land Application -- %
MLA = [{['create_player_lands { base_size 10 land_percent 0 circle_radius ' num2str(OR_R) ' 0 } ']}];


[COMMAND] = [RMS_Processor_V6([LM_CAP; LM_CAF; LM_OR])];

CODE = [Preface; COMMAND; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV9('SpaceColony_V2.ods')
