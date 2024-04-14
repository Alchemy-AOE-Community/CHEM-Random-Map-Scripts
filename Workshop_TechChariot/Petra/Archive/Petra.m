%Petrs Land Generation
%TechChariot
%12.02.21 (MM/DD/YY)

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms'); 


[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename);



terr_pl = [{'R'} {'R'} {'R'} {'R'} {'R'} {'R'} {'R'}];

a = [length(terr_pl)-1:-1:0]; r = 1; R_pl = [];
for i = 1:length(a)
f1 = [{['-' mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 1 
f2 = [{[    mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 2 
[R1] = LandScribeV5(terr_pl(i),{0},{0 -10},{90},f1,{1},{1},[-a(i) a(i)]); %Ring 1
[R2] = LandScribeV5(terr_pl(i),{0},{0 -10},{90},f2,{1},{1},[-a(i) a(i)]); %Ring 2
Rtemp = [R1; R2];
R_pl = [R_pl; Rtemp] ;
end
%

Siq = LandScribeV5({'R'},{0},{-16 0},{180},{'7*sin(2*pi*x/30)'},{1},{1},[0 52]);
Opening = LandScribeV5({'G'},{0},{0 50},{90},{'0.05*x.^2'},{1},{16},[-15 15]);


off =  linspace(38,52,4);           %Player Starting Offset Angle
b   =  linspace(0.2,0.25,3);          %Player Starting team bias factor
r   =  [48];           %Player Starting Group radius
adc = linspace(173,187,4);           %angular distance to group centers
e   = 0.4; e = 2*e;    %Player Starting Eccentricity



%[create_player_lands] = RMS_CPL_V6({0},{0},{0},off,adc,SA,b,r,e);

RawLand = [R_pl; Siq; Opening];
COMMAND = RMS_Processor_V3(RawLand,LPM_exp);
List = COMMAND;
%[List] = RMS_RS_V2(config,{'C'},COMMAND);
CODE = [Preface; List]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

%ObjectAutoscribeV6('ObjectDatabase.ods')

disp(["Run Completed " datestr(clock) "..."])
toc
