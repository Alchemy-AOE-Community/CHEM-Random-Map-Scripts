%Nesia (Greek Islands) Land Generation
%TechChariot
%10.3.22

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');
[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

MLP = []; MLA = [];

%% -- Defining Elevation Source Region Parameters (For Small, Rocky Outcroppings) -- %%
S.TT = [{'GRASS'}]; S.BS = [0]; S.BE = [0]; S.Z =[1]; S.OZA = [6];
%S.NT = 0;

%% -- Defining Neutral Patterned Islands -- %%
tag = [{'if P2'}; {'elseif P4'}; {'elseif P6'}; {'elseif P8'}; {'endif'}];

CODE = [Preface]; %Adding Preface and Player Lands to beginning of CODE


O = [0 10 20 30 40 50 60 70 80 90]; %Main Clocking Angle
%O = [0]; %Main Clocking Angle
o = [-5 0 5]; %Variance Angle
%o = [0]; %Variance Angle

f = [{'0*x'}; {'0.010*x.^2'}; {'-0.010*x.^2'}];

for i = 1:5
  CODE = [CODE; tag(i)];
  if i == 1
    j = 0; cent1 = [50 73]; cent2 = [50 27];
    %Setting Coordinates For Elevatable Grass Carpet (For Small Islands)
    SX = [5; 95]; SY = [50; 50];
    %Setting Parabolic Island Parameters Constant With Player Count
    P1.CF   = [30];                                                                   %Establishing Clumping Factor
    P1.BF   = [100];                                                                  %Establishing Border Fuzziness
    P1.OZA  = [14 14 13 14 14];                                                                   %Establishing Other Zone Avoidance
    P1.v = [200; 200; 84; 200; 200];                                                  %Setting X-Window
    P1.w = [200; 200; 84; 200; 200];                                                  %Setting Y-Window

    %Setting Parabolic Island Parameters Expected to Change
    P1.TT   = [{'GRASS3'}; {'DLC_DRYGRASS'}; {'DIRT'}; {'DLC_DRYGRASS'}; {'GRASS3'}]; %Establishing Terrain Types
    P1.BS   = [2; 2; 8; 2; 2];                                                        %Establishing Base Size
    P1.BE   = [4; 3; 2; 3; 4];                                                        %Establishing Base Elevation
    P1.NT   = [90; 70; 1200; 70; 90];                                                 %Establshing Number of Tiles
    P1.Z    = [2; 3; 4; 3; 2];                                                        %Establishing Zones
    P1.PC   = [0; 0; 1; 0; 0];                                                        %Setting Player Color Assignment

    P1.XG = [50];                                                                     %Setting the Growth Center X Coordinate
    P1.YG = [50];                                                                     %Setting the Growth Center y Coordinate

    P2 = P1;                                                                          %Mirroring Second Structure

    P2.Z  = [2; 3; 5; 3; 2];                                                          %Overwriting Zones
    P2.PC = [0; 0; 2; 0; 0];                                                          %Overwriting Player Color Assignment

    dom1 = [-49 -29; 0 0; 29 49];
    dom2 = [-49 -29; 0 0; 29 49];

    [P1X,P1Y] = function_to_points([f(1); {cent1}; {0}],[{dom1};{[2; 1; 2]}; {1}]);   %Parabola 1 X-Y Coordinates
    [P2X,P2Y] = function_to_points([f(1); {cent2}; {0}],[{dom2};{[2; 1; 2]}; {1}]);   %Parabola 2 X-Y Coordinates

    for k1 = 1:length(O)
      for k2 = 1:length(o)
        [P1.XB,P1.YB] = SimpleRotate(P1X,P1Y,O(k1)+o(k2),[50 50]); [P2.XB,P2.YB] = SimpleRotate(P2X,P2Y,O(k1)-o(k2),[50 50]); [S.XB,S.YB] = SimpleRotate(SX,SY,O(k1),[50 50]);
        [LM_P1,P1] = LandScribeV6(P1,[1 1]); [LM_P2,P2] = LandScribeV6(P2,[1 1]); [LM_S,~] = LandScribeV6(S,[1 1]); [LM_P1,LM_P2] = LandIDMirror(LM_P1,LM_P2);
        LM_PI = [LM_P1; LM_P2]; j += 1; [COMMAND(j).XY] = [RMS_Processor_V6([LM_PI; LM_S])]; %Processing the Lines of Code from Scribed Lands
      end
    end
    List = RMS_RS_V2(O,o,{'C'},COMMAND); CODE = [CODE; List]; rmfield(S,'XB'); rmfield(S,'YB');  clear COMMAND P1 P2
  elseif i == 2
    j = 0; cent1 = [50 80]; cent2 = [50 20]; yspan = 15;
    %Setting Coordinates For Elevatable Grass Carpet (For Small Islands)
    SX = [5; 95; 50; 50]; SY = [50; 50; -10; 110];
    %Setting Parabolic Island Parameters Constant With Player Count
    P1.CF   = [30];                                                                   %Establishing Clumping Factor
    P1.BF   = [100];                                                                  %Establishing Border Fuzziness
    P1.OZA  = [13];                                                                   %Establishing Other Zone Avoidance
    P1.v = [200 200; 200 200; 86 200; 86 200; 200 200; 200 200];                      %Setting X-Window
    P1.w = [200 200; 200 200; 86 200; 86 200; 200 200; 200 200];                      %Setting Y-Window
    %Setting Parabolic Island Parameters Expected to Change
    P1.TT   = [{'GRASS3'} {'GRASS3'}; {'DLC_DRYGRASS'} {'DLC_DRYGRASS'}; {'DIRT'} {'DLC_DRYGRASS'}; {'DIRT'} {'DLC_DRYGRASS'}; {'DLC_DRYGRASS'} {'DLC_DRYGRASS'}; {'GRASS3'} {'GRASS3'}]; %Establishing Terrain Types
    P1.BS   = [2 2; 2 2; 8 2; 8 2; 2 2; 2 2];                                         %Establishing Base Size
    P1.BE   = [4 4; 3 3; 2 3; 2 3; 3 3; 4 4];                                         %Establishing Base Elevation
    P1.NT   = [90 90; 70 70; 1250 70; 1250 70; 70 70; 90 90];                         %Establshing Number of Tiles
    P1.Z    = [2 2; 3 3; 4 3; 5 3; 3 3; 2 2];                                         %Establishing Zones
    P1.PC   = [0 0; 0 0; 1 0; 3 0; 0 0; 0 0];                                         %Setting Player Color Assignment

    P1.XG = [50];                                                                     %Setting the Growth Center X Coordinate
    P1.YG = [50];                                                                     %Setting the Growth Center y Coordinate

    P2 = P1;                                                                          %Mirroring Second Structure

    P2.Z  = [2 2; 3 3; 6 3; 7 3; 3 3; 2 2];                                           %Overwriting Zones
    P2.PC = [0 0; 0 0; 2 0; 4 0; 0 0; 0 0];                                           %Overwriting Player Color Assignment

    dom1 = [-49 -33; -15 15; 33 49];
    dom2 = [-49 -33; -15 15; 33 49];

    [P1X,P1Y] = function_to_points([f(1); {cent1}; {000}],[{dom1};{[2; 2; 2]}; {1}],[{[-yspan yspan]}; {2}; {1}]);   %Parabola 1 X-Y Coordinates
    [P2X,P2Y] = function_to_points([f(1); {cent2}; {180}],[{dom2};{[2; 2; 2]}; {1}],[{[-yspan yspan]}; {2}; {1}]);   %Parabola 2 X-Y Coordinates

    for k1 = 1:length(O)
      for k2 = 1:length(o)
        [P1.XB,P1.YB] = SimpleRotate(P1X,P1Y,O(k1)+o(k2),[50 50]); [P2.XB,P2.YB] = SimpleRotate(P2X,P2Y,O(k1)-o(k2),[50 50]); [S.XB,S.YB] = SimpleRotate(SX,SY,O(k1),[50 50]);
        [LM_P1,P1] = LandScribeV6(P1,[1 1]); [LM_P2,P2] = LandScribeV6(P2,[1 1]); [LM_S,~] = LandScribeV6(S,[1 1]); [LM_P1,LM_P2] = LandIDMirror(LM_P1,LM_P2);
        LM_PI = [LM_P1; LM_P2]; j += 1; [COMMAND(j).XY] = [RMS_Processor_V6([LM_PI; LM_S])]; %Processing the Lines of Code from Scribed Lands
      end
    end
    List = RMS_RS_V2(O,o,{'C'},COMMAND); CODE = [CODE; List]; rmfield(S,'XB'); rmfield(S,'YB');  clear COMMAND P1 P2
  elseif i == 3
    j = 0; cent1 = [50 87]; cent2 = [50 13]; yspan = 22;
    %Setting Coordinates For Elevatable Grass Carpet (For Small Islands)
    SX = [5; 95; 66; 66; 34; 34]; SY = [50; 50; -2; 102; -2; 102];
    %Setting Parabolic Island Parameters Constant With Player Count
    P1.CF   = [30];                                                                   %Establishing Clumping Factor
    P1.BF   = [100];                                                                  %Establishing Border Fuzziness
    P1.OZA  = [13];                                                                   %Establishing Other Zone Avoidance
    P1.v = [200 200 200; 200 200 200; 88 200 200; 88 200 200; 88 200 200; 200 200 200; 200 200 200]; %Setting X-Window
    P1.w = [200 200 200; 200 200 200; 88 200 200; 88 200 200; 88 200 200; 200 200 200; 200 200 200]; %Setting X-Window

    %Setting Parabolic Island Parameters Expected to Change
    P1.TT   = [{'GRASS3'} {'GRASS3'} {'GRASS3'}; ...
               {'DLC_DRYGRASS'} {'DLC_DRYGRASS'} {'GRASS3'};
               {'DIRT'} {'DLC_DRYGRASS'} {'GRASS3'};
               {'DIRT'} {'DLC_DRYGRASS'} {'GRASS3'};
               {'DIRT'} {'DLC_DRYGRASS'} {'GRASS3'};
               {'DLC_DRYGRASS'} {'DLC_DRYGRASS'} {'GRASS3'};
               {'GRASS3'} {'GRASS3'} {'GRASS3'}];                       %Establishing Terrain Types

    P1.BS   = [2 2 2; 2 2 2; 8 2 2; 8 2 2; 8 2 2; 2 2 2; 2 2 2];        %Establishing Base Size
    P1.BE   = [4 4 4; 3 3 4; 2 3 4; 2 3 4; 2 3 4; 3 3 4; 4 4 4];        %Establishing Base Elevation
    P1.NT   = [90 90 90; 70 70 90; 1300 70 120; 1300 70 120; 1300 70 120; 70 70 90; 90 90 90]; %Establshing Number of Tiles
    P1.Z    = [2 2 2; 3 3 2; 4 3 2; 5 3 2; 6 3 2; 3 3 2; 2 2 2];        %Establishing Zones
    P1.PC   = [0 0 0; 0 0 0; 1 0 0; 3 0 0; 5 0 0; 0 0 0; 0 0 0];        %Setting Player Color Assignment

    P1.XG = [50];                                                       %Setting the Growth Center X Coordinate
    P1.YG = [50];                                                       %Setting the Growth Center y Coordinate

    P2 = P1;                                                            %Mirroring Second Structure

    P2.Z  = [2 2 2; 3 3 2; 7 3 2; 8 3 2; 9 3 2; 3 3 2; 2 2 2];                                           %Overwriting Zones
    P2.PC = [0 0 0; 0 0 0; 2 0 0; 4 0 0; 6 0 0; 0 0 0; 0 0 0];                                           %Overwriting Player Color Assignment

    dom = [-54 -40; -21 21; 40 54];

    [P1X,P1Y] = function_to_points([f(1); {cent1}; {000}],[{dom};{[2; 2; 2]}; {1}],[{[-yspan yspan]}; {3}; {1}]); %Parabola 1 X-Y Coordinates
    [P2X,P2Y] = function_to_points([f(1); {cent2}; {180}],[{dom};{[2; 2; 2]}; {1}],[{[-yspan yspan]}; {3}; {1}]); %Parabola 2 X-Y Coordinates

    for k1 = 1:length(O)
      for k2 = 1:length(o)
        [P1.XB,P1.YB] = SimpleRotate(P1X,P1Y,O(k1)+o(k2),[50 50]); [P2.XB,P2.YB] = SimpleRotate(P2X,P2Y,O(k1)-o(k2),[50 50]); [S.XB,S.YB] = SimpleRotate(SX,SY,O(k1),[50 50]);
        [LM_P1,P1] = LandScribeV6(P1,[1 1]); [LM_P2,P2] = LandScribeV6(P2,[1 1]); [LM_S,~] = LandScribeV6(S,[1 1]); [LM_P1,LM_P2] = LandIDMirror(LM_P1,LM_P2);
        LM_PI = [LM_P1; LM_P2]; j += 1; [COMMAND(j).XY] = [RMS_Processor_V6([LM_PI; LM_S])]; %Processing the Lines of Code from Scribed Lands
      end
    end
    List = RMS_RS_V2(O,o,{'C'},COMMAND); CODE = [CODE; List]; rmfield(S,'XB'); rmfield(S,'YB');  clear COMMAND P1 P2
  elseif i == 4

    j = 0; cent1 = [50 91]; cent2 = [50 9]; yspan = 28;
    %Setting Coordinates For Elevatable Grass Carpet (For Small Islands)
    SX = [5; 95; 50; 50]; SY = [50; 50; -5; 105];
    %Setting Parabolic Island Parameters Constant With Player Count
    P1.CF   = [30];                                                                   %Establishing Clumping Factor
    P1.BF   = [100];                                                                  %Establishing Border Fuzziness
    P1.OZA  = [13];                                                                   %Establishing Other Zone Avoidance
    P1.v = [200 200 200 200; 200 200 200 200; 90 200 200 200; 90 200 200 200; 90 200 200 200; 90 200 200 200; 200 200 200 200; 200 200 200 200]; %Setting X-Window
    P1.w = [200 200 200 200; 200 200 200 200; 90 200 200 200; 90 200 200 200; 90 200 200 200; 90 200 200 200; 200 200 200 200; 200 200 200 200]; %Setting X-Window

    %Setting Parabolic Island Parameters Expected to Change
    P1.TT   = [{'GRASS3'} {'GRASS3'} {'GRASS3'} {'GRASS3'};
               {'DLC_DRYGRASS'} {'DLC_DRYGRASS'} {'GRASS3'} {'GRASS3'};
               {'DIRT'} {'DLC_DRYGRASS'} {'GRASS3'} {'GRASS3'};
               {'DIRT'} {'DLC_DRYGRASS'} {'GRASS3'} {'GRASS3'};
               {'DIRT'} {'DLC_DRYGRASS'} {'GRASS3'} {'GRASS3'};
               {'DLC_DRYGRASS'} {'DLC_DRYGRASS'} {'GRASS3'} {'GRASS3'};
               {'GRASS3'} {'GRASS3'} {'GRASS3'} {'GRASS3'}];                       %Establishing Terrain Types

    P1.BS   = [2 2 2 2; 2 2 2 2; 12 2 2 2; 12 2 2 2; 12 2 2 2; 12 2 2 2; 2 2 2 2; 2 2 2 2];        %Establishing Base Size
    P1.BE   = [4 4 4 4; 3 3 4 4; 2 3 4 4; 2 3 4 4; 2 3 4 4; 2 3 4 4; 3 3 4 4; 4 4 4 4];        %Establishing Base Elevation
    P1.NT   = [90 90 90 120; 70 70 90 120; 1400 70 160 200; 1400 70 160 200; 1400 70 160 200; 1400 70 160 200; 70 70 90 120; 90 90 90 120]; %Establshing Number of Tiles
    P1.Z    = [2 2 2 2; 3 3 2 2; 4 3 2 2; 5 3 2 2; 6 3 2 2; 7 3 2 2; 3 3 2 2; 2 2 2 2];        %Establishing Zones
    P1.PC   = [0 0 0 0; 0 0 0 0; 1 0 0 0; 3 0 0 0; 5 0 0 0; 7 0 0 0; 0 0 0 0; 0 0 0 0];        %Setting Player Color Assignment

    P1.XG = [50];                                                       %Setting the Growth Center X Coordinate
    P1.YG = [50];                                                       %Setting the Growth Center y Coordinate

    P2 = P1;                                                            %Mirroring Second Structure

    P2.Z  = [2 2 2 2; 3 3 2 2; 8 3 2 2; 9 3 2 2; 10 3 2 2; 11 3 2 2; 3 3 2 2; 2 2 2 2];                                           %Overwriting Zones
    P2.PC = [0 0 0 0; 0 0 0 0; 2 0 0 0; 4 0 0 0; 6 0 0 0; 8 0 0 0; 0 0 0 0; 0 0 0 0];                                           %Overwriting Player Color Assignment

    dom = [-68 -54; -36 -12; 12 36; 54 68];

    [P1X,P1Y] = function_to_points([f(1); {cent1}; {000}],[{dom};{[2; 2; 2]}; {1}],[{[-yspan yspan]}; {4}; {1}]); %Parabola 1 X-Y Coordinates
    [P2X,P2Y] = function_to_points([f(1); {cent2}; {180}],[{dom};{[2; 2; 2]}; {1}],[{[-yspan yspan]}; {4}; {1}]); %Parabola 2 X-Y Coordinates

    for k1 = 1:length(O)
      for k2 = 1:length(o)
        [P1.XB,P1.YB] = SimpleRotate(P1X,P1Y,O(k1)+o(k2),[50 50]); [P2.XB,P2.YB] = SimpleRotate(P2X,P2Y,O(k1)-o(k2),[50 50]); [S.XB,S.YB] = SimpleRotate(SX,SY,O(k1),[50 50]);
        [LM_P1,P1] = LandScribeV6(P1,[1 1]); [LM_P2,P2] = LandScribeV6(P2,[1 1]); [LM_S,~] = LandScribeV6(S,[1 1]); [LM_P1,LM_P2] = LandIDMirror(LM_P1,LM_P2);
        LM_PI = [LM_P1; LM_P2]; j += 1; [COMMAND(j).XY] = [RMS_Processor_V6([LM_PI; LM_S])]; %Processing the Lines of Code from Scribed Lands
      end
    end
    List = RMS_RS_V2(O,o,{'C'},COMMAND); CODE = [CODE; List]; rmfield(S,'XB'); rmfield(S,'YB');  clear COMMAND P1 P2
  else
  end
  %
end
%

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV8('Nesia.ods')
