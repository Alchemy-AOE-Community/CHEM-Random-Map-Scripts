%Kharga Land Generation V2
%ThorsChariot
%5.14.21

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename);

%Manual Land Appendix
MLA = [{'L { land_position 50 50 land_percent 100 terrain_type B }'}];

%Generating Mountain Data
[Mountain1] = LandScribeV5([{'D'} {'Q'} {'Q'}],[{1} {7} {7} {4} {4} {4}],{0 62},{045},{['0.02*x.^2']},{2},{12},[-50 50]); %Mountain 1
[Mountain2] = LandScribeV5([{'D'} {'Q'} {'Q'}],[{1} {7} {7} {4} {4} {4}],{0 62},{135},{['0.02*x.^2']},{2},{12},[-50 50]); %Mountain 2
[Mountain3] = LandScribeV5([{'D'} {'Q'} {'Q'}],[{1} {7} {7} {4} {4} {4}],{0 62},{225},{['0.02*x.^2']},{2},{12},[-50 50]); %Mountain 3
[Mountain4] = LandScribeV5([{'D'} {'Q'} {'Q'}],[{1} {7} {7} {4} {4} {4}],{0 62},{315},{['0.02*x.^2']},{2},{12},[-50 50]); %Mountain 4
Mountain = [Mountain1; Mountain2; Mountain3; Mountain4];

%Angular Orientation of Various Shapes
Angle = [{0}; {90}];

%Oasis Basic Parameters
r  = [{0.3}; {0.4}];     %Aspect Ratio of the Oasis
%ecc = [{0.9075}; {0.8285}];

Oasis_Terrain = [{'B'} {'B'} {'B'} {'B'} {'B'} {'B'} ...
                 {'B'} {'B'} {'B'} {'B'} {'B'} {'B'} ...
                 {'B'} {'M'} ...
                 {'M'} {'M'} {'M'} {'M'} {'M'} {'M'}...
                 {'Y'} {'Y'}  {'Y'} {'Y'} {'Y'} {'Y'}...
                 {'T'} {'T'} {'T'} {'T'}];


j = 1;
for i2 = 1:length(r)
for i1 = 1:length(Angle)
na = length(Oasis_Terrain);
S = 2;   %Spacing Between Layers
amax = S*na + 1;
amin = amax-S*na;
a = [amin:S:amax];

R = [{}]; LPM_exp_temp =[];
for i = 1:na
f1 = [{['-' mat2str(r{i2}) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 1
f2 = [{[    mat2str(r{i2}) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 2
[R1] = LandScribeV5(Oasis_Terrain(i),{0},{0 0},Angle(i1),f1,{1},{1},[-a(i) a(i)]); %Ring 1
[R2] = LandScribeV5(Oasis_Terrain(i),{0},{0 0},Angle(i1),f2,{1},{1},[-a(i) a(i)]); %Ring 2

if strcmp(Oasis_Terrain{i},'B')
LPM_exp_temp = [LPM_exp_temp; cell2mat(R1(:,1:2)); cell2mat(R2(:,1:2))];
else
R = [R; R1; R2] ;
end
%

end
%

RawLand = [R; Mountain];
%[cpl] = RMS_CPL_V6({1},{1},{0},[43 45 47],[175 180 185],Angle{i1},[0],[0.9*max(a)],2*r{i2}*0.70); %creating player lands
[cpl] = RMS_CPL_V10([{r{i2}*max(a)*[1.05 1.10]}; {[43 45 47]}; {[175 180 185]}; {[Angle{i1}]}; {[-0.05 0 0.05]}; {sqrt(1-r{i2}^2)}],[{1}; {4}; {120}]);



Combined = [SigComb; RawLand];

[nLPM,~] = size(LPM_exp_temp); LPM_exp_temp = LPM_Shadow(LPM_exp_temp,2*ones(nLPM,1));

[COMMAND(j).XY] = [RMS_Processor_V4(Combined,[LPM_exp; LPM_exp_temp]); cpl];

%
j = j + 1;
end
end
%

[List] = RMS_RS_V2(Angle,r,{'C'},COMMAND);

CODE = [Preface; List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);
%ObjectAutoscribeV8('Kharga_V5.ods')
%ObjectAutoscribeV10('Kharga_V7.ods')
disp(["Run Completed " datestr(clock) "..."])
toc
%SigScpt = [{'BT'} {0}];                 %Signature Map Parameters (necessary for positive space signature) [Terrain Type, Base Elevation]
