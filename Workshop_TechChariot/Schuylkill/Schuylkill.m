%Schuylkill Land Generation
%ThorsChariot
%3.20.21

clear all
close all
clc

tic
disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
path = filestruc.folder; path = path(1:102); addpath(path) %Adding functions in main folder to the path
files = {filestruc.name}; [filename] = RMS_GetLatest(files,'rms');

%Terrain Painting --River
Span = [{1}];
Cent = [{0 0};];
Angle = [{0} {90} {180} {270}];
f = [{'50*sin(2*pi*x/22)'} {'50*sin(2*pi*x/29)'} {'50*sin(2*pi*x/40)'}];

[nSpan] = length(Span);
[nCent,~] = size(Cent);
[~,nAngl] = size(Angle);
[~,nfunc] = size(f);

%SigMath = [{270} {0.2} {0.71} {[0 0]}]; %Signature Mathematical Parameters (necessary for any signature type) [Angular Orientation,Scale,Thickness,[x_center,y_center]]
%SigScpt = [{'DIRT'} {3}];                 %Signature Map Parameters (necessary for positive space signature) [Terrain Type, Base Elevation]

k = 0;
for i4 = 1:nSpan
for i3 = 1:nCent
for i2 = 1:nAngl
for i1 = 1:nfunc
[Preface,LPM_exp,SigComb] = RMS_Manual_Land(filename);

fupper = {[char(f(i1)) '+95']};
flower = {[char(f(i1)) '-95']};

[Upper] = LandScribeV5([{'G'}],[{1}],Cent(i3,:),Angle(i2),fupper,{1},{1},[-50 50]);
[River] = LandScribeV5({'B'},{0},Cent(i3,:),Angle(i2),f(i1),{1},Span(i4),[-50 50]);
[Lower] = LandScribeV5([{'G'}],[{1}],Cent(i3,:),Angle(i2),flower,{1},{1},[-50 50]);

Subtractee = [Upper; Lower]; Subtractor = [River];
[Subtractee,LPM_exp] = adv_filter(Subtractee,Subtractor,LPM_exp);

k = k + 1;
RawLand(k).XY = [Subtractor; Subtractee];
COMMAND(k).XY = RMS_Processor_V4(RawLand(k).XY,LPM_exp);

end
end
end
end
%

[List] = RMS_RS_V2(f,Angle,{'C'},COMMAND);
CODE = [Preface; List]; %Adding Preface, Definitions, Random Statement to beginning of CODE
RMS_ForgeV4(filename,CODE);


%ObjectAutoscribeV8('ObjectDatabase.ods')

disp(["Run Completed " datestr(clock) "..."])
toc
