clc;
clear;

trainNumInClass1=200;%The number of samples selected in the source scene
trainNumInClass2=5;%The number of samples selected in the target scene

load('DataCube.mat');
DataCube1=double(DataCube1);
 gt2=double(gt2);
DataCube2=double(DataCube2);
 gt1=double(gt1);
for exp_count=1:10
   
    %source scene
    label1=gt1;
    [m,n]=size(label1);
    label1=label1(:);
    idx1=find(label1>0);                          %Remove invalid pixels
    label1=label1(idx1);                          
    label1_domain=ones(size(label1));             
    data1=reshape(DataCube1,size(DataCube1,1)*size(DataCube1,2),size(DataCube1,3));
    data1=data1(idx1,:);                          
    data1=bsxfun(@rdivide,data1,sqrt(sum(data1.^2,2)));     %Spectral Normalization
    
%    Training set and testing set in source scene
    classes=unique(label1);
    classNum=length(classes);
    
    trainIdx1=[];
    testIdx1=[];
    for i=1:1:classNum
        index1=find(label1==classes(i));
        t=randsample(index1,trainNumInClass1);
        trainIdx1=[trainIdx1;t];
        tt=setdiff(index1,t);
        testIdx1=[testIdx1;tt];
    end
    
    trainData1=data1(trainIdx1,:);
    testData1=data1(testIdx1,:);
    trainLabel1=label1(trainIdx1);
    testLabel1=label1(testIdx1);
    
    
    
    %target scene
    
    label2=gt2;
    [m,n]=size(label2);
    label2=label2(:);
    idx2=find(label2>0);                     %Remove invalid pixels               
    label2=label2(idx2);                                    
    label2_domain=ones(size(label2))*2;                     
    data2=reshape(DataCube2,size(DataCube2,1)*size(DataCube2,2),size(DataCube2,3));
    data2=data2(idx2,:);
    data2=bsxfun(@rdivide,data2,sqrt(sum(data2.^2,2)));     %Spectral Normalization

    %Training set and testing set in source scene
    classes2=unique(label2);
    classNum2=length(classes2);
      
    trainIdx2=[];
    testIdx2=[];
    for i=1:1:classNum2
        index2=find(label2==classes2(i));
        t2=randsample(index2,trainNumInClass2);
        trainIdx2=[trainIdx2;t2];
        tt2=setdiff(index2,t2);
        testIdx2=[testIdx2;tt2];
    end
    trainData2=data2(trainIdx2,:);
    testData2=data2(testIdx2,:);
    trainLabel2=label2(trainIdx2);
    testLabel2=label2(testIdx2);


     %Normalization
    mu1=mean(trainData1,1);
    s1=std(trainData1,0,1);
    trainData1=bsxfun(@rdivide,bsxfun(@minus,trainData1,mu1),s1+eps);
    
    mu2=mean(trainData2,1);
    s2=std(trainData2,0,1);
    trainData2=bsxfun(@rdivide,bsxfun(@minus,trainData2,mu2),s2+eps);
    testData2=bsxfun(@rdivide,bsxfun(@minus,testData2,mu2),s2+eps);

    save(fullfile('C:\Users\111\Desktop\CDIRF\data',sprintf('exp%d-sample.mat',exp_count)),'trainData1','testData1','trainLabel1', ...
        'testLabel1','trainData2','testData2','trainLabel2','testLabel2');  
end