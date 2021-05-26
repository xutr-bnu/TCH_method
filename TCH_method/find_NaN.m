function [x,result] = find_NaN(X)
Nan_len=find(X==-999);
if Nan_len~=0
    x=[];
    result=-999;
else
    x=X;
    result=0;
end
end