%Patuxent Land Generation
%TechChariot
%2025-02-14

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%% -- Rotation-Dependent Sections -- %%
O  = linspace(0,180,11); %Seed Angle [deg]
##O  = 0; %Seed Angle [deg]

for i = 1:length(O)

%% -- Uphill Lands -- %%
  UL.TT = [{'UL'}];
  UL.BE = [1; 0;];
  UL.NT = [800; 400];
  UL.BS = [4; 2];
  UL.SS = [3];
  UL.CF = 25;
  UL.Z = 2;
  UL.OZA = 12;
  nULX = 5; nULY = 4;
  ULX = linspace(-20,120,nULX); ULY = linspace(-9,29,nULY)';
  ULX = ones(nULY,1)*ULX; ULY = ULY*ones(1,nULX);

  [ULX,ULY] = SimpleRotate(ULX,ULY,O(i)); %Neutral Land Simple Rotate Function

  UL.X = ULX; UL.Y = ULY;

  %% -- Sandbank Lands -- %%
  SB.TT = [{'SB'}];
  SB.BE = [0];
  SB.NT = [15];
  SB.BS = [1];
  SB.SS = [2];
  SB.Z = 2;
  SB.OZA = 12;
  nSBX = 81;
  SBX = linspace(-10,110,nSBX); SBY = 34*ones(1,nSBX);

  [SBX,SBY] = SimpleRotate(SBX,SBY,O(i)); %Neutral Land Simple Rotate Function

  SB.X = SBX; SB.Y = SBY;

  %% -- Oceanic Lands -- %%
  OL.TT = {'OL'};
  OL.BE = [0];
  OL.NT = [100; 300];
  OL.BS = [5; 10];
  OL.SS = [3];
  OL.CF = [25];
  OL.Z  = 1;
  OL.OZA = 12;

  nOLX = 41; nOLY = 2;
  OLX = linspace(-20,120,nOLX); OLY = linspace(98,108,nOLY)';
  OLX = ones(nOLY,1)*OLX; OLY = OLY*ones(1,nOLX);

  [OLX,OLY] = SimpleRotate(OLX,OLY,O(i)); %Neutral Land Simple Rotate Function

  OL.X = OLX; OL.Y = OLY;

  %% -- Flood Plain Lands -- %%
  FP.TT = [{'FP1'} {'FP2'} {'FP1'}];
  FP.BE = [0];
  FP.NT = [14400 0 14400];
  FP.BS = [3];
  FP.SS = [3];
  FP.Z  = 1;
  FP.OZA = 12;

  nFPX = 3;
  FPX = linspace(15,85,nFPX);  FPY = 60*ones(1,nFPX);

  [FPX,FPY] = SimpleRotate(FPX,FPY,O(i)); %Neutral Land Simple Rotate Function
  FP.X = FPX; FP.Y = FPY;

  %% -- Adding Land Compilations -- %%

  [LM_UL,UL] = LandScribeV6(UL,[1 1]);
  [LM_SB,SB] = LandScribeV6(SB,[1 1]);
  [LM_OL,OL] = LandScribeV6(OL,[1 1]);
  [LM_FP,FP] = LandScribeV6(FP,[1 1]);

  clear UL ULX ULY SB SBX SBY OL OLX OLY FP FPX FPY

  TM1 = [cosd(O(i)) -sind(O(i)); sind(O(i)) cosd(O(i))];
  TM2 = [cosd(90+O(i)) -sind(90+O(i)); sind(90+O(i)) cosd(90+O(i))];

  for j = 1:3
    if j == 1
      PL = [{'if DUEL_PLAYER_CONFIG'}];
      for k = 1:2
        if k == 1
          PL = [PL; {'if DOWNHILL_VERSION'}];
            p1 = [0 10]'; %Offset from center of map
            p2 = [0 0]'; %Perpendicular offset from other team focal point
            PZ = [1 1 1 1 1 1 1 1]'; POZA = 12*ones(8,1); %2 players downhill
            pt1 = TM1*p1; pt2 = TM2*p2;
            C = 50 + [pt1'; pt1'] + [+pt2'; -pt2'];
            [PL] = [PL; RMS_CPL_V10([{[29]}; {[45]}; {[175 180 185]}; {O(i)-90}; {0.1}; {0.6}; {C}],[{0}; {0}; {00}; {[PZ POZA]}])];
        else
          PL = [PL; {'else'}];
            p1 = [0 -35]'; %Offset from center of map
            p2 = [0 0]'; %Perpendicular offset from other team focal point
            PZ = 2*[1 1 1 1 1 1 1 1]'; POZA = 12*ones(8,1); %2 players downhill
            pt1 = TM1*p1; pt2 = TM2*p2;
            C = 50 + [pt1'; pt1'] + [+pt2'; -pt2'];
            [PL] = [PL; RMS_CPL_V10([{[29]}; {[45]}; {[175 180 185]}; {O(i)-90}; {0.1}; {0.6}; {C}],[{0}; {0}; {00}; {[PZ POZA]}])];
        end
        %
      end
      %
      PL = [PL; {'endif'}];

  elseif j == 2
      PL = [PL; {'elseif ODD_PLAYER_CONFIG'}];
      for k = 1:2
        if k == 1
          PL = [PL; {'if DOWNHILL_VERSION'}];
            p1 = [0 0]'; %Offset from center of map
            p2 = [0 0]'; %Perpendicular offset from other team focal point
            PZ = [2 1 1 1 1 2 2 2]'; POZA = 12*ones(8,1); %downhill
            pt1 = TM1*p1; pt2 = TM2*p2;
            C = 50 + [pt1'; pt1'] + [+pt2'; -pt2'];
            [PL] = [PL; RMS_CPL_V10([{[29]}; {[45]}; {[175 180 185]}; {O(i)-90}; {0.1}; {0.6}; {C}],[{0}; {0}; {00}; {[PZ POZA]}])];
        else
          PL = [PL; {'else'}];
            p1 = [0 -18]'; %Offset from center of map
            p2 = [0 0]'; %Perpendicular offset from other team focal point
            PZ = [2 2 1 1 2 2 1 1]'; POZA = 12*ones(8,1); %uphill
            pt1 = TM1*p1; pt2 = TM2*p2;
            C = 50 + [pt1'; pt1'] + [+pt2'; -pt2'];
            [PL] = [PL; RMS_CPL_V10([{[29]}; {[45]}; {[175 180 185]}; {O(i)-90}; {0.1}; {0.6}; {C}],[{0}; {0}; {00}; {[PZ POZA]}])];
        end
        %
      end
      %
      PL = [PL; {'endif'}];
  else
      p1 = [0 -12]'; %Offset from center of map
      p2 = [0 0]'; %Perpendicular offset from other team focal point

      PZ = [2 1 1 2 2 1 1 2]'; POZA = 12*ones(8,1);

      PL = [PL; {'elseif EVEN_PLAYER_CONFIG'}];
      pt1 = TM1*p1; pt2 = TM2*p2;
      C = 50 + [pt1'; pt1'] + [+pt2'; -pt2'];
      [PL] = [PL; RMS_CPL_V10([{[29]}; {[36]}; {[175 180 185]}; {O(i)-90}; {0.1}; {0.6}; {C}],[{0}; {0}; {00}; {[PZ POZA]}])];
    end
    %
  end
  %
  PL = [PL; {'endif'}];

  COMMAND(i).XY = [PL; RMS_Processor_V6([LM_SB; LM_UL; LM_OL; LM_FP])];

end
%

SCRIPT = RMS_RS_V2(O,{'C'},COMMAND);

MLP = [{[]}];

CODE = [Preface; MLP; SCRIPT; PL]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('Heidelberg.ods')


