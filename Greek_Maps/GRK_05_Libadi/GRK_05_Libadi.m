%Greek_Prairie Land Generation
%TechChariot
%8.17.22

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');
[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

MLP                  = [{'create_player_lands'}; ...
                        {'{'}; ...
                        {'terrain_type V'}; ...
                        {'land_percent 98'}; ...
                        {'base_size 0'}; ...
                        {'base_elevation 5'}; ...
                        {'clumping_factor 30'}; ...
                        {'border_fuzziness 1'}; ...
                        {'if TINY_MAP'}; ...
                        {'circle_radius 30 0 left_border 16 right_border 16 top_border 16 bottom_border 16'};
                        {'elseif SMALL_MAP'}; ...
                        {'circle_radius 30 0 left_border 14 right_border 14 top_border 14 bottom_border 14'};
                        {'elseif MEDIUM_MAP'}; ...
                        {'circle_radius 29 0 left_border 12 right_border 12 top_border 12 bottom_border 12'};
                        {'elseif LARGE_MAP'}; ...
                        {'circle_radius 28 0 left_border 10 right_border 10 top_border 10 bottom_border 10'};
                        {'elseif HUGE_MAP'}; ...
                        {'circle_radius 27 0 left_border 9 right_border 9 top_border 9 bottom_border 9'};
                        {'elseif GIGANTIC_MAP'}; ...
                        {'circle_radius 27 0 left_border 8 right_border 8 top_border 8 bottom_border 8'};
                        {'else'}; ...
                        {'endif'}; ...
                        {'}'}];

MLA = [{'L'}; ...
       {'{'}; ...
       {'terrain_type Y'}; ...
       {'land_position 50 50'}; ...
       {'base_elevation 5'}; ...
       {'land_percent 100'}; ...
       {'}'}];

Config = [{1}]; k = 1;
for i = 1:length(Config)
FC = [];
for j = 1:360
FC = [FC; LandScribeV5([{'Y'}],[{5}],{00 00},{j-1},{'0*x'},{1},{0},[22 23])]; %Field Circle Generation
end
%

[COMMAND(k).XY] = [RMS_Processor_V4([FC],LPM_exp)];

k = k + 1;
end
%

[List] = RMS_RS_V2(Config,{'C'},COMMAND);

CODE = [Preface; MLP; List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc


%ObjectAutoscribeV8('Libadi.ods')
