% This function corresponds to the equation £¨8£© of Ferreira et al. (2016)
% Ferreira, V.G., Montecino, H.D.C., Yakubu, C.I., Heck, B., 2016. Uncertainties of the Gravity Recovery and Climate Experiment time-variable gravity-field solutions based on three-cornered hat method. J. Appl. Remote Sens 10, 015015. https://doi.org/10.1117/1.JRS.10.015015
function F = myfun(r,S)
f=0;
for j=1:length(S)
    f =f+r(j)^(2);
    for k=1:length(S)
        if j<k
            f = (S(j,k)-r(length(S)+1)+r(j)+r(k))^(2)+f;
        end
    end
end
F=f/(det(S))^(2/length(S));
end