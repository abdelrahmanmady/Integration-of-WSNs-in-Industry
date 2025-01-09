function [output] = checkLOS(deployableLocation,targetPoint)
    tx = txsite("CoordinateSystem","cartesian", ...
    "AntennaPosition",targetPoint.', ...
    'TransmitterFrequency',3.25e9);


    rx = rxsite("CoordinateSystem","cartesian", ...
        "AntennaPosition",deployableLocation.');

    output = los(tx,rx,"Map","industrial_env.stl");
    
end