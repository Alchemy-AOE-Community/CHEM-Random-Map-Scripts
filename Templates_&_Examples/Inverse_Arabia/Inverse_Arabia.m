%Inverse Arabia Land Generation
%TechChariot
%2024-11-28

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
R = 30;

Y = [-45 -22.5 0 22.5 45];
o = -45;

K = 1;

for i2 = 1:length(Y)

  O1 = [(Y(i2)+o):(Y(i2)+180-o)];
  O2 = [(Y(i2)+180+o):(Y(i2)+360-o)];
  O = [O1 O2]; dnO = length(O1);

  sep = 58 + 12./cosd(Y(i2));

    for i = 1:length(O)

      if i <= dnO
  ##        cen(i,:)   = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; +sep/2];     %generic center
        cenpl(i,:) = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; +sep/2+0.95*R/2]; %center of player lands
      else
  ##        cen(i,:)   = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; -sep/2];;     %generic center
        cenpl(i,:) = 50 + [cosd(Y(i2)) -sind(Y(i2)); sind(Y(i2)) cosd(Y(i2));]*[0; -sep/2-0.95*R/2];; %center of player lands
      end
      %

    end
    %

    b = [0.22 0.24] + 0.04*cosd(Y(i2));
    f = 0.05 + 0.11*(1-cosd(Y(i2)));
    adc = 180*[(1-f) (1-0.5*f) 1 (1+0.5*f) (1+f)];

    G = [{R*[1.250 1.265 1.280]}; {[43 45 47]}; {adc}; {Y(i2)}; {b}; {[0 0.1]}; {[cenpl(1,1) cenpl(1,2); cenpl(end,1) cenpl(end,2)]}];

    C = [{0}; {0}; {0}; {[1 6; 2 6; 3 6; 4 6; 5 6; 6 6; 7 6; 8 6]}; {[0]}; {[3; 3; 3; 3]}];

    [PL] = RMS_CPL_V10(G,C);

    [COMMAND(K).XY] = [PL];

    clear BORDER LM_BORDER FILL LM_FILL BLOCK LM_BLOCK LE LM_LE RE LM_RE OF LM_OF OB LM_OB
    K += 1;
end
%
Dynamic_List = [{'if INVERSION'};  RMS_RS_V2(Y,sep,{'C'},COMMAND); {'else'}; {'create_player_lands { circle_radius 25 5 terrain_type PT1 base_size 0 number_of_tiles 0 clumping_factor 30 other_zone_avoidance_distance 6 left_border 3 right_border 3 top_border 3 bottom_border 3 }'}; {'endif'}];
Static_List  = [];

CODE = [Preface; Dynamic_List; Static_List]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV9('Inverse_Arabia')
