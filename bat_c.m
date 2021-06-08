%不同的参数
clear;
clc;
  Sigma=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.5,2,10,100];
 featureNums=5:5:60;

for exp_count=1:10
       for sigma=Sigma
       test(featureNums,exp_count,sigma);
      end 
        
end


