clear all; close all; clc

%--------- IMPORTING DATA ----------------------------------------%

%DATA FROM TEST WITH SOME MOVEMENT
dataIMU     = csvread('1605kalmantest_imu1.csv', 1, 0);
timeIMU     = dataIMU(:,1);
fieldSupply = dataIMU(:,2);
fieldXGyro  = dataIMU(:,3);
fieldYGyro  = dataIMU(:,4);
fieldZGyro  = dataIMU(:,5);
fieldXAccl  = dataIMU(:,6);
fieldYAccl  = dataIMU(:,7);
fieldZAccl  = dataIMU(:,8);
fieldXMagn  = dataIMU(:,9);
fieldYMagn  = dataIMU(:,10);
fieldZMagn  = dataIMU(:,11);
fieldTemp   = dataIMU(:,12);
fieldADC    = dataIMU(:,13);

timeIMU = timeIMU*10e-10;        % time in seconds
timeIMU = timeIMU - timeIMU(1);  % time starting from zero

%DATA FROM SAME TEST, AFTER KALMANFILER
dataATT = csvread('1605kalmantest_att1.csv', 1 ,0);
timeATT      = dataATT(:,1);
fieldRoll    = dataATT(:,2);
fieldPitch   = dataATT(:,3);
fieldYaw     = dataATT(:,4);
fieldRolld   = dataATT(:,5);
fieldPitchd  = dataATT(:,6);
fieldYawd    = dataATT(:,7);
fieldRolldd  = dataATT(:,8);
fieldPitchdd = dataATT(:,9);
fieldYawdd   = dataATT(:,10);

timeATT = timeATT*10e-10;        % time in seconds
timeATT = timeATT - timeATT(1);  % time starting from zero




%DATA FROM STILL TEST (MINIMAL MOVEMENT)
dataStill    = csvread('2017-05-04_still_test_att.csv', 1 ,0);
timeStill    = dataStill(:,1);
stillRoll    = dataStill(:,2);
stillPitch   = dataStill(:,3);
stillYaw     = dataStill(:,4);
stillRolld   = dataStill(:,5);
stillPitchd  = dataStill(:,6);
stillYawd    = dataStill(:,7);
stillRolldd  = dataStill(:,8);
stillPitchdd = dataStill(:,9);
stillYawdd   = dataStill(:,10);

timeStill = timeStill*10e-10;          % time in seconds
timeStill = timeStill - timeStill(1);  % time starting from zero



%DATA FROM STILL TEST 2 (MINIMAL MOVEMENT - MORE RECENT)
dataNew    = csvread('imuYawNoise.csv', 1 ,0);
timeNew    = dataNew(:,1);
newRoll    = dataNew(:,2);
newPitch   = dataNew(:,3);
newYaw     = dataNew(:,4);
newRolld   = dataNew(:,5);
newPitchd  = dataNew(:,6);
newYawd    = dataNew(:,7);
newRolldd  = dataNew(:,8);
newPitchdd = dataNew(:,9);
newYawdd   = dataNew(:,10);

timeNew = timeNew*10e-10;          % time in seconds
timeNew = timeNew - timeNew(1);    % time starting from zero

%-----------------------------------------------------------------%
%-----------------------------------------------------------------%


%---filter to remove low frequencies form fiest test---%
Fstop = 1.5;
Fpass = 2;
Astop = 40;
Apass = 1;
Fs = 20;

d = designfilt( 'highpassfir', ...
                'StopbandFrequency',Fstop, ...
                'PassbandFrequency',Fpass, ...
                'StopbandAttenuation',Astop, ...
                'PassbandRipple',Apass, ...
                'SampleRate',Fs, ...
                'DesignMethod','equiripple');

%tool to see filter characteristics:
%fvtool(d)

%-------------------------------------------------------%


%---analyzing noise in first test----%

%t = 0:.05:85.8; %persumed time

%Sanity Check of Time Vector
%plot(t,fieldYaw)
%hold on
%plot(timeATT, fieldYaw)

%using filter on the data from the first test
%figure;
%dOut = filter(d, fieldYaw);
%plot(t,fieldYaw)
%hold on
%plot(t,dOut)

%isolating a part of the signal where the noise is consistant:
%whiteNoize = dOut(700:1200);

%plotting the psd of the signal
%figure;
%periodogram(whiteNoize,[],512,20,'power')
%read -40dB on diagram, calculating power of noise:
%db2pow(-40)



%---analyzing noise in second test----%

t2 = 0:.05:960.25; %persumed time

%Sanity Check of Time Vector
%figure
%plot(t2,stillYaw)
%hold on
%plot(timeStill, stillYaw)

%using filter on the data from the first test
%figure;
%dOut = filter(d, stillYaw);
%plot(t,stillYaw)
%hold on
%plot(t,dOut)

%isolating a part of the signal where the noise is consistant:
%whiteNoize = dOut(700:1200);

%figure
%plot(t2,stillYawd-mean(stillYawd))

noize = stillYawd(11840:15740);
noize = noize -mean(noize);
tnoize = t2(1:size(noize));
%figure
%plot(tnoize,noize)

%plotting the psd of the signal
%figure;
%periodogram(noize,[],512,20,'power')
%read -40dB on diagram, calculating power of noize:
%db2pow(-45)





%---analyzing noise in NEW test----%

t3 = 0:.05:270.15; %persumed time

%Sanity Check of Time Vector
%figure
%plot(t3,newYaw)
%hold on
%plot(timeNew, newYaw)


noise = newYaw -mean(newYaw);
%figure
%plot(t3,noise)


%plotting the psd of the signal
figure
[ Hreal Treal ]=periodogram(noise,[],10000,20,'power')
hold on
plot(Treal, pow2db(Hreal))
%plot(Treal, Hreal)

meanOfPow = mean(Hreal)

dbMean = mean(pow2db(Hreal))

%read -58dB on diagram, calculating power of noise:
powOfDbMean = db2pow(dbMean)

%noisePower = powOfDbMean
%noisePower = meanOfPow
%noisePower = ((powOfDbMean+meanOfPow)/2)
noisePower = db2pow(-66)
%noisePower = 4.147e-5
%noisePower = max(Hreal)

%amplitudes read in fft-plot + tuning
peak0amp = 0.0043080+0.0005;
peak1amp = 0.0087010+0.0002;
peak2amp = 0.0023260+0.001;
peak3amp = 0.0015270+0.00027;
peak4amp = 0.0010100+0.0002;
peak5amp = 0.0009673+0.00023;

%frequencies in hz read in fft-plot
peak0fq = 0.003701*2*pi;
peak1fq = 0.9919*2*pi;
peak2fq = 2.979*2*pi;
peak3fq = 4.978*2*pi;
peak4fq = 6.973*2*pi;
peak5fq = 8.96*2*pi;


%0.9919*2*pi   0.011464







sim('noiseGen.slx')

hold on
[ Hsim Tsim ] = periodogram(simout.Data,[],10000,20,'power');
plot(Tsim,pow2db(Hsim),'r')
%plot(Tsim,Hsim,'r')

mean(Hsim)

%comparing simulated noise with real noise
figure
plot(simout.Time,simout.Data)
hold on
scatter(simout.Time,simout.Data,'.')
plot(t3,noise)
scatter(t3,noise,'.')



t = simout.Time;
Fs = 20;
T = 1/Fs;             % Sampling period       
X = simout.Data;
L = length(X);             % Length of signal

Y = fft(X);

%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


f = Fs*(0:(L/2))/L;
figure
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of Simulated Noise')
xlabel('f (Hz)')
ylabel('|P1(f)|')



t = t3;
Fs = 20;
T = 1/Fs;             % Sampling period       
X = noise;
L = length(X);             % Length of signal

Y = fft(X);

%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


f = Fs*(0:(L/2))/L;
figure
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of Real Noise')
xlabel('f (Hz)')
ylabel('|P1(f)|')

