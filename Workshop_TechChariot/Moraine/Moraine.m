%Moraine Land Generation
%TechChariot
%2.15.21

clear all
close all
clc

disp("Run Executed...")

%File Under Construction
filename = 'Moraine.rms';

%Terrain Painting -- Glacial Sand Deposit

terrain_type    = 'DLC_DESERTGRAVEL';
base_elevation  = 0;

thk = 2;
Angle = [225]';

for k = 1:22
y(k) = {@(x) -0.025*x.^2 - 16.5 + k};
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[-30 30],[-200 200]);
if k == 1
Sand_Deposit = STRUC(k).XY;
else
Sand_Deposit = [Sand_Deposit; STRUC(k).XY];
end
%
end
%
clear STRUC
%Terrain_Painting -- Bilateral Mountain Generation
terrain_type    = 'DIRT';
base_elevation  = [round(linspace(1,7,180))'; 7*ones(20,1)];
thk = 2;
Angle = [225]';

%Generating Bilateral Slopes
for k = 1:length(base_elevation)
y(k) = {@(x) 225*exp(-x.^2/100) + 0.423*(k-1)-34};
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation(k,1),Angle,thk,[-100 100],[-200 200]);
if k == 1
Slopes = STRUC(k).XY;
else
Slopes = [Slopes; STRUC(k).XY];
end
%
end
%
clear STRUC

%Generating Glacier
base_elevation  = 3;
thk = 2;
Angle = [225]';
terrain_type    = 'NNWB';
for k = 1:70
%
y(k) = {@(x) -100*cos(2*pi*x/150) + k + 102};
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[-12 12],[-1500 1500]);
if k == 1
Glacier = STRUC(k).XY;
else
Glacier = [Glacier; STRUC(k).XY];
end
end
%
clear STRUC

%Generating Meltpool
base_elevation  = 0;
thk = 1.5;
Angle = [225]';
terrain_type    = 'NNGB';
for k = 1:11
y(k) = {@(x) -100*cos(2*pi*x/200) + 0.5*k + 97.5};
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[-12 12],[-1500 1500]);
if k == 1
Meltpool = STRUC(k).XY;
else
Meltpool = [Meltpool; STRUC(k).XY];
end
end
%
clear STRUC

%Terrain Painting -- Drainage River
terrain_type    = 'NNGB';
base_elevation  = 0;
Angle = [135]';
thk = 3;

for k = 1:1
y(k) = {@(x) 0*x };
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[0 30],[-1500 1500]);
if k == 1
Drainage_River = STRUC(k).XY;
else
Drainage_River = [Drainage_River; STRUC(k).XY];
end
end
%

clear STRUC


%Terrain Painting -- Moraine Lake Island
terrain_type    = 'NNRB';
base_elevation  = 0;
Angle = [135]';
thk = 1;

for k = 1:1
y(k) = {@(x) 0*x };
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[32 32],[-1500 1500]);
if k == 1
Ice_Island = STRUC(k).XY;
else
Ice_Island = [Ice_Island; STRUC(k).XY];
end
end
%

clear STRUC

%Painting the Moraine
terrain_type    = 'DLC_CRACKED';
base_elevation  = 0;

Angle = [225]';
thk = [4];

for k = 1:29
y(k) = {@(x) -100*cos(2*pi*x/200) + 37.5 + 0.5*k};
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[-16 16]);
if k == 1
Moraine_Creation = STRUC(k).XY;
else
Moraine_Creation = [Drainage_River; STRUC(k).XY];
end
end
%

%Painting Seabed
terrain_type    = 'NNGB';
base_elevation  = 0;
Angle = [225]';
thk = 4;

for k = 1:50
y(k) = {@(x) -100*cos(2*pi*x/200) - k + 50};
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[-40 40]);
if k == 1
Beach = STRUC(k).XY;
else
Beach = [Beach; STRUC(k).XY];
end
end
%
clear STRUC

%Generating Glacial Lake
base_elevation  = 0;
thk = 12;
Angle = [225]';
terrain_type    = 'NNGB';
for k = 1:5
y(k) = {@(x) -100*cos(2*pi*x/200) + 7*k + 45};
STRUC(k).XY = LandScribeV4(y{k},terrain_type,base_elevation,Angle,thk,[-13 13],[-1500 1500]);
if k == 1
Glacial_Lake = STRUC(k).XY;
else
Glacial_Lake = [Glacial_Lake; STRUC(k).XY];
end
end
%
clear STRUC

SigMath = [{225} {0.25} {0.71} {[0 35]}]; %Signature Mathematical Parameters (necessary for any signature type) [Angular Orientation,Scale,Thickness,[x_center,y_center]]
SigScpt = [{'DIRT'} {3}];                 %Signature Map Parameters (necessary for positive space signature) [Terrain Type, Base Elevation]

COMMAND = [Moraine_Creation; Ice_Island; Drainage_River;  Meltpool; Glacier; Slopes; Beach; Sand_Deposit; Glacial_Lake]; % <-- MOST IMPORTANT TO LEAST IMPORTANT -->

%[CODE] = RMS_ForgeV3(filename,COMMAND,SigMath,SigScpt);
[CODE] = RMS_ForgeV3(filename,COMMAND,SigMath);
disp('All Done!!! :D')
