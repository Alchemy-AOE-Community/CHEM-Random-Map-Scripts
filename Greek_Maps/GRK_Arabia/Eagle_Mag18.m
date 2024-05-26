%Return of the Rising Eagle Cup Arabia Land Generation
%TechChariot
%3.04.23

clear all
close all
clc

pkg load image

tic
disp(["Run Executed " datestr(clock) "..."])

filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:90); addpath(genpath(path)) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

L = 'C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts\Age-of-Empires-II-Definitive-Edition----Random-Map-Scripts\Return_of_the_Rising_Eagle_Cup\RREC_Arabia\eaglerot.png'
f = 1.8; cut = 0;
M = ImagetoLands(f,L,cut);

save('Eagle_Points_M18','M')

disp(["Run Completed " datestr(clock) "..."])
toc
