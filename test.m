clc
clear all
close all

centerFrequncies=[3.25e9,3.75e9,4.25e9,4.75e9,5.25e9,5.75e9];

tx = txsite("CoordinateSystem","cartesian", ...
    "AntennaPosition",[-7.5; -0.5; 1.5], ...
    'TransmitterFrequency',centerFrequncies(6),...
    'TransmitterPower',10);


rx = rxsite("CoordinateSystem","cartesian", ...
    "AntennaPosition",[-12; 0; 3.5]);



pm = propagationModel("raytracing", ...
    "CoordinateSystem","cartesian", ...
    "Method","sbr", ...
    "AngularSeparation","low", ...
    "MaxNumReflections",2, ...
    "MaxNumDiffractions",1,...
    "SurfaceMaterial","metal");


rays = raytrace(tx,rx,pm,"Map","industrial_env.stl","Type","power");
rays = rays{1,1};
rtchan=comm.RayTracingChannel(rays,tx,rx);
%%
viewer=siteviewer("SceneModel","industrial_env.stl","ShowOrigin",false);
show(tx,"ShowAntennaHeight",false);
show(rx,"ShowAntennaHeight",false);
plot(rays,"Type","power");
%%
%construct gaussian impulse signal at the centerfrequency(i) and apply it to the
%channel to get the recieved signal y.
Ptx=10;
c=3*10.^8;%lLight speed
fc = centerFrequncies(6); % Actual Frequency of light [THz]
lambda= c/fc;%Wavelength
fsamp=fc*10; %sampling frequency
fs=1/fsamp; %Unit Time in [fs]
Ls=1e5; %Length of signal
sigma=lambda/1e+8;% Pulse duration
ts=(0:Ls-1)*fs; %time base
t0 = max(ts)/2; % Used to centering the pulse
x = (exp(-2*log(2)*(ts-t0).^2/(sigma)^2)).*cos(-2*pi*fc*(ts-t0));
x = x*sqrt(Ptx)/(sqrt(mean(x.^2)));
x=x';
% %transfer the signal x(t) to the Frequency domain X(f)
NFFT = 2^nextpow2(Ls);
freq = 0.5*fsamp*linspace(0,1,NFFT/2+1); % (full range) Frequency Vector
%%
%filter the signal through the channel
[~,cir]=rtchan(x);
%transform the channel impulse response using fourier transform into frequency
%domain
cir=sum(cir,1)/size(cir,1);
showProfile(rtchan);
CIR=fft(cir,NFFT);
figure
plot(freq,abs(CIR(1:size(freq,2))))
