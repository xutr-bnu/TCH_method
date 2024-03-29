%=======================Three-Cornered Hat (TCH) Method==============================
%Created by: Tongren Xu (xutr@bnu.edu.cn) and Xinlei He (hxlbsd@mail.bnu.edu.cn)
%Xu, T., Guo, Z., Xia, Y., et al. 2019. Evaluation of twelve evapotranspiration products from machine learning, remote sensing and land surface models over conterminous United States. Journal of Hydrology 578, 124105. https://doi.org/10.1016/j.jhydrol.2019.124105
%He, X., Xu, T., Xia, Y., et al. 2020. A Bayesian Three-Cornered Hat (BTCH) Method: Improving the Terrestrial Evapotranspiration Estimation. Remote Sensing 12, 878. https://doi.org/10.3390/rs12050878
%This program is used to calculate the relative uncertainty of gridded datasets
clear all;clc;close all

%Standard data is used to provide geographic coordinate system
ref_data=imread('.\ref_data.tif');
hs=size(ref_data,1);
ls=size(ref_data,2);
[W, R] = geotiffread('.\ref_data.tif');
info = geotiffinfo('.\ref_data.tif');

TCH_result1=zeros(hs,ls);
TCH_result2=zeros(hs,ls);
TCH_result3=zeros(hs,ls);
TCH_result4=zeros(hs,ls);
TCH_result5=zeros(hs,ls);
TCH_result1(find(TCH_result1==0))=NaN;
TCH_result2(find(TCH_result2==0))=NaN;
TCH_result3(find(TCH_result3==0))=NaN;
TCH_result4(find(TCH_result4==0))=NaN;
TCH_result5(find(TCH_result5==0))=NaN;

%Five gridded datasets is used to calculate the uncertainty
%More gridded datasets can be added
file_force1=dir('.\data1\*.tif');
file_force2=dir('.\data2\*.tif');
file_force3=dir('.\data3\*.tif');
file_force4=dir('.\data4\*.tif');
file_force5=dir('.\data5\*.tif');
data_len=length(file_force1);

for ii=1:data_len
    name1=strcat('.\data1\',file_force1(ii).name);
    name2=strcat('.\data2\',file_force2(ii).name);
    name3=strcat('.\data3\',file_force3(ii).name);
    name4=strcat('.\data4\',file_force4(ii).name);
    name5=strcat('.\data5\',file_force5(ii).name);
    force1=double(imread(name1));
    force2=double(imread(name2));
    force3=double(imread(name3));
    force4=double(imread(name4));
    force5=double(imread(name5));
    %force1(isnan(force1)) = 0;
    %force2(isnan(force2)) = 0;
    %force3(isnan(force3)) = 0;
    %force4(isnan(force4)) = 0;
    %force5(isnan(force5)) = 0;
    grid_data_1(:,:,ii)=force1;
    grid_data_2(:,:,ii)=force2;
    grid_data_3(:,:,ii)=force3;
    grid_data_4(:,:,ii)=force4;
    grid_data_5(:,:,ii)=force5;
end

for hh=1:hs
    hh
    for ll=1:ls
        x1=grid_data_1(hh,ll,:);
        x2=grid_data_2(hh,ll,:);
        x3=grid_data_3(hh,ll,:);
        x4=grid_data_4(hh,ll,:);
        x5=grid_data_5(hh,ll,:);
        x1=reshape(x1,data_len,1);
        x2=reshape(x2,data_len,1);
        x3=reshape(x3,data_len,1);
        x4=reshape(x4,data_len,1);
        x5=reshape(x5,data_len,1);
        if ~isnan(nanmean(x1))&&~isnan(nanmean(x2))&&~isnan(nanmean(x3))&&~isnan(nanmean(x4))&&~isnan(nanmean(x5))
            X=[x1 x2 x3 x4 x5];
            [std0,xd_std0]=TCH_main(X);
            %Uncertainty (Uncertainty is used to integrate multiple products)
            TCH_result1(hh,ll)=std0(1);TCH_result2(hh,ll)=std0(2);TCH_result3(hh,ll)=std0(3);TCH_result4(hh,ll)=std0(4);TCH_result5(hh,ll)=std0(5);
            %Relative uncertainty
            %TCH_result1(hh,ll)=xd_std0(1);TCH_result2(hh,ll)=xd_std0(2);TCH_result3(hh,ll)=xd_std0(3);TCH_result4(hh,ll)=xd_std0(4);TCH_result4(hh,ll)=xd_std0(5);
        end
    end
end

%Relative uncertainty results
filename1=strcat('.\','TCH_result_1','.tif');
geotiffwrite(filename1,TCH_result1,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
filename2=strcat('.\','TCH_result_2','.tif');
geotiffwrite(filename2,TCH_result2,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
filename3=strcat('.\','TCH_result_3','.tif');
geotiffwrite(filename3,TCH_result3,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
filename4=strcat('.\','TCH_result_4','.tif');
geotiffwrite(filename4,TCH_result4,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
filename5=strcat('.\','TCH_result_5','.tif');
geotiffwrite(filename5,TCH_result5,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
disp('successful!')
