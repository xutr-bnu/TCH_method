% This function corresponds to the equation (9) of Ferreira et al. (2016)
% Ferreira, V.G., Montecino, H.D.C., Yakubu, C.I., Heck, B., 2016. Uncertainties of the Gravity Recovery and Climate Experiment time-variable gravity-field solutions based on three-cornered hat method. J. Appl. Remote Sens 10, 015015. https://doi.org/10.1117/1.JRS.10.015015
function [c,ceq] = mycon(r,S)
fr=[];
for i=1:length(S)
    u(i)=1;
end
for i=1:length(S)
    fr=[fr,r(i)];
end
c=-((r(length(S)+1)-(fr-r(length(S)+1).*u)*inv(S)*(fr-r(length(S)+1).*u)')/((det(S))^(1/length(S))));
ceq = [];
end