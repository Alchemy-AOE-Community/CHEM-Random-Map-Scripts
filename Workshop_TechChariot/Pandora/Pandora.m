%Pandora Land Generation
%TechChariot
%8.13.23

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


%% -- Player Land Construction -- %%
G = []; C = [];

r = [28 29]; off = [44 45 46];
adc = [172 174 176 178 180 182 184 186 188];
SA  = [-45]; b  = [0.05 0.075 0.1]; ecc = [0];
G = [{r}; {off}; {adc}; {SA}; {b}; {ecc}];


BE = 1; BS = 2; NT = 200000; ZA = 0; delta = 0;
C = [{BE}; {BS}; {NT}; {ZA}; {delta}];

[create_player_lands] = RMS_CPL_V9(G,C);


%% -- Section on Island -- %%
ISf = [{'0.01*x.^2'}];

[ISX,ISY] = function_to_points_V2([ISf; {[15 85]}; {45}],[-30 30],[-13 13],[4; 4],[0 0]);

IS.BE = [1 1 2 2 3 3 4];
IS.TT = [{'GRASS2'}];
IS.SS = [3];
IS.BS = [1 1 1 2 2 2 3];
IS.X = [ISX]; IS.Y = [ISY];
IS.NT = linspace(40,70,7);
IS.NT(1,end) = 80;
IS.Z = 1;
[LM_IS,IS] = LandScribeV6(IS,[1 1]);

%% -- Section on Lava Flow -- %%

LFf = [{'0*x'}];
%[LFX,LFY] = function_to_points_V2([LFf; {[10 90]}; {135}],[-18 18],[0 0],[1; 1],[0 0]);
[LFX,LFY] = function_to_points_V2([LFf; {[8 92]}; {135}],[-19 19],[0 0],[1; 1],[0 0]);

LF.BE = [2; 2; 3; 3; 4; 4; 5; 5];
LF.TT = [{'EF'}];
LF.SS = [0];
LF.CF = [32];
LF.X = [LFX]; LF.Y = [LFY];

LF.BS = ones(length(LFX),1);
LF.BS(1,1) = 3;
LF.NT = linspace(16,8,length(LFX))';
LF.NT(1,1) = 64; %giving the last some extra spillage
LF.NT(2,1) = 32; %giving the second to last some extra spillage
LF.Z = 2; %zone declaration

[LM_LF,LF] = LandScribeV6(LF,[1 1]);

%% -- Oceanic Surge -- %%
OS.X = [95]; OS.Y = [5];
OS.TT = [{'NNRB'}];
[LM_OS,OS] = LandScribeV6(OS,[1 1]);

%% -- Section on Surge Barrier -- %%

SB.SS = [3];
SB.BE = [1];
SB.TT = [{'NNRB'}]; SB.BS = [1];

SB.NT = 10;

%fSB = [{'10*cos(2*pi*x/50)'}];
%fSB = [{'20*cos(2*pi*x/50)'}];
%fSB = [{'10*cos(2*pi*x/30)'}];
%fSB = [{'20*cos(2*pi*x/70)'}];
%fSB = [{'-10*cos(2*pi*x/70)'}];
%fSB = [{'-20*cos(2*pi*x/70)'}];
%fSB = [{'-10*cos(2*pi*x/50)'}];
%fSB = [{'-20*cos(2*pi*x/50)'}];
%fSB = [{'0.01*x.^2'}];
%fSB = [{'0.005*x.^2'}];
%fSB = [{'0*x'}];

fSB = [{'0*x'} {'0.0035*x.^2'} {'0.01*x.^2'} {'-20*cos(2*pi*x/50)'} {'-10*cos(2*pi*x/50)'} {'-20*cos(2*pi*x/70)'} {'-10*cos(2*pi*x/70)'} {'20*cos(2*pi*x/70)'} {'10*cos(2*pi*x/30)'} {'18*cos(2*pi*x/50)'} {'10*cos(2*pi*x/50)'}];

for i = 1:length(fSB)
[SBX,SBY] = function_to_points_V2([fSB(i); {[75 25]}; {45}],[-75 75],[0 0],[1; 100],[0 0]); %Surge Barrier Points
SB.X = [SBX]; SB.Y = [SBY];
[LM_SB,~] = LandScribeV6(SB,[1 1]);
DynamicCOMMAND(i).XY = [RMS_Processor_V6([LM_SB; LM_OS])];

clear LM_SB SBX SBY
SB.X = []; SB.Y = [];
end
%

StaticList  = [RMS_Processor_V6([LM_LF; LM_IS])];
[DynamicList] = RMS_RS_V2(fSB,{'C'},DynamicCOMMAND);


MLA = [];

CODE = [Preface; MLP; StaticList; DynamicList; create_player_lands; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV9('Pandora.ods')
