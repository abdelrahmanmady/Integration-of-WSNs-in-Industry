clc
clear all
close all

centerFrequencies=[3.25e9,3.75e9,4.25e9,4.75e9,5.25e9,5.75e9];
[CIR,freq]=uwbBandDividedRayTracing(centerFrequencies);
%%
plot(freq,abs(CIR))
title('Channel frequecy response');
xlabel('Frequency(Hz)');
ylabel('Magnitude |X(f)|');
grid on;
%%
viewer=siteviewer("SceneModel","industrial_env.stl");