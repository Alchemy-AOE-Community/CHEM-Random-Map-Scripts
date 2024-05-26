%TC Pilgrims Land Generation
%TechChariot
%11.24.21

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

off =  45;           %Player Starting Offset Angle
b   =  0;            %Player Starting team bias factor
r   =  [2];          %Player Starting Group radius
adc = 180;           %angular distance to group centers
e   = 0.5; e = 2*e;  %Player Starting Eccentricity
SA = 0;              %starting angle

[create_player_lands] = RMS_CPL_V6({0},{0},{0},off,adc,SA,b,r,e);

O = [-90 -45 0 45 90]/2;

for L = 1:length(O)
if O(L) == 0
p = 1/3; %Expansion power of the branches
elseif abs(O(L)) == 45
p = 1/6; %Expansion power of the branches
else
p = 1/4;  %Expansion power of the branches
end
%

N = FraktalT(6,0.7,[pi/4,-pi/4],p,[0,0],[0,1]);
[nx,ny,~] = size(N);  xmax = max(max(N(:,:,1))); ymax = max(max(N(:,:,2))); k = 0;
for j = 1:ny
for i = 1:nx
k = k + 1; M(k,:) = [50*(N(i,j,1)+1) 90*N(i,j,2)/ymax];
end
end
%

if O(L) == 0
M = 1.25*M; %Magnification Factor
elseif abs(O(L)) == 45
M = 0.75*M; %Magnification Factor
else
M = 0.9*M; %Magnification Factor
end
%

FracUp   = [LandScribeV5([{'W'}],[{0}],{50 74},{000+O(L)},{M},{1})];
FracDown = [LandScribeV5([{'W'}],[{0}],{50 26},{180+O(L)},{M},{1})];

Plus1 = [LandScribeV5([{'W'}],[{0}],{0 0},{045+O(L)},{'0*x'},{1},{2},[-25 25])];
Plus2 = [LandScribeV5([{'W'}],[{0}],{0 0},{135+O(L)},{'0*x'},{1},{2},[-25 25])];

Blend1 = LandScribeV5([{'W'}],[{0}],{0 7},{000+O(L)},{'0.02*x.^2'},{2},{4},[-10 10]);
Blend2 = LandScribeV5([{'W'}],[{0}],{0 7},{090+O(L)},{'0.02*x.^2'},{2},{4},[-10 10]);
Blend3 = LandScribeV5([{'W'}],[{0}],{0 7},{180+O(L)},{'0.02*x.^2'},{2},{4},[-10 10]);
Blend4 = LandScribeV5([{'W'}],[{0}],{0 7},{270+O(L)},{'0.02*x.^2'},{2},{4},[-10 10]);


RawLand_rand = [FracUp; FracDown; Plus1; Plus2; Blend1; Blend2; Blend3; Blend4];

RawLand_detr = [LandScribeV5([{'W'}],[{0}],{0 0},{000+O(L)},{'0*x'},{2},{12},[-7 7])];

COMMAND_rand = [RMS_Processor_Random_Coord(RawLand_rand,LPM_exp,1); create_player_lands];
COMMAND_detr = [RMS_Processor_V3(RawLand_detr,LPM_exp); create_player_lands];

COMMAND(L).XY = [COMMAND_rand; COMMAND_detr];

end
%

[List] = RMS_RS_V2(O,{'C'},COMMAND);

NewProbs = [{'start_random'}; ...
            {'percent_chance 10  #define C1'}; ...
            {'percent_chance 20  #define C2'}; ...
            {'percent_chance 40  #define C3'}; ...
            {'percent_chance 20  #define C4'}; ...
            {'percent_chance 10  #define C5'}; ...
            {'end_random'}];

List(1:7,:) = [];   List = [NewProbs; List];

CODE = [Preface; List]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

%ObjectAutoscribeV9('ESC_Saranac.ods')

disp(["Run Completed " datestr(clock) "..."])
toc
