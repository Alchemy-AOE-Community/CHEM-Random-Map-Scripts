%Bluegill Land Generation
%TechChariot
%01.15.23

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = [path(1:89)]; addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');


[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename);

GILL_O = [LandScribeV5({'WO'},{0},{[0 +22]},{0},{'-0.035*x.^2'},{2},{1},[-20 20]); ...
          LandScribeV5({'WO'},{0},{[0 -22]},{0},{'+0.035*x.^2'},{2},{1},[-20 20])];

GILL_I = [LandScribeV5({'WI'},{0},{[0 +10]},{0},{'-0.020*x.^2'},{2},{1},[-16 16]);...
          LandScribeV5({'WI'},{0},{[0 -10]},{0},{'+0.020*x.^2'},{2},{1},[-16 16])];

GILL_CON = [LandScribeV5({'WRB'},{0},{[0 +20]},{90},{'-0.04*x.^2'},{2},{1},[-6 6]); ...
            LandScribeV5({'WRB'},{0},{[0 -20]},{90},{'+0.04*x.^2'},{2},{1},[-6 6])];

RING = [];

for i = 1:360
RING = [RING; LandScribeV5({'GRASS'},{1},{[0 0]},{i},{['0*x']},{1},{0},(1+40*abs(sind(i))/360)*[33 33])];
end
%

RawLand = [GILL_CON; GILL_O; GILL_I; RING; Rounded_Rectangle({102},{1},{30},{'OB'},{2},{0})];

COMMAND = RMS_Processor_V4(RawLand,LPM_exp);

MLA = [{'L { terrain_type MUD land_position 50 50 base_size 0 land_percent 100 }'};...
       {'L { terrain_type MUD land_position 50 35 base_size 0 land_percent 100 }'};...
       {'L { terrain_type MUD land_position 50 65 base_size 0 land_percent 100 }'};...
       {'L { land_position 15 15   terrain_type GRASS3 base_size 0 base_elevation 1 land_percent 100 }'}; ...
       {'L { land_position 15 85   terrain_type GRASS3 base_size 0 base_elevation 1 land_percent 100 }'}; ...
       {'L { land_position 85 15   terrain_type GRASS3 base_size 0 base_elevation 1 land_percent 100 }'}; ...
       {'L { land_position 15 85   terrain_type GRASS3 base_size 0 base_elevation 1 land_percent 100 }'}; ...
       {'L { land_position 1 1     terrain_type OB base_size 0 base_elevation 2 land_percent 100 }'}; ...
       {'L { land_position 1 99    terrain_type OB base_size 0 base_elevation 2 land_percent 100 }'}; ...
       {'L { land_position 99 1    terrain_type OB base_size 0 base_elevation 2 land_percent 100 }'}; ...
       {'L { land_position 99 99   terrain_type OB base_size 0 base_elevation 2 land_percent 100 }'}];




List = COMMAND;

G = []; C = [];

r = [33]; off = [40 42 44 46 48 50];
adc = [170 172 174 176 178 180 182 184 186 188 190];
SA  = [0 90]; b  = [0 0.05 0.1]; ecc = [1];
G = [{r}; {off}; {adc}; {SA}; {b}; {ecc}];


BE = 1; BS = 6; LP = 0; ZA = 0; delta = 0;
C = [{BE}; {BS}; {LP}; {ZA}; {delta}];

[create_player_lands] = RMS_CPL_V7(G,C);

CODE = [Preface; List; MLA; create_player_lands]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

%ObjectAutoscribeV8('Bluegill.ods')

disp(["Run Completed " datestr(clock) "..."])
toc
