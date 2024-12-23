%Asteroid Belt Land Generation
%TechChariot
%02.23.2024

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%% -- World Lands -- %%
CRW = [99 1]; %Center of the Rimworld

%% -- Planet Boundary -- %%
rb   = [45];   %Radius of the Rimworld
Ob = linspace(90,181,91)'; %Angular Distribution of the Rimworld

RIMWORLD_X = []; RIMWORLD_Y = [];

RIMWORLD_X = rb*cosd(Ob)+CRW(1,1); RIMWORLD_Y = rb*sind(Ob)+CRW(1,2);

RIMWORLD.X = RIMWORLD_X; RIMWORLD.Y = RIMWORLD_Y;

RIMWORLD.TT = [{'RIM_TER'}];  %terrain type
RIMWORLD.BE = 0;         %base elevation
RIMWORLD.NT = 0;
RIMWORLD.BS = 2;
RIMWORLD.SS = 1;
[LM_RIMWORLD,~] = LandScribeV6(RIMWORLD,[1 1]);

%% -- Planet Substance -- %%
rc = [2:4:38]; Oc = [90:5:180]';
COREWORLD_X = cosd(Oc)*rc+CRW(1,1); COREWORLD_Y = sind(Oc)*rc+CRW(1,2);
COREWORLD.X = COREWORLD_X; COREWORLD.Y = COREWORLD_Y;
COREWORLD.TT = [{'CORE_TER'}];
COREWORLD.BE = 1;
COREWORLD.BS = 1;
[LM_COREWORLD,~] = LandScribeV6(COREWORLD,[1 1]);

%% -- Outside the Belt -- %%
ro = 118+[2:8:18]; Oo = [90:2:180]';
OUTSIDE_X = cosd(Oo)*ro+CRW(1,1); OUTSIDE_Y = sind(Oo)*ro+CRW(1,2);
OUTSIDE.X = OUTSIDE_X; OUTSIDE.Y = OUTSIDE_Y;
OUTSIDE.TT = [{'RIM_TER'}]; OUTSIDE.CF = [25];
OUTSIDE.BE = 0;
OUTSIDE.NT = 60;
OUTSIDE.BS = 2;
OUTSIDE.SS = 3;
[LM_OUTSIDE,~] = LandScribeV6(OUTSIDE,[1 1]);

%% -- Override Land (To block spawn of lands without a place to go) -- %%
OVERRIDE.X = 50; OVERRIDE.Y = 50;
OVERRIDE.TT = [{'BT'}];
OVERRIDE.BS = [4];
[LM_OVERRIDE,~] = LandScribeV6(OVERRIDE,[1 1]);


%% -- Defining Neutral Patterned Player Lands -- %%
tag = [{'if P2'}; {'elseif P4'}; {'elseif P6'}; {'elseif P8'}; {'endif'}];

Size_List = []; %Initializing Size List
Static_List = [];
Om = 135; %Median Angle

for j = 1:5
  Size_List = [Size_List; tag(j)];
  if     j == 1 % 1 or 2 players

    R = [74 78 82 86]; %Player Land Radius
    Od = [15 17.5 20 22.5 25]; %Player Land Angular Offset From Medium
    K = 1;
    for i1 = 1:length(Od)
      for i2 = 1:length(R)

        PL_X = R(i2)*[cosd(Om-Od(i1)) cosd(Om+Od(i1))]+CRW(1,1);
        PL_Y = R(i2)*[sind(Om-Od(i1)) sind(Om+Od(i1))]+CRW(1,2);

        PL.XB = PL_X; PL.YB = PL_Y;                   %Center of Land Growth
        PL.XG = 50; PL.YG = 50; PL.v = 80; PL.w = 80; %Avoiding Borders

        PL.TT = [{'ASTEROID_TER'}]; PL.BE = 1; PL.CF = 25;
        PL.NT = 600; PL.BS = 7;
        PL.PC = [1 2]; PL.Z = [1 2]; PL.OZA = [8];

        [LM_PL,~] = LandScribeV6(PL,[1 1]);
        [COMMAND(K).XY] = [RMS_Processor_V6([LM_PL])];

        clear PL LM_PL
        K += 1;

      end
      %
    end
    %
    Dynamic_List = RMS_RS_V2(R,Od,{'C'},COMMAND);

%    nas = 64; INIT = ones(floor(sqrt(nas)),floor(sqrt(nas)));
%
%    FIELD.BE  = 1; FIELD.TT  = {'ASTEROID_TER'};
%    FIELD.NT.s1 = 40*INIT;
%    FIELD.NT.s2 = 80*INIT;
%    FIELD.BS.s1 = 1;
%    FIELD.BS.s2 = 2;
%    FIELD.OZA = 15;
%
%    [LM_FIELD,~] = LandScribeV6(FIELD,[1 1]);
%    Static_List  = RMS_Processor_V6([LM_FIELD]);
    Size_List = [Size_List; Dynamic_List; Static_List];

  elseif j == 2 % 3 or 4 players

    R = [74 78 82 86]; %Player Land Radius
    Od = [24 25 26 27]; %Player Land Angular Offset From Medium
    d  = [11 12 13]; %Player Land Angular Difference Between Players of Same Team

    K = 1;
    for i1 = 1:length(Od)
      for i2 = 1:length(R)
        for i3 = 1:length(d)
          PL_X = R(i2)*[cosd(Om-Od(i1)-d(i3)) cosd(Om-Od(i1)+d(i3)) cosd(Om+Od(i1)-d(i3)) cosd(Om+Od(i1)+d(i3))]+CRW(1,1);
          PL_Y = R(i2)*[sind(Om-Od(i1)-d(i3)) sind(Om-Od(i1)+d(i3)) sind(Om+Od(i1)-d(i3)) sind(Om+Od(i1)+d(i3))]+CRW(1,2);

          PL.XB = PL_X; PL.YB = PL_Y;                   %Center of Land Growth
          PL.XG = 50; PL.YG = 50; PL.v = 88; PL.w = 88; %Avoiding Borders

          PL.TT = [{'ASTEROID_TER'}]; PL.BE = 1; PL.CF = 25;
          PL.NT = 600; PL.BS = 7;
          PL.PC = [3 1 2 4]; PL.Z = [1 2 3 4]; PL.OZA = [8];

          [LM_PL,~] = LandScribeV6(PL,[1 1]);
          [COMMAND(K).XY] = [RMS_Processor_V6([LM_PL])];

          clear PL LM_PL
          K += 1;
        end
        %
      end
      %
    end
    %
    Dynamic_List = RMS_RS_V2(d,R,Od,{'C'},COMMAND);

%    nas = 100; INIT = ones(floor(sqrt(nas)),floor(sqrt(nas)));
%
%    FIELD.BE  = 1; FIELD.TT  = {'ASTEROID_TER'};
%    FIELD.NT.s1 = 40*INIT;
%    FIELD.NT.s2 = 80*INIT;
%    FIELD.BS.s1 = 1;
%    FIELD.BS.s2 = 2;
%    FIELD.OZA = 15;
%
%    [LM_FIELD,~] = LandScribeV6(FIELD,[1 1]);
%    Static_List  = RMS_Processor_V6([LM_FIELD]);

    Size_List = [Size_List; Dynamic_List; Static_List];

  elseif j == 3 % 5 or 6 players

    R  = [74 78 82 86]; %Player Land Radius
    Od = [23 24 25 26]; %Player Land Angular Offset From Medium
    d  = [13 14 15]; %Player Land Angular Difference Between Players of Same Team

    K = 1;
    for i1 = 1:length(Od)
      for i2 = 1:length(R)
        for i3 = 1:length(d)
          for i4 = 1:length(d)
            PL_X = R(i2)*[cosd(Om-Od(i1)-d(i3)) cosd(Om-Od(i1)) cosd(Om-Od(i1)+d(i4)) ...
                          cosd(Om+Od(i1)-d(i3)) cosd(Om+Od(i1)) cosd(Om+Od(i1)+d(i4))]+CRW(1,1);
            PL_Y = R(i2)*[sind(Om-Od(i1)-d(i3)) sind(Om-Od(i1)) sind(Om-Od(i1)+d(i4)) ...
                          sind(Om+Od(i1)-d(i3)) sind(Om+Od(i1)) sind(Om+Od(i1)+d(i4))]+CRW(1,2);

            PL.XB = PL_X; PL.YB = PL_Y;                   %Center of Land Growth
            PL.XG = 50; PL.YG = 50; PL.v = 92; PL.w = 92; %Avoiding Borders

            PL.TT = [{'ASTEROID_TER'}]; PL.BE = 1; PL.CF = 25;
            PL.NT = 600; PL.BS = 7;
            PL.PC = [5 3 1 2 4 6]; PL.Z = [1 2 3 4 5 6]; PL.OZA = [8];

            [LM_PL,~] = LandScribeV6(PL,[1 1]);
            [COMMAND(K).XY] = [RMS_Processor_V6([LM_PL])];

            clear PL LM_PL
            K += 1;
          end
          %
        end
        %
      end
      %
    end
    %
    Dynamic_List = RMS_RS_V2(d,d,R,Od,{'C'},COMMAND);

%    nas = 144; INIT = ones(floor(sqrt(nas)),floor(sqrt(nas)));
%
%    FIELD.BE  = 1; FIELD.TT  = {'ASTEROID_TER'};
%    FIELD.NT.s1 = 40*INIT;
%    FIELD.NT.s2 = 80*INIT;
%    FIELD.BS.s1 = 1;
%    FIELD.BS.s2 = 2;
%    FIELD.OZA = 15;
%
%    [LM_FIELD,~] = LandScribeV6(FIELD,[1 1]);
%    Static_List  = RMS_Processor_V6([LM_FIELD]);

    Size_List = [Size_List; Dynamic_List; Static_List];

  elseif j == 4 % 7 or 8 players

    R = [74 78 82 86]; %Player Land Radius
    d = [-1 0 1];

    K = 1;
    for i1 = 1:length(R)
      for i2 = 1:length(d)
        for i3 = 1:length(d)
          for i4 = 1:length(d)
            for i5 = 1:length(d)

              PL_X = R(i1)*[cosd(Om+8+d(i2)) cosd(Om+19+d(i3)) cosd(Om+30+d(i4)) cosd(Om+41+d(i5)) ...
                            cosd(Om-8+d(i2)) cosd(Om-19+d(i3)) cosd(Om-30+d(i4)) cosd(Om-41+d(i5))] + CRW(1,1);
              PL_Y = R(i1)*[sind(Om+8+d(i2)) sind(Om+19+d(i3)) sind(Om+30+d(i4)) sind(Om+41+d(i5)) ...
                            sind(Om-8+d(i2)) sind(Om-19+d(i3)) sind(Om-30+d(i4)) sind(Om-41+d(i5))] + CRW(1,2);

              PL.XB = PL_X; PL.YB = PL_Y;                   %Center of Land Growth
              PL.XG = 50; PL.YG = 50; PL.v = 94; PL.w = 94; %Avoiding Borders

              PL.TT = [{'ASTEROID_TER'}]; PL.BE = 1; PL.CF = 25;
              PL.NT = 600; PL.BS = 7;
              PL.PC = [7 5 3 1 2 4 6 8]; PL.Z = [1 2 3 4 5 6 7 8]; PL.OZA = [8];

              [LM_PL,~] = LandScribeV6(PL,[1 1]);
              [COMMAND(K).XY] = [RMS_Processor_V6([LM_PL])];

              clear PL LM_PL
              K += 1;

            end
            %
          end
          %
        end
        %
      end
      %
    end
    %
    Dynamic_List = RMS_RS_V2(d,d,d,d,R,{'C'},COMMAND);

%    nas = 256; INIT = ones(floor(sqrt(nas)),floor(sqrt(nas)));
%
%    FIELD.BE  = 1; FIELD.TT  = {'ASTEROID_TER'};
%    FIELD.NT.s1 = 40*INIT;
%    FIELD.NT.s2 = 80*INIT;
%    FIELD.BS.s1 = 1;
%    FIELD.BS.s2 = 2;
%    FIELD.OZA = 15;
%
%    [LM_FIELD,~] = LandScribeV6(FIELD,[1 1]);
%    Static_List  = RMS_Processor_V6([LM_FIELD]);


    Size_List = [Size_List; Dynamic_List; Static_List];


  else

  end
  %


end
%

%% -- Asteroid Field -- %%
nas = 256; INIT = ones(floor(sqrt(nas)),floor(sqrt(nas)));

FIELD.BE  = 1; FIELD.TT  = {'ASTEROID_TER'};
FIELD.NT.s1 = 40*INIT;
FIELD.NT.s2 = 80*INIT;
FIELD.BS.s1 = 1;
FIELD.BS.s2 = 2;
FIELD.OZA = 15;

[LM_FIELD,~] = LandScribeV6(FIELD,[1 1]);
Static_List  = RMS_Processor_V6([LM_FIELD]);



Final_Static_List  = [RMS_Processor_V6([LM_RIMWORLD; LM_COREWORLD; LM_OUTSIDE; LM_FIELD]); RMS_Processor_V6([LM_OVERRIDE])];

CODE = [Preface; Size_List; Final_Static_List]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV9('HVN_08_Asteroid_Belt.ods')
