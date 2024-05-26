%Eggrena Land Generation
%TechChariot
%5.11.22

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms'); 
[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

manual_land_appendix = [('create_land'); ...
                        {'{'}; ...
                        {'terrain_type MRLD'}; ...
                        {'land_percent 100'}; ...
                        {'land_position 50 50'}; ...
                        {'base_elevation 0'}; ...
                        {'}'}];

Config = [{-1} {0} {1}];

Ri = 12;

Clearing_Terrain   = [{'G'} {'G'} {'G'} {'G'} {'G'} {'G'} {'G'} {'G'}];
Clearing_Elevation = [{1} {1} {1} {1} {1} {1} {1} {1}];

j = 1;        
for i = 1:length(Config)       

if i == 1 || i == 3
Yi = 0.5;
Ai = 58; %The longer side length of the inner rectangle
Ao = 2*Ai; %The longer side length of the outer rectangle
Yo = Ai/Ao*(Yi-1)+1;

  if    i == 1
  Angle = {0};
  else
  Angle = {90}; zen = 67
  end
%

[cpl] = RMS_CPL_V6({1},{14},{0},[44 45 46],[175 180 185],Angle{1},[0.025 0.05],[40],0.75*Yo); %creating player lands
[cvl_2] = Circular_Variable_Lands({1},{8},{0},[44 45 46],[175 180 185],Angle{1},[0.025 0.05],[50],0.75*Yo);
[cvl_1] = Circular_Variable_Lands({1},{12},{0},[44 45 46],[175 180 185],Angle{1},[0.025 0.05],[60],0.75*Yo);

elseif i == 2
Yi = 1;
Ai = 38; %The longer side length of the inner rectangle
[cpl] = RMS_CPL_V6({1},{14},{0},[44 45 46],[175 180 185],[0 90],[0.025 0.05],[29],1); %creating player lands
[cvl_2] = Circular_Variable_Lands({1},{8},{0},[44 45 46],[175 180 185],[0 90],[0.025 0.05],[32],1);
[cvl_1] = Circular_Variable_Lands({1},{12},{0},[44 45 46],[175 180 185],[0 90],[0.025 0.05],[35],1);


end
%

[IR] = Rounded_Rectangle({Ai},{Yi},{Ri},[{'G'} {'G'} {'G'} {'G'} {'G'} {'G'} {'G'} {'G'}],{1},Angle); %Inner Ring Calculation







[COMMAND(j).XY] = [cpl; cvl_1; cvl_2; RMS_Processor_V4([IR],LPM_exp)];

%
j = j + 1;
end
%

[List] = RMS_RS_V2(Config,{'C'},COMMAND);

CODE = [Preface; List; manual_land_appendix]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV8('ESC_Oriskany.ods')
