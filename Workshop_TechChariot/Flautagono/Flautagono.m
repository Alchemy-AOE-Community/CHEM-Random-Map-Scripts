%Flautagono Land Generation
%TechChariot
%5.28.22

clear all
close all
clc


tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

%off =  [45];           %Player Starting Offset Angle
%SA  =  [0];           %Player Starting Seed Angle
%b   =  [0.0];          %Player Starting team bias factor
%r   =  [10];           %Player Starting Group radius
%e   = 0.5; e = 2*e;    %Player Starting Eccentricity
%
%[create_player_lands] = RMS_CPL_V2({1},{'GRASS'},{0},off,SA,b,r,e);


%Outputs:
%P -- List of Points
%limits -- matrix with miniumum and maximum values of x and y values of P
%FORMAT: [xmin,ymin; xmax,ymax]





pkg load image
%f1 = [0.3];
f1 = [0.35];
L1 = 'C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts\_My_Workshop\Flautagono\Hexagon.jpg';
[M1] = ImagetoLands(f1,L1);

%f2 = [0.4];
f2 = [0.45];
[M2] = ImagetoLands(f2,L1);


%f3 = [0.4];
%f3 = [0.5];
%L2 = 'C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts\_My_Workshop\Help\Flautagono\Hexagon_Outline.jpg';
%[M3] = ImagetoLands(f3,L2);

MLA = []; %Initializing Manual Land Appendix
NL = 100;
for i = 1:NL
MLA =   [MLA; ];
end
%



O = [45]; 
%R = 38;
R = 30;
S = 15;
for i5 = 1:4

if i5 == 1
size_prefix = {'if P12'};
k = 1;
for j = 1:length(O)
  
PLI1 = LandScribeV5([{'NNRB'}],[{1}],{00 00},{O(j)},{'0*x'},{1},{0},[-S S]); 
PLI2 = LandScribeV5([{'NNRB'}],[{1}],{00 10},{O(j)},{'0*x'},{1},{0},[-2 2]); 
PLI3 = LandScribeV5([{'NNRB'}],[{1}],{00 20},{O(j)},{'0*x'},{1},{0},[-2 2]); 
PLI4 = LandScribeV5([{'NNRB'}],[{1}],{00 30},{O(j)},{'0*x'},{1},{0},[-2 2]); 

Structure(k).XY = [LandScribeV5([{'NNRB'}],[{0}],{50 50},{O(j)},{M1},{1}); LandScribeV5([{'WNI'}],[{0}],{50 50},{O(j)},{M2},{1})];
%Boundary(k).XY = LandScribeV5([{'WNI'}],[{0}],{50 50},{O(j)},{M3},{1});

%COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}]); RMS_Processor_Random_Coord(Boundary(k).XY,LPM_exp,1)];
COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}])];


k = k + 1;
end
%

elseif i5 == 2

size_prefix = {'elseif P34'};
k = 1;
for j = 1:length(O)
  
PLI1 = LandScribeV5([{'NNRB'}],[{1}],{00 00},{O(j)},{'0*x'},{1},{0},-25+[-S  S]); 
PLI2 = LandScribeV5([{'NNRB'}],[{1}],{00 00},{O(j)},{'0*x'},{1},{0}, 25+[-S  S]); 
    
Structure(k).XY = [LandScribeV5([{'NNRB'}],[{0}],{50+25*[cosd(045) sind(045)]},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{50+25*[cosd(045) sind(045)]},{O(j)},{M2},{1}); ...
                   LandScribeV5([{'NNRB'}],[{0}],{50+25*[cosd(225) sind(225)]},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{50+25*[cosd(225) sind(225)]},{O(j)},{M2},{1})];
                   
%Boundary (k).XY = [LandScribeV5([{'WNI'}],[{0}],{50+25*[cosd(045) sind(045)]},{O(j)},{M3},{1}); ...
%                   LandScribeV5([{'WNI'}],[{0}],{50+25*[cosd(225) sind(225)]},{O(j)},{M3},{1})];
                   
%COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}]); RMS_Processor_Random_Coord(Boundary(k).XY,LPM_exp,1)];
COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}])];
k = k + 1;
end
%


elseif i5 == 3
size_prefix = {'elseif P56'};
k = 1;
for j = 1:length(O)

c1 = ([42+R*cosd(000) 50+R*sind(000)]);
c2 = ([42+R*cosd(120) 50+R*sind(120)]);
c3 = ([42+R*cosd(240) 50+R*sind(240)]);

Y1 = (c1(:,1)-50)*sind(O(j))+(c1(:,2)-50)*cosd(O(j));
Y2 = (c2(:,1)-50)*sind(O(j))+(c2(:,2)-50)*cosd(O(j)); 
Y3 = (c3(:,1)-50)*sind(O(j))+(c3(:,2)-50)*cosd(O(j));

X1 = (c1(:,1)-50)*cosd(O(j))-(c1(:,2)-50)*sind(O(j));
X2 = (c2(:,1)-50)*cosd(O(j))-(c2(:,2)-50)*sind(O(j)); 
X3 = (c3(:,1)-50)*cosd(O(j))-(c3(:,2)-50)*sind(O(j));

PLI1 = LandScribeV5([{'NNRB'}],[{1}],{[00 -Y1]},{O(j)},{'0*x'},{1},{0},X1+[-S +S]); 
PLI2 = LandScribeV5([{'NNRB'}],[{1}],{[00 -Y2]},{O(j)},{'0*x'},{1},{0},X2+[-S +S]); 
PLI3 = LandScribeV5([{'NNRB'}],[{1}],{[00 -Y3]},{O(j)},{'0*x'},{1},{0},X3+[-S +S]);  
 
Structure(k).XY = [LandScribeV5([{'NNRB'}],[{0}],{c1},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{c1},{O(j)},{M2},{1}); ...
                   LandScribeV5([{'NNRB'}],[{0}],{c2},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{c2},{O(j)},{M2},{1}); ...         
                   LandScribeV5([{'NNRB'}],[{0}],{c3},{O(j)},{M1},{1}); ... 
                   LandScribeV5([{'WNI'}],[{0}],{c3},{O(j)},{M2},{1})];

%Boundary (k).XY = [LandScribeV5([{'WNI'}],[{0}],{c1},{O(j)},{M3},{1}); ...
%                   LandScribeV5([{'WNI'}],[{0}],{c2},{O(j)},{M3},{1}); ...
%                   LandScribeV5([{'WNI'}],[{0}],{c3},{O(j)},{M3},{1})];


                   
%COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}]); RMS_Processor_Random_Coord(Boundary(k).XY,LPM_exp,1)];
COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}])];
k = k + 1;
end
%

elseif i5 == 4
size_prefix = {'else'};
k = 1;
for j = 1:length(O)
  
c1 = [25 25];
c2 = [25 75];
c3 = [75 25];
c4 = [75 75];

Y1 = (c1(:,1)-50)*sind(O(j))+(c1(:,2)-50)*cosd(O(j));
Y2 = (c2(:,1)-50)*sind(O(j))+(c2(:,2)-50)*cosd(O(j)); 
Y3 = (c3(:,1)-50)*sind(O(j))+(c3(:,2)-50)*cosd(O(j));
Y4 = (c4(:,1)-50)*sind(O(j))+(c4(:,2)-50)*cosd(O(j));

X1 = (c1(:,1)-50)*cosd(O(j))-(c1(:,2)-50)*sind(O(j));
X2 = (c2(:,1)-50)*cosd(O(j))-(c2(:,2)-50)*sind(O(j)); 
X3 = (c3(:,1)-50)*cosd(O(j))-(c3(:,2)-50)*sind(O(j));  
X4 = (c4(:,1)-50)*cosd(O(j))-(c4(:,2)-50)*sind(O(j));  

PLI1 = LandScribeV5([{'NNRB'}],[{1}],{[00 -Y1]},{O(j)},{'0*x'},{1},{0},X1+[-S +S]); 
PLI2 = LandScribeV5([{'NNRB'}],[{1}],{[00 -Y2]},{O(j)},{'0*x'},{1},{0},X2+[-S +S]); 
PLI3 = LandScribeV5([{'NNRB'}],[{1}],{[00 -Y3]},{O(j)},{'0*x'},{1},{0},X3+[-S +S]); 
PLI4 = LandScribeV5([{'NNRB'}],[{1}],{[00 -Y4]},{O(j)},{'0*x'},{1},{0},X4+[-S +S]);  

Structure(k).XY = [LandScribeV5([{'NNRB'}],[{0}],{25 25},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{25 25},{O(j)},{M2},{1}); ...
                   LandScribeV5([{'NNRB'}],[{0}],{25 75},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{25 75},{O(j)},{M2},{1}); ...
                   LandScribeV5([{'NNRB'}],[{0}],{75 25},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{75 25},{O(j)},{M2},{1}); ...
                   LandScribeV5([{'NNRB'}],[{0}],{75 75},{O(j)},{M1},{1}); ...
                   LandScribeV5([{'WNI'}],[{0}],{75 75},{O(j)},{M2},{1})];
                   
%Boundary (k).XY = [LandScribeV5([{'WNI'}],[{0}],{25 25},{O(j)},{M3},{1}); ...
%                   LandScribeV5([{'WNI'}],[{0}],{25 75},{O(j)},{M3},{1}); ...
%                   LandScribeV5([{'WNI'}],[{0}],{75 25},{O(j)},{M3},{1}); ...
%                   LandScribeV5([{'WNI'}],[{0}],{75 75},{O(j)},{M3},{1})];                   
%                   
%                   
%COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}]); RMS_Processor_Random_Coord(Boundary(k).XY,LPM_exp,1)];
COMMAND(k).XY = [RMS_Processor_V4(Structure(k).XY,LPM_exp,[{PLI1} {PLI2} {PLI3} {PLI4}])];
k = k + 1;
end
%

end
%


if i5 == 1
[Size_List] = [size_prefix; RMS_RS_V3(O,{'C'},COMMAND)];
else
[Size_List] = [Size_List; size_prefix; RMS_RS_V3(O,{'C'},COMMAND)];
end
%


end
%
Size_List = [Size_List; {'endif'}];



%ObjectAutoscribeV8('ObjectDatabase.ods')
CODE = [Preface; Size_List; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc