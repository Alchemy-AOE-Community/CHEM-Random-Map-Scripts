%Tara Land Generation
%TechChariot
%9.3.21

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

adc = [175 180 185];       %Angular Distance to Team Centroid
off =  [45];           %Player Starting Offset Angle
%SA  =  [-45 135];           %Player Starting Seed Angle
SA  =  [-50 -45 -40 130 135 140];           %Player Starting Seed Angl
b   =  [0.6];          %Player Starting team bias factor
r   =  [74 78 82];           %Player Starting Group radius
e   = 0.25; e = 2*e;    %Player Starting Eccentricity

[create_player_lands] = RMS_CPL_V6({3},{1},{1},off,adc,SA,b,r,e);

config = [{1} {1}]; K = 1;

for k = 1:length(config);
%Angular Orientation of Various Shapes
Angle = [{45};];

%Oasis Basic Parameters
r  = [2];     %Aspect Ratio of the Oasis

Countryside_Terrain = [{'S'} {'S'} {'S'} {'S'} {'S'} {'S'} {'S'} {'S'}  ...
                       {'S'} {'S'} {'S'} {'S'} {'S'} {'S'} {'S'} {'S'}  ...
                       {'S'} {'S'} {'S'} {'S'} {'S'} {'S'} {'S'} {'S'} ];
                   
LCT = length(Countryside_Terrain);

for i = 1:LCT
Ellipse_Elev(i) = {round(5*(i-1)/LCT)};  
end

Ellipse_Elev = fliplr(Ellipse_Elev);
                   
j = 1;
     
S = 2;   %Spacing Between Layers 
amin = 24; %Setting the inside radius
amax = S*LCT + amin; 
a = [amin:S:amax];


[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename);

Rcountryside = [{}];
for i = 1:LCT
f1 = [{['-' mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 1 
f2 = [{[    mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 2 
[R1] = LandScribeV5(Countryside_Terrain(i),Ellipse_Elev(i),{0 0},Angle,f1,{1},{4},[-a(i) a(i)]); %Ring 1
[R2] = LandScribeV5(Countryside_Terrain(i),Ellipse_Elev(i),{0 0},Angle,f2,{1},{4},[-a(i) a(i)]); %Ring 2
Rtemp = [R1; R2];
Rcountryside = [Rcountryside; Rtemp] ;
end


a = [amin:-S:0];
Rtop = [{}];
for i = 1:length(a)
f1 = [{['-' mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 1 
f2 = [{[    mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 2 
[R1] = LandScribeV5({'R'},{5},{0 -0},Angle,f1,{1},{4},[-a(i) a(i)]); %Ring 1
[R2] = LandScribeV5({'R'},{5},{0 -0},Angle,f2,{1},{4},[-a(i) a(i)]); %Ring 2
Rtemp = [R1; R2];
Rtop = [Rtop; Rtemp] ;
end


Rcountryside = [Rtop; Rcountryside];

r = 1;
%upper mound
terr_um = [{'R2'} {'R2'} {'R2'} {'R2'} {'R2'} ...
           {'G'}  ...
           {'G3'} {'G3'} {'G3'} {'G3'} {'G3'} {'G3'} ...
           {'G'}  ...
 {'R4'} {'R4'} {'R4'} {'R4'} {'R4'} {'R4'} {'R4'} {'R4'} {'R4'}];


a = [length(terr_um)-1:-1:0]; 

Rum = [{}];
for i = 1:length(terr_um)
f1 = [{['-' mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 1 
f2 = [{[    mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 2 
[R1] = LandScribeV5(terr_um(i),{5},{0 (-1)^k*18},Angle,f1,{1},{1},[-a(i) a(i)]); %Ring 1
[R2] = LandScribeV5(terr_um(i),{5},{0 (-1)^k*18},Angle,f2,{1},{1},[-a(i) a(i)]); %Ring 2
Rtemp = [R1; R2];
Rum = [Rum; Rtemp] ;
end
%


%lower mound
terr_lm = [{'R2'} {'R2'} {'R2'} {'R2'} {'R2'} ...
           {'G'} {'G'} ...
           {'Y'} {'Y'} {'Y'} {'Y'} {'Y'} ...
           {'Y'} {'Y'} {'Y'} {'Y'} {'Y'} ...
           {'Y'} {'Y'} {'Y'} {'Y'} ];

a = [length(terr_lm)-1:-1:0]; 

Rlm = [{}];
for i = 1:length(terr_lm)
f1 = [{['-' mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 1 
f2 = [{[    mat2str(r) '*sqrt(' mat2str(a(i)) '^2 - x.^2)']}]; %Function 2 
[R1] = LandScribeV5(terr_lm(i),{5},{0 (-1)^(k+1)*18},Angle,f1,{1},{1},[-a(i) a(i)]); %Ring 1
[R2] = LandScribeV5(terr_lm(i),{5},{0 (-1)^(k+1)*18},Angle,f2,{1},{1},[-a(i) a(i)]); %Ring 2
Rtemp = [R1; R2];
Rlm = [Rlm; Rtemp] ;
end
%


Grid_Forest = LandScribeV5([{'S'}],[{1}],{0 0},{45},{'0*x'},{1},{1},[-75 75]);
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 -25},{45},{'0*x'},{1},{1},[-75 75])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 +25},{45},{'0*x'},{1},{1},[-75 75])];

Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 0},{-45},{'0*x'},{1},{1},[-75 75])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 +25},{-45},{'0*x'},{1},{1},[-75 75])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 -25},{-45},{'0*x'},{1},{1},[-75 75])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 +50},{-45},{'0*x'},{1},{1},[-75 75])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 -50},{-45},{'0*x'},{1},{1},[-75 75])];

Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 -49},{00},{'0*x'},{1},{1},[-50 50])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 -49},{90},{'0*x'},{1},{1},[-50 50])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 +48},{00},{'0*x'},{1},{1},[-50 50])];
Grid_Forest = [Grid_Forest; LandScribeV5([{'S'}],[{0}],{0 +48},{90},{'0*x'},{1},{1},[-50 50])];


[~,idxFRST,idxCNTSD] = union(cell2mat(Grid_Forest(:,1:2)),cell2mat(Rcountryside(:,1:2)),'rows','stable');

tg_vct = [1:length(Rcountryside)];
tg_vct = setdiff(tg_vct,idxCNTSD);
tg_vct = idxCNTSD';
j = 1;
for i = tg_vct
R_Forest(j,:) = Rcountryside(i,:);
R_Forest(j,3) = {'G'};
j = j + 1;
end
%

[LPM_FT_exp] = LPM_Shadow(cell2mat(R_Forest(:,1:2)),3*ones(length(R_Forest),1));
LPM_exp = [LPM_exp; LPM_FT_exp];
LPM_exp = setdiff(LPM_exp,cell2mat([R_Forest(:,1:2); Rtop(:,1:2); Rlm(:,1:2); Rum(:,1:2)]),'rows','stable'); %Removing any data that conflicts with directly specified points

RawLand = [Rum; Rlm; R_Forest; Rcountryside];

[COMMAND(K).XY] = [RMS_Processor_V2(RawLand,LPM_exp); create_player_lands];
K = K + 1;
end
%

%ObjectAutoscribeV6('ObjectDatabase.ods')

[List] = RMS_RS_V2(config,{'C'},COMMAND);
CODE = [Preface; List]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc