%Petra Land Generation
%TechChariot
%11.14.2023

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%% -- Section on Canyon -- %%

CAN1_FILL.TT = {'CAN_TER1'};
CAN1_FILL.NT = 800;
CAN1_FILL.BS = 1;
CAN1_FILL.SS = 2;
CAN1_FILL.Z = 1;
CAN1_FILL.OZA = 2;
CAN1_FILL.CF = -20;

CAN2_FILL = CAN1_FILL;
CAN2_FILL.Z = 2;
CAN2_FILL.TT = {'CAN_TER2'};

CAN1_BOUN.TT = {'CAN_TER1'};
CAN1_BOUN.NT = 0;
CAN1_BOUN.BS = 3;
CAN1_BOUN.SS = 1;
CAN1_BOUN.Z  = 1;
CAN2_BOUN = CAN1_BOUN;
CAN2_BOUN.Z  = 2;
CAN2_BOUN.TT = {'CAN_TER2'};

CAN_Y_RANGE = 76;  y_sep = 7;

s = 0.15; %Curve Maturation Factor

xmin = 12; xmax = 50; xave = (xmin + xmax)/2;
CAN1_BOUN.X = [xmin:xmax]'; CAN2_BOUN.X = CAN1_BOUN.X;
CAN1_BOUN.Y = (CAN_Y_RANGE - y_sep)/2*exp(-0.5*((CAN1_BOUN.X-xave)/(s*(xmax-xmin))).^2) + 50 + y_sep/2;
CAN2_BOUN.Y = (y_sep - CAN_Y_RANGE)/2*exp(-0.5*((CAN2_BOUN.X-xave)/(s*(xmax-xmin))).^2) + 50 - y_sep/2;

CAN1_FILL.X = xave; CAN2_FILL.X = xave; off = 20;
CAN1_FILL.YB = max(CAN1_BOUN.Y) - off; CAN2_FILL.YB = min(CAN2_BOUN.Y) + off;
CAN1_FILL.YG = 50; CAN2_FILL.YG = 50;

CAN1_FILL.v = (xmax-xmin); CAN2_FILL.v = (xmax-xmin);
CAN1_FILL.w = CAN_Y_RANGE; CAN2_FILL.w = CAN_Y_RANGE;

[LM_CAN1,CAN1_BOUN] = LandScribeV6(CAN1_BOUN,[1 1]);
[LM_CAN2,CAN2_BOUN] = LandScribeV6(CAN2_BOUN,[1 1]);
[LM_CAN1_FILL,CAN1_FILL] = LandScribeV6(CAN1_FILL,[1 1]);
[LM_CAN2_FILL,CAN2_FILL] = LandScribeV6(CAN2_FILL,[1 1]);

%% -- Section on the Opening -- %%
%OPEN.X = xmax+4; OPEN.Y = 50; %Coodinates of Opening
%OPEN.TT = {'OPEN_TER'};
%OPEN.NT = 240;
%OPEN.BS = 7;
%OPEN.CF = 25;
%OPEN.v = 10; OPEN.w = 10;
%[LM_OPEN,OPEN] = LandScribeV6(OPEN,[1 1]);

Ro = [1:9]; O = [1:360]';
OPENX = cosd(O)*Ro+xmax+10; OPENY = sind(O)*Ro+50;

OPEN.X = OPENX; OPEN.Y = OPENY; %Coodinates of Opening

OPEN.TT = {'OPEN_TER'};
OPEN.NT = 0;
OPEN.BS = [2 1 1 1 1 1 1 1 1];
OPEN.CF = 25;
%OPEN.v = 10; OPEN.w = 10;
[LM_OPEN,OPEN] = LandScribeV6(OPEN,[1 1]);

%% -- Section on Shortcuts -- %%
SHCT.TT = {'SHCT_TER'};
f = '-0.02*x.^2';

[SHCTX,SHCTY] = function_to_points_V3([f; {[58 50]}; {90}],[-50 50],[0 0],[1 1; 1 1]);
SHCT.X = SHCTX; SHCT.Y = SHCTY;

SHCT.NT = 16;
SHCT.BS = 1;
SHCT.BE = 0;
SHCT.Z = 3;

nSHCT = length(SHCTX); SHCT_pt_mid = round(nSHCT/2); idx = 1:nSHCT;
SHCT.BS =  6*(1-exp(-0.5*((idx-SHCT_pt_mid)/(0.35*(nSHCT - 1))).^2))'+1;
SHCT.NT = 260*(1-exp(-0.5*((idx-SHCT_pt_mid)/(0.35*(nSHCT - 1))).^2))';
SHCT.CF = 25;

%[LM_SHCT,SHCT] = LandScribeV6(SHCT,[1 1]);
LM_SHCT = [];

% -- Upland Section -- %
UPLND.TT = {'UPLND_TER'};
UPLND.X = 86; UPLND.Y = 50;
UPLND.BE = 4;
UPLND.CF = 25;
UPLND.Z = 4;
UPLND.OZA = 7;
%[LM_UPLND,UPLND] = LandScribeV6(UPLND,[1 1]);
LM_UPLND = [];


%% -- Section on the MidLand -- %%
MDLND.XB = [58; 58; 80]; MDLND.YB = [25; 75; 50]; MDLND.XG = 50;
MDLND.NT = 14400;
MDLND.BS = 1;
MDLND.BE = 4;
MDLND.TT = {'MDLND_TER'};
MDLND.CF = 25;
MDLND.v = 89; MDLND.w = 36;
MDLND.SS = 2;
[LM_MDLND,MDLND] = LandScribeV6(MDLND,[1 1]);

% -- Lowland Section -- %
LWLND.TT = {'LWLND_TER'};
LWLND.X = 1; LWLND.Y = 50;
LWLND.v = 12; LWLND.w = 10;
LWLND.BS = 5;
LWLND.NT = 121;
LWLND.BE = 0;
LWLND.CF = 25;
LWLND.SS = 3;
[LM_LWLND,LWLND] = LandScribeV6(LWLND,[1 1]);
%LM_LWLND = [];

[COMMAND] = [RMS_Processor_V6([LM_CAN1; LM_CAN2; LM_CAN1_FILL; LM_CAN2_FILL; LM_OPEN; LM_SHCT; LM_UPLND; LM_MDLND; LM_LWLND])];

CODE = [Preface; COMMAND]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV9('Petra.ods')
