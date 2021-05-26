% Ferreira, V.G., Montecino, H.D.C., Yakubu, C.I., Heck, B., 2016. Uncertainties of the Gravity Recovery and Climate Experiment time-variable gravity-field solutions based on three-cornered hat method. J. Appl. Remote Sens 10, 015015. https://doi.org/10.1117/1.JRS.10.015015
function [std,xd_std] = TCH_main(X)
R=[];
%X=[x1 x2 x3 x4];
%X is the data matrix with N rows and M columns (M is the total number of time samples in each product).
[M,N]=size(X);
%Reference data
ture_num=N;
Y=[];
for i=1:N
    if i~=ture_num
        y=X(:,i)-X(:,ture_num);
        Y=[Y,y];
    end
end
S = cov(Y);
u=[];
for i=1:N-1
    u(i)=1;
end
%Set the initial conditions of the iteration
for i=1:length(S)
    R(i,N)=0;
end
R(N,N) = (2*u*inv(S)*u')^-1;    %inv(): Inverse matrix
x0 = R(:,N);
%According to the initial conditions, constraint conditions, and objective function of the iteration, R(:,N) is calculated
opts = optimset('Algorithm','active-set','TolX',2e-10,'TolCon',2e-10,'Display','off');
x= fmincon(@(r) myfun(r,S),x0,[],[],[],[],[],[],@(r) mycon(r,S),opts);
%Using the relationship between S and R and the R(:,N) solved in the previous step, find the remaining unknowns in the R matrix
for i=1:N
    R(i,N) = x(i);
end
for i=1:length(S)
    for j=1:length(S)
        if i<j | i==j
            R(i,j)= S(i,j)-R(N,N) +R(i,N)+R(j,N);
        end
    end
end
for i=1:length(S)+1
    for j=1:length(S)+1
        R(j,i)=R(i,j);
    end
end
std=[];
for i=1:N
    st=sqrt(R(i,i));
    std=[std st];
end
xd_std=[];
for i=1:N
    xd_st=(sqrt(R(i,i))/mean(abs(X(:,i))))*100;
    xd_std=[xd_std xd_st];
end
end
