clc
clear all
close all
TR = stlread("conferenceroom.stl");

%factory walls
T = TR.ConnectivityList(39381:end,:) - 19692;

P(1,:) = [-20, -10, 0]; %1
P(2,:) = [20, -10, 0];  %2
P(3,:) = [-20, -10, 5]; %3
P(4,:) = [-20, 10, 0];  %4
P(5,:) = [20, 10, 0]; %5
P(6,:) = [20, -10, 5]; %6
P(7,:) = [-20, 10, 5]; %7
P(8,:) = [20, 10, 5]; %8

% metal objects
[P,T]=metalcolumn(P,T,[-15,-6],1,5);
[P,T]=metalcolumn(P,T,[-5,-6],1,5);
[P,T]=metalcolumn(P,T,[5,-6],1,5);
[P,T]=metalcolumn(P,T,[15,-6],1,5);

[P,T]=metalcolumn(P,T,[-15,5],1,5);
[P,T]=metalcolumn(P,T,[-5,5],1,5);
[P,T]=metalcolumn(P,T,[5,5],1,5);
[P,T]=metalcolumn(P,T,[15,5],1,5);

[P,T]=metalcolumn(P,T,[-20,-8],3,2.5);
[P,T]=metalcolumn(P,T,[-20,-4],3,2.5);
[P,T]=metalcolumn(P,T,[-20,2],3,2.5);
[P,T]=metalcolumn(P,T,[-20,6],3,2.5);


[P,T]=metalcolumn(P,T,[-13,-10],2.5,4);
[P,T]=metalcolumn(P,T,[-8,-10],2.5,4);
[P,T]=metalcolumn(P,T,[-4,-10],2.5,4);


[P,T]=metalcolumn(P,T,[-10,-3],5,1.5);
[P,T]=metalcolumn(P,T,[0,-3],5,1.5);
[P,T]=metalcolumn(P,T,[10,-3],5,1.5);

TR = triangulation(T,P);
stlwrite(TR,"industrial_env.stl")