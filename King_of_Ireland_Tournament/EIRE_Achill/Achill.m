%Template Land Generation
%TechChariot
%8.11.21

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms'); 

swrlcnst = [{1}];

[Random_Statement] = RMS_RS (swrlcnst,{'C'});

[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename);

ML3 = LandScribeV5([{'DLC_WETROCKBEACH'}],[{0}],{0 0},{00},{'0*x'},{1},{90},[-45 45]);
ML2 = LandScribeV5([{'DLC_WETROCKBEACH'}],[{0}],{0 0},{00},{'0*x'},{1},{80},[-40 40]);
ML1 = LandScribeV5([{'DLC_WETROCKBEACH'}],[{0}],{0 0},{00},{'0*x'},{1},{70},[-35 35]);

KB = LandScribeV5([{'BEACH'}],[{0}],{0 17},{45},{'0.01*x.^2'},{1},{12},[-12 12]); 
WestCoast  = LandScribeV5([{'GRASS'}],[{0}],{0 45},{45},{'0.01*x.^2'},{1},{60},[-45 45]); 
[LPM_WestCoast_exp] = LPM_Shadow(cell2mat(WestCoast(:,1:2)),1*ones(length(WestCoast),1));
LPM_exp = [LPM_exp; LPM_WestCoast_exp];

MTN1 = LandScribeV5([{'DLC_WETROCKBEACH'}],[{5} {7} {9} {11} {13} {13} {13} {13} {11} {9} {7} {5}],{00 -24},{00},{'0*x'},{1},{22},[-35 -17]);
MTN2 = LandScribeV5([{'DLC_WETROCKBEACH'}],[{5} {7} {9} {11} {13} {13} {13} {13} {11} {9} {7} {5}],{00 -24},{90},{'0*x'},{1},{22},[ 17  35]);

[COMMAND3] = RMS_Processor_Random_Coord([ML3],LPM_exp,2);
[COMMAND2] = RMS_Processor_Random_Coord(ML2,LPM_exp,1);
[COMMAND1] = RMS_Processor_V2([KB; ML1],LPM_exp);
[MTNCMMD] =  RMS_Processor_V2([MTN1;MTN2],LPM_exp);



COMMAND = [COMMAND3; COMMAND2; COMMAND1; MTNCMMD];

j = 0;
if j == 0
LogicTag = [{['if C' sprintf('%02d',j)]}];
CODE = [LogicTag; COMMAND];
else
LogicTag = [{['elseif C' sprintf('%02d',j)]}];
CODE = [CODE; LogicTag; COMMAND];
end
%
j = j + 1;

%
CODE = [Preface; Random_Statement; CODE;{'else'};{'endif'}]; %Adding End of Logic Statement



%ObjectAutoscribeV8('ObjectDatabaseV2.ods')


%CODE = [Preface; Random_Statement; create_player_lands; CODE]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc
