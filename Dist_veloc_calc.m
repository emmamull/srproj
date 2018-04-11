%Calculates the total displacement of the the inital ROI and velocity
%inputs: 
%matrix_meanu, matrix_meanv, initframe,endframe

%perform distance formula
Cart_usum=0;
Cart_vsum=0;
for i= 1:length(Cart_meanu_vec)
Cart_usum=Cart_usum+Cart_meanu_vec(i);
Cart_vsum=Cart_vsum+Cart_meanv_vec(i);
end
%calculate distance
total_Cart_dist= ((Cart_usum)^(2)+(Cart_vsum)^(2))^(1/2);

%physical dist as defined a matrix box by wire test

%Avg-ed from 9 different points along the string, from 31-36 diameter
string_Cart_Diameter=32.88;
phys_string_diam=0.25;%in mm
physdist_toCartdist=phys_string_diam/string_Cart_Diameter;
%calculates the physical distance using the conversion factor from fishing
%wire
physicaldist=total_Cart_dist*physdist_toCartdist;
disp(["Cartisian distance: " total_Cart_dist]);
disp(["Physical distance in mm: " physicaldist]);


%Frames per second found in the .ult.txt file
frames_per_s=38; %Hz
s_per_frame=1/frames_per_s;
totaltime=(endframe-initframe)*s_per_frame; %in s
%{
totframe_num=len; %Calculated when opening the initial file
tot_time=len/38; %in secs
%}

phys_velocity=physicaldist/totaltime; %in mm/s
disp(["Physical velocity in mm/s: " phys_velocity]);
