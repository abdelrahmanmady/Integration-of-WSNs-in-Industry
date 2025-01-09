function [output1,output2]=uwbBandDividedRayTracing(centerFrequencies)
    %start frequency = 2 Ghz, Bandwidth = 2Ghz, frequency step = 500 MHz
    %sample frequencies = Bandwidth/frequencystep = 4 central frequencies
    %centerFrequncies=[2.25e9,2.75e9,3.25e9,3.75e9]
    output1=[];
    output2=[];
    for i=1:size(centerFrequencies,2)
        %create the ray tracing channel using the center frequency(i)
        tx = txsite("CoordinateSystem","cartesian", ...
            "AntennaPosition",[-17; -2.5; 3.5], ...
            'TransmitterFrequency',centerFrequencies(i),...
            'TransmitterPower',10);
        
        
        rx = rxsite("CoordinateSystem","cartesian", ...
            "AntennaPosition",[0; 0; 5]);
        
        
        
        pm = propagationModel("raytracing", ...
            "CoordinateSystem","cartesian", ...
            "Method","sbr", ...
            "AngularSeparation","low", ...
            "MaxNumReflections",3, ...
            "MaxNumDiffractions",1,...
            "SurfaceMaterial","metal");
        
        
        rays = raytrace(tx,rx,pm,"Map","industrial_env.stl");
        rays = rays{1,1};
        rtchan=comm.RayTracingChannel(rays,tx,rx);
        
        %construct gaussian impulse signal at the centerfrequency(i) and apply it to the
        %channel to get the recieved signal y.
        Ptx=10;
        c=3*10.^8;%lLight speed
        fc = centerFrequencies(i); % Actual Frequency of light [THz]
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


        % %filter the signal through the channel
        cir=rtchan();
        %transform the channel impulse response using fourier transform into frequency
        %domain
        cir=sum(cir,1)/size(cir,1);

        CIR=fft(cir,NFFT);

        %get the 500MHz part from the CIR
        temp=CIR(1:NFFT/2+1);
        temp=temp(find(freq>=centerFrequencies(i)-((500e6)/2) & freq<=centerFrequencies(i)+((500e6)/2)));
        output1=[output1 temp];
        temp=freq(freq>=centerFrequencies(i)-((500e6)/2) & freq<=centerFrequencies(i)+((500e6)/2));
        output2=[output2 temp];
            
    end

    

end