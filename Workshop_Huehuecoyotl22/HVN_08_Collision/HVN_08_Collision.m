%Collision Land Generation
%TechChariot
%02.19.2024

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:89); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%% -- Section on Border -- %%
R = 20;
sep = 50;

Y = [0 15 30 45 60 75 90];

o = -45;

K = 1;
for i1 = 1:1

  for i2 = 1:length(Y)

    O1 = [(Y(i2)+o):(Y(i2)+180-o)];
    O2 = [(Y(i2)+180+o):(Y(i2)+360-o)];
    O = [O1 O2]; dnO = length(O1);

    BORDER.TT = [{'BORDER_TER1'}; {'BORDER_TER2'}];  %terrain type
    BORDER.BE = 1;         %base elevation
    BORDER.Z  = [1; 2];
    BORDER.NT = 0;
    BORDER.BS = 2;
    BORDER.SS = 2;
    BORDER.OZA = 10;


    FILL.TT  = [{'FILL_TER'}];  %terrain type
    FILL.BE  = 0;         %base elevation
    FILL.Z   = [4];
    FILL.BS = 1;
    FILL.SS = 2;
    FILL.CF = 25;
    FILL.OZA = 1;

    FILL_X = [27 73]; FILL_Y = [47; 50; 53];

    FILL_X = ones(3,1)*FILL_X;
    FILL_Y = FILL_Y*ones(1,2);

    [FILL_X,FILL_Y] = SimpleRotate(FILL_X,FILL_Y,Y(i2),[50 50]);

    FILL.X = FILL_X; FILL.Y = FILL_Y;

    [LM_FILL,~] = LandScribeV6(FILL,[1 1]);

    BLOCK.TT = [{'BORDER_TER1'}; {'BORDER_TER2'}]; %terrain type
    BLOCK.NT = [50];
    BLOCK.BS = [1];
    BLOCK.BE = [1];
    BLOCK.SS = [3];
    BLOCK.Z   = [1; 2];
    BLOCK.OZA = [10];

    BORDER_X = []; BORDER_Y = [];

    for i = 1:length(O)

      if i <= dnO
        cen(i,:)   = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; +sep/2];     %generic center
        cenpl(i,:) = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; +sep/2+0.95*R/2]; %center of player lands
      else
        cen(i,:)   = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; -sep/2];;     %generic center
        cenpl(i,:) = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; -sep/2-0.95*R/2];; %center of player lands
      end
      %

      BORDER_X = [BORDER_X; R*cosd(O(i))+cen(i,1)]; BORDER_Y = [BORDER_Y; R*sind(O(i))+cen(i,2)];

    end
    %

    BLOCK_X  = 50+[-R*cosd(o):1:R*cosd(o)];
    BLOCK_Y  = 50+[+sep/2+R*sind(o); -sep/2-R*sind(o)];

    BLOCK_X = ones(2,1)*BLOCK_X;
    BLOCK_Y = BLOCK_Y*ones(1,length(BLOCK_X));

    [BLOCK_X,BLOCK_Y] = SimpleRotate(BLOCK_X,BLOCK_Y,Y(i2));

    BLOCK.X = BLOCK_X; BLOCK.Y = BLOCK_Y;

    [LM_BLOCK,~] = LandScribeV6(BLOCK,[1 1]);

    BORDER.X = BORDER_X; BORDER.Y = BORDER_Y;
    [LM_BORDER,~] = LandScribeV6(BORDER,[1 1]);

    %% -- Left Explosion -- %%
    [LECX,LECY] = SimpleRotate(50,50+2.25*R,Y(i2)+90);

    xr = [-24 24];
    yr = [-12 16];

    [LE_X,LE_Y,~,~] = function_to_points_V3([{'-0.0075*x.^2'} {[LECX LECY]} {Y(i2)+90}],xr,yr,[8 14; 8 8],[60],[{'edge'}; {'edge'}]);

    LE.TT.s1 = [{'BORDER_TER1'}]; %terrain type
    LE.TT.s2 = [{'BORDER_TER2'}]; %terrain type

    [nx,ny] = size(LE_X);

    [~,~,H,~,~] = poisson2D([{xr} {nx}; {yr} {ny}],[{'N'} {'0'}; {'N'} {'0'}; {'D'} {'20'}; {'D'} {'100'}],0.1,0*LE_X);
    LE.NT.s1 = H;
    RE.NT.s1 = fliplr(H);

    [~,~,H,~,~] = poisson2D([{xr} {nx}; {yr} {ny}],[{'N'} {'0'}; {'N'} {'0'}; {'D'} {'20'}; {'D'} {'100'}],0.1,0*LE_X);
    LE.NT.s2 = H;
    RE.NT.s2 = fliplr(H);

    LE.BS = 2;
    LE.BE = 0;
    LE.SS = 3;
    LE.CF = 25;

    LE.X = LE_X; LE.Y = LE_Y;

    [LM_LE,~] = LandScribeV6(LE,[1 1]);

    %% -- Right Explosion (Mirror) -- %%
    [RECX,RECY] = SimpleRotate(50,50+2.25*R,Y(i2)-90);

    yr = [-16 12];

    [RE_X,RE_Y,~,~] = function_to_points_V3([{'0.0075*x.^2'} {[RECX RECY]} {Y(i2)+90}],xr,yr,[8 14; 8 8],[60],[{'edge'}; {'edge'}]);

    RE.TT.s1 = LE.TT.s1;
    RE.TT.s2 = LE.TT.s2;

    RE.BS = LE.BS;
    RE.BE = LE.BE;
    RE.SS = LE.SS;
    RE.CF = LE.CF;

    RE.X = RE_X; RE.Y = RE_Y;

    [LM_RE,~] = LandScribeV6(RE,[1 1]);


    %% -- Outside Blocker -- %%

    OB_X = [-10:(50-1.1*R) (50+1.1*R):110]';
    OB_Y = [15 85];

    OB.X = OB_X*ones(1,length(OB_Y));
    OB.Y = ones(length(OB_X),1)*OB_Y;

    [OB.X,OB.Y] = SimpleRotate(OB.X,OB.Y,Y(i2),[50 50]);

    OB.TT = [{'BLOCKER_TER'}];  %terrain type
    OB.BE = 0;         %base elevation
    OB.Z   = [1; 2];
    OB.NT = 0;
    OB.BS = 2;

    [LM_OB,~] = LandScribeV6(OB,[1 1]);


    %% -- Outside Filler -- %%

    OF_X = [1:3:(50-1.4*R) (50+1.4*R):3:99]';
    OF_Y = [2 6 10 90 94 98];

    OF.X = OF_X*ones(1,length(OF_Y));
    OF.Y = ones(length(OF_X),1)*OF_Y;

    [OF.X,OF.Y] = SimpleRotate(OF.X,OF.Y,Y(i2),[50 50]);

    OF.TT = [{'BLOCKER_TER'}];  %terrain type
    OF.BE = 0;         %base elevation
    OF.Z  = [3];
    OF.BS = 1;
    OF.OZA = 3;

    [LM_OF,~] = LandScribeV6(OF,[1 1]);

    %% -- Section on Player Lands -- %%

    % G = [{Vector of Radii}; ...
    %      {Vector of Angular Offsets Between Flank and Pocket}; ...
    %      {Vector of Angular Distance to Centroid of Teams}; ...
    %      {Vector of Clocking "Seed Angles"}; ...
    %      {Vector of Team Biases}; ...
    %      {Vector of Eccentricities}; ...
    %      {Matrix of Team Centers}] (geometric inputs)

    % C = [{Base Elevation}; ...
    %      {Base Size}; ...
    %      {Number of Tiles}; ...
    %      {[Zones (1-8), Avoidances (#-#)]}; ...
    %      {Linear Slop};
    %      {[left right top bottom] border avoidances}]  (characteristic inputs)

    G = [{R*[0.75 0.85]}; {[40 45 50]}; {[175 180 190]}; {Y(i2)}; {[0]}; {[0]}; {[cenpl(1,1) cenpl(1,2); cenpl(end,1) cenpl(end,2)]}];
    C = [{1}; {4}; {14400}; {[1 0; 2 0; 1 0; 2 0; 1 0; 2 0; 1 0; 2 0]}];

    [PL] = RMS_CPL_V10(G,C);

    [COMMAND(K).XY] = [PL; RMS_Processor_V6([LM_BLOCK; LM_BORDER; LM_LE; LM_RE; LM_OB; LM_OF; LM_FILL])];

    clear BORDER LM_BORDER FILL LM_FILL BLOCK LM_BLOCK LE LM_LE RE LM_RE OF LM_OF OB LM_OB
    K += 1;
  end
  %
end
%
Dynamic_List = RMS_RS_V2(1,Y,{'C'},COMMAND);
Static_List  = [];

CODE = [Preface; Dynamic_List; Static_List]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV9('HVN_08_Collision.ods')
