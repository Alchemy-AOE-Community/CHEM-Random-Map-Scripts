%SPC_08_Syzygy Land Generation
%TechChariot
%2024-11-17

clear all
close all
clc


tic

disp(["Run Executed " datestr(clock) "..."])
filestruc = dir; %Extract a structure of the files in this directory
PATH = filestruc.folder; fi = strfind(PATH,'\'); PATH  = PATH(1:fi(end-2));
addpath(genpath(PATH)) %Adding functions in main folder to the path

filename = [mfilename '.rms'];

[Preface,LPM_exp,~] = RMS_Manual_Land(filename);

d = @(x1,x2,y1,y2) sqrt((x1-x2).^2+(y1-y2).^2); %distance calculation (anonymous function)

MLP = [];

r = [13 20 24 28]; %Progressively Increasing Radial Size


L = linspace(5,95,4)'; %Linear Distribution of Planet Centers
L = flipud([L 50*ones(4,1)]);

cpl = [];
for PlayerNum = 1:8
  cpl = [ cpl;
                        {'L'};
                         {'{'};
                         {['terrain_type PT']}
                         {['number_of_tiles 0']};
                         {['assign_to_player ' num2str(PlayerNum)]};
                         {['other_zone_avoidance_distance 10']};
                         {'}'}];
end

##c  = [80 80;
##      61 61;
##      41 41;
##      25 25]; %Planet Centers

## looks like one of the .8 configurations is broken.
##o = [-45];
o = [-45 45 135 -135];
##f = [1, 0.8];
f = [1];
K = 1;


for i2 = 1:length(f)
  L(:,1) = f(i2)*(L(:,1) - 50) + 50;
##  L(:,1) = f(i2)*(L(:,1) - 50) + 50*f(i2);
  ## to improve: use a static list above, and create a new list for use down below. Simplifies computations,
for i1 = 1:length(o)


  [cx,cy] = SimpleRotate(L(:,1),L(:,2),o(i1),[50 50]); c = [cx cy];

  %% -- Planet Rims, Common Characteristics -- %%
  bsv = [1 1 1 1]; t = length(bsv);
  ntv = [0 0 0 14400];

  PR1.NT = ntv; PR2.NT = ntv; PR3.NT = ntv; PR4.NT = ntv; %Number of Tiles
  PR1.BS = bsv; PR2.BS = bsv; PR3.BS = bsv; PR4.BS = bsv; %Base Size
  PR1.SS = [3]; PR2.SS = [3]; PR3.SS = [3]; PR4.SS = [3]; %Size Scaling
  PR1.BE = [2]; PR2.BE = [2]; PR3.BE = [2]; PR4.BE = [2]; %Base Elevation
  PR1.TT = [{'PN1'}]; PR2.TT = [{'PN2'}]; PR3.TT = [{'PN3'}]; PR4.TT = [{'PN4'}]; %Terrain Type

  rr = r'*linspace(1,(1-0.05*t),t);

  nO = 360;
  O = linspace(0,360,nO);
  Ohd = (O(2) - O(1))/2; %Theta Half-Difference

  %% -- Planet Rim Coordinate Crunch -- %%


  for i = 1:nO
    PR1X(i,:) = rr(1,:).*cosd(O(i)+Ohd*[1:t])+c(1,1);
    PR1Y(i,:) = rr(1,:).*sind(O(i)+Ohd*[1:t])+c(1,2);
  end
    %

  k = 0;
  for i = 1:nO
    x = rr(2,:).*cosd(O(i)+Ohd*[1:t])+c(2,1);
    y = rr(2,:).*sind(O(i)+Ohd*[1:t])+c(2,2);
    if any(d(x,c(1,1),y,c(1,2)) <= 1*rr(1))
    else
      k += 1;
      PR2X(k,:) = x;
      PR2Y(k,:) = y;
    end
    %
  end
  %
  clear x y

  k = 0;
  for i = 1:nO
    x = rr(3,:).*cosd(O(i)+Ohd*[1:t])+c(3,1);
    y = rr(3,:).*sind(O(i)+Ohd*[1:t])+c(3,2);
    if any(d(x,c(2,1),y,c(2,2)) <= 1*rr(2))
    else
      k += 1;
      PR3X(k,:) = x;
      PR3Y(k,:) = y;
    end
    %
  end
  %
  clear x y

  k = 0;
  for i = 1:nO
    x = rr(4,:).*cosd(O(i)+Ohd*[1:t])+c(4,1);
    y = rr(4,:).*sind(O(i)+Ohd*[1:t])+c(4,2);
    if any(d(x,c(3,1),y,c(3,2)) <= 1*rr(3))
    else
      k += 1;
      PR4X(k,:) = x;
      PR4Y(k,:) = y;
    end
    %
  end
  %
  clear x y

  PR1.X = PR1X; PR1.Y = PR1Y;
  PR2.X = PR2X; PR2.Y = PR2Y;
  PR3.X = PR3X; PR3.Y = PR3Y;
  PR4.X = PR4X; PR4.Y = PR4Y;

  %% -- Matrix Conversion, Planet Rims -- %%
  [LM_PR1,PR1] = LandScribeV6(PR1,[1 1]);
  [LM_PR2,PR2] = LandScribeV6(PR2,[1 1]);
  [LM_PR3,PR3] = LandScribeV6(PR3,[1 1]);
  [LM_PR4,PR4] = LandScribeV6(PR4,[1 1]);


  %% -- Player Land Construction -- %%
  BE = 0; BS = 1;
##  [cpl] = RMS_CPL_V10([{48}; {45}; {180}; {o(i1)}; {0.5}],[{BE}; {BS}]); %Player Land Declaration


##  COMMAND(K).XY = [RMS_Processor_V6([LM_PR4; LM_PR3; LM_PR2; LM_PR1])];
  COMMAND(K).XY = [RMS_Processor_V6([LM_PR4; LM_PR3; LM_PR2; LM_PR1]); cpl]; ## appears to apend cpl
  K += 1;
  clear PR1 PR2 PR3 PR4



##    create_player_lands = [{'L'};
##                         {'{'};
##                         {['terrain_type PT' num2str(j)]}
##                         {['base_size ' num2str(BS)]};
##                         {['base_elevation ' num2str(BE)]};
##                         {['number_of_tiles ' num2str(NT)]};
##                         {'clumping_factor 30'};
##                         {['other_zone_avoidance_distance ' num2str(ZA(j,2))]};
##                         {['zone ' num2str(ZA(j,1))]};
##                         {border_string};
##                         team_logical_V3(j);
##                         {'if P2'};
##                         LPC2;
##                         {'elseif P4'};
##                         LPC4;
##                         {'elseif P6'};
##                         LPC6;
##                         {'else'};
##                         LPC8;
##                         {'endif'};
##                         {'}'}];
end
end
%

[DynamicList] = RMS_RS_V3(o,f,{'C'},COMMAND);
##DynamicList = [];

##StaticList = [RMS_Processor_V6([LM_MT1; LM_MT2])];
StaticList = [];









MLA = [];

CODE = [Preface; MLP; StaticList; DynamicList; MLA]; %Adding Preface, Definitions, Random Statement to beginning of CODE

RMS_ForgeV4(filename,CODE);

disp(["Run Completed " datestr(clock) "..."])
toc

%ObjectAutoscribeV10('SPC_08_Syzygy.ods')
