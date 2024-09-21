%Denali Land Generation
%TechChariot
%2024-07-12

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%% -- Mountain Generals -- %%
f = '0.02*x.^2+58';
sx = 8; sy = 15;

[MTNX,MTNY] = function_to_points_V3([f; {[-5 105]}; {45}],[-50 50],[-9*sy 0*sy],[sx sx; sy sy]);
MTN.X = MTNX; MTN.Y = MTNY;
[nx,ny] = size(MTNX);


for j = 1:ny
  for i = 1:nx
      MTN.TT(i,j) = {'SNOW'};
  end
end
%

StnBrd = 26; %standard borders
MTN.v.s1 = StnBrd*ones(nx,ny);
MTN.v.s2 = StnBrd*ones(nx,ny);
MTN.w.s1 = StnBrd*ones(nx,ny);
MTN.w.s2 = StnBrd*ones(nx,ny);

MTN.OZA = 7*ones(nx,ny); %standard other zone avoidance

MTN.BS  = ones(nx,ny); %standard base size

MTN.CF = 25; %standard clumping factor

MTN.BE = zeros(nx,ny); %standard base elevation

MTN.NT = 6000*ones(nx,ny); %standard size

MTN.Z = 3*ones(nx,ny); %standard zone

MTN.SS = 2*ones(nx,ny); %size scaling

%% -- Mountain Regionals -- %%

  % -- Elevations -- %
  MTN.BE((1:6),:)    = 14;                           %left corner
  MTN.BE((7:9),:)    = [13; 14; 11]*linspace(1,0.25,ny); %left slope
  MTN.BE(8,2:6)      = [14]; %left slope
  MTN.BE(7,7)        = [14]; %left slope
  MTN.BE((14:end),:) = 14;                           %right corner
  MTN.BE((11:13),:)  = [11; 14; 13]*linspace(1,0.25,ny); %right slope
  MTN.BE(12,2:6)     = [14]; %right slope
  MTN.BE(13,7)       = [14]; %right slope

  MTN.BE(10,1:4) = [16 14 13 12];                    %central peak slope
  MTN.BE(9:11,(end-2):end) = 0;                         %basin flatness

  % -- Sizing -- %
  MTN.NT(10,5:end) = 0; %number of tiles, central glacial line
  MTN.BS(10,5:end) = 0; %base size, central glacial line

  MTN.BS(8,2:6)      = [2]; %left slope
  MTN.BS(7,7)        = [2]; %left slope
  MTN.BS(12,2:6)     = [2]; %right slope
  MTN.BS(13,7)       = [2]; %right slope

  % -- Zoning -- %
  MTN.Z((1:6),:)    = 1; %left corner
  MTN.Z((14:end),:) = 5; %right corner

  MTN.Z((7:9),:)    = 2; %left slope
  MTN.Z((11:13),:)  = 4; %right slope

  %% -- Zone Avoidances -- %%
  MTN.OZA(:,(end-2):end) = 2;                         %basin zone avoidance

  MTN.OZA((1:6),:)       = 8;                         %left corner
  MTN.OZA((14:end),:)    = 8;                         %right corner

  MTN.OZA(9,(end-2))  = 10;                          %basin opening zone avoidance
  MTN.OZA(11,(end-2)) = 10;                          %basin opening zone avoidance


  %% -- Scaling -- %%
  MTN.SS((7:9),:)      = 3*[1; 1; 1]*ones(1,ny); %left  slope
  MTN.SS((11:13),:)    = 3*[1; 1; 1]*ones(1,ny); %right slope

  %% -- Windowing -- %%
  wry = 5:8; %window range y
  tw = 10; %tight window

  MTN.v.s1(9,wry) = tw;                        %near central glacier, left side
  MTN.v.s2(9,wry) = tw;                        %near central glacier, left side
  MTN.w.s1(9,wry) = tw;                        %near central glacier, left side
  MTN.w.s2(9,wry) = tw;                        %near central glacier, left side

  MTN.v.s1(11,wry) = tw;                        %near central glacier, left side
  MTN.v.s2(11,wry) = tw;                        %near central glacier, left side
  MTN.w.s1(11,wry) = tw;                        %near central glacier, left side
  MTN.w.s2(11,wry) = tw;                        %near central glacier, left side


%% -- Mountain Locals -- %%

  rw = 4;  %razor tight window
  MTN.v.s1(8,8)  = 2*rw; %glacial basin, razor window left
  MTN.v.s2(8,8)  = 2*rw; %glacial basin, razor window left
  MTN.w.s1(8,8)  = 2*rw; %glacial basin, razor window left
  MTN.w.s2(8,8)  = 2*rw; %glacial basin, razor window left

  MTN.v.s1(12,8) = 2*rw; %glacial basin, razor window left
  MTN.v.s2(12,8) = 2*rw; %glacial basin, razor window left
  MTN.w.s1(12,8) = 2*rw; %glacial basin, razor window left
  MTN.w.s2(12,8) = 2*rw; %glacial basin, razor window left

  MTN.v.s1(8,9)  = rw; %glacial basin, razor window left
  MTN.v.s2(8,9)  = rw; %glacial basin, razor window left
  MTN.w.s1(8,9)  = rw; %glacial basin, razor window left
  MTN.w.s2(8,9)  = rw; %glacial basin, razor window left

  MTN.v.s1(12,9) = rw; %glacial basin, razor window left
  MTN.v.s2(12,9) = rw; %glacial basin, razor window left
  MTN.w.s1(12,9) = rw; %glacial basin, razor window left
  MTN.w.s2(12,9) = rw; %glacial basin, razor window left

  MTN.v.s1(8,10)  = 0.5*rw; %glacial basin, razor window left
  MTN.v.s2(8,10)  = 0.5*rw; %glacial basin, razor window left
  MTN.w.s1(8,10)  = 0.5*rw; %glacial basin, razor window left
  MTN.w.s2(8,10)  = 0.5*rw; %glacial basin, razor window left

  MTN.v.s1(12,10) = 0.5*rw; %glacial basin, razor window left
  MTN.v.s2(12,10) = 0.5*rw; %glacial basin, razor window left
  MTN.w.s1(12,10) = 0.5*rw; %glacial basin, razor window left
  MTN.w.s2(12,10) = 0.5*rw; %glacial basin, razor window left

  MTN.BS(10,ny) = 2;   %base size, meltwater
  MTN.NT(10,ny) = 30;  %number of tiles, meltwater
  MTN.SS(10,ny) = 3;   %size scaling, meltwater
  MTN.TT(10,ny) = {'GRASS'};   %terrain type, meltwater

%  MTN.NT = 0*ones(nx,ny); %standard size

[LM_MTN,MTN] = LandScribeV6(MTN,[1 1]);

[COMMAND] = [RMS_Processor_V6([LM_MTN])];

[CPL] = RMS_CPL_V10([{[26 27 28]}; {[42 45 48]}; {[170 175 180 185 190]}; {[-45]}; {[0.25 0.30 0.35]}; {[0.9]}],[{15}; {3}; {0}; {[4 0; 2 0; 4 0; 2 0; 4 0; 2 0; 4 0; 2 0]}]);

CODE = [Preface; COMMAND; CPL]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('Denali.ods')


