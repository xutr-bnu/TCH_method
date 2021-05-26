clear all;clc;close all
data=xlsread('.\data.csv');
%std0: uncertainty
%xd_std0: relative uncertainty
[std0,xd_std0]=TCH_main(data);
