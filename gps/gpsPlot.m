clear all; close all; clc

noBase = csvread('gpsNoBase_time_lat_long_alt.csv');
wBase  = csvread('gpsWithBase_time_lat_long_alt.csv');

nTime = noBase(:,1);
nLat  = noBase(:,2);
nLong = noBase(:,3);
nAlt  = noBase(:,4);

wTime = wBase(:,1);
wLat  = wBase(:,2);
wLong = wBase(:,3);
wAlt  = wBase(:,4);

scatter3(nLat, nLong, nAlt, '.')
hold on
scatter3(wLat, wLong, wAlt, '.')


