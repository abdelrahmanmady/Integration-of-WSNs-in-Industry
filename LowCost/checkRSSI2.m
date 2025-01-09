function [rssi] = checkRSSI(deployableLocation,targetPoint)
    tx = txsite("CoordinateSystem","cartesian", ...
        "AntennaPosition",targetPoint', ...
        'TransmitterFrequency',4.24e9,...
        'TransmitterPower',10);
    
    Rx=targetPoint';
    Rx(3)=Rx(3)+1;
    rx = rxsite("CoordinateSystem","cartesian", ...
        "AntennaPosition",Rx);
    
    
    
    pm = propagationModel("raytracing", ...
        "CoordinateSystem","cartesian", ...
        "Method","sbr", ...
        "AngularSeparation","low", ...
        "MaxNumReflections",3, ...
        "SurfaceMaterial","metal");
    
    
    
    %RSSI calculation
    Pr=sigstrength(rx,tx,pm,"Map","industrial_env.stl");
    Pr= Pr-30; % Convert to dbw
    PL0= tx.TransmitterPower-Pr;

    %Configure UWB Channel
    environmentType = "Industrial";
    LOS             = true;
    env = uwbChannelConfig(environmentType, LOS);
    env.ReferencePathLoss=PL0;


    %Construct Gaussian impulse signal centered at fc
    Ptx = 10; % Transmit power, in Watts
    lambda= 15/212;%Wavelength
    c=3*10.^8;%lLight speed
    fc = c/lambda; % Actual Frequency of light [THz]
    fsamp=fc*10; %sampling frequency
    fs=1/fsamp; %Unit Time in [fs]
    Ls=2048; %Length of signal
    sigma=lambda/1e+8;% Pulse duration
    ts=(0:Ls-1)*fs; %time base
    t0 = max(ts)/2; % Used to centering the pulse
    x = (exp(-2*log(2)*(ts-t0).^2/(sigma)^2)).*cos(-2*pi*fc*(ts-t0));
    x = x*sqrt(Ptx)/(sqrt(mean(x.^2)));

    %Apply distance dependance path loss to the signal
    d = euclideanDistance(deployableLocation,targetPoint); % distance between transmitter and receiver, in meters
    rxSignal = helperDistancePathLoss(x, env.ReferencePathLoss, d, env.PathLossExponent, env.ShadowingDeviation);
    
    %Apply frequency dependence path loss to the signal
    bw = 3e9;

    rxSignal = helperFrequencyPathLoss(rxSignal, fc, bw, env.FrequencyExponent);
    %Antenna Loss
    rxSignal = rxSignal * 10^(-env.AntennaLoss/20);

    %RSSI in dBm
    rssi=pow2db(rms(rxSignal)^2)+30;

    
end