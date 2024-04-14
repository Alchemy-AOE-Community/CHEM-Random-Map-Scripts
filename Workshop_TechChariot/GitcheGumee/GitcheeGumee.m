%GitcheeGumee Land Generation
%TechChariot
%2.6.23

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

MLP = [];

GG.v.s1 = [6];  GG.v.s2 = [94];
GG.w.s1 = [45]; GG.w.s2 = [93];

GG.AS = 2; GG.SS = 2;

GG.TT = {'B'}; GG.BS = [0]; GG.MPD = [4];  GG.BF = 0;

nx = 22; ny = 22;
b = 0;
Q = [1.9]; %Source
tol = 10^-6;
M = zeros(nx,ny); Mold = M; maxperdiff = 100;
while maxperdiff > tol
for i = 1:nx
for j = 1:ny
if i == 1 && j == 1
M(i,j) = b;
elseif i == 1 && j == ny
M(i,j) = b;
elseif i == nx && j == 1
M(i,j) = b;
elseif i == nx && j == ny
M(i,j) = b;
elseif i == 1
M(i,j) = b;
elseif i == nx
M(i,j) = b;
elseif j == 1
M(i,j) = b;
elseif j == ny
M(i,j) = b;


%elseif i == floor(nx/2) && j == floor(ny/2)
%M(i,j) = Q;

else
M(i,j) = (M(i+1,j)+ M(i-1,j) + M(i,j+1) +M(i,j-1) + Q )/4 ;
res(i,j) = (abs(M(i,j)-Mold(i,j)));
Mold = M;
end
end
end
maxperdiff = max(max(res));
end
%

%figure(1)
%mesh(M)

GG.NT = M;

[LM_GG,GG] = LandScribeV6(GG,[1 1]);

B.X = [(45:99)'; 99*ones(99,1); (45:99)'; 25*ones(99,1)];
B.Y = [ones(55,1); (1:99)'; 99*ones(55,1); (1:99)'];
B.BS = 2;

for i = 1:308
if i <= 209
B.TT(i,1) = {'NNRB'};
B.BE(i,1) = 0;
B.NT(i,1) = 20;
B.SS(i,1) = 0;
else
B.TT(i,1) = {'GRASS'};
B.BE(i,1) = 2;
B.NT(i,1) = 40;
B.SS(i,1) = 2;
end
end
%

[LM_B,B] = LandScribeV6(B,[1 1]);


List = [RMS_Processor_V5(LM_B); RMS_Processor_V5(LM_GG)];

MLA = [];



CODE = [Preface; MLP; List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV8('GitcheeGumee.ods')
