%Akropole (Greek Team Acropolis) Land Generation
%TechChariot
%10.4.22

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');
[Preface,LPM_exp,~] = RMS_Manual_Land(filename);


MLP = [{'L { terrain_type NNRB base_elevation 0 land_position 50 50 base_size 3 number_of_tiles 121 clumping_factor 30 zone 1 }'}];

MLA = [{'create_player_lands'};
       {'{'};
       {'terrain_type K'};
       {'base_elevation 7'};
       {'clumping_factor 30'};
       {'set_zone_by_team'};
       {'clumping_factor 30'};
       {'border_fuzziness 6'};
       {'if TINY_MAP'};
       {'base_size 12'};
       {'circle_radius 34 0'};
       {'land_percent 20'};
       {'other_zone_avoidance_distance 18'};
       {'top_border 16 bottom_border 16 right_border 16 left_border 16'};
       {'elseif SMALL_MAP'};
       {'base_size 13'};
       {'circle_radius 36 0'};
       {'land_percent 33'};
       {'other_zone_avoidance_distance 21'};
       {'top_border 15 bottom_border 15 right_border 15 left_border 15'};
       {'elseif MEDIUM_MAP'};
       {'base_size 14'};
       {'circle_radius 37 0'};
       {'land_percent 46'};
       {'other_zone_avoidance_distance 24'};
       {'top_border 14 bottom_border 14 right_border 14 left_border 14'};
       {'elseif LARGE_MAP'};
       {'base_size 15'};
       {'circle_radius 38 0'};
       {'land_percent 48'};
       {'other_zone_avoidance_distance 24'};
       {'top_border 12 bottom_border 12 right_border 12 left_border 12'};
       {'elseif HUGE_MAP'};
       {'base_size 16'};
       {'circle_radius 39 0'};
       {'land_percent 50'};
       {'other_zone_avoidance_distance 24'};
       {'top_border 11 bottom_border 11 right_border 11 left_border 11'};
       {'elseif GIGANTIC_MAP'};
       {'base_size 18'};
       {'circle_radius 39 0'};
       {'land_percent 52'};
       {'other_zone_avoidance_distance 24'};
       {'top_border 10 bottom_border 10 right_border 10 left_border 10'};
       {'else'};
       {'endif'};
       {'}'}];

List = [];
%[List] = RMS_RS_V2(f,Angle,{'C'},COMMAND);
CODE = [Preface; MLP; List; MLA; ]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV8('Akropole.ods')
